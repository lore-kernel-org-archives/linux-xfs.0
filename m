Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B94C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 00:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BA082067B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 00:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZLcW4v6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgFAAyK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 May 2020 20:54:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27104 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726081AbgFAAyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 May 2020 20:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590972847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+hRH1E1ERGI1jYA5Y+IstH8Yr4L4B5L4M6CjWisPJM=;
        b=JZLcW4v6Iwsu4t/68T15l0vilw8UFEx0zFx61Pc/w4r9x8LRMoYGt3fsM42UWca+nnPSLV
        xgvKazQ7rCi687LlLaECOr08jp0O5PKz7FQJtJX6olnGB6pMnKOA5YQ4Mpv4lCjFATaDNU
        /sIZkBesn9IEjceTRBcZ0hVr6wiCX8w=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-G0F6e5WxP4y9F5H_NPie0g-1; Sun, 31 May 2020 20:54:05 -0400
X-MC-Unique: G0F6e5WxP4y9F5H_NPie0g-1
Received: by mail-pj1-f71.google.com with SMTP id d3so7264055pjv.2
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 17:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A+hRH1E1ERGI1jYA5Y+IstH8Yr4L4B5L4M6CjWisPJM=;
        b=clGt/MDB3hTZ33er58TaCBbFAW+YfBZkj0pkTBHmuYfjWAVlbspRPJ06kT8GQkxiKn
         R4eMKPIKfafB+HnMkQX+0g2oSUTrXzmU756mDDaKr6jm+vR5NznsFPKNIYRW0Bps0JoW
         X92/2u3cwp05VAqBRCgf1ZKW3HQE9MinVrfiCGTN1lKqb7AnfpUgvByP++UFfmmAHzFS
         3pE7baqK7dOh69EwPk4eAeM6tUSd+EixnWcejryv5utiMiW79iIuY1XTPigKvidg45tS
         scoyyW6CGZWEpKpFh8/oYAmGrWRuJE2GytGbvuEzz+8g+W8hF58weCFD01HpHLS1YCgZ
         OTaw==
X-Gm-Message-State: AOAM533CcsdOXt//luqvUbgxWqKwsPTNwRfYQCjfym0g8ZKJ3XFLnXKt
        gwAo/1gKNWUltHdisKnhpSRvrN632FXDs0eg0Hbuy0t/mfGNc7iEjnxGXaJ91F1s0SvMAkPhyQT
        ypzpmvg23Lr9Pk/73qn6b
X-Received: by 2002:a17:90a:4497:: with SMTP id t23mr20819009pjg.88.1590972844054;
        Sun, 31 May 2020 17:54:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRtkPDQvseIzciaKTe8ek24kGZjIytmOuC85l7IR3K6EAjHrBgI18lGh3PO+TReMk+lYZ1AA==
X-Received: by 2002:a17:90a:4497:: with SMTP id t23mr20818990pjg.88.1590972843754;
        Sun, 31 May 2020 17:54:03 -0700 (PDT)
Received: from don.don ([60.224.129.195])
        by smtp.gmail.com with ESMTPSA id w26sm12630632pfj.20.2020.05.31.17.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2020 17:54:02 -0700 (PDT)
Subject: Re: [PATCH v2] xfstests: add test for xfs_repair progress reporting
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
References: <20200519160125.GB17621@magnolia>
 <20200520035258.298516-1-ddouwsma@redhat.com>
 <20200529080640.GH1938@dhcp-12-102.nay.redhat.com>
From:   Donald Douwsma <ddouwsma@redhat.com>
Message-ID: <3097a996-c661-d03f-a3e6-aa60ea808f04@redhat.com>
Date:   Mon, 1 Jun 2020 10:53:59 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529080640.GH1938@dhcp-12-102.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zorro,

On 29/05/2020 18:06, Zorro Lang wrote:
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
>> +	cd /
>> +	_dmsetup_remove delay-test > /dev/null 2>&1
> 
> How about use the helper, avoid using the 'delay-test' name at here?
> _cleanup_delay > /dev/null 2>&1
> 
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
>> +
>> +_cleanup_delay
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
> 
> I just tested on latest upstream xfsprogs-dev for-next branch, it failed as:
> --- /root/git/xfstests-dev/tests/xfs/516.out    2020-05-29 15:31:06.602440261 +0800
> +++ /root/git/xfstests-dev/results//xfs/516.out.bad     2020-05-29 15:40:13.401777675 +0800
> @@ -3,6 +3,7 @@
>  Introduce a dmdelay
>  Run repair
>   - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
> + - #:#:#: Phase #: #% done - estimated remaining time # second
>   - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
>   - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
>   - #:#:#: process known inodes and inode discovery - # of # inodes done
> 
> 
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
> Is there a reason why this case shouldn't be in auto group?
> 
> Thanks,
> Zorro


We could work to wards getting it into auto, I wanted to make sure it
was working ok first.

It takes about 2.5 min to run with the current image used by
_scratch_populate_cached, by its nature it needs time for the progress
code to fire, but that may be ok.

It sometimes leaves the delay-test active, I think because I've I used
_dmsetup_remove in _cleanup instead of _cleanup_delay because the later
unmounts the filesystem, which this test doesnt do, but I'd have to look
into this more so it plays well with other tests like the original
dmdelay unmount test 311.

I wasn't completely happy with the filter, it only checks that any of the
progress messages are printing at least once, which for most can still
just match on the end of phase printing, which always worked. Ideally it
would check that some of these messages print multiple times.

I can work on a V3 if this hasn't merged yet, or a follow up after, thoughts?

Cheers, 
Don


