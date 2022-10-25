Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83077FA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 20:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiJYUzW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 16:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJYUzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 16:55:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4075FADC
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 13:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B63B81BE1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 20:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA47EC433C1;
        Tue, 25 Oct 2022 20:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666731307;
        bh=9KWN8V9FNcAkGW8FCBErDay+ySZ5pGNeierHIOhnYQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QacdNWQxlforxazOSfy+F4Ho+BnS6CAxHBXxnuk4FLFuCyoq/e6ptaYzFpkwUinAB
         dhnDpPHkpgv95TgbnBa4cf4aYH/rLARZGRoxKuvVKtsWJ4hGZochVfrkCg9ZUq7bIB
         0Ku9ukAjojSfoNxL6qpOzDj8N92N+3aSOVBdiVMKYTzPJN/cMwOYJGVUpCHg37T+Z4
         qlTovqSdDDtsWsu9cQUgB/kwBBF2RlIrVLBpjmNtN0CPJZ/E61+tfWqHMJIm9bsM7P
         wM/Q9smDDybpP/JtI3bzthTBXzqSIYy0Rz9b0E9shirzmo2XnJ1doG2TQA+C5+CBeW
         3wpi94v5qixvQ==
Date:   Tue, 25 Oct 2022 13:55:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 14/27] xfs: extend transaction reservations for parent
 attributes
Message-ID: <Y1hNK0aHNZYo5M/d@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-15-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:23PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> We need to add, remove or modify parent pointer attributes during
> create/link/unlink/rename operations atomically with the dirents in the
> parent directories being modified. This means they need to be modified
> in the same transaction as the parent directories, and so we need to add
> the required space for the attribute modifications to the transaction
> reservations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 303 +++++++++++++++++++++++++++------
>  1 file changed, 249 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 5b2f27cbdb80..756b6f38c385 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -19,6 +19,9 @@
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  #include "xfs_trans_space.h"
> +#include "xfs_attr_item.h"
> +#include "xfs_log.h"
> +#include "xfs_da_format.h"
>  
>  #define _ALLOC	true
>  #define _FREE	false
> @@ -426,23 +429,62 @@ xfs_calc_itruncate_reservation_minlogsize(
>   *    the two directory btrees: 2 * (max depth + v2) * dir block size
>   *    the two directory bmap btrees: 2 * max depth * block size
>   * And the bmap_finish transaction can free dir and bmap blocks (two sets
> - *	of bmap blocks) giving:
> + *	of bmap blocks) giving (t2):
>   *    the agf for the ags in which the blocks live: 3 * sector size
>   *    the agfl for the ags in which the blocks live: 3 * sector size
>   *    the superblock for the free block count: sector size
>   *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
> + * If parent pointers are enabled (t3), then each transaction in the chain
> + *    must be capable of setting or removing the extended attribute
> + *    containing the parent information.  It must also be able to handle
> + *    the three xattr intent items that track the progress of the parent
> + *    pointer update.

To check my assumptions here: For a standard rename, the three xattr
intent items are (1) replacing the pptr for the source file; (2)
removing the pptr on the dest file; and (3) adding a pptr for the
whiteout file in the src dir?

For an RENAME_EXCHANGE, there are two xattr intent items to replace the
pptr for both src and dest files.  Link counts don't change and there is
no whiteout, correct?

