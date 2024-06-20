Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D7E2BAF3;
	Thu, 20 Jun 2024 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916766; cv=none; b=sD5kabgfCVLqp1tMLS9QFakdZBCyfnU/M8IkHV9tdW1dixxVYPIhKm7Ww9ntgVE4tuq3bS7K12rBGDhqwfpKC7BcFLhCWotlOtDOvm2ZZJZ28vxksAEYMvy1UfwJCUhKuwE74ong/AQBhDv8zo63wDd94jMv/TtQZCZwvfxnNHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916766; c=relaxed/simple;
	bh=MuvWHe6OEO+lg+sJwo05GpEuAV4k50LRxR3fr63a2q4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlGonriJ8ohvkX9SdoDTCKuhe4vhhfoW9wMN1DO1NuJszTzZE+DT09f8wLbSMDwAGbOu2NKp8zVXAFerzCFR5pImQ3/Xn1rncUhdOwrRP52NWuJE4NDO4x5UiWDxdZfKW+4DeWtp5CyoRJUU101BbpWcxIzD998Zpp+9Bvo1NGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKUxl1sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKUxl1sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E88C2BD10;
	Thu, 20 Jun 2024 20:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916765;
	bh=MuvWHe6OEO+lg+sJwo05GpEuAV4k50LRxR3fr63a2q4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WKUxl1sHmVN6bWahcAZ2D9xEdj0gJf6phegUyrh0ECZ7eQWspY+q2k4AbbN+b/FyM
	 oD6XfYuAZD80iyLQiIdewUoWJew4YoPq5mDUXqWhuLs8AWhjfiO0+AFjtYkACiDX+u
	 E8lsuOWQ6NISfG8Y10YuefIKPLbirJbVJkO94jvrwKT2CEq4EIz7K+vnpZXy/FePv8
	 5KUpegN0iFjNcwty9Dv/AHu8Q4Gr4miTPSzxvid6PPC2WSUo182MN6xMAP4jT8XH37
	 t5xKBucx08U57ArznqvYO75Gn2mQy55mVoSUSJeLzgmDGAN/pcvIUywdeXG+zI7GK2
	 253TEtbqL/r0w==
Date: Thu, 20 Jun 2024 13:52:45 -0700
Subject: [PATCHSET v30.7 2/6] fstests: atomic file updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
In-Reply-To: <20240620205017.GC103020@frogsfrogsfrogs>
References: <20240620205017.GC103020@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series creates a new XFS_IOC_EXCHANGE_RANGE ioctl to exchange
ranges of bytes between two files atomically.

This new functionality enables data storage programs to stage and commit
file updates such that reader programs will see either the old contents
or the new contents in their entirety, with no chance of torn writes.  A
successful call completion guarantees that the new contents will be seen
even if the system fails.

The ability to exchange file fork mappings between files in this manner
is critical to supporting online filesystem repair, which is built upon
the strategy of constructing a clean copy of a damaged structure and
committing the new structure into the metadata file atomically.  The
ioctls exist to facilitate testing of the new functionality and to
enable future application program designs.

User programs will be able to update files atomically by opening an
O_TMPFILE, reflinking the source file to it, making whatever updates
they want to make, and exchange the relevant ranges of the temp file
with the original file.  If the updates are aligned with the file block
size, a new (since v2) flag provides for exchanging only the written
areas.  Note that application software must quiesce writes to the file
while it stages an atomic update.  This will be addressed by a
subsequent series.

This mechanism solves the clunkiness of two existing atomic file update
mechanisms: for O_TRUNC + rewrite, this eliminates the brief period
where other programs can see an empty file.  For create tempfile +
rename, the need to copy file attributes and extended attributes for
each file update is eliminated.

However, this method introduces its own awkwardness -- any program
initiating an exchange now needs to have a way to signal to other
programs that the file contents have changed.  For file access mediated
via read and write, fanotify or inotify are probably sufficient.  For
mmaped files, that may not be fast enough.

The reference implementation in XFS creates a new log incompat feature
and log intent items to track high level progress of swapping ranges of
two files and finish interrupted work if the system goes down.  Sample
code can be found in the corresponding changes to xfs_io to exercise the
use case mentioned above.

Note that this function is /not/ the O_DIRECT atomic untorn file writes
concept that has also been floating around for years.  It is also not
the RWF_ATOMIC patchset that has been shared.  This RFC is constructed
entirely in software, which means that there are no limitations other
than the general filesystem limits.

