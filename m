Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703DB1361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298635; cv=none; b=eCFah1Jre6GNlwxq6yPsnrNCjq44Opw+rdubkz03L5mRp4GG1rYTVwQmNIJWElU3OuETUeSXX7HWY7PycBgPuw3ij1qRP9KsGDmd6fbonB6e34/Kpt0J88i2CTZ+HG7eixb0hQUXwz9ISC5xZIpgx/RqwJV5lGvhH78ThWkeg4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298635; c=relaxed/simple;
	bh=1gkhsOneM7bP3i6oxYLhhCWtTHvJY0TVQb7CiMI30e8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JofLwXkNsl7svrsxNJzte0wl9z6bA1EL5ILEp5jQWkT3s8N5v+V+NA/G7V9Yk66oCmGQrqEv8jOrvLFvOjIgrn5NBRrpdQwTxe2qNsdQVvBfU7NjEI63hbfQ4SbJ02Z0RQOoUZwxgng4uqu3e4EkO1oiPNhOmlDay+DL30MGxkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqKfM3yP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqKfM3yP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75E4C32786;
	Tue, 30 Jul 2024 00:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298635;
	bh=1gkhsOneM7bP3i6oxYLhhCWtTHvJY0TVQb7CiMI30e8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hqKfM3yPjRR2voyw9CEhjIltWpsEtIZKD8BD8lrvVRqk0/QpNXrYXL8M2RIInlgNd
	 UdM1I9CwMWB98Jixv7ZYdm3++86poubj9yLGIPMQdmpdJisx2czs19Kgba9NbZWxbk
	 t+C62VxKnsXRaBmH9f+YKK3r/mog73egBpWPX44phfUXbxgBhjIMPoVswyMlxOZgTI
	 ZxhCUyFj5Fsjif7km2ZcXyBplqSGMCR/ewMroCbfe4Cylcndv1K1EEamX2XgdkkcOs
	 fWbB8QRu1dKxGEAR/HQ3t5BaJaMA11DQEERZ+hbM9Ky1s7AlDzTa5+MoxVJ5T5PQMg
	 wrNnZESpY236A==
Date: Mon, 29 Jul 2024 17:17:14 -0700
Subject: [PATCHSET v30.9 03/23] xfsprogs: atomic file updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-updates-6.10

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-file-updates-6.10
---
Commits in this patchset:
 * man: document the exchange-range ioctl
 * man: document XFS_FSOP_GEOM_FLAGS_EXCHRANGE
 * libhandle: add support for bulkstat v5
 * libfrog: add support for exchange range ioctl family
 * xfs_db: advertise exchange-range in the version command
 * xfs_logprint: support dumping exchmaps log items
 * xfs_fsr: convert to bulkstat v5 ioctls
 * xfs_fsr: skip the xattr/forkoff levering with the newer swapext implementations
 * xfs_io: create exchangerange command to test file range exchange ioctl
 * libfrog: advertise exchange-range support
 * xfs_repair: add exchange-range to file systems
 * mkfs: add a formatting option for exchange-range
---
 db/sb.c                             |    2 
 fsr/xfs_fsr.c                       |  167 +++++++++++++--------
 include/jdm.h                       |   23 +++
 io/Makefile                         |   48 +++++-
 io/exchrange.c                      |  156 ++++++++++++++++++++
 io/init.c                           |    1 
 io/io.h                             |    1 
 libfrog/Makefile                    |    2 
 libfrog/file_exchange.c             |   52 +++++++
 libfrog/file_exchange.h             |   15 ++
 libfrog/fsgeom.c                    |   49 +++++-
 libfrog/fsgeom.h                    |    1 
 libhandle/jdm.c                     |  117 +++++++++++++++
 logprint/log_misc.c                 |   11 +
 logprint/log_print_all.c            |   12 ++
 logprint/log_redo.c                 |  128 ++++++++++++++++
 logprint/logprint.h                 |    6 +
 man/man2/ioctl_xfs_exchange_range.2 |  278 +++++++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsgeometry.2     |    3 
 man/man8/mkfs.xfs.8.in              |    7 +
 man/man8/xfs_admin.8                |    7 +
 man/man8/xfs_io.8                   |   40 +++++
 mkfs/lts_4.19.conf                  |    1 
 mkfs/lts_5.10.conf                  |    1 
 mkfs/lts_5.15.conf                  |    1 
 mkfs/lts_5.4.conf                   |    1 
 mkfs/lts_6.1.conf                   |    1 
 mkfs/lts_6.6.conf                   |    1 
 mkfs/xfs_mkfs.c                     |   26 +++
 repair/globals.c                    |    1 
 repair/globals.h                    |    1 
 repair/phase2.c                     |   30 ++++
 repair/xfs_repair.c                 |   11 +
 33 files changed, 1114 insertions(+), 87 deletions(-)
 create mode 100644 io/exchrange.c
 create mode 100644 libfrog/file_exchange.c
 create mode 100644 libfrog/file_exchange.h
 create mode 100644 man/man2/ioctl_xfs_exchange_range.2

