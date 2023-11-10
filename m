Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E75C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 17:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjKJR6Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbjKJR40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 12:56:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2158939764
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 06:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699627231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YbY/ExOolu9c+QNO+25u+1iTHYBsG6uJEdRpQLfNoKw=;
        b=eTXopygvO/TBUxRczEN8wc8fGAlSuAD7eqwnpPfBQCLdH7LrfN27iCwzJldZkruPZ1hHKp
        LU/b6GSMqmmBxc9g6ISIh4H3fQF4lpstD0+NF3WfkCR/ggDKmxWnlhGx+fVtiMvF3NxISc
        sk9xSF6TWKgMGtXGgTyzekAq0G1lYp8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-flvIDmgLN0mSzlw-GzxaVg-1; Fri, 10 Nov 2023 09:40:29 -0500
X-MC-Unique: flvIDmgLN0mSzlw-GzxaVg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cc56cc8139so21625755ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 06:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699627228; x=1700232028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbY/ExOolu9c+QNO+25u+1iTHYBsG6uJEdRpQLfNoKw=;
        b=rnWtiKH/56bKG0vip40qYc9SiX1ZnysV+PolBEviJMLkSxQkZ9q36zmAKMZXSFINcs
         dIhogE+MEIT5ceLXjSgCH8ApesaqN+g+O4PBN7YPFCulK0FdaXAdkWP0/AxBgoJjHWwz
         FTchxiFQKt5bHVqWetvYev0+b6/a+Uw/8RIMGLsu79vwZv4sLO0GNTKj1IJTmw7c0p2n
         Rc0NcYVhT2efkKC3NpK5ih7pB2cJAC/lt7O4/sRIRvJP0vKpOISCPuKIaeLcHlMrzPZo
         afOQbe/BeOGcFUohVUIJ4LJjU2veOJ9ztzY2tExVG00nvgVIZNX62EucPS2GRcSD1Zby
         72Qw==
X-Gm-Message-State: AOJu0YzszYQQjtgII8FwKtEfBJwfjgR96FiHKeO2uzxgRQxK4kXQZR+L
        EgLsGbCUwjPE85a0c/1O/6w0huCv/ioDP3eujIrWFzo/W/Z0kL9CSWT2PDresGo1HNf6s7M+Hc7
        e//RF79pN6qoZp9Ax3NP7
X-Received: by 2002:a17:903:2281:b0:1cc:332f:9e4b with SMTP id b1-20020a170903228100b001cc332f9e4bmr3753185plh.1.1699627228555;
        Fri, 10 Nov 2023 06:40:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7HCLG+T2acY7pjZAAYvJ8tZDZXjXwF7QY+zo6+aNzSKnSqSRh62FYR0DZyajugNe1DUYyAQ==
X-Received: by 2002:a17:903:2281:b0:1cc:332f:9e4b with SMTP id b1-20020a170903228100b001cc332f9e4bmr3753161plh.1.1699627228230;
        Fri, 10 Nov 2023 06:40:28 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id az10-20020a170902a58a00b001cc615e6850sm5430949plb.90.2023.11.10.06.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Nov 2023 06:40:27 -0800 (PST)
Date:   Fri, 10 Nov 2023 22:40:19 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] generic: test reads racing with slow reflink
 operations
Message-ID: <20231110144019.4uonhyfqk44owdzq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <169947896328.203781.17647180888752123384.stgit@frogsfrogsfrogs>
 <169947896885.203781.13438458222742566484.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169947896885.203781.13438458222742566484.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 01:29:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS has a rather slow reflink operation.  While a reflink operation is
> running, other programs cannot read the contents of the source file,
> which is causing latency spikes.  Catherine Hoang wrote a patch to
> permit reads, since the source file contents do not change.  This is a
> functionality test for that patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  configure.ac              |    1 
>  include/builddefs.in      |    1 
>  m4/package_libcdev.m4     |   12 ++
>  src/Makefile              |    4 +
>  src/t_reflink_read_race.c |  339 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1953        |   74 ++++++++++
>  tests/generic/1953.out    |    6 +
>  7 files changed, 437 insertions(+)
>  create mode 100644 src/t_reflink_read_race.c
>  create mode 100755 tests/generic/1953
>  create mode 100644 tests/generic/1953.out
> 
> 
> diff --git a/configure.ac b/configure.ac
> index 4687d8a3c0..7333045330 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -71,6 +71,7 @@ AC_HAVE_BMV_OF_SHARED
>  AC_HAVE_NFTW
>  AC_HAVE_RLIMIT_NOFILE
>  AC_HAVE_FIEXCHANGE
> +AC_HAVE_FICLONE
>  
>  AC_CHECK_FUNCS([renameat2])
>  AC_CHECK_FUNCS([reallocarray])
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 969acf0da2..446350d5fc 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -73,6 +73,7 @@ HAVE_NFTW = @have_nftw@
>  HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
>  HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
>  HAVE_FIEXCHANGE = @have_fiexchange@
> +HAVE_FICLONE = @have_ficlone@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 7f73104405..91eb64db21 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -173,4 +173,16 @@ AC_DEFUN([AC_HAVE_FIEXCHANGE],
>      ]])],[have_fiexchange=yes
>         AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
>      AC_SUBST(have_fiexchange)
> +
> +# Check if we have FICLONE
> +AC_DEFUN([AC_HAVE_FICLONE],
> +  [ AC_MSG_CHECKING([for FICLONE])
> +    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
> +#include <sys/ioctl.h>
> +#include <linux/fs.h>
> +    ]], [[
> +	 ioctl(-1, FICLONE, -1);
> +    ]])],[have_ficlone=yes
> +       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
> +    AC_SUBST(have_ficlone)

I got below build error:
  libtoolize: Consider adding '-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
  cp include/install-sh .
  aclocal -I m4
  /usr/bin/m4:m4/package_libcdev.m4:162: ERROR: end of file in string
  autom4te: error: /usr/bin/m4 failed with exit status: 1
  aclocal: error: autom4te failed with exit status: 1
  make: *** [Makefile:66: configure] Error 1

I think you missed a "])" at here, below "])" belong to last AC_DEFUN.

>    ])
> diff --git a/src/Makefile b/src/Makefile
> index 2815f919b2..49dd2f6c1e 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -94,6 +94,10 @@ ifeq ($(HAVE_SEEK_DATA), yes)
>   endif
>  endif
>  
> +ifeq ($(HAVE_FICLONE),yes)
> +     TARGETS += t_reflink_read_race
> +endif
> +
>  CFILES = $(TARGETS:=.c)
>  LDIRT = $(TARGETS) fssum
>  

