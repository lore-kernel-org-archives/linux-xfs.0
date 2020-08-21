Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C561C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 12:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044FF2078D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 12:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="Q8Rrd25R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgHUMMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 08:12:43 -0400
Received: from fanzine.igalia.com ([178.60.130.6]:36192 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgHUMMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 08:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:Subject:Cc:To:From; bh=SHsuFs9mT8gT5ADLBvdeofOS9XickGEVntwzc4rnjUA=;
        b=Q8Rrd25RHlbCA6hJIiHKHO2khXK/NszKZmYqY+V0R0hdKKwc7JnBYXuADW5+sXTJ5BXyjvE0EATMMoQH5Bn/e1VlRvjtNc78EQuXg5F6lr22Nygc0Sk/IQuDjXDhUSS3fuKcqtTsuCgZi602xSg34SArkFsNC3Vk3Z84HuHkxSqsWhTM4HrD/jJkaBGTYezp0/YEYl6P1EWjW5G5MXErghMDMXEMwmiP9z4XlThxfDGK/dhKApyQulrd8aeGeEFn4rqm72RFgnF3BW+ELSrGR/ysA/bZog9x9ak/rDAj+MZA+PnCtrfJnQ3d6o1cxAodJLHpzuReD1GgcacXmO9Gvg==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
        by fanzine.igalia.com with esmtps 
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1k95uK-0003Dw-Cq; Fri, 21 Aug 2020 14:12:32 +0200
Received: from berto by mail.igalia.com with local (Exim)
        id 1k95uK-0006lS-28; Fri, 21 Aug 2020 14:12:32 +0200
From:   Alberto Garcia <berto@igalia.com>
To:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero cluster
In-Reply-To: <w51364gjkcj.fsf@maestria.local.igalia.com>
References: <cover.1597416317.git.berto@igalia.com> <20200817101019.GD11402@linux.fritz.box> <w518sedz3td.fsf@maestria.local.igalia.com> <20200817155307.GS11402@linux.fritz.box> <w51pn7memr7.fsf@maestria.local.igalia.com> <20200819150711.GE10272@linux.fritz.box> <20200819175300.GA141399@bfoster> <w51v9hdultt.fsf@maestria.local.igalia.com> <20200820215811.GC7941@dread.disaster.area> <20200821110506.GB212879@bfoster> <w51364gjkcj.fsf@maestria.local.igalia.com>
User-Agent: Notmuch/0.18.2 (http://notmuchmail.org) Emacs/24.4.1 (i586-pc-linux-gnu)
Date:   Fri, 21 Aug 2020 14:12:32 +0200
Message-ID: <w51zh6oi4en.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri 21 Aug 2020 01:42:52 PM CEST, Alberto Garcia wrote:
> On Fri 21 Aug 2020 01:05:06 PM CEST, Brian Foster <bfoster@redhat.com> wrote:
>>> > 1) off: for every write request QEMU initializes the cluster (64KB)
>>> >         with fallocate(ZERO_RANGE) and then writes the 4KB of data.
>>> > 
>>> > 2) off w/o ZERO_RANGE: QEMU writes the 4KB of data and fills the rest
>>> >         of the cluster with zeroes.
>>> > 
>>> > 3) metadata: all clusters were allocated when the image was created
>>> >         but they are sparse, QEMU only writes the 4KB of data.
>>> > 
>>> > 4) falloc: all clusters were allocated with fallocate() when the image
>>> >         was created, QEMU only writes 4KB of data.
>>> > 
>>> > 5) full: all clusters were allocated by writing zeroes to all of them
>>> >         when the image was created, QEMU only writes 4KB of data.
>>> > 
>>> > As I said in a previous message I'm not familiar with xfs, but the
>>> > parts that I don't understand are
>>> > 
>>> >    - Why is (4) slower than (1)?
>>> 
>>> Because fallocate() is a full IO serialisation barrier at the
>>> filesystem level. If you do:
>>> 
>>> fallocate(whole file)
>>> <IO>
>>> <IO>
>>> <IO>
>>> .....
>>> 
>>> The IO can run concurrent and does not serialise against anything in
>>> the filesysetm except unwritten extent conversions at IO completion
>>> (see answer to next question!)
>>> 
>>> However, if you just use (4) you get:
>>> 
>>> falloc(64k)
>>>   <wait for inflight IO to complete>
>>>   <allocates 64k as unwritten>
>>> <4k io>
>>>   ....
>>> falloc(64k)
>>>   <wait for inflight IO to complete>
>>>   ....
>>>   <4k IO completes, converts 4k to written>
>>>   <allocates 64k as unwritten>
>>> <4k io>
>>> falloc(64k)
>>>   <wait for inflight IO to complete>
>>>   ....
>>>   <4k IO completes, converts 4k to written>
>>>   <allocates 64k as unwritten>
>>> <4k io>
>>>   ....
>>> 
>>
>> Option 4 is described above as initial file preallocation whereas
>> option 1 is per 64k cluster prealloc. Prealloc mode mixup aside, Berto
>> is reporting that the initial file preallocation mode is slower than
>> the per cluster prealloc mode. Berto, am I following that right?

After looking more closely at the data I can see that there is a peak of
~30K IOPS during the first 5 or 6 seconds and then it suddenly drops to
~7K for the rest of the test.

I was running fio with --ramp_time=5 which ignores the first 5 seconds
of data in order to let performance settle, but if I remove that I can
see the effect more clearly. I can observe it with raw files (in 'off'
and 'prealloc' modes) and qcow2 files in 'prealloc' mode. With qcow2 and
preallocation=off the performance is stable during the whole test.

Berto
