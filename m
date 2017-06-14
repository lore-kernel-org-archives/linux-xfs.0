Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbdFNKPU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jun 2017 06:15:20 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82967883B1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2017 10:15:19 +0000 (UTC)
Date: Wed, 14 Jun 2017 12:15:16 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2 V3] xfs: Add infrastructure needed for error
 propagation during buffer IO failure
Message-ID: <20170614101516.dre7e4pkltpsqdx6@eorzea.usersys.redhat.com>
References: <20170608140014.25132-1-cmaiolino@redhat.com>
 <20170608140014.25132-2-cmaiolino@redhat.com>
 <20170608164315.GH5244@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608164315.GH5244@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> > +STATIC void
> > +xfs_buf_do_callbacks_fail(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_log_item	*lip, *next;
> > +	unsigned int		bflags = bp->b_flags;
> > +
> > +	for (lip = bp->b_fspriv; lip; lip = next) {
> > +		next = lip->li_bio_list;
> > +		if (lip->li_ops->iop_error)
> > +			lip->li_ops->iop_error(lip, bp, bflags);
> 
> There's still no need to pass bflags here, particularly since we pass
> along the buffer already. (I'm still questioning the need for
> ->iop_error(), but I'll leave that as a final review question once
> everything else is in order. :P)
> 

Agreed regarding bflags, removed for V4.

Regarding iop_error(), well, I'm not discussing it anymore :)

> > +	}
> > +}
> > +
> >  static bool
> >  xfs_buf_iodone_callback_error(
> >  	struct xfs_buf		*bp)
> > @@ -1120,8 +1135,14 @@ xfs_buf_iodone_callback_error(
> >  	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
> >  		goto permanent_error;
> >  
> > -	/* still a transient error, higher layers will retry */
> > +	/*
> > +	 * still a transient error, run IO completion failure callbacks and
> > +	 * let the higher layers retry the buffer.
> > +	 * */
> >  	xfs_buf_ioerror(bp, 0);
> > +
> > +	/* run failure callbacks before releasing buffer */
> > +	xfs_buf_do_callbacks_fail(bp);
> 
> I think in principle it might be more appropriate to invoke the
> callbacks before we reset the I/O error. That way the failure callbacks
> see the buffer in the error state, then we reset the error and release
> it back to the AIL (so to speak).
> 

Agreed, on V4.


> Otherwise the rest looks sane to me.
> 

Thanks for the review
> Brian
> 
> >  	xfs_buf_relse(bp);
> >  	return true;
> >  
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index a07acbf..3486517 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -64,11 +64,13 @@ typedef struct xfs_log_item {
> >  } xfs_log_item_t;
> >  
> >  #define	XFS_LI_IN_AIL	0x1
> > -#define XFS_LI_ABORTED	0x2
> > +#define	XFS_LI_ABORTED	0x2
> > +#define	XFS_LI_FAILED	0x4
> >  
> >  #define XFS_LI_FLAGS \
> >  	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
> > -	{ XFS_LI_ABORTED,	"ABORTED" }
> > +	{ XFS_LI_ABORTED,	"ABORTED" }, \
> > +	{ XFS_LI_FAILED,	"FAILED" }
> >  
> >  struct xfs_item_ops {
> >  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> > @@ -79,6 +81,7 @@ struct xfs_item_ops {
> >  	void (*iop_unlock)(xfs_log_item_t *);
> >  	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
> >  	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
> > +	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *, unsigned int bflags);
> >  };
> >  
> >  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> > -- 
> > 2.9.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
