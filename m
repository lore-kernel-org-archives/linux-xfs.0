Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434B1C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 15:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 011AB20870
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 15:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tr4ALKKH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbfHUPIV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 11:08:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55522 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbfHUPIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 11:08:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7LF3lIb136203;
        Wed, 21 Aug 2019 15:08:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KJc2jrsQogNjCpz+9eDTcz/WLGPKNdua5K1YaYro0oM=;
 b=Tr4ALKKHdvd+8F6oNbOSIDbY+klfhQXelxt40Gy+7XiMpHA4DQ+whFGoQ5kXMRkJT29i
 HFzWMGlxk0ySEmD4oGxiITjN08dUvgwFy9ZLkdZ0o9zAa6WzxZzhJbHpY4bHvetlzMnz
 0cUn/jByDRKzlyWxWbaREoQHjEnt/kqavlhBhR6fPRhTWpBHftZEQDTDMUTrO3gYhQPa
 ZBH8Sa3C/pesg6vVISVfZYbrjJ+v42shzJkMCVYgCzlQD9lr0cDACmTwiSA6m6RlMqQ0
 3563LFcRbPJG9MPtAYa6VFdgDNDJvi98POPLVwVQlmhW2pWDhGIkdlTILKsNMO+dZFcA GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ue9hpp60f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 15:08:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7LF3ZaT027885;
        Wed, 21 Aug 2019 15:08:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ugj7q0syn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 15:08:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7LF82e6031590;
        Wed, 21 Aug 2019 15:08:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Aug 2019 08:08:02 -0700
Date:   Wed, 21 Aug 2019 08:08:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
Message-ID: <20190821150801.GF1037350@magnolia>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com>
 <20190821133533.GB19646@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821133533.GB19646@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908210161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 09:35:33AM -0400, Brian Foster wrote:
> On Wed, Aug 21, 2019 at 06:38:19PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Memory we use to submit for IO needs strict alignment to the
> > underlying driver contraints. Worst case, this is 512 bytes. Given
> > that all allocations for IO are always a power of 2 multiple of 512
> > bytes, the kernel heap provides natural alignment for objects of
> > these sizes and that suffices.
> > 
> > Until, of course, memory debugging of some kind is turned on (e.g.
> > red zones, poisoning, KASAN) and then the alignment of the heap
> > objects is thrown out the window. Then we get weird IO errors and
> > data corruption problems because drivers don't validate alignment
> > and do the wrong thing when passed unaligned memory buffers in bios.
> > 
> > TO fix this, introduce kmem_alloc_io(), which will guaranteeat least
> 
> s/TO/To/
> 
> > 512 byte alignment of buffers for IO, even if memory debugging
> > options are turned on. It is assumed that the minimum allocation
> > size will be 512 bytes, and that sizes will be power of 2 mulitples
> > of 512 bytes.
> > 
> > Use this everywhere we allocate buffers for IO.
> > 
> > This no longer fails with log recovery errors when KASAN is enabled
> > due to the brd driver not handling unaligned memory buffers:
> > 
> > # mkfs.xfs -f /dev/ram0 ; mount /dev/ram0 /mnt/test
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/kmem.c            | 61 +++++++++++++++++++++++++++++-----------
> >  fs/xfs/kmem.h            |  1 +
> >  fs/xfs/xfs_buf.c         |  4 +--
> >  fs/xfs/xfs_log.c         |  2 +-
> >  fs/xfs/xfs_log_recover.c |  2 +-
> >  fs/xfs/xfs_trace.h       |  1 +
> >  6 files changed, 50 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > index edcf393c8fd9..ec693c0fdcff 100644
> > --- a/fs/xfs/kmem.c
> > +++ b/fs/xfs/kmem.c
> ...
> > @@ -62,6 +56,39 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> >  	return ptr;
> >  }
> >  
> > +/*
> > + * Same as kmem_alloc_large, except we guarantee a 512 byte aligned buffer is
> > + * returned. vmalloc always returns an aligned region.
> > + */
> > +void *
> > +kmem_alloc_io(size_t size, xfs_km_flags_t flags)
> > +{
> > +	void	*ptr;
> > +
> > +	trace_kmem_alloc_io(size, flags, _RET_IP_);
> > +
> > +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> > +	if (ptr) {
> > +		if (!((long)ptr & 511))

Er... didn't you say "it needs to grab the alignment from
[blk_]queue_dma_alignment(), not use a hard coded value of 511"?

How is this different?  If this buffer is really for IO then shouldn't
we pass in the buftarg or something so that we find the real alignment?
Or check it down in the xfs_buf code that associates a page to a buffer?

Even if all that logic is hidden behind CONFIG_XFS_DEBUG?

> > +			return ptr;
> > +		kfree(ptr);
> > +	}
> > +	return __kmem_vmalloc(size, flags);

How about checking the vmalloc alignment too?  If we're going to be this
paranoid we might as well go all the way. :)

