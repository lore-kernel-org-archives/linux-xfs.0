Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BTC_ID,
	PDS_BTC_MSGID,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4243AC63777
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 07:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB85218AC
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 07:39:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D5e4s66G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgJ2HYt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 03:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgJ2HYf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 03:24:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED38C05BD41;
        Wed, 28 Oct 2020 23:13:18 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p17so782774pli.13;
        Wed, 28 Oct 2020 23:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TJn+j2w8g5NVqMbJepsMnNvYLSAric5DVBME7N8mcmg=;
        b=D5e4s66GoMNcw4/7gwl8OFOmMC9gtjKejTtZ0ikxW/VDTcJ7Ewcu5+5S7d5Li04lDV
         wdKPlwD/RhMXuh2qsnE5cLYeFlNK+J9mG7Ex+e/NhXfdNt6VJW6cIlUtGGqPpuodXO9r
         JGbCCIVb/1F2o9CqfkE5BowALWaZ+QZw4BrEZhFl5gqCqjuSVwxUs7Ao/GexA+W9FEla
         /eMGxuzvOCyjXLEeWXVo1GzmErTwb2+jgvmosaMLsUSF0Mz2ZADJTeDyXQnWVlRVqals
         J1Hn/IJYs2GtCEtbfcaxE+4Md/pZN1XKBw5rrwBRQIuuTzGP/teh29X9ZjTDp+MTD3BM
         rCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TJn+j2w8g5NVqMbJepsMnNvYLSAric5DVBME7N8mcmg=;
        b=R0BF2A3gENflT314sSPhJRuZA07G3lHgn4wQl3NBb5EBS0kPmJgW0H02Lj1aYaF5p3
         rrx/nHxd1HUKE3PjWiQuz0qOFdnAT13PLRKW/EnF7020wfRvAxuvq5YJ/cUEoXKJJuXR
         rIZYGCLAY0bVvtdbCTFZSEuhfI2r9PZWQ6/cgiwxeqAhhFw1GpBByZuaf6niMrkEqcrD
         Q/j+blsDGduuTqD3u6zb9KZsNkFt21MRtN9AusS3D/EV42Cxt8EXXdVu/nJsdJAN87Jv
         Zlj10ymbZEdpl+xe5QUXcZ1j7/mmI6CQYBkOnWDCQzT+11Tq8J0k+RB2NfC6D2nzeokX
         2K0Q==
X-Gm-Message-State: AOAM530vGFlW61Vxub/mG5qq0HqQWxqTauixVaab5KvAOA4ukL/SlcIi
        fKCzqB/o+ikJzI8oqtHJSc0=
X-Google-Smtp-Source: ABdhPJyXvA2YEArmH1LfyFdbD5ZVnIuf9JbRL0qMGkgT3DMkv4pS87ppme84EbgzQR74Bj0I0OZtOA==
X-Received: by 2002:a17:902:d910:b029:d6:8226:4163 with SMTP id c16-20020a170902d910b02900d682264163mr2793081plz.15.1603951998079;
        Wed, 28 Oct 2020 23:13:18 -0700 (PDT)
