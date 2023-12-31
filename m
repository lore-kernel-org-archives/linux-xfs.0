Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A2DB645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhDjlHkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25511C433C7;
	Sun, 31 Dec 2023 19:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050972;
	bh=BT1MNUCWonswX69wttW+0wOQcrHojTujeQGbf4igom4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PhDjlHkNIEU0Z06Xez/Z7Akz7ii6V1EjKeQkURNFqvNsTWg07KEwXUkDKUr1JLwRK
	 40Ktq4UXxwUCl/gVMjVFAyWcpVoN+St9wTeilDzDVSda0tEB6Zq1rge8XSjh9JuxcQ
	 IKRmwVtFpidCrSTXcI+pJ06SrXdxyLxu6eQSE9Feagv5zEnRzrXwFgBzqsaR6W2Jvo
	 do/5af3VUXXi+X/OWLTCMdRIzo+gOG2PP5bVEfsFMkIkQps7gk1Udkhz8eK9q/YQH4
	 4vkGYTh2W3NR8ygHao/sHZRxmUzENT5Ni0yqxA3OntN65ACbzL/UdzG0TyHLR99jB7
	 uzdzzkaPE39KQ==
Date: Sun, 31 Dec 2023 11:29:31 -0800
Subject: [PATCHSET v29.0 16/28] xfs: atomic file updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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
Content-Transfer-Encoding: 8bit

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
Here is the proposed manual page:

IOCTL-XFS-EXCHANGE-RANGE(2System Calls ManuIOCTL-XFS-EXCHANGE-RANGE(2)

NAME
       ioctl_xfs_exchange_range  -  exchange  the contents of parts of
       two files

SYNOPSIS
       #include <sys/ioctl.h>
       #include <xfs/xfs_fs_staging.h>

       int   ioctl(int   file2_fd,   XFS_IOC_EXCHANGE_RANGE,    struct
       xfs_exch_range *arg);

DESCRIPTION
       Given  a  range  of bytes in a first file file1_fd and a second
       range of bytes in a second file  file2_fd,  this  ioctl(2)  ex‐
       changes the contents of the two ranges.

       Exchanges  are  atomic  with  regards to concurrent file opera‐
       tions, so no userspace-level locks need to be taken  to  obtain
       consistent  results.  Implementations must guarantee that read‐
       ers see either the old contents or the new  contents  in  their
       entirety, even if the system fails.

       The exchange parameters are conveyed in a structure of the fol‐
       lowing form:

           struct xfs_exch_range {
               __s64    file1_fd;
               __s64    file1_offset;
               __s64    file2_offset;
               __s64    length;

               __u64    flags;

               __s64    file2_ino;
               __s64    file2_mtime;
               __s64    file2_ctime;
               __s32    file2_mtime_nsec;
               __s32    file2_ctime_nsec;

               __u64    pad[6];
           };

       The field pad must be zero.

       The fields file1_fd, file1_offset, and length define the  first
       range of bytes to be exchanged.

       The fields file2_fd, file2_offset, and length define the second
       range of bytes to be exchanged.

       Both files must be from the same filesystem mount.  If the  two
       file  descriptors represent the same file, the byte ranges must
       not overlap.  Most  disk-based  filesystems  require  that  the
       starts  of  both ranges must be aligned to the file block size.
       If this is the case, the ends of the ranges  must  also  be  so
       aligned unless the XFS_EXCH_RANGE_TO_EOF flag is set.

       The field flags control the behavior of the exchange operation.

           XFS_EXCH_RANGE_FILE2_FRESH
                  Check  the  freshness  of file2_fd after locking the
                  file but before exchanging the contents.   The  sup‐
                  plied  file2_ino field must match file2's inode num‐
                  ber, and the supplied file2_mtime, file2_mtime_nsec,
                  file2_ctime,  and file2_ctime_nsec fields must match
                  the modification time and change time of file2.   If
                  they do not match, EBUSY will be returned.

           XFS_EXCH_RANGE_TO_EOF
                  Ignore  the length parameter.  All bytes in file1_fd
                  from file1_offset to EOF are moved to file2_fd,  and
                  file2's  size is set to (file2_offset+(file1_length-
                  file1_offset)).  Meanwhile, all bytes in file2  from
                  file2_offset  to  EOF are moved to file1 and file1's
                  size   is   set   to    (file1_offset+(file2_length-
                  file2_offset)).   This option is not compatible with
                  XFS_EXCH_RANGE_FULL_FILES.

           XFS_EXCH_RANGE_FSYNC
                  Ensure that all modified in-core data in  both  file
                  ranges  and  all  metadata updates pertaining to the
                  exchange operation are flushed to persistent storage
                  before  the  call  returns.  Opening either file de‐
                  scriptor with O_SYNC or O_DSYNC will have  the  same
                  effect.

           XFS_EXCH_RANGE_FILE1_WRITTEN
                  Only  exchange sub-ranges of file1_fd that are known
                  to contain data  written  by  application  software.
                  Each  sub-range  may  be  expanded (both upwards and
                  downwards) to align with the file  allocation  unit.
                  For files on the data device, this is one filesystem
                  block.  For files on the realtime  device,  this  is
                  the realtime extent size.  This facility can be used
                  to implement fast atomic  scatter-gather  writes  of
                  any  complexity for software-defined storage targets
                  if all writes are aligned  to  the  file  allocation
                  unit.

           XFS_EXCH_RANGE_DRY_RUN
                  Check  the parameters and the feasibility of the op‐
                  eration, but do not change anything.

           XFS_EXCH_RANGE_COMMIT
                  This     flag     is      a      combination      of
                  XFS_EXCH_RANGE_FILE2_FRESH   |  XFS_EXCH_RANGE_FSYNC
                  and can be used to commit  changes  to  file2_fd  to
                  persistent  storage  if  and  only  if file2 has not
                  changed.

           XFS_EXCH_RANGE_FULL_FILES
                  Require that file1_offset and file2_offset are zero,
                  and  that  the  length  field matches the lengths of
                  both files.  If not, EDOM will  be  returned.   This
                  option is not compatible with XFS_EXCH_RANGE_TO_EOF.

           XFS_EXCH_RANGE_NONATOMIC
                  This  flag  relaxes the requirement that readers see
                  only the old contents or the new contents  in  their
                  entirety.   If  the system fails before all modified
                  in-core data and metadata updates are  persisted  to
                  disk,  the contents of both file ranges after recov‐
                  ery are not defined and may be a mix of both.

                  Do not use this flag unless  the  contents  of  both
                  ranges  are  known  to be identical and there are no
                  other writers.

