Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAAEC04EBE
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 11:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C519E21527
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 11:26:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPLQhB3W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgJHL0d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 07:26:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbgJHL0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 07:26:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602156391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pOpx193RVkty7gttPC/b3t14HndLpceKiJZ4sryFBkQ=;
        b=HPLQhB3WEXlml72tAQmgTLauG0GoOetdco46mgEdeFAmGic1wZkA0vxSaH7/wem4IXVY2E
        /jfQAdXTOo8LpdHYUSL6wgGTAT5qW0UYWJu9sOz5RqxwMtt3LlsJMx/5fsqsFFZun3cLLv
        giFz80BI1vJh5qJs21+s0Y6URhpOoPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-sniSPYVGMcukpUqEM4pDrw-1; Thu, 08 Oct 2020 07:26:29 -0400
X-MC-Unique: sniSPYVGMcukpUqEM4pDrw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46D148030A2;
        Thu,  8 Oct 2020 11:26:28 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EAFE110013C1;
        Thu,  8 Oct 2020 11:26:27 +0000 (UTC)
Date:   Thu, 8 Oct 2020 07:26:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: transaction subsystem quiesce mechanism
Message-ID: <20201008112626.GA702156@bfoster>
References: <20201001150310.141467-1-bfoster@redhat.com>
 <20201001150310.141467-3-bfoster@redhat.com>
 <20201007221310.GF6540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007221310.GF6540@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 03:13:10PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 01, 2020 at 11:03:09AM -0400, Brian Foster wrote:
> > The updated quotaoff logging algorithm depends on a runtime quiesce
> > of the transaction subsystem to guarantee all transactions after a
> > certain point detect quota subsystem changes. Implement this
> > mechanism using an internal lock, similar to the external filesystem
> > freeze mechanism. This is also somewhat analogous to the old percpu
> > transaction counter mechanism, but we don't actually need a counter.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c  |  2 ++
> >  fs/xfs/xfs_mount.h |  3 +++
> >  fs/xfs/xfs_super.c |  8 ++++++++
> >  fs/xfs/xfs_trans.c |  4 ++--
> >  fs/xfs/xfs_trans.h | 20 ++++++++++++++++++++
> >  5 files changed, 35 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index b35611882ff9..214310c94de5 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -58,6 +58,7 @@ xfs_setfilesize_trans_alloc(
> >  	 * we released it.
> >  	 */
> >  	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
> > +	percpu_rwsem_release(&mp->m_trans_rwsem, true, _THIS_IP_);
> >  	/*
> >  	 * We hand off the transaction to the completion thread now, so
> >  	 * clear the flag here.
> > @@ -127,6 +128,7 @@ xfs_setfilesize_ioend(
> >  	 */
> >  	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> >  	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
> > +	percpu_rwsem_acquire(&ip->i_mount->m_trans_rwsem, true, _THIS_IP_);
> >  
> >  	/* we abort the update if there was an IO error */
> >  	if (error) {
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index dfa429b77ee2..f1083a9ce1f8 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -171,6 +171,9 @@ typedef struct xfs_mount {
> >  	 */
> >  	struct percpu_counter	m_delalloc_blks;
> >  
> > +	/* lock for transaction quiesce (used by quotaoff) */
> > +	struct percpu_rw_semaphore	m_trans_rwsem;
> > +
> >  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> >  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> >  	uint64_t		m_resblks;	/* total reserved blocks */
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index baf5de30eebb..ff3ad5392e21 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1029,8 +1029,15 @@ xfs_init_percpu_counters(
> >  	if (error)
> >  		goto free_fdblocks;
> >  
> > +	/* not a counter, but close enough... */
> > +	error = percpu_init_rwsem(&mp->m_trans_rwsem);
> > +	if (error)
> > +		goto free_delalloc;
> > +
> >  	return 0;
> >  
> > +free_delalloc:
> > +	percpu_counter_destroy(&mp->m_delalloc_blks);
> >  free_fdblocks:
> >  	percpu_counter_destroy(&mp->m_fdblocks);
> >  free_ifree:
> > @@ -1053,6 +1060,7 @@ static void
> >  xfs_destroy_percpu_counters(
> >  	struct xfs_mount	*mp)
> >  {
> > +	percpu_free_rwsem(&mp->m_trans_rwsem);
> >  	percpu_counter_destroy(&mp->m_icount);
> >  	percpu_counter_destroy(&mp->m_ifree);
> >  	percpu_counter_destroy(&mp->m_fdblocks);
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index ca18a040336a..c07fa036549a 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -69,7 +69,7 @@ xfs_trans_free(
> >  
> >  	trace_xfs_trans_free(tp, _RET_IP_);
> >  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
> > -		sb_end_intwrite(tp->t_mountp->m_super);
> > +		xfs_trans_end(tp->t_mountp);
> >  	xfs_trans_free_dqinfo(tp);
> >  	kmem_cache_free(xfs_trans_zone, tp);
> >  }
> > @@ -265,7 +265,7 @@ xfs_trans_alloc(
> >  	 */
> >  	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
> >  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> > -		sb_start_intwrite(mp->m_super);
> > +		xfs_trans_start(mp);
> >  
> >  	/*
> >  	 * Zero-reservation ("empty") transactions can't modify anything, so
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index f46534b75236..af54c17a22c0 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -209,6 +209,26 @@ xfs_trans_read_buf(
> >  				      flags, bpp, ops);
> >  }
> >  
> > +/*
> > + * Context tracking helpers for external (i.e. fs freeze) and internal
> > + * transaction quiesce.
> > + */
> > +static inline void
> > +xfs_trans_start(
> > +	struct xfs_mount	*mp)
> > +{
> > +	sb_start_intwrite(mp->m_super);
> > +	percpu_down_read(&mp->m_trans_rwsem);
> 
> /me wonders, have you noticed any extra cpu overhead with this?
> 

Not that I've noticed, but I haven't explicitly profiled it or anything.
My understanding is the percpu variant of the rwsem should make read
acquisition extremely cheap at the cost of more expensive write
acquisition (which pretty much fits use cases like freeze, quotaoff,
etc.). I can try a file create/remove workload or something on a high
cpu count box and see if there's a noticeable effect..

> So far it looks ok to me, though I wonder if we could skip all this if
> CONFIG_XFS_QUOTA=n...
> 

We could, though I'd probably prefer to use something like
XFS_IS_QUOTA_RUNNING() as a conditional rather than an ifdef. Of course,
that means we'd have to be careful that turning quotaoff doesn't
actually break the transaction tracking. Regardless, I'm not really sure
it's worth sprinkling that logic around to avoid a per-transaction
percpu read lock.

Brian

> --D
> 
> > +}
> > +
> > +static inline void
> > +xfs_trans_end(
> > +	struct xfs_mount	*mp)
> > +{
> > +	percpu_up_read(&mp->m_trans_rwsem);
> > +	sb_end_intwrite(mp->m_super);
> > +}
> > +
> >  struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
> >  
> >  void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
> > -- 
> > 2.25.4
> > 
> 

