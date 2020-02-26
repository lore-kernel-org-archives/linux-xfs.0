Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E05C4BA21
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 19:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 520C221556
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 19:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UNqsQ7lr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgBZTZu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 14:25:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57264 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgBZTZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 14:25:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QJNZFN158998;
        Wed, 26 Feb 2020 19:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=b1WS9iy2XnHfBwO8+d1WLHlczauAfBvSpt+zxFp6V6w=;
 b=UNqsQ7lrIJpk7QGtldsJYYdyfTgHMUjqCqAbtxdFHDOo+DnwuCfnFH0UfyZQUqmG4j98
 MCsXkQz1ouirKJYKaXDL+jz+VEYysxb6ng6w8ZWQ9hnlr+Zt4L4iAlHM95yefak/tFpO
 eZmiYy6WG8kpTg69zOdQIlDoyNr6B2mwQ0v1OCzBVPBF9j3uDiTIpTnQIIiHPbVBJ6c0
 7GMT67JTAUO4mv+ccUUgEL7WyX7LH+Yz8Okr9mqy6MYBr4Um8polJR4bgC+jSG1CgO0M
 TQ8eI6scMLKtLfozFS9xv8/gvViQ3/hRcwzjFtydr6DkwSL3ZW+AUP1f/T9rARTM5gB4 dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ydcsnduxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 19:25:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QJDg4c061300;
        Wed, 26 Feb 2020 19:23:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ydcsagc7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 19:23:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01QJNftZ007007;
        Wed, 26 Feb 2020 19:23:41 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 11:23:41 -0800
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-14-allison.henderson@oracle.com>
 <20200224152555.GG15761@bfoster>
 <65a72135-01dd-7a7a-bfa4-5365512c3233@oracle.com>
 <20200225133426.GD21304@bfoster>
 <d1ce5ba7-99dd-82b1-a187-68dd4fab048e@oracle.com>
 <20200226134820.GB19695@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <1ba941db-9977-c4c4-c234-74b7ebc58deb@oracle.com>