[snip]

> diff --git a/tests/generic/1953 b/tests/generic/1953
> new file mode 100755
> index 0000000000..058538e6fe
> --- /dev/null
> +++ b/tests/generic/1953
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 1953
> +#
> +# Race file reads with a very slow reflink operation to see if the reads
> +# actually complete while the reflink is ongoing.  This is a functionality
> +# test for XFS commit f3ba4762fa56 "xfs: allow read IO and FICLONE to run
> +# concurrently".
> +#
> +. ./common/preamble
> +_begin_fstest auto clone punch
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/reflink
> +
> +# real QA test starts here
> +_require_scratch_reflink
> +_require_cp_reflink
> +_require_xfs_io_command "fpunch"
> +_require_test_program "punch-alternating"
> +_require_test_program "t_reflink_read_race"
> +
> +rm -f "$seqres.full"
> +
> +echo "Format and mount"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount >> "$seqres.full" 2>&1
> +
> +testdir="$SCRATCH_MNT/test-$seq"
> +mkdir "$testdir"
> +
> +calc_space() {
> +	blocks_needed=$(( 2 ** (fnr + 1) ))
> +	space_needed=$((blocks_needed * blksz * 5 / 4))
> +}
> +
> +# Figure out the number of blocks that we need to get the reflink runtime above
> +# 1 seconds
> +echo "Create a many-block file"
> +for ((fnr = 1; fnr < 40; fnr++)); do
> +	free_blocks=$(stat -f -c '%a' "$testdir")
> +	blksz=$(_get_file_block_size "$testdir")
> +	space_avail=$((free_blocks * blksz))
> +	calc_space
> +	test $space_needed -gt $space_avail && \
> +		_notrun "Insufficient space for stress test; would only create $blocks_needed extents."
> +
> +	off=$(( (2 ** fnr) * blksz))
> +	$XFS_IO_PROG -f -c "pwrite -S 0x61 -b 4194304 $off $off" "$testdir/file1" >> "$seqres.full"
> +	"$here/src/punch-alternating" "$testdir/file1" >> "$seqres.full"
> +
> +	timeout 1s cp --reflink=always "$testdir/file1" "$testdir/garbage" || break

To make sure we have this program:
  _require_command "$TIMEOUT_PROG" timeout
then use $TIMEOUT_PROG at here.

Others looks good to me, if it expects to get below failure on linux 6.6.0-rc6+.

# ./check generic/1953
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
MKFS_OPTIONS  -- -f /dev/loop0
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop0 /mnt/scratch

generic/1953       - output mismatch (see /root/git/xfstests/results//generic/1953.out.bad)
    --- tests/generic/1953.out  2023-11-10 22:22:12.379185281 +0800
    +++ /root/git/xfstests/results//generic/1953.out.bad        2023-11-10 22:28:27.041801352 +0800
    @@ -3,4 +3,4 @@
     Create a many-block file
     Reflink the big file
     Terminated
    -test completed successfully
    +clone finished before any reads
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/1953.out /root/git/xfstests/results//generic/1953.out.bad'  to see the entire diff)
Ran: generic/1953
Failures: generic/1953
Failed 1 of 1 tests

Thanks,
Zorro

> +done
> +echo "fnr=$fnr" >> $seqres.full
> +
> +echo "Reflink the big file"
> +$here/src/t_reflink_read_race "$testdir/file1" "$testdir/file2" \
> +	"$testdir/outcome" &>> $seqres.full
> +
> +if [ ! -e "$testdir/outcome" ]; then
> +	echo "Could not set up program"
> +elif grep -q "finished read early" "$testdir/outcome"; then
> +	echo "test completed successfully"
> +else
> +	cat "$testdir/outcome"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1953.out b/tests/generic/1953.out
> new file mode 100644
> index 0000000000..8eaacb7ff0
> --- /dev/null
> +++ b/tests/generic/1953.out
> @@ -0,0 +1,6 @@
> +QA output created by 1953
> +Format and mount
> +Create a many-block file
> +Reflink the big file
> +Terminated
> +test completed successfully
> 

