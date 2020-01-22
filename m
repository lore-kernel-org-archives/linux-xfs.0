Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC117C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 09:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D6252467B
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 09:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PX0xF4tX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgAVJz6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 04:55:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41900 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730066AbgAVJcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 04:32:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M9Rn5e073764
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 09:32:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ofkCOnSAk4tWwHN7soXzcLLaNAfNlKJXyDuOW618Af0=;
 b=PX0xF4tXCJlCESJWx4xX5WuREjpwh3E02Pj9QysxzlvBdO1HWHACplnM64+l8ub9c+oH
 lBrymu6NEiabcqdDEjAjEOwBh/+TUv6UsuLqZUQvhtztp9bx/ECea2O9Xz7q+6U7ENiI
 mzdXFEOEPh2WYFEWMRYm+egZEb/8pCs3hFQEa0jkebTIs3xuTqzSkO4TiWl1tBRQ5wSJ
 MV6DxDVee072SeoP9gnOYciCsaYKgmjA8iadi9KcS8i7UI8MJCuhTAQF/71GfPuqf+TA
 HK5JWRJ0xumgnP+2COkEe+fsLwmLbgSEJPrfovtr8Q2j7VEhThbqVCY45TWhYqGPkXDb aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnraag6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 09:32:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M9TUSu109711
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 09:32:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xnpekr8tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 09:32:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00M9WKSJ014477
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 09:32:20 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 01:32:20 -0800
Subject: Re: [PATCH v6 15/16] xfs: Add delay ready attr remove routines
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-16-allison.henderson@oracle.com>
 <20200122000207.GO8247@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7d5d5ce0-532c-c07a-6b19-16360e41c703@oracle.com>
Date:   Wed, 22 Jan 2020 02:32:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200122000207.GO8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220086
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/20 5:02 PM, Darrick J. Wong wrote:
> On Sat, Jan 18, 2020 at 03:50:34PM -0700, Allison Collins wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction.
>> In this series, xfs_attr_remove_args has become xfs_attr_remove_iter,
>> which uses a sort of state machine like switch to keep track of where it
>> was when EAGAIN was returned. xfs_attr_node_removename has also been
>> modified to use the switch, and a  new version of xfs_attr_remove_args
>> consists of a simple loop to refresh the transaction until the operation
>> is completed.  A helper function xfs_attr_node_shrink has also been
>> added to help simplify xfs_attr_node_removename and reduce length.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c     | 181 +++++++++++++++++++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr.h     |   1 +
>>   fs/xfs/libxfs/xfs_da_btree.h |  24 ++++++
>>   fs/xfs/scrub/common.c        |   2 +
>>   fs/xfs/xfs_acl.c             |   2 +
>>   fs/xfs/xfs_attr_list.c       |   1 +
>>   fs/xfs/xfs_ioctl.c           |   2 +
>>   fs/xfs/xfs_ioctl32.c         |   2 +
>>   fs/xfs/xfs_iops.c            |   2 +
>>   fs/xfs/xfs_xattr.c           |   1 +
>>   10 files changed, 176 insertions(+), 42 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 90e0b2d..92929ad 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -371,11 +371,60 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> +	struct xfs_da_args	*args)
>> +{
>> +	int			error = 0;
>> +	int			err2 = 0;
>> +
>> +	do {
>> +		error = xfs_attr_remove_iter(args);
>> +		if (error && error != -EAGAIN)
>> +			goto out;
>> +
>> +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>> +			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
> 
> Won't rolling the transaction take care of calling defer_finish?
> 
> (Granted, I think you started this patch set long before we actually
> introduced that behavior...)

I actually plumbed in this extra flag field because folks has asked me 
to preserve the finish calls where they appeared in the last review. 
Reason being that this changes behavior in that the transaction roll 
doesn't complete pending deferred operations.

https://www.spinics.net/lists/linux-xfs/msg35096.html

> 
>> +			err2 = xfs_defer_finish(&args->trans);
>> +			if (err2) {
>> +				error = err2;
>> +				goto out;
>> +			}
>> +		}
>> +
>> +		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (err2) {
>> +			error = err2;
>> +			goto out;
>> +		}
>> +
>> +	} while (error == -EAGAIN);
> 
> /me suspects this could be compressed down to:
> 
> do {
> 	error = xfs_attr_remove_iter(args);
> 	if (error == -EAGAIN) {
> 		error = 0;
> 		break;
?? if error is EAGAIN, we want to roll and continue, right?
And if it's 0 we roll and break.

> 	}
> 	if (error)
> 		break;
> 
> 	error = xfs_trans_roll_inode(...);
> } while (error == 0);
Logic bugs aside, I think you meant something pretty close to the v5 
version.

