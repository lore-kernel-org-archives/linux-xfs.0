Return-Path: <SRS0=bcFD=6A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A946C2BA2B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Apr 2020 22:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C5332078B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Apr 2020 22:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fLuefIy2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgDPWnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 18:43:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47480 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbgDPWny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Apr 2020 18:43:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GMbxAH049502;
        Thu, 16 Apr 2020 22:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EQNE6AMjmtjSJAOhef3KICNsRke9wPKdyJymopuRknw=;
 b=fLuefIy28HC/+//aPuEv+XjKF/gzlkXHbngJm+31C/uKW8fnBmqazTd6P7DEEdSsqgI8
 BopYdJvfN+IPXFAzdfaSpp8Yde1s67g50rmEZxktmCbk/nepw7usIs/Jrwa6HTpe7RRJ
 21aHHPMU7lo0mB/n87RJH4t6teGlDe/BTQaUXXywIOE+4M6UPPVmpHlX1vZJPZNVWtD1
 n1Up6yBompL4AZvaqE0H/FObuR85anPhqCA9H0bgQ6QFWbXaGRyds57ZcfewM80rlKH3
 nr/ZEvcz2HtKEgWROBV964Ch06n9OtYkzpB+5TWKDyjZrAO3UiALXWr1vRfrcIS+AQ/9 Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30emejm155-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 22:43:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GMbLdD123826;
        Thu, 16 Apr 2020 22:41:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30dn90cd45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 22:41:48 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03GMfkSJ000377;
        Thu, 16 Apr 2020 22:41:47 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Apr 2020 15:41:46 -0700
Subject: Re: [PATCH v8 18/20] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-19-allison.henderson@oracle.com>
 <20200413123021.GA57285@bfoster>
 <4c38d38f-ad8a-24dc-9d00-815fc433dfdb@oracle.com>
 <20200415114603.GB2140@bfoster>
 <8660ee8d-5b51-a400-aa2d-be8536d82602@oracle.com>
 <20200416105832.GA6945@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <3fe45a6c-877a-c8b0-a17e-d6e1187f8d50@oracle.com>
