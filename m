Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149BCC636CC
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Feb 2023 12:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBEM6p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Feb 2023 07:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBEM6o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Feb 2023 07:58:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E99B126F0
        for <linux-xfs@vger.kernel.org>; Sun,  5 Feb 2023 04:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675601875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JBu12n/q16esg6pYfz/C67li5XvHm8bgkb9OORnA5jk=;
        b=VoHgbgQvybhcXhXPHGVIdj1qCFbiwCkyaqR4tSsT7UcXDrgfBjqBZ1+mWvgzU5Grnteb3E
        pRb2czT/g0g7fwhQs+Ayip6Y9Oi04m3f54GGx/EVsSaYGKc0mtYgxCBBD6gkplPzFTfW3c
        itod/RhDOPP2hiwALin3r/GLTpeuoss=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-577-sgB1MMR8PMqNg_ewMU_c9Q-1; Sun, 05 Feb 2023 07:57:54 -0500
X-MC-Unique: sgB1MMR8PMqNg_ewMU_c9Q-1
Received: by mail-pf1-f198.google.com with SMTP id h11-20020a056a00230b00b00593b9e6ee79so5051346pfh.8
        for <linux-xfs@vger.kernel.org>; Sun, 05 Feb 2023 04:57:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JBu12n/q16esg6pYfz/C67li5XvHm8bgkb9OORnA5jk=;
        b=C0zuGYbpYUszC7GOGS8jVq0b6TFQmGk4A3jL/ul2G18uERqTzHfBzK8ThayUyp+p0m
         I4RussXMBJSSphBqRyXl8owozBWlt01m1ctnIvzcL0cUh2mdJX3RlSy8WKFyBg53G/+s
         hXekmOqtqRptouwewEaMWCilLVccTXhigquwUxt2v51DPEW5Ax++oPi0atOTd6g755w+
         vUvPjwERRHXq+6ihH+4vj/c3lJ+ebi2zeNxvQYo0XQbc5GStjzclSLKR88QABLlOf7Vg
         wuGO738pWFY78dQ6nDHxAIxwOXiRUcUAmob4uMLYoBr6JwjaDPvXRWheRm64kQo8eNwJ
         xk4w==
X-Gm-Message-State: AO0yUKXzEhbI3tHp7nk2dqh19sUEKE1dwaZK4XwBmhIkmgvHd1nf/cNO
        lDNKQwYC+I9bvt/uyqaIZ2FtgtF/G9lYdOo/qbjRLJwYAXg/dbIKWfxRFIAHlXgBySLhD/X4aNM
        K/ChJAbUoP8olhNs1wklZ
X-Received: by 2002:a17:902:c943:b0:196:5787:d73a with SMTP id i3-20020a170902c94300b001965787d73amr20077690pla.53.1675601872583;
        Sun, 05 Feb 2023 04:57:52 -0800 (PST)
X-Google-Smtp-Source: AK7set9nSqdRcN7v7fZcfvWsTX6xy0xcXeYi7SFg92cXoAmb/rEKv1b2oNdjkfu3jhMW1XT35t1NsQ==
X-Received: by 2002:a17:902:c943:b0:196:5787:d73a with SMTP id i3-20020a170902c94300b001965787d73amr20077674pla.53.1675601872161;
        Sun, 05 Feb 2023 04:57:52 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709029a9300b00186b69157ecsm4856432plp.202.2023.02.05.04.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Feb 2023 04:57:51 -0800 (PST)
Date:   Sun, 5 Feb 2023 20:57:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] fuzzy: add a custom xfs find utility for scrub
 stress tests
Message-ID: <20230205125747.ehig3b5ahyxgiuzq@zlang-mailbox>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
 <167243874650.722028.10607547751700517177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243874650.722028.10607547751700517177.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new find(1) like utility that doesn't crash on directory tree
