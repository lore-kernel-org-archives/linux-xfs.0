Return-Path: <SRS0=w6e5=56=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE370C2BB1D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 21:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A33420768
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 21:38:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I1m3hW2b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbgDNVh7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 17:37:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731763AbgDNVhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Apr 2020 17:37:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03ELIZf6131290;
        Tue, 14 Apr 2020 21:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PxDkDZIZg8UH5Zw5jEwYTiZ1IC1RmqWG3BWTtN6BFvw=;
 b=I1m3hW2b9VTGPexUIGt+zlT0JDqusrs+qoeDiImziQMHrM1gygCI1JYDNonpjR5B5tjn
 7uqoY3xaVLKmmt7DtNT3CxS8+eG1CT+tA2bFtY0ObHFBi4jE332Bp6o/66+mROWIFQAQ
 /sBB478yfh9bs1mCDKbZH3+12y8LUoC9GNEcRehzRAmhzslSKhv+v/pJMFZCIrbrztXp
 ldakSqkQja1+tjd3G7CYYFvXd26mnrAwErQimTtMncY8r3hvekol6mK8xFKz6pOSznAu
 nUepPqgE0C/c5vQN4Yl8Vqa3vMPGgMjcpVj1gXBWLLolN7FxrDQ0N3mlSphV2zFQ+iFb LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30b5ar7ggk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 21:37:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03ELLkpp087318;
        Tue, 14 Apr 2020 21:35:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30bqcjx595-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 21:35:46 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03ELZjn2020058;
        Tue, 14 Apr 2020 21:35:45 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 14:35:44 -0700
Subject: Re: [PATCH v8 18/20] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-19-allison.henderson@oracle.com>
 <20200413123021.GA57285@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <4c38d38f-ad8a-24dc-9d00-815fc433dfdb@oracle.com>
Date:   Tue, 14 Apr 2020 14:35:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200413123021.GA57285@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/13/20 5:30 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:27PM -0700, Allison Collins wrote:
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
> 
> All in all this is starting to look much more simple to me, at least in
> the remove path. ;P There's only a few states and the markers that are
> introduced are fairly straightforward, etc. Comments to follow..
> 
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
> 
> Hmm.. so we're duplicating the call instead of using labels..? 

Yes, this was a suggestion made during v7.  I suspect Dave may have been 
wanting to simplify things by escaping the use of labels.  At least in 
so far as the remove path is concerned.  Though he may not have realized 
this would create a duplication call?  I will cc him here; the 
conditions for calling xfs_attr_node_removename are: the below if/else 
sequence exhausts with no successes, and defaults into the else case 
(ie: the entry condition), OR one of the above states is set (which is a 
re-entry condition)


I'm
> wondering if this can be elegantly combined with the if/else branches
> below, particularly since node format is the only situation that seems
> to require a roll here.
> 
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

If we want to try and combine this into if/elses with no duplication, I 
believe the simplest arrangement would look something like this:


int
xfs_attr_remove_iter(
	struct xfs_delattr_context *dac)
{
	struct xfs_da_args	*args = dac->da_args;
	struct xfs_inode	*dp = args->dp;

	if (dac->dela_state != XFS_DAS_RM_SHRINK &&
	    dac->dela_state != XFS_DAS_RMTVAL_REMOVE) {
		if (!xfs_inode_hasattr(dp)) {
			return -ENOATTR;
		} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
			return xfs_attr_shortform_remove(args);
		} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
			return xfs_attr_leaf_removename(dac);
		}
	}

	return xfs_attr_node_removename(dac);
}

Let me know what folks think of that.  I'm not always clear on where 
people stand with aesthetics. (IE, is it better to have a duplicate call 
if it gets rid of a label?  Is the solution with the least amount of LOC 
always preferable?)  This area seems simple enough maybe we can get it 
ironed out here with out another version.

IMHO I think the above code sort of obfuscates that the code flow is 
really just one if/else switch with one function that has the 
statemachine behavior.  But its not bad either if that's what people 
prefer.  I'd like to find something every can be sort of happy with.  :-)

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
> 
> There's no -EAGAIN return here, is this an exit path for the remove?
I think so, maybe I can remove this and the other one you pointed out in 
patch 12 along with the other unneeded transaction handling.

> 
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
> 
> Same question here.
> 
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
> 
> Seems like this moves code, which should probably happen in a separate
> patch.
Ok, this pairs with the  xfs_attr_rmtval_remove to 
__xfs_attr_rmtval_remove below.  Basically xfs_attr_rmtval_remove is the 
combination of xfs_attr_rmtval_invalidate and __xfs_attr_rmtval_remove. 
So thats why we see xfs_attr_rmtval_remove going away and 
xfs_attr_rmtval_invalidate + __xfs_attr_rmtval_remove coming in.

How about a patch that pulls xfs_attr_rmtval_invalidate out of 
xfs_attr_rmtval_remove and into the calling functions?  I think that 
might be more clear.