Date:   Wed, 26 Feb 2020 12:23:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200226134820.GB19695@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/26/20 6:48 AM, Brian Foster wrote:
> On Tue, Feb 25, 2020 at 10:36:18PM -0700, Allison Collins wrote:
>>
>>
>> On 2/25/20 6:34 AM, Brian Foster wrote:
>>> On Mon, Feb 24, 2020 at 04:14:48PM -0700, Allison Collins wrote:
>>>> On 2/24/20 8:25 AM, Brian Foster wrote:
>>>>> On Sat, Feb 22, 2020 at 07:06:05PM -0700, Allison Collins wrote:
>>>>>> This patch modifies the attr remove routines to be delay ready. This means they no
>>>>>> longer roll or commit transactions, but instead return -EAGAIN to have the calling
>>>>>> routine roll and refresh the transaction. In this series, xfs_attr_remove_args has
>>>>>> become xfs_attr_remove_iter, which uses a sort of state machine like switch to keep
>>>>>> track of where it was when EAGAIN was returned. xfs_attr_node_removename has also
>>>>>> been modified to use the switch, and a  new version of xfs_attr_remove_args
>>>>>> consists of a simple loop to refresh the transaction until the operation is
>>>>>> completed.
>>>>>>
>>>>>> This patch also adds a new struct xfs_delattr_context, which we will use to keep
>>>>>> track of the current state of an attribute operation. The new xfs_delattr_state
>>>>>> enum is used to track various operations that are in progress so that we know not
>>>>>> to repeat them, and resume where we left off before EAGAIN was returned to cycle
>>>>>> out the transaction. Other members take the place of local variables that need
>>>>>> to retain their values across multiple function recalls.
>>>>>>
>>>>>> Below is a state machine diagram for attr remove operations. The XFS_DAS_* states
>>>>>> indicate places where the function would return -EAGAIN, and then immediately
>>>>>> resume from after being recalled by the calling function.  States marked as a
>>>>>> "subroutine state" indicate that they belong to a subroutine, and so the calling
>>>>>> function needs to pass them back to that subroutine to allow it to finish where
>>>>>> it left off. But they otherwise do not have a role in the calling function other
>>>>>> than just passing through.
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
>>>>>
>>>>> Wow. :P I guess I have nothing against verbose commit logs, but I wonder
>>>>> how useful this level of documentation is for a patch that shouldn't
>>>>> really change the existing flow of the operation.
>>>>
>>>> Yes Darrick had requested a diagram in the last review, so I had put this
>>>> together.  I wasnt sure where the best place to put it even was, so I put it
>>>> here at least for now.  I have no idea if there is a limit on commit message
>>>> length, but if there is, I'm pretty sure I blew right past it in this patch
>>>> and the next.  Maybe if anything it can just be here for now while we work
>>>> through things?
>>>>
>>>
>>> No problem.. if it's useful it's good to have a record of out around
>>> somewhere until the end result is more stabilized and we can determine
>>> whether this warrants a permanent home somewhere in the code.
>>>
>>>>>
>>>>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>>>>> ---
>>>>>>     fs/xfs/libxfs/xfs_attr.c     | 114 +++++++++++++++++++++++++++++++++++++------
>>>>>>     fs/xfs/libxfs/xfs_attr.h     |   1 +
>>>>>>     fs/xfs/libxfs/xfs_da_btree.h |  30 ++++++++++++
>>>>>>     fs/xfs/scrub/common.c        |   2 +
>>>>>>     fs/xfs/xfs_acl.c             |   2 +
>>>>>>     fs/xfs/xfs_attr_list.c       |   1 +
>>>>>>     fs/xfs/xfs_ioctl.c           |   2 +
>>>>>>     fs/xfs/xfs_ioctl32.c         |   2 +
>>>>>>     fs/xfs/xfs_iops.c            |   2 +
>>>>>>     fs/xfs/xfs_xattr.c           |   1 +
>>>>>>     10 files changed, 141 insertions(+), 16 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>>>> index 5d73bdf..cd3a3f7 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>>>> @@ -368,11 +368,60 @@ xfs_has_attr(
>>>>>>      */
>>>>>>     int
>>>>>>     xfs_attr_remove_args(
>>>>>> +	struct xfs_da_args	*args)
>>>>>> +{
>>>>>> +	int			error = 0;
>>>>>> +	int			err2 = 0;
>>>>>> +
>>>>>> +	do {
>>>>>> +		error = xfs_attr_remove_iter(args);
>>>>>> +		if (error && error != -EAGAIN)
>>>>>> +			goto out;
>>>>>> +
>>>>>
>>>>> I'm a little confused on the logic of this loop given that the only
>>>>> caller commits the transaction (which also finishes dfops). IOW, it
>>>>> seems we shouldn't ever need to finish/roll when error != -EAGAIN. If
>>>>> that is the case, this can be simplified to something like:
>>>> Well, we need to do it when error == -EAGAIN or 0, right? Which I think
>>>> better imitates the defer_finish routines.  That's why a lot of the existing
>>>> code that just finishes off with a transaction just sort of gets sawed off
>>>> at the end. Otherwise they would need one more state just to return -EAGAIN
>>>> as the last thing they have to do. Did that make sense?
>>>>
>>>
>>> Hmm.. I could just be missing something or not far along enough in the
>>> series. Can you point me at an example of where we need to finish/roll
>>> before the caller of xfs_attr_remove_args() commits the transaction?
>>>
>> Ok, in looking for an example, realized all such examples appear in the next
>> patch ;-)  So maybe we can get away with simplifying it in this patch.
>>
> 
> Ah, Ok. Yeah, I think that would be best so long as it is correct, since
> right now at least we have separate xfs_attr_[set|remove]_args() loop
> functions and I didn't see any code that warranted the extra roll in the
> remove path.
> 
>> For the next patch though, it's any place the roll/finish disappears, and an
>> "return -EAGAIN" does not.  For example, at the end of
>> xfs_attr_leaf_addname.
>>
> 
> I see, thanks. Hmmm... so I think that particular example is basically a
> programming pattern thing moreso than a functional requirement. I.e.,
> the current _clearflag() function clears the flag and rolls the
> transaction perhaps simply so it can be reliably used in different
> contexts. The use in the _addname() case is functionally spurious afaict
> because we roll the transaction only to make no further changes and then
> commit the final transaction in the higher level code.
> 
> I could see leaving the loop as is if this were the case for every exit
> path back to xfs_attr_set_args(), but is that really the case? If not,
> haven't we introduced a spurious roll for any zero return back to the
> _args() function? I think it might be best to fix up the loop to not
> roll on error == 0, explicitly plumb in the -EAGAIN in those spurious
> cases like _addname() where we currently roll, and then come up with a
> follow up patch to remove the ones that end up as spurious. That way
> we're not conflating too much refactoring with functional change and can
> review/document the functional change independently (i.e., if removing
> one of those rolls ends up introducing a bug, we don't have to revert an
> entire refactoring patch to restore original behavior).
> 
> Now that I think of it, the better option is probably to remove the
> xfs_trans_roll_inode() call from _addname() first, before these patches
> introduce the delay ready infrastructure, since it's already isolated as
> spurious at that point. That should be a simple patch with a
> clear/obvious explanation.
Alrighty then, got it.  I will add these suggestions into the next 
version.  Thanks again for all the reviews!

Allison

> 
> Brian
> 
>>>>>
>>>>> int
>>>>> xfs_attr_remove_args(
>>>>>            struct xfs_da_args      *args)
>>>>> {
>>>>>            int                     error;
>>>>>
>>>>>            do {
>>>>>                    error = xfs_attr_remove_iter(args);
>>>>>                    if (error != -EAGAIN)
>>>>>                            break;
>>>>>
>>>>>                    if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>>>>>                            args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
>>>>>                            error = xfs_defer_finish(&args->trans);
>>>>>                            if (error)
>>>>>                                    break;
>>>>>                    }
>>>>>
>>>>>                    error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>>>                    if (error)
>>>>>                            break;
>>>>>            } while (true);
>>>>>
>>>>>            return error;
>>>>> }
>>>>>
>>>>> That has the added benefit of eliminating the whole err2 pattern, which
>>>>> always strikes me as a landmine.
>>>>>
>>>>>> +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>>>>>
>>>>> BTW, _FINISH_TRANS also seems misnamed given that we finish deferred
>>>>> operations, not necessarily the transaction. XFS_DAC_DEFER_FINISH?
>>>> Sure, will update
>>>>
>>>>>
>>>>>> +			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
>>>>>> +
>>>>>> +			err2 = xfs_defer_finish(&args->trans);
>>>>>> +			if (err2) {
>>>>>> +				error = err2;
>>>>>> +				goto out;
>>>>>> +			}
>>>>>> +		}
>>>>>> +
>>>>>> +		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
>>>>>> +		if (err2) {
>>>>>> +			error = err2;
>>>>>> +			goto out;
>>>>>> +		}
>>>>>> +
>>>>>> +	} while (error == -EAGAIN);
>>>>>> +out:
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
>>>>>>     	struct xfs_da_args      *args)
>>>>>>     {
>>>>>>     	struct xfs_inode	*dp = args->dp;
>>>>>>     	int			error;
>>>>>> +	/* State machine switch */
>>>>>> +	switch (args->dac.dela_state) {
>>>>>> +	case XFS_DAS_RM_SHRINK:
>>>>>> +	case XFS_DAS_RMTVAL_REMOVE:
>>>>>> +		goto node;
>>>>>> +	default:
>>>>>> +		break;
>>>>>> +	}
>>>>>> +
>>>>>>     	if (!xfs_inode_hasattr(dp)) {
>>>>>>     		error = -ENOATTR;
>>>>>>     	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>>>>>> @@ -381,6 +430,7 @@ xfs_attr_remove_args(
>>>>>>     	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>>>>>     		error = xfs_attr_leaf_removename(args);
>>>>>>     	} else {
>>>>>> +node:
>>>>>>     		error = xfs_attr_node_removename(args);
>>>>>>     	}
>>>>>> @@ -895,9 +945,8 @@ xfs_attr_leaf_removename(
>>>>>>     		/* bp is gone due to xfs_da_shrink_inode */
>>>>>>     		if (error)
>>>>>>     			return error;
>>>>>> -		error = xfs_defer_finish(&args->trans);
>>>>>> -		if (error)
>>>>>> -			return error;
>>>>>> +
>>>>>> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>>>>>     	}
>>>>>>     	return 0;
>>>>>>     }
>>>>>> @@ -1218,6 +1267,11 @@ xfs_attr_node_addname(
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
>>>>>> @@ -1230,10 +1284,24 @@ xfs_attr_node_removename(
>>>>>>     	struct xfs_inode	*dp = args->dp;
>>>>>>     	trace_xfs_attr_node_removename(args);
>>>>>> +	state = args->dac.da_state;
>>>>>> +	blk = args->dac.blk;
>>>>>> +
>>>>>> +	/* State machine switch */
>>>>>> +	switch (args->dac.dela_state) {
>>>>>> +	case XFS_DAS_RMTVAL_REMOVE:
>>>>>> +		goto rm_node_blks;
>>>>>> +	case XFS_DAS_RM_SHRINK:
>>>>>> +		goto rm_shrink;
>>>>>> +	default:
>>>>>> +		break;
>>>>>> +	}
>>>>>>     	error = xfs_attr_node_hasname(args, &state);
>>>>>>     	if (error != -EEXIST)
>>>>>>     		goto out;
>>>>>> +	else
>>>>>> +		error = 0;
>>>>>
>>>>> This doesn't look necessary.
>>>> Well, at this point error has to be -EEXIST.  Which is great because we need
>>>> the attr to exist, but we dont want to return that as error for this
>>>> function.  Which can happen if error is not otherwise set.
>>>>
>>>
>>> AFAICT every codepath after this assigns error one way or another before
>>> it's returned. There's another error = 0 assignment just before the out:
>>> label.
>> Ok, I see it.  Will remove.
>>
>>>
>>>>>
>>>>>>     	/*
>>>>>>     	 * If there is an out-of-line value, de-allocate the blocks.
>>>>>> @@ -1243,6 +1311,14 @@ xfs_attr_node_removename(
>>>>>>     	blk = &state->path.blk[ state->path.active-1 ];
>>>>>>     	ASSERT(blk->bp != NULL);
>>>>>>     	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Store blk and state in the context incase we need to cycle out the
>>>>>> +	 * transaction
>>>>>> +	 */
>>>>>> +	args->dac.blk = blk;
>>>>>> +	args->dac.da_state = state;
>>>>>> +
>>>>>>     	if (args->rmtblkno > 0) {
>>>>>>     		/*
>>>>>>     		 * Fill in disk block numbers in the state structure
>>>>>> @@ -1261,13 +1337,21 @@ xfs_attr_node_removename(
>>>>>>     		if (error)
>>>>>>     			goto out;
>>>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>>>> +		error = xfs_attr_rmtval_invalidate(args);
>>>>>
>>>>> Remind me why we lose the above trans roll? I vaguely recall that this
>>>>> was intentional, but I could be mistaken...
>>>> I think we removed it in v5.  We used to have a  XFS_DAS_RM_INVALIDATE
>>>> state, but then we reasoned that because these are just in-core changes, we
>>>> didnt need it, so we eliminated this state entirely.
>>>>
>>>> Maybe i just add a comment here?  Just as a reminder
>>>>
>>>
>>> Ah, Ok. Normally I'd say document things like this in the commit log so
>>> we don't lose track, though I don't know how much space we have there.
>>> ;)
>> Ok, I'll see if I can squeeze in a few more lines :-)
>>
>>>
>>>>>
>>>>>>     		if (error)
>>>>>>     			goto out;
>>>>>> +	}
>>>>>> -		error = xfs_attr_rmtval_remove(args);
>>>>>> -		if (error)
>>>>>> -			goto out;
>>>>>> +rm_node_blks:
>>>>>> +
>>>>>> +	if (args->rmtblkno > 0) {
>>>>>> +		error = xfs_attr_rmtval_unmap(args);
>>>>>> +
>>>>>> +		if (error) {
>>>>>> +			if (error == -EAGAIN)
>>>>>> +				args->dac.dela_state = XFS_DAS_RMTVAL_REMOVE;
>>>>>
>>>>> Might be helpful for the code labels to match the state names. I.e., use
>>>>> das_rmtval_remove: for the label above.
>>>> Sure, I can update add the das prefix.
>>>>
>>>>>
>>>>>> +			return error;
>>>>>> +		}
>>>>>>     		/*
>>>>>>     		 * Refill the state structure with buffers, the prior calls
>>>>>> @@ -1293,17 +1377,15 @@ xfs_attr_node_removename(
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
>>>>>> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>>>>> +		args->dac.dela_state = XFS_DAS_RM_SHRINK;
>>>>>> +		return -EAGAIN;
>>>>>>     	}
>>>>>> +rm_shrink:
>>>>>> +	args->dac.dela_state = XFS_DAS_RM_SHRINK;
>>>>>> +
>>>>>
>>>>> There's an xfs_defer_finish() call further down this function. Should
>>>>> that be replaced with the flag?
>>>>>
>>>>> Finally, I mentioned in a previous review that this function should
>>>>> probably be further broken down before fitting in the state management
>>>>> stuff. It doesn't look like that happened so I've attached a diff that
>>>>> is just intended to give an idea of what I mean by sectioning off the
>>>>> hunks that might be able to break down into helpers. The helpers
>>>>> wouldn't contain any state management, so we create a clear separation
>>>>> between the state code and functional components.
>>>> Yes, it's xfs_attr_node_shrink in patch 15.  I moved it to another patch to
>>>> try and keep the activity in this one to a minimum.  Apologies if it
>>>> surprised you!  And then i mistakenly had taken the XFS_DAC_FINISH_TRANS
>>>> flag with it.  I meant to keep all the state machine stuff here.  Will fix!
>>>>
>>>
>>> Ok, I might have just not got there yet.
>>>
>>>> I think this initial
>>>>> refactoring would make the introduction of state much more simple
>>>>
>>>> I guess I didn't think people would be partial to introducing helpers before
>>>> or after the state logic.  I put them after in this set because the states
>>>> are visible now, so I though it would make the goal of modularizing code
>>>> between the states more clear to folks.  Do you think I should move it back
>>>> behind the state machine patches?
>>>>
>>>
>>> I do think the refactoring should be done first. This does make it more
>>> challenging for the developer (IMO) because I know I'd probably have to
>>> hack around with the state bits to have a better idea of how to refactor
>>> things in some cases, and then go back and retrofit the refactoring.
>>>
>>> The advantage is that the heavy lifting in this series becomes agnostic
>>> to the state bits. Refactoring patches are easier to review and we can
>>> make progress because there's less of a need to carry those out of tree
>>> through however many versions of the state code we'll need before
>>> getting it merged. Once the code is sufficiently factored, the state
>>> code should be much simpler to introduce and review since we hopefully
>>> won't be jumping around into the middle of functions, multiple branches
>>> of logic deep, etc.
>>>
>>> (I see Dave commented similarly on a couple of the subsequent patches. I
>>> 100% agree with the approach he describes there and that is similar to
>>> what I was trying to describe with the diff I attached in my earlier
>>> mail...)
>>>
>>> Brian
>>
>> Alrighty then, will move back.  Thanks, and thanks again for the reviews!!
>>
>> Allison
>>
>>>
>>>> (and
>>>>> perhaps alleviate the need for the huge diagram).
>>>> Well, I get the impression that people find the series sort of scary and
>>>> maybe the diagrams help them a bit.  Maybe we can take them out later after
>>>> people feel like they are comfortable with things?
>>>>
>>>> It might also be
>>>>> interesting to see how much of the result could be folded up further
>>>>> into _removename_iter()...
>>>>
>>>> Yes, I think that is the goal we're reaching for.  I will add the other
>>>> helpers I see in your diff too.
>>>>
>>>> Thanks for the reviews!
>>>> Allison
>>>>
>>>>>
>>>>> Brian
>>>>>
>>>>>>     	/*
>>>>>>     	 * If the result is small enough, push it all into the inode.
>>>>>>     	 */
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>>>> index ce7b039..ea873a5 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>>>> @@ -155,6 +155,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>>>>>>     int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>>>>>>     int xfs_has_attr(struct xfs_da_args *args);
>>>>>>     int xfs_attr_remove_args(struct xfs_da_args *args);
>>>>>> +int xfs_attr_remove_iter(struct xfs_da_args *args);
>>>>>>     int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>>>>>     		  int flags, struct attrlist_cursor_kern *cursor);
>>>>>>     bool xfs_attr_namecheck(const void *name, size_t length);
>>>>>> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
>>>>>> index 14f1be3..3c78498 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_da_btree.h
>>>>>> +++ b/fs/xfs/libxfs/xfs_da_btree.h
>>>>>> @@ -50,9 +50,39 @@ enum xfs_dacmp {
>>>>>>     };
>>>>>>     /*
>>>>>> + * Enum values for xfs_delattr_context.da_state
>>>>>> + *
>>>>>> + * These values are used by delayed attribute operations to keep track  of where
>>>>>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>>>>>> + * calling function to roll the transaction, and then recall the subroutine to
>>>>>> + * finish the operation.  The enum is then used by the subroutine to jump back
>>>>>> + * to where it was and resume executing where it left off.
>>>>>> + */
>>>>>> +enum xfs_delattr_state {
>>>>>> +	XFS_DAS_RM_SHRINK,	/* We are shrinking the tree */
>>>>>> +	XFS_DAS_RMTVAL_REMOVE,	/* We are removing remote value blocks */
>>>>>> +};
>>>>>> +
>>>>>> +/*
>>>>>> + * Defines for xfs_delattr_context.flags
>>>>>> + */
>>>>>> +#define	XFS_DAC_FINISH_TRANS	0x1 /* indicates to finish the transaction */
>>>>>> +
>>>>>> +/*
>>>>>> + * Context used for keeping track of delayed attribute operations
>>>>>> + */
>>>>>> +struct xfs_delattr_context {
>>>>>> +	struct xfs_da_state	*da_state;
>>>>>> +	struct xfs_da_state_blk *blk;
>>>>>> +	unsigned int		flags;
>>>>>> +	enum xfs_delattr_state	dela_state;
>>>>>> +};
>>>>>> +
>>>>>> +/*
>>>>>>      * Structure to ease passing around component names.
>>>>>>      */
>>>>>>     typedef struct xfs_da_args {
>>>>>> +	struct xfs_delattr_context dac; /* context used for delay attr ops */
>>>>>>     	struct xfs_da_geometry *geo;	/* da block geometry */
>>>>>>     	struct xfs_name	name;		/* name, length and argument  flags*/
>>>>>>     	uint8_t		filetype;	/* filetype of inode for directories */
>>>>>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>>>>>> index 1887605..9a649d1 100644
>>>>>> --- a/fs/xfs/scrub/common.c
>>>>>> +++ b/fs/xfs/scrub/common.c
>>>>>> @@ -24,6 +24,8 @@
>>>>>>     #include "xfs_rmap_btree.h"
>>>>>>     #include "xfs_log.h"
>>>>>>     #include "xfs_trans_priv.h"
>>>>>> +#include "xfs_da_format.h"
>>>>>> +#include "xfs_da_btree.h"
>>>>>>     #include "xfs_attr.h"
>>>>>>     #include "xfs_reflink.h"
>>>>>>     #include "scrub/scrub.h"
>>>>>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>>>>>> index 42ac847..d65e6d8 100644
>>>>>> --- a/fs/xfs/xfs_acl.c
>>>>>> +++ b/fs/xfs/xfs_acl.c
>>>>>> @@ -10,6 +10,8 @@
>>>>>>     #include "xfs_trans_resv.h"
>>>>>>     #include "xfs_mount.h"
>>>>>>     #include "xfs_inode.h"
>>>>>> +#include "xfs_da_format.h"
>>>>>> +#include "xfs_da_btree.h"
>>>>>>     #include "xfs_attr.h"
>>>>>>     #include "xfs_trace.h"
>>>>>>     #include "xfs_error.h"
>>>>>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>>>>>> index d37743b..881b9a4 100644
>>>>>> --- a/fs/xfs/xfs_attr_list.c
>>>>>> +++ b/fs/xfs/xfs_attr_list.c
>>>>>> @@ -12,6 +12,7 @@
>>>>>>     #include "xfs_trans_resv.h"
>>>>>>     #include "xfs_mount.h"
>>>>>>     #include "xfs_da_format.h"
>>>>>> +#include "xfs_da_btree.h"
>>>>>>     #include "xfs_inode.h"
>>>>>>     #include "xfs_trans.h"
>>>>>>     #include "xfs_bmap.h"
>>>>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>>>>> index 28c07c9..7c1d9da 100644
>>>>>> --- a/fs/xfs/xfs_ioctl.c
>>>>>> +++ b/fs/xfs/xfs_ioctl.c
>>>>>> @@ -15,6 +15,8 @@
>>>>>>     #include "xfs_iwalk.h"
>>>>>>     #include "xfs_itable.h"
>>>>>>     #include "xfs_error.h"
>>>>>> +#include "xfs_da_format.h"
>>>>>> +#include "xfs_da_btree.h"
>>>>>>     #include "xfs_attr.h"
>>>>>>     #include "xfs_bmap.h"
>>>>>>     #include "xfs_bmap_util.h"
>>>>>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>>>>>> index 769581a..d504f8f 100644
>>>>>> --- a/fs/xfs/xfs_ioctl32.c
>>>>>> +++ b/fs/xfs/xfs_ioctl32.c
>>>>>> @@ -17,6 +17,8 @@
>>>>>>     #include "xfs_itable.h"
>>>>>>     #include "xfs_fsops.h"
>>>>>>     #include "xfs_rtalloc.h"
>>>>>> +#include "xfs_da_format.h"
>>>>>> +#include "xfs_da_btree.h"
>>>>>>     #include "xfs_attr.h"
>>>>>>     #include "xfs_ioctl.h"
>>>>>>     #include "xfs_ioctl32.h"
>>>>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>>>>> index e85bbf5..a2d299f 100644
>>>>>> --- a/fs/xfs/xfs_iops.c
>>>>>> +++ b/fs/xfs/xfs_iops.c
>>>>>> @@ -13,6 +13,8 @@
>>>>>>     #include "xfs_inode.h"
>>>>>>     #include "xfs_acl.h"
>>>>>>     #include "xfs_quota.h"
>>>>>> +#include "xfs_da_format.h"
>>>>>> +#include "xfs_da_btree.h"
>>>>>>     #include "xfs_attr.h"
>>>>>>     #include "xfs_trans.h"
>>>>>>     #include "xfs_trace.h"
>>>>>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>>>>>> index 74133a5..d8dc72d 100644
>>>>>> --- a/fs/xfs/xfs_xattr.c
>>>>>> +++ b/fs/xfs/xfs_xattr.c
>>>>>> @@ -10,6 +10,7 @@
>>>>>>     #include "xfs_log_format.h"
>>>>>>     #include "xfs_da_format.h"
>>>>>>     #include "xfs_inode.h"
>>>>>> +#include "xfs_da_btree.h"
>>>>>>     #include "xfs_attr.h"
>>>>>>     #include "xfs_acl.h"
>>>>>> -- 
>>>>>> 2.7.4
>>>>>>
>>>>>
>>>>
>>>
>>
> 