RETURN VALUE
       On error, -1 is returned, and errno is set to indicate the  er‐
       ror.

ERRORS
       Error  codes can be one of, but are not limited to, the follow‐
       ing:

       EBADF  file1_fd is not open for reading and writing or is  open
              for  append-only  writes;  or  file2_fd  is not open for
              reading and writing or is open for append-only writes.

       EBUSY  The inode number and timestamps supplied  do  not  match
              file2_fd   and  XFS_EXCH_RANGE_FILE2_FRESH  was  set  in
              flags.

       EDOM   The ranges do not cover the entirety of both files,  and
              XFS_EXCH_RANGE_FULL_FILES was set in flags.

       EINVAL The  parameters  are  not correct for these files.  This
              error can also appear if either file  descriptor  repre‐
              sents  a device, FIFO, or socket.  Disk filesystems gen‐
              erally require the offset and  length  arguments  to  be
              aligned to the fundamental block sizes of both files.

       EIO    An I/O error occurred.

       EISDIR One of the files is a directory.

       ENOMEM The  kernel  was unable to allocate sufficient memory to
              perform the operation.

       ENOSPC There is not enough free space  in  the  filesystem  ex‐
              change the contents safely.

       EOPNOTSUPP
              The filesystem does not support exchanging bytes between
              the two files.

       EPERM  file1_fd or file2_fd are immutable.

       ETXTBSY
              One of the files is a swap file.

       EUCLEAN
              The filesystem is corrupt.

       EXDEV  file1_fd and  file2_fd  are  not  on  the  same  mounted
              filesystem.

CONFORMING TO
       This API is XFS-specific.

