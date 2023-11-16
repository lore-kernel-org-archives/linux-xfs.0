Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E9BC47071
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 16:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjKPQfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 11:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjKPQfL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 11:35:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB25DAD
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 08:35:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D74FC433C7;
        Thu, 16 Nov 2023 16:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700152506;
        bh=rwPxazDIxgA8siFJNcmF4OW7NWlmPvQIsiLl4QE0eeU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JQS1Yhv7sZB6Cy710kIXwOnkrtGN2h+0jXMcGn2471TnuEgaD43Gy4WYrZpGtRo0E
         5gHuWUwvf/zrhcQnuKfA5E69ovi2cs82hMNUNMpuRjiMEq9CYxNoGlDTVB4X7b1S4c
         uQN3SYNW9CNlt/0ny/rmjOLE23eRm17Yyn8l769Eu4VihW8n82I2Iss4T3C2BvQ7DS
         7EoCmw7nQIW+wLkq5F0a0JxMqXhS3sPgTdg+oMPiaUc3qAMrj1fMmtfPC8+x5VDv+a
         ys1LRfBqSHdkJbGCKYywQz/0sY+0TGInJ9t09uiMMBQJOk+qo/OMUdMdBNZLT8w4JQ
         TBU5lOcmHdqsQ==
Date:   Thu, 16 Nov 2023 08:35:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: privatize the FIEXCHANGE ioctl for now
Message-ID: <20231116163505.GE36211@frogsfrogsfrogs>
References: <169947992096.220003.8427995158013553083.stgit@frogsfrogsfrogs>
 <169947992659.220003.6848674343755298330.stgit@frogsfrogsfrogs>
 <20231116151408.rbs4skzefu4zbjag@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116151408.rbs4skzefu4zbjag@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 16, 2023 at 11:14:08PM +0800, Zorro Lang wrote:
> On Wed, Nov 08, 2023 at 01:45:26PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > I'm abandoning (for now) efforts to bring atomic file content exchanges
> > to the VFS.  The goal here is to reduce friction in getting online fsck
> > merged, so Dave and I want to take this back to being a private XFS
> > ioctl so we can explore with it for a while before committing it to the
> > stable KABI.
> > 
> > Shift all the existing FIEXCHANGE usage to XFS_IOC_EXCHANGE_RANGE, and
> > try to pick it up from xfs_fs_staging.h if the system xfslibs-dev
> > package has such an animal.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Hi Darrick,
> 
> Could you please rebase this patchset onto latest fstests for-next branch?
> I can't merge it onto for-next or master branch, always hit:
>   $ git am -s  ./20231108_djwong_fstests_fiexchange_is_now_an_xfs_ioctl.mbx
>   Applying: misc: privatize the FIEXCHANGE ioctl for now
>   error: patch failed: configure.ac:70
>   error: configure.ac: patch does not apply
>   error: patch failed: include/builddefs.in:72
>   error: include/builddefs.in: patch does not apply
>   error: patch failed: m4/package_libcdev.m4:155
>   error: m4/package_libcdev.m4: patch does not apply
>   error: patch failed: src/Makefile:98
>   error: src/Makefile: patch does not apply
>   Patch failed at 0001 misc: privatize the FIEXCHANGE ioctl for now
> 
> Can you rebase this patchset onto latest for-next branch, better to after: 
> 
>   [PATCH 1/1] generic: test reads racing with slow reflink operations

I'll ... try to figure out what the FIEXCHANGE patch is tripping over.
If I figure it out I'll send you a pull request; if not, I'll reply to
this thread.

> I've merged it.
> 
> And of course, you please keep the RVB from Christoph Hellwig :)

Will do.

--D