--D

> > +}
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
> 
> Brian
> 
> > +
> > +void *
> > +kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> > +{
> > +	void	*ptr;
> > +
> > +	trace_kmem_alloc_large(size, flags, _RET_IP_);
> > +
> > +	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> > +	if (ptr)
> > +		return ptr;
> > +	return __kmem_vmalloc(size, flags);
> > +}
> > +
> >  void *
> >  kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
> >  {
> > diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> > index 267655acd426..423a1fa0fcd6 100644
> > --- a/fs/xfs/kmem.h
> > +++ b/fs/xfs/kmem.h
> > @@ -59,6 +59,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
> >  }
> >  
> >  extern void *kmem_alloc(size_t, xfs_km_flags_t);
> > +extern void *kmem_alloc_io(size_t, xfs_km_flags_t);
> >  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
> >  extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
> >  static inline void  kmem_free(const void *ptr)
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index ca0849043f54..7bd1f31febfc 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -353,7 +353,7 @@ xfs_buf_allocate_memory(
> >  	 */
> >  	size = BBTOB(bp->b_length);
> >  	if (size < PAGE_SIZE) {
> > -		bp->b_addr = kmem_alloc(size, KM_NOFS);
> > +		bp->b_addr = kmem_alloc_io(size, KM_NOFS);
> >  		if (!bp->b_addr) {
> >  			/* low memory - use alloc_page loop instead */
> >  			goto use_alloc_page;
> > @@ -368,7 +368,7 @@ xfs_buf_allocate_memory(
> >  		}
> >  		bp->b_offset = offset_in_page(bp->b_addr);
> >  		bp->b_pages = bp->b_page_array;
> > -		bp->b_pages[0] = virt_to_page(bp->b_addr);
> > +		bp->b_pages[0] = kmem_to_page(bp->b_addr);
> >  		bp->b_page_count = 1;
> >  		bp->b_flags |= _XBF_KMEM;
> >  		return 0;
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 7fc3c1ad36bc..1830d185d7fc 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1415,7 +1415,7 @@ xlog_alloc_log(
> >  		iclog->ic_prev = prev_iclog;
> >  		prev_iclog = iclog;
> >  
> > -		iclog->ic_data = kmem_alloc_large(log->l_iclog_size,
> > +		iclog->ic_data = kmem_alloc_io(log->l_iclog_size,
> >  				KM_MAYFAIL);
> >  		if (!iclog->ic_data)
> >  			goto out_free_iclog;
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 13d1d3e95b88..b4a6a008986b 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -125,7 +125,7 @@ xlog_alloc_buffer(
> >  	if (nbblks > 1 && log->l_sectBBsize > 1)
> >  		nbblks += log->l_sectBBsize;
> >  	nbblks = round_up(nbblks, log->l_sectBBsize);
> > -	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
> > +	return kmem_alloc_io(BBTOB(nbblks), KM_MAYFAIL);
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 8bb8b4704a00..eaae275ed430 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3604,6 +3604,7 @@ DEFINE_EVENT(xfs_kmem_class, name, \
> >  	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
> >  	TP_ARGS(size, flags, caller_ip))
> >  DEFINE_KMEM_EVENT(kmem_alloc);
> > +DEFINE_KMEM_EVENT(kmem_alloc_io);
> >  DEFINE_KMEM_EVENT(kmem_alloc_large);
> >  DEFINE_KMEM_EVENT(kmem_realloc);
> >  DEFINE_KMEM_EVENT(kmem_zone_alloc);
> > -- 
> > 2.23.0.rc1
> > 
