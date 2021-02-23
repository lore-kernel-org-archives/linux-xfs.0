Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3551C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 16:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEAE164E6B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 16:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhBWQnl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 11:43:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231604AbhBWQnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 11:43:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614098532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRyitFeu/UVz8RCUVTVp0xSWfzIJV3e8eZnTXrbD9m4=;
        b=IIUWdXaCiosy6z7zy+jHuG8Palfk1XBXRNy99p+8AmvY2QBO/RpNZxcyp1JRYN3ucmoX2l
        WWzcjbARJlkIX++vGcHDlKLHpKpc6dBnFvmyc9KsBkmyBn1pEpHBqiHmDvmuhhB8jaio1p
        tLyPmGs/anGdVCltFhdJeVez/7/V2F0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-W1bCECZWNiyM4IPjGQR3fw-1; Tue, 23 Feb 2021 11:41:07 -0500
X-MC-Unique: W1bCECZWNiyM4IPjGQR3fw-1
Received: by mail-wr1-f71.google.com with SMTP id e29so7372116wra.12
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 08:41:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MRyitFeu/UVz8RCUVTVp0xSWfzIJV3e8eZnTXrbD9m4=;
        b=Y/Tb+3bqkecoPwiOBIK0fvM6YX/7kaduZJ0AK0g3qqqljWdzztt9goRS/8+iUAzpkJ
         TZ/60bBzUvb45ZTBHlW6Dk/A4XVka4l/tyzFIRiZP2Hf9ORMQAiMhv0bMELV/aPDIOEc
         YQt48/FOZcWBF2QQH744Nh9M3VSDNGAaYGAmft2NCjik+ohC5MALMWk+8hpYgCVSpQVE
         aVmlb81Dr8UC5eAv1OCxmgsKZ3Mf6GxJ20yFfJy4ikEmfjyk2Pk3XOnnPnc0ajH3JROZ
         Ny8TbCPtJK38pIzHdCWLYlJieMKAUpXuHuSY04jZufyhXIBFTKP5PNKOAFAfr2CSyeXD
         0yLg==
X-Gm-Message-State: AOAM530WRtvfy9R+/0s9i2duO/e6fb+RiYtr/8B3pWVvSC7kYhdBlVfj
        usx/7sH5kBfpiefVP21/WrgAA+Nkd8HVw39ad0arV8V5vUHRGuvOrGmk4BAVFSxPvTtPQeydD8L
        ocP9liBCqb2kHr/hLdfAKz7qTR0BBdu2RQRbnhOk1LRliYFuXoJXqh95HT7w6/q53sXWfYLM=
X-Received: by 2002:adf:9521:: with SMTP id 30mr9925976wrs.23.1614098466072;
        Tue, 23 Feb 2021 08:41:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwg6NEiHhFFgXLi/xrtJXv/31xxNamGRda/eFUuQ/BrhqfJee+G5mF3g9cyhieomGcHfN/gYQ==
X-Received: by 2002:adf:9521:: with SMTP id 30mr9925952wrs.23.1614098465831;
        Tue, 23 Feb 2021 08:41:05 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id f7sm32849277wre.78.2021.02.23.08.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 08:41:05 -0800 (PST)
Subject: Re: [PATCH] xfs: Add test for printing deprec. mount options
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-2-preichl@redhat.com> <20210222212217.GD7272@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <86ed6a8b-47e5-544e-50b0-2632d29fbeb7@redhat.com>
Date:   Tue, 23 Feb 2021 17:41:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222212217.GD7272@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 10:22 PM, Darrick J. Wong wrote:
> On Sat, Feb 20, 2021 at 11:15:48PM +0100, Pavel Reichl wrote:
>> Verify that warnings about deprecated mount options are properly
>> printed.
>>
>> Verify that no excessive warnings are printed during remounts.
>>
>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>> ---
>>  tests/xfs/528     | 88 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/528.out |  2 ++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 91 insertions(+)
>>  create mode 100755 tests/xfs/528
>>  create mode 100644 tests/xfs/528.out
>>
>> diff --git a/tests/xfs/528 b/tests/xfs/528
>> new file mode 100755
>> index 00000000..0fc57cef
>> --- /dev/null
>> +++ b/tests/xfs/528
>> @@ -0,0 +1,88 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Red Hat, Inc.. All Rights Reserved.
>> +#
>> +# FS QA Test 528
>> +#
>> +# Verify that warnings about deprecated mount options are properly printed.
>> +#  
>> +# Verify that no excessive warnings are printed during remounts.
>> +#
>> +
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
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +_require_check_dmesg
>> +_supported_fs xfs
>> +_require_scratch
>> +
>> +log_tag()
>> +{
>> +	echo "fstests $seqnum [tag]" > /dev/kmsg
> 
> _require_check_dmesg?


Yeah? I mean it's right above _supported_fs_xfs and _require_scratch...I guess I should move it right next to _require_scratch, OK?


> 
>> +}
>> +
>> +dmesg_since_test_tag()
>> +{
>> +        dmesg | tac | sed -ne "0,\#fstests $seqnum \[tag\]#p" | \
>> +                tac
>> +}
>> +
>> +check_dmesg_for_since_tag()
>> +{
>> +        dmesg_since_test_tag | egrep -q "$1"
>> +}
>> +
>> +echo "Silence is golden."
>> +
>> +log_tag
>> +
>> +# Test mount
>> +for VAR in {attr2,ikeep,noikeep}; do
>> +	_scratch_mkfs > $seqres.full 2>&1
>> +	_scratch_mount -o $VAR
>> +	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
>> +		echo "Could not find deprecation warning for $VAR"
> 
> I think this is going to regress on old stable kernels that don't know
> about the mount option deprecation, right?  Shouldn't there be some
> logic to skip the test in that case?

I think you are right, thanks for the catch.
	
Do you know how to make sure that xfstest is executed only on the kernel that implements the tested feature? I tried to do some grepping but I didn't find anything yet.

Adding check for the output of `uname -r' directly to test seems a bit too crude.

> 
> --D
> 
>> +	umount $SCRATCH_MNT
>> +done
>> +
>> +# Test mount with default options (attr2 and noikeep) and remount with
>> +# 2 groups of options
>> +# 1) the defaults (attr2, noikeep)
>> +# 2) non defaults (noattr2, ikeep)
>> +_scratch_mount
>> +for VAR in {attr2,noikeep}; do
>> +	log_tag
>> +	mount -o $VAR,remount $SCRATCH_MNT
>> +	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated." && \
>> +		echo "Should not be able to find deprecation warning for $VAR"
>> +done
>> +for VAR in {noattr2,ikeep}; do
>> +	log_tag
>> +	mount -o $VAR,remount $SCRATCH_MNT
>> +	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
>> +		echo "Could not find deprecation warning for $VAR"
>> +done
>> +umount $SCRATCH_MNT
>> +
>> +# success, all done
>> +status=0
>> +exit
>> +
>> diff --git a/tests/xfs/528.out b/tests/xfs/528.out
>> new file mode 100644
>> index 00000000..762dccc0
>> --- /dev/null
>> +++ b/tests/xfs/528.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 528
>> +Silence is golden.
>> diff --git a/tests/xfs/group b/tests/xfs/group
>> index e861cec9..ad3bd223 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -525,3 +525,4 @@
>>  525 auto quick mkfs
>>  526 auto quick mkfs
>>  527 auto quick quota
>> +528 auto quick mount
>> -- 
>> 2.29.2
>>
> 

