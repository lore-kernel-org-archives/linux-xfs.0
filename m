Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0188DC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E8B206C2
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389196AbfIPVc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 17:32:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389236AbfIPVcz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 17:32:55 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 937A089F39E;
        Mon, 16 Sep 2019 21:32:55 +0000 (UTC)
Received: from redhat.com (ovpn-122-216.rdu2.redhat.com [10.10.122.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F3535D6B2;
        Mon, 16 Sep 2019 21:32:54 +0000 (UTC)
Date:   Mon, 16 Sep 2019 16:32:53 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190916213253.GA13257@redhat.com>
References: <20190916153504.30809-1-billodo@redhat.com>
 <5f1bcfbd-f16b-6d8a-416d-3a0639b9c7fe@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f1bcfbd-f16b-6d8a-416d-3a0639b9c7fe@sandeen.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Mon, 16 Sep 2019 21:32:55 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 04:24:40PM -0500, Eric Sandeen wrote:
> On 9/16/19 10:35 AM, Bill O'Donnell wrote:
> > Guarantee zeroed memory buffers for cases where potential memory
> > leak to disk can occur. In these cases, kmem_alloc is used and
> > doesn't zero the buffer, opening the possibility of information
> > leakage to disk.
> > 
> > Introduce a xfs_buf_flag, _XBF_KMZ, to indicate a request for a zeroed
> > buffer, and use existing infrastucture (xfs_buf_allocate_memory) to
> > obtain the already zeroed buffer from kernel memory.
> > 
> > This solution avoids the performance issue that would occur if a
> > wholesale change to replace kmem_alloc with kmem_zalloc was done.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> 
> I think this can probably be further optimized by not obtaining zeroed
> memory when we're about to fill the buffer from disk as the very
> next step.

Yep. I missed that redundancy.

> 
> (in this case, xfs_buf_read_map calls xfs_buf_get_map and then immediately
> reads the buffer from disk with _xfs_buf_read)  xfs_buf_read_map adds
> XBF_READ to the flags during this process.
> 
> So I wonder if this can be simplified/optimized by just checking for XBF_READ
> in xfs_buf_allocate_memory's flags, and if it's not set, then request
> zeroed memory, because that indicates a buffer we'll be filling in from
> memory and subsequently writing to disk.

nod.

> 
> -Eric
> 
> > ---
> >  fs/xfs/xfs_buf.c | 8 ++++++--
> >  fs/xfs/xfs_buf.h | 4 +++-
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 120ef99d09e8..916a3f782950 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -345,16 +345,19 @@ xfs_buf_allocate_memory(
> >  	unsigned short		page_count, i;
> >  	xfs_off_t		start, end;
> >  	int			error;
> > +	uint			kmflag_mask = 0;
> >  
> >  	/*
> >  	 * for buffers that are contained within a single page, just allocate
> >  	 * the memory from the heap - there's no need for the complexity of
> >  	 * page arrays to keep allocation down to order 0.
> >  	 */
> > +	if (flags & _XBF_KMZ)
> > +		kmflag_mask |= KM_ZERO;
> >  	size = BBTOB(bp->b_length);
> >  	if (size < PAGE_SIZE) {
> >  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> > -		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
> > +		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS | kmflag_mask);
> >  		if (!bp->b_addr) {
> >  			/* low memory - use alloc_page loop instead */
> >  			goto use_alloc_page;
> > @@ -391,7 +394,7 @@ xfs_buf_allocate_memory(
> >  		struct page	*page;
> >  		uint		retries = 0;
> >  retry:
> > -		page = alloc_page(gfp_mask);
> > +		page = alloc_page(gfp_mask | kmflag_mask);
> >  		if (unlikely(page == NULL)) {
> >  			if (flags & XBF_READ_AHEAD) {
> >  				bp->b_page_count = i;
> > @@ -683,6 +686,7 @@ xfs_buf_get_map(
> >  	struct xfs_buf		*new_bp;
> >  	int			error = 0;
> >  
> > +	flags |= _XBF_KMZ;
> >  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
> >  
> >  	switch (error) {
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index f6ce17d8d848..416ff588240a 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -38,6 +38,7 @@
> >  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> >  #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
> >  #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
> > +#define _XBF_KMZ	 (1 << 23)/* zeroed buffer required */
> >  
> >  typedef unsigned int xfs_buf_flags_t;
> >  
> > @@ -54,7 +55,8 @@ typedef unsigned int xfs_buf_flags_t;
> >  	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
> >  	{ _XBF_PAGES,		"PAGES" }, \
> >  	{ _XBF_KMEM,		"KMEM" }, \
> > -	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
> > +	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> > +	{ _XBF_KMZ,             "KMEM_Z" }
> >  
> >  
> >  /*
> > 
