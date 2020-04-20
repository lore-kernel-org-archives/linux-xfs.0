Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D069BC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 09:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD8012145D
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 09:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgDTJDS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 05:03:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbgDTJDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 05:03:18 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K924Ke018079
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 05:03:16 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gj229tmt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 05:03:16 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 20 Apr 2020 10:02:23 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Apr 2020 10:02:20 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03K939KT57868536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 09:03:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76A6A11C052;
        Mon, 20 Apr 2020 09:03:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8876211C04C;
        Mon, 20 Apr 2020 09:03:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.68.184])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 09:03:08 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 18/20] xfs: Add delay ready attr remove routines
Date:   Mon, 20 Apr 2020 14:36:13 +0530
Organization: IBM
In-Reply-To: <20200403221229.4995-19-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com> <20200403221229.4995-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-TM-AS-GCONF: 00
x-cbid: 20042009-0020-0000-0000-000003CB1CF6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042009-0021-0000-0000-000022240F41
Message-Id: <1751112.6zseaXoMQ2@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_03:2020-04-17,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 mlxscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200076
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday, April 4, 2020 3:42 AM Allison Collins wrote: 
> This patch modifies the attr remove routines to be delay ready. This
> means they no longer roll or commit transactions, but instead return
> -EAGAIN to have the calling routine roll and refresh the transaction. In
> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
> uses a sort of state machine like switch to keep track of where it was
> when EAGAIN was returned. xfs_attr_node_removename has also been
> modified to use the switch, and a new version of xfs_attr_remove_args
> consists of a simple loop to refresh the transaction until the operation
> is completed.
> 
> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> counter parts: xfs_attr_rmtval_invalidate (appearing in the setup
> helper) and then __xfs_attr_rmtval_remove. We will rename
> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> done.
> 
> This patch also adds a new struct xfs_delattr_context, which we will use
> to keep track of the current state of an attribute operation. The new
> xfs_delattr_state enum is used to track various operations that are in
> progress so that we know not to repeat them, and resume where we left
> off before EAGAIN was returned to cycle out the transaction. Other
> members take the place of local variables that need to retain their
> values across multiple function recalls.
> 
> Below is a state machine diagram for attr remove operations. The
> XFS_DAS_* states indicate places where the function would return
> -EAGAIN, and then immediately resume from after being recalled by the
> calling function.  States marked as a "subroutine state" indicate that
> they belong to a subroutine, and so the calling function needs to pass
> them back to that subroutine to allow it to finish where it left off.
> But they otherwise do not have a role in the calling function other than
> just passing through.
> 
>  xfs_attr_remove_iter()
>          XFS_DAS_RM_SHRINK     ─┐
>          (subroutine state)     │
>                                 │
>          XFS_DAS_RMTVAL_REMOVE ─┤
>          (subroutine state)     │
>                                 └─>xfs_attr_node_removename()
>                                                  │
>                                                  v
>                                          need to remove
>                                    ┌─n──  rmt blocks?
>                                    │             │
>                                    │             y
>                                    │             │
>                                    │             v
>                                    │  ┌─>XFS_DAS_RMTVAL_REMOVE
>                                    │  │          │
>                                    │  │          v
>                                    │  └──y── more blks
>                                    │         to remove?
>                                    │             │
>                                    │             n
>                                    │             │
>                                    │             v
>                                    │         need to
>                                    └─────> shrink tree? ─n─┐
>                                                  │         │
>                                                  y         │
>                                                  │         │
>                                                  v         │
>                                          XFS_DAS_RM_SHRINK │
>                                                  │         │
>                                                  v         │
>                                                 done <─────┘
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 168 ++++++++++++++++++++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_attr.h |  38 +++++++++++
>  2 files changed, 168 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d735570..f700976 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -45,7 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_removename(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  
>  /*
> @@ -53,12 +53,21 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  
> +STATIC void
> +xfs_delattr_context_init(
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_da_args		*args)
> +{
> +	memset(dac, 0, sizeof(struct xfs_delattr_context));
> +	dac->da_args = args;
> +}
> +
>  int
>  xfs_inode_hasattr(
>  	struct xfs_inode	*ip)
> @@ -356,20 +365,66 @@ xfs_has_attr(
>   */
>  int
>  xfs_attr_remove_args(
> -	struct xfs_da_args      *args)
> +	struct xfs_da_args	*args)
>  {
> +	int			error = 0;
> +	struct			xfs_delattr_context dac;
> +
> +	xfs_delattr_context_init(&dac, args);
> +
> +	do {
> +		error = xfs_attr_remove_iter(&dac);
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
> +	} while (true);
> +
> +	return error;
> +}
> +
> +/*
> + * Remove the attribute specified in @args.
> + *
> + * This function may return -EAGAIN to signal that the transaction needs to be
> + * rolled.  Callers should continue calling this function until they receive a
> + * return value other than -EAGAIN.
> + */
> +int
> +xfs_attr_remove_iter(
> +	struct xfs_delattr_context *dac)
> +{
> +	struct xfs_da_args	*args = dac->da_args;
>  	struct xfs_inode	*dp = args->dp;
>  	int			error;
>  
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_RM_SHRINK:
> +	case XFS_DAS_RMTVAL_REMOVE:
> +		return xfs_attr_node_removename(dac);
> +	default:
> +		break;
> +	}
> +
>  	if (!xfs_inode_hasattr(dp)) {
>  		error = -ENOATTR;
>  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>  		error = xfs_attr_shortform_remove(args);
>  	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_removename(args);
> +		error = xfs_attr_leaf_removename(dac);
>  	} else {
> -		error = xfs_attr_node_removename(args);
> +		error = xfs_attr_node_removename(dac);
>  	}
>  
>  	return error;
> @@ -794,11 +849,12 @@ xfs_attr_leaf_hasname(
>   */
>  STATIC int
>  xfs_attr_leaf_removename(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_inode	*dp;
> -	struct xfs_buf		*bp;
> -	int			error, forkoff;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_inode		*dp;
> +	struct xfs_buf			*bp;
> +	int				error, forkoff;
>  
>  	trace_xfs_attr_leaf_removename(args);
>  
> @@ -825,9 +881,8 @@ xfs_attr_leaf_removename(
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +
> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>  	}
>  	return 0;
>  }
> @@ -1128,12 +1183,13 @@ xfs_attr_node_addname(
>   */
>  STATIC int
>  xfs_attr_node_shrink(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state     *state)
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_da_state		*state)
>  {
> -	struct xfs_inode	*dp = args->dp;
> -	int			error, forkoff;
> -	struct xfs_buf		*bp;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error, forkoff;
> +	struct xfs_buf			*bp;
>  
>  	/*
>  	 * Have to get rid of the copy of this dabuf in the state.
> @@ -1153,9 +1209,7 @@ xfs_attr_node_shrink(
>  		if (error)
>  			return error;
>  
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>  	} else
>  		xfs_trans_brelse(args->trans, bp);
>  
> @@ -1194,13 +1248,15 @@ xfs_attr_leaf_mark_incomplete(
>  
>  /*
>   * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
> - * the blocks are valid.  Any remote blocks will be marked incomplete.
> + * the blocks are valid.  Any remote blocks will be marked incomplete and
> + * invalidated.
>   */
>  STATIC
>  int xfs_attr_node_removename_setup(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	**state)
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_da_state		**state)
>  {
> +	struct xfs_da_args	*args = dac->da_args;
>  	int			error;
>  	struct xfs_da_state_blk	*blk;
>  
> @@ -1212,10 +1268,21 @@ int xfs_attr_node_removename_setup(
>  	ASSERT(blk->bp != NULL);
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  
> +	/*
> +	 * Store blk and state in the context incase we need to cycle out the
> +	 * transaction
> +	 */
> +	dac->blk = blk;
> +	dac->da_state = *state;
> +
>  	if (args->rmtblkno > 0) {
>  		error = xfs_attr_leaf_mark_incomplete(args, *state);
>  		if (error)
>  			return error;
> +
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
>  	}
>  
>  	return 0;
> @@ -1228,7 +1295,10 @@ xfs_attr_node_removename_rmt (
>  {
>  	int			error = 0;
>  
> -	error = xfs_attr_rmtval_remove(args);
> +	/*
> +	 * May return -EAGAIN to request that the caller recall this function
> +	 */
> +	error = __xfs_attr_rmtval_remove(args);
>  	if (error)
>  		return error;
>  
> @@ -1249,19 +1319,37 @@ xfs_attr_node_removename_rmt (
>   * This will involve walking down the Btree, and may involve joining
>   * leaf nodes and even joining intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as either an inline or delayed operation,
> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> + * functions will need to handle this, and recall the function until a
> + * successful error code is returned.
>   */
>  STATIC int
>  xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> +	struct xfs_da_args	*args = dac->da_args;
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
>  	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> +	state = dac->da_state;
> +	blk = dac->blk;
> +
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_RMTVAL_REMOVE:
> +		goto das_rmtval_remove;
> +	case XFS_DAS_RM_SHRINK:
> +		goto das_rm_shrink;
> +	default:
> +		break;
> +	}
>  
> -	error = xfs_attr_node_removename_setup(args, &state);
> +	error = xfs_attr_node_removename_setup(dac, &state);
>  	if (error)
>  		goto out;
>  
> @@ -1270,10 +1358,16 @@ xfs_attr_node_removename(
>  	 * This is done before we remove the attribute so that we don't
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
> +
> +das_rmtval_remove:
> +
>  	if (args->rmtblkno > 0) {
>  		error = xfs_attr_node_removename_rmt(args, state);
> -		if (error)
> -			goto out;
> +		if (error) {
> +			if (error == -EAGAIN)
> +				dac->dela_state = XFS_DAS_RMTVAL_REMOVE;

Shouldn't XFS_DAC_DEFER_FINISH be set in dac->flags?
xfs_attr_node_removename_rmt() indirectly calls __xfs_bunmapi() which would
have added items to the deferred list.

-- 
chandan