As a side note, the original motivation behind the kernel functionality
is online repair of file-based metadata.  The atomic file content
exchange is implemented as an atomic exchange of file fork mappings,
which means that we can implement online reconstruction of extended
attributes and directories by building a new one in another inode and
exchanging the contents.

Subsequent patchsets adapt the online filesystem repair code to use
atomic file exchanges.  This enables repair functions to construct a
clean copy of a directory, xattr information, symbolic links, realtime
bitmaps, and realtime summary information in a temporary inode.  If this
completes successfully, the new contents can be committed atomically
into the inode being repaired.  This is essential to avoid making
corruption problems worse if the system goes down in the middle of
running repair.

For userspace, this series also includes the userspace pieces needed to
test the new functionality, and a sample implementation of atomic file
updates.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-updates

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-file-updates

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=atomic-file-updates

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=atomic-file-updates
---
Commits in this patchset:
 * misc: split swapext and exchangerange
 * misc: change xfs_io -c swapext to exchangerange
 * generic/709,710: rework these for exchangerange vs. quota testing
 * generic/711,xfs/537: actually fork these tests for exchange-range
 * generic/717: remove obsolete check
 * ltp/{fsstress,fsx}: make the exchangerange naming consistent
 * misc: flip HAVE_XFS_IOC_EXCHANGE_RANGE logic
 * src/fiexchange.h: update XFS_IOC_EXCHANGE_RANGE definitions
 * xfs/122: fix for exchrange conversion
 * xfs/206: screen out exchange-range from golden output
 * exchangerange: make sure that we don't swap unwritten extents unless they're part of a rt extent
---
 common/rc              |    2 
 common/xfs             |    2 
 configure.ac           |    2 
 include/builddefs.in   |    2 
 ltp/Makefile           |    4 -
 ltp/fsstress.c         |   34 +++----
 ltp/fsx.c              |   43 +++------
 m4/package_xfslibs.m4  |   15 ++-
 src/Makefile           |    4 -
 src/fiexchange.h       |   84 ++++-------------
 src/global.h           |   12 ++
 src/vfs/Makefile       |    4 -
 src/xfsfind.c          |    1 
 tests/generic/1221     |   45 +++++++++
 tests/generic/1221.out |    2 
 tests/generic/709      |   12 +-
 tests/generic/710      |   14 +--
 tests/generic/710.out  |    2 
 tests/generic/711      |    4 -
 tests/generic/712      |   10 +-
 tests/generic/713      |   42 ++++-----
 tests/generic/713.out  |   38 ++++----
 tests/generic/714      |   40 ++++----
 tests/generic/714.out  |   34 ++++---
 tests/generic/715      |   26 +++--
 tests/generic/715.out  |   14 +--
 tests/generic/716      |    4 -
 tests/generic/717      |   39 ++++----
 tests/generic/717.out  |   32 +++----
 tests/generic/718      |   12 +-
 tests/generic/718.out  |    2 
 tests/generic/719      |    4 -
 tests/generic/720      |   10 +-
 tests/generic/721      |    2 
 tests/generic/722      |    8 +-
 tests/generic/723      |   12 +-
 tests/generic/724      |   10 +-
 tests/generic/725      |    4 -
 tests/generic/726      |    4 -
 tests/generic/727      |    4 -
 tests/xfs/1213         |   73 +++++++++++++++
 tests/xfs/1213.out     |    2 
 tests/xfs/1214         |  232 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1214.out     |    2 
 tests/xfs/1215         |   89 ++++++++++++++++++
 tests/xfs/1215.out     |   13 +++
 tests/xfs/122.out      |    6 +
 tests/xfs/206          |    1 
 tests/xfs/300          |    2 
 tests/xfs/443          |    4 -
 tests/xfs/789          |    4 -
 tests/xfs/790          |   10 +-
 tests/xfs/790.out      |    2 
 tests/xfs/791          |   10 +-
 tests/xfs/791.out      |    2 
 tests/xfs/792          |    4 -
 tests/xfs/795          |    2 
 57 files changed, 748 insertions(+), 349 deletions(-)
 create mode 100755 tests/generic/1221
 create mode 100644 tests/generic/1221.out
 create mode 100755 tests/xfs/1213
 create mode 100644 tests/xfs/1213.out
 create mode 100755 tests/xfs/1214
 create mode 100644 tests/xfs/1214.out
 create mode 100755 tests/xfs/1215
 create mode 100644 tests/xfs/1215.out

