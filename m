Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0447C7CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:12:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75D1FAC004
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 16:12:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OfhDhUc9apfssLrL for <xfs@oss.sgi.com>;
	Tue, 30 Jul 2013 16:12:00 -0700 (PDT)
Date: Wed, 31 Jul 2013 09:11:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: introduce object readahead to log recovery
Message-ID: <20130730231155.GM13468@dastard>
References: <1375178347-29037-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1375178347-29037-1-git-send-email-zwu.kernel@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 30, 2013 at 05:59:07PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   It can take a long time to run log recovery operation because it is
> single threaded and is bound by read latency. We can find that it took
> most of the time to wait for the read IO to occur, so if one object
> readahead is introduced to log recovery, it will obviously reduce the
> log recovery time.
> 
> Log recovery time stat:
> 
>           w/o this patch        w/ this patch
> 
> real:        0m15.023s             0m7.802s
> user:        0m0.001s              0m0.001s
> sys:         0m0.246s              0m0.107s
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  fs/xfs/xfs_log_recover.c | 162 +++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_log_recover.h |   2 +
>  2 files changed, 159 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 7681b19..029826f 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3116,6 +3116,111 @@ xlog_recover_free_trans(
>  	kmem_free(trans);
>  }
>  
> +STATIC void
> +xlog_recover_buffer_ra_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover_item        *item)
> +{
> +	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
> +	xfs_mount_t		*mp = log->l_mp;

	struct xfs_buf_log_format
	struct xfs_mount

> +
> +	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
> +			buf_f->blf_len, buf_f->blf_flags)) {
> +		return;
> +	}
> +
> +	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
> +				buf_f->blf_len, NULL);
> +}
> +
> +STATIC void
> +xlog_recover_inode_ra_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover_item        *item)
> +{
> +	xfs_inode_log_format_t	in_buf, *in_f;
> +	xfs_mount_t		*mp = log->l_mp;

	struct xfs_inode_log_format
	struct xfs_mount

and a separate declaration for each variable.

Also, in_buf and in_f are not very good names as tehy don't follow
any commonly used XFs naming convention. The shorthand for a
struct xfs_inode_log_format variable is "ilf" and a pointer to such
an object is "ilfp". i.e:

	struct xfs_inode_log_format ilf_buf;
	struct xfs_inode_log_format *ilfp;

> +xlog_recover_dquot_ra_pass2(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	xfs_mount_t		*mp = log->l_mp;
> +	struct xfs_disk_dquot	*recddq;
> +	int			error;
> +	xfs_dq_logformat_t	*dq_f;
> +	uint			type;

More typedefs.

> +
> +
> +	if (mp->m_qflags == 0)
> +		return;
> +
> +	recddq = item->ri_buf[1].i_addr;
> +	if (recddq == NULL)
> +		return;
> +	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t))
> +		return;
> +
> +	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
> +	ASSERT(type);
> +	if (log->l_quotaoffs_flag & type)
> +		return;
> +
> +	dq_f = item->ri_buf[0].i_addr;
> +	ASSERT(dq_f);
> +	error = xfs_qm_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
> +			   "xlog_recover_dquot_ra_pass2 (log copy)");

You don't need to do validation of the dquot in the transaction
here - it's unlikely to be corrupt. Just do the readahead like for a
normal buffer, and the validation can occur when recovering the
item in the next pass.

