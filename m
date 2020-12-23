Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B285C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 16:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A19222BB
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 16:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLWQcI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 11:32:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40070 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgLWQcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Dec 2020 11:32:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BNGUNaQ187309;
        Wed, 23 Dec 2020 16:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eK9hTwOh3qtns8LPtP8vUyjtoiwjnMZcsWLGHAYiU8E=;
 b=GBdK2vNaBSG7+vJyWy19PePLKWtJaDwlRfsQV8012ZIPTBX7ze4rqj9Uoef6j0f8VyWu
 CyWp0ZUvO/afK1QRQ9JjF+InIKLqZWmIwYGZdY2JtXgJBENHOJ+8ESeX5pHu1qheWRBF
 mOCwZ8elVvhyw1tQ0z5kOtxmz3JbaM3nzb182XmVUTU0R9mIgB2jcKHGolxRy/ZlncCr
 etHwI+kLDcojhL3nty119sYW2k6mkwS5TRc9Q6CkLXBh3VDEN27s3oXruKazaGUtZOLz
 CT5cDZBBBkQH07eKx2w/0JpB8Od8CqQbuEXS8L50kL0+YcmQ9iqjkQJIWmfKvQD2jvRi 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35k0d18k33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Dec 2020 16:31:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BNGPjoU005363;
        Wed, 23 Dec 2020 16:31:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35k0ea1jty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 16:31:18 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BNGVGPt023348;
        Wed, 23 Dec 2020 16:31:16 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Dec 2020 08:31:16 -0800
Subject: Re: [PATCH v14 05/15] xfs: Add delay ready attr set routines
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-6-allison.henderson@oracle.com>
 <14114612.x9Zgue1qBj@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <3334d0ae-43da-32ee-f445-f987dd067ddc@oracle.com>
Date:   Wed, 23 Dec 2020 09:31:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <14114612.x9Zgue1qBj@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9844 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012230120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9844 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012230121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/23/20 1:00 AM, Chandan Babu R wrote:
> On Fri, 18 Dec 2020 00:29:07 -0700, Allison Henderson wrote:
>> This patch modifies the attr set routines to be delay ready. This means
>> they no longer roll or commit transactions, but instead return -EAGAIN
>> to have the calling routine roll and refresh the transaction.  In this
>> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
>> state machine like switch to keep track of where it was when EAGAIN was
>> returned. See xfs_attr.h for a more detailed diagram of the states.
>>
>> Two new helper functions have been added: xfs_attr_rmtval_set_init and
> 
> I don't see xfs_attr_rmtval_set_init() being added in this patch. Maybe it
> needs to be removed from the description.

