Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC26C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 00:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D40560F51
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 00:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbhIRADn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237453AbhIRADn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 20:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C350B610FD;
        Sat, 18 Sep 2021 00:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631923340;
        bh=RMFPekOmCM1d2h5lvt2Ae5HxwfNf/8drwNyhly3KYqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fmMUUesM5k/dV39LWfx3SUHxiU8ova2QoEOO3zZe89Xnl49X5qtXut3mBgPk/1xoe
         oRzGep7Y+RR9JQXW6ZzOcBoJ4FRq2vUlMfnIcPtkwhd4KhlaJpPBduix65kb24gqwF
         MAcqNmW9NTfcR5fgDLN8+Z/FBilD0qTsPjifXImtYbLeWVm00ksAGTjzTSs121lz0a
         flo8l87MvoElQXzr/qvvEi7GErgowJtk+2CaY3umA0O/6E1P1NzE2Ng6+AmYZMmj7S
         p1o/Nv6E5BozLU3N2VKgQZb/hK8eVJWxwJEuMSMgw5fwF5XhB7+RRT5S4rinsm2apW
         KcRcSp6+RdTnQ==
Date:   Fri, 17 Sep 2021 17:02:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 02/11] xfs: Capture buffers for delayed ops
Message-ID: <20210918000220.GC10250@magnolia>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-3-allison.henderson@oracle.com>
 <20210830174407.GA9942@magnolia>
 <dce359c9-18d2-ad38-b951-d1cb98d7cc7d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dce359c9-18d2-ad38-b951-d1cb98d7cc7d@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 10:50:52AM -0700, Allison Henderson wrote:
> 
> 
> On 8/30/21 10:44 AM, Darrick J. Wong wrote:
> > On Tue, Aug 24, 2021 at 03:44:25PM -0700, Allison Henderson wrote:
> > > This patch enables delayed operations to capture held buffers with in
> > > the xfs_defer_capture. Buffers are then rejoined to the new
> > > transaction in xlog_finish_defer_ops
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_defer.c  | 7 ++++++-
> > >   fs/xfs/libxfs/xfs_defer.h  | 4 +++-
> > >   fs/xfs/xfs_bmap_item.c     | 2 +-
> > >   fs/xfs/xfs_buf.c           | 1 +
> > >   fs/xfs/xfs_buf.h           | 1 +
> > >   fs/xfs/xfs_extfree_item.c  | 2 +-
> > >   fs/xfs/xfs_log_recover.c   | 7 +++++++
> > >   fs/xfs/xfs_refcount_item.c | 2 +-
> > >   fs/xfs/xfs_rmap_item.c     | 2 +-
> > >   9 files changed, 22 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > > index eff4a127188e..d1d09b6aca55 100644
> > > --- a/fs/xfs/libxfs/xfs_defer.c
> > > +++ b/fs/xfs/libxfs/xfs_defer.c
> > > @@ -639,6 +639,7 @@ xfs_defer_ops_capture(
> > >   	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
> > >   	INIT_LIST_HEAD(&dfc->dfc_list);
> > >   	INIT_LIST_HEAD(&dfc->dfc_dfops);
> > > +	INIT_LIST_HEAD(&dfc->dfc_buffers);
> > >   	xfs_defer_create_intents(tp);
> > > @@ -690,7 +691,8 @@ int
> > >   xfs_defer_ops_capture_and_commit(
> > >   	struct xfs_trans		*tp,
> > >   	struct xfs_inode		*capture_ip,
> > > -	struct list_head		*capture_list)
> > > +	struct list_head		*capture_list,
> > > +	struct xfs_buf			*bp)
> > 
> > I wonder if xfs_defer_ops_capture should learn to pick up the inodes and
> > buffers to hold automatically from the transaction that's being
> > committed?  Seeing as xfs_defer_trans_roll already knows how to do that
> > across transaction rolls, and that's more or less the same thing we're
> > doing here, but in a much more roundabout way.
> I see, I suppose it could?  But it wouldnt be used in this case though, at
> least not yet.  I sort of got the impression that people like to see things
> added as they are needed, and then unused code culled where it can be.  I
> would think that if the need does arise though, b_delay would be easy to
> expand into list of xfs_delay_items or something similar to what
> xfs_defer_trans_roll has.

