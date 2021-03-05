Return-Path: <SRS0=x8pl=ID=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F038AC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 14:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C15F864FD2
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 14:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhCEOnu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhCEOnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 09:43:20 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5399C061574;
        Fri,  5 Mar 2021 06:43:20 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ch11so2152848pjb.4;
        Fri, 05 Mar 2021 06:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=hv7Rtm925dg0SfhTWYzSfU4XSJ6hXMN9tWZHcMpunnE=;
        b=s5MvSgeH1AHzTQN7S4ntQBVRileTfyTXuWn4DAiIgf2eGUwiYy9X0Ih2sEiYJ8FQ9e
         vUL51gtipYVMn45IVgyk8FQd+M8vWJSurI9xCsohCidJUbmzg1CULfTvo5dAvoO5yfQN
         fwLB1DYsB+ytP/JSqEcNffoTConL7VyIwYXXP3bs78nlyWx4TTNGmKiE/QB6Ym1sDc7W
         /GQUL11HWyiPzwBFB+U/2e4vpSUodss62JBjGjrZlDxWexz3uRe9d2EPcPRzQIia9Ogj
         lf98LpE5llBDL5TLXz1HhJh92RdBrBNCzomS0Hokv3I8B2bqOAoLWjPdBIxfO80Q5nd1
         zJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=hv7Rtm925dg0SfhTWYzSfU4XSJ6hXMN9tWZHcMpunnE=;
        b=gIfSWGoVcYJ89c20K+tuHuyfrGtBqc+muMxWvAv68wIHwAgzr6payMDrH0NkQFlmn2
         Dgj/9VWrgf6CXxttda0Jv93bH9i7o//jj/sk14sCg4geKB7iZ/B3ciftKeQ843QDah0l
         w9qqACYxDH6w0RZvlMW1Fsim19mtwyk3jjW349LuO8sp7JNnhhYmaV6TDzJVmepOyPaq
         Gr2c3Fzu5TBq3yHIEFtGu+7xY29RM6I7HXKQoomyS+DI1e1qkq6RU4WGUuSeS7rpLgpY
         a2qrwWvMRvSyegsaDge9EiEG2NJdLnmjavh9plaxGUF7pqQWc3VVVhaSWwEeQpIB/wIR
         DhMg==
X-Gm-Message-State: AOAM530JeRX3vC2rMw7/u5rfR8zdoek5tndVLqclKvXaq3utNLT2s0ED
        Ho6EhQvt16MgENd2+oL9vDk=
X-Google-Smtp-Source: ABdhPJyLBtH/87z19VyGJqUj3QsqYu+tlKhh3R7xmqHy1JhO209FEmslmFBQH8ATAx68Q3gTg4c5Iw==
X-Received: by 2002:a17:902:bc87:b029:e3:aae4:3188 with SMTP id bb7-20020a170902bc87b02900e3aae43188mr9442433plb.56.1614955400331;
        Fri, 05 Mar 2021 06:43:20 -0800 (PST)
Received: from garuda ([122.171.172.255])
        by smtp.gmail.com with ESMTPSA id ob6sm2488122pjb.30.2021.03.05.06.43.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Mar 2021 06:43:20 -0800 (PST)
References: <20210118062022.15069-1-chandanrlinux@gmail.com> <20210118062022.15069-8-chandanrlinux@gmail.com> <20210303180508.GO7269@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 07/11] xfs: Check for extent overflow when writing to unwritten extent
In-reply-to: <20210303180508.GO7269@magnolia>
Date:   Fri, 05 Mar 2021 20:13:17 +0530
Message-ID: <87ft19u0e2.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 23:35, Darrick J. Wong wrote:
> On Mon, Jan 18, 2021 at 11:50:18AM +0530, Chandan Babu R wrote:
>> This test verifies that XFS does not cause inode fork's extent count to
>> overflow when writing to an unwritten extent.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  tests/xfs/527     | 89 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/527.out | 11 ++++++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 101 insertions(+)
>>  create mode 100755 tests/xfs/527
>>  create mode 100644 tests/xfs/527.out
>>
>> diff --git a/tests/xfs/527 b/tests/xfs/527
>> new file mode 100755
>> index 00000000..cd67bce4
>> --- /dev/null
>> +++ b/tests/xfs/527
>> @@ -0,0 +1,89 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
>> +#
>> +# FS QA Test 527
>> +#
>> +# Verify that XFS does not cause inode fork's extent count to overflow when
>> +# writing to an unwritten extent.
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
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/inject
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs xfs
>> +_require_scratch
>> +_require_xfs_debug
>> +_require_xfs_io_command "falloc"
>> +_require_xfs_io_error_injection "reduce_max_iextents"
>> +
>> +echo "Format and mount fs"
>> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
>> +_scratch_mount >> $seqres.full
>> +
>> +bsize=$(_get_file_block_size $SCRATCH_MNT)
>> +
>> +testfile=${SCRATCH_MNT}/testfile
>> +
>> +echo "Inject reduce_max_iextents error tag"
>> +_scratch_inject_error reduce_max_iextents 1
>> +
>> +nr_blks=15
>> +
>> +for io in Buffered Direct; do
>
> # First test buffered writes, then direct writes.
> for $xfs_io_flag in "" "-d"; do ?

The keywords "Buffered" and "Direct" are also being used in the log
messages printed ...

>
>> +	echo "* $io write to unwritten extent"

... For example, In the above line, $io would be replaced by one of "Buffered"
and "Direct" ...

>> +
>> +	echo "Fallocate $nr_blks blocks"
>> +	$XFS_IO_PROG -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
>> +
>> +	if [[ $io == "Buffered" ]]; then
>> +		xfs_io_flag=""
>> +	else
>> +		xfs_io_flag="-d"
>> +	fi
>
> ...because then you can skip this part.
>
>> +
>> +	echo "$io write to every other block of fallocated space"

... Same logic is used above.

>> +	for i in $(seq 1 2 $((nr_blks - 1))); do
>> +		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
>> +		       $testfile >> $seqres.full 2>&1
>> +		[[ $? != 0 ]] && break
>> +	done
>> +
>> +	echo "Verify \$testfile's extent count"
>> +	nextents=$($XFS_IO_PROG -c 'stat' $testfile | grep nextents)
>> +	nextents=${nextents##fsxattr.nextents = }
>> +	if (( $nextents > 10 )); then
>> +		echo "Extent count overflow check failed: nextents = $nextents"
>> +		exit 1
>> +	fi
>> +
>> +	rm $testfile
>> +done
>> +
>> +# super_block->s_wb_err will have a newer seq value when compared to "/"'s
>> +# file->f_sb_err. Consume it here so that xfs_scrub can does not error out.
>> +$XFS_IO_PROG -c syncfs $SCRATCH_MNT >> $seqres.full 2>&1
>
> I wonder, should _check_xfs_filesystem should syncfs to clear old EIOs
> before running xfs_scrub?  I occasionally see this pop up on
> generic/204.

I agree with the idea of including a call to syncfs in
_check_xfs_filesystem. An error message can be logged if syncfs returns a
failure status. This will also prevent xfs_scrub from aborting and help in
providing information about any corrupt on-disk data structures.

I will include this in the next version of the patchset.

--
chandan