Yeah, I think we dropped it a couple revisions ago.  Will remove.
> 
>> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
>> xfs_attr_rmtval_set, but they store the current block in the delay attr
>> context to allow the caller to roll the transaction between allocations.
>> This helps to simplify and consolidate code used by
>> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
>> now become a simple loop to refresh the transaction until the operation
>> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
>> removed.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 357 ++++++++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_attr.h        | 235 +++++++++++++++++++++++++-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  98 +++++++----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   5 +-
>>   fs/xfs/xfs_trace.h              |   1 -
>>   5 files changed, 541 insertions(+), 155 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index b6330f9..cd72512 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>    * Internal routines when attribute list is one block.
>>    */
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>   
>> @@ -52,12 +52,15 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    * Internal routines when attribute list is more than one block.
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
>>   STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>> +STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> +			     struct xfs_buf **leaf_bp);
>>   
>>   int
>>   xfs_inode_hasattr(
>> @@ -218,8 +221,11 @@ xfs_attr_is_shortform(
>>   
>>   /*
>>    * Attempts to set an attr in shortform, or converts short form to leaf form if
>> - * there is not enough room.  If the attr is set, the transaction is committed
>> - * and set to NULL.
>> + * there is not enough room.  This function is meant to operate as a helper
>> + * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
>> + * that the calling function should roll the transaction, and then proceed to
>> + * add the attr in leaf form.  This subroutine does not expect to be recalled
>> + * again like the other delayed attr routines do.
>>    */
>>   STATIC int
>>   xfs_attr_set_shortform(
>> @@ -227,16 +233,16 @@ xfs_attr_set_shortform(
>>   	struct xfs_buf		**leaf_bp)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	int			error, error2 = 0;
>> +	int			error = 0;
>>   
>>   	/*
>>   	 * Try to add the attr to the attribute list in the inode.
>>   	 */
>>   	error = xfs_attr_try_sf_addname(dp, args);
>> +
>> +	/* Should only be 0, -EEXIST or -ENOSPC */
>>   	if (error != -ENOSPC) {
>> -		error2 = xfs_trans_commit(args->trans);
>> -		args->trans = NULL;
>> -		return error ? error : error2;
>> +		return error;
>>   	}
>>   	/*
>>   	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>> @@ -249,18 +255,15 @@ xfs_attr_set_shortform(
>>   	/*
>>   	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>>   	 * push cannot grab the half-baked leaf buffer and run into problems
>> -	 * with the write verifier. Once we're done rolling the transaction we
>> -	 * can release the hold and add the attr to the leaf.
>> +	 * with the write verifier.
>>   	 */
>>   	xfs_trans_bhold(args->trans, *leaf_bp);
>> -	error = xfs_defer_finish(&args->trans);
>> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
>> -	if (error) {
>> -		xfs_trans_brelse(args->trans, *leaf_bp);
>> -		return error;
>> -	}
>>   
>> -	return 0;
>> +	/*
>> +	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
>> +	 * fork to leaf format and will restart with the leaf add.
>> +	 */
>> +	return -EAGAIN;
>>   }
>>   
>>   /*
>> @@ -268,7 +271,7 @@ xfs_attr_set_shortform(
>>    * also checks for a defer finish.  Transaction is finished and rolled as
>>    * needed, and returns true of false if the delayed operation should continue.
>>    */
>> -int
>> +STATIC int
>>   xfs_attr_trans_roll(
>>   	struct xfs_delattr_context	*dac)
>>   {
>> @@ -298,34 +301,95 @@ int
>>   xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>> -	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error = 0;
>> +	struct xfs_buf			*leaf_bp = NULL;
>> +	int				error = 0;
>> +	struct xfs_delattr_context	dac = {
>> +		.da_args	= args,
>> +	};
>> +
>> +	do {
>> +		error = xfs_attr_set_iter(&dac, &leaf_bp);
>> +		if (error != -EAGAIN)
>> +			break;
>> +
>> +		error = xfs_attr_trans_roll(&dac);
>> +		if (error)
>> +			return error;
>> +	} while (true);
>> +
>> +	return error;
>> +}
>> +
>> +/*
>> + * Set the attribute specified in @args.
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + * returned.
>> + */
>> +STATIC int
>> +xfs_attr_set_iter(
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_buf			**leaf_bp)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_inode		*dp = args->dp;
>> +	int				error = 0;
>> +
>> +	/* State machine switch */
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_FLIP_LFLAG:
>> +	case XFS_DAS_FOUND_LBLK:
>> +	case XFS_DAS_RM_LBLK:
>> +		return xfs_attr_leaf_addname(dac);
>> +	case XFS_DAS_FOUND_NBLK:
>> +	case XFS_DAS_FLIP_NFLAG:
>> +	case XFS_DAS_ALLOC_NODE:
>> +		return xfs_attr_node_addname(dac);
>> +	case XFS_DAS_UNINIT:
>> +		break;
>> +	default:
>> +		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
>> +		break;
>> +	}
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>>   	 * leaf handling.  Otherwise, try to add the attribute to the shortform
>>   	 * list; if there's no room then convert the list to leaf format and try
>> -	 * again.
>> +	 * again. No need to set state as we will be in leaf form when we come
>> +	 * back
>>   	 */
>>   	if (xfs_attr_is_shortform(dp)) {
>>   
>>   		/*
>> -		 * If the attr was successfully set in shortform, the
>> -		 * transaction is committed and set to NULL.  Otherwise, is it
>> -		 * converted from shortform to leaf, and the transaction is
>> -		 * retained.
>> +		 * If the attr was successfully set in shortform, no need to
>> +		 * continue.  Otherwise, is it converted from shortform to leaf
>> +		 * and -EAGAIN is returned.
>>   		 */
>> -		error = xfs_attr_set_shortform(args, &leaf_bp);
>> -		if (error || !args->trans)
>> -			return error;
>> +		error = xfs_attr_set_shortform(args, leaf_bp);
>> +		if (error == -EAGAIN)
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +
>> +		return error;
>>   	}
>>   
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_addname(args);
>> -		if (error != -ENOSPC)
>> -			return error;
>> +	/*
>> +	 * After a shortform to leaf conversion, we need to hold the leaf and
>> +	 * cycle out the transaction.  When we get back, we need to release
>> +	 * the leaf to release the hold on the leaf buffer.
>> +	 */
>> +	if (*leaf_bp != NULL) {
>> +		xfs_trans_bhold_release(args->trans, *leaf_bp);
>> +		*leaf_bp = NULL;
>> +	}
>> +
>> +	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		return xfs_attr_node_addname(dac);
>>   
>> +	error = xfs_attr_leaf_try_add(args, *leaf_bp);
>> +	switch (error) {
>> +	case -ENOSPC:
>>   		/*
>>   		 * Promote the attribute list to the Btree format.
>>   		 */
>> @@ -334,25 +398,22 @@ xfs_attr_set_args(
>>   			return error;
>>   
>>   		/*
>> -		 * Finish any deferred work items and roll the transaction once
>> -		 * more.  The goal here is to call node_addname with the inode
>> -		 * and transaction in the same state (inode locked and joined,
>> -		 * transaction clean) no matter how we got to this step.
>> -		 */
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> -
>> -		/*
>> -		 * Commit the current trans (including the inode) and
>> -		 * start a new one.
>> +		 * Finish any deferred work items and roll the
>> +		 * transaction once more.  The goal here is to call
>> +		 * node_addname with the inode and transaction in the
>> +		 * same state (inode locked and joined, transaction
>> +		 * clean) no matter how we got to this step.
>> +		 *
>> +		 * At this point, we are still in XFS_DAS_UNINIT, but
>> +		 * when we come back, we'll be a node, so we'll fall
>> +		 * down into the node handling code below
> 
>   ... node handling code above?.
It used to be a goto that jumped below.  Will update

> 
> Apart from the above nits I don't see any issues w.r.t the logical correctness
> of the code. Hence,
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, thank you!
Allison

> 
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		return -EAGAIN;
>> +	case 0:
>> +		dac->dela_state = XFS_DAS_FOUND_LBLK;
>> +		return -EAGAIN;
>>   	}
>> -
>> -	error = xfs_attr_node_addname(args);
>>   	return error;
>>   }
>>   
>> @@ -728,28 +789,30 @@ xfs_attr_leaf_try_add(
>>    *
>>    * This leaf block cannot have a "remote" value, we only call this routine
>>    * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + *
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + * returned.
>>    */
>>   STATIC int
>>   xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error, forkoff;
>> -	struct xfs_buf		*bp = NULL;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> -	trace_xfs_attr_leaf_addname(args);
>> -
>> -	error = xfs_attr_leaf_try_add(args, bp);
>> -	if (error)
>> -		return error;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_buf			*bp = NULL;
>> +	int				error, forkoff;
>> +	struct xfs_inode		*dp = args->dp;
>>   
>> -	/*
>> -	 * Commit the transaction that added the attr name so that
>> -	 * later routines can manage their own transactions.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		return error;
>> +	/* State machine switch */
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_FLIP_LFLAG:
>> +		goto das_flip_flag;
>> +	case XFS_DAS_RM_LBLK:
>> +		goto das_rm_lblk;
>> +	default:
>> +		break;
>> +	}
>>   
>>   	/*
>>   	 * If there was an out-of-line value, allocate the blocks we
>> @@ -757,12 +820,34 @@ xfs_attr_leaf_addname(
>>   	 * after we create the attribute so that we don't overflow the
>>   	 * maximum size of a transaction and/or hit a deadlock.
>>   	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> +
>> +	/* Open coded xfs_attr_rmtval_set without trans handling */
>> +	if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
>> +		dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
>> +		if (args->rmtblkno > 0) {
>> +			error = xfs_attr_rmtval_find_space(dac);
>> +			if (error)
>> +				return error;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Roll through the "value", allocating blocks on disk as
>> +	 * required.
>> +	 */
>> +	if (dac->blkcnt > 0) {
>> +		error = xfs_attr_rmtval_set_blk(dac);
>>   		if (error)
>>   			return error;
>> +
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		return -EAGAIN;
>>   	}
>>   
>> +	error = xfs_attr_rmtval_set_value(args);
>> +	if (error)
>> +		return error;
>> +
>>   	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>>   		/*
>>   		 * Added a "remote" value, just clear the incomplete flag.
>> @@ -782,29 +867,30 @@ xfs_attr_leaf_addname(
>>   	 * In a separate transaction, set the incomplete flag on the "old" attr
>>   	 * and clear the incomplete flag on the "new" attr.
>>   	 */
>> -
>>   	error = xfs_attr3_leaf_flipflags(args);
>>   	if (error)
>>   		return error;
>>   	/*
>>   	 * Commit the flag value change and start the next trans in series.
>>   	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -	if (error)
>> -		return error;
>> -
>> +	dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> +	return -EAGAIN;
>> +das_flip_flag:
>>   	/*
>>   	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>>   	 * (if it exists).
>>   	 */
>>   	xfs_attr_restore_rmt_blk(args);
>>   
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_invalidate(args);
>> -		if (error)
>> -			return error;
>> +	error = xfs_attr_rmtval_invalidate(args);
>> +	if (error)
>> +		return error;
>>   
>> -		error = xfs_attr_rmtval_remove(args);
>> +	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>> +	dac->dela_state = XFS_DAS_RM_LBLK;
>> +das_rm_lblk:
>> +	if (args->rmtblkno) {
>> +		error = __xfs_attr_rmtval_remove(dac);
>>   		if (error)
>>   			return error;
>>   	}
>> @@ -970,23 +1056,38 @@ xfs_attr_node_hasname(
>>    *
>>    * "Remote" attribute values confuse the issue and atomic rename operations
>>    * add a whole extra layer of confusion on top of that.
>> + *
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + *returned.
>>    */
>>   STATIC int
>>   xfs_attr_node_addname(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	struct xfs_da_state	*state;
>> -	struct xfs_da_state_blk	*blk;
>> -	struct xfs_inode	*dp;
>> -	int			retval, error;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = NULL;
>> +	struct xfs_da_state_blk		*blk;
>> +	int				retval = 0;
>> +	int				error = 0;
>>   
>>   	trace_xfs_attr_node_addname(args);
>>   
>> -	/*
>> -	 * Fill in bucket of arguments/results/context to carry around.
>> -	 */
>> -	dp = args->dp;
>> -restart:
>> +	/* State machine switch */
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_FLIP_NFLAG:
>> +		goto das_flip_flag;
>> +	case XFS_DAS_FOUND_NBLK:
>> +		goto das_found_nblk;
>> +	case XFS_DAS_ALLOC_NODE:
>> +		goto das_alloc_node;
>> +	case XFS_DAS_RM_NBLK:
>> +		goto das_rm_nblk;
>> +	default:
>> +		break;
>> +	}
>> +
>>   	/*
>>   	 * Search to see if name already exists, and get back a pointer
>>   	 * to where it should go.
>> @@ -1032,19 +1133,16 @@ xfs_attr_node_addname(
>>   			error = xfs_attr3_leaf_to_node(args);
>>   			if (error)
>>   				goto out;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				goto out;
>>   
>>   			/*
>> -			 * Commit the node conversion and start the next
>> -			 * trans in the chain.
>> +			 * Now that we have converted the leaf to a node, we can
>> +			 * roll the transaction, and try xfs_attr3_leaf_add
>> +			 * again on re-entry.  No need to set dela_state to do
>> +			 * this. dela_state is still unset by this function at
>> +			 * this point.
>>   			 */
>> -			error = xfs_trans_roll_inode(&args->trans, dp);
>> -			if (error)
>> -				goto out;
>> -
>> -			goto restart;
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			return -EAGAIN;
>>   		}
>>   
>>   		/*
>> @@ -1056,9 +1154,7 @@ xfs_attr_node_addname(
>>   		error = xfs_da3_split(state);
>>   		if (error)
>>   			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			goto out;
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	} else {
>>   		/*
>>   		 * Addition succeeded, update Btree hashvals.
>> @@ -1066,6 +1162,11 @@ xfs_attr_node_addname(
>>   		xfs_da3_fixhashpath(state, &state->path);
>>   	}
>>   
>> +	if (!args->rmtblkno && !(args->op_flags & XFS_DA_OP_RENAME)) {
>> +		retval = error;
>> +		goto out;
>> +	}
>> +
>>   	/*
>>   	 * Kill the state structure, we're done with it and need to
>>   	 * allow the buffers to come back later.
>> @@ -1073,13 +1174,9 @@ xfs_attr_node_addname(
>>   	xfs_da_state_free(state);
>>   	state = NULL;
>>   
>> -	/*
>> -	 * Commit the leaf addition or btree split and start the next
>> -	 * trans in the chain.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		goto out;
>> +	dac->dela_state = XFS_DAS_FOUND_NBLK;
>> +	return -EAGAIN;
>> +das_found_nblk:
>>   
>>   	/*
>>   	 * If there was an out-of-line value, allocate the blocks we
>> @@ -1088,7 +1185,27 @@ xfs_attr_node_addname(
>>   	 * maximum size of a transaction and/or hit a deadlock.
>>   	 */
>>   	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> +		/* Open coded xfs_attr_rmtval_set without trans handling */
>> +		error = xfs_attr_rmtval_find_space(dac);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Roll through the "value", allocating blocks on disk as
>> +		 * required.  Set the state in case of -EAGAIN return code
>> +		 */
>> +		dac->dela_state = XFS_DAS_ALLOC_NODE;
>> +das_alloc_node:
>> +		if (dac->blkcnt > 0) {
>> +			error = xfs_attr_rmtval_set_blk(dac);
>> +			if (error)
>> +				return error;
>> +
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		error = xfs_attr_rmtval_set_value(args);
>>   		if (error)
>>   			return error;
>>   	}
>> @@ -1118,22 +1235,24 @@ xfs_attr_node_addname(
>>   	/*
>>   	 * Commit the flag value change and start the next trans in series
>>   	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -	if (error)
>> -		goto out;
>> -
>> +	dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> +	return -EAGAIN;
>> +das_flip_flag:
>>   	/*
>>   	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>>   	 * (if it exists).
>>   	 */
>>   	xfs_attr_restore_rmt_blk(args);
>>   
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_invalidate(args);
>> -		if (error)
>> -			return error;
>> +	error = xfs_attr_rmtval_invalidate(args);
>> +	if (error)
>> +		return error;
>>   
>> -		error = xfs_attr_rmtval_remove(args);
>> +	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>> +	dac->dela_state = XFS_DAS_RM_NBLK;
>> +das_rm_nblk:
>> +	if (args->rmtblkno) {
>> +		error = __xfs_attr_rmtval_remove(dac);
>>   		if (error)
>>   			return error;
>>   	}
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 3154ef4..e101238 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -135,6 +135,227 @@ struct xfs_attr_list_context {
>>    *              v
>>    *            done
>>    *
>> + *
>> + * Below is a state machine diagram for attr set operations.
>> + *
>> + * It seems the challenge with undertanding this system comes from trying to
>> + * absorb the state machine all at once, when really one should only be looking
>> + * at it with in the context of a single function.  Once a state sensitive
>> + * function is called, the idea is that it "takes ownership" of the
>> + * statemachine. It isn't concerned with the states that may have belonged to
>> + * it's calling parent.  Only the states relevant to itself or any other
>> + * subroutines there in.  Once a calling function hands off the statemachine to
>> + * a subroutine, it needs to respect the simple rule that it doesn't "own" the
>> + * statemachine anymore, and it's the responsibility of that calling function to
>> + * propagate the -EAGAIN back up the call stack.  Upon reentry, it is committed
>> + * to re-calling that subroutine until it returns something other than -EAGAIN.
>> + * Once that subroutine signals completion (by returning anything other than
>> + * -EAGAIN), the calling function can resume using the statemachine.
>> + *
>> + *  xfs_attr_set_iter()
>> + *              │
>> + *              v
>> + *   ┌─y─ has an attr fork?
>> + *   │          |
>> + *   │          n
>> + *   │          |
>> + *   │          V
>> + *   │       add a fork
>> + *   │          │
>> + *   └──────────┤
>> + *              │
>> + *              V
>> + *   ┌─n── is shortform?
>> + *   │          |
>> + *   │          y
>> + *   │          |
>> + *   │          V
>> + *   │ xfs_attr_set_shortform
>> + *   │          |
>> + *   │          V
>> + *   │      had enough ──y──> done
>> + *   │        space?
>> + *   │          │
>> + *   │          n
>> + *   │          │
>> + *   │          V
>> + *   │     return -EAGAIN
>> + *   │   Re-enter in leaf form
>> + *   │          │
>> + *   └──────────┤
>> + *              │
>> + *              V
>> + *       release leaf buffer
>> + *          if needed
>> + *              │
>> + *              V
>> + *   ┌───n── fork has
>> + *   │      only 1 blk?
>> + *   │          │
>> + *   │          y
>> + *   │          │
>> + *   │          v
>> + *   │ xfs_attr_leaf_try_add()
>> + *   │                  │
>> + *   │                  v
>> + *   │              had enough
>> + *   │       ┌────n── space?
>> + *   │       │          │
>> + *   │       v          │
>> + *   │ return -EAGAIN   │
>> + *   │  re-enter in     y
>> + *   │   node form      │
>> + *   │       │          │
>> + *   ├───────┘          │
>> + *   │                  v
>> + *   │  XFS_DAS_FOUND_LBLK ──┐
>> + *   │                       │
>> + *   │  XFS_DAS_FLIP_LFLAG ──┤
>> + *   │  (subroutine state)   │
>> + *   │                       │
>> + *   │                       └─>xfs_attr_leaf_addname()
>> + *   │                                │
>> + *   │                                v
>> + *   │                     ┌──first time through?
>> + *   │                     │          │
>> + *   │                     │          y
>> + *   │                     │          │
>> + *   │                     n          v
>> + *   │                     │    if we have rmt blks
>> + *   │                     │    find space for them
>> + *   │                     │          │
>> + *   │                     └──────────┤
>> + *   │                                │
>> + *   │                                v
>> + *   │                           still have
>> + *   │                     ┌─n─ blks to alloc? <──┐
>> + *   │                     │          │           │
>> + *   │                     │          y           │
>> + *   │                     │          │           │
>> + *   │                     │          v           │
>> + *   │                     │     alloc one blk    │
>> + *   │                     │     return -EAGAIN ──┘
>> + *   │                     │    re-enter with one
>> + *   │                     │    less blk to alloc
>> + *   │                     │
>> + *   │                     │
>> + *   │                     └───> set the rmt
>> + *   │                              value
>> + *   │                                │
>> + *   │                                v
>> + *   │                              was this
>> + *   │                             a rename? ──n─┐
>> + *   │                                │          │
>> + *   │                                y          │
>> + *   │                                │          │
>> + *   │                                v          │
>> + *   │                          flip incomplete  │
>> + *   │                              flag         │
>> + *   │                                │          │
>> + *   │                                v          │
>> + *   │                        XFS_DAS_FLIP_LFLAG │
>> + *   │                                │          │
>> + *   │                                v          │
>> + *   │                              remove       │
>> + *   │          XFS_DAS_RM_LBLK ─> old name      │
>> + *   │                   ^            │          │
>> + *   │                   │            v          │
>> + *   │                   └──────y── more to      │
>> + *   │                              remove       │
>> + *   │                                │          │
>> + *   │                                n          │
>> + *   │                                │          │
>> + *   │                                v          │
>> + *   │                               done <──────┘
>> + *   └──> XFS_DAS_FOUND_NBLK ──┐
>> + *        (subroutine state)   │
>> + *                             │
>> + *        XFS_DAS_ALLOC_NODE ──┤
>> + *        (subroutine state)   │
>> + *                             │
>> + *        XFS_DAS_FLIP_NFLAG ──┤
>> + *        (subroutine state)   │
>> + *                             │
>> + *                             └─>xfs_attr_node_addname()
>> + *                                     │
>> + *                                     v
>> + *                               determine if this
>> + *                              is create or rename
>> + *                            find space to store attr
>> + *                                     │
>> + *                                     v
>> + *               ┌──────n──── fits in a node leaf?
>> + *               │               ^     │
>> + *       single leaf node?       │     │
>> + *         │            │        │     y
>> + *         n            y        │     │
>> + *         │            │        │     v
>> + *         v            v        │   update
>> + *     split if   grow the leaf ─┘  hashvals
>> + *      needed     return -EAGAIN      │
>> + *         │      retry leaf add       │
>> + *         │        on reentry         │
>> + *         │                           │
>> + *         └───────────────────────────┤
>> + *                                     v
>> + *                                need to alloc ──n──> done
>> + *                                or flip flag?
>> + *                                     │
>> + *                                     y
>> + *                                     │
>> + *                                     v
>> + *                             XFS_DAS_FOUND_NBLK
>> + *                                     │
>> + *                                     v
>> + *                       ┌─────n──  need to
>> + *                       │        alloc blks?
>> + *                       │             │
>> + *                       │             y
>> + *                       │             │
>> + *                       │             v
>> + *                       │        find space
>> + *                       │             │
>> + *                       │             v
>> + *                       │  ┌─>XFS_DAS_ALLOC_NODE
>> + *                       │  │          │
>> + *                       │  │          v
>> + *                       │  │      alloc blk
>> + *                       │  │          │
>> + *                       │  │          v
>> + *                       │  └──y── need to alloc
>> + *                       │         more blocks?
>> + *                       │             │
>> + *                       │             n
>> + *                       │             │
>> + *                       │             v
>> + *                       │      set the rmt value
>> + *                       │             │
>> + *                       │             v
>> + *                       │          was this
>> + *                       └────────> a rename? ──n─┐
>> + *                                     │          │
>> + *                                     y          │
>> + *                                     │          │
>> + *                                     v          │
>> + *                               flip incomplete  │
>> + *                                   flag         │
>> + *                                     │          │
>> + *                                     v          │
>> + *                             XFS_DAS_FLIP_NFLAG │
>> + *                                     │          │
>> + *                                     v          │
>> + *                                   remove       │
>> + *               XFS_DAS_RM_NBLK ─> old name      │
>> + *                        ^            │          │
>> + *                        │            v          │
>> + *                        └──────y── more to      │
>> + *                                   remove       │
>> + *                                     │          │
>> + *                                     n          │
>> + *                                     │          │
>> + *                                     v          │
>> + *                                    done <──────┘
>> + *
>>    */
>>   
>>   /*
>> @@ -149,12 +370,20 @@ struct xfs_attr_list_context {
>>   enum xfs_delattr_state {
>>   	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>>   	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>> +	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
>> +	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
>> +	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
>> +	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
>> +	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
>> +	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
>> +	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
>>   };
>>   
>>   /*
>>    * Defines for xfs_delattr_context.flags
>>    */
>>   #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
>>   
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>> @@ -162,6 +391,11 @@ enum xfs_delattr_state {
>>   struct xfs_delattr_context {
>>   	struct xfs_da_args      *da_args;
>>   
>> +	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
>> +	struct xfs_bmbt_irec	map;
>> +	xfs_dablk_t		lblkno;
>> +	int			blkcnt;
>> +
>>   	/* Used in xfs_attr_node_removename to roll through removing blocks */
>>   	struct xfs_da_state     *da_state;
>>   
>> @@ -188,7 +422,6 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>> -int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index f09820c..6af86bf 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -441,7 +441,7 @@ xfs_attr_rmtval_get(
>>    * Find a "hole" in the attribute address space large enough for us to drop the
>>    * new attribute's value into
>>    */
>> -STATIC int
>> +int
>>   xfs_attr_rmt_find_hole(
>>   	struct xfs_da_args	*args)
>>   {
>> @@ -468,7 +468,7 @@ xfs_attr_rmt_find_hole(
>>   	return 0;
>>   }
>>   
>> -STATIC int
>> +int
>>   xfs_attr_rmtval_set_value(
>>   	struct xfs_da_args	*args)
>>   {
>> @@ -628,6 +628,69 @@ xfs_attr_rmtval_set(
>>   }
>>   
>>   /*
>> + * Find a hole for the attr and store it in the delayed attr context.  This
>> + * initializes the context to roll through allocating an attr extent for a
>> + * delayed attr operation
>> + */
>> +int
>> +xfs_attr_rmtval_find_space(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_bmbt_irec		*map = &dac->map;
>> +	int				error;
>> +
>> +	dac->lblkno = 0;
>> +	dac->blkcnt = 0;
>> +	args->rmtblkcnt = 0;
>> +	args->rmtblkno = 0;
>> +	memset(map, 0, sizeof(struct xfs_bmbt_irec));
>> +
>> +	error = xfs_attr_rmt_find_hole(args);
>> +	if (error)
>> +		return error;
>> +
>> +	dac->blkcnt = args->rmtblkcnt;
>> +	dac->lblkno = args->rmtblkno;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Write one block of the value associated with an attribute into the
>> + * out-of-line buffer that we have defined for it. This is similar to a subset
>> + * of xfs_attr_rmtval_set, but records the current block to the delayed attr
>> + * context, and leaves transaction handling to the caller.
>> + */
>> +int
>> +xfs_attr_rmtval_set_blk(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_inode		*dp = args->dp;
>> +	struct xfs_bmbt_irec		*map = &dac->map;
>> +	int nmap;
>> +	int error;
>> +
>> +	nmap = 1;
>> +	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
>> +				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
>> +				map, &nmap);
>> +	if (error)
>> +		return error;
>> +
>> +	ASSERT(nmap == 1);
>> +	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
>> +	       (map->br_startblock != HOLESTARTBLOCK));
>> +
>> +	/* roll attribute extent map forwards */
>> +	dac->lblkno += map->br_blockcount;
>> +	dac->blkcnt -= map->br_blockcount;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * Remove the value associated with an attribute by deleting the
>>    * out-of-line buffer that it is stored on.
>>    */
>> @@ -669,37 +732,6 @@ xfs_attr_rmtval_invalidate(
>>   }
>>   
>>   /*
>> - * Remove the value associated with an attribute by deleting the
>> - * out-of-line buffer that it is stored on.
>> - */
>> -int
>> -xfs_attr_rmtval_remove(
>> -	struct xfs_da_args		*args)
>> -{
>> -	int				error;
>> -	struct xfs_delattr_context	dac  = {
>> -		.da_args	= args,
>> -	};
>> -
>> -	trace_xfs_attr_rmtval_remove(args);
>> -
>> -	/*
>> -	 * Keep de-allocating extents until the remote-value region is gone.
>> -	 */
>> -	do {
>> -		error = __xfs_attr_rmtval_remove(&dac);
>> -		if (error != -EAGAIN)
>> -			break;
>> -
>> -		error = xfs_attr_trans_roll(&dac);
>> -		if (error)
>> -			return error;
>> -	} while (true);
>> -
>> -	return error;
>> -}
>> -
>> -/*
>>    * Remove the value associated with an attribute by deleting the out-of-line
>>    * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>>    * transaction and re-call the function
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 002fd30..8ad68d5 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -10,9 +10,12 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>> -int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>   int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>> +int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
>> +int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index 5a263ae..9074b8b 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -1943,7 +1943,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
>>   
>>   DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
>>   DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
>> -DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
>>   
>>   #define DEFINE_DA_EVENT(name) \
>>   DEFINE_EVENT(xfs_da_class, name, \
>>
> 
> 
