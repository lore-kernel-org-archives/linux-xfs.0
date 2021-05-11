Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E39C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 07:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE9C61490
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 07:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhEKHUZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 03:20:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53526 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhEKHUO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 03:20:14 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3F7F2104321F;
        Tue, 11 May 2021 17:19:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lgMfZ-00DUkS-Od; Tue, 11 May 2021 17:19:05 +1000
Date:   Tue, 11 May 2021 17:19:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/22] xfs: prepare for moving perag definitions and
 support to libxfs
Message-ID: <20210511071905.GR63242@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-3-david@fromorbit.com>
 <YJksyJDAfDmv326/@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJksyJDAfDmv326/@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=2loSEbv1Pm2Ynvyrl7gA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 10, 2021 at 08:53:28AM -0400, Brian Foster wrote:
> On Thu, May 06, 2021 at 05:20:34PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The perag structures really need to be defined with the rest of the
> > AG support infrastructure. The struct xfs_perag and init/teardown
> > has been placed in xfs_mount.[ch] because there are differences in
> > the structure between kernel and userspace. Mainly that userspace
> > doesn't have a lot of the internal stuff that the kernel has for
> > caches and discard and other such structures.
> > 
> > However, it makes more sense to move this to libxfs than to keep
> > this separation because we are now moving to use struct perags
> > everywhere in the code instead of passing raw agnumber_t values
> > about. Hence we shoudl really move the support infrastructure to
> > libxfs/xfs_ag.[ch].
> > 
> > To do this without breaking userspace, first we need to rearrange
> > the structures and code so that all the kernel specific code is
> > located together. This makes it simple for userspace to ifdef out
> > the all the parts it does not need, minimising the code differences
> > between kernel and userspace. The next commit will do the move...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.c | 50 ++++++++++++++++++++++++++--------------------
> >  fs/xfs/xfs_mount.h | 19 +++++++++---------
> >  2 files changed, 38 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 21c630dde476..2e6d42014346 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> ...
> > @@ -229,13 +220,27 @@ xfs_initialize_perag(
> >  		}
> >  		spin_unlock(&mp->m_perag_lock);
> >  		radix_tree_preload_end();
> > -		/* first new pag is fully initialized */
> > -		if (first_initialised == NULLAGNUMBER)
> > -			first_initialised = index;
> > +
> > +		spin_lock_init(&pag->pag_ici_lock);
> > +		spin_lock_init(&pag->pagb_lock);
> > +		spin_lock_init(&pag->pag_state_lock);
> > +		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
> > +		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
> > +		init_waitqueue_head(&pag->pagb_wait);
> > +		pag->pagb_count = 0;
> > +		pag->pagb_tree = RB_ROOT;
> > +
> > +		error = xfs_buf_hash_init(pag);
> > +		if (error)
> > +			goto out_free_pag;
> > +
> 
> There's error handling code earlier up in this function that still lands
> in out_hash_destroy, which is now before we get to the _hash_init()
> call.
> 
> >  		error = xfs_iunlink_init(pag);
> >  		if (error)
> >  			goto out_hash_destroy;
> > -		spin_lock_init(&pag->pag_state_lock);
> > +
> > +		/* first new pag is fully initialized */
> > +		if (first_initialised == NULLAGNUMBER)
> > +			first_initialised = index;
> >  	}
> >  
> >  	index = xfs_set_inode_alloc(mp, agcount);
> > @@ -249,6 +254,7 @@ xfs_initialize_perag(
> >  out_hash_destroy:
> >  	xfs_buf_hash_destroy(pag);
> >  out_free_pag:
> > +	pag = radix_tree_delete(&mp->m_perag_tree, index);
> 
> Now if we get here with an allocated pag that hasn't been inserted to
> the tree, I suspect this call would assign pag = NULL..

Yup, error handling was fubar. Fixed now.

-- 
Dave Chinner
david@fromorbit.com
