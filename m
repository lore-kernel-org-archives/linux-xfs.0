Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51550C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241E360F9C
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhHBVdb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232492AbhHBVda (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Aug 2021 17:33:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E175360F39;
        Mon,  2 Aug 2021 21:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627940001;
        bh=N63Rzn5wPqqGOSnhbEnauXxRPLu0v7B1kddf2Zh7TFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i9nC5dSFJ/mbhLLq/VqhOjipptBcY0qmfUaRPSQ+kbApI4FAWwZM9xCYzrfhXhK3P
         w1IL8HtDQNrzzRLuQMQjoQnnshwtKqRPu7GalFh8DVIjFc+wg/8QIVgenBP3k6ao/X
         Nnkf1R8XARGP9yBvvF3tWbJgXHvitt77OYtLdEzAoKcLHTvKgs7nP+oVeoznQ3oCrf
         dW4uMS3eJG6s+FYPYYhJy20oYE9KupevrqK9Ps8OSBAXMnn8tGouV3tC94U4najZuK
         L0VwTIB0543kqAN1YHgKx/wjBv5ckQxyi1tB2ABuOFGIEamgGDzTtjtz9stow0S12C
         mB5nWf1mfi4ww==
Date:   Mon, 2 Aug 2021 14:33:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 14/20] xfs: parallelize inode inactivation
Message-ID: <20210802213320.GO3601443@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758431072.332903.17159226037941080971.stgit@magnolia>
 <20210802005532.GF2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802005532.GF2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 02, 2021 at 10:55:32AM +1000, Dave Chinner wrote:
> On Thu, Jul 29, 2021 at 11:45:10AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Split the inode inactivation work into per-AG work items so that we can
> > take advantage of parallelization.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c |   12 ++++++-
> >  fs/xfs/libxfs/xfs_ag.h |   10 +++++
> >  fs/xfs/xfs_icache.c    |   88 ++++++++++++++++++++++++++++--------------------
> >  fs/xfs/xfs_icache.h    |    2 +
> >  fs/xfs/xfs_mount.c     |    9 +----
> >  fs/xfs/xfs_mount.h     |    8 ----
> >  fs/xfs/xfs_super.c     |    2 -
> >  fs/xfs/xfs_trace.h     |   82 ++++++++++++++++++++++++++++++++-------------
> >  8 files changed, 134 insertions(+), 79 deletions(-)
> 
> ....
> 
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -420,9 +420,11 @@ xfs_blockgc_queue(
> >   */
> >  static void
> >  xfs_inodegc_queue(
> > -	struct xfs_mount        *mp,
> > +	struct xfs_perag	*pag,
> >  	struct xfs_inode	*ip)
> >  {
> > +	struct xfs_mount        *mp = pag->pag_mount;
> > +
> >  	if (!test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
> >  		return;
> >  
> > @@ -431,8 +433,8 @@ xfs_inodegc_queue(
> >  		unsigned int	delay;
> >  
> >  		delay = xfs_gc_delay_ms(mp, ip, XFS_ICI_INODEGC_TAG);
> > -		trace_xfs_inodegc_queue(mp, delay);
> > -		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
> > +		trace_xfs_inodegc_queue(pag, delay);
> > +		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
> >  				msecs_to_jiffies(delay));
> >  	}
> >  	rcu_read_unlock();
> 
> I think you missed this change in xfs_inodegc_queue():
> 
> @@ -492,7 +492,7 @@ xfs_inodegc_queue(
>  		return;
>  
>  	rcu_read_lock();
> -	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
> +	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG)) {

Yep, I've rebased this series so many times that merge conflict
resolution mutations have crept in.  Fixed; thank you. :(

(And FWIW for v9 I moved this patch to be immediately after the patch
that changes xfs to use the radix tree tags; this reduces the churn in
struct xfs_mount somewhat.)

--D

>  		unsigned int    delay;
>  
>  		delay = xfs_gc_delay_ms(pag, ip, XFS_ICI_INODEGC_TAG);
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
