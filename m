Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B60C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE1C2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aLoSimYU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgHQHt4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 03:49:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbgHQHty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 03:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597650592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRwUKUAgHQU/Br+9CJJW/SQJIlgAG6AUACubTcWu9kQ=;
        b=aLoSimYUWzKbl6myoK92cZOKekT/hwWrFrh6KuOd1+5aSZwNs5xb103k7yNXCXkpLgu7Gx
        TRDqtprYHsfy7Ddkj+wJKtvvekJYmPmpcXf3Sc0YGkbkDKqrJcNdgxoeqnaVPeFOLMMjDR
        8ALlAiFjdSn7MmSgPgwLKFzWgYnyYLU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-9qgVjerxOQ2uC-2yd5UYTA-1; Mon, 17 Aug 2020 03:49:48 -0400
X-MC-Unique: 9qgVjerxOQ2uC-2yd5UYTA-1
Received: by mail-pg1-f199.google.com with SMTP id f18so9840481pgl.1
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 00:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cRwUKUAgHQU/Br+9CJJW/SQJIlgAG6AUACubTcWu9kQ=;
        b=IGHuawHhamdYPsRrrdKKEt8TIdYEsGWUNy79CBZ3MqZWVLICU14iXygKrDuNb0g+K2
         uzMpNTE1g4Z/aYPbKgW2BD4J4UuTmSa5zGVNqob//8WXFeK24Ej10/dE6K4tOmWk44PC
         /RJh3CEahGO040Df0Pf/Z6Va6Nq3HWhpSDhxTQelp4NwmXzibPFuzcsk82qR8YtBS+KK
         8U6wQWYg0mYMXAtRRrHTJ1wlN1L0HdbBvFYyuRvsL4GYmRSAShQdJOHwtDCwHoy9p3T+
         c1GPJO3btsqDa7JHiiPl7q1NivBzESa5ZQOy9IMbdl4clTcsUwue2qQlNvmIn+EuUt09
         Q+Pw==
X-Gm-Message-State: AOAM533RHDr2JUVO3itBYsD914/Rzrk5l7oL9E9Gh7zLSAHxTNxd6nmI
        ErFXCS+V84BJbR/6zZQKIWznN3uNK2MSt7TW5XZuF5sZDFrBjsIAkz+E8Xv7twJGOG81Zh0b0EP
        tx+NrhOjemlN+yl4Br7qH
X-Received: by 2002:a17:902:c402:: with SMTP id k2mr94419plk.308.1597650587403;
        Mon, 17 Aug 2020 00:49:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzueq0IKKElz/SyVLOuJIUIIO8gj6sTYrlAZi6eb3A4SYyDkE3uYBspiPYUtqa5sUzhcYQnSQ==
X-Received: by 2002:a17:902:c402:: with SMTP id k2mr94407plk.308.1597650587060;
        Mon, 17 Aug 2020 00:49:47 -0700 (PDT)
Received: from don.don ([60.224.129.195])
        by smtp.gmail.com with ESMTPSA id j5sm18717144pfg.80.2020.08.17.00.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 00:49:46 -0700 (PDT)
Subject: Re: [PATCH v2] xfstests: add test for xfs_repair progress reporting
To:     Eryu Guan <guan@eryu.me>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
References: <20200519160125.GB17621@magnolia>
 <20200520035258.298516-1-ddouwsma@redhat.com> <20200524164648.GB3363@desktop>
From:   Donald Douwsma <ddouwsma@redhat.com>
Message-ID: <7fb5ce19-dd6e-1e02-3120-16138320c5f6@redhat.com>
Date:   Mon, 17 Aug 2020 17:49:43 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200524164648.GB3363@desktop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eryu, 

Thanks for the feedback. Apologies for the delay getting back to you,
I hadn't noticed the rest of your questions under Darrick's reply.


On 25/05/2020 02:46, Eryu Guan wrote:
> On Wed, May 20, 2020 at 01:52:58PM +1000, Donald Douwsma wrote:
>> xfs_repair's interval based progress has been broken for
>> some time, create a test based on dmdelay to stretch out
>> the time and use ag_stride to force parallelism.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>> Changes since v1:
>> - Use _scratch_xfs_repair
>> - Filter only repair output
>> - Make the filter more tolerant of whitespace and plurals
>> - Take golden output from 'xfs_repair: fix progress reporting'
> 
> I saw failures like below, and I'm using v5.7-rc4 kernel and v5.4.0
> xfsprogs, is this expected failure?

This should be passing now.

> 
> @@ -2,8 +2,6 @@
>  Format and populate
>  Introduce a dmdelay
>  Run repair
> - - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
> - - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
>   - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
>   - #:#:#: process known inodes and inode discovery - # of # inodes done
>   - #:#:#: process newly discovered inodes - # of # allocation groups done
> @@ -12,4 +10,3 @@
>   - #:#:#: scanning filesystem freespace - # of # allocation groups done
>   - #:#:#: setting up duplicate extent list - # of # allocation groups done
>   - #:#:#: verify and correct link counts - # of # allocation groups done
> - - #:#:#: zeroing log - # of # blocks done
> 
>>
>>  tests/xfs/516     | 76 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/516.out | 15 ++++++++++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 92 insertions(+)
>>  create mode 100755 tests/xfs/516
>>  create mode 100644 tests/xfs/516.out
>>
>> diff --git a/tests/xfs/516 b/tests/xfs/516
>> new file mode 100755
>> index 00000000..1c0508ef
>> --- /dev/null
>> +++ b/tests/xfs/516
>> @@ -0,0 +1,76 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
>> +#
>> +# FS QA Test 516
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
> 
> 	rm -f $tmp.*
> 
> As some common helpers would use $tmp. files as well.
> 
>> +	cd /
>> +	_dmsetup_remove delay-test > /dev/null 2>&1
> 
> I think we could do _cleanup_delay here and discard the outputs.
> 

Fixed.

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
>> +_filter_repair()
> 
> Function names with the leading underscore are reserved for common
> helpers, filter_repair would be fine.

Fixed.

> 
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
>> +        tee -a $seqres.full > $seqres.xfs_repair.out
>> +
>> +cat $seqres.xfs_repair.out | _filter_repair | sort -u
> 
> I agreed with Darrick here. redirect output to $tmp.repair is better, as
> we already cleanup $tmp.* in _cleanup, and no one is cleaning up
> $seqres.xfs_repair.out file.
> 
>> +
>> +_cleanup_delay
> 
> We could remove this one if do it in _cleanup.

Done!

> 
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/xfs/516.out b/tests/xfs/516.out
>> new file mode 100644
>> index 00000000..85018b93
>> --- /dev/null
>> +++ b/tests/xfs/516.out
>> @@ -0,0 +1,15 @@
>> +QA output created by 516
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
>> index 12eb55c9..aeeca23f 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -513,3 +513,4 @@
>>  513 auto mount
>>  514 auto quick db
>>  515 auto quick quota
>> +516 repair
> 
> Should be in auto group as well? Only tests in auto (and quick, which is
> a sub-set of auto) will be run by default.

It doesn't seem there were any objections to adding it, so I've added it to
auto, I've left it out of quick for now. 

Regards, 
Don