> 
> return error;
> 
>> +out:
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove the attribute specified in @args.
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + * returned.
> 
> "This function may return -EAGAIN to signal that the transaction needs
> to be rolled.  Callers should continue calling this function until they
> receive a return value other than -EAGAIN." ?
Sure that's fine if folks think that is more clear.  At this point I 
feel like I have enough of it in my head, it's more about whether it 
makes sense to other people.  I agree the paraphrasing it equivalent.

> 
>> + */
>> +int
>> +xfs_attr_remove_iter(
>>   	struct xfs_da_args      *args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	int			error;
>>   
>> +	/* State machine switch */
>> +	switch (args->dac.dela_state) {
>> +	case XFS_DAS_RM_SHRINK:
>> +	case XFS_DAS_RM_NODE_BLKS:
>> +		goto node;
>> +	default:
>> +		break;
>> +	}
>> +
>>   	if (!xfs_inode_hasattr(dp)) {
>>   		error = -ENOATTR;
>>   	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> @@ -384,6 +433,7 @@ xfs_attr_remove_args(
>>   	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_removename(args);
>>   	} else {
>> +node:
>>   		error = xfs_attr_node_removename(args);
>>   	}
>>   
>> @@ -887,9 +937,8 @@ xfs_attr_leaf_removename(
>>   		/* bp is gone due to xfs_da_shrink_inode */
>>   		if (error)
>>   			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +
>> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>   	}
>>   	return 0;
>>   }
>> @@ -1233,6 +1282,42 @@ xfs_attr_init_unmapstate(
>>   	return 0;
>>   }
>>   
>> +/*
>> + * Shrink an attribute from leaf to shortform
>> + */
>> +STATIC int
>> +xfs_attr_node_shrink(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state     *state)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error, forkoff;
>> +	struct xfs_buf		*bp;
>> +
>> +	/*
>> +	 * Have to get rid of the copy of this dabuf in the state.
>> +	 */
>> +	ASSERT(state->path.active == 1);
>> +	ASSERT(state->path.blk[0].bp);
>> +	state->path.blk[0].bp = NULL;
>> +
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>> +	if (error)
>> +		return error;
>> +
>> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +	if (forkoff) {
>> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +		/* bp is gone due to xfs_da_shrink_inode */
>> +		if (error)
>> +			return error;
>> +
>> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> +	} else
>> +		xfs_trans_brelse(args->trans, bp);
>> +
>> +	return 0;
>> +}
>>   
>>   /*
>>    * Remove a name from a B-tree attribute list.
>> @@ -1240,6 +1325,11 @@ xfs_attr_init_unmapstate(
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
>> @@ -1247,15 +1337,28 @@ xfs_attr_node_removename(
>>   {
>>   	struct xfs_da_state	*state;
>>   	struct xfs_da_state_blk	*blk;
>> -	struct xfs_buf		*bp;
>> -	int			retval, error, forkoff;
>> +	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>> +	state = args->dac.da_state;
>> +	blk = args->dac.blk;
>> +
>> +	/* State machine switch */
>> +	switch (args->dac.dela_state) {
>> +	case XFS_DAS_RM_NODE_BLKS:
>> +		goto rm_node_blks;
>> +	case XFS_DAS_RM_SHRINK:
>> +		goto rm_shrink;
>> +	default:
>> +		break;
>> +	}
>>   
>>   	error = xfs_attr_node_hasname(args, &state);
>>   	if (error != -EEXIST)
>>   		goto out;
>> +	else
>> +		error = 0;
>>   
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.
>> @@ -1265,18 +1368,36 @@ xfs_attr_node_removename(
>>   	blk = &state->path.blk[ state->path.active-1 ];
>>   	ASSERT(blk->bp != NULL);
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +
>> +	/*
>> +	 * Store blk and state in the context incase we need to cycle out the
>> +	 * transaction
>> +	 */
>> +	args->dac.blk = blk;
>> +	args->dac.da_state = state;
>> +
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_init_unmapstate(args, state);
>>   		if (error)
>>   			goto out;
>>   
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		error = xfs_attr_rmtval_invalidate(args);
>>   		if (error)
>>   			goto out;
>> +	}
>>   
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			goto out;
>> +rm_node_blks:
>> +
>> +	args->dac.dela_state = XFS_DAS_RM_NODE_BLKS;
> 
> That's odd -- we jumped here if dela_state == RM_NODE_BLKS, so why do we
> need to set dela_state?  Does that put us at risk of jumping back here
> by accident?
It would if there was a subroutine using the state machine, but we dont 
have that in this case, so it actually doesn't have an effect.  It was 
asked for in one of the reviews, I assumed because people found it 
appropriate to set it at that time, sort of like a witness mark.  It 
doesnt hurt anything to do so, but you are right in that it is a 
duplicate.

