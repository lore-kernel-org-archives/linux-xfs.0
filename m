Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF931C8C8;
	Sun, 31 Dec 2023 19:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rm/bmEDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A04CC433C8;
	Sun, 31 Dec 2023 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052676;
	bh=4uHo/II/EKvASf7c1U8oJNgc4NqJrf5piaNedGJS7PI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rm/bmEDc/T3FzLSW/Gz8yBODYSGUwRHUdTYAwzc6fvEyKT0/BiMWHoz2hS4Y8phS6
	 Lds3ruIeaPoMumsGO7tJIYrBFt+POHnPhW7JSq0z1F9t84LcuI+ULdoPXCenKa9F2A
	 CaCwcj/yOjH96azlg0Ra1BJ7Rl/6ejym6voioJiRXi4Ln2XKSUUfULOj9+ThAuQ6eM
	 vSAFJjfP4FqRl2O+XwLY0TGXJQGKB8YO6RVmDRpoZxbZ9UI8SeeR+iJI2H8SYUPvBU
	 KfqNvLF/mkPDlpS0MSDuju99ZZEyMBdfnS/0+oQg0IUyaW+a9aJqTO+BcpgJ0zLMST
	 xgJeOZGW6GOsg==
Date: Sun, 31 Dec 2023 11:57:56 -0800
Subject: [PATCHSET v29.0 4/8] fstests: atomic file updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405026593.1823789.14190079314297200957.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

This series creates a new FIEXCHANGE_RANGE system call to exchange
ranges of bytes between two files atomically.  This new functionality
enables data storage programs to stage and commit file updates such that
reader programs will see either the old contents or the new contents in
their entirety, with no chance of torn writes.  A successful call
completion guarantees that the new contents will be seen even if the
system fails.

The ability to swap extent mappings between files in this manner is
critical to supporting online filesystem repair, which is built upon the
strategy of constructing a clean copy of a damaged structure and
committing the new structure into the metadata file atomically.

User programs will be able to update files atomically by opening an
O_TMPFILE, reflinking the source file to it, making whatever updates
they want to make, and exchange the relevant ranges of the temp file
with the original file.  If the updates are aligned with the file block
size, a new (since v2) flag provides for exchanging only the written
areas.  Callers can arrange for the update to be rejected if the
original file has been changed.

The intent behind this new userspace functionality is to enable atomic
rewrites of arbitrary parts of individual files.  For years, application
programmers wanting to ensure the atomicity of a file update had to
write the changes to a new file in the same directory, fsync the new
file, rename the new file on top of the old filename, and then fsync the
directory.  People get it wrong all the time, and $fs hacks abound.

The reference implementation in XFS creates a new log incompat feature
and log intent items to track high level progress of swapping ranges of
two files and finish interrupted work if the system goes down.  Sample
code can be found in the corresponding changes to xfs_io to exercise the
use case mentioned above.

Note that this function is /not/ the O_DIRECT atomic file writes concept
that has also been floating around for years.  It is also not the
RWF_ATOMIC patchset that has been shared.  This RFC is constructed
entirely in software, which means that there are no limitations other
than the general filesystem limits.

As a side note, the original motivation behind the kernel functionality
is online repair of file-based metadata.  The atomic file swap is
implemented as an atomic inode fork swap, which means that we can
implement online reconstruction of extended attributes and directories
by building a new one in another inode and atomically swap the contents.

Subsequent patchsets adapt the online filesystem repair code to use
atomic extent swapping.  This enables repair functions to construct a
clean copy of a directory, xattr information, symbolic links, realtime
bitmaps, and realtime summary information in a temporary inode.  If this
completes successfully, the new contents can be swapped atomically into
the inode being repaired.  This is essential to avoid making corruption
problems worse if the system goes down in the middle of running repair.

This patchset also ports the old XFS extent swap ioctl interface to use
the new extent swap code.

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
 tests/xfs/1213     |   73 ++++++++++++++++
 tests/xfs/1213.out |    2 
 tests/xfs/1214     |  232 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1214.out |    2 
 4 files changed, 309 insertions(+)
 create mode 100755 tests/xfs/1213
 create mode 100644 tests/xfs/1213.out
 create mode 100755 tests/xfs/1214
 create mode 100644 tests/xfs/1214.out

