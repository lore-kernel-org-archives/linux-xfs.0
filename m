Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9ADEB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 02:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbjFOCP6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 22:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbjFOCP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 22:15:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE35B1BE8
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 19:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686795317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WK94QTfv2HYRBTh9/ggUqASYqFtgGznTD3engC7yDf8=;
        b=arlbVkjpKoUHk+nm+7uQI9uln/n8EdFVTxXX1ygi18a/mgPQk86fllgDkCOfjfSETTMqr2
        gpmduBBS8++mJXOWRXXXiHHdcT4w1m3/EUx998xH/ybUOLn+oMJ4MZMw4tIFzdft7Rvnjl
        HBy1+snSt3aCdu7VKq3OY3TIVS2zA14=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-nrgs6uvcNomwigGrbqW9zw-1; Wed, 14 Jun 2023 22:15:15 -0400
X-MC-Unique: nrgs6uvcNomwigGrbqW9zw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-75d540855c5so383698885a.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 19:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686795315; x=1689387315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WK94QTfv2HYRBTh9/ggUqASYqFtgGznTD3engC7yDf8=;
        b=ZVf6KBtVUSLfYAFe8xwJCaxj1ytZzzXuLQrzxCEb7R/aGaBEZDY0HqIM06ldCUwWl6
         3NeVClySYkzG/CJW1T/LRo6N5jPFXB5hf++wHl95B7gXdTb/NZWxUXKM91QEBE2NvytS
         OS3ej9vIbNi1EscpSUP4+JPh9hZNmBGi75MFTgtzx4h85Ives0tuQwdIbnk1AjsSwjmT
         eFNIbQDqqfx3TB7Rm/Zlf8ssd8b0/HubiUnJfhTSGxD7oM2jSiYS/u/Xt8frBQXuenUG
         Q6Wcj7cHQ/+EXGiAk+lfGunoCUa3GSUdjn6/00dz3C1hU5Mi8k6V2MQKfZ+XxgKjzW/x
         k7mw==
X-Gm-Message-State: AC+VfDwDPIO8yQg4MKVLGBSg0MDF94ZbZJAVhzNwUPSZkgFI+gqb46zP
        Wdk5lyVO5uxjpkNokBgLqPeYLVUsq9a4UutkM08+Ji54pcH7jbrscby2q0h413NZ5PRjXMJz06w
        XZTSHIAMrMXUezmfRCyXp
X-Received: by 2002:a05:620a:828d:b0:75b:23a0:e7d9 with SMTP id ox13-20020a05620a828d00b0075b23a0e7d9mr16221520qkn.58.1686795315048;
        Wed, 14 Jun 2023 19:15:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7FjFm7HDgkwuy9JljG2neySKSIPr0eeraavlqD5oR0ZOALtMLTXZg8YsRsE4gLvWDzrBPyuw==
X-Received: by 2002:a05:620a:828d:b0:75b:23a0:e7d9 with SMTP id ox13-20020a05620a828d00b0075b23a0e7d9mr16221513qkn.58.1686795314723;
        Wed, 14 Jun 2023 19:15:14 -0700 (PDT)
Received: from ?IPV6:2001:8003:4b08:fb00:e45d:9492:62e8:873c? ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id b2-20020aa78702000000b006668f004420sm276308pfo.148.2023.06.14.19.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 19:15:13 -0700 (PDT)
Message-ID: <ea333d41-94ea-4507-7106-b63110368a59@redhat.com>
Date:   Thu, 15 Jun 2023 12:15:09 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4] xfstests: add test for xfs_repair progress reporting
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20230531064024.1737213-1-ddouwsma@redhat.com>
 <20230531064024.1737213-2-ddouwsma@redhat.com>
 <20230609145253.GY1325469@frogsfrogsfrogs>
 <20230610063855.gg6cd7bh5pzyobhe@zlang-mailbox>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20230610063855.gg6cd7bh5pzyobhe@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/6/23 16:38, Zorro Lang wrote:
> On Fri, Jun 09, 2023 at 07:52:53AM -0700, Darrick J. Wong wrote:
>> Tests ought to be cc'd to fstests@vger.kernel.org.
> 
> Thanks, I got this patch now :)

Sorry Zorro, I'd meant to CC the cover letter and test to fstests.