> 
> Oh, maybe this is supposed to make sure we keep coming back for more
> bunmapi if the the remote value blocks were backed by multiple extents.
> 
> Perhaps this would be better named DAS_RMTVAL_REMOVE?
xfs_attr_rmtval_unmap is the association in this case. 
DAS_RMTVAL_REMOVE is appropriate if folks prefer.

> 
>> +
>> +	if (args->rmtblkno > 0) {
>> +		error = xfs_attr_rmtval_unmap(args);
>> +
>> +		if (error) {
>> +			if (error == -EAGAIN)
>> +				args->dac.dela_state = XFS_DAS_RM_NODE_BLKS;
> 
> (Didn't we already set this state?)
It is.  If you prefer to only keep one, I would stick with this one 
because this is the specific case that really needs it.  Also I think 
having them there helps to mark which of the returns are sort of the 
"jump out" points

> 
>> +			return error;
>> +		}
>>   
>>   		/*
>>   		 * Refill the state structure with buffers, the prior calls
>> @@ -1302,44 +1423,20 @@ xfs_attr_node_removename(
>>   		error = xfs_da3_join(state);
>>   		if (error)
>>   			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			goto out;
>> -		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			goto out;
>> +
>> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> +		args->dac.dela_state = XFS_DAS_RM_SHRINK;
>> +		return -EAGAIN;
>>   	}
>>   
>> +rm_shrink:
>> +	args->dac.dela_state = XFS_DAS_RM_SHRINK;
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		/*
>> -		 * Have to get rid of the copy of this dabuf in the state.
>> -		 */
>> -		ASSERT(state->path.active == 1);
>> -		ASSERT(state->path.blk[0].bp);
>> -		state->path.blk[0].bp = NULL;
>> -
>> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>> -		if (error)
>> -			goto out;
>> -
>> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -			/* bp is gone due to xfs_da_shrink_inode */
>> -			if (error)
>> -				goto out;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				goto out;
>> -		} else
>> -			xfs_trans_brelse(args->trans, bp);
>> -	}
>> -	error = 0;
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		error = xfs_attr_node_shrink(args, state);
>>   
>>   out:
>>   	if (state)
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index ce7b039..ea873a5 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -155,6 +155,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>> +int xfs_attr_remove_iter(struct xfs_da_args *args);
>>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   		  int flags, struct attrlist_cursor_kern *cursor);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
>> index 14f1be3..7fc87da 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.h
>> +++ b/fs/xfs/libxfs/xfs_da_btree.h
>> @@ -50,9 +50,33 @@ enum xfs_dacmp {
>>   };
>>   
>>   /*
>> + * Enum values for xfs_delattr_context.da_state
>> + */
> 
> I can tell this is an enum. ;)
> 
> Could you have this comment explain a little more about how states are
> managed?  I /think/ these state values mark where we were in the attr
> code when something decided it was time to roll a transaction, right?
> 
> In other words, dela_state is a save point where we jump back to after
> hopping out to roll a transaction?
> 
> (The parts of the code we jump somewhere based on dela_state and
> immediately set dela_state confused me, so I don't know if I've
> understood how the state machine works correctly.)
It sounds like you're pretty much understanding it.  If that extra state 
set was confusing, then perhaps it should go.  Anyway, how about the 
following commentary:

/*
  * Enum values for xfs_delattr_context.da_state
  *
  * These values are used by delayed attribute operations to keep track
  * of where they were before they returned -EAGAIN.  A return code of
  * -EAGAIN signals the calling function to roll the transaction, and
  * then recall the subroutine to finish the operation.  The enum
  * is then used by the subroutine to jump back to where it was and
  * resume executing where it left off.
  */

