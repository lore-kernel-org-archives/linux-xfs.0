Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815A0C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1343920825
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rC6mHbWV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgJ2JKq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgJ2JKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:10:46 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204B0C0613CF;
        Thu, 29 Oct 2020 02:10:46 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p17so975871pli.13;
        Thu, 29 Oct 2020 02:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zZFuZNmkPVlh7SwgTnJjmTmVGpj4LnR9d6uIP1gV0uM=;
        b=rC6mHbWVWMASvBVGcdDDfbZsUnM1IGBQIiQ1Ah8iViGdfIeEFGhDO4MVXuCAv2Hgro
         wuaTarpzqDJ0pxYpHnkx8O0E5Kn9x1I30HNlCkb2mvbkBpnx8LQDhYaem45kPU91Qesc
         HsnV6oTQZI7Ke8zrJH/ux6+CeOV8QHfRnZR4IUpBDwjki+0bHpKfnfE/R+WG7LH7FK3S
         xKxm3i52Dc18gsgl+9+tYmCaQkupsmXNfifS3RtWfzKBr2yr4eer8r6f0mofUt43LDWt
         qrHatWZ0YaK8MSfERFEAiX9yq3qE6WZR75BjPgzpUrQ7oEKxGB3MGmCzEirH6AiEbYur
         VWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zZFuZNmkPVlh7SwgTnJjmTmVGpj4LnR9d6uIP1gV0uM=;
        b=AHDnrOStkDx40QGeE85NtqDadx98wj+SYnnY0BlSdqvHVIRisBqnuOYEnieUIzSTBb
         ZEV2T1auv2spPwA2c2ej1oPA9idQLGbOLaSpu4uembjM9y/qqZpAslBXtYybDdrlwVl2
         YukaeOmKwBxCBmTT+DVM3/8lGFQ+yZEK2YzhI5Qhxv5lTkD5Mk3xUyJrS02XNhyvzD2i
         yuubKRIoNoS4o5psHH6b8Kib+sekXEH5TFc4a0VIwrp6NNWInQx3dxRDyyULTM4ff5tc
         jGNFgT0x+ulK0thF2S5f06/44HcSIr8G/RUhx8U4O5KqkJ+LAVUMdTJpTOtcE/e5beSu
         T74Q==
X-Gm-Message-State: AOAM531aLMaoGzVj5KobFnn3FjrnHuol/pGIi9smp/0Jr8MVZ1DV2WYl
        ZgIj5JwPfKUPZ1jYF9m8YVw=
X-Google-Smtp-Source: ABdhPJzI3hm4OblEcN+aNVOyoqTfm7AjwPGM1EGsZYFYf/2sjN1Gn4j3NhD2FRVsoDCd8ah3kdOJTQ==
X-Received: by 2002:a17:902:b711:b029:d3:f1e5:c9c1 with SMTP id d17-20020a170902b711b02900d3f1e5c9c1mr3199571pls.3.1603962645539;
        Thu, 29 Oct 2020 02:10:45 -0700 (PDT)
Received: from garuda.localnet ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id w66sm1974332pgb.63.2020.10.29.02.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 02:10:44 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/7] generic: test reflink and copy_file_range behavior with O_SYNC and FS_XFLAG_SYNC files
Date:   Thu, 29 Oct 2020 14:40:41 +0530
Message-ID: <1765451.iLfdfiCMV9@garuda>
In-Reply-To: <160382536986.1203387.16617757455373368775.stgit@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia> <160382536986.1203387.16617757455373368775.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 28 October 2020 12:32:49 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add two regression tests to make sure that FICLONERANGE and the splice
> based copy_file_range actually flush all data and metadata to disk
> before the call ends.
>