> changes (like find does due to bugs in its loop detector) and actually
> implements the custom xfs attribute predicates that we need for scrub
> stress tests.  This program will be needed for a future patch where we
> add stress tests for scrub and repair of file metadata.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  configure.ac          |    5 +
>  include/builddefs.in  |    4 +
>  m4/package_libcdev.m4 |   47 ++++++++
>  m4/package_xfslibs.m4 |   16 +++
>  src/Makefile          |   10 ++
>  src/xfsfind.c         |  290 +++++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 372 insertions(+)
>  create mode 100644 src/xfsfind.c
> 
> 
> diff --git a/configure.ac b/configure.ac
> index cbf8377988..e92bd6b26d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -66,6 +66,11 @@ AC_PACKAGE_WANT_LINUX_FS_H
>  AC_PACKAGE_WANT_LIBBTRFSUTIL
>  
>  AC_HAVE_COPY_FILE_RANGE
> +AC_HAVE_SEEK_DATA
> +AC_HAVE_BMV_OF_SHARED
> +AC_HAVE_NFTW
> +AC_HAVE_RLIMIT_NOFILE
> +
>  AC_CHECK_FUNCS([renameat2])
>  AC_CHECK_FUNCS([reallocarray])
>  AC_CHECK_TYPES([struct mount_attr], [], [], [[#include <linux/mount.h>]])
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 6641209f81..dab10c968f 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -68,6 +68,10 @@ HAVE_FIEMAP = @have_fiemap@
>  HAVE_FALLOCATE = @have_fallocate@
>  HAVE_COPY_FILE_RANGE = @have_copy_file_range@
>  HAVE_LIBBTRFSUTIL = @have_libbtrfsutil@
> +HAVE_SEEK_DATA = @have_seek_data@
> +HAVE_NFTW = @have_nftw@
> +HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
> +HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 5c76c0f73e..e1b381c16f 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -110,3 +110,50 @@ AC_DEFUN([AC_HAVE_COPY_FILE_RANGE],
>      AC_SUBST(have_copy_file_range)
>    ])
>  
> +# Check if we have SEEK_DATA
> +AC_DEFUN([AC_HAVE_SEEK_DATA],
> +  [ AC_MSG_CHECKING([for SEEK_DATA])
> +    AC_TRY_LINK([

The AC_TRY_LINK is obsolete by autoconf, refer to:
https://www.gnu.org/software/autoconf/manual/autoconf-2.69/html_node/Obsolete-Macros.html

So as the suggestion of above link, we'd better to replace:
          Macro: AC_TRY_LINK (includes, function-body, [action-if-true], [action-if-false])
with:
          AC_LINK_IFELSE(
            [AC_LANG_PROGRAM([[includes]],
               [[function-body]])],
            [action-if-true],
            [action-if-false])

For example (hope it's right:)

diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index e1b381c1..7f1767a4 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -113,13 +113,13 @@ AC_DEFUN([AC_HAVE_COPY_FILE_RANGE],
 # Check if we have SEEK_DATA
 AC_DEFUN([AC_HAVE_SEEK_DATA],
   [ AC_MSG_CHECKING([for SEEK_DATA])
-    AC_TRY_LINK([
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
 #define _GNU_SOURCE
 #include <sys/types.h>
 #include <unistd.h>
-    ], [
+    ]], [[
          lseek(-1, 0, SEEK_DATA);
-    ], have_seek_data=yes
+    ]])], have_seek_data=yes
        AC_MSG_RESULT(yes),
        AC_MSG_RESULT(no))
     AC_SUBST(have_seek_data)

> +#define _GNU_SOURCE
> +#include <sys/types.h>
> +#include <unistd.h>
> +    ], [
> +         lseek(-1, 0, SEEK_DATA);
> +    ], have_seek_data=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_seek_data)
> +  ])
> +
> +# Check if we have nftw
> +AC_DEFUN([AC_HAVE_NFTW],
> +  [ AC_MSG_CHECKING([for nftw])
> +    AC_TRY_LINK([

Same as above

> +#define _GNU_SOURCE
> +#include <stddef.h>
> +#include <ftw.h>
> +    ], [
> +         nftw("/", (int (*)(const char *, const struct stat *, int, struct FTW *))1, 0, 0);
> +    ], have_nftw=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_nftw)
> +  ])
> +
> +# Check if we have RLIMIT_NOFILE
> +AC_DEFUN([AC_HAVE_RLIMIT_NOFILE],
> +  [ AC_MSG_CHECKING([for RLIMIT_NOFILE])
> +    AC_TRY_LINK([

Same as above

> +#define _GNU_SOURCE
> +#include <sys/time.h>
> +#include <sys/resource.h>
> +    ], [
> +         struct rlimit rlimit;
> +
> +         rlimit.rlim_cur = 0;
> +         getrlimit(RLIMIT_NOFILE, &rlimit);
> +    ], have_rlimit_nofile=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_rlimit_nofile)
> +  ])
> diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
> index 0746cd1dc5..479f30a29b 100644
> --- a/m4/package_xfslibs.m4
> +++ b/m4/package_xfslibs.m4
> @@ -104,3 +104,19 @@ AC_DEFUN([AC_PACKAGE_NEED_XFSCTL_MACRO],
>          exit 1
>        ])
>    ])
> +
> +# Check if we have BMV_OF_SHARED from the GETBMAPX ioctl
> +AC_DEFUN([AC_HAVE_BMV_OF_SHARED],
> +  [ AC_MSG_CHECKING([for BMV_OF_SHARED])
> +    AC_TRY_LINK([

Same as above

Thanks,
Zorro

> +#define _GNU_SOURCE
> +#include <xfs/xfs.h>
> +    ], [
> +         struct getbmapx obj;
> +         ioctl(-1, XFS_IOC_GETBMAPX, &obj);
> +         obj.bmv_oflags |= BMV_OF_SHARED;
> +    ], have_bmv_of_shared=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_bmv_of_shared)
> +  ])
> diff --git a/src/Makefile b/src/Makefile
> index afdf6b30c5..7807ca89a5 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -83,6 +83,16 @@ ifeq ($(HAVE_LIBCAP), true)
>  LLDLIBS += -lcap
>  endif
>  
> +ifeq ($(HAVE_SEEK_DATA), yes)
> + ifeq ($(HAVE_NFTW), yes)
> +  ifeq ($(HAVE_BMV_OF_SHARED), yes)
> +   ifeq ($(HAVE_RLIMIT_NOFILE), yes)
> +     TARGETS += xfsfind
> +   endif
> +  endif
> + endif
> +endif
> +
>  CFILES = $(TARGETS:=.c)
>  LDIRT = $(TARGETS) fssum
>  
> diff --git a/src/xfsfind.c b/src/xfsfind.c
> new file mode 100644
> index 0000000000..6b0a93e793
> --- /dev/null
> +++ b/src/xfsfind.c
> @@ -0,0 +1,290 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * find(1) but with special predicates for finding XFS attributes.
> + * Copyright (C) 2022 Oracle.
> + */
> +#include <sys/time.h>
> +#include <sys/resource.h>
> +#include <sys/types.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <ftw.h>
> +#include <linux/fs.h>
> +#include <xfs/xfs.h>
> +
> +#include "global.h"
> +
> +static int want_anyfile;
> +static int want_datafile;
> +static int want_attrfile;
> +static int want_dir;
> +static int want_regfile;
> +static int want_sharedfile;
> +static int report_errors = 1;
> +
> +static int
> +check_datafile(
> +	const char		*path,
> +	int			fd)
> +{
> +	off_t			off;
> +
> +	off = lseek(fd, 0, SEEK_DATA);
> +	if (off >= 0)
> +		return 1;
> +
> +	if (errno == ENXIO)
> +		return 0;
> +
> +	if (report_errors)
> +		perror(path);
> +
> +	return -1;
> +}
> +
> +static int
> +check_attrfile(
> +	const char		*path,
> +	int			fd)
> +{
> +	struct fsxattr		fsx;
> +	int			ret;
> +
> +	ret = ioctl(fd, XFS_IOC_FSGETXATTR, &fsx);
> +	if (ret) {
> +		if (report_errors)
> +			perror(path);
> +		return -1;
> +	}
> +
> +	if (want_attrfile && (fsx.fsx_xflags & XFS_XFLAG_HASATTR))
> +		return 1;
> +	return 0;
> +}
> +
> +#define BMAP_NR			33
> +static struct getbmapx		bmaps[BMAP_NR];
> +
> +static int
> +check_sharedfile(
> +	const char		*path,
> +	int			fd)
> +{
> +	struct getbmapx		*key = &bmaps[0];
> +	unsigned int		i;
> +	int			ret;
> +
> +	memset(key, 0, sizeof(struct getbmapx));
> +	key->bmv_length = ULLONG_MAX;
> +	/* no holes and don't flush dirty pages */
> +	key->bmv_iflags = BMV_IF_DELALLOC | BMV_IF_NO_HOLES;
> +	key->bmv_count = BMAP_NR;
> +
> +	while ((ret = ioctl(fd, XFS_IOC_GETBMAPX, bmaps)) == 0) {
> +		struct getbmapx	*p = &bmaps[1];
> +		xfs_off_t	new_off;
> +
> +		for (i = 0; i < key->bmv_entries; i++, p++) {
> +			if (p->bmv_oflags & BMV_OF_SHARED)
> +				return 1;
> +		}
> +
> +		if (key->bmv_entries == 0)
> +			break;
> +		p = key + key->bmv_entries;
> +		if (p->bmv_oflags & BMV_OF_LAST)
> +			return 0;
> +
> +		new_off = p->bmv_offset + p->bmv_length;
> +		key->bmv_length -= new_off - key->bmv_offset;
> +		key->bmv_offset = new_off;
> +	}
> +	if (ret < 0) {
> +		if (report_errors)
> +			perror(path);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void
> +print_help(
> +	const char		*name)
> +{
> +	printf("Usage: %s [OPTIONS] path\n", name);
> +	printf("\n");
> +	printf("Print all file paths matching any of the given predicates.\n");
> +	printf("\n");
> +	printf("-a	Match files with xattrs.\n");
> +	printf("-b	Match files with data blocks.\n");
> +	printf("-d	Match directories.\n");
> +	printf("-q	Ignore errors while walking directory tree.\n");
> +	printf("-r	Match regular files.\n");
> +	printf("-s	Match files with shared blocks.\n");
> +	printf("\n");
> +	printf("If no matching options are given, match all files found.\n");
> +}
> +
> +static int
> +visit(
> +	const char		*path,
> +	const struct stat	*sb,
> +	int			typeflag,
> +	struct FTW		*ftwbuf)
> +{
> +	int			printme = 1;
> +	int			fd = -1;
> +	int			retval = FTW_CONTINUE;
> +
> +	if (want_anyfile)
> +		goto out;
> +	if (want_regfile && typeflag == FTW_F)
> +		goto out;
> +	if (want_dir && typeflag == FTW_D)
> +		goto out;
> +
> +	/*
> +	 * We can only open directories and files; screen out everything else.
> +	 * Note that nftw lies and reports FTW_F for device files, so check the
> +	 * statbuf mode too.
> +	 */
> +	if (typeflag != FTW_F && typeflag != FTW_D) {
> +		printme = 0;
> +		goto out;
> +	}
> +
> +	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode)) {
> +		printme = 0;
> +		goto out;
> +	}
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0) {
> +		if (report_errors) {
> +			perror(path);
> +			return FTW_STOP;
> +		}
> +
> +		return FTW_CONTINUE;
> +	}
> +
> +	if (want_datafile && typeflag == FTW_F) {
> +		int ret = check_datafile(path, fd);
> +		if (ret < 0 && report_errors) {
> +			printme = 0;
> +			retval = FTW_STOP;
> +			goto out_fd;
> +		}
> +
> +		if (ret == 1)
> +			goto out_fd;
> +	}
> +
> +	if (want_attrfile) {
> +		int ret = check_attrfile(path, fd);
> +		if (ret < 0 && report_errors) {
> +			printme = 0;
> +			retval = FTW_STOP;
> +			goto out_fd;
> +		}
> +
> +		if (ret == 1)
> +			goto out_fd;
> +	}
> +
> +	if (want_sharedfile) {
> +		int ret = check_sharedfile(path, fd);
> +		if (ret < 0 && report_errors) {
> +			printme = 0;
> +			retval = FTW_STOP;
> +			goto out_fd;
> +		}
> +
> +		if (ret == 1)
> +			goto out_fd;
> +	}
> +
> +	printme = 0;
> +out_fd:
> +	close(fd);
> +out:
> +	if (printme)
> +		printf("%s\n", path);
> +	return retval;
> +}
> +
> +static void
> +handle_sigabrt(
> +	int		signal,
> +	siginfo_t	*info,
> +	void		*ucontext)
> +{
> +	fprintf(stderr, "Signal %u, exiting.\n", signal);
> +	exit(2);
> +}
> +
> +int
> +main(
> +	int			argc,
> +	char			*argv[])
> +{
> +	struct rlimit		rlimit;
> +	struct sigaction	abrt = {
> +		.sa_sigaction	= handle_sigabrt,
> +		.sa_flags	= SA_SIGINFO,
> +	};
> +	int			c;
> +	int			ret;
> +
> +	while ((c = getopt(argc, argv, "abdqrs")) >= 0) {
> +		switch (c) {
> +		case 'a':	want_attrfile = 1;   break;
> +		case 'b':	want_datafile = 1;   break;
> +		case 'd':	want_dir = 1;        break;
> +		case 'q':	report_errors = 0;   break;
> +		case 'r':	want_regfile = 1;    break;
> +		case 's':	want_sharedfile = 1; break;
> +		default:
> +			print_help(argv[0]);
> +			return 1;
> +		}
> +	}
> +
> +	ret = getrlimit(RLIMIT_NOFILE, &rlimit);
> +	if (ret) {
> +		perror("RLIMIT_NOFILE");
> +		return 1;
> +	}
> +
> +	if (!want_attrfile && !want_datafile && !want_dir && !want_regfile &&
> +	    !want_sharedfile)
> +		want_anyfile = 1;
> +
> +	/*
> +	 * nftw is known to abort() if a directory it is walking disappears out
> +	 * from under it.  Handle this with grace if the caller wants us to run
> +	 * quietly.
> +	 */
> +	if (!report_errors) {
> +		ret = sigaction(SIGABRT, &abrt, NULL);
> +		if (ret) {
> +			perror("SIGABRT handler");
> +			return 1;
> +		}
> +	}
> +
> +	for (c = optind; c < argc; c++) {
> +		ret = nftw(argv[c], visit, rlimit.rlim_cur - 5,
> +				FTW_ACTIONRETVAL | FTW_CHDIR | FTW_MOUNT |
> +				FTW_PHYS);
> +		if (ret && report_errors) {
> +			perror(argv[c]);
> +			break;
> +		}
> +	}
> +
> +	if (ret)
> +		return 1;
> +	return 0;
> +}
> 

