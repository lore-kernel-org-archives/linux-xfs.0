Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEB8C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 13:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CC1520679
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 13:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfHUNfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 09:35:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfHUNfg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 09:35:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6AA23082B02;
        Wed, 21 Aug 2019 13:35:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 901D81001925;
        Wed, 21 Aug 2019 13:35:35 +0000 (UTC)
Date:   Wed, 21 Aug 2019 09:35:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
Message-ID: <20190821133533.GB19646@bfoster>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821083820.11725-3-david@fromorbit.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 21 Aug 2019 13:35:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 06:38:19PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Memory we use to submit for IO needs strict alignment to the
> underlying driver contraints. Worst case, this is 512 bytes. Given
> that all allocations for IO are always a power of 2 multiple of 512
> bytes, the kernel heap provides natural alignment for objects of
> these sizes and that suffices.
> 
> Until, of course, memory debugging of some kind is turned on (e.g.
> red zones, poisoning, KASAN) and then the alignment of the heap
> objects is thrown out the window. Then we get weird IO errors and
> data corruption problems because drivers don't validate alignment
> and do the wrong thing when passed unaligned memory buffers in bios.
> 
> TO fix this, introduce kmem_alloc_io(), which will guaranteeat least

s/TO/To/

> 512 byte alignment of buffers for IO, even if memory debugging
> options are turned on. It is assumed that the minimum allocation
> size will be 512 bytes, and that sizes will be power of 2 mulitples
> of 512 bytes.
> 
> Use this everywhere we allocate buffers for IO.
> 
> This no longer fails with log recovery errors when KASAN is enabled
> due to the brd driver not handling unaligned memory buffers:
> 
> # mkfs.xfs -f /dev/ram0 ; mount /dev/ram0 /mnt/test
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/kmem.c            | 61 +++++++++++++++++++++++++++++-----------
>  fs/xfs/kmem.h            |  1 +
>  fs/xfs/xfs_buf.c         |  4 +--
>  fs/xfs/xfs_log.c         |  2 +-
>  fs/xfs/xfs_log_recover.c |  2 +-
>  fs/xfs/xfs_trace.h       |  1 +
>  6 files changed, 50 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index edcf393c8fd9..ec693c0fdcff 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
...
> @@ -62,6 +56,39 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>  	return ptr;
>  }
>  
> +/*
> + * Same as kmem_alloc_large, except we guarantee a 512 byte aligned buffer is
> + * returned. vmalloc always returns an aligned region.
> + */
> +void *
> +kmem_alloc_io(size_t size, xfs_km_flags_t flags)
> +{
> +	void	*ptr;
> +
> +	trace_kmem_alloc_io(size, flags, _RET_IP_);
> +
> +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> +	if (ptr) {
> +		if (!((long)ptr & 511))
> +			return ptr;
> +		kfree(ptr);
> +	}
> +	return __kmem_vmalloc(size, flags);
> +}

Even though it is unfortunate, this seems like a quite reasonable and
isolated temporary solution to the problem to me. The one concern I have
is if/how much this could affect performance under certain
circumstances. I realize that these callsites are isolated in the common
scenario. Less common scenarios like sub-page block sizes (whether due
to explicit mkfs time format or default configurations on larger page
size systems) can fall into this path much more frequently, however.

Since this implies some kind of vm debug option is enabled, performance
itself isn't critical when this solution is active. But how bad is it in
those cases where we might depend on this more heavily? Have you
confirmed that the end configuration is still "usable," at least?

I ask because the repeated alloc/free behavior can easily be avoided via
something like an mp flag (which may require a tweak to the
kmem_alloc_io() interface) to skip further kmem_alloc() calls from this
path once we see one unaligned allocation. That assumes this behavior is
tied to functionality that isn't dynamically configured at runtime, of
course.

Brian

> +
> +void *
> +kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> +{
> +	void	*ptr;
> +
> +	trace_kmem_alloc_large(size, flags, _RET_IP_);
> +
> +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> +	if (ptr)
> +		return ptr;
> +	return __kmem_vmalloc(size, flags);
> +}
> +
>  void *
>  kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
>  {
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 267655acd426..423a1fa0fcd6 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -59,6 +59,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  }
>  
>  extern void *kmem_alloc(size_t, xfs_km_flags_t);
> +extern void *kmem_alloc_io(size_t, xfs_km_flags_t);
>  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
>  extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
>  static inline void  kmem_free(const void *ptr)
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ca0849043f54..7bd1f31febfc 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -353,7 +353,7 @@ xfs_buf_allocate_memory(
>  	 */
>  	size = BBTOB(bp->b_length);
>  	if (size < PAGE_SIZE) {
> -		bp->b_addr = kmem_alloc(size, KM_NOFS);
> +		bp->b_addr = kmem_alloc_io(size, KM_NOFS);
>  		if (!bp->b_addr) {
>  			/* low memory - use alloc_page loop instead */
>  			goto use_alloc_page;
> @@ -368,7 +368,7 @@ xfs_buf_allocate_memory(
>  		}
>  		bp->b_offset = offset_in_page(bp->b_addr);
>  		bp->b_pages = bp->b_page_array;
> -		bp->b_pages[0] = virt_to_page(bp->b_addr);
> +		bp->b_pages[0] = kmem_to_page(bp->b_addr);
>  		bp->b_page_count = 1;
>  		bp->b_flags |= _XBF_KMEM;
>  		return 0;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7fc3c1ad36bc..1830d185d7fc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1415,7 +1415,7 @@ xlog_alloc_log(
>  		iclog->ic_prev = prev_iclog;
>  		prev_iclog = iclog;
>  
> -		iclog->ic_data = kmem_alloc_large(log->l_iclog_size,
> +		iclog->ic_data = kmem_alloc_io(log->l_iclog_size,
>  				KM_MAYFAIL);
>  		if (!iclog->ic_data)
>  			goto out_free_iclog;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 13d1d3e95b88..b4a6a008986b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -125,7 +125,7 @@ xlog_alloc_buffer(
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
> -	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
> +	return kmem_alloc_io(BBTOB(nbblks), KM_MAYFAIL);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8bb8b4704a00..eaae275ed430 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3604,6 +3604,7 @@ DEFINE_EVENT(xfs_kmem_class, name, \
>  	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
>  	TP_ARGS(size, flags, caller_ip))
>  DEFINE_KMEM_EVENT(kmem_alloc);
> +DEFINE_KMEM_EVENT(kmem_alloc_io);
>  DEFINE_KMEM_EVENT(kmem_alloc_large);
>  DEFINE_KMEM_EVENT(kmem_realloc);
>  DEFINE_KMEM_EVENT(kmem_zone_alloc);
> -- 
> 2.23.0.rc1
> 