On further thought, I decided that log recovery of intent items really
ought to be able to hold the same number and type of resources across a
transaction "roll" that we can do at runtime, since there really ought
to be no difference.

I wrote a quick patch series to hoist the runtime code path to store the
held buffers and inodes during xfs_defer_trans_roll in an explicitly
named structure with separate save and restore helpers, then refactored
log recovery to use it.

This cleans up the API a bit so we that the defer capture system picks
up the held resources from the log item state just like a regular defer
roll.  It occurs to me that another way to handle intent item recovery
would be to create workqueue items for each recovered intent and then
kick the transactions off in background threads so that the end of all
the _recover functions would be xfs_trans_commit.  But that's a lot more
surgery on the recovery code and I don't want to go there right now.

Anyway, I'll send the RFC series shortly and cc you on it, in case you
want to incorporate it at the head of your series and nuke patch #2.

Note: the end of the xattri recovery function then becomes:

	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
	if (error)
		/* pretend I handled the error */

	if (attr->xattri_dac.leaf_bp)
		xfs_buf_relse(attr->xattri_dac.leaf_bp);
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	xfs_irele(ip);
	return 0;

I think it's a bug that patch 4 doesn't release leaf_bp, since we
require code that holds a buffer across a commit to relse it explicitly.

--D

> 
> > 
> > >   {
> > >   	struct xfs_mount		*mp = tp->t_mountp;
> > >   	struct xfs_defer_capture	*dfc;
> > > @@ -703,6 +705,9 @@ xfs_defer_ops_capture_and_commit(
> > >   	if (!dfc)
> > >   		return xfs_trans_commit(tp);
> > > +	if (bp && bp->b_transp == tp)
> > > +		list_add_tail(&bp->b_delay, &dfc->dfc_buffers);
> > > +
> > >   	/* Commit the transaction and add the capture structure to the list. */
> > >   	error = xfs_trans_commit(tp);
> > >   	if (error) {
> > > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > > index 05472f71fffe..739f70d72fd5 100644
> > > --- a/fs/xfs/libxfs/xfs_defer.h
> > > +++ b/fs/xfs/libxfs/xfs_defer.h
> > > @@ -74,6 +74,7 @@ struct xfs_defer_capture {
> > >   	/* Deferred ops state saved from the transaction. */
> > >   	struct list_head	dfc_dfops;
> > > +	struct list_head	dfc_buffers;
> > >   	unsigned int		dfc_tpflags;
> > >   	/* Block reservations for the data and rt devices. */
> > > @@ -95,7 +96,8 @@ struct xfs_defer_capture {
> > >    * This doesn't normally happen except log recovery.
> > >    */
> > >   int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
> > > -		struct xfs_inode *capture_ip, struct list_head *capture_list);
> > > +		struct xfs_inode *capture_ip, struct list_head *capture_list,
> > > +		struct xfs_buf *bp);
> > >   void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
> > >   		struct xfs_inode **captured_ipp);
> > >   void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
> > > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > > index 03159970133f..51ba8ee368ca 100644
> > > --- a/fs/xfs/xfs_bmap_item.c
> > > +++ b/fs/xfs/xfs_bmap_item.c
> > > @@ -532,7 +532,7 @@ xfs_bui_item_recover(
> > >   	 * Commit transaction, which frees the transaction and saves the inode
> > >   	 * for later replay activities.
> > >   	 */
> > > -	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
> > > +	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list, NULL);
> > >   	if (error)
> > >   		goto err_unlock;
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 047bd6e3f389..29b4655a0a65 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -233,6 +233,7 @@ _xfs_buf_alloc(
> > >   	init_completion(&bp->b_iowait);
> > >   	INIT_LIST_HEAD(&bp->b_lru);
> > >   	INIT_LIST_HEAD(&bp->b_list);
> > > +	INIT_LIST_HEAD(&bp->b_delay);
> > >   	INIT_LIST_HEAD(&bp->b_li_list);
> > >   	sema_init(&bp->b_sema, 0); /* held, no waiters */
> > >   	spin_lock_init(&bp->b_lock);
> > > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > > index 6b0200b8007d..c51445705dc6 100644
> > > --- a/fs/xfs/xfs_buf.h
> > > +++ b/fs/xfs/xfs_buf.h
> > > @@ -151,6 +151,7 @@ struct xfs_buf {
> > >   	int			b_io_error;	/* internal IO error state */
> > >   	wait_queue_head_t	b_waiters;	/* unpin waiters */
> > >   	struct list_head	b_list;
> > > +	struct list_head	b_delay;	/* delayed operations list */
> > >   	struct xfs_perag	*b_pag;		/* contains rbtree root */
> > >   	struct xfs_mount	*b_mount;
> > >   	struct xfs_buftarg	*b_target;	/* buffer target (device) */
> > 
> > The bare list-conveyance machinery looks fine to me, but adding 16 bytes
> > to struct xfs_buf for something that only happens during log recovery is
> > rather expensive.  Can you reuse b_list for this purpose?  I think the
> > only user of b_list are the buffer delwri functions, which shouldn't be
> > active here since the xattr recovery mechanism (a) holds the buffer lock
> > and (b) doesn't itself use delwri buffer lists for xattr leaf blocks.
> > 
> > (The AIL uses delwri lists, but it won't touch a locked buffer.)
> > 
> Sure, it sounds like it would work, will try it out.
> 
> > > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > > index 3f8a0713573a..046f21338c48 100644
> > > --- a/fs/xfs/xfs_extfree_item.c
> > > +++ b/fs/xfs/xfs_extfree_item.c
> > > @@ -637,7 +637,7 @@ xfs_efi_item_recover(
> > >   	}
> > > -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> > > +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
> > >   abort_error:
> > >   	xfs_trans_cancel(tp);
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index 10562ecbd9ea..6a3c0bb16b69 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -2465,6 +2465,7 @@ xlog_finish_defer_ops(
> > >   	struct list_head	*capture_list)
> > >   {
> > >   	struct xfs_defer_capture *dfc, *next;
> > > +	struct xfs_buf		*bp, *bnext;
> > >   	struct xfs_trans	*tp;
> > >   	struct xfs_inode	*ip;
> > >   	int			error = 0;
> > > @@ -2489,6 +2490,12 @@ xlog_finish_defer_ops(
> > >   			return error;
> > >   		}
> > > +		list_for_each_entry_safe(bp, bnext, &dfc->dfc_buffers, b_delay) {
> > > +			xfs_trans_bjoin(tp, bp);
> > > +			xfs_trans_bhold(tp, bp);
> > > +			list_del_init(&bp->b_delay);
> > > +		}
> > 
> > Why isn't this in xfs_defer_ops_continue, like the code that extracts
> > the inodes from the capture struct and hands them back to the caller?
> Its just what was discussed in the last review is all.  That does look like
> a better place for it though.  Will move there.
> 
> Allison
> 
> > 
> > > +
> > >   		/*
> > >   		 * Transfer to this new transaction all the dfops we captured
> > >   		 * from recovering a single intent item.
> > > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > > index 46904b793bd4..a6e7351ca4f9 100644
> > > --- a/fs/xfs/xfs_refcount_item.c
> > > +++ b/fs/xfs/xfs_refcount_item.c
> > > @@ -557,7 +557,7 @@ xfs_cui_item_recover(
> > >   	}
> > >   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > > -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> > > +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
> > >   abort_error:
> > >   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > > index 5f0695980467..8c70a4af80a9 100644
> > > --- a/fs/xfs/xfs_rmap_item.c
> > > +++ b/fs/xfs/xfs_rmap_item.c
> > > @@ -587,7 +587,7 @@ xfs_rui_item_recover(
> > >   	}
> > >   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> > > -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> > > +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
> > >   abort_error:
> > >   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> > > -- 
> > > 2.25.1
> > > 
