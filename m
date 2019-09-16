Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D387C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECA8B214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbfIPVyu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 17:54:50 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48703 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730463AbfIPVyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 17:54:50 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4F23143DB11;
        Tue, 17 Sep 2019 07:54:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i9yxJ-0000vL-4z; Tue, 17 Sep 2019 07:54:45 +1000
Date:   Tue, 17 Sep 2019 07:54:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190916215445.GZ16973@dread.disaster.area>
References: <20190916153504.30809-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916153504.30809-1-billodo@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=hiNPt6W6QxSGO3wkO4gA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 10:35:04AM -0500, Bill O'Donnell wrote:
> Guarantee zeroed memory buffers for cases where potential memory
> leak to disk can occur. In these cases, kmem_alloc is used and
> doesn't zero the buffer, opening the possibility of information
> leakage to disk.
> 
> Introduce a xfs_buf_flag, _XBF_KMZ, to indicate a request for a zeroed
> buffer, and use existing infrastucture (xfs_buf_allocate_memory) to
> obtain the already zeroed buffer from kernel memory.
> 
> This solution avoids the performance issue that would occur if a
> wholesale change to replace kmem_alloc with kmem_zalloc was done.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 8 ++++++--
>  fs/xfs/xfs_buf.h | 4 +++-
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 120ef99d09e8..916a3f782950 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -345,16 +345,19 @@ xfs_buf_allocate_memory(
>  	unsigned short		page_count, i;
>  	xfs_off_t		start, end;
>  	int			error;
> +	uint			kmflag_mask = 0;
>  
>  	/*
>  	 * for buffers that are contained within a single page, just allocate
>  	 * the memory from the heap - there's no need for the complexity of
>  	 * page arrays to keep allocation down to order 0.
>  	 */
> +	if (flags & _XBF_KMZ)
> +		kmflag_mask |= KM_ZERO;
>  	size = BBTOB(bp->b_length);
>  	if (size < PAGE_SIZE) {
>  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> -		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
> +		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS | kmflag_mask);
>  		if (!bp->b_addr) {
>  			/* low memory - use alloc_page loop instead */
>  			goto use_alloc_page;
> @@ -391,7 +394,7 @@ xfs_buf_allocate_memory(
>  		struct page	*page;
>  		uint		retries = 0;
>  retry:
> -		page = alloc_page(gfp_mask);
> +		page = alloc_page(gfp_mask | kmflag_mask);
>  		if (unlikely(page == NULL)) {
>  			if (flags & XBF_READ_AHEAD) {
>  				bp->b_page_count = i;
> @@ -683,6 +686,7 @@ xfs_buf_get_map(
>  	struct xfs_buf		*new_bp;
>  	int			error = 0;
>  
> +	flags |= _XBF_KMZ;
>  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);

IIRC, this flag was supposed to go into xfs_trans_get_buf_map()
and direct callers of xfs_buf_get*() that weren't in the read path.
That avoids the need for zeroing pages that we are going to DMA
actual data into before it gets to users...

>  	switch (error) {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index f6ce17d8d848..416ff588240a 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -38,6 +38,7 @@
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
>  #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
> +#define _XBF_KMZ	 (1 << 23)/* zeroed buffer required */

"KMZ" isn't very descriptive, and it shouldn't have a "_" prefix as
it's not internal to the buffer cache - it's a caller controlled
flag like XBF_TRYLOCK.

I'd suggest something like XBF_INIT_PAGES or XBF_ZERO to make it
clear we are asking for ithe buffer to be explicitly initialised
to zero.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
