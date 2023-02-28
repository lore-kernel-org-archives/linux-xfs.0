Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71EBC7EE2E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Feb 2023 01:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjB1B4Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Feb 2023 20:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjB1B4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2023 20:56:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F21A66A
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 17:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677549335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1+6mGWPsCO3IWrFa98JJlqYPD/D0nP40q9U3Bm8Cpyo=;
        b=O0RQWyRYj+t1FrJjLT5VbJrqXQEYHowrFLEqdTUcCEHLzgg0SdBgFUqsRwmm/SNV1lto4H
        UUaDyXsVwiQx5NDnwhvHDI3D6ia+RBxxpR076hXHMsR3JGQUGrChhz88ZKfO0QAqUVOL+p
        XGFgySIQ83iEOINa6cpjuvXQcZpHNqA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-281-8LNXcUonMmO4FgXLH0fDYA-1; Mon, 27 Feb 2023 20:55:34 -0500
X-MC-Unique: 8LNXcUonMmO4FgXLH0fDYA-1
Received: by mail-pj1-f69.google.com with SMTP id q61-20020a17090a1b4300b00237d2fb8400so3688370pjq.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 17:55:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1+6mGWPsCO3IWrFa98JJlqYPD/D0nP40q9U3Bm8Cpyo=;
        b=jHrAhSwWk6N0mHmjv4GgRCKR9yn7Uum0qUu9fLhtMZcyGwGN03APuee+Q266Vn2EeF
         E7KH+KzazI3HydIWIntRA75d4k1qNtt+1ARPGC7RLrgW8UGuhSnM9RpYsuHo9PF1bB7a
         1/HirOFhWNSXhy9H5VoEPRq7GePlE+k8V+EmTlfwMLQLmkT7yNjX4jKqvnnOJFfRDvJD
         nm25o9RI6s1JGiMx7Jg9O+d9QWTtTVO5jUKsjEDWce5g+Zw7zF8hTM8RAkH/Z2l2Yc1m
         ECyGw4DeawnQO3P40SuXvHBtrv+Q67513/tq4K/2cN1pqqAb7Z12viM6Gazj5dLFHSsx
         Aaqw==
X-Gm-Message-State: AO0yUKUKIP2o+QV43jgcnpUhRsL9L9BN88p5v0oyR+aHJexU1lBy0+nf
        XJ0Da23L62hCzElGdZI9CHffLlqFAwBYpAThvaCk3tCM55QUnBng088IMViiEFDlYipTqetDMKv
        KxOUiaUwzA6X+OwOeXcTk
X-Received: by 2002:a17:902:ce8f:b0:19d:181f:511 with SMTP id f15-20020a170902ce8f00b0019d181f0511mr1160499plg.30.1677549332822;
        Mon, 27 Feb 2023 17:55:32 -0800 (PST)
X-Google-Smtp-Source: AK7set9pGSpF8Pnja11dlEN8lTTyBYUD7kc1iBpNQKpbjj5zvzKMpTD+9hIIkA6+Ob6tTorUJ54B9w==
X-Received: by 2002:a17:902:ce8f:b0:19d:181f:511 with SMTP id f15-20020a170902ce8f00b0019d181f0511mr1160479plg.30.1677549332362;
        Mon, 27 Feb 2023 17:55:32 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902a38e00b0019607984a5esm5236437pla.95.2023.02.27.17.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 17:55:31 -0800 (PST)
Date:   Tue, 28 Feb 2023 09:55:28 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/7] fsx: support FIEXCHANGE_RANGE
Message-ID: <20230228015528.a4z542srffjwzzd7@zlang-mailbox>
References: <167243878818.732172.6392253687008406885.stgit@magnolia>
 <167243878899.732172.1539601356241657286.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243878899.732172.1539601356241657286.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Upgrade fsx to support exchanging file contents.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Hi Darrick,

I've merged most of patches of [NYE DELUGE 2/4], now I'm trying to merge
the rest of it this time.

This patch will get build warning [1] from autoconf, can you rebase this patch
to current for-next branch, and use autoupdate to update the configure.ac
and lib/autoconf/general.m4 ?

Thanks,
Zorro