> 
>>
>> On Wed, May 31, 2023 at 04:40:24PM +1000, Donald Douwsma wrote:
>>> Confirm that xfs_repair reports on its progress if -o ag_stride is
>>> enabled.
>>>
>>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>>> ---
>>> Changes since v3
>>> - Rebase after tests/xfs/groups removal (tools/convert-group), drop _supported_os
>>> - Shorten the delay, remove superfluous dm-delay parameters
>>> Changes since v2:
>>> - Fix cleanup handling and function naming
>>> - Added to auto group
>>> Changes since v1:
>>> - Use _scratch_xfs_repair
>>> - Filter only repair output
>>> - Make the filter more tolerant of whitespace and plurals
>>> - Take golden output from 'xfs_repair: fix progress reporting'
>>>
>>>   tests/xfs/999     | 66 +++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/xfs/999.out | 15 +++++++++++
>>>   2 files changed, 81 insertions(+)
>>>   create mode 100755 tests/xfs/999
>>>   create mode 100644 tests/xfs/999.out
>>>
>>> diff --git a/tests/xfs/999 b/tests/xfs/999
>>> new file mode 100755
>>> index 00000000..9e799f66
>>> --- /dev/null
>>> +++ b/tests/xfs/999
>>> @@ -0,0 +1,66 @@
>>> +#! /bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
>>> +#
>>> +# FS QA Test 521
>>> +#
>>> +# Test xfs_repair's progress reporting
>>> +#
>>> +. ./common/preamble
>>> +_begin_fstest auto repair
>>> +
>>> +# Override the default cleanup function.
>>> +_cleanup()
>>> +{
>>> +	cd /
>>> +	rm -f $tmp.*
>>> +	_cleanup_delay > /dev/null 2>&1
>>> +}
>>> +
>>> +# Import common functions.
>>> +. ./common/filter
>>> +. ./common/dmdelay
>>> +. ./common/populate
>>> +
>>> +# real QA test starts here
>>> +
>>> +# Modify as appropriate.
>>> +_supported_fs xfs
> 
> As a regression test case, we need to point out that it's:
>    _fixed_by_git_commit xfsprogs a4d94d6c30ac "xfs_repair: fix progress reporting"
> 

Will do.

> Then due to it might fail without the other patch [1] (which has been reviewed),
> so we'd better to point out that:
> 
>    _wants_git_commit xfsprogs xxxxxxxxxxxx \
>            "xfs_repair: always print an estimate when reporting progress"
> 
> [1]
> https://lore.kernel.org/linux-xfs/ZIM%2FKegChkoeTJE8@redhat.com/T/#u

I'll send a v5 to fstests and linux-xfs once the above is merged and I
can add the commit.

- Don

> 
> 
>>> +_require_scratch
>>> +_require_dm_target delay
>>> +
>>> +# Filter output specific to the formatters in xfs_repair/progress.c
>>> +# Ideally we'd like to see hits on anything that matches
>>> +# awk '/{FMT/' xfsprogs-dev/repair/progress.c
>>> +filter_repair()
>>> +{
>>> +	sed -nre '
>>> +	s/[0-9]+/#/g;
>>> +	s/^\s+/ /g;
>>> +	s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
>>> +	/#:#:#:/p
>>> +	'
>>> +}
>>> +
>>> +echo "Format and populate"
>>> +_scratch_populate_cached nofill > $seqres.full 2>&1
>>> +
>>> +echo "Introduce a dmdelay"
>>> +_init_delay
>>> +DELAY_MS=38
>>
>> I wonder if this is where _init_delay should gain a delay_ms argument?
>>
>> _init_delay() {
>> 	local delay_ms="${1:-10000}"
> 
> Agree
> 
>>
>> 	...
>> 	DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $delay_ms $SCRATCH_DEV 0 0"
>> }
>>
>>
>>> +# Introduce a read I/O delay
>>> +# The default in common/dmdelay is a bit too agressive
>>> +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
>>> +DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $DELAY_MS"
>>> +_load_delay_table $DELAY_READ
>>> +
>>> +echo "Run repair"
>>> +SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
>>> +        tee -a $seqres.full > $tmp.repair
>>> +
>>> +cat $tmp.repair | filter_repair | sort -u
> 
> If the `sort -u` is necessary, how about only print the lines we realy care,
> filter out all other lines?
> 
> Thanks,
> Zorro
> 
>>> +
>>> +# success, all done
>>> +status=0
>>> +exit
>>> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
>>> new file mode 100644
>>> index 00000000..e27534d8
>>> --- /dev/null
>>> +++ b/tests/xfs/999.out
>>> @@ -0,0 +1,15 @@
>>> +QA output created by 999
>>> +Format and populate
>>> +Introduce a dmdelay
>>> +Run repair
>>> + - #:#:#: Phase #: #% done - estimated remaining time {progres}
>>> + - #:#:#: Phase #: elapsed time {progres} - processed # inodes per minute
>>> + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
>>> + - #:#:#: process known inodes and inode discovery - # of # inodes done
>>> + - #:#:#: process newly discovered inodes - # of # allocation groups done
>>> + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
>>> + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
>>> + - #:#:#: scanning filesystem freespace - # of # allocation groups done
>>> + - #:#:#: setting up duplicate extent list - # of # allocation groups done
>>> + - #:#:#: verify and correct link counts - # of # allocation groups done
>>> + - #:#:#: zeroing log - # of # blocks done
>>
>> Otherwise seems fine to me, assuming nothing goes nuts if rt devices or
>> whatever happen to be configured. ;)
>>
>> --D
>>
>>> -- 
>>> 2.39.3
>>>
>>
> 