> 
>> +enum xfs_delattr_state {
>> +	XFS_DAS_RM_SHRINK	= 1, /* We are shrinking the tree */
> 
> This means that dela_state == 0 means "do not use delayed attributes",
> right?  We might want to make the meaning of zero more explicit.
No, at this point a value of 0 does not mean anything.  It will later 
when we get into delayed attrs.  Delayed attrs are slightly different in 
that args (and the state machine) need to get set up after the "ping 
pong" has already started.  So we initialize on a state of 0, and have 
one more extra state (XFS_DAS_INIT) just to say that we did it, so dont 
initialize it again.  (See xfs_attr_finish_item from the git branch I 
sent earlier)

To further comment your interpretation, no, the routines do not execute 
any differently when the state is zero, or any other value they do not 
reconize.  They simply assume to "start from the begining" (ie: they 
simply fall through the switch statement) and over write the state as 
needed.

In fact, there are a few spots in the next patch when a child function 
gets a state reminicent of it's parent.  This condidtion is not an 
error.  It just means that the parent function was using it up until 
this point when it choose  to surrender the statemachine to the child 
function.  The child function has no notion of what its parents states 
even mean and pay no mind.  It is however the parents responsibility to 
reconize states of its child, and jump back to the child function to 
allow it to finish its tasks.

Hope that helps some :-)

> 
>> +	XFS_DAS_RM_NODE_BLKS	= 2, /* We are removing node blocks */
> 
> Also, the C compiler will auto-increment this for you if you don't
> assign an explicit value.
Ok, do you prefer them not to be explicitly assigned?

> 
>> +};
>> +
>> +/*
>> + * Defines for xfs_delattr_context.flags
>> + */
>> +#define	XFS_DAC_FINISH_TRANS	0x1 /* indicates to finish the transaction */
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delattr_context {
>> +	struct xfs_da_state	*da_state;
>> +	struct xfs_da_state_blk *blk;
>> +	int			flags;
> 
> unsigned int, assuming FINISH_TRANS doesn't just disappear.
Sure, will fix

> 
>> +	enum xfs_delattr_state	dela_state;
>> +};
>> +
>> +/*
>>    * Structure to ease passing around component names.
>>    */
>>   typedef struct xfs_da_args {
>> +	struct xfs_delattr_context dac; /* context used for delay attr ops */
>>   	struct xfs_da_geometry *geo;	/* da block geometry */
>>   	struct xfs_name	name;		/* name, length and argument  flags*/
>>   	uint8_t		filetype;	/* filetype of inode for directories */
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index 1887605..9a649d1 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -24,6 +24,8 @@
>>   #include "xfs_rmap_btree.h"
>>   #include "xfs_log.h"
>>   #include "xfs_trans_priv.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
> 
> Are these necessary if all the da_args stuff moves to xfs_types.h?
That may remedy some of this.  I'll see if I can move it over.  Thanks 
for the review.

Allison

> 
> --D
> 
>>   #include "xfs_attr.h"
>>   #include "xfs_reflink.h"
>>   #include "scrub/scrub.h"
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index 42ac847..d65e6d8 100644
>> --- a/fs/xfs/xfs_acl.c
>> +++ b/fs/xfs/xfs_acl.c
>> @@ -10,6 +10,8 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_error.h"
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index d37743b..881b9a4 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -12,6 +12,7 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_inode.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 28c07c9..7c1d9da 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -15,6 +15,8 @@
>>   #include "xfs_iwalk.h"
>>   #include "xfs_itable.h"
>>   #include "xfs_error.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_bmap_util.h"
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index 769581a..d504f8f 100644
>> --- a/fs/xfs/xfs_ioctl32.c
>> +++ b/fs/xfs/xfs_ioctl32.c
>> @@ -17,6 +17,8 @@
>>   #include "xfs_itable.h"
>>   #include "xfs_fsops.h"
>>   #include "xfs_rtalloc.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_ioctl.h"
>>   #include "xfs_ioctl32.h"
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index e85bbf5..a2d299f 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -13,6 +13,8 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_quota.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 74133a5..d8dc72d 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -10,6 +10,7 @@
>>   #include "xfs_log_format.h"
>>   #include "xfs_da_format.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_acl.h"
>>   
>> -- 
>> 2.7.4
>>
