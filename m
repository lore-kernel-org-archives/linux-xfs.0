Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5C4C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 12:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0376264F27
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 12:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbhCDL7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 06:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239645AbhCDL7O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 06:59:14 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B5EC061574;
        Thu,  4 Mar 2021 03:58:34 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so524707pjb.1;
        Thu, 04 Mar 2021 03:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=B8+S65UtGEAwGhQMguwVkrznyUT3qEnZEocMkGvdXAA=;
        b=E0rBJo9vIMXJO+HUBRqWHxZ6CH6f6JY/XWaFS62WaRZzUU/BtWxCoChCCFxoTlsEPa
         In1wxpstBAarm3qrAAOFV4aLsma2vF1cbHskb0rmxs8+sfNx6DcOzCay/pn/np39oJbr
         GuZD2NmBQroVUSScqxHD9QVrweM+mCAcpxbN6dNEgnSOGxIyjBWhUuwMCR2mud+RdzHJ
         nxfjfRQs7jEFwvBynXvZ83TW/uQQ9VATrDP2b5buuJ47p5p5AylpVq1NABUmTzxp4rA6
         QKf68QkXQiHu6qW1FHMIn0hJgKa2BQr2dl54TDK4SjLeYHi0vJw9umrDk6lqGSngk11V
         k54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=B8+S65UtGEAwGhQMguwVkrznyUT3qEnZEocMkGvdXAA=;
        b=SzxGKyAtmcDJewxTlYCMcE/fRRmAFS+i4p5Zw3cfN84ED1eM8qFG9abLSBoRnYFJc5
         ecfi8lygfLIjT2owOtykPm1JZ5t6Rv/KMbWrmEviSp1DW3PM5+k70YRxb/f7zD9NpZij
         wdHqjcwkH7p6B76ujDG5Dc7THNglFVZxFQI6W5vPho0bwzbk+WLrIpYZPALRIflj8qDd
         oX8PKZBahMU/xTqfZ+0MG2d/WLmw44zi9s2+Hx3vXspffR+kgO2ZcDTsDMay8kgunnNR
         vou+nUpN3ae+ZtGStQZ6dBTnsKFIwPzxv/lVMd0PwRxTYT0EUCqLofAk4DUdFPbzY3vW
         5aGw==
X-Gm-Message-State: AOAM5317ESmXJj4NqhX6Jmk9eXhy7zdRmVycnnuXViYobVn33YnyBZR4
        Ol95K3MMJMvgqioLkwd0PZc=
X-Google-Smtp-Source: ABdhPJyp6Rx3vFd9iiEYigsHDBPlRaqG1x7YI9r5Jc/Uwi3k6U7+rMwNTVmLnsJUo7PWOrUIukJ5vg==
X-Received: by 2002:a17:90a:d497:: with SMTP id s23mr4068985pju.148.1614859113858;
        Thu, 04 Mar 2021 03:58:33 -0800 (PST)
Received: from garuda ([122.179.119.194])
        by smtp.gmail.com with ESMTPSA id c11sm25225143pfl.52.2021.03.04.03.58.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Mar 2021 03:58:33 -0800 (PST)
References: <20210118062022.15069-1-chandanrlinux@gmail.com> <20210118062022.15069-4-chandanrlinux@gmail.com> <20210303174527.GK7269@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 03/11] xfs: Check for extent overflow when growing realtime bitmap/summary inodes
In-reply-to: <20210303174527.GK7269@magnolia>
Date:   Thu, 04 Mar 2021 17:28:30 +0530
Message-ID: <87r1kvp1uh.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 23:15, Darrick J. Wong wrote:
> On Mon, Jan 18, 2021 at 11:50:14AM +0530, Chandan Babu R wrote:
>> Verify that XFS does not cause realtime bitmap/summary inode fork's
>> extent count to overflow when growing the realtime volume associated
>> with a filesystem.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  tests/xfs/523     | 119 ++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/523.out |  11 +++++
>>  tests/xfs/group   |   1 +
>>  3 files changed, 131 insertions(+)
>>  create mode 100755 tests/xfs/523
>>  create mode 100644 tests/xfs/523.out
>>
>> diff --git a/tests/xfs/523 b/tests/xfs/523
>> new file mode 100755
>> index 00000000..145f0ff6
>> --- /dev/null
>> +++ b/tests/xfs/523
>> @@ -0,0 +1,119 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
>> +#
>> +# FS QA Test 523
>> +#
>> +# Verify that XFS does not cause bitmap/summary inode fork's extent count to
>> +# overflow when growing an the realtime volume of the filesystem.
>> +#
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	_scratch_unmount >> $seqres.full 2>&1
>> +	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
>> +	rm -f $tmp.* $TEST_DIR/$seq.rtvol
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/inject
>> +. ./common/populate
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs xfs
>> +_require_test
>> +_require_xfs_debug
>> +_require_test_program "punch-alternating"
>> +_require_xfs_io_error_injection "reduce_max_iextents"
>> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>> +_require_scratch_nocheck
>
> Might want a comment about why this test doesn't _require_realtime.

