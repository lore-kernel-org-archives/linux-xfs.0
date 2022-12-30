Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4923C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiL3XMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbiL3XMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:12:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04240DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95EB561C3A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03247C433D2;
        Fri, 30 Dec 2022 23:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441933;
        bh=7CFux/NWIwozLaBFNDAFiSf3yjPb7jV/RxTMs+PvA9U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m0N8yCiarOI2Or4827R4GbXN4U5h/5QEF0KfhGrk+RhXRtBspEB59+RJsMLWRsfb7
         ukSar8F3nSRC/TcxtaSpGordU3YBmDctEUlk96rN01iJmFpjZC8iwfT2sLw2Bd56zi
         MSkboBDOK1A08EwqJnoK3yaoDMUeVW/9xBU0ev0usfnykd1YwqYtqssaJia+pLDEJo
         Tpur0HeWf6yFxWCX2G3jzjSTA2LNEc6IKD+JFDJDtjl74RwMC5dvfiniI97Ssn9wGl
         a0xFeohreYEyXQ8Fsq3bSs8GxyKxYKjvEe1dCWKFI/v7tbK78HQA1Rijh1idRsuxD+
         1EznfU8b2OXtA==
Subject: [PATCHSET v24.0 00/19] libxfs: atomic file updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:59 -0800
Message-ID: <167243867932.713817.982387501030567647.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
that has also been floating around for years.  This RFC is constructed
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

Question: Should we really bother with fsdevel bikeshedding?  Most
filesystems cannot support this functionality, so we could keep it
private to XFS for now.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
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
 configure.ac                    |    1 
 fsr/xfs_fsr.c                   |  214 ++++---
 include/builddefs.in            |    1 
 include/jdm.h                   |   24 +
 include/xfs_inode.h             |    5 
 include/xfs_trace.h             |   13 
 io/Makefile                     |    6 
 io/atomicupdate.c               |  387 ++++++++++++
 io/init.c                       |    1 
 io/inject.c                     |    1 
 io/io.h                         |    5 
 io/open.c                       |   27 +
 io/swapext.c                    |  195 +++++-
 libfrog/Makefile                |    6 
 libfrog/fiexchange.h            |  105 +++
 libfrog/file_exchange.c         |  184 ++++++
 libfrog/file_exchange.h         |   16 
 libfrog/fsgeom.c                |   45 +
 libfrog/fsgeom.h                |    7 
 libhandle/jdm.c                 |  117 ++++
 libxfs/Makefile                 |    2 
 libxfs/defer_item.c             |   79 ++
 libxfs/libxfs_priv.h            |   30 +
 libxfs/xfs_bmap.h               |    4 
 libxfs/xfs_defer.c              |    7 
 libxfs/xfs_defer.h              |    3 
 libxfs/xfs_errortag.h           |    4 
 libxfs/xfs_format.h             |   15 
 libxfs/xfs_fs.h                 |    2 
 libxfs/xfs_log_format.h         |   80 ++
 libxfs/xfs_sb.c                 |    3 
 libxfs/xfs_swapext.c            | 1256 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_swapext.h            |  170 +++++
 libxfs/xfs_symlink_remote.c     |   47 +
 libxfs/xfs_symlink_remote.h     |    1 
 libxfs/xfs_trans_space.h        |    4 
 logprint/log_misc.c             |   11 
 logprint/log_print_all.c        |   12 
 logprint/log_redo.c             |  128 ++++
 logprint/logprint.h             |    6 
 m4/package_libcdev.m4           |   20 +
 man/man2/ioctl_xfs_fsgeometry.2 |    3 
 man/man8/xfs_io.8               |   87 +++
 43 files changed, 3183 insertions(+), 151 deletions(-)
 create mode 100644 io/atomicupdate.c
 create mode 100644 libfrog/fiexchange.h
 create mode 100644 libfrog/file_exchange.c
 create mode 100644 libfrog/file_exchange.h
 create mode 100644 libxfs/xfs_swapext.c
 create mode 100644 libxfs/xfs_swapext.h

