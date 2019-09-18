Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8335C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 22:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83773218AF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 22:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfIRWLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 18:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfIRWLU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 18:11:20 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 628E03084295;
        Wed, 18 Sep 2019 22:11:20 +0000 (UTC)
Received: from redhat.com (ovpn-123-212.rdu2.redhat.com [10.10.123.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF09C5D9CC;
        Wed, 18 Sep 2019 22:11:19 +0000 (UTC)
Date:   Wed, 18 Sep 2019 17:11:18 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190918221118.GA6418@redhat.com>
References: <20190916153504.30809-1-billodo@redhat.com>
 <20190918154733.24355-1-billodo@redhat.com>
 <20190918163212.GA568270@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918163212.GA568270@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 18 Sep 2019 22:11:20 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 09:32:13AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 18, 2019 at 10:47:33AM -0500, Bill O'Donnell wrote:
> > Guarantee zeroed memory buffers for cases where potential memory
> > leak to disk can occur. In these cases, kmem_alloc is used and
> > doesn't zero the buffer, opening the possibility of information
> > leakage to disk.
> > 
> > Introduce a xfs_buf_flag, XBF_ZERO, to indicate a request for a zeroed
> > buffer, and use existing infrastucture (xfs_buf_allocate_memory) to
> > obtain the already zeroed buffer from kernel memory.
> > 
> > This solution avoids the performance issue that would occur if a
> > wholesale change to replace kmem_alloc with kmem_zalloc was done.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> > v2: zeroed buffer not required for XBF_READ case. Correct placement
> >     and rename the XBF_ZERO flag.
> > 
> >  fs/xfs/xfs_buf.c       | 9 +++++++--
> >  fs/xfs/xfs_buf.h       | 2 ++
> >  fs/xfs/xfs_trans_buf.c | 2 ++
> >  3 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 120ef99d09e8..0d96efff451e 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -345,6 +345,10 @@ xfs_buf_allocate_memory(
> >  	unsigned short		page_count, i;
> >  	xfs_off_t		start, end;
> >  	int			error;
> > +	uint			kmflag_mask = 0;
> > +
> > +	if ((flags & XBF_ZERO) && !(flags & XBF_READ))
> 
> The sole caller of xfs_buf_allocate_memory is xfs_buf_get_map.  If
> _get_map is called from the *read_buf* functions, they pass in XBF_READ
> to ensure buffer contents are read.  The other _get_map callers seem to
> be initializing metadata blocks and do not set XBF_READ.
> 
> So I wonder, do you even need XBF_ZERO?  Or could this be reduced to:
> 
> 	if (!(flags & XBF_READ))
> 		km_flag_mask |= KM_ZERO;
> 
> ?
> 
> --D

Yeah, I see no cases of XBF_ZERO true AND XBF_READ true.
Anytime XBF_ZERO is true, XBF_READ is false.
So, yes, it could be reduced by eliminating XBF_ZERO.

Thanks,
Bill

> 
> > +		kmflag_mask |= KM_ZERO;
> >  
> >  	/*
> >  	 * for buffers that are contained within a single page, just allocate
> > @@ -354,7 +358,8 @@ xfs_buf_allocate_memory(
> >  	size = BBTOB(bp->b_length);
> >  	if (size < PAGE_SIZE) {
> >  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> > -		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
> > +		bp->b_addr = kmem_alloc_io(size, align_mask,
> > +					   KM_NOFS | kmflag_mask);
> >  		if (!bp->b_addr) {
> >  			/* low memory - use alloc_page loop instead */
> >  			goto use_alloc_page;
> > @@ -391,7 +396,7 @@ xfs_buf_allocate_memory(
> >  		struct page	*page;
> >  		uint		retries = 0;
> >  retry:
> > -		page = alloc_page(gfp_mask);
> > +		page = alloc_page(gfp_mask | kmflag_mask);
> >  		if (unlikely(page == NULL)) {
> >  			if (flags & XBF_READ_AHEAD) {
> >  				bp->b_page_count = i;
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index f6ce17d8d848..dccdd653c9dc 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -33,6 +33,7 @@
> >  /* flags used only as arguments to access routines */
> >  #define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
> >  #define XBF_UNMAPPED	 (1 << 17)/* do not map the buffer */
> > +#define XBF_ZERO	 (1 << 18)/* zeroed buffer required */
> >  
> >  /* flags used only internally */
> >  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> > @@ -52,6 +53,7 @@ typedef unsigned int xfs_buf_flags_t;
> >  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
> >  	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
> >  	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
> > +	{ XBF_ZERO,		"KMEM_ZERO" }, \
> >  	{ _XBF_PAGES,		"PAGES" }, \
> >  	{ _XBF_KMEM,		"KMEM" }, \
> >  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index b5b3a78ef31c..087d413c1490 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -123,6 +123,8 @@ xfs_trans_get_buf_map(
> >  	xfs_buf_t		*bp;
> >  	struct xfs_buf_log_item	*bip;
> >  
> > +	flags |= XBF_ZERO;
> > +
> >  	if (!tp)
> >  		return xfs_buf_get_map(target, map, nmaps, flags);
> >  
> > -- 
> > 2.21.0
> > 
