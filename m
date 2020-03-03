Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80472C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 13:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4041F20717
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 13:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgCCNir convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 08:38:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbgCCNir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 08:38:47 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023DaKtA145136
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 08:38:45 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfnbg25gf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 08:38:45 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Tue, 3 Mar 2020 13:38:42 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Mar 2020 13:38:39 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 023DcdRV40436066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Mar 2020 13:38:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC02EAE058;
        Tue,  3 Mar 2020 13:38:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF08DAE045;
        Tue,  3 Mar 2020 13:38:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.54.141])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Mar 2020 13:38:37 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 14/19] xfs: Add delay ready attr set routines
Date:   Tue, 03 Mar 2020 19:11:33 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-15-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-TM-AS-GCONF: 00
x-cbid: 20030313-0028-0000-0000-000003E07CCA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030313-0029-0000-0000-000024A5A940
Message-Id: <6212160.4XXo0ysdIk@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_04:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030104
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote: 
> This patch modifies the attr set routines to be delay ready. This means they no
> longer roll or commit transactions, but instead return -EAGAIN to have the calling
> routine roll and refresh the transaction.  In this series, xfs_attr_set_args has
> become xfs_attr_set_iter, which uses a state machine like switch to keep track of
> where it was when EAGAIN was returned.
> 
> Part of xfs_attr_leaf_addname has been factored out into a new helper function
> xfs_attr_leaf_try_add to allow transaction cycling between the two routines.
> 
> Two new helper functions have been added: xfs_attr_rmtval_set_init and
> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> xfs_attr_rmtval_set, but they store the current block in the delay attr
> context to allow the caller to roll the transaction between allocations. This helps
> to simplify and consolidate code used by xfs_attr_leaf_addname and
> xfs_attr_node_addname. Finally, xfs_attr_set_args has become a simple loop to
> refresh the transaction until the operation is completed.
> 
> Below is a state machine diagram for attr set operations. The XFS_DAS_* states
> indicate places where the function would return -EAGAIN, and then immediately
> resume from after being recalled by the calling function.  States marked as a
> "subroutine state" indicate that they belong to a subroutine, and so the calling
> function needs to pass them back to that subroutine to allow it to finish where it
> left off.  But they otherwise do not have a role in the calling function other
> than just passing through.
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
>   │                                   ┌─>XFS_DAS_FLIP_LFLAG │
>   │                                   │          │          │
>   │                                   │          v          │
>   │                                   │        remove       │
>   │                                   │       old name      │
>   │                                   │          │          │
>   │                                   │          v          │
>   │                                   └────y── more to      │
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
>                                       ┌─>XFS_DAS_FLIP_NFLAG │
>                                       │          │          │
>                                       │          v          │
>                                       │        remove       │
>                                       │       old name      │
>                                       │          │          │
>                                       │          v          │
>                                       └────y── more to      │
>                                                remove       │
>                                                  │          │
>                                                  n          │
>                                                  │          │
>                                                  v          │
>                                                 done <──────┘
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 368 ++++++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr.h        |   1 +
>  fs/xfs/libxfs/xfs_attr_remote.c |  67 +++++++-
>  fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>  fs/xfs/libxfs/xfs_da_btree.h    |  13 ++
>  5 files changed, 319 insertions(+), 134 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index cd3a3f7..4b788f2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -58,6 +58,7 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>  
>  
>  STATIC int
> @@ -259,9 +260,86 @@ int
>  xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
> +	int			error = 0;
> +	int			err2 = 0;
> +	struct xfs_buf		*leaf_bp = NULL;
> +
> +	do {
> +		error = xfs_attr_set_iter(args, &leaf_bp);
> +		if (error && error != -EAGAIN)
> +			goto out;
> +
> +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
> +			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
> +
> +			err2 = xfs_defer_finish(&args->trans);
> +			if (err2) {
> +				error = err2;
> +				goto out;
> +			}
> +		}
> +
> +		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (err2) {
> +			error = err2;
> +			goto out;
> +		}
> +
> +		if (leaf_bp) {
> +			xfs_trans_bjoin(args->trans, leaf_bp);
> +			xfs_trans_bhold(args->trans, leaf_bp);
> +		}
> +
> +	} while (error == -EAGAIN);
> +
> +out:
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
> +	struct xfs_da_args	*args,
> +	struct xfs_buf          **leaf_bp)
> +{
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf          *leaf_bp = NULL;
> -	int			error, error2 = 0;
> +	int			error = 0;
> +	int			sf_size;
> +
> +	/* State machine switch */
> +	switch (args->dac.dela_state) {
> +	case XFS_DAS_ADD_LEAF:
> +		goto add_leaf;
> +	case XFS_DAS_ALLOC_LEAF:
> +	case XFS_DAS_FLIP_LFLAG:
> +	case XFS_DAS_FOUND_LBLK:
> +		goto leaf;
> +	case XFS_DAS_FOUND_NBLK:
> +	case XFS_DAS_FLIP_NFLAG:
> +	case XFS_DAS_ALLOC_NODE:
> +	case XFS_DAS_LEAF_TO_NODE:
> +		goto node;
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
> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
> +	}
>  
>  	/*
>  	 * If the attribute list is non-existent or a shortform list,
> @@ -275,17 +353,16 @@ xfs_attr_set_args(
>  		 * Try to add the attr to the attribute list in the inode.
>  		 */
>  		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC) {
> -			error2 = xfs_trans_commit(args->trans);
> -			args->trans = NULL;
> -			return error ? error : error2;
> -		}
> +
> +		/* Should only be 0, -EEXIST or ENOSPC */
> +		if (error != -ENOSPC)
> +			return error;
>  
>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
>  		 * GROT: another possible req'mt for a double-split btree op.
>  		 */
> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>  		if (error)
>  			return error;
>  
> @@ -293,41 +370,48 @@ xfs_attr_set_args(
>  		 * Prevent the leaf buffer from being unlocked so that a
>  		 * concurrent AIL push cannot grab the half-baked leaf
>  		 * buffer and run into problems with the write verifier.
> -		 * Once we're done rolling the transaction we can release
> -		 * the hold and add the attr to the leaf.
>  		 */
> -		xfs_trans_bhold(args->trans, leaf_bp);
> -		error = xfs_defer_finish(&args->trans);
> -		xfs_trans_bhold_release(args->trans, leaf_bp);
> -		if (error) {
> -			xfs_trans_brelse(args->trans, leaf_bp);
> -			return error;
> -		}
> +		xfs_trans_bhold(args->trans, *leaf_bp);
> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
> +		args->dac.dela_state = XFS_DAS_ADD_LEAF;
> +		return -EAGAIN;
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_addname(args);
> -		if (error != -ENOSPC)
> -			return error;
> +add_leaf:
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
> +			args->dac.flags |= XFS_DAC_FINISH_TRANS;
> +			args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
> +			return -EAGAIN;
> +		case 0:
> +			args->dac.dela_state = XFS_DAS_FOUND_LBLK;
> +			return -EAGAIN;
> +		default:
>  			return error;
> -
> +		}
> +leaf:
> +		error = xfs_attr_leaf_addname(args);
> +		if (error == -ENOSPC) {
> +			args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
> +			return -EAGAIN;
> +		}
> +		return error;
>  	}
> -
> +	args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
> +node:
>  	error = xfs_attr_node_addname(args);
>  	return error;
>  }
> @@ -766,28 +850,29 @@ xfs_attr_leaf_try_add(
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
>  	struct xfs_da_args	*args)
>  {
> -	int			error, forkoff;
>  	struct xfs_buf		*bp = NULL;
> +	int			error, forkoff;
>  	struct xfs_inode	*dp = args->dp;
>  
> -	trace_xfs_attr_leaf_addname(args);
> -
> -	error = xfs_attr_leaf_try_add(args, bp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Commit the transaction that added the attr name so that
> -	 * later routines can manage their own transactions.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		return error;
> +	/* State machine switch */
> +	switch (args->dac.dela_state) {
> +	case XFS_DAS_FLIP_LFLAG:
> +		goto flip_flag;
> +	case XFS_DAS_ALLOC_LEAF:
> +		goto alloc_leaf;
> +	default:
> +		break;
> +	}
>  
>  	/*
>  	 * If there was an out-of-line value, allocate the blocks we
> @@ -796,7 +881,28 @@ xfs_attr_leaf_addname(
>  	 * maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
> +
> +		/* Open coded xfs_attr_rmtval_set without trans handling */
> +		error = xfs_attr_rmtval_set_init(args);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Roll through the "value", allocating blocks on disk as
> +		 * required.
> +		 */
> +alloc_leaf:
> +		while (args->dac.blkcnt > 0) {
> +			error = xfs_attr_rmtval_set_blk(args);
> +			if (error)
> +				return error;
> +
> +			args->dac.flags |= XFS_DAC_FINISH_TRANS;
> +			args->dac.dela_state = XFS_DAS_ALLOC_LEAF;
> +			return -EAGAIN;
> +		}
> +
> +		error = xfs_attr_rmtval_set_value(args);
>  		if (error)
>  			return error;
>  	}
> @@ -815,13 +921,6 @@ xfs_attr_leaf_addname(
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
>  
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> @@ -832,8 +931,17 @@ xfs_attr_leaf_addname(
>  		args->rmtblkno = args->rmtblkno2;
>  		args->rmtblkcnt = args->rmtblkcnt2;
>  		args->rmtvaluelen = args->rmtvaluelen2;
> +
> +		args->dac.dela_state = XFS_DAS_FLIP_LFLAG;
> +		return -EAGAIN;
> +flip_flag:
>  		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_remove(args);
> +			error = xfs_attr_rmtval_unmap(args);
> +
> +			/*
> +			 * if (error == -EAGAIN), we will repeat this until
> +			 * args->rmtblkno is zero
> +			 */
>  			if (error)
>  				return error;
>  		}
Hi Allison,

In the case where args->rmtblkno is non-zero, xfs_attr_rmtval_unmap() invokes
xfs_bunmapi() for unmapping the file block range starting at
args->rmtblkno. If xfs_bunmapi() frees a subset of the range of blocks, it
returns with 'done' set to 0 and in turn xfs_attr_rmtval_unmap() returns with
-EAGAIN error. This will cause xfs_attr_leaf_addname() to return -EAGAIN to
its caller i.e. xfs_attr_set_iter(). In turn xfs_attr_set_iter() returns back
to xfs_attr_set_args(). Here the loop is executed once again and hence
xfs_attr_set_iter() is invoked with args->dac.dela_state set to
XFS_DAS_FLIP_LFLAG. Hence xfs_attr_leaf_addname() is invoked once again with
args->dac.dela_state set to XFS_DAS_FLIP_LFLAG. Here xfs_attr_rmtval_unmap()
is invoked once again with an unmodified args->rmtblkno.

-- 
chandan