USE CASES
       Three use cases are imagined for this system call.

       The  first  is a filesystem defragmenter, which copies the con‐
       tents of a file into another file and wishes  to  exchange  the
       space  mappings  of  the  two files, provided that the original
       file has not changed.  The flags NONATOMIC and FILE2_FRESH  are
       recommended for this application.

       The  second is a data storage program that wants to commit non-
       contiguous updates to a file atomically.  This can be  done  by
       creating a temporary file, calling FICLONE(2) to share the con‐
       tents, and staging the updates into the temporary file.  Either
       of  the  FULL_FILES or TO_EOF flags are recommended, along with
       FSYNC.  Depending on  the  application's  locking  design,  the
       flags FILE2_FRESH or COMMIT may be applicable here.  The tempo‐
       rary file can be deleted or punched out afterwards.

       The third is a software-defined storage host (e.g. a disk juke‐
       box)  which  implements an atomic scatter-gather write command.
       Provided the exported disk's logical  block  size  matches  the
       file's  allocation  unit  size,  this can be done by creating a
       temporary file and writing the data at the appropriate offsets.
       It  is  recommended that the temporary file be truncated to the
       size of the regular file before any writes are  staged  to  the
       temporary  file  to avoid issues with zeroing during EOF exten‐
       sion.  Use this call with the FILE1_WRITTEN  flag  to  exchange
       only  the  file  allocation  units involved in the emulated de‐
       vice's write command.  The use of the FSYNC flag is recommended
       here.  The temporary file should be deleted or punched out com‐
       pletely before being reused to stage another write.

NOTES
       Some filesystems may limit the amount of data or the number  of
       extents that can be exchanged in a single call.

SEE ALSO
       ioctl(2)

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
 fs/read_write.c                    |    2 
 fs/remap_range.c                   |    4 
 fs/xfs/Makefile                    |    3 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_defer.c          |    6 
 fs/xfs/libxfs/xfs_defer.h          |    2 
 fs/xfs/libxfs/xfs_errortag.h       |    4 
 fs/xfs/libxfs/xfs_format.h         |   20 -
 fs/xfs/libxfs/xfs_fs.h             |    4 
 fs/xfs/libxfs/xfs_fs_staging.h     |  107 +++
 fs/xfs/libxfs/xfs_log_format.h     |   83 ++
 fs/xfs/libxfs/xfs_log_recover.h    |    2 
 fs/xfs/libxfs/xfs_sb.c             |    3 
 fs/xfs/libxfs/xfs_swapext.c        | 1318 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_swapext.h        |  223 ++++++
 fs/xfs/libxfs/xfs_symlink_remote.c |   47 +
 fs/xfs/libxfs/xfs_symlink_remote.h |    1 
 fs/xfs/libxfs/xfs_trans_space.h    |    4 
 fs/xfs/xfs_bmap_util.c             |  732 ++++---------------
 fs/xfs/xfs_bmap_util.h             |   10 
 fs/xfs/xfs_error.c                 |    3 
 fs/xfs/xfs_file.c                  |   88 --
 fs/xfs/xfs_file.h                  |   15 
 fs/xfs/xfs_inode.c                 |   75 ++
 fs/xfs/xfs_inode.h                 |   12 
 fs/xfs/xfs_ioctl.c                 |  133 ++-
 fs/xfs/xfs_ioctl.h                 |    4 
 fs/xfs/xfs_ioctl32.c               |   11 
 fs/xfs/xfs_iops.c                  |    1 
 fs/xfs/xfs_iops.h                  |    7 
 fs/xfs/xfs_linux.h                 |    6 
 fs/xfs/xfs_log.c                   |   47 +
 fs/xfs/xfs_log.h                   |   10 
 fs/xfs/xfs_log_priv.h              |    3 
 fs/xfs/xfs_log_recover.c           |    5 
 fs/xfs/xfs_mount.c                 |   11 
 fs/xfs/xfs_mount.h                 |    7 
 fs/xfs/xfs_super.c                 |   19 
 fs/xfs/xfs_swapext_item.c          |  616 ++++++++++++++++
 fs/xfs/xfs_swapext_item.h          |   60 ++
 fs/xfs/xfs_symlink.c               |   49 -
 fs/xfs/xfs_trace.c                 |    2 
 fs/xfs/xfs_trace.h                 |  359 +++++++++
 fs/xfs/xfs_xattr.c                 |    6 
 fs/xfs/xfs_xchgrange.c             | 1393 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_xchgrange.h             |   56 +
 include/linux/fs.h                 |    1 
 47 files changed, 4727 insertions(+), 849 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_fs_staging.h
 create mode 100644 fs/xfs/libxfs/xfs_swapext.c
 create mode 100644 fs/xfs/libxfs/xfs_swapext.h
 create mode 100644 fs/xfs/xfs_file.h
 create mode 100644 fs/xfs/xfs_swapext_item.c
 create mode 100644 fs/xfs/xfs_swapext_item.h
 create mode 100644 fs/xfs/xfs_xchgrange.c
 create mode 100644 fs/xfs/xfs_xchgrange.h

