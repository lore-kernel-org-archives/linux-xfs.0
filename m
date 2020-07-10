Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E11C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 22:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E5FA2075D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 22:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGJWVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 18:21:42 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56695 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgGJWVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 18:21:42 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id EBE6210AA85;
        Sat, 11 Jul 2020 08:21:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ju1Of-0000n1-0h; Sat, 11 Jul 2020 08:21:33 +1000
Date:   Sat, 11 Jul 2020 08:21:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200710222132.GC2005@dread.disaster.area>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-2-cmaiolino@redhat.com>
 <20200710160804.GA10364@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710160804.GA10364@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=8wZEIu3nHaYhlynhxUEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 05:08:04PM +0100, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 5daef654956cb..8c3fe7ef56e27 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -35,15 +35,20 @@ xfs_inode_alloc(
> >  	xfs_ino_t		ino)
> >  {
> >  	struct xfs_inode	*ip;
> > +	gfp_t			gfp_mask = GFP_KERNEL;
> >  
> >  	/*
> > -	 * if this didn't occur in transactions, we could use
> > -	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
> > -	 * code up to do this anyway.
> > +	 * If this is inside a transaction, we can not fail here,
> > +	 * otherwise we can return NULL on ENOMEM.
> >  	 */
> > -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> > +
> > +	if (current->flags & PF_MEMALLOC_NOFS)
> > +		gfp_mask |= __GFP_NOFAIL;
> 
> I'm a little worried about this change in beavior here.  Can we
> just keep the unconditional __GFP_NOFAIL and if we really care do the
> change separately after the series?  At that point it should probably
> use the re-added PF_FSTRANS flag as well.

Checking PF_FSTRANS was what I suggested should be done here, not
PF_MEMALLOC_NOFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