Sure. I will do that.

>
> Hm.  What /does/ happen if the kernel xfs driver wasn't built with
> realtime support?  I'll investigate and report back.

_scratch_mount invocation later in the script fails and hence the script exits
with a failure status.

>
>> +
>> +echo "* Test extending rt inodes"
>> +
>> +_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
>> +. $tmp.mkfs
>> +
>> +echo "Create fake rt volume"
>> +nr_bitmap_blks=25
>> +nr_bits=$((nr_bitmap_blks * dbsize * 8))
>> +rtextsz=$dbsize
>> +rtdevsz=$((nr_bits * rtextsz))
>> +truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
>> +rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
>> +
>> +echo "Format and mount rt volume"
>> +
>> +export USE_EXTERNAL=yes
>> +export SCRATCH_RTDEV=$rtdev
>> +_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
>> +	      -r size=2M,extsize=${rtextsz} >> $seqres.full
>> +_scratch_mount >> $seqres.full
>> +
>> +echo "Consume free space"
>> +fillerdir=$SCRATCH_MNT/fillerdir
>> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
>> +nr_free_blks=$((nr_free_blks * 90 / 100))
>> +
>> +_fill_fs $((dbsize * nr_free_blks)) $fillerdir $dbsize 0 >> $seqres.full 2>&1
>> +
>> +echo "Create fragmented filesystem"
>> +for dentry in $(ls -1 $fillerdir/); do
>> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
>> +done
>> +
>> +echo "Inject reduce_max_iextents error tag"
>> +_scratch_inject_error reduce_max_iextents 1
>> +
>> +echo "Inject bmap_alloc_minlen_extent error tag"
>> +_scratch_inject_error bmap_alloc_minlen_extent 1
>> +
>> +echo "Grow realtime volume"
>> +$XFS_GROWFS_PROG -r $SCRATCH_MNT >> $seqres.full 2>&1
>> +if [[ $? == 0 ]]; then
>> +	echo "Growfs succeeded; should have failed."
>> +	exit 1
>> +fi
>> +
>> +_scratch_unmount >> $seqres.full
>> +
>> +echo "Verify rbmino's and rsumino's extent count"
>> +for rtino in rbmino rsumino; do
>> +	ino=$(_scratch_xfs_db -c sb -c "print $rtino")
>> +	ino=${ino##${rtino} = }
>> +	echo "$rtino = $ino" >> $seqres.full
>> +
>> +	nextents=$(_scratch_get_iext_count $ino data || \
>> +			_fail "Unable to obtain inode fork's extent count")
>> +	if (( $nextents > 10 )); then
>> +		echo "Extent count overflow check failed: nextents = $nextents"
>> +		exit 1
>> +	fi
>> +done
>> +
>> +echo "Check filesystem"
>> +_check_xfs_filesystem $SCRATCH_DEV none $rtdev
>> +
>> +losetup -d $rtdev
>> +rm -f $TEST_DIR/$seq.rtvol
>> +
>> +export USE_EXTERNAL=""
>> +export SCRATCH_RTDEV=""
>
> No need to clear these, but with those two nits fixed, this looks all right.
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks for the review!

I also noticed a bug in the script when it is executed on a 1k block sized
filesystem. The second invocation of _scratch_mkfs ends up creating a 4k
blocksized filesystem since the block size was not explicitly passed as an
argument. Also, if the block size is less than 4k, we have to set realtime
block size to 4k.

I have fixed these bugs and will include the fixes in the next version
of the patchset.

>
> --D
>
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/xfs/523.out b/tests/xfs/523.out
>> new file mode 100644
>> index 00000000..7df02970
>> --- /dev/null
>> +++ b/tests/xfs/523.out
>> @@ -0,0 +1,11 @@
>> +QA output created by 523
>> +* Test extending rt inodes
>> +Create fake rt volume
>> +Format and mount rt volume
>> +Consume free space
>> +Create fragmented filesystem
>> +Inject reduce_max_iextents error tag
>> +Inject bmap_alloc_minlen_extent error tag
>> +Grow realtime volume
>> +Verify rbmino's and rsumino's extent count
>> +Check filesystem
>> diff --git a/tests/xfs/group b/tests/xfs/group
>> index 1831f0b5..018c70ef 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -520,3 +520,4 @@
>>  520 auto quick reflink
>>  521 auto quick realtime growfs
>>  522 auto quick quota
>> +523 auto quick realtime growfs
>> --
>> 2.29.2
>>


--
chandan
