Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4ACEMi8260162 for <xfs@oss.sgi.com>; Mon, 10 May 2010 07:14:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F34B1DE9E0C
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 05:16:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	0H0c6QlW5nM5uLA6 for <xfs@oss.sgi.com>;
	Mon, 10 May 2010 05:16:32 -0700 (PDT)
Date: Mon, 10 May 2010 22:16:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/12] xfs: Introduce delayed logging core code
Message-ID: <20100510121628.GD7165@dastard>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
	<1273210860-23414-10-git-send-email-david@fromorbit.com>
	<20100510114435.GA27624@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100510114435.GA27624@infradead.org>
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

On Mon, May 10, 2010 at 07:44:35AM -0400, Christoph Hellwig wrote:
> Looks good to me,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> A couple comments below anyway:
> 
> > +int
> > +xlog_cil_init_post_recovery(
> > +	struct log	*log)
> > +{
> > +	if (!log->l_cilp)
> > +		return 0;
> > +
> > +	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
> > +	log->l_cilp->xc_ctx->sequence = 1;
> > +	log->l_cilp->xc_ctx->commit_lsn = xlog_assign_lsn(log->l_curr_cycle,
> > +								log->l_curr_block);
> > +	return 0;
> > +}
> 
> This should return void.

OK.

> > +static void
> > +xlog_cil_insert(
> > +	struct log		*log,
> > +	struct xlog_ticket	*ticket,
> > +	struct xfs_log_item	*item,
> > +	struct xfs_log_vec	*lv)
> > +{
> > +	struct xfs_cil		*cil = log->l_cilp;
> > +	struct xfs_log_vec *old = lv->lv_item->li_lv;
> > +	struct xfs_cil_ctx *ctx = cil->xc_ctx;
> > +	int		len;
> > +	int		diff_iovecs;
> > +	int		iclog_space;
> > +
> > +	if (old) {
> > +		/* existing lv on log item, space used is a delta */
> > +		ASSERT(!list_empty(&item->li_cil));
> > +		ASSERT(old->lv_buf && old->lv_buf_len && old->lv_niovecs);
> > +
> > +		len = lv->lv_buf_len - old->lv_buf_len;
> > +		diff_iovecs = lv->lv_niovecs - old->lv_niovecs;
> 
> Add asserts that len and diff_iovecs aren't negative here?

Actually, they can be negative here - a previously logged buffer
that is now stale will go from ((N dirty regions * 128 bytes) +
format header) to (zero dirty regions + format header), and
effectively free up space as what was previously logged is now
ignored due to the XFS_BLI_CANCEL flag in the format header.

> > +	for (lv = log_vector; lv; lv = lv->lv_next) {
> > +		void	*ptr;
> > +		int	index;
> > +		int	offset = 0;
> > +		int	len = 0;
> > +
> > +		for (index = 0; index < lv->lv_niovecs; index++)
> > +			len += lv->lv_iovecp[index].i_len;
> > +
> > +		lv->lv_buf_len = len;
> > +		lv->lv_buf = kmem_zalloc(lv->lv_buf_len, KM_SLEEP|KM_NOFS);
> > +		ptr = lv->lv_buf;
> > +
> > +		for (index = 0; index < lv->lv_niovecs; index++) {
> > +			struct xfs_log_iovec *vec = &lv->lv_iovecp[index];
> > +
> > +			memcpy(ptr, vec->i_addr, vec->i_len);
> > +			vec->i_addr = ptr;
> > +			xlog_write_adv_cnt(&ptr, &len, &offset, vec->i_len);
> > +		}
> > +		ASSERT(len == 0);
> > +
> > +		xlog_cil_insert(log, ticket, lv->lv_item, lv);
> 
> The use of xlog_write_adv_cnt doesn't seem quite optimal to me.  The
> offset variable is entirely unused, and len is only used for an asswer
> that could easily be reformulated as
> 
> 	ASSERT(ptr == lv->lv_buf + len);
> 
> if we replace the xlog_write_adv_cnt with a simple
> 
> 	ptr += vec->i_len;

Good idea - xlog_write_adv_cnt() was left over from the original
code that was copied from the log code.

> 
> > +/*
> > + * Push the Committed Item List to the log. If the push_now flag is not set,
> > + * then it is a background flush and so we can chose to ignore it.
> > + */
> > +int
> > +xlog_cil_push(
> > +	struct log	*log,
> > +	int		push_now)
> > +{
> > +	struct xfs_cil		*cil = log->l_cilp;
> 
> The variables don't line up here.  There's another instance of that
> in xlog_cil_insert, btw.

Ok, will fix.

> 
> > +	/* check if we've anything to push */
> > +	if (list_empty(&cil->xc_cil)) {
> > +		up_write(&cil->xc_ctx_lock);
> > +		xfs_log_ticket_put(new_ctx->ticket);
> > +		kmem_free(new_ctx);
> > +		return 0;
> > +	}
> 
> Please add a out_skip label for this cleanup code, as it would be
> duplicated by the background flushing check added in a later patch.

OK.

> > +		new_lv = kmem_zalloc(sizeof(*new_lv) +
> > +				lidp->lid_size * sizeof(struct xfs_log_iovec),
> > +				KM_SLEEP);
> > +
> > +		/* The allocated iovec region lies beyond the log vector. */
> > +		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
> > +		if (!ret_lv)
> > +			ret_lv = new_lv;
> > +		else
> > +			lv->lv_next = new_lv;
> > +		lv = new_lv;
> 
> I'd suggest already setting up lv->lv_niovecs and lv->lv_item here
> instead of in xfs_trans_fill_log_vecs.  That way xfs_trans_fill_log_vecs
> can be simplified to:
> 
> STATIC void
> xfs_trans_fill_log_vecs(
> 	struct xfs_trans	*tp,
> 	struct xfs_log_vec	*log_vector)
> {
> 	struct xfs_log_vec	*lv;
> 
> 	for (lv = log_vector; lv = lv->lv_next; lv)
> 		IOP_FORMAT(lidp->lid_item, lv->lv_iovecp);
> }
> 
> Or just inlined into the caller or even xfs_log_commit_cil given how simple
> it is now.  Moving it to xfs_log_commit_cil would also help avoiding the
> locking imbalance where xfs_log_commit_cil is called with xc_ctx_lock
> held but returns without it after the last patch in the series.  That
> again might allow merging the IOP_FORMAT loop into xlog_cil_format_items.
> 
> Btw, I wonder if xfs_log_commit_cil should simply move to xfs_trans.c?
> That would avoid having to export xfs_trans_unreserve_and_mod_sb,
> xfs_trans_free_items and xfs_trans_free from there, and only require
> exporting xlog_cil_format_items (if we didn't move that one as well,
> then xlog_cil_insert), while keeping things a lot more symmetric with
> the traditional commit path.

I did find it a bit hard trying to draw the line between the trans
subsystem and the logging subsystem because of the interactions and
the way they changed as I developed the code and fixed bugs. I'll
have a closer look at what you are suggesting (it seems reasonable
just from a quick scan) and see how much it cleans up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