> +	if (error)
> +		return;
> +	ASSERT(dq_f->qlf_len == 1);
> +
> +	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno,
> +				dq_f->qlf_len, NULL);
> +}
> +
> +STATIC void
> +xlog_recover_ra_pass2(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	switch (ITEM_TYPE(item)) {
> +	case XFS_LI_BUF:
> +		xlog_recover_buffer_ra_pass2(log, item);
> +		break;
> +	case XFS_LI_INODE:
> +		xlog_recover_inode_ra_pass2(log, item);
> +		break;
> +	case XFS_LI_DQUOT:
> +		xlog_recover_dquot_ra_pass2(log, item);
> +		break;
> +	case XFS_LI_EFI:
> +	case XFS_LI_EFD:
> +	case XFS_LI_QUOTAOFF:
> +	default:
> +		break;
> +	}
> +}
> +
>  STATIC int
>  xlog_recover_commit_pass1(
>  	struct xlog			*log,
> @@ -3177,6 +3282,26 @@ xlog_recover_commit_pass2(
>  	}
>  }
>  
> +STATIC int
> +xlog_recover_items_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover             *trans,
> +	struct list_head                *buffer_list,
> +	struct list_head                *ra_list)
> +{
> +	int			error = 0;
> +	xlog_recover_item_t	*item;

typedef.

> +
> +	list_for_each_entry(item, ra_list, ri_list) {
> +		error = xlog_recover_commit_pass2(log, trans,
> +					  buffer_list, item);
> +		if (error)
> +			return error;
> +	}
> +
> +	return error;
> +}
> +
>  /*
>   * Perform the transaction.
>   *
> @@ -3189,9 +3314,11 @@ xlog_recover_commit_trans(
>  	struct xlog_recover	*trans,
>  	int			pass)
>  {
> -	int			error = 0, error2;
> -	xlog_recover_item_t	*item;
> +	int			error = 0, error2, ra_qdepth = 0;
> +	xlog_recover_item_t	*item, *next;

typedef, one variable per line.

>  	LIST_HEAD		(buffer_list);
> +	LIST_HEAD		(ra_list);
> +	LIST_HEAD		(all_ra_list);

Isn't the second the "recovered" list?

i.e. objects are moved to the ra_list when readhead is issued,
then when they are committed they are moved to the "recovered"
list?

>  	hlist_del(&trans->r_list);
>  
> @@ -3199,14 +3326,21 @@ xlog_recover_commit_trans(
>  	if (error)
>  		return error;
>  
> -	list_for_each_entry(item, &trans->r_itemq, ri_list) {
> +	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
>  		switch (pass) {
>  		case XLOG_RECOVER_PASS1:
>  			error = xlog_recover_commit_pass1(log, trans, item);
>  			break;
>  		case XLOG_RECOVER_PASS2:
> -			error = xlog_recover_commit_pass2(log, trans,
> -							  &buffer_list, item);
> +			if (ra_qdepth++ >= XLOG_RECOVER_MAX_QDEPTH) {

I'd define XLOG_RECOVER_MAX_QDEPTH inside this function with all the
local variables. It has not scope outside this function.

Also, "items_queued" is a better name than ra_qdepth - we are
tracking how many items we've queued for recovery, not the number of
readahead IOs we have in progress. Similar for
XLOG_RECOVER_MAX_QDEPTH - XLOG_RECOVER_COMMIT_QUEUE_MAX might be
better.


> +				error = xlog_recover_items_pass2(log, trans,
> +						&buffer_list, &ra_list);
> +				list_splice_tail_init(&ra_list, &all_ra_list);
> +				ra_qdepth = 0;
> +			} else {
> +				xlog_recover_ra_pass2(log, item);
> +				list_move_tail(&item->ri_list, &ra_list);
> +			}
>  			break;
>  		default:
>  			ASSERT(0);
> @@ -3216,9 +3350,27 @@ xlog_recover_commit_trans(
>  			goto out;
>  	}
>  
> +	if (!list_empty(&ra_list)) {
> +		error = xlog_recover_items_pass2(log, trans,
> +				&buffer_list, &ra_list);
> +		if (error)
> +			goto out;
> +
> +		list_splice_tail_init(&ra_list, &all_ra_list);
> +	}
> +
> +	if (!list_empty(&all_ra_list))
> +		list_splice_init(&all_ra_list, &trans->r_itemq);
> +
>  	xlog_recover_free_trans(trans);
>  
>  out:
> +	if (!list_empty(&ra_list))
> +		list_splice_tail_init(&ra_list, &all_ra_list);
> +
> +	if (!list_empty(&all_ra_list))
> +		list_splice_init(&all_ra_list, &trans->r_itemq);

The error handling here is all wrong. xlog_recover_free_trans()
frees everything on the trans->r_itemq, and then frees trans, so
this is both leaky and a use after free. This is all you need to do
here:

@@ -3216,6 +3359,13 @@ xlog_recover_commit_trans(
 		if (error)
 			goto out;
 	}
+	if (!list_empty(&ra_list)) {
+		error = recover_commit(log, trans, &buffer_list, &ra_list);
+		list_splice_init(&ra_list, &done_list);
+	}
+
+	if (!list_empty(&done_list))
+		list_splice(&done_list, &trans->r_itemq);
 
 	xlog_recover_free_trans(trans);
 

i.e. run the recovery of the remainder of the ra_list, splice it
to the done list, the splice the done list back to the trans and
then free the trans. The error path falls through naturally and
without needing any special handling....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
