Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5DCC54FCF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 11:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3724821473
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 11:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgDTLmO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 07:42:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbgDTLmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 07:42:12 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KBXBZh124574
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 07:42:09 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gfea9dbn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 07:42:09 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 20 Apr 2020 12:41:22 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Apr 2020 12:41:21 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KBg4RS49414336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 11:42:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E6BDAE04D;
        Mon, 20 Apr 2020 11:42:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A461AE045;
        Mon, 20 Apr 2020 11:42:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.68.184])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 11:42:03 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 19/20] xfs: Add delay ready attr set routines
Date:   Mon, 20 Apr 2020 17:15:08 +0530
Organization: IBM
In-Reply-To: <20200403221229.4995-20-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com> <20200403221229.4995-20-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-TM-AS-GCONF: 00
x-cbid: 20042011-0016-0000-0000-00000307E987
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042011-0017-0000-0000-0000336BFAF7
Message-Id: <3903108.UdAzE1QFjl@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_03:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 suspectscore=1 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200104
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday, April 4, 2020 3:42 AM Allison Collins wrote: 
> This patch modifies the attr set routines to be delay ready. This means
> they no longer roll or commit transactions, but instead return -EAGAIN
> to have the calling routine roll and refresh the transaction.  In this
> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
> state machine like switch to keep track of where it was when EAGAIN was
> returned.
> 
> Two new helper functions have been added: xfs_attr_rmtval_set_init and
> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> xfs_attr_rmtval_set, but they store the current block in the delay attr
> context to allow the caller to roll the transaction between allocations.
> This helps to simplify and consolidate code used by
> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
> now become a simple loop to refresh the transaction until the operation
> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
> removed.
> 
> Below is a state machine diagram for attr set operations. The XFS_DAS_*
> states indicate places where the function would return -EAGAIN, and then
> immediately resume from after being recalled by the calling function.
> States marked as a "subroutine state" indicate that they belong to a
> subroutine, and so the calling function needs to pass them back to that
> subroutine to allow it to finish where it left off.  But they otherwise
> do not have a role in the calling function other than just passing
> through.
> 
>  xfs_attr_set_iter()
>                  │
>                  v
>            need to upgrade
>           from sf to leaf? ──n─┐
>                  │             │
>                  y             │
>                  │             │
>                  V             │
>           XFS_DAS_ADD_LEAF     │
>                  │             │
>                  v             │
>   ┌──────n── fork has   <──────┘
>   │         only 1 blk?
>   │              │
>   │              y
>   │              │
>   │              v
>   │     xfs_attr_leaf_try_add()
>   │              │
>   │              v
>   │          had enough
>   ├──────n──   space?
>   │              │
>   │              y
>   │              │
>   │              v
>   │      XFS_DAS_FOUND_LBLK  ──┐
>   │                            │
>   │      XFS_DAS_FLIP_LFLAG  ──┤
>   │      (subroutine state)    │
>   │                            │
>   │      XFS_DAS_ALLOC_LEAF  ──┤
>   │      (subroutine state)    │
>   │                            └─>xfs_attr_leaf_addname()
>   │                                              │
>   │                                              v
>   │                                ┌─────n──  need to
>   │                                │        alloc blks?
>   │                                │             │
>   │                                │             y
>   │                                │             │
>   │                                │             v
>   │                                │  ┌─>XFS_DAS_ALLOC_LEAF
>   │                                │  │          │
>   │                                │  │          v
>   │                                │  └──y── need to alloc
>   │                                │         more blocks?
>   │                                │             │
>   │                                │             n
>   │                                │             │
>   │                                │             v
>   │                                │          was this
>   │                                └────────> a rename? ──n─┐
>   │                                              │          │
>   │                                              y          │
>   │                                              │          │
>   │                                              v          │
>   │                                        flip incomplete  │
>   │                                            flag         │
>   │                                              │          │
>   │                                              v          │
>   │                                      XFS_DAS_FLIP_LFLAG │
>   │                                              │          │
>   │                                              v          │
>   │                                            remove       │
>   │                        XFS_DAS_RM_LBLK ─> old name      │
>   │                                 ^            │          │
>   │                                 │            v          │
>   │                                 └──────y── more to      │
>   │                                            remove       │
>   │                                              │          │
>   │                                              n          │
>   │                                              │          │
>   │                                              v          │
>   │                                             done <──────┘
>   └────> XFS_DAS_LEAF_TO_NODE ─┐
>                                │
>          XFS_DAS_FOUND_NBLK  ──┤
>          (subroutine state)    │
>                                │
>          XFS_DAS_ALLOC_NODE  ──┤
>          (subroutine state)    │
>                                │
>          XFS_DAS_FLIP_NFLAG  ──┤
>          (subroutine state)    │
>                                │
>                                └─>xfs_attr_node_addname()
>                                                  │
>                                                  v
>                                          find space to store
>                                         attr. Split if needed
>                                                  │
>                                                  v
>                                          XFS_DAS_FOUND_NBLK
>                                                  │
>                                                  v
>                                    ┌─────n──  need to
>                                    │        alloc blks?
>                                    │             │
>                                    │             y
>                                    │             │
>                                    │             v
>                                    │  ┌─>XFS_DAS_ALLOC_NODE
>                                    │  │          │
>                                    │  │          v
>                                    │  └──y── need to alloc
>                                    │         more blocks?
>                                    │             │
>                                    │             n
>                                    │             │
>                                    │             v
>                                    │          was this
>                                    └────────> a rename? ──n─┐
>                                                  │          │
>                                                  y          │
>                                                  │          │
>                                                  v          │
>                                            flip incomplete  │
>                                                flag         │
>                                                  │          │
>                                                  v          │
>                                          XFS_DAS_FLIP_NFLAG │
>                                                  │          │
>                                                  v          │
>                                                remove       │
>                            XFS_DAS_RM_NBLK ─> old name      │
>                                     ^            │          │
>                                     │            v          │
>                                     └──────y── more to      │
>                                                remove       │
>                                                  │          │
>                                                  n          │
>                                                  │          │
>                                                  v          │
>                                                 done <──────┘
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 384 +++++++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_attr.h        |  16 ++
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   1 +
>  fs/xfs/libxfs/xfs_attr_remote.c | 111 +++++++-----
>  fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>  fs/xfs/xfs_attr_inactive.c      |   1 +
>  fs/xfs/xfs_trace.h              |   1 -
>  7 files changed, 351 insertions(+), 167 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f700976..c160b7a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>   * Internal routines when attribute list is one block.
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_leaf_removename(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  
> @@ -52,12 +52,13 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>  
>  STATIC void
>  xfs_delattr_context_init(
> @@ -227,8 +228,11 @@ xfs_attr_is_shortform(
>  
>  /*
>   * Attempts to set an attr in shortform, or converts the tree to leaf form if
> - * there is not enough room.  If the attr is set, the transaction is committed
> - * and set to NULL.
> + * there is not enough room.  This function is meant to operate as a helper
> + * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
> + * that the calling function should roll the transaction, and then proceed to
> + * add the attr in leaf form.  This subroutine does not expect to be recalled
> + * again like the other delayed attr routines do.
>   */
>  STATIC int
>  xfs_attr_set_shortform(
> @@ -236,16 +240,16 @@ xfs_attr_set_shortform(
>  	struct xfs_buf		**leaf_bp)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	int			error, error2 = 0;
> +	int			error = 0;
>  
>  	/*
>  	 * Try to add the attr to the attribute list in the inode.
>  	 */
>  	error = xfs_attr_try_sf_addname(dp, args);
> +
> +	/* Should only be 0, -EEXIST or ENOSPC */
>  	if (error != -ENOSPC) {
> -		error2 = xfs_trans_commit(args->trans);
> -		args->trans = NULL;
> -		return error ? error : error2;
> +		return error;
>  	}
>  	/*
>  	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> @@ -258,18 +262,10 @@ xfs_attr_set_shortform(
>  	/*
>  	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>  	 * push cannot grab the half-baked leaf buffer and run into problems
> -	 * with the write verifier. Once we're done rolling the transaction we
> -	 * can release the hold and add the attr to the leaf.
> +	 * with the write verifier.
>  	 */
>  	xfs_trans_bhold(args->trans, *leaf_bp);
> -	error = xfs_defer_finish(&args->trans);
> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> -	if (error) {
> -		xfs_trans_brelse(args->trans, *leaf_bp);
> -		return error;
> -	}
> -
> -	return 0;
> +	return -EAGAIN;
>  }
>  
>  /*
> @@ -279,9 +275,83 @@ int
>  xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf          *leaf_bp = NULL;
> -	int			error = 0;
> +	struct xfs_buf			*leaf_bp = NULL;
> +	int				error = 0;
> +	struct xfs_delattr_context	dac;
> +
> +	xfs_delattr_context_init(&dac, args);
> +
> +	do {
> +		error = xfs_attr_set_iter(&dac, &leaf_bp);
> +		if (error != -EAGAIN)
> +			break;
> +
> +		if (dac.flags & XFS_DAC_DEFER_FINISH) {
> +			dac.flags &= ~XFS_DAC_DEFER_FINISH;
> +			error = xfs_defer_finish(&args->trans);
> +			if (error)
> +				break;
> +		}
> +
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			break;
> +
> +		if (leaf_bp) {
> +			xfs_trans_bjoin(args->trans, leaf_bp);
> +			xfs_trans_bhold(args->trans, leaf_bp);
> +		}
> +
> +	} while (true);
> +
> +	return error;
> +}
> +
> +/*
> + * Set the attribute specified in @args.
> + * This routine is meant to function as a delayed operation, and may return
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
> + */
> +int
> +xfs_attr_set_iter(
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_buf			**leaf_bp)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
> +	int				sf_size;
> +
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_ADD_LEAF:
> +		goto das_add_leaf;
> +	case XFS_DAS_ALLOC_LEAF:
> +	case XFS_DAS_FLIP_LFLAG:
> +	case XFS_DAS_FOUND_LBLK:
> +		goto das_leaf;
> +	case XFS_DAS_FOUND_NBLK:
> +	case XFS_DAS_FLIP_NFLAG:
> +	case XFS_DAS_ALLOC_NODE:
> +	case XFS_DAS_LEAF_TO_NODE:
> +		goto das_node;
> +	default:
> +		break;
> +	}
> +
> +	/*
> +	 * New inodes may not have an attribute fork yet. So set the attribute
> +	 * fork appropriately
> +	 */
> +	if (XFS_IFORK_Q((args->dp)) == 0) {
> +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
> +	}
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -292,40 +362,53 @@ xfs_attr_set_args(
>  	if (xfs_attr_is_shortform(dp)) {
>  
>  		/*
> -		 * If the attr was successfully set in shortform, the
> -		 * transaction is committed and set to NULL.  Otherwise, is it
> -		 * converted from shortform to leaf, and the transaction is
> -		 * retained.
> +		 * If the attr was successfully set in shortform, no need to
> +		 * continue.  Otherwise, is it converted from shortform to leaf
> +		 * and -EAGAIN is returned.
>  		 */
> -		error = xfs_attr_set_shortform(args, &leaf_bp);
> -		if (error || !args->trans)
> -			return error;
> +		error = xfs_attr_set_shortform(args, leaf_bp);
> +		if (error == -EAGAIN) {
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			dac->dela_state = XFS_DAS_ADD_LEAF;
> +		}
> +		return error;
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_addname(args);
> -		if (error != -ENOSPC)
> -			return error;
> +das_add_leaf:
>  
> -		/*
> -		 * Commit that transaction so that the node_addname()
> -		 * call can manage its own transactions.
> -		 */
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +	/*
> +	 * After a shortform to leaf conversion, we need to hold the leaf and
> +	 * cylce out the transaction.  When we get back, we need to release
> +	 * the leaf.
> +	 */
> +	if (*leaf_bp != NULL) {
> +		xfs_trans_brelse(args->trans, *leaf_bp);
> +		*leaf_bp = NULL;
> +	}
>  
> -		/*
> -		 * Commit the current trans (including the inode) and
> -		 * start a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		error = xfs_attr_leaf_try_add(args, *leaf_bp);
> +		switch (error) {
> +		case -ENOSPC:
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			dac->dela_state = XFS_DAS_LEAF_TO_NODE;
> +			return -EAGAIN;
> +		case 0:
> +			dac->dela_state = XFS_DAS_FOUND_LBLK;
> +			return -EAGAIN;
> +		default:
>  			return error;
> -
> +		}
> +das_leaf:
> +		error = xfs_attr_leaf_addname(dac);
> +		if (error == -ENOSPC) {
> +			dac->dela_state = XFS_DAS_LEAF_TO_NODE;
> +			return -EAGAIN;
> +		}
> +		return error;
>  	}
> -
> -	error = xfs_attr_node_addname(args);
> +das_node:
> +	error = xfs_attr_node_addname(dac);
>  	return error;
>  }
>  
> @@ -716,28 +799,32 @@ xfs_attr_leaf_try_add(
>   *
>   * This leaf block cannot have a "remote" value, we only call this routine
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
> + *
> + * This routine is meant to function as a delayed operation, and may return
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
>   */
>  STATIC int
>  xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error, forkoff;
> -	struct xfs_buf		*bp = NULL;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> -
> -	error = xfs_attr_leaf_try_add(args, bp);
> -	if (error)
> -		return error;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_buf			*bp = NULL;
> +	int				error, forkoff;
> +	struct xfs_inode		*dp = args->dp;
>  
> -	/*
> -	 * Commit the transaction that added the attr name so that
> -	 * later routines can manage their own transactions.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		return error;
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_FLIP_LFLAG:
> +		goto das_flip_flag;
> +	case XFS_DAS_ALLOC_LEAF:
> +		goto das_alloc_leaf;
> +	case XFS_DAS_RM_LBLK:
> +		goto das_rm_lblk;
> +	default:
> +		break;
> +	}
>  
>  	/*
>  	 * If there was an out-of-line value, allocate the blocks we
> @@ -746,7 +833,28 @@ xfs_attr_leaf_addname(
>  	 * maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
> +
> +		/* Open coded xfs_attr_rmtval_set without trans handling */
> +		error = xfs_attr_rmtval_set_init(dac);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Roll through the "value", allocating blocks on disk as
> +		 * required.
> +		 */
> +das_alloc_leaf:
> +		while (dac->blkcnt > 0) {
> +			error = xfs_attr_rmtval_set_blk(dac);
> +			if (error)
> +				return error;
> +
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			dac->dela_state = XFS_DAS_ALLOC_LEAF;
> +			return -EAGAIN;
> +		}
> +
> +		error = xfs_attr_rmtval_set_value(args);
>  		if (error)
>  			return error;
>  	}
> @@ -765,22 +873,25 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_flipflags(args);
>  		if (error)
>  			return error;
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			return error;
> -
> +		dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +		return -EAGAIN;
> +das_flip_flag:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
>  		 * a "remote" value (if it exists).
>  		 */
>  		xfs_attr_restore_rmt_blk(args);
>  
> +		xfs_attr_rmtval_invalidate(args);
> +das_rm_lblk:
>  		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_remove(args);
> +			error = __xfs_attr_rmtval_remove(args);
> +
> +			if (error == -EAGAIN) {
> +				dac->dela_state = XFS_DAS_RM_LBLK;

Similar to what I had observed in the patch "Add delay ready attr remove
routines",

Shouldn't XFS_DAC_DEFER_FINISH be set in dac->flags?
__xfs_attr_rmtval_remove() calls __xfs_bunmapi() which would
have added items to the deferred list.

-- 
chandan



