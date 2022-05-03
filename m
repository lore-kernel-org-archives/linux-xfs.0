Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7214BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 06:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiECG6s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 02:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiECG54 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 02:57:56 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E24D393DE
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 23:53:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 28B7853463D;
        Tue,  3 May 2022 16:53:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nlmPv-007QSb-Ok; Tue, 03 May 2022 16:53:51 +1000
Date:   Tue, 3 May 2022 16:53:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/16] xfs: remove xfs_attri_remove_iter
Message-ID: <20220503065351.GY1098723@dread.disaster.area>
References: <20220414094434.2508781-1-david@fromorbit.com>
 <20220414094434.2508781-15-david@fromorbit.com>
 <77c71042835cc77e5d9cdd506142e6b4ac7998ca.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77c71042835cc77e5d9cdd506142e6b4ac7998ca.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6270d181
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=nGJD6lV_w62dBs13BjAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:34:47PM -0700, Alli wrote:
> On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_attri_remove_iter is not used anymore, so remove it and all the
> > infrastructure it uses and is needed to drive it.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> > -	case XFS_DAS_RMTBLK:
> > -		attr->xattri_dela_state = XFS_DAS_RMTBLK;
> > -
> > -		/*
> > -		 * If there is an out-of-line value, de-allocate the
> > blocks.
> > -		 * This is done before we remove the attribute so that
> > we don't
> > -		 * overflow the maximum size of a transaction and/or
> > hit a
> > -		 * deadlock.
> > -		 */
> > -		if (args->rmtblkno > 0) {
> > -			/*
> > -			 * May return -EAGAIN. Roll and repeat until
> > all remote
> > -			 * blocks are removed.
> > -			 */
> > -			error = xfs_attr_rmtval_remove(attr);
> > -			if (error == -EAGAIN) {
> > -				trace_xfs_attr_remove_iter_return(
> > -					attr->xattri_dela_state, args-
> > >dp);
> > -				return error;
> > -			} else if (error) {
> > -				goto out;
> > -			}
> > -
> > -			/*
> > -			 * Refill the state structure with buffers (the
> > prior
> > -			 * calls released our buffers) and close out
> > this
> > -			 * transaction before proceeding.
> > -			 */
> > -			ASSERT(args->rmtblkno == 0);
> > -			error = xfs_attr_refillstate(state);
> 
> I think you can remove xfs_attr_refillstate too.  I'm getting some
> compiler gripes about that being declared but not used, and I'm pretty
> sure this was the last call to it, so probably it can go too.

I'm going to ifdef it out for now, which will remove the compiler
warning. I'll leave a comment explaining why it's been left there
unused for the moment. That is a bit of a long story.....

.... so it's Story Time! :)

The xfs_attr_savestate(), xfs_attr_refillstate() pair are for saving
the state path cursor that points to the name entry in the btree so
we don't have to look it up again after we've removed the remote
value blocks.

Removing the remote value extents trashes the state cursor (points to
remote value extents that have been removed on return, not the name
entry in the btree), so to avoid doing another tree walk we save the
disk addresses of the path blocks before remote extent removal and
restore them to the state cursor afterwards.

This avoids having to walk the hash tree to find the data block that
contains the name entry again to remove that. It's an optimisation
that I removed when combining the two state machines because it hurt
my brain trying to reconcile the two paths. Hence I ended up using
the simpler _set_iter() path that just does the lookup a second time
when I combined the state machines rather than the more complex
save/restore path in the remove_iter state machine.

I left the code there because I want to re-introduce the
optimisation in future - it will benefit both the replace and remove
paths - but I want to get the code working correctly first before I
worry too much about intricate performance optimisations like this.

> Other
> than that this patch looks ok.
> 
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