Date:   Thu, 16 Apr 2020 15:41:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200416105832.GA6945@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004160157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/16/20 3:58 AM, Brian Foster wrote:
> On Wed, Apr 15, 2020 at 08:17:07PM -0700, Allison Collins wrote:
>>
>>
>> On 4/15/20 4:46 AM, Brian Foster wrote:
>>> On Tue, Apr 14, 2020 at 02:35:43PM -0700, Allison Collins wrote:
>>>>
>>>>
>>>> On 4/13/20 5:30 AM, Brian Foster wrote:
>>>>> On Fri, Apr 03, 2020 at 03:12:27PM -0700, Allison Collins wrote:
>>>>>> This patch modifies the attr remove routines to be delay ready. This
>>>>>> means they no longer roll or commit transactions, but instead return
>>>>>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>>>>>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>>>>>> uses a sort of state machine like switch to keep track of where it was
>>>>>> when EAGAIN was returned. xfs_attr_node_removename has also been
>>>>>> modified to use the switch, and a new version of xfs_attr_remove_args
>>>>>> consists of a simple loop to refresh the transaction until the operation
>>>>>> is completed.
>>>>>>
>>>>>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>>>>>> counter parts: xfs_attr_rmtval_invalidate (appearing in the setup
>>>>>> helper) and then __xfs_attr_rmtval_remove. We will rename
>>>>>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>>>>>> done.
>>>>>>
>>>>>> This patch also adds a new struct xfs_delattr_context, which we will use
>>>>>> to keep track of the current state of an attribute operation. The new
>>>>>> xfs_delattr_state enum is used to track various operations that are in
>>>>>> progress so that we know not to repeat them, and resume where we left
>>>>>> off before EAGAIN was returned to cycle out the transaction. Other
>>>>>> members take the place of local variables that need to retain their
>>>>>> values across multiple function recalls.
>>>>>>
>>>>>> Below is a state machine diagram for attr remove operations. The
>>>>>> XFS_DAS_* states indicate places where the function would return
>>>>>> -EAGAIN, and then immediately resume from after being recalled by the
>>>>>> calling function.  States marked as a "subroutine state" indicate that
>>>>>> they belong to a subroutine, and so the calling function needs to pass
>>>>>> them back to that subroutine to allow it to finish where it left off.
>>>>>> But they otherwise do not have a role in the calling function other than
>>>>>> just passing through.
>>>>>>
>>>>>>     xfs_attr_remove_iter()
>>>>>>             XFS_DAS_RM_SHRINK     ─┐
>>>>>>             (subroutine state)     │
>>>>>>                                    │
>>>>>>             XFS_DAS_RMTVAL_REMOVE ─┤
>>>>>>             (subroutine state)     │
>>>>>>                                    └─>xfs_attr_node_removename()
>>>>>>                                                     │
>>>>>>                                                     v
>>>>>>                                             need to remove
>>>>>>                                       ┌─n──  rmt blocks?
>>>>>>                                       │             │
>>>>>>                                       │             y
>>>>>>                                       │             │
>>>>>>                                       │             v
>>>>>>                                       │  ┌─>XFS_DAS_RMTVAL_REMOVE
>>>>>>                                       │  │          │
>>>>>>                                       │  │          v
>>>>>>                                       │  └──y── more blks
>>>>>>                                       │         to remove?
>>>>>>                                       │             │
>>>>>>                                       │             n
>>>>>>                                       │             │
>>>>>>                                       │             v
>>>>>>                                       │         need to
>>>>>>                                       └─────> shrink tree? ─n─┐
>>>>>>                                                     │         │
>>>>>>                                                     y         │
>>>>>>                                                     │         │
>>>>>>                                                     v         │
>>>>>>                                             XFS_DAS_RM_SHRINK │
>>>>>>                                                     │         │
>>>>>>                                                     v         │
>>>>>>                                                    done <─────┘
>>>>>>
>>>>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>>>>> ---
>>>>>
>>>>> All in all this is starting to look much more simple to me, at least in
>>>>> the remove path. ;P There's only a few states and the markers that are
>>>>> introduced are fairly straightforward, etc. Comments to follow..
>>>>>
>>>>>>     fs/xfs/libxfs/xfs_attr.c | 168 ++++++++++++++++++++++++++++++++++++-----------
>>>>>>     fs/xfs/libxfs/xfs_attr.h |  38 +++++++++++
>>>>>>     2 files changed, 168 insertions(+), 38 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>>>> index d735570..f700976 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>>>> @@ -45,7 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>>>>>      */
>>>>>>     STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>>>>>     STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>>>>>> -STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>>>>> +STATIC int xfs_attr_leaf_removename(struct xfs_delattr_context *dac);
>>>>>>     STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>>>>     /*
>>>>>> @@ -53,12 +53,21 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>>>>      */
>>>>>>     STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>>>>>     STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>>>>> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>>>>> +STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
>>>>>>     STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>>>>     				 struct xfs_da_state **state);
>>>>>>     STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>>>>     STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>>>>> +STATIC void
>>>>>> +xfs_delattr_context_init(
>>>>>> +	struct xfs_delattr_context	*dac,
>>>>>> +	struct xfs_da_args		*args)
>>>>>> +{
>>>>>> +	memset(dac, 0, sizeof(struct xfs_delattr_context));
>>>>>> +	dac->da_args = args;
>>>>>> +}
>>>>>> +
>>>>>>     int
>>>>>>     xfs_inode_hasattr(
>>>>>>     	struct xfs_inode	*ip)
>>>>>> @@ -356,20 +365,66 @@ xfs_has_attr(
>>>>>>      */
>>>>>>     int
>>>>>>     xfs_attr_remove_args(
>>>>>> -	struct xfs_da_args      *args)
>>>>>> +	struct xfs_da_args	*args)
>>>>>>     {
>>>>>> +	int			error = 0;
>>>>>> +	struct			xfs_delattr_context dac;
>>>>>> +
>>>>>> +	xfs_delattr_context_init(&dac, args);
>>>>>> +
>>>>>> +	do {
>>>>>> +		error = xfs_attr_remove_iter(&dac);
>>>>>> +		if (error != -EAGAIN)
>>>>>> +			break;
>>>>>> +
>>>>>> +		if (dac.flags & XFS_DAC_DEFER_FINISH) {
>>>>>> +			dac.flags &= ~XFS_DAC_DEFER_FINISH;
>>>>>> +			error = xfs_defer_finish(&args->trans);
>>>>>> +			if (error)
>>>>>> +				break;
>>>>>> +		}
>>>>>> +
>>>>>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>>>> +		if (error)
>>>>>> +			break;
>>>>>> +	} while (true);
>>>>>> +
>>>>>> +	return error;
>>>>>> +}
>>>>>> +
>>>>>> +/*
>>>>>> + * Remove the attribute specified in @args.
>>>>>> + *
>>>>>> + * This function may return -EAGAIN to signal that the transaction needs to be
>>>>>> + * rolled.  Callers should continue calling this function until they receive a
>>>>>> + * return value other than -EAGAIN.
>>>>>> + */
>>>>>> +int
>>>>>> +xfs_attr_remove_iter(
>>>>>> +	struct xfs_delattr_context *dac)
>>>>>> +{
>>>>>> +	struct xfs_da_args	*args = dac->da_args;
>>>>>>     	struct xfs_inode	*dp = args->dp;
>>>>>>     	int			error;
>>>>>> +	/* State machine switch */
>>>>>> +	switch (dac->dela_state) {
>>>>>> +	case XFS_DAS_RM_SHRINK:
>>>>>> +	case XFS_DAS_RMTVAL_REMOVE:
>>>>>> +		return xfs_attr_node_removename(dac);
>>>>>> +	default:
>>>>>> +		break;
>>>>>> +	}
>>>>>> +
>>>>>
>>>>> Hmm.. so we're duplicating the call instead of using labels..?
>>>>
>>>> Yes, this was a suggestion made during v7.  I suspect Dave may have been
>>>> wanting to simplify things by escaping the use of labels.  At least in so
>>>> far as the remove path is concerned.  Though he may not have realized this
>>>> would create a duplication call?  I will cc him here; the conditions for
>>>> calling xfs_attr_node_removename are: the below if/else sequence exhausts
>>>> with no successes, and defaults into the else case (ie: the entry
>>>> condition), OR one of the above states is set (which is a re-entry
>>>> condition)
>>>>
>>>
>>> Ok.
>>>
>>>>
>>>> I'm
>>>>> wondering if this can be elegantly combined with the if/else branches
>>>>> below, particularly since node format is the only situation that seems
>>>>> to require a roll here.
>>>>>
>>>>>>     	if (!xfs_inode_hasattr(dp)) {
>>>>>>     		error = -ENOATTR;
>>>>>>     	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>>>>>>     		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>>>>>>     		error = xfs_attr_shortform_remove(args);
>>>>>>     	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>>>>> -		error = xfs_attr_leaf_removename(args);
>>>>>> +		error = xfs_attr_leaf_removename(dac);
>>>>>>     	} else {
>>>>>> -		error = xfs_attr_node_removename(args);
>>>>>> +		error = xfs_attr_node_removename(dac);
>>>>>>     	}
>>>>>>     	return error;
>>>>
>>>> If we want to try and combine this into if/elses with no duplication, I
>>>> believe the simplest arrangement would look something like this:
>>>>
>>>>
>>>> int
>>>> xfs_attr_remove_iter(
>>>> 	struct xfs_delattr_context *dac)
>>>> {
>>>> 	struct xfs_da_args	*args = dac->da_args;
>>>> 	struct xfs_inode	*dp = args->dp;
>>>>
>>>> 	if (dac->dela_state != XFS_DAS_RM_SHRINK &&
>>>> 	    dac->dela_state != XFS_DAS_RMTVAL_REMOVE) {
>>>> 		if (!xfs_inode_hasattr(dp)) {
>>>> 			return -ENOATTR;
>>>> 		} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>>>> 			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>>>> 			return xfs_attr_shortform_remove(args);
>>>> 		} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>>> 			return xfs_attr_leaf_removename(dac);
>>>> 		}
>>>> 	}
>>>>
>>>> 	return xfs_attr_node_removename(dac);
>>>> }
>>>>
>>>> Let me know what folks think of that.  I'm not always clear on where people
>>>> stand with aesthetics. (IE, is it better to have a duplicate call if it gets
>>>> rid of a label?  Is the solution with the least amount of LOC always
>>>> preferable?)  This area seems simple enough maybe we can get it ironed out
>>>> here with out another version.
>>>>
>>>> IMHO I think the above code sort of obfuscates that the code flow is really
>>>> just one if/else switch with one function that has the statemachine
>>>> behavior.  But its not bad either if that's what people prefer.  I'd like to
>>>> find something every can be sort of happy with.  :-)
>>>>
>>>
>>> If you want my .02, some combination of the above is cleanest from an
>>> aesthetic pov:
>>>
>>> {
>>> 	...
>>> 	if (RM_SHRINK || RMTVAL_REMOVE)
>>> 		goto node;
>>>
>>> 	if (!hasattr)
>>> 		return -ENOATTR;
>>> 	else if (local)
>>> 		return shortform_remove();
>>> 	else if (oneblock)
>>> 		return leaf_removename();
>>>
>>> node:
>>> 	return node_removename();
>>> }
>>>
>>> I find that easiest to read at a glance, but I don't feel terribly
>>> strongly about it I guess.
>>
>> I am entirely fine with that if everyone else is :-)
>>
>>>
>>>>>> @@ -794,11 +849,12 @@ xfs_attr_leaf_hasname(
>>>>>>      */
>>>>>>     STATIC int
>>>>>>     xfs_attr_leaf_removename(
>>>>>> -	struct xfs_da_args	*args)
>>>>>> +	struct xfs_delattr_context	*dac)
>>>>>>     {
>>>>>> -	struct xfs_inode	*dp;
>>>>>> -	struct xfs_buf		*bp;
>>>>>> -	int			error, forkoff;
>>>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>>>> +	struct xfs_inode		*dp;
>>>>>> +	struct xfs_buf			*bp;
>>>>>> +	int				error, forkoff;
>>>>>>     	trace_xfs_attr_leaf_removename(args);
>>>>>> @@ -825,9 +881,8 @@ xfs_attr_leaf_removename(
>>>>>>     		/* bp is gone due to xfs_da_shrink_inode */
>>>>>>     		if (error)
>>>>>>     			return error;
>>>>>> -		error = xfs_defer_finish(&args->trans);
>>>>>> -		if (error)
>>>>>> -			return error;
>>>>>> +
>>>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>>
>>>>> There's no -EAGAIN return here, is this an exit path for the remove?
>>>> I think so, maybe I can remove this and the other one you pointed out in
>>>> patch 12 along with the other unneeded transaction handling.
>>>>
>>>>>
>>>>>>     	}
>>>>>>     	return 0;
>>>>>>     }
>>>>>> @@ -1128,12 +1183,13 @@ xfs_attr_node_addname(
>>>>>>      */
>>>>>>     STATIC int
>>>>>>     xfs_attr_node_shrink(
>>>>>> -	struct xfs_da_args	*args,
>>>>>> -	struct xfs_da_state     *state)
>>>>>> +	struct xfs_delattr_context	*dac,
>>>>>> +	struct xfs_da_state		*state)
>>>>>>     {
>>>>>> -	struct xfs_inode	*dp = args->dp;
>>>>>> -	int			error, forkoff;
>>>>>> -	struct xfs_buf		*bp;
>>>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>>>> +	struct xfs_inode		*dp = args->dp;
>>>>>> +	int				error, forkoff;
>>>>>> +	struct xfs_buf			*bp;
>>>>>>     	/*
>>>>>>     	 * Have to get rid of the copy of this dabuf in the state.
>>>>>> @@ -1153,9 +1209,7 @@ xfs_attr_node_shrink(
>>>>>>     		if (error)
>>>>>>     			return error;
>>>>>> -		error = xfs_defer_finish(&args->trans);
>>>>>> -		if (error)
>>>>>> -			return error;
>>>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>>
>>>>> Same question here.
>>>>>
>>>>>>     	} else
>>>>>>     		xfs_trans_brelse(args->trans, bp);
>>>>>> @@ -1194,13 +1248,15 @@ xfs_attr_leaf_mark_incomplete(
>>>>>>     /*
>>>>>>      * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
>>>>>> - * the blocks are valid.  Any remote blocks will be marked incomplete.
>>>>>> + * the blocks are valid.  Any remote blocks will be marked incomplete and
>>>>>> + * invalidated.
>>>>>>      */
>>>>>>     STATIC
>>>>>>     int xfs_attr_node_removename_setup(
>>>>>> -	struct xfs_da_args	*args,
>>>>>> -	struct xfs_da_state	**state)
>>>>>> +	struct xfs_delattr_context	*dac,
>>>>>> +	struct xfs_da_state		**state)
>>>>>>     {
>>>>>> +	struct xfs_da_args	*args = dac->da_args;
>>>>>>     	int			error;
>>>>>>     	struct xfs_da_state_blk	*blk;
>>>>>> @@ -1212,10 +1268,21 @@ int xfs_attr_node_removename_setup(
>>>>>>     	ASSERT(blk->bp != NULL);
>>>>>>     	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>>>>> +	/*
>>>>>> +	 * Store blk and state in the context incase we need to cycle out the
>>>>>> +	 * transaction
>>>>>> +	 */
>>>>>> +	dac->blk = blk;
>>>>>> +	dac->da_state = *state;
>>>>>> +
>>>>>>     	if (args->rmtblkno > 0) {
>>>>>>     		error = xfs_attr_leaf_mark_incomplete(args, *state);
>>>>>>     		if (error)
>>>>>>     			return error;
>>>>>> +
>>>>>> +		error = xfs_attr_rmtval_invalidate(args);
>>>>>> +		if (error)
>>>>>> +			return error;
>>>>>
>>>>> Seems like this moves code, which should probably happen in a separate
>>>>> patch.
>>>> Ok, this pairs with the  xfs_attr_rmtval_remove to __xfs_attr_rmtval_remove
>>>> below.  Basically xfs_attr_rmtval_remove is the combination of
>>>> xfs_attr_rmtval_invalidate and __xfs_attr_rmtval_remove. So thats why we see
>>>> xfs_attr_rmtval_remove going away and xfs_attr_rmtval_invalidate +
>>>> __xfs_attr_rmtval_remove coming in.
>>>>
>>>> How about a patch that pulls xfs_attr_rmtval_invalidate out of
>>>> xfs_attr_rmtval_remove and into the calling functions?  I think that might
>>>> be more clear.
>>>>
>>>
>>> Yes, separate patch please. I think that if the earlier refactoring
>>> parts of the series are split out properly (i.e., no dependencies on
>>> subsequent patches) and reviewed, perhaps we can start getting some of
>>> those patches merged while the latter bits are worked out.
>> Ok then, will do
>>
>>>
>>>>>
>>>>>>     	}
>>>>>>     	return 0;
>>>>>> @@ -1228,7 +1295,10 @@ xfs_attr_node_removename_rmt (
>>>>>>     {
>>>>>>     	int			error = 0;
>>>>>> -	error = xfs_attr_rmtval_remove(args);
>>>>>> +	/*
>>>>>> +	 * May return -EAGAIN to request that the caller recall this function
>>>>>> +	 */
>>>>>> +	error = __xfs_attr_rmtval_remove(args);
>>>>>>     	if (error)
>>>>>>     		return error;
>>>>>> @@ -1249,19 +1319,37 @@ xfs_attr_node_removename_rmt (
>>>>>>      * This will involve walking down the Btree, and may involve joining
>>>>>>      * leaf nodes and even joining intermediate nodes up to and including
>>>>>>      * the root node (a special case of an intermediate node).
>>>>>> + *
>>>>>> + * This routine is meant to function as either an inline or delayed operation,
>>>>>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>>>>>> + * functions will need to handle this, and recall the function until a
>>>>>> + * successful error code is returned.
>>>>>>      */
>>>>>>     STATIC int
>>>>>>     xfs_attr_node_removename(
>>>>>> -	struct xfs_da_args	*args)
>>>>>> +	struct xfs_delattr_context	*dac)
>>>>>>     {
>>>>>> +	struct xfs_da_args	*args = dac->da_args;
>>>>>>     	struct xfs_da_state	*state;
>>>>>>     	struct xfs_da_state_blk	*blk;
>>>>>>     	int			retval, error;
>>>>>>     	struct xfs_inode	*dp = args->dp;
>>>>>>     	trace_xfs_attr_node_removename(args);
>>>>>> +	state = dac->da_state;
>>>>>> +	blk = dac->blk;
>>>>>> +
>>>>>> +	/* State machine switch */
>>>>>> +	switch (dac->dela_state) {
>>>>>> +	case XFS_DAS_RMTVAL_REMOVE:
>>>>>> +		goto das_rmtval_remove;
>>>>>> +	case XFS_DAS_RM_SHRINK:
>>>>>> +		goto das_rm_shrink;
>>>>>> +	default:
>>>>>> +		break;
>>>>>> +	}
>>>>>> -	error = xfs_attr_node_removename_setup(args, &state);
>>>>>> +	error = xfs_attr_node_removename_setup(dac, &state);
>>>>>>     	if (error)
>>>>>>     		goto out;
>>>>>> @@ -1270,10 +1358,16 @@ xfs_attr_node_removename(
>>>>>>     	 * This is done before we remove the attribute so that we don't
>>>>>>     	 * overflow the maximum size of a transaction and/or hit a deadlock.
>>>>>>     	 */
>>>>>> +
>>>>>> +das_rmtval_remove:
>>>>>> +
>>>>>
>>>>> I wonder if we need this label just to protect the setup. Perhaps if we
>>>>> had something like:
>>>>>
>>>>> 	/* set up the remove only once... */
>>>>> 	if (dela_state == 0)
>>>>> 		error = xfs_attr_node_removename_setup(...);
>>>>>
>>>>> ... we could reduce another state.
>>>>>
>>>>> We could also accomplish the same thing with an explicit state to
>>>>> indicate the setup already occurred or a new dac flag, though I'm not
>>>>> sure a flag is appropriate if it would only be used here.
>>>>>
>>>>> Brian
>>>>
>>>> Mmmm, dela_state == 0 will conflict a bit when we get into fully delayed
>>>> attrs.  Basically when this is getting called from the delayed operations
>>>> path, it sets dela_state to a new XFS_DAS_INIT. Because we have to set up
>>>> args mid fight, we need the extra state to not do that twice.
>>>>
>>>
>>> Can we address that when the conflict is introduced?
>> Sure, i was just looking ahead, but focus should stay here
>>
>>>
>>>> But even without getting into that right away, what you're proposing only
>>>> gets rid of the label.  It doesnt get rid of the state.  We still have to
>>>> set the state to not be zero (or what ever the initial value is).  So we
>>>> still need the unique value of  XFS_DAS_RMTVAL_REMOVE
>>>>
>>>
>>> Yeah, I was partly thinking of the setup call being tied to a flag
>>> rather than a state. That way the logic is something like the typical:
>>>
>>> 	if (!setup)
>>> 		do_setup();
>>> 	...
>>>
>>> ... and it's one less bit of code tied into the state machine. All in
>>> all, it's more that having a label right at the top of a function like
>>> that kind of looks like it's asking for some form of simplification.
>> Ok, this is similar to the discussion going on in the next patch.  To be
>> clear, if we add a flag, we need to keep it in the delay_attr_context so
>> that it persists across re-calls.  We dont want multiple functions shareing
>> the same setup flag, so really we're talking about a new flag scheme like
>> XFS_DAC_SETUP_* for any function that needs a set up flag? Is that what you
>> had in mind?
>>
> 
> Yep, pretty much. It's not clear to me if we can reuse one general INIT
> flag across operations or need several such flags, but I'm not sure I
> understand why we couldn't reuse the existing dac->flags at least..
> 
> Brian

Ok, I think I likely answered this in the discussion for the next patch. 
  I forgot I had already added a flag member to the delay attr context, 
I will move forward with an init flag scheme.  Thanks again for all the 
reviewing!

Allison

> 
>>>
>>>> Really what you would need here in order to do what you are describeing is
>>>> dela_state != XFS_DAS_RMTVAL_REMOVE.  If I assume to simplify away to the
>>>> lease amount of LOC we get this:
>>>>
>>>>
>>>> STATIC int
>>>> xfs_attr_node_removename(
>>>>           struct xfs_delattr_context      *dac)
>>>> {
>>>>           struct xfs_da_args      *args = dac->da_args;
>>>>           struct xfs_da_state     *state;
>>>>           struct xfs_da_state_blk *blk;
>>>>           int                     retval, error;
>>>>           struct xfs_inode        *dp = args->dp;
>>>>
>>>>           trace_xfs_attr_node_removename(args);
>>>>           state = dac->da_state;
>>>>           blk = dac->blk;
>>>>
>>>>           if (dac->dela_state == XFS_DAS_RM_SHRINK) {
>>>>                   goto das_rm_shrink;
>>>>           } else if (dac->dela_state != XFS_DAS_RMTVAL_REMOVE) {
>>>>                   error = xfs_attr_node_removename_setup(dac, &state);
>>>>                   if (error)
>>>>                           goto out;
>>>>           }
>>>>
>>>>           /*
>>>>            * If there is an out-of-line value, de-allocate the blocks.
>>>>            * This is done before we remove the attribute so that we don't
>>>>            * overflow the maximum size of a transaction and/or hit a deadlock.
>>>>            */
>>>>
>>>>           if (args->rmtblkno > 0) {
>>>>                   error = xfs_attr_node_removename_rmt(args, state);
>>>>                   if (error) {
>>>>                           if (error == -EAGAIN)
>>>>                                   dac->dela_state = XFS_DAS_RMTVAL_REMOVE;
>>>>                           return error;
>>>>                   }
>>>>           }
>>>>
>>>> .....
>>>>
>>>>
>>>> Let me know what folks think of this.  Again, I think I like the switches
>>>> and the labels just because it makes it more clear where the jump points
>>>> are, even if its more LOC.  But again, this isnt bad either if this is more
>>>> preferable to folks.  If there's another arrangment that is preferable, let
>>>> me know, it's not difficult to run it through the test cases to make sure
>>>> it's functional.  It may be a faster way to hash out what people want to
>>>> see.
>>>>
>>>
>>> I prefer to see the state management stuff as boilerplate as possible.
>>> The above pattern of creating separate reentry calls to the same
>>> functions is not nearly as clear to me, particularly in this instance
>>> where we have multiple branches of reentry logic (as opposed to the
>>> earlier example of only one).
>>>
>>> IOW, I agree that the jumps are preferable and more intuitive. I'm just
>>> trying to be reductive by considering what could be factored out vs.
>>> trying to fundamentally rework the approach or aggressively reduce LOC
>>> or anything like that. IMO, simplicity of the code is usually top
>>> priority.
>>>
>>> Brian
>>
>> Ok, lets firm up what we want this setup flag to look like, and then we can
>> simplify the current label and goto scheme :-)
>>
>> Thank you!!
>> Allison
>>
>>
>>>
>>>> Thank you again for all the reviewing!!!
>>>>
>>>> Allison
>>>>
>>>>>
>>>>>>     	if (args->rmtblkno > 0) {
>>>>>>     		error = xfs_attr_node_removename_rmt(args, state);
>>>>>> -		if (error)
>>>>>> -			goto out;
>>>>>> +		if (error) {
>>>>>> +			if (error == -EAGAIN)
>>>>>> +				dac->dela_state = XFS_DAS_RMTVAL_REMOVE;
>>>>>> +			return error;
>>>>>> +		}
>>>>>>     	}
>>>>>>     	/*
>>>>>> @@ -1291,22 +1385,20 @@ xfs_attr_node_removename(
>>>>>>     		error = xfs_da3_join(state);
>>>>>>     		if (error)
>>>>>>     			goto out;
>>>>>> -		error = xfs_defer_finish(&args->trans);
>>>>>> -		if (error)
>>>>>> -			goto out;
>>>>>> -		/*
>>>>>> -		 * Commit the Btree join operation and start a new trans.
>>>>>> -		 */
>>>>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>>>>> -		if (error)
>>>>>> -			goto out;
>>>>>> +
>>>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>>> +		dac->dela_state = XFS_DAS_RM_SHRINK;
>>>>>> +		return -EAGAIN;
>>>>>>     	}
>>>>>> +das_rm_shrink:
>>>>>> +	dac->dela_state = XFS_DAS_RM_SHRINK;
>>>>>> +
>>>>>>     	/*
>>>>>>     	 * If the result is small enough, push it all into the inode.
>>>>>>     	 */
>>>>>>     	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>>>> -		error = xfs_attr_node_shrink(args, state);
>>>>>> +		error = xfs_attr_node_shrink(dac, state);
>>>>>>     	error = 0;
>>>>>>     out:
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>>>> index 66575b8..0e8ae1a 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>>>> @@ -74,6 +74,43 @@ struct xfs_attr_list_context {
>>>>>>     };
>>>>>> +/*
>>>>>> + * ========================================================================
>>>>>> + * Structure used to pass context around among the delayed routines.
>>>>>> + * ========================================================================
>>>>>> + */
>>>>>> +
>>>>>> +/*
>>>>>> + * Enum values for xfs_delattr_context.da_state
>>>>>> + *
>>>>>> + * These values are used by delayed attribute operations to keep track  of where
>>>>>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>>>>>> + * calling function to roll the transaction, and then recall the subroutine to
>>>>>> + * finish the operation.  The enum is then used by the subroutine to jump back
>>>>>> + * to where it was and resume executing where it left off.
>>>>>> + */
>>>>>> +enum xfs_delattr_state {
>>>>>> +				      /* Zero is uninitalized */
>>>>>> +	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
>>>>>> +	XFS_DAS_RMTVAL_REMOVE,	      /* We are removing remote value blocks */
>>>>>> +};
>>>>>> +
>>>>>> +/*
>>>>>> + * Defines for xfs_delattr_context.flags
>>>>>> + */
>>>>>> +#define XFS_DAC_DEFER_FINISH    0x1 /* indicates to finish the transaction */
>>>>>> +
>>>>>> +/*
>>>>>> + * Context used for keeping track of delayed attribute operations
>>>>>> + */
>>>>>> +struct xfs_delattr_context {
>>>>>> +	struct xfs_da_args      *da_args;
>>>>>> +	struct xfs_da_state     *da_state;
>>>>>> +	struct xfs_da_state_blk *blk;
>>>>>> +	unsigned int            flags;
>>>>>> +	enum xfs_delattr_state  dela_state;
>>>>>> +};
>>>>>> +
>>>>>>     /*========================================================================
>>>>>>      * Function prototypes for the kernel.
>>>>>>      *========================================================================*/
>>>>>> @@ -91,6 +128,7 @@ int xfs_attr_set(struct xfs_da_args *args);
>>>>>>     int xfs_attr_set_args(struct xfs_da_args *args);
>>>>>>     int xfs_has_attr(struct xfs_da_args *args);
>>>>>>     int xfs_attr_remove_args(struct xfs_da_args *args);
>>>>>> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>>>>>     bool xfs_attr_namecheck(const void *name, size_t length);
>>>>>>     #endif	/* __XFS_ATTR_H__ */
>>>>>> -- 
>>>>>> 2.7.4
>>>>>>
>>>>>
>>>>
>>>
>>
> 