Received: from garuda.localnet ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id v24sm1217464pgi.91.2020.10.28.23.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 23:13:16 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: test fallocate ops when rt extent size is and isn't a power of 2
Date:   Thu, 29 Oct 2020 11:43:13 +0530
Message-ID: <2372060.oy4k316svl@garuda>
In-Reply-To: <160382535741.1203387.10647004373989609905.stgit@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia> <160382535741.1203387.10647004373989609905.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 28 October 2020 12:32:37 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that fallocate works when the rt extent size is and isn't a
> power of 2.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/763     |  181 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/763.out |   91 +++++++++++++++++++++++++++
>  tests/xfs/group   |    1 
>  3 files changed, 273 insertions(+)
>  create mode 100755 tests/xfs/763
>  create mode 100644 tests/xfs/763.out
> 
> 
> diff --git a/tests/xfs/763 b/tests/xfs/763
> new file mode 100755
> index 00000000..4b0b08a0
> --- /dev/null
> +++ b/tests/xfs/763
> @@ -0,0 +1,181 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 763
> +#
> +# Make sure that regular fallocate functions work ok when the realtime extent
> +# size is and isn't a power of 2.
> +#
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
> +	_scratch_unmount >> $seqres.full 2>&1
> +	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
> +	rm -f $tmp.* $TEST_DIR/$seq.rtvol
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_io_command "fpunch"
> +_require_xfs_io_command "fzero"
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "finsert"
> +# Note that we don't _require_realtime because we synthesize a rt volume
> +# below.  This also means we cannot run the post-test check.
> +_require_scratch_nocheck
> +
> +log() {
> +	echo "$@" | tee -a $seqres.full
> +}
> +
> +mk_file() {
> +	local file="$1"
> +	local rextsize="$2"
> +
> +	$XFS_IO_PROG -f \
> +		-c "pwrite -S 0x57 -b $rextsize 0 $rextsize" \
> +		-c "pwrite -S 0x58 -b $rextsize $rextsize $rextsize" \
> +		-c "pwrite -S 0x59 -b $rextsize $((rextsize * 2)) $rextsize" \
> +		-c fsync \
> +		"$file" >> $seqres.full
> +}
> +
> +check_file() {
> +	filefrag -v "$1" >> $seqres.full
> +	od -tx1 -Ad -c "$1" >> $seqres.full
> +	md5sum "$1" | _filter_scratch | tee -a $seqres.full
> +}
> +
> +test_ops() {
> +	local rextsize=$1
> +	local sz=$((rextsize * 3))
> +	local unaligned_sz=65536
> +	local unaligned_off=$((rextsize * 2 + unaligned_sz))
> +	local lunaligned_sz=$((rextsize * 2))
> +	local lunaligned_off=$unaligned_sz
> +
> +	log "Format rtextsize=$rextsize"
> +	_scratch_unmount
> +	_scratch_mkfs -r extsize=$rextsize >> $seqres.full
> +	_scratch_mount || \
> +		_notrun "Could not mount rextsize=$rextsize with synthetic rt volume"
> +
> +	# Force all files to be realtime files
> +	$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
> +
> +	log "Test regular write, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/write $rextsize
> +	check_file $SCRATCH_MNT/write
> +
> +	log "Test aligned falloc, rextsize=$rextsize"
> +	$XFS_IO_PROG -f -c "falloc 0 $sz" $SCRATCH_MNT/falloc >> $seqres.full
> +	check_file $SCRATCH_MNT/falloc
> +
> +	log "Test aligned fcollapse, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/collapse $rextsize
> +	$XFS_IO_PROG -f -c "fcollapse $rextsize $rextsize" $SCRATCH_MNT/collapse >> $seqres.full
> +	check_file $SCRATCH_MNT/collapse
> +
> +	log "Test aligned finsert, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/insert $rextsize
> +	$XFS_IO_PROG -f -c "finsert $rextsize $rextsize" $SCRATCH_MNT/insert >> $seqres.full
> +	check_file $SCRATCH_MNT/insert
> +
> +	log "Test aligned fzero, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/zero $rextsize
> +	$XFS_IO_PROG -f -c "fzero $rextsize $rextsize" $SCRATCH_MNT/zero >> $seqres.full
> +	check_file $SCRATCH_MNT/zero
> +
> +	log "Test aligned fpunch, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/punch $rextsize
> +	$XFS_IO_PROG -f -c "fpunch $rextsize $rextsize" $SCRATCH_MNT/punch >> $seqres.full
> +	check_file $SCRATCH_MNT/punch
> +
> +	log "Test unaligned falloc, rextsize=$rextsize"
> +	$XFS_IO_PROG -f -c "falloc $unaligned_off $unaligned_sz" $SCRATCH_MNT/ufalloc >> $seqres.full
> +	check_file $SCRATCH_MNT/ufalloc
> +
> +	log "Test unaligned fcollapse, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/ucollapse $rextsize
> +	$XFS_IO_PROG -f -c "fcollapse $unaligned_off $unaligned_sz" $SCRATCH_MNT/ucollapse >> $seqres.full
> +	check_file $SCRATCH_MNT/ucollapse
> +
> +	log "Test unaligned finsert, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/uinsert $rextsize
> +	$XFS_IO_PROG -f -c "finsert $unaligned_off $unaligned_sz" $SCRATCH_MNT/uinsert >> $seqres.full
> +	check_file $SCRATCH_MNT/uinsert
> +
> +	log "Test unaligned fzero, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/uzero $rextsize
> +	$XFS_IO_PROG -f -c "fzero $unaligned_off $unaligned_sz" $SCRATCH_MNT/uzero >> $seqres.full
> +	check_file $SCRATCH_MNT/uzero
> +
> +	log "Test unaligned fpunch, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/upunch $rextsize
> +	$XFS_IO_PROG -f -c "fpunch $unaligned_off $unaligned_sz" $SCRATCH_MNT/upunch >> $seqres.full
> +	check_file $SCRATCH_MNT/upunch
> +
> +	log "Test large unaligned fzero, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/luzero $rextsize
> +	$XFS_IO_PROG -f -c "fzero $lunaligned_off $lunaligned_sz" $SCRATCH_MNT/luzero >> $seqres.full
> +	check_file $SCRATCH_MNT/luzero
> +
> +	log "Test large unaligned fpunch, rextsize=$rextsize"
> +	mk_file $SCRATCH_MNT/lpunch $rextsize
> +	$XFS_IO_PROG -f -c "fpunch $lunaligned_off $lunaligned_sz" $SCRATCH_MNT/lpunch >> $seqres.full
> +	check_file $SCRATCH_MNT/lpunch
> +
> +	log "Remount and compare"
> +	_scratch_cycle_mount
> +	check_file $SCRATCH_MNT/write
> +	check_file $SCRATCH_MNT/falloc
> +	check_file $SCRATCH_MNT/collapse
> +	check_file $SCRATCH_MNT/insert
> +	check_file $SCRATCH_MNT/zero
> +	check_file $SCRATCH_MNT/punch
> +	check_file $SCRATCH_MNT/ufalloc
> +	check_file $SCRATCH_MNT/ucollapse
> +	check_file $SCRATCH_MNT/uinsert
> +	check_file $SCRATCH_MNT/uzero
> +	check_file $SCRATCH_MNT/upunch
> +	check_file $SCRATCH_MNT/luzero
> +	check_file $SCRATCH_MNT/lpunch
> +
> +	log "Check everything, rextsize=$rextsize"
> +	_check_scratch_fs
> +}
> +
> +echo "Create fake rt volume"
> +truncate -s 400m $TEST_DIR/$seq.rtvol
> +rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> +
> +echo "Make sure synth rt volume works"
> +export USE_EXTERNAL=yes
> +export SCRATCH_RTDEV=$rtdev
> +_scratch_mkfs > $seqres.full
> +_scratch_mount || \
> +	_notrun "Could not mount with synthetic rt volume"
> +
> +# power of two
> +test_ops 262144
> +
> +# not a power of two
> +test_ops 327680
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/763.out b/tests/xfs/763.out
> new file mode 100644
> index 00000000..27c87bab
> --- /dev/null
> +++ b/tests/xfs/763.out
> @@ -0,0 +1,91 @@
> +QA output created by 763
> +Create fake rt volume
> +Make sure synth rt volume works
> +Format rtextsize=262144
> +Test regular write, rextsize=262144
> +2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/write
> +Test aligned falloc, rextsize=262144
> +cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/falloc
> +Test aligned fcollapse, rextsize=262144
> +2e94746ab733025c21a9cae7d19c18d0  SCRATCH_MNT/collapse
> +Test aligned finsert, rextsize=262144
> +24e228d3d5f68b612eceec47f8416a7d  SCRATCH_MNT/insert
> +Test aligned fzero, rextsize=262144
> +ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/zero
> +Test aligned fpunch, rextsize=262144
> +ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/punch
> +Test unaligned falloc, rextsize=262144
> +157e39521e47ad1c923a94edd69ad59c  SCRATCH_MNT/ufalloc
> +Test unaligned fcollapse, rextsize=262144
> +fallocate: Invalid argument
> +2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/ucollapse
> +Test unaligned finsert, rextsize=262144
> +fallocate: Invalid argument
> +2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/uinsert
> +Test unaligned fzero, rextsize=262144
> +4402ca12d4425d7f94c9f536b756d924  SCRATCH_MNT/uzero
> +Test unaligned fpunch, rextsize=262144
> +4402ca12d4425d7f94c9f536b756d924  SCRATCH_MNT/upunch
> +Test large unaligned fzero, rextsize=262144
> +be43c5a0de0b510a6a573d682b0df726  SCRATCH_MNT/luzero
> +Test large unaligned fpunch, rextsize=262144
> +be43c5a0de0b510a6a573d682b0df726  SCRATCH_MNT/lpunch
> +Remount and compare
> +2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/write
> +cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/falloc
> +2e94746ab733025c21a9cae7d19c18d0  SCRATCH_MNT/collapse
> +24e228d3d5f68b612eceec47f8416a7d  SCRATCH_MNT/insert
> +ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/zero
> +ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/punch
> +157e39521e47ad1c923a94edd69ad59c  SCRATCH_MNT/ufalloc
> +2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/ucollapse
> +2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/uinsert
> +4402ca12d4425d7f94c9f536b756d924  SCRATCH_MNT/uzero
> +4402ca12d4425d7f94c9f536b756d924  SCRATCH_MNT/upunch
> +be43c5a0de0b510a6a573d682b0df726  SCRATCH_MNT/luzero
> +be43c5a0de0b510a6a573d682b0df726  SCRATCH_MNT/lpunch
> +Check everything, rextsize=262144
> +Format rtextsize=327680
> +Test regular write, rextsize=327680
> +dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/write
> +Test aligned falloc, rextsize=327680
> +63a6c5a8b8da92e30cd0ef23c56d4f06  SCRATCH_MNT/falloc
> +Test aligned fcollapse, rextsize=327680
> +8bdd728a7a4af4ac18bbcbe39dea14d5  SCRATCH_MNT/collapse
> +Test aligned finsert, rextsize=327680
> +2b178c860f7bef4c0e55399be5172c5e  SCRATCH_MNT/insert
> +Test aligned fzero, rextsize=327680
> +350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/zero
> +Test aligned fpunch, rextsize=327680
> +350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/punch
> +Test unaligned falloc, rextsize=327680
> +cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/ufalloc
> +Test unaligned fcollapse, rextsize=327680
> +fallocate: Invalid argument
> +dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/ucollapse
> +Test unaligned finsert, rextsize=327680
> +fallocate: Invalid argument
> +dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/uinsert
> +Test unaligned fzero, rextsize=327680
> +c9c7b8791f445ec8c5fbbf82cb26b33c  SCRATCH_MNT/uzero
> +Test unaligned fpunch, rextsize=327680
> +c9c7b8791f445ec8c5fbbf82cb26b33c  SCRATCH_MNT/upunch
> +Test large unaligned fzero, rextsize=327680
> +d8bf9fa95e4a7dd228d0b03768045db9  SCRATCH_MNT/luzero
> +Test large unaligned fpunch, rextsize=327680
> +d8bf9fa95e4a7dd228d0b03768045db9  SCRATCH_MNT/lpunch
> +Remount and compare
> +dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/write
> +63a6c5a8b8da92e30cd0ef23c56d4f06  SCRATCH_MNT/falloc
> +8bdd728a7a4af4ac18bbcbe39dea14d5  SCRATCH_MNT/collapse
> +2b178c860f7bef4c0e55399be5172c5e  SCRATCH_MNT/insert
> +350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/zero
> +350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/punch
> +cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/ufalloc
> +dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/ucollapse
> +dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/uinsert
> +c9c7b8791f445ec8c5fbbf82cb26b33c  SCRATCH_MNT/uzero
> +c9c7b8791f445ec8c5fbbf82cb26b33c  SCRATCH_MNT/upunch
> +d8bf9fa95e4a7dd228d0b03768045db9  SCRATCH_MNT/luzero
> +d8bf9fa95e4a7dd228d0b03768045db9  SCRATCH_MNT/lpunch
> +Check everything, rextsize=327680
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b89c0a4e..ffd18166 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -519,3 +519,4 @@
>  519 auto quick reflink
>  520 auto quick reflink
>  521 auto quick realtime growfs
> +763 auto quick rw realtime
> 
> 


-- 
chandan



