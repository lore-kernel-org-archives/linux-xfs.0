Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n39HvXeI007218 for <xfs@oss.sgi.com>; Thu, 9 Apr 2009 12:57:43 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82FF7AC003
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2009 10:57:14 -0700 (PDT)
Message-Id: <81C20178-5096-4E2E-A588-28AAE674748F@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <1239189748-11703-57-git-send-email-jwjstone@fastmail.fm>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 56/56] xfs: Remove void casts
Date: Thu, 9 Apr 2009 12:37:08 -0500
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-17-git-send-email-jwjstone@fastmail.fm
	> <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-34-git-send-email-jwjstone@fastmail.fm> <
	1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-51-git-send-email-jwjstone@fastmail.fm> <123
	9189748-11703-52-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-56-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-57-git-send-email-jwjstone@fastmail.fm>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jack Stone <jwjstone@fastmail.fm>
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, jeff@garzik.org, xfs mailing list <xfs@oss.sgi.com>


On Apr 8, 2009, at 6:22 AM, Jack Stone wrote:

> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>

See comments below.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
> fs/xfs/quota/xfs_dquot_item.c |    2 +-
> fs/xfs/support/ktrace.c       |    6 +++---
> fs/xfs/xfs_attr_leaf.c        |    2 +-
> fs/xfs/xfs_buf_item.c         |    6 +++---
> fs/xfs/xfs_extfree_item.c     |    8 ++++----
> fs/xfs/xfs_inode.c            |    5 ++---
> fs/xfs/xfs_log_recover.c      |    9 ++++-----
> fs/xfs/xfs_trans.c            |    2 +-
> fs/xfs/xfs_trans_inode.c      |    3 +--
> fs/xfs/xfs_trans_item.c       |    6 ++----
> 10 files changed, 22 insertions(+), 27 deletions(-)
>
> diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/ 
> xfs_dquot_item.c
> index 1728f6a..a4d970a 100644
> --- a/fs/xfs/quota/xfs_dquot_item.c
> +++ b/fs/xfs/quota/xfs_dquot_item.c
> @@ -648,7 +648,7 @@ xfs_qm_qoff_logitem_init(
> {
> 	xfs_qoff_logitem_t	*qf;
>
> -	qf = (xfs_qoff_logitem_t*) kmem_zalloc(sizeof(xfs_qoff_logitem_t),  
> KM_SLEEP);
> +	qf = kmem_zalloc(sizeof(xfs_qoff_logitem_t), KM_SLEEP);
>
> 	qf->qql_item.li_type = XFS_LI_QUOTAOFF;
> 	if (start)
> diff --git a/fs/xfs/support/ktrace.c b/fs/xfs/support/ktrace.c
> index 2d494c2..3982acf 100644
> --- a/fs/xfs/support/ktrace.c
> +++ b/fs/xfs/support/ktrace.c
> @@ -58,7 +58,7 @@ ktrace_alloc(int nentries, unsigned int __nocast  
> sleep)
> 	ktrace_entry_t  *ktep;
> 	int		entries;
>
> -	ktp = (ktrace_t*)kmem_zone_alloc(ktrace_hdr_zone, sleep);
> +	ktp = kmem_zone_alloc(ktrace_hdr_zone, sleep);
>
> 	if (ktp == (ktrace_t*)NULL) {
> 		/*
> @@ -75,10 +75,10 @@ ktrace_alloc(int nentries, unsigned int __nocast  
> sleep)
> 	 */
> 	entries = roundup_pow_of_two(nentries);
> 	if (entries == ktrace_zentries) {
> -		ktep = (ktrace_entry_t*)kmem_zone_zalloc(ktrace_ent_zone,
> +		ktep = kmem_zone_zalloc(ktrace_ent_zone,
> 							    sleep);

Combine two lines.

>
> 	} else {
> -		ktep = (ktrace_entry_t*)kmem_zalloc((entries * sizeof(*ktep)),
> +		ktep = kmem_zalloc((entries * sizeof(*ktep)),
> 							    sleep | KM_LARGE);

Ditto.

>
> 	}
>
> diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> index afdc891..688e894 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -2869,7 +2869,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **trans,  
> xfs_inode_t *dp, xfs_dabuf_t *bp)
> 	 * Allocate storage for a list of all the "remote" value extents.
> 	 */
> 	size = count * sizeof(xfs_attr_inactive_list_t);
> -	list = (xfs_attr_inactive_list_t *)kmem_alloc(size, KM_SLEEP);
> +	list = kmem_alloc(size, KM_SLEEP);
>
> 	/*
> 	 * Identify each of the "remote" value extents.
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 92af409..431755a 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -726,7 +726,7 @@ xfs_buf_item_init(
> 	chunks = (int)((XFS_BUF_COUNT(bp) + (XFS_BLI_CHUNK - 1)) >>  
> XFS_BLI_SHIFT);
> 	map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);
>
> -	bip = (xfs_buf_log_item_t*)kmem_zone_zalloc(xfs_buf_item_zone,
> +	bip = kmem_zone_zalloc(xfs_buf_item_zone,
> 						    KM_SLEEP);

Ditto.

>
> 	bip->bli_item.li_type = XFS_LI_BUF;
> 	bip->bli_item.li_ops = &xfs_buf_item_ops;
> @@ -751,9 +751,9 @@ xfs_buf_item_init(
> 	 * the buffer to indicate which bytes the callers have asked
> 	 * to have logged.
> 	 */
> -	bip->bli_orig = (char *)kmem_alloc(XFS_BUF_COUNT(bp), KM_SLEEP);
> +	bip->bli_orig = kmem_alloc(XFS_BUF_COUNT(bp), KM_SLEEP);
> 	memcpy(bip->bli_orig, XFS_BUF_PTR(bp), XFS_BUF_COUNT(bp));
> -	bip->bli_logged = (char *)kmem_zalloc(XFS_BUF_COUNT(bp) / NBBY,  
> KM_SLEEP);
> +	bip->bli_logged = kmem_zalloc(XFS_BUF_COUNT(bp) / NBBY, KM_SLEEP);
> #endif
>
> 	/*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 05a4bdd..53ccdc4 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -253,9 +253,9 @@ xfs_efi_init(xfs_mount_t	*mp,
> 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
> 		size = (uint)(sizeof(xfs_efi_log_item_t) +
> 			((nextents - 1) * sizeof(xfs_extent_t)));
> -		efip = (xfs_efi_log_item_t*)kmem_zalloc(size, KM_SLEEP);
> +		efip = kmem_zalloc(size, KM_SLEEP);
> 	} else {
> -		efip = (xfs_efi_log_item_t*)kmem_zone_zalloc(xfs_efi_zone,
> +		efip = kmem_zone_zalloc(xfs_efi_zone,
> 							     KM_SLEEP);

Ditto.

>
> 	}
>
> @@ -548,9 +548,9 @@ xfs_efd_init(xfs_mount_t	*mp,
> 	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> 		size = (uint)(sizeof(xfs_efd_log_item_t) +
> 			((nextents - 1) * sizeof(xfs_extent_t)));
> -		efdp = (xfs_efd_log_item_t*)kmem_zalloc(size, KM_SLEEP);
> +		efdp = kmem_zalloc(size, KM_SLEEP);
> 	} else {
> -		efdp = (xfs_efd_log_item_t*)kmem_zone_zalloc(xfs_efd_zone,
> +		efdp = kmem_zone_zalloc(xfs_efd_zone,
> 							     KM_SLEEP);

Ditto.

>
> 	}
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e7ae08d..5ab6e3d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3453,7 +3453,7 @@ xfs_iext_add_indirect_multi(
> 	 * (all extents past */
> 	if (nex2) {
> 		byte_diff = nex2 * sizeof(xfs_bmbt_rec_t);
> -		nex2_ep = (xfs_bmbt_rec_t *) kmem_alloc(byte_diff, KM_NOFS);
> +		nex2_ep = kmem_alloc(byte_diff, KM_NOFS);
> 		memmove(nex2_ep, &erp->er_extbuf[idx], byte_diff);
> 		erp->er_extcount -= nex2;
> 		xfs_iext_irec_update_extoffs(ifp, erp_idx + 1, -nex2);
> @@ -3842,8 +3842,7 @@ xfs_iext_realloc_indirect(
> 	if (new_size == 0) {
> 		xfs_iext_destroy(ifp);
> 	} else {
> -		ifp->if_u1.if_ext_irec = (xfs_ext_irec_t *)
> -			kmem_realloc(ifp->if_u1.if_ext_irec,
> +		ifp->if_u1.if_ext_irec = kmem_realloc(ifp->if_u1.if_ext_irec,
> 				new_size, size, KM_NOFS);
> 	}
> }
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 7ba4501..3037920 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1670,7 +1670,7 @@ xlog_recover_do_buffer_pass1(
> 	 * the bucket.
> 	 */
> 	if (*bucket == NULL) {
> -		bcp = (xfs_buf_cancel_t *)kmem_alloc(sizeof(xfs_buf_cancel_t),
> +		bcp = kmem_alloc(sizeof(xfs_buf_cancel_t),
> 						     KM_SLEEP);

Ditto.

>
> 		bcp->bc_blkno = blkno;
> 		bcp->bc_len = len;
> @@ -1696,7 +1696,7 @@ xlog_recover_do_buffer_pass1(
> 		nextp = nextp->bc_next;
> 	}
> 	ASSERT(prevp != NULL);
> -	bcp = (xfs_buf_cancel_t *)kmem_alloc(sizeof(xfs_buf_cancel_t),
> +	bcp = kmem_alloc(sizeof(xfs_buf_cancel_t),
> 					     KM_SLEEP);

Ditto.

>
> 	bcp->bc_blkno = blkno;
> 	bcp->bc_len = len;
> @@ -2316,7 +2316,7 @@ xlog_recover_do_inode_trans(
> 	if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
> 		in_f = (xfs_inode_log_format_t *)item->ri_buf[0].i_addr;
> 	} else {
> -		in_f = (xfs_inode_log_format_t *)kmem_alloc(
> +		in_f = kmem_alloc(
> 			sizeof(xfs_inode_log_format_t), KM_SLEEP);
> 		need_free = 1;
> 		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
> @@ -3778,8 +3778,7 @@ xlog_do_log_recovery(
> 	 * First do a pass to find all of the cancelled buf log items.
> 	 * Store them in the buf_cancel_table for use in the second pass.
> 	 */
> -	log->l_buf_cancel_table =
> -		(xfs_buf_cancel_t **)kmem_zalloc(XLOG_BC_TABLE_SIZE *
> +	log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
> 						 sizeof(xfs_buf_cancel_t*),
> 						 KM_SLEEP);
> 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8570b82..44d039d 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -868,7 +868,7 @@ shut_us_down:
> 	} else if (nvec <= XFS_TRANS_LOGVEC_COUNT) {
> 		log_vector = log_vector_fast;
> 	} else {
> -		log_vector = (xfs_log_iovec_t *)kmem_alloc(nvec *
> +		log_vector = kmem_alloc(nvec *
> 						   sizeof(xfs_log_iovec_t),

Ditto.

>
> 						   KM_SLEEP);
> 	}
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 23d276a..e1b90f0 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -271,8 +271,7 @@ xfs_trans_inode_broot_debug(
> 		ASSERT((ip->i_df.if_broot != NULL) &&
> 		       (ip->i_df.if_broot_bytes > 0));
> 		iip->ili_root_size = ip->i_df.if_broot_bytes;
> -		iip->ili_orig_root =
> -			(char*)kmem_alloc(iip->ili_root_size, KM_SLEEP);
> +		iip->ili_orig_root = kmem_alloc(iip->ili_root_size, KM_SLEEP);
> 		memcpy(iip->ili_orig_root, (char*)(ip->i_df.if_broot),
> 		      iip->ili_root_size);
> 	}
> diff --git a/fs/xfs/xfs_trans_item.c b/fs/xfs/xfs_trans_item.c
> index eb3fc57..49615dd 100644
> --- a/fs/xfs/xfs_trans_item.c
> +++ b/fs/xfs/xfs_trans_item.c
> @@ -54,8 +54,7 @@ xfs_trans_add_item(xfs_trans_t *tp, xfs_log_item_t  
> *lip)
> 	 * of them and put it at the front of the chunk list.
> 	 */
> 	if (tp->t_items_free == 0) {
> -		licp = (xfs_log_item_chunk_t*)
> -		       kmem_alloc(sizeof(xfs_log_item_chunk_t), KM_SLEEP);
> +		licp = kmem_alloc(sizeof(xfs_log_item_chunk_t), KM_SLEEP);
> 		ASSERT(licp != NULL);
> 		/*
> 		 * Initialize the chunk, and then
> @@ -460,8 +459,7 @@ xfs_trans_add_busy(xfs_trans_t *tp,  
> xfs_agnumber_t ag, xfs_extlen_t idx)
> 	 * of them and put it at the front of the chunk list.
> 	 */
> 	if (tp->t_busy_free == 0) {
> -		lbcp = (xfs_log_busy_chunk_t*)
> -		       kmem_alloc(sizeof(xfs_log_busy_chunk_t), KM_SLEEP);
> +		lbcp = kmem_alloc(sizeof(xfs_log_busy_chunk_t), KM_SLEEP);
> 		ASSERT(lbcp != NULL);
> 		/*
> 		 * Initialize the chunk, and then
> -- 
> 1.5.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
