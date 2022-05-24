Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E069C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 04:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiEXEAZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 00:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiEXEAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 00:00:24 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4474B5C369
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 21:00:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 218EC53440C;
        Tue, 24 May 2022 14:00:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntLiR-00Fgmx-GS; Tue, 24 May 2022 14:00:15 +1000
Date:   Tue, 24 May 2022 14:00:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: don't assert fail on perag references on
 teardown
Message-ID: <20220524040015.GZ1098723@dread.disaster.area>
References: <20220524022158.1849458-1-david@fromorbit.com>
 <20220524022158.1849458-3-david@fromorbit.com>
 <YoxVdipmKR4PHUyH@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoxVdipmKR4PHUyH@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628c5856
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=49XdF8D72hN7BixIbX4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 08:48:06PM -0700, Darrick J. Wong wrote:
> On Tue, May 24, 2022 at 12:21:57PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Not fatal, the assert is there to catch developer attention. I'm
> > seeing this occasionally during recoveryloop testing after a
> > shutdown, and I don't want this to stop an overnight recoveryloop
> > run as it is currently doing.
> > 
> > Convert the ASSERT to a XFS_IS_CORRUPT() check so it will dump a
> > corruption report into the log and cause a test failure that way,
> > but it won't stop the machine dead.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 1e4ee042d52f..3e920cf1b454 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -173,7 +173,6 @@ __xfs_free_perag(
> >  	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
> >  
> >  	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
> > -	ASSERT(atomic_read(&pag->pag_ref) == 0);
> 
> Er, shouldn't this also be converted to XFS_IS_CORRUPT?  That's what the
> commit message said...

That's in the RCU callback context and we never get here when the
ASSERT fires. i.e. the assert in xfs_free_perag fires before we
queue the rcu callback to free this, so checking it here is kinda
redundant.

i.e. it's not where this issue is being caught - it's
being caught by the check below (in xfs_free_perag()) where the
conversion to XFS_IS_CORRUPT is done....

Cheers,

Dave.

> >  	kmem_free(pag);
> >  }
> >  
> > @@ -192,7 +191,7 @@ xfs_free_perag(
> >  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> >  		spin_unlock(&mp->m_perag_lock);
> >  		ASSERT(pag);
> > -		ASSERT(atomic_read(&pag->pag_ref) == 0);
> > +		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
> >  
> >  		cancel_delayed_work_sync(&pag->pag_blockgc_work);
> >  		xfs_iunlink_destroy(pag);
> > -- 
> > 2.35.1
> > 
> 

-- 
Dave Chinner
david@fromorbit.com
