Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4H5mml0228759 for <xfs@oss.sgi.com>; Mon, 17 May 2010 00:48:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E8EF13EBF6D
	for <xfs@oss.sgi.com>; Sun, 16 May 2010 22:51:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	iIh4qCWxlUJgRFe9 for <xfs@oss.sgi.com>;
	Sun, 16 May 2010 22:51:03 -0700 (PDT)
Date: Mon, 17 May 2010 15:51:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/12] xfs: Introduce delayed logging core code
Message-ID: <20100517055101.GK8120@dastard>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
	<1273210860-23414-10-git-send-email-david@fromorbit.com>
	<20100510114435.GA27624@infradead.org>
	<20100510121628.GD7165@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100510121628.GD7165@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, May 10, 2010 at 10:16:28PM +1000, Dave Chinner wrote:
> On Mon, May 10, 2010 at 07:44:35AM -0400, Christoph Hellwig wrote:
> > > +		new_lv = kmem_zalloc(sizeof(*new_lv) +
> > > +				lidp->lid_size * sizeof(struct xfs_log_iovec),
> > > +				KM_SLEEP);
> > > +
> > > +		/* The allocated iovec region lies beyond the log vector. */
> > > +		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
> > > +		if (!ret_lv)
> > > +			ret_lv = new_lv;
> > > +		else
> > > +			lv->lv_next = new_lv;
> > > +		lv = new_lv;
> > 
> > I'd suggest already setting up lv->lv_niovecs and lv->lv_item here
> > instead of in xfs_trans_fill_log_vecs.  That way xfs_trans_fill_log_vecs
> > can be simplified to:
> > 
> > STATIC void
> > xfs_trans_fill_log_vecs(
> > 	struct xfs_trans	*tp,
> > 	struct xfs_log_vec	*log_vector)
> > {
> > 	struct xfs_log_vec	*lv;
> > 
> > 	for (lv = log_vector; lv = lv->lv_next; lv)
> > 		IOP_FORMAT(lidp->lid_item, lv->lv_iovecp);
> > }
> > 
> > Or just inlined into the caller or even xfs_log_commit_cil given how simple
> > it is now.  Moving it to xfs_log_commit_cil would also help avoiding the
> > locking imbalance where xfs_log_commit_cil is called with xc_ctx_lock
> > held but returns without it after the last patch in the series.  That
> > again might allow merging the IOP_FORMAT loop into xlog_cil_format_items.

OK, having looked into this in more detail, I agree that this makes
the code much simpler and formatting in xlog_cil_format_items()
makes sense for cleaning up the unbalanced locking.
xfs_trans_fill_log_vecs() basically goes away completely.

> > Btw, I wonder if xfs_log_commit_cil should simply move to xfs_trans.c?
> > That would avoid having to export xfs_trans_unreserve_and_mod_sb,
> > xfs_trans_free_items and xfs_trans_free from there, and only require
> > exporting xlog_cil_format_items (if we didn't move that one as well,
> > then xlog_cil_insert), while keeping things a lot more symmetric with
> > the traditional commit path.
> 
> I did find it a bit hard trying to draw the line between the trans
> subsystem and the logging subsystem because of the interactions and
> the way they changed as I developed the code and fixed bugs. I'll
> have a closer look at what you are suggesting (it seems reasonable
> just from a quick scan) and see how much it cleans up.

Unfortunately, it's still not a totally clean separation - either
way something has to be exported. I'd prefer not to export the CIL
context or the context lock outside xfs_log_cil.c, so that kind of
rules out moving xfs_log_commit_cil(). I moved a couple of things
from there back to xfs_trans_commit_cil(), but we still need
xfs_trans_item_committed() and xfs_trans_unreserve_and_mod_sb()
exported. That seems to be the cleanest I can come up with right
now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
