Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D26C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 15:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54CDA206BA
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 15:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfHUPXc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 11:23:32 -0400
Received: from sandeen.net ([63.231.237.45]:57316 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbfHUPXb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 11:23:31 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C248417DFF;
        Wed, 21 Aug 2019 10:23:30 -0500 (CDT)
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
To:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com> <20190821133533.GB19646@bfoster>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <f559978b-4c82-87ed-a79c-5c63228f4955@sandeen.net>
Date:   Wed, 21 Aug 2019 10:23:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821133533.GB19646@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/21/19 8:35 AM, Brian Foster wrote:
> On Wed, Aug 21, 2019 at 06:38:19PM +1000, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Memory we use to submit for IO needs strict alignment to the
>> underlying driver contraints. Worst case, this is 512 bytes. Given
>> that all allocations for IO are always a power of 2 multiple of 512
>> bytes, the kernel heap provides natural alignment for objects of
>> these sizes and that suffices.
>>
>> Until, of course, memory debugging of some kind is turned on (e.g.
>> red zones, poisoning, KASAN) and then the alignment of the heap
>> objects is thrown out the window. Then we get weird IO errors and
>> data corruption problems because drivers don't validate alignment
>> and do the wrong thing when passed unaligned memory buffers in bios.
>>
>> TO fix this, introduce kmem_alloc_io(), which will guaranteeat least
> 
> s/TO/To/
> 
>> 512 byte alignment of buffers for IO, even if memory debugging
>> options are turned on. It is assumed that the minimum allocation
>> size will be 512 bytes, and that sizes will be power of 2 mulitples
>> of 512 bytes.
>>
>> Use this everywhere we allocate buffers for IO.
>>
>> This no longer fails with log recovery errors when KASAN is enabled
>> due to the brd driver not handling unaligned memory buffers:
>>
>> # mkfs.xfs -f /dev/ram0 ; mount /dev/ram0 /mnt/test
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>  fs/xfs/kmem.c            | 61 +++++++++++++++++++++++++++++-----------
>>  fs/xfs/kmem.h            |  1 +
>>  fs/xfs/xfs_buf.c         |  4 +--
>>  fs/xfs/xfs_log.c         |  2 +-
>>  fs/xfs/xfs_log_recover.c |  2 +-
>>  fs/xfs/xfs_trace.h       |  1 +
>>  6 files changed, 50 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
>> index edcf393c8fd9..ec693c0fdcff 100644
>> --- a/fs/xfs/kmem.c
>> +++ b/fs/xfs/kmem.c
> ...
>> @@ -62,6 +56,39 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>>  	return ptr;
>>  }
>>  
>> +/*
>> + * Same as kmem_alloc_large, except we guarantee a 512 byte aligned buffer is
>> + * returned. vmalloc always returns an aligned region.
>> + */
>> +void *
>> +kmem_alloc_io(size_t size, xfs_km_flags_t flags)
>> +{
>> +	void	*ptr;
>> +
>> +	trace_kmem_alloc_io(size, flags, _RET_IP_);
>> +
>> +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
>> +	if (ptr) {
>> +		if (!((long)ptr & 511))
>> +			return ptr;
>> +		kfree(ptr);
>> +	}
>> +	return __kmem_vmalloc(size, flags);
>> +}
> 
> Even though it is unfortunate, this seems like a quite reasonable and
> isolated temporary solution to the problem to me. The one concern I have
> is if/how much this could affect performance under certain
> circumstances. I realize that these callsites are isolated in the common
> scenario. Less common scenarios like sub-page block sizes (whether due
> to explicit mkfs time format or default configurations on larger page
> size systems) can fall into this path much more frequently, however.
> 
> Since this implies some kind of vm debug option is enabled, performance
> itself isn't critical when this solution is active. But how bad is it in
> those cases where we might depend on this more heavily? Have you
> confirmed that the end configuration is still "usable," at least?
> 
> I ask because the repeated alloc/free behavior can easily be avoided via
> something like an mp flag (which may require a tweak to the
> kmem_alloc_io() interface) to skip further kmem_alloc() calls from this
> path once we see one unaligned allocation. That assumes this behavior is
> tied to functionality that isn't dynamically configured at runtime, of
> course.

This seems like a good idea to me.

-Eric