Looks good to me.
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/947     |  117 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/947.out |   15 ++++++
>  tests/generic/948     |   90 ++++++++++++++++++++++++++++++++++++++
>  tests/generic/948.out |    9 ++++
>  tests/generic/group   |    2 +
>  5 files changed, 233 insertions(+)
>  create mode 100755 tests/generic/947
>  create mode 100644 tests/generic/947.out
>  create mode 100755 tests/generic/948
>  create mode 100644 tests/generic/948.out
> 
> 
> diff --git a/tests/generic/947 b/tests/generic/947
> new file mode 100755
> index 00000000..d2adf745
> --- /dev/null
> +++ b/tests/generic/947
> @@ -0,0 +1,117 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 947
> +#
> +# Make sure that reflink forces the log out if we open the file with O_SYNC or
> +# set FS_XFLAG_SYNC on the file.  We test that it actually forced the log by
> +# using dm-error to shut down the fs without flushing the log and then
> +# remounting to check file contents.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_dmerror_unmount
> +	_dmerror_cleanup
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/reflink
> +. ./common/dmerror
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_dm_target error
> +_require_scratch_reflink
> +_require_xfs_io_command "chattr" "s"
> +_require_cp_reflink
> +
> +rm -f $seqres.full
> +
> +# Format filesystem and set up quota limits
> +_scratch_mkfs > $seqres.full
> +_require_metadata_journaling $SCRATCH_DEV
> +_dmerror_init
> +_dmerror_mount
> +
> +# Test that O_SYNC actually results in file data being written even if the
> +# fs immediately dies
> +echo "test o_sync write"
> +$XFS_IO_PROG -x -f -s -c "pwrite -S 0x58 0 1m -b 1m" $SCRATCH_MNT/0 >> $seqres.full
> +_dmerror_load_error_table
> +_dmerror_unmount
> +_dmerror_load_working_table
> +_dmerror_mount
> +md5sum $SCRATCH_MNT/0 | _filter_scratch
> +
> +# Set up initial files for reflink test
> +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 1m -b 1m' $SCRATCH_MNT/a >> $seqres.full
> +$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 1m -b 1m' $SCRATCH_MNT/c >> $seqres.full
> +_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/e
> +_cp_reflink $SCRATCH_MNT/c $SCRATCH_MNT/d
> +touch $SCRATCH_MNT/b
> +sync
> +
> +# Test that reflink forces dirty data/metadata to disk when destination file
> +# opened with O_SYNC
> +echo "test reflink flag not set o_sync"
> +$XFS_IO_PROG -x -s -c "reflink $SCRATCH_MNT/a" $SCRATCH_MNT/b >> $seqres.full
> +_dmerror_load_error_table
> +_dmerror_unmount
> +_dmerror_load_working_table
> +_dmerror_mount
> +md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
> +
> +# Test that reflink to a shared file forces dirty data/metadata to disk when
> +# destination is opened with O_SYNC
> +echo "test reflink flag already set o_sync"
> +$XFS_IO_PROG -x -s -c "reflink $SCRATCH_MNT/a" $SCRATCH_MNT/d >> $seqres.full
> +_dmerror_load_error_table
> +_dmerror_unmount
> +_dmerror_load_working_table
> +_dmerror_mount
> +md5sum $SCRATCH_MNT/a $SCRATCH_MNT/d | _filter_scratch
> +
> +# Set up the two files with chattr +S
> +rm -f $SCRATCH_MNT/b $SCRATCH_MNT/d
> +_cp_reflink $SCRATCH_MNT/c $SCRATCH_MNT/d
> +touch $SCRATCH_MNT/b
> +chattr +S $SCRATCH_MNT/b $SCRATCH_MNT/d
> +sync
> +
> +# Test that reflink forces dirty data/metadata to disk when destination file
> +# has the sync iflag set
> +echo "test reflink flag not set iflag"
> +$XFS_IO_PROG -x -c "reflink $SCRATCH_MNT/a" $SCRATCH_MNT/b >> $seqres.full
> +_dmerror_load_error_table
> +_dmerror_unmount
> +_dmerror_load_working_table
> +_dmerror_mount
> +md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
> +
> +# Test that reflink to a shared file forces dirty data/metadata to disk when
> +# destination file has the sync iflag set
> +echo "test reflink flag already set iflag"
> +$XFS_IO_PROG -x -c "reflink $SCRATCH_MNT/a" $SCRATCH_MNT/d >> $seqres.full
> +_dmerror_load_error_table
> +_dmerror_unmount
> +_dmerror_load_working_table
> +_dmerror_mount
> +md5sum $SCRATCH_MNT/a $SCRATCH_MNT/d | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/947.out b/tests/generic/947.out
> new file mode 100644
> index 00000000..05ba10d1
> --- /dev/null
> +++ b/tests/generic/947.out
> @@ -0,0 +1,15 @@
> +QA output created by 947
> +test o_sync write
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/0
> +test reflink flag not set o_sync
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/b
> +test reflink flag already set o_sync
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/d
> +test reflink flag not set iflag
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/b
> +test reflink flag already set iflag
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/d
> diff --git a/tests/generic/948 b/tests/generic/948
> new file mode 100755
> index 00000000..83fe414b
> --- /dev/null
> +++ b/tests/generic/948
> @@ -0,0 +1,90 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 948
> +#
> +# Make sure that copy_file_range forces the log out if we open the file with
> +# O_SYNC or set FS_XFLAG_SYNC on the file.  We test that it actually forced the
> +# log by using dm-error to shut down the fs without flushing the log and then
> +# remounting to check file contents.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_dmerror_unmount
> +	_dmerror_cleanup
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmerror
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_dm_target error
> +_require_xfs_io_command "chattr" "s"
> +
> +rm -f $seqres.full
> +
> +# Format filesystem and set up quota limits
> +_scratch_mkfs > $seqres.full
> +_require_metadata_journaling $SCRATCH_DEV
> +_dmerror_init
> +_dmerror_mount
> +
> +# Test that O_SYNC actually results in file data being written even if the
> +# fs immediately dies
> +echo "test o_sync write"
> +$XFS_IO_PROG -x -f -s -c "pwrite -S 0x58 0 1m -b 1m" $SCRATCH_MNT/0 >> $seqres.full
> +_dmerror_load_error_table
> +_dmerror_unmount
> +_dmerror_load_working_table
> +_dmerror_mount
> +md5sum $SCRATCH_MNT/0 | _filter_scratch
> +
> +# Set up initial files for copy test
> +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 1m -b 1m' $SCRATCH_MNT/a >> $seqres.full
> +touch $SCRATCH_MNT/b
> +sync
> +
> +# Test that unaligned copy file range forces dirty data/metadata to disk when
> +# destination file opened with O_SYNC
> +echo "test unaligned copy range o_sync"
> +$XFS_IO_PROG -x -s -c "copy_range -s 13 -d 13 -l 1048550 $SCRATCH_MNT/a" $SCRATCH_MNT/b >> $seqres.full
> +_dmerror_load_error_table
> +_dmerror_unmount
> +_dmerror_load_working_table
> +_dmerror_mount
> +md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
> +
> +# Set up dest file with chattr +S
> +rm -f $SCRATCH_MNT/b
> +touch $SCRATCH_MNT/b
> +chattr +S $SCRATCH_MNT/b
> +sync
> +
> +# Test that unaligned copy file range forces dirty data/metadata to disk when
> +# destination file has the sync iflag set
> +echo "test unaligned copy range iflag"
> +$XFS_IO_PROG -x -c "copy_range -s 13 -d 13 -l 1048550 $SCRATCH_MNT/a" $SCRATCH_MNT/b >> $seqres.full
> +_dmerror_load_error_table
> +_dmerror_unmount
> +_dmerror_load_working_table
> +_dmerror_mount
> +md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/948.out b/tests/generic/948.out
> new file mode 100644
> index 00000000..eec6c0dc
> --- /dev/null
> +++ b/tests/generic/948.out
> @@ -0,0 +1,9 @@
> +QA output created by 948
> +test o_sync write
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/0
> +test unaligned copy range o_sync
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +2a715d2093b5aca82783a0c5943ac0b8  SCRATCH_MNT/b
> +test unaligned copy range iflag
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +2a715d2093b5aca82783a0c5943ac0b8  SCRATCH_MNT/b
> diff --git a/tests/generic/group b/tests/generic/group
> index 8054d874..cf4fdc23 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -615,3 +615,5 @@
>  610 auto quick prealloc zero
>  611 auto quick attr
>  612 auto quick clone
> +947 auto quick rw clone
> +948 auto quick rw copy_range
> 
> 


-- 
chandan