> Thanks,
> Zorro
> 
> 
> >  configure.ac          |    2 +-
> >  doc/group-names.txt   |    2 +-
> >  include/builddefs.in  |    2 +-
> >  ltp/Makefile          |    4 ++--
> >  ltp/fsstress.c        |   10 +++++-----
> >  ltp/fsx.c             |   20 ++++++++++----------
> >  m4/package_libcdev.m4 |   19 -------------------
> >  m4/package_xfslibs.m4 |   14 ++++++++++++++
> >  src/Makefile          |    4 ++++
> >  src/fiexchange.h      |   44 ++++++++++++++++++++++----------------------
> >  src/global.h          |    4 +---
> >  src/vfs/Makefile      |    4 ++++
> >  tests/generic/724     |    2 +-
> >  tests/xfs/122.out     |    1 +
> >  tests/xfs/791         |    2 +-
> >  15 files changed, 68 insertions(+), 66 deletions(-)
> > 
> > 
> > diff --git a/configure.ac b/configure.ac
> > index 7333045330..b22fc52bff 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -70,7 +70,7 @@ AC_HAVE_SEEK_DATA
> >  AC_HAVE_BMV_OF_SHARED
> >  AC_HAVE_NFTW
> >  AC_HAVE_RLIMIT_NOFILE
> > -AC_HAVE_FIEXCHANGE
> > +AC_HAVE_XFS_IOC_EXCHANGE_RANGE
> >  AC_HAVE_FICLONE
> >  
> >  AC_CHECK_FUNCS([renameat2])
> > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > index c3dcca3755..fec6bf71ab 100644
> > --- a/doc/group-names.txt
> > +++ b/doc/group-names.txt
> > @@ -52,7 +52,7 @@ enospc			ENOSPC error reporting
> >  exportfs		file handles
> >  fiemap			fiemap ioctl
> >  filestreams		XFS filestreams allocator
> > -fiexchange		FIEXCHANGE_RANGE ioctl
> > +fiexchange		XFS_IOC_EXCHANGE_RANGE ioctl
> >  freeze			filesystem freeze tests
> >  fsck			general fsck tests
> >  fsmap			FS_IOC_GETFSMAP ioctl
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 446350d5fc..ce95fe7d4b 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -72,7 +72,7 @@ HAVE_SEEK_DATA = @have_seek_data@
> >  HAVE_NFTW = @have_nftw@
> >  HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
> >  HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
> > -HAVE_FIEXCHANGE = @have_fiexchange@
> > +HAVE_XFS_IOC_EXCHANGE_RANGE = @have_xfs_ioc_exchange_range@
> >  HAVE_FICLONE = @have_ficlone@
> >  
> >  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
> > diff --git a/ltp/Makefile b/ltp/Makefile
> > index c2b70d896e..c0b2824076 100644
> > --- a/ltp/Makefile
> > +++ b/ltp/Makefile
> > @@ -36,8 +36,8 @@ ifeq ($(HAVE_COPY_FILE_RANGE),yes)
> >  LCFLAGS += -DHAVE_COPY_FILE_RANGE
> >  endif
> >  
> > -ifeq ($(HAVE_FIEXCHANGE),yes)
> > -LCFLAGS += -DHAVE_FIEXCHANGE
> > +ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
> > +LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
> >  endif
> >  
> >  default: depend $(TARGETS)
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index abe2874253..2681ed2b08 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -2592,8 +2592,8 @@ xchgrange_f(
> >  	opnum_t			opno,
> >  	long			r)
> >  {
> > -#ifdef FIEXCHANGE_RANGE
> > -	struct file_xchg_range	fxr = { 0 };
> > +#ifdef XFS_IOC_EXCHANGE_RANGE
> > +	struct xfs_exch_range	fxr = { 0 };
> >  	static __u64		swap_flags = 0;
> >  	struct pathname		fpath1;
> >  	struct pathname		fpath2;
> > @@ -2721,10 +2721,10 @@ xchgrange_f(
> >  	fxr.flags = swap_flags;
> >  
> >  retry:
> > -	ret = ioctl(fd2, FIEXCHANGE_RANGE, &fxr);
> > +	ret = ioctl(fd2, XFS_IOC_EXCHANGE_RANGE, &fxr);
> >  	e = ret < 0 ? errno : 0;
> > -	if (e == EOPNOTSUPP && !(swap_flags & FILE_XCHG_RANGE_NONATOMIC)) {
> > -		swap_flags = FILE_XCHG_RANGE_NONATOMIC;
> > +	if (e == EOPNOTSUPP && !(swap_flags & XFS_EXCH_RANGE_NONATOMIC)) {
> > +		swap_flags = XFS_EXCH_RANGE_NONATOMIC;
> >  		fxr.flags |= swap_flags;
> >  		goto retry;
> >  	}
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index a30e2a8dbc..777ba0de5d 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -1389,27 +1389,27 @@ do_insert_range(unsigned offset, unsigned length)
> >  }
> >  #endif
> >  
> > -#ifdef FIEXCHANGE_RANGE
> > +#ifdef XFS_IOC_EXCHANGE_RANGE
> >  static __u64 swap_flags = 0;
> >  
> >  int
> >  test_xchg_range(void)
> >  {
> > -	struct file_xchg_range	fsr = {
> > +	struct xfs_exch_range	fsr = {
> >  		.file1_fd = fd,
> > -		.flags = FILE_XCHG_RANGE_DRY_RUN | swap_flags,
> > +		.flags = XFS_EXCH_RANGE_DRY_RUN | swap_flags,
> >  	};
> >  	int ret, e;
> >  
> >  retry:
> > -	ret = ioctl(fd, FIEXCHANGE_RANGE, &fsr);
> > +	ret = ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &fsr);
> >  	e = ret < 0 ? errno : 0;
> > -	if (e == EOPNOTSUPP && !(swap_flags & FILE_XCHG_RANGE_NONATOMIC)) {
> > +	if (e == EOPNOTSUPP && !(swap_flags & XFS_EXCH_RANGE_NONATOMIC)) {
> >  		/*
> >  		 * If the call fails with atomic mode, try again with non
> >  		 * atomic mode.
> >  		 */
> > -		swap_flags = FILE_XCHG_RANGE_NONATOMIC;
> > +		swap_flags = XFS_EXCH_RANGE_NONATOMIC;
> >  		fsr.flags |= swap_flags;
> >  		goto retry;
> >  	}
> > @@ -1427,7 +1427,7 @@ test_xchg_range(void)
> >  void
> >  do_xchg_range(unsigned offset, unsigned length, unsigned dest)
> >  {
> > -	struct file_xchg_range	fsr = {
> > +	struct xfs_exch_range	fsr = {
> >  		.file1_fd = fd,
> >  		.file1_offset = offset,
> >  		.file2_offset = dest,
> > @@ -1470,10 +1470,10 @@ do_xchg_range(unsigned offset, unsigned length, unsigned dest)
> >  			testcalls, offset, offset+length, length, dest);
> >  	}
> >  
> > -	if (ioctl(fd, FIEXCHANGE_RANGE, &fsr) == -1) {
> > +	if (ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &fsr) == -1) {
> >  		prt("exchange range: 0x%x to 0x%x at 0x%x\n", offset,
> >  				offset + length, dest);
> > -		prterr("do_xchg_range: FIEXCHANGE_RANGE");
> > +		prterr("do_xchg_range: XFS_IOC_EXCHANGE_RANGE");
> >  		report_failure(161);
> >  		goto out_free;
> >  	}
> > @@ -2452,7 +2452,7 @@ usage(void)
> >  #ifdef HAVE_COPY_FILE_RANGE
> >  "	-E: Do not use copy range calls\n"
> >  #endif
> > -#ifdef FIEXCHANGE_RANGE
> > +#ifdef XFS_IOC_EXCHANGE_RANGE
> >  "	-0: Do not use exchange range calls\n"
> >  #endif
> >  "	-K: Do not use keep size\n\
> > diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> > index 91eb64db21..d5d88b8e44 100644
> > --- a/m4/package_libcdev.m4
> > +++ b/m4/package_libcdev.m4
> > @@ -155,25 +155,6 @@ AC_DEFUN([AC_HAVE_RLIMIT_NOFILE],
> >      AC_SUBST(have_rlimit_nofile)
> >    ])
> >  
> > -#
> > -# Check if we have a FIEXCHANGE_RANGE ioctl (Linux)
> > -#
> > -AC_DEFUN([AC_HAVE_FIEXCHANGE],
> > -  [ AC_MSG_CHECKING([for FIEXCHANGE_RANGE])
> > -    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
> > -#define _GNU_SOURCE
> > -#include <sys/syscall.h>
> > -#include <sys/ioctl.h>
> > -#include <unistd.h>
> > -#include <linux/fs.h>
> > -#include <linux/fiexchange.h>
> > -    ]], [[
> > -         struct file_xchg_range fxr;
> > -         ioctl(-1, FIEXCHANGE_RANGE, &fxr);
> > -    ]])],[have_fiexchange=yes
> > -       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
> > -    AC_SUBST(have_fiexchange)
> > -
> >  # Check if we have FICLONE
> >  AC_DEFUN([AC_HAVE_FICLONE],
> >    [ AC_MSG_CHECKING([for FICLONE])
> > diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
> > index 8ef58cc064..1549360df6 100644
> > --- a/m4/package_xfslibs.m4
> > +++ b/m4/package_xfslibs.m4
> > @@ -119,3 +119,17 @@ AC_DEFUN([AC_HAVE_BMV_OF_SHARED],
> >         AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
> >      AC_SUBST(have_bmv_of_shared)
> >    ])
> > +
> > +# Check if we have XFS_IOC_EXCHANGE_RANGE
> > +AC_DEFUN([AC_HAVE_XFS_IOC_EXCHANGE_RANGE],
> > +  [ AC_MSG_CHECKING([for XFS_IOC_EXCHANGE_RANGE])
> > +    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
> > +#define _GNU_SOURCE
> > +#include <xfs/xfs.h>
> > +    ]], [[
> > +         struct xfs_exch_range obj;
> > +         ioctl(-1, XFS_IOC_EXCHANGE_RANGE, &obj);
> > +    ]])],[have_xfs_ioc_exchange_range=yes
> > +       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
> > +    AC_SUBST(have_xfs_ioc_exchange_range)
> > +  ])
> > diff --git a/src/Makefile b/src/Makefile
> > index 49dd2f6c1e..8160a0e8ec 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -98,6 +98,10 @@ ifeq ($(HAVE_FICLONE),yes)
> >       TARGETS += t_reflink_read_race
> >  endif
> >  
> > +ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
> > +LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
> > +endif
> > +
> >  CFILES = $(TARGETS:=.c)
> >  LDIRT = $(TARGETS) fssum
> >  
> > diff --git a/src/fiexchange.h b/src/fiexchange.h
> > index 29b3ac0ff5..6a3ae8964d 100644
> > --- a/src/fiexchange.h
> > +++ b/src/fiexchange.h
> > @@ -16,13 +16,13 @@
> >   * called against (which we'll call file2).  Filesystems must be able to
> >   * restart and complete the operation even after the system goes down.
> >   */
> > -struct file_xchg_range {
> > +struct xfs_exch_range {
> >  	__s64		file1_fd;
> >  	__s64		file1_offset;	/* file1 offset, bytes */
> >  	__s64		file2_offset;	/* file2 offset, bytes */
> >  	__s64		length;		/* bytes to exchange */
> >  
> > -	__u64		flags;		/* see FILE_XCHG_RANGE_* below */
> > +	__u64		flags;		/* see XFS_EXCH_RANGE_* below */
> >  
> >  	/* file2 metadata for optional freshness checks */
> >  	__s64		file2_ino;	/* inode number */
> > @@ -38,39 +38,39 @@ struct file_xchg_range {
> >   * Atomic exchange operations are not required.  This relaxes the requirement
> >   * that the filesystem must be able to complete the operation after a crash.
> >   */
> > -#define FILE_XCHG_RANGE_NONATOMIC	(1 << 0)
> > +#define XFS_EXCH_RANGE_NONATOMIC	(1 << 0)
> >  
> >  /*
> >   * Check that file2's inode number, mtime, and ctime against the values
> >   * provided, and return -EBUSY if there isn't an exact match.
> >   */
> > -#define FILE_XCHG_RANGE_FILE2_FRESH	(1 << 1)
> > +#define XFS_EXCH_RANGE_FILE2_FRESH	(1 << 1)
> >  
> >  /*
> >   * Check that the file1's length is equal to file1_offset + length, and that
> >   * file2's length is equal to file2_offset + length.  Returns -EDOM if there
> >   * isn't an exact match.
> >   */
> > -#define FILE_XCHG_RANGE_FULL_FILES	(1 << 2)
> > +#define XFS_EXCH_RANGE_FULL_FILES	(1 << 2)
> >  
> >  /*
> >   * Exchange file data all the way to the ends of both files, and then exchange
> >   * the file sizes.  This flag can be used to replace a file's contents with a
> >   * different amount of data.  length will be ignored.
> >   */
> > -#define FILE_XCHG_RANGE_TO_EOF		(1 << 3)
> > +#define XFS_EXCH_RANGE_TO_EOF		(1 << 3)
> >  
> >  /* Flush all changes in file data and file metadata to disk before returning. */
> > -#define FILE_XCHG_RANGE_FSYNC		(1 << 4)
> > +#define XFS_EXCH_RANGE_FSYNC		(1 << 4)
> >  
> >  /* Dry run; do all the parameter verification but do not change anything. */
> > -#define FILE_XCHG_RANGE_DRY_RUN		(1 << 5)
> > +#define XFS_EXCH_RANGE_DRY_RUN		(1 << 5)
> >  
> >  /*
> > - * Do not exchange any part of the range where file1's mapping is a hole.  This
> > - * can be used to emulate scatter-gather atomic writes with a temp file.
> > + * Only exchange ranges where file1's range maps to a written extent.  This can
> > + * be used to emulate scatter-gather atomic writes with a temp file.
> >   */
> > -#define FILE_XCHG_RANGE_SKIP_FILE1_HOLES (1 << 6)
> > +#define XFS_EXCH_RANGE_FILE1_WRITTEN	(1 << 6)
> >  
> >  /*
> >   * Commit the contents of file1 into file2 if file2 has the same inode number,
> > @@ -83,19 +83,19 @@ struct file_xchg_range {
> >   * commit is complete.
> >   *
> >   * This flag should not be combined with NONATOMIC.  It can be combined with
> > - * SKIP_FILE1_HOLES.
> > + * FILE1_WRITTEN.
> >   */
> > -#define FILE_XCHG_RANGE_COMMIT		(FILE_XCHG_RANGE_FILE2_FRESH | \
> > -					 FILE_XCHG_RANGE_FSYNC)
> > +#define XFS_EXCH_RANGE_COMMIT		(XFS_EXCH_RANGE_FILE2_FRESH | \
> > +					 XFS_EXCH_RANGE_FSYNC)
> >  
> > -#define FILE_XCHG_RANGE_ALL_FLAGS	(FILE_XCHG_RANGE_NONATOMIC | \
> > -					 FILE_XCHG_RANGE_FILE2_FRESH | \
> > -					 FILE_XCHG_RANGE_FULL_FILES | \
> > -					 FILE_XCHG_RANGE_TO_EOF | \
> > -					 FILE_XCHG_RANGE_FSYNC | \
> > -					 FILE_XCHG_RANGE_DRY_RUN | \
> > -					 FILE_XCHG_RANGE_SKIP_FILE1_HOLES)
> > +#define XFS_EXCH_RANGE_ALL_FLAGS	(XFS_EXCH_RANGE_NONATOMIC | \
> > +					 XFS_EXCH_RANGE_FILE2_FRESH | \
> > +					 XFS_EXCH_RANGE_FULL_FILES | \
> > +					 XFS_EXCH_RANGE_TO_EOF | \
> > +					 XFS_EXCH_RANGE_FSYNC | \
> > +					 XFS_EXCH_RANGE_DRY_RUN | \
> > +					 XFS_EXCH_RANGE_FILE1_WRITTEN)
> >  
> > -#define FIEXCHANGE_RANGE	_IOWR('X', 129, struct file_xchg_range)
> > +#define XFS_IOC_EXCHANGE_RANGE	_IOWR('X', 129, struct xfs_exch_range)
> >  
> >  #endif /* _LINUX_FIEXCHANGE_H */
> > diff --git a/src/global.h b/src/global.h
> > index 49570ef117..4f92308d6c 100644
> > --- a/src/global.h
> > +++ b/src/global.h
> > @@ -171,9 +171,7 @@
> >  #include <sys/mman.h>
> >  #endif
> >  
> > -#ifdef HAVE_FIEXCHANGE
> > -# include <linux/fiexchange.h>
> > -#else
> > +#ifndef HAVE_XFS_IOC_EXCHANGE_RANGE
> >  # include "fiexchange.h"
> >  #endif
> >  
> > diff --git a/src/vfs/Makefile b/src/vfs/Makefile
> > index 4841da1286..868540f578 100644
> > --- a/src/vfs/Makefile
> > +++ b/src/vfs/Makefile
> > @@ -19,6 +19,10 @@ ifeq ($(HAVE_URING), true)
> >  LLDLIBS += -luring
> >  endif
> >  
> > +ifeq ($(HAVE_XFS_IOC_EXCHANGE_RANGE),yes)
> > +LCFLAGS += -DHAVE_XFS_IOC_EXCHANGE_RANGE
> > +endif
> > +
> >  default: depend $(TARGETS)
> >  
> >  depend: .dep
> > diff --git a/tests/generic/724 b/tests/generic/724
> > index 8d7dc4e12a..67e0dba446 100755
> > --- a/tests/generic/724
> > +++ b/tests/generic/724
> > @@ -5,7 +5,7 @@
> >  # FS QA Test No. 724
> >  #
> >  # Test scatter-gather atomic file writes.  We create a temporary file, write
> > -# sparsely to it, then use FILE_SWAP_RANGE_SKIP_FILE1_HOLES flag to swap
> > +# sparsely to it, then use XFS_EXCH_RANGE_FILE1_WRITTEN flag to swap
> >  # atomicallly only the ranges that we wrote.
> >  
> >  . ./common/preamble
> > diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> > index 21549db7fd..89f7b735b0 100644
> > --- a/tests/xfs/122.out
> > +++ b/tests/xfs/122.out
> > @@ -90,6 +90,7 @@ sizeof(struct xfs_disk_dquot) = 104
> >  sizeof(struct xfs_dqblk) = 136
> >  sizeof(struct xfs_dsb) = 264
> >  sizeof(struct xfs_dsymlink_hdr) = 56
> > +sizeof(struct xfs_exch_range) = 120
> >  sizeof(struct xfs_extent_data) = 24
> >  sizeof(struct xfs_extent_data_info) = 32
> >  sizeof(struct xfs_fs_eofblocks) = 128
> > diff --git a/tests/xfs/791 b/tests/xfs/791
> > index d82314ee08..4944c1517c 100755
> > --- a/tests/xfs/791
> > +++ b/tests/xfs/791
> > @@ -5,7 +5,7 @@
> >  # FS QA Test No. 791
> >  #
> >  # Test scatter-gather atomic file writes.  We create a temporary file, write
> > -# sparsely to it, then use FILE_SWAP_RANGE_SKIP_FILE1_HOLES flag to swap
> > +# sparsely to it, then use XFS_EXCH_RANGE_FILE1_WRITTEN flag to swap
> >  # atomicallly only the ranges that we wrote.  Inject an error so that we can
> >  # test that log recovery finishes the swap.
> >  
> > 
> 
