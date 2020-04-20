Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E49C54FCC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 23:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802EF206D9
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 23:26:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ElfZ22S6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgDTX02 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 19:26:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43970 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDTX01 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 19:26:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNIYjZ012164;
        Mon, 20 Apr 2020 23:26:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ipVTfd1L1s7JPONP/TJxT6Wzlo5ISEq6PcEK5YSAYBw=;
 b=ElfZ22S6MUiktsr2bYEaakm+aULI4LOZPH+nEdaO5S74897Q9y08u2R6DMdZm0LL57qR
 OnMQj4Ndit3XsBkaLzzOxkSQ6BxJ1xvJw8IJI+J+/SGgkHlFEhvbdm3ex2KmtLvoq2tS
 C7TufN1j9IBI2kw7As3BebAc50gcDUQe5/3MvA5s9y2ZOzhMbjcKP8hFtaPfiyh4qsRh
 UfcfY5PUuij8P8I5dnpZUaNRl6rusIggwfUUJBEOwj5LaTrlF8RcYRN92x+Zo3i3Bkue
 y9XUQkA+5uPCgirMnbU6hWlFofNVxbTmW0bUZSxDyFFN064nppYoVuoNP2iDiBl7iurt CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30fsgkt3rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 23:26:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KNCQwP009568;
        Mon, 20 Apr 2020 23:26:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30gbbby4ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 23:26:22 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03KNQMbA001303;
        Mon, 20 Apr 2020 23:26:22 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 16:26:21 -0700
Subject: Re: [PATCH v8 18/20] xfs: Add delay ready attr remove routines
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-19-allison.henderson@oracle.com>
 <1751112.6zseaXoMQ2@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <4077db7e-faa5-75df-cd32-8496ba378c32@oracle.com>