>   */
>  STATIC uint
>  xfs_calc_rename_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> -		max((xfs_calc_inode_res(mp, 5) +
> -		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
> -				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
> -				      XFS_FSB_TO_B(mp, 1))));
> +	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
> +	struct xfs_trans_resv	*resp = M_RES(mp);
> +	unsigned int		t1, t2, t3 = 0;
> +
> +	t1 = xfs_calc_inode_res(mp, 5) +
> +	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
> +			XFS_FSB_TO_B(mp, 1));
> +
> +	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> +	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
> +			XFS_FSB_TO_B(mp, 1));
> +
> +	if (xfs_has_parent(mp)) {
> +		t3 = max(resp->tr_attrsetm.tr_logres,
> +				resp->tr_attrrm.tr_logres);
> +		overhead += 4 * (sizeof(struct xfs_attri_log_item) +

I'm not sure why this multiplies by four then?

The log reservation is for the ondisk structures, so the sizeof should
be for xfs_attri_log_format, not xfs_attri_log_item.

> +				 (2 * xlog_calc_iovec_len(XATTR_NAME_MAX)) +

I guess the 2 * XATTR_NAME_MAX is to log replacing the old name with
the new name?

> +				 xlog_calc_iovec_len(
> +					sizeof(struct xfs_parent_name_rec)));

And this last one is for the xattr "name", which is just the (parent,
gen, diroffset) structure?

I'm concerned about the overhead becoming unnecessarily large here,
since that all comes out to:

	4 * (48 +
	     (2 * 256) +
	     16)

	= 2304 bytes?  Or 1728 bytes if we only multiply by 3?

Ok, maybe I'm not so concerned after all; 2.3k isn't that large as
compared to logging entire fsblock buffers.  These namespace
transactions are 300-400KB in size.  Could this be reduced further,
though?

For a regular rename, we're doing a replace, a link, and an unlink.

	(48 + (2 * 256)) +
	(48 + 256) +
	(48)

	= 912 bytes

For a RENAME_EXCHANGE, we're doing two replaces:

	(48 + (2 * 256)) +
	(48 + (2 * 256))

	= 1120 bytes

I'm glad that 1728 is larger than both of those. :)

Looking forward in this patch, I see the same open-coded overhead
calculations and wonder what you think of the following refactoring:

static inline unsigned int xfs_calc_pptr_link_overhead(void)
{
	return sizeof(struct xfs_attri_log_format) +
			xlog_calc_iovec_len(XATTR_NAME_MAX) +
			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
}
static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
{
	return sizeof(struct xfs_attri_log_format) +
			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
}
static inline unsigned int xfs_calc_pptr_replace_overhead(void)
{
	return sizeof(struct xfs_attri_log_format) +
			xlog_calc_iovec_len(XATTR_NAME_MAX) +
			xlog_calc_iovec_len(XATTR_NAME_MAX) +
			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
}

And then the above becomes:

	if (xfs_has_parent(mp)) {
		unsigned int	rename_overhead, exchange_overhead;

		t3 = max(resp->tr_attrsetm.tr_logres,
			 resp->tr_attrrm.tr_logres);

		/*
		 * For a standard rename, the three xattr intent log items
		 * are (1) replacing the pptr for the source file; (2)
		 * removing the pptr on the dest file; and (3) adding a
		 * pptr for the whiteout file in the src dir.
		 *
		 * For an RENAME_EXCHANGE, there are two xattr intent
		 * items to replace the pptr for both src and dest
		 * files.  Link counts don't change and there is no
		 * whiteout.
		 *
		 * In the worst case we can end up relogging all log
		 * intent items to allow the log tail to move ahead, so
		 * they become overhead added to each transaction in a
		 * processing chain.
		 */
		rename_overhead = xfs_calc_pptr_replace_overhead() +
				  xfs_calc_pptr_unlink_overhead() +
				  xfs_calc_pptr_link_overhead();
		exchange_overhead = 2 * xfs_calc_pptr_replace_overhead();

		overhead += max(rename_overhead, exchange_overhead);
	}

You might want to come up with better names though.

> +	}
> +
> +	return overhead + max3(t1, t2, t3);
> +}
> +
> +static inline unsigned int
> +xfs_rename_log_count(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	/* One for the rename, one more for freeing blocks */
> +	unsigned int		ret = XFS_RENAME_LOG_COUNT;
> +
> +	/*
> +	 * Pre-reserve enough log reservation to handle the transaction
> +	 * rolling needed to remove or add one parent pointer.
> +	 */
> +	if (xfs_has_parent(mp))
> +		ret += max(resp->tr_attrsetm.tr_logcount,
> +			   resp->tr_attrrm.tr_logcount);
> +
> +	return ret;
>  }
>  
>  /*
> @@ -459,6 +501,23 @@ xfs_calc_iunlink_remove_reservation(
>  	       2 * M_IGEO(mp)->inode_cluster_size;
>  }
>  
> +static inline unsigned int
> +xfs_link_log_count(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	unsigned int		ret = XFS_LINK_LOG_COUNT;
> +
> +	/*
> +	 * Pre-reserve enough log reservation to handle the transaction
> +	 * rolling needed to add one parent pointer.
> +	 */
> +	if (xfs_has_parent(mp))
> +		ret += resp->tr_attrsetm.tr_logcount;
> +
> +	return ret;
> +}
> +
>  /*
>   * For creating a link to an inode:
>   *    the parent directory inode: inode size
> @@ -475,14 +534,27 @@ STATIC uint
>  xfs_calc_link_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> -		xfs_calc_iunlink_remove_reservation(mp) +
> -		max((xfs_calc_inode_res(mp, 2) +
> -		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
> -				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
> -				      XFS_FSB_TO_B(mp, 1))));
> +	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
> +	struct xfs_trans_resv   *resp = M_RES(mp);
> +	unsigned int            t1, t2, t2_1, t2_2, t3 = 0;
> +
> +	t1 = xfs_calc_iunlink_remove_reservation(mp);
> +	t2_1 = xfs_calc_inode_res(mp, 2) +
> +	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
> +	t2_2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> +	       xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
> +				XFS_FSB_TO_B(mp, 1));
> +	t2 = max(t2_1, t2_2);

Add xfs_calc_iunlink_remove_reservation to overhead, rename t2_1 to t1
and t2_2 to t2, and the return statement can become:

	return overhead + max3(t1, t2, t3);

> +
> +	if (xfs_has_parent(mp)) {
> +		t3 = resp->tr_attrsetm.tr_logres;
> +		overhead += sizeof(struct xfs_attri_log_item) +
> +			    xlog_calc_iovec_len(XATTR_NAME_MAX) +
> +			    xlog_calc_iovec_len(
> +					sizeof(struct xfs_parent_name_rec));

		overhead += xfs_calc_pptr_link_overhead();
> +	}
> +
> +	return overhead + t1 + t2 + t3;
>  }
>  
>  /*
> @@ -497,6 +569,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
>  			M_IGEO(mp)->inode_cluster_size;
>  }
>  
> +static inline unsigned int
> +xfs_remove_log_count(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	unsigned int		ret = XFS_REMOVE_LOG_COUNT;
> +
> +	/*
> +	 * Pre-reserve enough log reservation to handle the transaction
> +	 * rolling needed to add one parent pointer.
> +	 */
> +	if (xfs_has_parent(mp))
> +		ret += resp->tr_attrrm.tr_logcount;
> +
> +	return ret;
> +}
> +
>  /*
>   * For removing a directory entry we can modify:
>   *    the parent directory inode: inode size
> @@ -513,14 +602,27 @@ STATIC uint
>  xfs_calc_remove_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> -		xfs_calc_iunlink_add_reservation(mp) +
> -		max((xfs_calc_inode_res(mp, 2) +
> -		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
> -				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
> -				      XFS_FSB_TO_B(mp, 1))));
> +	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
> +	struct xfs_trans_resv   *resp = M_RES(mp);
> +	unsigned int            t1, t2, t2_1, t2_2, t3 = 0;
> +
> +	t1 = xfs_calc_iunlink_add_reservation(mp);
> +
> +	t2_1 = xfs_calc_inode_res(mp, 2) +
> +	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
> +	t2_2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> +	       xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
> +				XFS_FSB_TO_B(mp, 1));
> +	t2 = max(t2_1, t2_2);

Similar to the last _reservation function -- add
xfs_calc_iunlink_add_reservation to overhead, rename t2_1 to t1 and t2_2
to t2 and the return statement becomes:

	return overhead + max3(t1, t2, t3);

> +	if (xfs_has_parent(mp)) {
> +		t3 = resp->tr_attrrm.tr_logres;
> +		overhead += sizeof(struct xfs_attri_log_item) +
> +			    xlog_calc_iovec_len(
> +					sizeof(struct xfs_parent_name_rec));

		overhead += xfs_calc_pptr_unlink_overhead();

> +	}
> +
> +	return overhead + t1 + t2 + t3;
>  }
>  
>  /*
> @@ -569,12 +671,39 @@ xfs_calc_icreate_resv_alloc(
>  		xfs_calc_finobt_res(mp);
>  }
>  
> +static inline unsigned int
> +xfs_icreate_log_count(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	unsigned int		ret = XFS_CREATE_LOG_COUNT;
> +
> +	/*
> +	 * Pre-reserve enough log reservation to handle the transaction
> +	 * rolling needed to add one parent pointer.
> +	 */
> +	if (xfs_has_parent(mp))
> +		ret += resp->tr_attrsetm.tr_logcount;
> +
> +	return ret;
> +}
> +
>  STATIC uint
> -xfs_calc_icreate_reservation(xfs_mount_t *mp)
> +xfs_calc_icreate_reservation(
> +	struct xfs_mount	*mp)
>  {
> -	return XFS_DQUOT_LOGRES(mp) +
> -		max(xfs_calc_icreate_resv_alloc(mp),
> -		    xfs_calc_create_resv_modify(mp));
> +	struct xfs_trans_resv   *resp = M_RES(mp);
> +	unsigned int		ret = XFS_DQUOT_LOGRES(mp) +
> +				      max(xfs_calc_icreate_resv_alloc(mp),
> +				      xfs_calc_create_resv_modify(mp));

Stylistic complaint: Please follow the same format as the other _calc
functions:

	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
	unsigned int		t1, t2, t3 = 0;

	t1 = xfs_calc_icreate_resv_alloc(mp);
	t2 = xfs_calc_create_resv_modify(mp);

	if (xfs_has_parent(mp)) {
		t3 = resp->tr_attrsetm.tr_logres;
		overhead += xfs_calc_pptr_link_overhead();
	}

	return overhead + max3(t1, t2, t3);

> +
> +	if (xfs_has_parent(mp))
> +		ret += resp->tr_attrsetm.tr_logres +
> +		       sizeof(struct xfs_attri_log_item) +
> +		       xlog_calc_iovec_len(XATTR_NAME_MAX) +
> +		       xlog_calc_iovec_len(
> +					sizeof(struct xfs_parent_name_rec));
> +	return ret;
>  }
>  
>  STATIC uint
> @@ -587,6 +716,23 @@ xfs_calc_create_tmpfile_reservation(
>  	return res + xfs_calc_iunlink_add_reservation(mp);
>  }
>  
> +static inline unsigned int
> +xfs_mkdir_log_count(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	unsigned int		ret = XFS_MKDIR_LOG_COUNT;
> +
> +	/*
> +	 * Pre-reserve enough log reservation to handle the transaction
> +	 * rolling needed to add one parent pointer.
> +	 */
> +	if (xfs_has_parent(mp))
> +		ret += resp->tr_attrsetm.tr_logcount;
> +
> +	return ret;
> +}
> +
>  /*
>   * Making a new directory is the same as creating a new file.
>   */
> @@ -597,6 +743,22 @@ xfs_calc_mkdir_reservation(
>  	return xfs_calc_icreate_reservation(mp);
>  }
>  
> +static inline unsigned int
> +xfs_symlink_log_count(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	unsigned int		ret = XFS_SYMLINK_LOG_COUNT;
> +
> +	/*
> +	 * Pre-reserve enough log reservation to handle the transaction
> +	 * rolling needed to add one parent pointer.
> +	 */
> +	if (xfs_has_parent(mp))
> +		ret += resp->tr_attrsetm.tr_logcount;
> +
> +	return ret;
> +}
>  
>  /*
>   * Making a new symplink is the same as creating a new file, but
> @@ -607,8 +769,17 @@ STATIC uint
>  xfs_calc_symlink_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return xfs_calc_icreate_reservation(mp) +
> -	       xfs_calc_buf_res(1, XFS_SYMLINK_MAXLEN);
> +	struct xfs_trans_resv   *resp = M_RES(mp);
> +	unsigned int		ret = xfs_calc_icreate_reservation(mp) +
> +				      xfs_calc_buf_res(1, XFS_SYMLINK_MAXLEN);
> +
> +	if (xfs_has_parent(mp))
> +		ret += resp->tr_attrsetm.tr_logres +
> +		       sizeof(struct xfs_attri_log_item) +
> +		       xlog_calc_iovec_len(XATTR_NAME_MAX) +
> +		       xlog_calc_iovec_len(
> +					sizeof(struct xfs_parent_name_rec));

Didn't we already account for the pptr log item overhead in
xfs_calc_icreate_reservation?

> +	return ret;
>  }
>  
>  /*
> @@ -909,54 +1080,76 @@ xfs_calc_sb_reservation(
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  }
>  
> -void
> -xfs_trans_resv_calc(
> +/*
> + * Namespace reservations.
> + *
> + * These get tricky when parent pointers are enabled as we have attribute
> + * modifications occurring from within these transactions. Rather than confuse
> + * each of these reservation calculations with the conditional attribute
> + * reservations, add them here in a clear and concise manner. This assumes that

s/assumes/requires/ since you put in ASSERTs :)

--D

> + * the attribute reservations have already been calculated.
> + *
> + * Note that we only include the static attribute reservation here; the runtime
> + * reservation will have to be modified by the size of the attributes being
> + * added/removed/modified. See the comments on the attribute reservation
> + * calculations for more details.
> + */
> +STATIC void
> +xfs_calc_namespace_reservations(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_resv	*resp)
>  {
> -	int			logcount_adj = 0;
> -
> -	/*
> -	 * The following transactions are logged in physical format and
> -	 * require a permanent reservation on space.
> -	 */
> -	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
> -	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> -	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> -
> -	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
> -	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> -	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +	ASSERT(resp->tr_attrsetm.tr_logres > 0);
>  
>  	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
> -	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
> +	resp->tr_rename.tr_logcount = xfs_rename_log_count(mp, resp);
>  	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
>  	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
> -	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
> +	resp->tr_link.tr_logcount = xfs_link_log_count(mp, resp);
>  	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
>  	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
> -	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
> +	resp->tr_remove.tr_logcount = xfs_remove_log_count(mp, resp);
>  	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
>  	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
> -	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
> +	resp->tr_symlink.tr_logcount = xfs_symlink_log_count(mp, resp);
>  	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
>  	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
> -	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
> +	resp->tr_create.tr_logcount = xfs_icreate_log_count(mp, resp);
>  	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> +	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> +	resp->tr_mkdir.tr_logcount = xfs_mkdir_log_count(mp, resp);
> +	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +}
> +
> +void
> +xfs_trans_resv_calc(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	int			logcount_adj = 0;
> +
> +	/*
> +	 * The following transactions are logged in physical format and
> +	 * require a permanent reservation on space.
> +	 */
> +	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
> +	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> +	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
> +	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> +	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
>  	resp->tr_create_tmpfile.tr_logres =
>  			xfs_calc_create_tmpfile_reservation(mp);
>  	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
>  	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> -	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> -	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> -	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> -
>  	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
>  	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
>  	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> @@ -986,6 +1179,8 @@ xfs_trans_resv_calc(
>  	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
>  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> +	xfs_calc_namespace_reservations(mp, resp);
> +
>  	/*
>  	 * The following transactions are logged in logical format with
>  	 * a default log count.
> -- 
> 2.25.1
> 
