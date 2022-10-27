Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02818FA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbiJ0Vdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiJ0Vdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:33:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3836C945
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2ED90CE289B
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 21:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75595C433D6;
        Thu, 27 Oct 2022 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666906425;
        bh=b5uhZ35JCVFzSBX1AmSbU9Wcrj7Dq4Yl8t4Jm3EJj4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e9pfNwRTK8Yu2WgtNIq9hoy5FBy2ZMYduPogcNP2QWbiGyAIJVJg8VmDGqcCFAI3/
         +VVCGGdwZtNofRjqfgJIz/mfSRxFpUF2I9auzr0fdj25V1qUzk6dY7JfEXqETykM0W
         zHy1J0VUQD9V0ziXlf7cT+fb5ovOFWauJI9u20/BY+ZMHQnaSJyMDLKOioige7mYpO
         7cC+4JLXP6gNBXndZmWeUpz+2nAuWqK3aw1PzCcZy9esQG2hxGLFLmSGI1pDvbpZWM
         v6xWW0MBPFmLmYcOBNa1rJKNzj33sTMIoFRP//jrRL2AV0h37q18gYJ+ear4thgs1G
         N3edBmfqXvrrQ==
Date:   Thu, 27 Oct 2022 14:33:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: check record domain when accessing refcount
 records
Message-ID: <Y1r5OdnXJQ461gAY@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689089384.3788582.15595498616742667720.stgit@magnolia>
 <20221027211531.GW3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027211531.GW3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 08:15:31AM +1100, Dave Chinner wrote:
> On Thu, Oct 27, 2022 at 10:14:53AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we've separated the startblock and CoW/shared extent domain in
> > the incore refcount record structure, check the domain whenever we
> > retrieve a record to ensure that it's still in the domain that we want.
> > Depending on the circumstances, a change in domain either means we're
> > done processing or that we've found a corruption and need to fail out.
> > 
> > The refcount check in xchk_xref_is_cow_staging is redundant since
> > _get_rec has done that for a long time now, so we can get rid of it.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_refcount.c |   53 ++++++++++++++++++++++++++++++++----------
> >  fs/xfs/scrub/refcount.c      |    4 ++-
> >  2 files changed, 43 insertions(+), 14 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index 3b1cb0578770..608a122eef16 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -386,6 +386,8 @@ xfs_refcount_split_extent(
> >  		goto out_error;
> >  	}
> >  
> > +	if (rcext.rc_domain != domain)
> > +		return 0;
> >  	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
> >  		return 0;
> >  
> > @@ -434,6 +436,9 @@ xfs_refcount_merge_center_extents(
> >  	int				error;
> >  	int				found_rec;
> >  
> > +	ASSERT(left->rc_domain == center->rc_domain);
> > +	ASSERT(right->rc_domain == center->rc_domain);
> > +
> >  	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
> >  			cur->bc_ag.pag->pag_agno, left, center, right);
> 
> Can you move the asserts to after the trace points? That way we if
> need to debug the assert, we'll have a tracepoint with the record
> information that triggered the assert emitted immediately before it
> fires...

Done.

> >  
> > @@ -510,6 +515,8 @@ xfs_refcount_merge_left_extent(
> >  	int				error;
> >  	int				found_rec;
> >  
> > +	ASSERT(left->rc_domain == cleft->rc_domain);
> > +
> >  	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
> >  			cur->bc_ag.pag->pag_agno, left, cleft);
> >  
> > @@ -571,6 +578,8 @@ xfs_refcount_merge_right_extent(
> >  	int				error;
> >  	int				found_rec;
> >  
> > +	ASSERT(right->rc_domain == cright->rc_domain);
> > +
> >  	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
> >  			cur->bc_ag.pag->pag_agno, cright, right);
> >  
> > @@ -654,12 +663,10 @@ xfs_refcount_find_left_extents(
> >  		goto out_error;
> >  	}
> >  
> > +	if (tmp.rc_domain != domain)
> > +		return 0;
> >  	if (xfs_refc_next(&tmp) != agbno)
> >  		return 0;
> > -	if (domain == XFS_REFC_DOMAIN_SHARED && tmp.rc_refcount < 2)
> > -		return 0;
> > -	if (domain == XFS_REFC_DOMAIN_COW && tmp.rc_refcount > 1)
> > -		return 0;
> 
> Ah, as these go away, you can ignore my comment about them in the
> previous patches... :)
> 
> Otherwise, looks ok.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cool, thanks!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
