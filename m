Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4E3C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 00:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDA7F61974
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 00:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhCWABX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 20:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230009AbhCWABN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 20:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D24619AD;
        Tue, 23 Mar 2021 00:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616457673;
        bh=R4lZldWKIWbnacXFLVAcYdqKuRrr8KbW6F4iFkmBrwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I1L7Y3LkxulZV6NLg8Nw/tpAexIEA5w+W2w2KLr3qMmICduIiwItoUiToAZHS2VlL
         RHZgLHzhBQIAbe9OkPVd+1YnXipn86+xZ42FbPcK0+gaeJ5fMpWfiLrUoBS6OIHZp9
         hnteMd/0c89T2YYh+6/71hL/M5Eo0lWFeVZ7iAYTuE545GfhdXkvFNvOmnI/PDrjS4
         8p9NMqilbLdkMKfDwHlDwaDpCBZX/bbsfMidPLpRaljp+Lr5i0x+qv8q1BqFmA6u1L
         VuylZvhuJI+UnQi4jzMYSdjWj4TwwcjWD8S03ytVMDVtQzSMT3hmVPNrSDhr62hYX0
         VlmPiKJalWO8Q==
Date:   Mon, 22 Mar 2021 17:01:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: don't reclaim dquots with incore reservations
Message-ID: <20210323000111.GG22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543195719.1947934.8218545606940173264.stgit@magnolia>
 <20210322233139.GZ63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322233139.GZ63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 10:31:39AM +1100, Dave Chinner wrote:
> On Wed, Mar 10, 2021 at 07:05:57PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a dquot has an incore reservation that exceeds the ondisk count, it
> > by definition has active incore state and must not be reclaimed.  Up to
> > this point every inode with an incore dquot reservation has always
> > retained a reference to the dquot so it was never possible for
> > xfs_qm_dquot_isolate to be called on a dquot with active state and zero
> > refcount, but this will soon change.
> > 
> > Deferred inode inactivation is about to reorganize how inodes are
> > inactivated by shunting all that work to a background workqueue.  In
> > order to avoid deadlocks with the quotaoff inode scan and reduce overall
> > memory requirements (since inodes can spend a lot of time waiting for
> > inactivation), inactive inodes will drop their dquot references while
> > they're waiting to be inactivated.
> > 
> > However, inactive inodes can have delalloc extents in the data fork or
> > any extents in the CoW fork.  Either of these contribute to the dquot's
> > incore reservation being larger than the resource count (i.e. they're
> > the reason the dquot still has active incore state), so we cannot allow
> > the dquot to be reclaimed.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> .....
> >  static enum lru_status
> >  xfs_qm_dquot_isolate(
> >  	struct list_head	*item,
> > @@ -427,10 +441,15 @@ xfs_qm_dquot_isolate(
> >  		goto out_miss_busy;
> >  
> >  	/*
> > -	 * This dquot has acquired a reference in the meantime remove it from
> > -	 * the freelist and try again.
> > +	 * Either this dquot has incore reservations or it has acquired a
> > +	 * reference.  Remove it from the freelist and try again.
> > +	 *
> > +	 * Inodes tagged for inactivation drop their dquot references to avoid
> > +	 * deadlocks with quotaoff.  If these inodes have delalloc reservations
> > +	 * in the data fork or any extents in the CoW fork, these contribute
> > +	 * to the dquot's incore block reservation exceeding the count.
> >  	 */
> > -	if (dqp->q_nrefs) {
> > +	if (xfs_dquot_has_incore_resv(dqp) || dqp->q_nrefs) {
> >  		xfs_dqunlock(dqp);
> >  		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
> >  
> 
> This means we can have dquots with no references that aren't on
> the free list and aren't actually referenced by any inode, either.
> 
> So if we now shut down the filesystem, what frees these dquots?
> Are we relying on xfs_qm_dqpurge_all() to find all these dquots
> and xfs_qm_dqpurge() guaranteeing that they are always cleaned
> and freed?

Yes.  Want me to add that to the comment?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
