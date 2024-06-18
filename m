Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5705672;
	Tue, 18 Jun 2024 00:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671578; cv=none; b=nMwTh6QMgNBrDJ5aiARDIRvEXyPfSdAYwGUH6L7e72+mctbLYMb/fQjISy1zJu6MhBe59dRJz/asptXJWe9VIfPZMFNHX8ah/FAoolOIcdyGrF1DEqf8+okYKxqVg6PiqqxjlmaOeZ+tIhvkGZwmPMrEZF+gzzuVAQN2BdNd6UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671578; c=relaxed/simple;
	bh=5AH3uPu/AhEtr1OTK8SNQDfYAV8krPzgw2qaIMNe3mw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=TJJfXGGpwUWwQxU/SQvstX1yl+NmGDKuQDMr/+eIje0P+9BcAJrYccmP8NiV+eOSZcV7rIrOE94L2Vx/gx5u4heb7Dia0rtOwiAMSlufapsAg5medCywVZuuCC8zWh5BPpFmDE9tec4DFM9V85WARC4pMgCRy99NG9drVG44wqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubApex0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubApex0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F61C2BD10;
	Tue, 18 Jun 2024 00:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671577;
	bh=5AH3uPu/AhEtr1OTK8SNQDfYAV8krPzgw2qaIMNe3mw=;
	h=Date:Subject:From:To:Cc:From;
	b=ubApex0z046NJPuyOPzW4YyMUdlEtCwhKLUpeXHfZ3+2GEk8KAwv2rHmNrNzJyVlc
	 SCIwB6LEWbIF2LQvPFkNoh7ra5NBbNUBJMQb2m4Tsa9vijjtQ9AmiXZhaK5o5Va/oc
	 Q3R7LFVGDbDYb2JW5lGskRncUGnLEuGAncHwcDAHa90u35hx3aTpjkLWXoQmqCqW3v
	 8FLCZ0wNIBNcdmLns2Fkv0azIxQbs7aU1PNE0mueXsBfY+In4jxe+pIryRn1/ZiLxP
	 GNyvqEg7zwh8ILTpMO5IUoT+EtND+ojJh0FIV8XwdDejLhjf833kRf0n5vu16qjYPz
	 PqIiS35lMBqiw==
Date: Mon, 17 Jun 2024 17:46:17 -0700
Subject: [PATCHSET v30.6 2/6] fstests: atomic file updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
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
 * generic/710: repurpose this for exchangerange vs. quota testing
 * generic/717: remove obsolete check
 * ltp/{fsstress,fsx}: make the exchangerange naming consistent
 * misc: flip HAVE_XFS_IOC_EXCHANGE_RANGE logic
 * src/fiexchange.h: update XFS_IOC_EXCHANGE_RANGE definitions
 * xfs/122: fix for exchrange conversion
 * xfs/206: screen out exchange-range from golden output
 * swapext: make sure that we don't swap unwritten extents unless they're part of a rt extent(??)
---
 common/rc             |    2 
 common/xfs            |    2 
 configure.ac          |    2 
 include/builddefs.in  |    2 
 ltp/Makefile          |    4 -
 ltp/fsstress.c        |   34 +++----
 ltp/fsx.c             |   43 +++------
 m4/package_xfslibs.m4 |   15 ++-
 src/Makefile          |    4 -
 src/fiexchange.h      |   84 ++++--------------
 src/global.h          |   12 ++-
 src/vfs/Makefile      |    4 -
 src/xfsfind.c         |    1 
 tests/generic/709     |    2 
 tests/generic/710     |   14 +--
 tests/generic/710.out |    2 
 tests/generic/711     |    2 
 tests/generic/712     |   10 +-
 tests/generic/713     |   42 ++++-----
 tests/generic/713.out |   38 ++++----
 tests/generic/714     |   40 ++++----
 tests/generic/714.out |   34 ++++---
 tests/generic/715     |   26 +++--
 tests/generic/715.out |   14 +--
 tests/generic/716     |    4 -
 tests/generic/717     |   39 ++++----
 tests/generic/717.out |   32 +++----
 tests/generic/718     |   12 +--
 tests/generic/718.out |    2 
 tests/generic/719     |    4 -
 tests/generic/720     |   10 +-
 tests/generic/721     |    2 
 tests/generic/722     |    8 +-
 tests/generic/723     |   12 +--
 tests/generic/724     |   10 +-
 tests/generic/725     |    4 -
 tests/generic/726     |    4 -
 tests/generic/727     |    4 -
 tests/xfs/1213        |   73 +++++++++++++++
 tests/xfs/1213.out    |    2 
 tests/xfs/1214        |  232 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1214.out    |    2 
 tests/xfs/122.out     |    6 +
 tests/xfs/206         |    1 
 tests/xfs/300         |    2 
 tests/xfs/443         |    4 -
 tests/xfs/789         |    2 
 tests/xfs/790         |   10 +-
 tests/xfs/790.out     |    2 
 tests/xfs/791         |   10 +-
 tests/xfs/791.out     |    2 
 tests/xfs/792         |    4 -
 tests/xfs/795         |    2 
 53 files changed, 592 insertions(+), 342 deletions(-)
 create mode 100755 tests/xfs/1213
 create mode 100644 tests/xfs/1213.out
 create mode 100755 tests/xfs/1214
 create mode 100644 tests/xfs/1214.out

