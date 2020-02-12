Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210B4C2BA83
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 15:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C1020873
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 15:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHHnjBEl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBLPNm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 10:13:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42167 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727458AbgBLPNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 10:13:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581520419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+2Nm2xcQ9aE2w7EYOr1muGz8r6UdIeRWxF+cxiO7Cmo=;
        b=EHHnjBElm2w0g258srvHeiEurvPYS2YyAWdpcFYVQvpIR2Nd8sHC7cSaVQyH8Q4hAnlHM6
        5JAPyuxBvakRnKDgxtw4Rw/sULaFswPu5H+yRI280fI1h6kRISQc+OsD+lor6bVxF4dNBm
        5QFdQMlIZMQiWHdvUiThpEbd7UGkiI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-DOCLXGuZPx2hKFJpYWPfkw-1; Wed, 12 Feb 2020 10:13:31 -0500
X-MC-Unique: DOCLXGuZPx2hKFJpYWPfkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21926800D41;
        Wed, 12 Feb 2020 15:13:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C19690F47;
        Wed, 12 Feb 2020 15:13:29 +0000 (UTC)
Date:   Wed, 12 Feb 2020 10:13:27 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com
Subject: Re: [PATCH V3 2/2] xfs: Fix log reservation calculation for xattr
 insert operation
Message-ID: <20200212151327.GB17921@bfoster>
References: <20200129045939.10380-1-chandanrlinux@gmail.com>
 <20200129045939.10380-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129045939.10380-2-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 10:29:39AM +0530, Chandan Rajendra wrote:
> Log space reservation for xattr insert operation can be divided into two
> parts,
> 1. Mount time
>    - Inode
>    - Superblock for accounting space allocations
>    - AGF for accounting space used be count, block number, rmapbt and refcnt
>      btrees.
> 
> 2. The remaining log space can only be calculated at run time because,
>    - A local xattr can be large enough to cause a double split of the dabtree.
>    - The value of the xattr can be large enough to be stored in remote
>      blocks. The contents of the remote blocks are not logged.
> 
>    The log space reservation could be,
>    - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
>      number of blocks are required if xattr is large enough to cause another
>      split of the dabtree path from root to leaf block.
>    - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
>      entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
>      case of a double split of the dabtree path from root to leaf blocks.
>    - Space for logging blocks of count, block number, rmap and refcnt btrees.
> 
> Presently, mount time log reservation includes block count required for a
> single split of the dabtree. The dabtree block count is also taken into
> account by xfs_attr_calc_size().
> 
> Also, AGF log space reservation isn't accounted for. Hence log reservation
> calculation for xattr insert operation gives an incorrect value.
> 
> Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> 
> To fix these issues, this commit refactors xfs_attr_calc_size() to calculate,
> 1. The number of dabtree blocks that need to be logged.
> 2. The number of remote blocks that need to be allocated.
> 3. The number of dabtree blocks that need to be allocated.
> 4. The number of bmbt blocks that need to be allocated.
> 5. The total number of blocks that need to be allocated.
> 
> xfs_attr_set() uses this information to compute number of bytes that needs to
> be reserved in the log.
> 
> This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> xfs_attr_calc_size() to obtain the number of blocks to be logged which it uses
> to figure out the total number of bytes to be logged.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
> Changelog:
> V1 -> V2:
> 1. Use convenience variables to reduce indentation of code.
> 
> V2 -> V3:
> 1. Introduce 'struct xfs_attr_set_resv' to be used an as out parameter
>    holding xattr reservation values.
> 2. Calculate number of bmbt blocks and total allocation blocks within
>    xfs_attr_calc_size().
> 
>  fs/xfs/libxfs/xfs_attr.c       | 93 +++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_attr.h       | 20 +++++++-
>  fs/xfs/libxfs/xfs_log_rlimit.c | 14 ++---
>  fs/xfs/libxfs/xfs_trans_resv.c | 52 +++++++++----------
>  fs/xfs/libxfs/xfs_trans_resv.h |  2 +
>  5 files changed, 107 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1eae1db74f6cd..1f3b001a1092e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -248,6 +211,53 @@ xfs_attr_try_sf_addname(
>  	return error ? error : error2;
>  }
>  
> +/*
> + * Calculate how many blocks we need for the new attribute,
> + */
> +void
> +xfs_attr_calc_size(
> +	struct xfs_mount		*mp,
> +	struct xfs_attr_set_resv	*resv,
> +	int				namelen,
> +	int				valuelen,
> +	int				*local)
> +{
> +	unsigned int		blksize;
> +	int			size;
> +
> +	blksize = mp->m_dir_geo->blksize;
> +
> +	/*
> +	 * Determine space new attribute will use, and if it would be
> +	 * "local" or "remote" (note: local != inline).
> +	 */
> +	size = xfs_attr_leaf_newentsize(mp, namelen, valuelen, local);
> +
> +	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> +	resv->log_dablks = 2 * resv->total_dablks;
> +

It looks like this changes the setxattr transaction reservation
calculation at the same time as refactoring how the reservation is
calculated, which makes it hard to even identify what is changing. Can
you split the general refactoring and calculation changes into
independent patches? E.g., refactor the existing calculation first and
then subsequently fix up the calculation..?

Brian

> +	if (*local) {
> +		if (size > (blksize / 2)) {
> +			/* Double split possible */
> +			resv->log_dablks += resv->total_dablks;
> +			resv->total_dablks *= 2;
> +		}
> +	} else {
> +		/*
> +		 * Out of line attribute, cannot double split, but
> +		 * make room for the attribute value itself.
> +		 */
> +		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, valuelen);
> +	}
> +
> +	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
> +					resv->total_dablks + resv->rmt_blks,
> +					XFS_ATTR_FORK);
> +
> +	resv->alloc_blks = resv->total_dablks + resv->rmt_blks +
> +		resv->bmbt_blks;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   */
> @@ -344,6 +354,7 @@ xfs_attr_set(
>  	int			flags)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_attr_set_resv resv = { 0 };
>  	struct xfs_da_args	args;
>  	struct xfs_trans_res	tres;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
> @@ -361,7 +372,10 @@ xfs_attr_set(
>  	args.value = value;
>  	args.valuelen = valuelen;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> -	args.total = xfs_attr_calc_size(&args, &local);
> +
> +	xfs_attr_calc_size(mp, &resv, args.namelen, args.valuelen, &local);
> +
> +	args.total = resv.alloc_blks;
>  
>  	error = xfs_qm_dqattach(dp);
>  	if (error)
> @@ -380,8 +394,7 @@ xfs_attr_set(
>  			return error;
>  	}
>  
> -	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> +	tres.tr_logres = xfs_calc_attr_res(mp, &resv);
>  	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 94badfa1743e3..0b42faf7d6a1f 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -131,6 +131,22 @@ typedef struct xfs_attr_list_context {
>  	int				index;		/* index into output buffer */
>  } xfs_attr_list_context_t;
>  
> +struct xfs_attr_set_resv {
> +	/* Number of blocks in the da btree that we might need to log. */
> +	unsigned int		log_dablks;
> +
> +	/* Number of unlogged blocks needed to store the remote attr value. */
> +	unsigned int		rmt_blks;
> +
> +	/* Number of blocks to allocate for the da btree. */
> +	unsigned int		total_dablks;
> +
> +	/* Blocks we might need to create all the new attr fork mappings. */
> +	unsigned int		bmbt_blks;
> +
> +	/* Total number of blocks we might have to allocate. */
> +	unsigned int		alloc_blks;
> +};
>  
>  /*========================================================================
>   * Function prototypes for the kernel.
> @@ -154,5 +170,7 @@ int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> -
> +void xfs_attr_calc_size(struct xfs_mount *mp,
> +			struct xfs_attr_set_resv *resv,
> +			int namelen, int valuelen, int *local);
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 7f55eb3f36536..26566c25c7e2c 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_attr.h"
>  #include "xfs_da_format.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_da_btree.h"
> @@ -23,17 +24,16 @@ STATIC int
>  xfs_log_calc_max_attrsetm_res(
>  	struct xfs_mount	*mp)
>  {
> -	int			size;
> -	int			nblks;
> +	struct xfs_attr_set_resv resv = { 0 };
> +	int		size;
> +	int		local;
>  
>  	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
>  	       MAXNAMELEN - 1;
> -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> -	nblks += XFS_B_TO_FSB(mp, size);
> -	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> +	xfs_attr_calc_size(mp, &resv, size, 0, &local);
> +	ASSERT(local == 1);
>  
> -	return  M_RES(mp)->tr_attrsetm.tr_logres +
> -		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
> +	return xfs_calc_attr_res(mp, &resv);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 824073a839acb..867f1954c49bc 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -19,6 +19,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  #include "xfs_trans_space.h"
> +#include "xfs_attr.h"
>  
>  #define _ALLOC	true
>  #define _FREE	false
> @@ -701,12 +702,10 @@ xfs_calc_attrinval_reservation(
>   * Setting an attribute at mount time.
>   *	the inode getting the attribute
>   *	the superblock for allocations
> - *	the agfs extents are allocated from
> - *	the attribute btree * max depth
> - *	the inode allocation btree
> + *	the agf extents are allocated from
>   * Since attribute transaction space is dependent on the size of the attribute,
>   * the calculation is done partially at mount time and partially at runtime(see
> - * below).
> + * xfs_attr_calc_size()).
>   */
>  STATIC uint
>  xfs_calc_attrsetm_reservation(
> @@ -714,27 +713,7 @@ xfs_calc_attrsetm_reservation(
>  {
>  	return XFS_DQUOT_LOGRES(mp) +
>  		xfs_calc_inode_res(mp, 1) +
> -		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
> -}
> -
> -/*
> - * Setting an attribute at runtime, transaction space unit per block.
> - * 	the superblock for allocations: sector size
> - *	the inode bmap btree could join or split: max depth * block size
> - * Since the runtime attribute transaction space is dependent on the total
> - * blocks needed for the 1st bmap, here we calculate out the space unit for
> - * one block so that the caller could figure out the total space according
> - * to the attibute extent length in blocks by:
> - *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
> - */
> -STATIC uint
> -xfs_calc_attrsetrt_reservation(
> -	struct xfs_mount	*mp)
> -{
> -	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
> -				 XFS_FSB_TO_B(mp, 1));
> +		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
>  }
>  
>  /*
> @@ -832,6 +811,27 @@ xfs_calc_sb_reservation(
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  }
>  
> +uint
> +xfs_calc_attr_res(
> +	struct xfs_mount		*mp,
> +	struct xfs_attr_set_resv	*resv)
> +{
> +	unsigned int		space_blks;
> +	unsigned int		attr_res;
> +
> +	space_blks = xfs_allocfree_log_count(mp,
> +			resv->total_dablks + resv->bmbt_blks);
> +
> +	attr_res = M_RES(mp)->tr_attrsetm.tr_logres +
> +		xfs_calc_buf_res(resv->log_dablks,
> +				mp->m_attr_geo->blksize) +
> +		xfs_calc_buf_res(resv->bmbt_blks,
> +				mp->m_sb.sb_blocksize) +
> +		xfs_calc_buf_res(space_blks, mp->m_sb.sb_blocksize);
> +
> +	return attr_res;
> +}
> +
>  void
>  xfs_trans_resv_calc(
>  	struct xfs_mount	*mp,
> @@ -942,7 +942,7 @@ xfs_trans_resv_calc(
>  	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
>  	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
>  	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
> -	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
> +	resp->tr_attrsetrt.tr_logres = 0;
>  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
>  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
>  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 7241ab28cf84f..3a6a0bf21e9b1 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -7,6 +7,7 @@
>  #define	__XFS_TRANS_RESV_H__
>  
>  struct xfs_mount;
> +struct xfs_attr_set_resv;
>  
>  /*
>   * structure for maintaining pre-calculated transaction reservations.
> @@ -91,6 +92,7 @@ struct xfs_trans_resv {
>  #define	XFS_ATTRSET_LOG_COUNT		3
>  #define	XFS_ATTRRM_LOG_COUNT		3
>  
> +uint xfs_calc_attr_res(struct xfs_mount *mp, struct xfs_attr_set_resv *resv);
>  void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
>  uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
>  
> -- 
> 2.19.1
> 