Date:   Mon, 20 Apr 2020 16:26:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1751112.6zseaXoMQ2@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/20 2:06 AM, Chandan Rajendra wrote:
> On Saturday, April 4, 2020 3:42 AM Allison Collins wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>> uses a sort of state machine like switch to keep track of where it was
>> when EAGAIN was returned. xfs_attr_node_removename has also been
>> modified to use the switch, and a new version of xfs_attr_remove_args
>> consists of a simple loop to refresh the transaction until the operation
>> is completed.
>>
>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>> counter parts: xfs_attr_rmtval_invalidate (appearing in the setup
>> helper) and then __xfs_attr_rmtval_remove. We will rename
>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>> done.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.
>>
>> Below is a state machine diagram for attr remove operations. The
>> XFS_DAS_* states indicate places where the function would return
>> -EAGAIN, and then immediately resume from after being recalled by the
>> calling function.  States marked as a "subroutine state" indicate that
>> they belong to a subroutine, and so the calling function needs to pass
>> them back to that subroutine to allow it to finish where it left off.
>> But they otherwise do not have a role in the calling function other than
>> just passing through.
>>
>>   xfs_attr_remove_iter()
>>           XFS_DAS_RM_SHRINK     ─┐
>>           (subroutine state)     │
>>                                  │
>>           XFS_DAS_RMTVAL_REMOVE ─┤
>>           (subroutine state)     │
>>                                  └─>xfs_attr_node_removename()
>>                                                   │
>>                                                   v
>>                                           need to remove
>>                                     ┌─n──  rmt blocks?
>>                                     │             │
>>                                     │             y
>>                                     │             │
>>                                     │             v
>>                                     │  ┌─>XFS_DAS_RMTVAL_REMOVE
>>                                     │  │          │
>>                                     │  │          v
>>                                     │  └──y── more blks
>>                                     │         to remove?
>>                                     │             │
>>                                     │             n
>>                                     │             │
>>                                     │             v
>>                                     │         need to
>>                                     └─────> shrink tree? ─n─┐
>>                                                   │         │
>>                                                   y         │
>>                                                   │         │
>>                                                   v         │
>>                                           XFS_DAS_RM_SHRINK │
>>                                                   │         │
>>                                                   v         │
>>                                                  done <─────┘
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 168 ++++++++++++++++++++++++++++++++++++-----------
>>   fs/xfs/libxfs/xfs_attr.h |  38 +++++++++++
>>   2 files changed, 168 insertions(+), 38 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index d735570..f700976 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -45,7 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>    */
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>> -STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_leaf_removename(struct xfs_delattr_context *dac);
>>   STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>   
>>   /*
>> @@ -53,12 +53,21 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>   
>> +STATIC void
>> +xfs_delattr_context_init(
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_da_args		*args)
>> +{
>> +	memset(dac, 0, sizeof(struct xfs_delattr_context));
>> +	dac->da_args = args;
>> +}
>> +
>>   int
>>   xfs_inode_hasattr(
>>   	struct xfs_inode	*ip)
>> @@ -356,20 +365,66 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args	*args)
>>   {
>> +	int			error = 0;
>> +	struct			xfs_delattr_context dac;
>> +
>> +	xfs_delattr_context_init(&dac, args);
>> +
>> +	do {
>> +		error = xfs_attr_remove_iter(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
>> +
>> +		if (dac.flags & XFS_DAC_DEFER_FINISH) {
>> +			dac.flags &= ~XFS_DAC_DEFER_FINISH;
>> +			error = xfs_defer_finish(&args->trans);
>> +			if (error)
>> +				break;
>> +		}
>> +
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			break;
>> +	} while (true);
>> +
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove the attribute specified in @args.
>> + *
>> + * This function may return -EAGAIN to signal that the transaction needs to be
>> + * rolled.  Callers should continue calling this function until they receive a
>> + * return value other than -EAGAIN.
>> + */
>> +int
>> +xfs_attr_remove_iter(
>> +	struct xfs_delattr_context *dac)
>> +{
>> +	struct xfs_da_args	*args = dac->da_args;
>>   	struct xfs_inode	*dp = args->dp;
>>   	int			error;
>>   
>> +	/* State machine switch */
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_RM_SHRINK:
>> +	case XFS_DAS_RMTVAL_REMOVE:
>> +		return xfs_attr_node_removename(dac);
>> +	default:
>> +		break;
>> +	}
>> +
>>   	if (!xfs_inode_hasattr(dp)) {
>>   		error = -ENOATTR;
>>   	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>>   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>>   		error = xfs_attr_shortform_remove(args);
>>   	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_removename(args);
>> +		error = xfs_attr_leaf_removename(dac);
>>   	} else {
>> -		error = xfs_attr_node_removename(args);
>> +		error = xfs_attr_node_removename(dac);
>>   	}
>>   
>>   	return error;
>> @@ -794,11 +849,12 @@ xfs_attr_leaf_hasname(
>>    */
>>   STATIC int
>>   xfs_attr_leaf_removename(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	struct xfs_inode	*dp;
>> -	struct xfs_buf		*bp;
>> -	int			error, forkoff;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_inode		*dp;
>> +	struct xfs_buf			*bp;
>> +	int				error, forkoff;
>>   
>>   	trace_xfs_attr_leaf_removename(args);
>>   
>> @@ -825,9 +881,8 @@ xfs_attr_leaf_removename(
>>   		/* bp is gone due to xfs_da_shrink_inode */
>>   		if (error)
>>   			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	}
>>   	return 0;
>>   }
>> @@ -1128,12 +1183,13 @@ xfs_attr_node_addname(
>>    */
>>   STATIC int
>>   xfs_attr_node_shrink(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state     *state)
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_da_state		*state)
>>   {
>> -	struct xfs_inode	*dp = args->dp;
>> -	int			error, forkoff;
>> -	struct xfs_buf		*bp;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_inode		*dp = args->dp;
>> +	int				error, forkoff;
>> +	struct xfs_buf			*bp;
>>   
>>   	/*
>>   	 * Have to get rid of the copy of this dabuf in the state.
>> @@ -1153,9 +1209,7 @@ xfs_attr_node_shrink(
>>   		if (error)
>>   			return error;
>>   
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	} else
>>   		xfs_trans_brelse(args->trans, bp);
>>   
>> @@ -1194,13 +1248,15 @@ xfs_attr_leaf_mark_incomplete(
>>   
>>   /*
>>    * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
>> - * the blocks are valid.  Any remote blocks will be marked incomplete.
>> + * the blocks are valid.  Any remote blocks will be marked incomplete and
>> + * invalidated.
>>    */
>>   STATIC
>>   int xfs_attr_node_removename_setup(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	**state)
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_da_state		**state)
>>   {
>> +	struct xfs_da_args	*args = dac->da_args;
>>   	int			error;
>>   	struct xfs_da_state_blk	*blk;
>>   
>> @@ -1212,10 +1268,21 @@ int xfs_attr_node_removename_setup(
>>   	ASSERT(blk->bp != NULL);
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   
>> +	/*
>> +	 * Store blk and state in the context incase we need to cycle out the
>> +	 * transaction
>> +	 */
>> +	dac->blk = blk;
>> +	dac->da_state = *state;
>> +
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_leaf_mark_incomplete(args, *state);
>>   		if (error)
>>   			return error;
>> +
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
>>   	}
>>   
>>   	return 0;
>> @@ -1228,7 +1295,10 @@ xfs_attr_node_removename_rmt (
>>   {
>>   	int			error = 0;
>>   
>> -	error = xfs_attr_rmtval_remove(args);
>> +	/*
>> +	 * May return -EAGAIN to request that the caller recall this function
>> +	 */
>> +	error = __xfs_attr_rmtval_remove(args);
>>   	if (error)
>>   		return error;
>>   
>> @@ -1249,19 +1319,37 @@ xfs_attr_node_removename_rmt (
>>    * This will involve walking down the Btree, and may involve joining
>>    * leaf nodes and even joining intermediate nodes up to and including
>>    * the root node (a special case of an intermediate node).
>> + *
>> + * This routine is meant to function as either an inline or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>>   STATIC int
>>   xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> +	struct xfs_da_args	*args = dac->da_args;
>>   	struct xfs_da_state	*state;
>>   	struct xfs_da_state_blk	*blk;
>>   	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>> +	state = dac->da_state;
>> +	blk = dac->blk;
>> +
>> +	/* State machine switch */
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_RMTVAL_REMOVE:
>> +		goto das_rmtval_remove;
>> +	case XFS_DAS_RM_SHRINK:
>> +		goto das_rm_shrink;
>> +	default:
>> +		break;
>> +	}
>>   
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> +	error = xfs_attr_node_removename_setup(dac, &state);
>>   	if (error)
>>   		goto out;
>>   
>> @@ -1270,10 +1358,16 @@ xfs_attr_node_removename(
>>   	 * This is done before we remove the attribute so that we don't
>>   	 * overflow the maximum size of a transaction and/or hit a deadlock.
>>   	 */
>> +
>> +das_rmtval_remove:
>> +
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_node_removename_rmt(args, state);
>> -		if (error)
>> -			goto out;
>> +		if (error) {
>> +			if (error == -EAGAIN)
>> +				dac->dela_state = XFS_DAS_RMTVAL_REMOVE;
> 
> Shouldn't XFS_DAC_DEFER_FINISH be set in dac->flags?
> xfs_attr_node_removename_rmt() indirectly calls __xfs_bunmapi() which would
> have added items to the deferred list.
> 
Ok I see it.  I think what I'll do based on the over all v8 feed back 
is: make __xfs_attr_rmtval_remove a helper function of 
xfs_attr_rmtval_remove in patch 10.  I'll keep the xfs_defer_finish as 
part of that helper.  Then when we come to this patch, the 
xfs_defer_finish will turn into the flag set.  That should fix this I 
believe.  Thank for the review!

Allison
