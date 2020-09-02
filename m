Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547D2C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 09:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3311020FC3
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 09:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fn1EXaPf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIBJEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:04:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41878 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726657AbgIBJEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 05:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599037481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJx2CZpvT++3g4OCpAdAP1tjKdf5XEuitI5I8CH2nZg=;
        b=fn1EXaPf1T0TOKsMmtY4b7lVPHtc6OMZnrzBJraMgVb7MTC3YWr9Jm90lX1j2wrOvPLkIN
        CHsKhCKzsNs/AhGWL/CKmVHMSOBOsrJZadzXRM4kpfJXR8qwjB4d/UGwckJMEHA+fISrBT
        g0r/07Svy7UNuzTqsfrymb3/pN8A87g=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-9ZMXDcPZMX2pFQuJ1RukPg-1; Wed, 02 Sep 2020 05:04:35 -0400
X-MC-Unique: 9ZMXDcPZMX2pFQuJ1RukPg-1
Received: by mail-pg1-f199.google.com with SMTP id m16so2224467pgl.16
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 02:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mJx2CZpvT++3g4OCpAdAP1tjKdf5XEuitI5I8CH2nZg=;
        b=DIj8pPpXyoUPDy2elpNDA31ePcldH0jdXsR5FOliYl9XNTIiazoSS+D0kTw6+MxOUs
         G/qkh4Iyn24w+Uuf0VBPmS3UC0fTB7DByOKooc9fN/YZGWG8U86NuWkseL4EcyMh4p/e
         DrQ4BzWG4ZYtV9zSVQZYmp8Afe5gUcCH9ZOdHgTXFG3nGs+Pn/o1ClDZUhBzlAs4lsA9
         JnOkIGTEFF4I2/aB2iHXyBsqv7CZ2kNs3lF91xVykgyrcPZjvMuLb82CEq93HZF1Lqw5
         w5vA5liNJMJHu5LySejKJqRrmEaOhLQO097lAwf2fulBmCM8RfYv/Pe7IIuY8APbA+wX
         keiw==
X-Gm-Message-State: AOAM530KigeVXsC9gnXK35sAnRrPlETZQPBskiaB+oJY5EdRoewRi7Dy
        w5W6iBg6WmI/q1TfpV8STa3SfpcjdtoTg4RxG9lrBKGKMXSNVn+b4EuvtsP8mudytSCGiAcDuMp
        VjLvjIz99K5N8ItxdXto8
X-Received: by 2002:a63:e20:: with SMTP id d32mr1168960pgl.53.1599037473973;
        Wed, 02 Sep 2020 02:04:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaU4Yx70gvnYd16i4d/40ICBeCbhWsWdFny4BC0C7dC8APkL57eONzT4TB9Ouodx40RPSuhg==
X-Received: by 2002:a63:e20:: with SMTP id d32mr1168931pgl.53.1599037473541;
        Wed, 02 Sep 2020 02:04:33 -0700 (PDT)
Received: from don.don ([60.224.129.195])
        by smtp.gmail.com with ESMTPSA id h193sm4847117pgc.42.2020.09.02.02.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 02:04:33 -0700 (PDT)
Subject: Re: [PATCH v3] xfstests: add test for xfs_repair progress reporting
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Eryu Guan <guan@eryu.me>, Zorro Lang <zlang@redhat.com>
References: <20200524164648.GB3363@desktop>
 <20200817075313.1484879-1-ddouwsma@redhat.com>
 <20200830155723.GA3853@desktop>