[1]
autoconf
configure.ac:73: warning: The macro `AC_TRY_LINK' is obsolete.
configure.ac:73: You should run autoupdate.
./lib/autoconf/general.m4:2920: AC_TRY_LINK is expanded from...
m4/package_libcdev.m4:161: AC_HAVE_FIEXCHANGE is expanded from...
configure.ac:73: the top level
./configure \   
                --libexecdir=/usr/lib \
                --exec_prefix=/var/lib

>  configure.ac          |    1 
>  include/builddefs.in  |    1 
>  ltp/Makefile          |    4 +
>  ltp/fsx.c             |  160 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  m4/package_libcdev.m4 |   21 ++++++
>  src/fiexchange.h      |  101 +++++++++++++++++++++++++++++++
>  src/global.h          |    6 ++
>  7 files changed, 292 insertions(+), 2 deletions(-)
>  create mode 100644 src/fiexchange.h
> 
> 
> diff --git a/configure.ac b/configure.ac
> index e92bd6b26d..4687d8a3c0 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -70,6 +70,7 @@ AC_HAVE_SEEK_DATA
>  AC_HAVE_BMV_OF_SHARED
>  AC_HAVE_NFTW
>  AC_HAVE_RLIMIT_NOFILE
> +AC_HAVE_FIEXCHANGE

[snip]

>  	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
>  
>  	while ((ch = getopt_long(argc, argv,
> -				 "b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",
> +				 "0b:c:dfg:i:j:kl:m:no:p:qr:s:t:w:xyABD:EFJKHzCILN:OP:RS:UWXZ",

Looks like we nearly used up most of letters for fsx, to avoid some operations.

Maybe we can use a single option (e.g. -a means avoid) and suboptions to
help that. For example "-a xchg_range,clone_range,dedupe_range" to avoid
these 3 operations. Or use long option, e.g. --no-xchg-range, --no-clone-range
to replace short ones.

What do you think? (Anyway, that's not the problem of this patch)

Thanks,
Zorro

>  				 longopts, NULL)) != EOF)
>  		switch (ch) {
>  		case 'b':
> @@ -2747,6 +2898,9 @@ main(int argc, char **argv)
>  		case 'I':
>  			insert_range_calls = 0;
>  			break;
> +		case '0':
> +			xchg_range_calls = 0;
> +			break;
>  		case 'J':
>  			clone_range_calls = 0;
>  			break;
> @@ -2988,6 +3142,8 @@ main(int argc, char **argv)
>  		dedupe_range_calls = test_dedupe_range();
>  	if (copy_range_calls)
>  		copy_range_calls = test_copy_range();
> +	if (xchg_range_calls)
> +		xchg_range_calls = test_xchg_range();
>  
>  	while (numops == -1 || numops--)
>  		if (!test())
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index e1b381c16f..db663970c2 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -157,3 +157,24 @@ AC_DEFUN([AC_HAVE_RLIMIT_NOFILE],
>         AC_MSG_RESULT(no))
>      AC_SUBST(have_rlimit_nofile)
>    ])
> +
> +#
> +# Check if we have a FIEXCHANGE_RANGE ioctl (Linux)
> +#
> +AC_DEFUN([AC_HAVE_FIEXCHANGE],
> +  [ AC_MSG_CHECKING([for FIEXCHANGE_RANGE])
> +    AC_TRY_LINK([
> +#define _GNU_SOURCE
> +#include <sys/syscall.h>
> +#include <sys/ioctl.h>
> +#include <unistd.h>
> +#include <linux/fs.h>
> +#include <linux/fiexchange.h>
> +    ], [
> +         struct file_xchg_range fxr;
> +         ioctl(-1, FIEXCHANGE_RANGE, &fxr);
> +    ], have_fiexchange=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_fiexchange)
> +  ])
> diff --git a/src/fiexchange.h b/src/fiexchange.h
> new file mode 100644
> index 0000000000..29b3ac0ff5
> --- /dev/null
> +++ b/src/fiexchange.h
> @@ -0,0 +1,101 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
> +/*
> + * FIEXCHANGE ioctl definitions, to facilitate exchanging parts of files.
> + *
> + * Copyright (C) 2022 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <djwong@kernel.org>
> + */
> +#ifndef _LINUX_FIEXCHANGE_H
> +#define _LINUX_FIEXCHANGE_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * Exchange part of file1 with part of the file that this ioctl that is being
> + * called against (which we'll call file2).  Filesystems must be able to
> + * restart and complete the operation even after the system goes down.
> + */
> +struct file_xchg_range {
> +	__s64		file1_fd;
> +	__s64		file1_offset;	/* file1 offset, bytes */
> +	__s64		file2_offset;	/* file2 offset, bytes */
> +	__s64		length;		/* bytes to exchange */
> +
> +	__u64		flags;		/* see FILE_XCHG_RANGE_* below */
> +
> +	/* file2 metadata for optional freshness checks */
> +	__s64		file2_ino;	/* inode number */
> +	__s64		file2_mtime;	/* modification time */
> +	__s64		file2_ctime;	/* change time */
> +	__s32		file2_mtime_nsec; /* mod time, nsec */
> +	__s32		file2_ctime_nsec; /* change time, nsec */
> +
> +	__u64		pad[6];		/* must be zeroes */
> +};
> +
> +/*
> + * Atomic exchange operations are not required.  This relaxes the requirement
> + * that the filesystem must be able to complete the operation after a crash.
> + */
> +#define FILE_XCHG_RANGE_NONATOMIC	(1 << 0)
> +
> +/*
> + * Check that file2's inode number, mtime, and ctime against the values
> + * provided, and return -EBUSY if there isn't an exact match.
> + */
> +#define FILE_XCHG_RANGE_FILE2_FRESH	(1 << 1)
> +
> +/*
> + * Check that the file1's length is equal to file1_offset + length, and that
> + * file2's length is equal to file2_offset + length.  Returns -EDOM if there
> + * isn't an exact match.
> + */
> +#define FILE_XCHG_RANGE_FULL_FILES	(1 << 2)
> +
> +/*
> + * Exchange file data all the way to the ends of both files, and then exchange
> + * the file sizes.  This flag can be used to replace a file's contents with a
> + * different amount of data.  length will be ignored.
> + */
> +#define FILE_XCHG_RANGE_TO_EOF		(1 << 3)
> +
> +/* Flush all changes in file data and file metadata to disk before returning. */
> +#define FILE_XCHG_RANGE_FSYNC		(1 << 4)
> +
> +/* Dry run; do all the parameter verification but do not change anything. */
> +#define FILE_XCHG_RANGE_DRY_RUN		(1 << 5)
> +
> +/*
> + * Do not exchange any part of the range where file1's mapping is a hole.  This
> + * can be used to emulate scatter-gather atomic writes with a temp file.
> + */
> +#define FILE_XCHG_RANGE_SKIP_FILE1_HOLES (1 << 6)
> +
> +/*
> + * Commit the contents of file1 into file2 if file2 has the same inode number,
> + * mtime, and ctime as the arguments provided to the call.  The old contents of
> + * file2 will be moved to file1.
> + *
> + * With this flag, all committed information can be retrieved even if the
> + * system crashes or is rebooted.  This includes writing through or flushing a
> + * disk cache if present.  The call blocks until the device reports that the
> + * commit is complete.
> + *
> + * This flag should not be combined with NONATOMIC.  It can be combined with
> + * SKIP_FILE1_HOLES.
> + */
> +#define FILE_XCHG_RANGE_COMMIT		(FILE_XCHG_RANGE_FILE2_FRESH | \
> +					 FILE_XCHG_RANGE_FSYNC)
> +
> +#define FILE_XCHG_RANGE_ALL_FLAGS	(FILE_XCHG_RANGE_NONATOMIC | \
> +					 FILE_XCHG_RANGE_FILE2_FRESH | \
> +					 FILE_XCHG_RANGE_FULL_FILES | \
> +					 FILE_XCHG_RANGE_TO_EOF | \
> +					 FILE_XCHG_RANGE_FSYNC | \
> +					 FILE_XCHG_RANGE_DRY_RUN | \
> +					 FILE_XCHG_RANGE_SKIP_FILE1_HOLES)
> +
> +#define FIEXCHANGE_RANGE	_IOWR('X', 129, struct file_xchg_range)
> +
> +#endif /* _LINUX_FIEXCHANGE_H */
> diff --git a/src/global.h b/src/global.h
> index b44070993c..49570ef117 100644
> --- a/src/global.h
> +++ b/src/global.h
> @@ -171,6 +171,12 @@
>  #include <sys/mman.h>
>  #endif
>  
> +#ifdef HAVE_FIEXCHANGE
> +# include <linux/fiexchange.h>
> +#else
> +# include "fiexchange.h"
> +#endif
> +
>  static inline unsigned long long
>  rounddown_64(unsigned long long x, unsigned int y)
>  {
> 

