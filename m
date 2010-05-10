Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4ABgOiL258900 for <xfs@oss.sgi.com>; Mon, 10 May 2010 06:42:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32512983416
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 04:44:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id f2KOfdkhLXGFHtw1 for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 04:44:56 -0700 (PDT)
Date: Mon, 10 May 2010 07:44:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/12] xfs: Introduce delayed logging core code
Message-ID: <20100510114435.GA27624@infradead.org>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
	<1273210860-23414-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273210860-23414-10-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

A couple comments below anyway:

> +int
> +xlog_cil_init_post_recovery(
> +	struct log	*log)
> +{
> +	if (!log->l_cilp)
> +		return 0;
> +
> +	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
> +	log->l_cilp->xc_ctx->sequence = 1;
> +	log->l_cilp->xc_ctx->commit_lsn = xlog_assign_lsn(log->l_curr_cycle,
> +								log->l_curr_block);
> +	return 0;
> +}

This should return void.

> +static void
> +xlog_cil_insert(
> +	struct log		*log,
> +	struct xlog_ticket	*ticket,
> +	struct xfs_log_item	*item,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_cil		*cil = log->l_cilp;
> +	struct xfs_log_vec *old = lv->lv_item->li_lv;
> +	struct xfs_cil_ctx *ctx = cil->xc_ctx;
> +	int		len;
> +	int		diff_iovecs;
> +	int		iclog_space;
> +
> +	if (old) {
> +		/* existing lv on log item, space used is a delta */
> +		ASSERT(!list_empty(&item->li_cil));
> +		ASSERT(old->lv_buf && old->lv_buf_len && old->lv_niovecs);
> +
> +		len = lv->lv_buf_len - old->lv_buf_len;
> +		diff_iovecs = lv->lv_niovecs - old->lv_niovecs;

Add asserts that len and diff_iovecs aren't negative here?

> +	for (lv = log_vector; lv; lv = lv->lv_next) {
> +		void	*ptr;
> +		int	index;
> +		int	offset = 0;
> +		int	len = 0;
> +
> +		for (index = 0; index < lv->lv_niovecs; index++)
> +			len += lv->lv_iovecp[index].i_len;
> +
> +		lv->lv_buf_len = len;
> +		lv->lv_buf = kmem_zalloc(lv->lv_buf_len, KM_SLEEP|KM_NOFS);
> +		ptr = lv->lv_buf;
> +
> +		for (index = 0; index < lv->lv_niovecs; index++) {
> +			struct xfs_log_iovec *vec = &lv->lv_iovecp[index];
> +
> +			memcpy(ptr, vec->i_addr, vec->i_len);
> +			vec->i_addr = ptr;
> +			xlog_write_adv_cnt(&ptr, &len, &offset, vec->i_len);
> +		}
> +		ASSERT(len == 0);
> +
> +		xlog_cil_insert(log, ticket, lv->lv_item, lv);

The use of xlog_write_adv_cnt doesn't seem quite optimal to me.  The
offset variable is entirely unused, and len is only used for an asswer
that could easily be reformulated as

	ASSERT(ptr == lv->lv_buf + len);

if we replace the xlog_write_adv_cnt with a simple

	ptr += vec->i_len;

> +/*
> + * Push the Committed Item List to the log. If the push_now flag is not set,
> + * then it is a background flush and so we can chose to ignore it.
> + */
> +int
> +xlog_cil_push(
> +	struct log	*log,
> +	int		push_now)
> +{
> +	struct xfs_cil		*cil = log->l_cilp;

The variables don't line up here.  There's another instance of that
in xlog_cil_insert, btw.

> +	/* check if we've anything to push */
> +	if (list_empty(&cil->xc_cil)) {
> +		up_write(&cil->xc_ctx_lock);
> +		xfs_log_ticket_put(new_ctx->ticket);
> +		kmem_free(new_ctx);
> +		return 0;
> +	}

Please add a out_skip label for this cleanup code, as it would be
duplicated by the background flushing check added in a later patch.

> +		new_lv = kmem_zalloc(sizeof(*new_lv) +
> +				lidp->lid_size * sizeof(struct xfs_log_iovec),
> +				KM_SLEEP);
> +
> +		/* The allocated iovec region lies beyond the log vector. */
> +		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
> +		if (!ret_lv)
> +			ret_lv = new_lv;
> +		else
> +			lv->lv_next = new_lv;
> +		lv = new_lv;

I'd suggest already setting up lv->lv_niovecs and lv->lv_item here
instead of in xfs_trans_fill_log_vecs.  That way xfs_trans_fill_log_vecs
can be simplified to:

STATIC void
xfs_trans_fill_log_vecs(
	struct xfs_trans	*tp,
	struct xfs_log_vec	*log_vector)
{
	struct xfs_log_vec	*lv;

	for (lv = log_vector; lv = lv->lv_next; lv)
		IOP_FORMAT(lidp->lid_item, lv->lv_iovecp);
}

Or just inlined into the caller or even xfs_log_commit_cil given how simple
it is now.  Moving it to xfs_log_commit_cil would also help avoiding the
locking imbalance where xfs_log_commit_cil is called with xc_ctx_lock
held but returns without it after the last patch in the series.  That
again might allow merging the IOP_FORMAT loop into xlog_cil_format_items.

Btw, I wonder if xfs_log_commit_cil should simply move to xfs_trans.c?
That would avoid having to export xfs_trans_unreserve_and_mod_sb,
xfs_trans_free_items and xfs_trans_free from there, and only require
exporting xlog_cil_format_items (if we didn't move that one as well,
then xlog_cil_insert), while keeping things a lot more symmetric with
the traditional commit path.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