From:   Donald Douwsma <ddouwsma@redhat.com>
Message-ID: <eebaff94-d73d-2b0d-b433-dab3fb42602d@redhat.com>
Date:   Wed, 2 Sep 2020 19:04:27 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200830155723.GA3853@desktop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 31/08/2020 01:57, Eryu Guan wrote:
> On Mon, Aug 17, 2020 at 05:53:13PM +1000, Donald Douwsma wrote:
>> xfs_repair's interval based progress has been broken for
>> some time, create a test based on dmdelay to stretch out
>> the time and use ag_stride to force parallelism.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> 
> Thanks for the revision! But I'm still seeing the following diff with
> v5.9-rc2 kernel and latest xfsprogs for-next branch, which should
> contains the progress reporting patches I guess (HEAD is commit
> 2cf166bca8a2 ("xfs_db: set b_ops to NULL in set_cur for types without
> verifiers"))
> 
>  Format and populate
>  Introduce a dmdelay
>  Run repair
> + - #:#:#: Phase #: #% done - estimated remaining time 
>   - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
>   - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
>   - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done


When testing this I only saw cases with minute(s) and second(s), but it turns
out that the duration function in xfs_repair/progress.c can produce an empty 
string or combinations of second, seconds, minute, minutes, day, days, week, 
or weeks.

This can affect the estimate string, but also the elapsed time like
    #:#:#: Phase #: #% done - estimated remaining time # second
    #:#:#: Phase #: elapsed time # second - processed # inodes per minute
    #:#:#: Phase #: elapsed time # seconds - processed # inodes per minute

I'll need to filter output from progress() specifically.

Thanks for pointing this out. 

Don


> 
>> ---
>> Changes since v2:
>> - Fix cleanup handling and function naming
>> - Added to auto group
>> Changes since v1:
>> - Use _scratch_xfs_repair
>> - Filter only repair output
>> - Make the filter more tolerant of whitespace and plurals
>> - Take golden output from 'xfs_repair: fix progress reporting'
>>
>>  tests/xfs/521     | 75 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/521.out | 15 ++++++++++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 91 insertions(+)
>>  create mode 100755 tests/xfs/521
>>  create mode 100644 tests/xfs/521.out
>>
>> diff --git a/tests/xfs/521 b/tests/xfs/521
>> new file mode 100755
>> index 00000000..c16c82bf
>> --- /dev/null
>> +++ b/tests/xfs/521
>> @@ -0,0 +1,75 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
>> +#
>> +# FS QA Test 521
>> +#
>> +# Test xfs_repair's progress reporting
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
>> +	rm -f $tmp.*
>> +	_cleanup_delay > /dev/null 2>&1
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/dmdelay
>> +. ./common/populate
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs xfs
>> +_supported_os Linux
>> +_require_scratch
>> +_require_dm_target delay
>> +
>> +# Filter output specific to the formatters in xfs_repair/progress.c
>> +# Ideally we'd like to see hits on anything that matches
>> +# awk '/{FMT/' repair/progress.c
>> +filter_repair()
>> +{
>> +	sed -ne '
>> +	s/[0-9]\+/#/g;
>> +	s/^\s\+/ /g;
>> +	s/\(second\|minute\)s/\1/g
>> +	/#:#:#:/p
>> +	'
>> +}
>> +
>> +echo "Format and populate"
>> +_scratch_populate_cached nofill > $seqres.full 2>&1
>> +
>> +echo "Introduce a dmdelay"
>> +_init_delay
>> +
>> +# Introduce a read I/O delay
>> +# The default in common/dmdelay is a bit too agressive
>> +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
>> +DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 100 $SCRATCH_DEV 0 0"
>> +_load_delay_table $DELAY_READ
>> +
>> +echo "Run repair"
>> +SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
>> +        tee -a $seqres.full > $tmp.repair
>> +
>> +cat $tmp.repair | filter_repair | sort -u
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/xfs/521.out b/tests/xfs/521.out
>> new file mode 100644
>> index 00000000..03337083
>> --- /dev/null
>> +++ b/tests/xfs/521.out
>> @@ -0,0 +1,15 @@
>> +QA output created by 521
>> +Format and populate
>> +Introduce a dmdelay
>> +Run repair
>> + - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
>> + - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
>> + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
>> + - #:#:#: process known inodes and inode discovery - # of # inodes done
>> + - #:#:#: process newly discovered inodes - # of # allocation groups done
>> + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
>> + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
>> + - #:#:#: scanning filesystem freespace - # of # allocation groups done
>> + - #:#:#: setting up duplicate extent list - # of # allocation groups done
>> + - #:#:#: verify and correct link counts - # of # allocation groups done
>> + - #:#:#: zeroing log - # of # blocks done
>> diff --git a/tests/xfs/group b/tests/xfs/group
>> index ed0d389e..1c8ec5fa 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -517,3 +517,4 @@
>>  518 auto quick quota
>>  519 auto quick reflink
>>  520 auto quick reflink
>> +521 auto repair
>> -- 
>> 2.18.4
> 

