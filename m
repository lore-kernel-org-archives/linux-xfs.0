Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85FBC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 17:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352414AbiE0RER (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 13:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242354AbiE0REQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 13:04:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBD513B8EC
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 10:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82A5161E01
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 17:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E1FC385A9;
        Fri, 27 May 2022 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653671050;
        bh=xuzCQCZ44yurLhW+0XyvIBIsEsuSf4WQT5UhLxg8XLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eRI+nz8ddShDc/jdr5KP3V/8C1qv7OcvaPLElgy/vRpYQ9WtDRUKIUPzxCabkAlGe
         031wMgMqtSEI6f4GxUUkZUG47I0ER+FIqsys2+6zoOogmhj+gJgH3H57qZuzvQRtpg
         5mhtyPZQF9GVRAcR7niwkN6sWSd5/rRwEeDj9t3s2TwOGVTDGrl19h8p9WjzxHq22A
         WyhuMcMCVDUr+z5nOtZ2sK30HhIE+fYECxPvjBbWeTarjkyCZ0U/hWsuXiXrk1pmaP
         KPZYxMpEhNNpuQJflFB7JfyOZhpzS4K2EQeSKTF/aJjDV7Z8xD2OUYwuVKSjwFUhqf
         z5VQGUCyXfBtw==
Date:   Fri, 27 May 2022 10:04:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfsprogs: autoconf modernisation
Message-ID: <YpEEisc/aoqkkxMr@magnolia>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426234453.682296-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 09:44:53AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because apparently AC_TRY_COMPILE and AC_TRY_LINK has been
> deprecated and made obsolete.
> 
> .....
> configure.ac:164: warning: The macro `AC_TRY_COMPILE' is obsolete.
> configure.ac:164: You should run autoupdate.
> ./lib/autoconf/general.m4:2847: AC_TRY_COMPILE is expanded from...
> m4/package_libcdev.m4:68: AC_HAVE_GETMNTENT is expanded from...
> configure.ac:164: the top level
> configure.ac:165: warning: The macro `AC_TRY_LINK' is obsolete.
> configure.ac:165: You should run autoupdate.
> ./lib/autoconf/general.m4:2920: AC_TRY_LINK is expanded from...
> m4/package_libcdev.m4:84: AC_HAVE_FALLOCATE is expanded from...
> configure.ac:165: the top level
> .....
> 
> But "autoupdate" does nothing to fix this, so I have to manually do
> these conversions:
> 
> 	- AC_TRY_COMPILE -> AC_COMPILE_IFELSE
> 	- AC_TRY_LINK -> AC_LINK_IFELSE

Note for the next time we have to do this: I started rebasing djwong-dev
on this one patch, and noticed my autoupdate accepts file paths, which
means that one can do things like:

$ autoupdate configure.ac m4/*.m4

instead of doing this by hand.

--D

> because I have nothing better to do than fix currently working
> code.
> 
> Also, running autoupdate forces the minimum pre-req to be autoconf
> 2.71 because it replaces other stuff...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  configure.ac          |   8 +--
>  m4/package_attr.m4    |   8 ++-
>  m4/package_libcdev.m4 | 158 ++++++++++++++++++++++++++----------------
>  m4/package_types.m4   |   8 ++-
>  m4/package_urcu.m4    |  18 +++--
>  5 files changed, 123 insertions(+), 77 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 4278145fe74b..36e42394a9df 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -1,13 +1,13 @@
> -AC_INIT([xfsprogs], [5.15.0], [linux-xfs@vger.kernel.org])
> -AC_PREREQ(2.50)
> +AC_INIT([xfsprogs],[5.15.0],[linux-xfs@vger.kernel.org])
> +AC_PREREQ([2.71])
>  AC_CONFIG_AUX_DIR([.])
>  AC_CONFIG_MACRO_DIR([m4])
>  AC_CONFIG_SRCDIR([include/libxfs.h])
> -AC_CONFIG_HEADER(include/platform_defs.h)
> +AC_CONFIG_HEADERS([include/platform_defs.h])
>  AC_PREFIX_DEFAULT(/usr)
>  
>  AC_PROG_INSTALL
> -AC_PROG_LIBTOOL
> +LT_INIT
>  
>  AC_PROG_CC
>  AC_ARG_VAR(BUILD_CC, [C compiler for build tools])
> diff --git a/m4/package_attr.m4 b/m4/package_attr.m4
> index 432492311d18..05e02b38fb5a 100644
> --- a/m4/package_attr.m4
> +++ b/m4/package_attr.m4
> @@ -8,15 +8,17 @@ AC_DEFUN([AC_PACKAGE_WANT_ATTRIBUTES_H],
>  #
>  AC_DEFUN([AC_HAVE_LIBATTR],
>    [ AC_MSG_CHECKING([for struct attrlist_cursor])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #include <sys/types.h>
>  #include <attr/attributes.h>
> -       ], [
> +	]], [[
>  struct attrlist_cursor *cur;
>  struct attrlist *list;
>  struct attrlist_ent *ent;
>  int flags = ATTR_ROOT;
> -       ], have_libattr=yes
> +	]])
> +    ], have_libattr=yes
>            AC_MSG_RESULT(yes),
>            AC_MSG_RESULT(no))
>      AC_SUBST(have_libattr)
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index adab9bb9773a..94d76c7b3a19 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -3,11 +3,13 @@
>  #
>  AC_DEFUN([AC_HAVE_FADVISE],
>    [ AC_MSG_CHECKING([for fadvise ])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <fcntl.h>
> -    ], [
> -	posix_fadvise(0, 1, 0, POSIX_FADV_NORMAL);
> +	]], [[
> +posix_fadvise(0, 1, 0, POSIX_FADV_NORMAL);
> +	]])
>      ],	have_fadvise=yes
>  	AC_MSG_RESULT(yes),
>  	AC_MSG_RESULT(no))
> @@ -19,11 +21,13 @@ AC_DEFUN([AC_HAVE_FADVISE],
>  #
>  AC_DEFUN([AC_HAVE_MADVISE],
>    [ AC_MSG_CHECKING([for madvise ])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <sys/mman.h>
> -    ], [
> -	posix_madvise(0, 0, MADV_NORMAL);
> +	]], [[
> +posix_madvise(0, 0, MADV_NORMAL);
> +	]])
>      ],	have_madvise=yes
>  	AC_MSG_RESULT(yes),
>  	AC_MSG_RESULT(no))
> @@ -35,11 +39,13 @@ AC_DEFUN([AC_HAVE_MADVISE],
>  #
>  AC_DEFUN([AC_HAVE_MINCORE],
>    [ AC_MSG_CHECKING([for mincore ])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <sys/mman.h>
> -    ], [
> -	mincore(0, 0, 0);
> +	]], [[
> +mincore(0, 0, 0);
> +	]])
>      ],	have_mincore=yes
>  	AC_MSG_RESULT(yes),
>  	AC_MSG_RESULT(no))
> @@ -51,11 +57,13 @@ AC_DEFUN([AC_HAVE_MINCORE],
>  #
>  AC_DEFUN([AC_HAVE_SENDFILE],
>    [ AC_MSG_CHECKING([for sendfile ])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <sys/sendfile.h>
> -    ], [
> -         sendfile(0, 0, 0, 0);
> +	]], [[
> +sendfile(0, 0, 0, 0);
> +	]])
>      ],	have_sendfile=yes
>  	AC_MSG_RESULT(yes),
>  	AC_MSG_RESULT(no))
> @@ -67,11 +75,13 @@ AC_DEFUN([AC_HAVE_SENDFILE],
>  #
>  AC_DEFUN([AC_HAVE_GETMNTENT],
>    [ AC_MSG_CHECKING([for getmntent ])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #include <stdio.h>
>  #include <mntent.h>
> -    ], [
> -         getmntent(0);
> +	]], [[
> +getmntent(0);
> +	]])
>      ], have_getmntent=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -83,12 +93,14 @@ AC_DEFUN([AC_HAVE_GETMNTENT],
>  #
>  AC_DEFUN([AC_HAVE_FALLOCATE],
>    [ AC_MSG_CHECKING([for fallocate])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <fcntl.h>
>  #include <linux/falloc.h>
> -    ], [
> -         fallocate(0, 0, 0, 0);
> +	]], [[
> +fallocate(0, 0, 0, 0);
> +	]])
>      ], have_fallocate=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -100,13 +112,15 @@ AC_DEFUN([AC_HAVE_FALLOCATE],
>  #
>  AC_DEFUN([AC_HAVE_FIEMAP],
>    [ AC_MSG_CHECKING([for fiemap])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <linux/fs.h>
>  #include <linux/fiemap.h>
> -    ], [
> -         struct fiemap *fiemap;
> -         ioctl(0, FS_IOC_FIEMAP, (unsigned long)fiemap);
> +	]], [[
> +struct fiemap *fiemap;
> +ioctl(0, FS_IOC_FIEMAP, (unsigned long)fiemap);
> +	]])
>      ], have_fiemap=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -118,12 +132,14 @@ AC_DEFUN([AC_HAVE_FIEMAP],
>  #
>  AC_DEFUN([AC_HAVE_PREADV],
>    [ AC_MSG_CHECKING([for preadv])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _BSD_SOURCE
>  #define _DEFAULT_SOURCE
>  #include <sys/uio.h>
> -    ], [
> -         preadv(0, 0, 0, 0);
> +	]], [[
> +preadv(0, 0, 0, 0);
> +	]])
>      ], have_preadv=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -135,11 +151,13 @@ AC_DEFUN([AC_HAVE_PREADV],
>  #
>  AC_DEFUN([AC_HAVE_PWRITEV2],
>    [ AC_MSG_CHECKING([for pwritev2])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _BSD_SOURCE
>  #include <sys/uio.h>
> -    ], [
> -         pwritev2(0, 0, 0, 0, 0);
> +	]], [[
> +pwritev2(0, 0, 0, 0, 0);
> +	]])
>      ], have_pwritev2=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -151,12 +169,14 @@ AC_DEFUN([AC_HAVE_PWRITEV2],
>  #
>  AC_DEFUN([AC_HAVE_COPY_FILE_RANGE],
>    [ AC_MSG_CHECKING([for copy_file_range])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <sys/syscall.h>
>  #include <unistd.h>
> -    ], [
> -         syscall(__NR_copy_file_range, 0, 0, 0, 0, 0, 0);
> +	]], [[
> +syscall(__NR_copy_file_range, 0, 0, 0, 0, 0, 0);
> +	]])
>      ], have_copy_file_range=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -168,11 +188,13 @@ AC_DEFUN([AC_HAVE_COPY_FILE_RANGE],
>  #
>  AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
>    [ AC_MSG_CHECKING([for sync_file_range])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <fcntl.h>
> -    ], [
> -         sync_file_range(0, 0, 0, 0);
> +	]], [[
> +sync_file_range(0, 0, 0, 0);
> +	]])
>      ], have_sync_file_range=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -184,11 +206,13 @@ AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
>  #
>  AC_DEFUN([AC_HAVE_SYNCFS],
>    [ AC_MSG_CHECKING([for syncfs])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <unistd.h>
> -    ], [
> -         syncfs(0);
> +	]], [[
> +syncfs(0);
> +	]])
>      ], have_syncfs=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -200,10 +224,12 @@ AC_DEFUN([AC_HAVE_SYNCFS],
>  #
>  AC_DEFUN([AC_HAVE_READDIR],
>    [ AC_MSG_CHECKING([for readdir])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #include <dirent.h>
> -    ], [
> -         readdir(0);
> +	]], [[
> +readdir(0);
> +	]])
>      ], have_readdir=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -304,15 +330,17 @@ AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG],
>  #
>  AC_DEFUN([AC_HAVE_GETFSMAP],
>    [ AC_MSG_CHECKING([for GETFSMAP])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <sys/syscall.h>
>  #include <unistd.h>
>  #include <linux/fs.h>
>  #include <linux/fsmap.h>
> -    ], [
> -         unsigned long x = FS_IOC_GETFSMAP;
> -         struct fsmap_head fh;
> +	]], [[
> +unsigned long x = FS_IOC_GETFSMAP;
> +struct fsmap_head fh;
> +	]])
>      ], have_getfsmap=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -338,11 +366,13 @@ AC_DEFUN([AC_HAVE_STATFS_FLAGS],
>  #
>  AC_DEFUN([AC_HAVE_MAP_SYNC],
>    [ AC_MSG_CHECKING([for MAP_SYNC])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #include <asm-generic/mman.h>
>  #include <asm-generic/mman-common.h>
> -    ], [
> -        int flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> +	]], [[
> +int flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> +	]])
>      ], have_map_sync=yes
>  	AC_MSG_RESULT(yes),
>  	AC_MSG_RESULT(no))
> @@ -354,13 +384,15 @@ AC_DEFUN([AC_HAVE_MAP_SYNC],
>  #
>  AC_DEFUN([AC_HAVE_MALLINFO],
>    [ AC_MSG_CHECKING([for mallinfo ])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #include <malloc.h>
> -    ], [
> -         struct mallinfo test;
> +	]], [[
> +struct mallinfo test;
>  
> -         test.arena = 0; test.hblkhd = 0; test.uordblks = 0; test.fordblks = 0;
> -         test = mallinfo();
> +test.arena = 0; test.hblkhd = 0; test.uordblks = 0; test.fordblks = 0;
> +test = mallinfo();
> +	]])
>      ], have_mallinfo=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -400,10 +432,13 @@ AC_DEFUN([AC_HAVE_FSTATAT],
>  #
>  AC_DEFUN([AC_HAVE_SG_IO],
>    [ AC_MSG_CHECKING([for struct sg_io_hdr ])
> -    AC_TRY_COMPILE([#include <scsi/sg.h>],
> -    [
> -         struct sg_io_hdr hdr;
> -         ioctl(0, SG_IO, &hdr);
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
> +#include <scsi/sg.h>
> +	]], [[
> +struct sg_io_hdr hdr;
> +ioctl(0, SG_IO, &hdr);
> +	]])
>      ], have_sg_io=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -415,10 +450,13 @@ AC_DEFUN([AC_HAVE_SG_IO],
>  #
>  AC_DEFUN([AC_HAVE_HDIO_GETGEO],
>    [ AC_MSG_CHECKING([for struct hd_geometry ])
> -    AC_TRY_COMPILE([#include <linux/hdreg.h>],
> -    [
> -         struct hd_geometry hdr;
> -         ioctl(0, HDIO_GETGEO, &hdr);
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
> +#include <linux/hdreg.h>,
> +	]], [[
> +struct hd_geometry hdr;
> +ioctl(0, HDIO_GETGEO, &hdr);
> +	]])
>      ], have_hdio_getgeo=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> diff --git a/m4/package_types.m4 b/m4/package_types.m4
> index 1c35839319d6..6e817a310f79 100644
> --- a/m4/package_types.m4
> +++ b/m4/package_types.m4
> @@ -4,9 +4,11 @@
>  AH_TEMPLATE([HAVE_UMODE_T], [Whether you have umode_t])
>  AC_DEFUN([AC_TYPE_UMODE_T],
>    [ AC_MSG_CHECKING([for umode_t])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #include <asm/types.h>
> -    ], [
> -         umode_t umode;
> +	]], [[
> +umode_t umode;
> +	]])
>      ], AC_DEFINE(HAVE_UMODE_T) AC_MSG_RESULT(yes) , AC_MSG_RESULT(no))
>    ])
> diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> index f8e798b66136..ef116e0cda76 100644
> --- a/m4/package_urcu.m4
> +++ b/m4/package_urcu.m4
> @@ -10,11 +10,13 @@ AC_DEFUN([AC_PACKAGE_NEED_URCU_H],
>  
>  AC_DEFUN([AC_PACKAGE_NEED_RCU_INIT],
>    [ AC_MSG_CHECKING([for liburcu])
> -    AC_TRY_COMPILE([
> +    AC_COMPILE_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <urcu.h>
> -    ], [
> -       rcu_init();
> +	]], [[
> +rcu_init();
> +	]])
>      ], liburcu=-lurcu
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> @@ -28,12 +30,14 @@ AC_DEFUN([AC_PACKAGE_NEED_RCU_INIT],
>  #
>  AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
>    [ AC_MSG_CHECKING([for atomic64_t support in liburcu])
> -    AC_TRY_LINK([
> +    AC_LINK_IFELSE(
> +    [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <urcu.h>
> -    ], [
> -       long long f = 3;
> -       uatomic_inc(&f);
> +	]], [[
> +long long f = 3;
> +uatomic_inc(&f);
> +	]])
>      ], have_liburcu_atomic64=yes
>         AC_MSG_RESULT(yes),
>         AC_MSG_RESULT(no))
> -- 
> 2.35.1
> 