> 
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
> 
> I wonder if we need this label just to protect the setup. Perhaps if we
> had something like:
> 
> 	/* set up the remove only once... */
> 	if (dela_state == 0)
> 		error = xfs_attr_node_removename_setup(...);
> 
> ... we could reduce another state.
> 
> We could also accomplish the same thing with an explicit state to
> indicate the setup already occurred or a new dac flag, though I'm not
> sure a flag is appropriate if it would only be used here.
> 
> Brian

Mmmm, dela_state == 0 will conflict a bit when we get into fully delayed 
attrs.  Basically when this is getting called from the delayed 
operations path, it sets dela_state to a new XFS_DAS_INIT. Because we 
have to set up args mid fight, we need the extra state to not do that 
twice.

But even without getting into that right away, what you're proposing 
only gets rid of the label.  It doesnt get rid of the state.  We still 
have to set the state to not be zero (or what ever the initial value 
is).  So we still need the unique value of  XFS_DAS_RMTVAL_REMOVE

Really what you would need here in order to do what you are describeing 
is dela_state != XFS_DAS_RMTVAL_REMOVE.  If I assume to simplify away to 
the lease amount of LOC we get this:


STATIC int
xfs_attr_node_removename(
         struct xfs_delattr_context      *dac)
{
         struct xfs_da_args      *args = dac->da_args;
         struct xfs_da_state     *state;
         struct xfs_da_state_blk *blk;
         int                     retval, error;
         struct xfs_inode        *dp = args->dp;

         trace_xfs_attr_node_removename(args);
         state = dac->da_state;
         blk = dac->blk;

         if (dac->dela_state == XFS_DAS_RM_SHRINK) {
                 goto das_rm_shrink;
         } else if (dac->dela_state != XFS_DAS_RMTVAL_REMOVE) {
                 error = xfs_attr_node_removename_setup(dac, &state);
                 if (error)
                         goto out;
         }

         /*
          * If there is an out-of-line value, de-allocate the blocks.
          * This is done before we remove the attribute so that we don't
          * overflow the maximum size of a transaction and/or hit a 
deadlock.
          */ 

         if (args->rmtblkno > 0) {
                 error = xfs_attr_node_removename_rmt(args, state);
                 if (error) {
                         if (error == -EAGAIN)
                                 dac->dela_state = XFS_DAS_RMTVAL_REMOVE;
                         return error;
                 }
         }

.....


Let me know what folks think of this.  Again, I think I like the 
switches and the labels just because it makes it more clear where the 
jump points are, even if its more LOC.  But again, this isnt bad either 
if this is more preferable to folks.  If there's another arrangment that 
is preferable, let me know, it's not difficult to run it through the 
test cases to make sure it's functional.  It may be a faster way to hash 
out what people want to see.

Thank you again for all the reviewing!!!

Allison

> 
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_node_removename_rmt(args, state);
>> -		if (error)
>> -			goto out;
>> +		if (error) {
>> +			if (error == -EAGAIN)
>> +				dac->dela_state = XFS_DAS_RMTVAL_REMOVE;
>> +			return error;
>> +		}
>>   	}
>>   
>>   	/*
>> @@ -1291,22 +1385,20 @@ xfs_attr_node_removename(
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
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		dac->dela_state = XFS_DAS_RM_SHRINK;
>> +		return -EAGAIN;
>>   	}
>>   
>> +das_rm_shrink:
>> +	dac->dela_state = XFS_DAS_RM_SHRINK;
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		error = xfs_attr_node_shrink(args, state);
>> +		error = xfs_attr_node_shrink(dac, state);
>>   
>>   	error = 0;
>>   out:
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 66575b8..0e8ae1a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -74,6 +74,43 @@ struct xfs_attr_list_context {
>>   };
>>   
>>   
>> +/*
>> + * ========================================================================
>> + * Structure used to pass context around among the delayed routines.
>> + * ========================================================================
>> + */
>> +
>> +/*
>> + * Enum values for xfs_delattr_context.da_state
>> + *
>> + * These values are used by delayed attribute operations to keep track  of where
>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>> + * calling function to roll the transaction, and then recall the subroutine to
>> + * finish the operation.  The enum is then used by the subroutine to jump back
>> + * to where it was and resume executing where it left off.
>> + */
>> +enum xfs_delattr_state {
>> +				      /* Zero is uninitalized */
>> +	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
>> +	XFS_DAS_RMTVAL_REMOVE,	      /* We are removing remote value blocks */
>> +};
>> +
>> +/*
>> + * Defines for xfs_delattr_context.flags
>> + */
>> +#define XFS_DAC_DEFER_FINISH    0x1 /* indicates to finish the transaction */
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delattr_context {
>> +	struct xfs_da_args      *da_args;
>> +	struct xfs_da_state     *da_state;
>> +	struct xfs_da_state_blk *blk;
>> +	unsigned int            flags;
>> +	enum xfs_delattr_state  dela_state;
>> +};
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -91,6 +128,7 @@ int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> -- 
>> 2.7.4
>>
> 
