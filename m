Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AB4C4742C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 05:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92DD022280
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 05:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w+AApaQy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725300AbgKPFMb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 00:12:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54046 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgKPFM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 00:12:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AG54uFv146404
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 05:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=c9qUkyx4hTwkRHhN4jEVEHQ2C0/tFDxSdWl1UrC6XUQ=;
 b=w+AApaQyWJRU1sD/LTTUtlbIqnO6uQIPMdT2zIst3dJluMwIUdIF7ARL5SptlU//MiTk
 k72jAQs1ene4F0jvQ6+U5Z+8LXUd1HoeokRbBI44cZu8hRe10F9QLO8fqyJsc1qCfDS9
 MwpJboNKVV+LzGbyR0eZABvavWnXQgVt0Puyf3SfhgRlA3UUyFVjBOoTQTeQOkAlCsOH
 kE9ZAPRScTW0AssZq+AvKiXH0wVEzxYQO0L5b2ZqkbkEdsHQd0eSkrmD0FdhiGmdpZHo
 z5CRrLvQFDYdsI15vjRbqt36BsCjbEgdEfQvkbzyTa/jJ+7p4iYDVbGBBtT7Aew+H/kV BA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rakg1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 05:12:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AG56SB6049001
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 05:12:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34ts5u8ptu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 05:12:23 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AG5CMpg001819
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 05:12:22 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Nov 2020 21:12:22 -0800
Subject: Re: [PATCH v13 02/10] xfs: Add delay ready attr remove routines
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-3-allison.henderson@oracle.com>
 <20201110234331.GL9695@magnolia>
 <327c218c-2937-9b96-87cd-3b96080cbe79@oracle.com>
 <20201114011820.GG9699@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <561e99f0-5495-a14b-f74f-f78a0650ee02@oracle.com>
Date:   Sun, 15 Nov 2020 22:12:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201114011820.GG9699@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9806 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=2 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9806 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=2 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160031
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/13/20 6:18 PM, Darrick J. Wong wrote:
> On Thu, Nov 12, 2020 at 08:43:25PM -0700, Allison Henderson wrote:
>>
>>
>> On 11/10/20 4:43 PM, Darrick J. Wong wrote:
>>> On Thu, Oct 22, 2020 at 11:34:27PM -0700, Allison Henderson wrote:
>>>> This patch modifies the attr remove routines to be delay ready. This
>>>> means they no longer roll or commit transactions, but instead return
>>>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>>>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>>>> uses a sort of state machine like switch to keep track of where it was
>>>> when EAGAIN was returned. xfs_attr_node_removename has also been
>>>> modified to use the switch, and a new version of xfs_attr_remove_args
>>>> consists of a simple loop to refresh the transaction until the operation
>>>> is completed.  A new XFS_DAC_DEFER_FINISH flag is used to finish the
>>>> transaction where ever the existing code used to.
>>>>
>>>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>>>> version __xfs_attr_rmtval_remove. We will rename
>>>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>>>> done.
>>>>
>>>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>>>> during a rename).  For reasons of preserving existing function, we
>>>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>>>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>>>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>>>> used and will be removed.
>>>>
>>>> This patch also adds a new struct xfs_delattr_context, which we will use
>>>> to keep track of the current state of an attribute operation. The new
>>>> xfs_delattr_state enum is used to track various operations that are in
>>>> progress so that we know not to repeat them, and resume where we left
>>>> off before EAGAIN was returned to cycle out the transaction. Other
>>>> members take the place of local variables that need to retain their
>>>> values across multiple function recalls.  See xfs_attr.h for a more
>>>> detailed diagram of the states.
>>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr.c        | 200 +++++++++++++++++++++++++++++-----------
>>>>    fs/xfs/libxfs/xfs_attr.h        |  72 +++++++++++++++
>>>>    fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>>>    fs/xfs/libxfs/xfs_attr_remote.c |  37 ++++----
>>>>    fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>>>    fs/xfs/xfs_attr_inactive.c      |   2 +-
>>>>    6 files changed, 241 insertions(+), 74 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index f4d39bf..6ca94cb 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>> @@ -53,7 +53,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>>     */
>>>>    STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>>>    STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>>> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>>> +STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
>>>>    STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>>    				 struct xfs_da_state **state);
>>>>    STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>> @@ -264,6 +264,33 @@ xfs_attr_set_shortform(
>>>>    }
>>>>    /*
>>>> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
>>>> + * also checks for a defer finish.  Transaction is finished and rolled as
>>>> + * needed, and returns true of false if the delayed operation should continue.
>>>> + */
>>>> +int
>>>> +xfs_attr_trans_roll(
>>>> +	struct xfs_delattr_context	*dac)
>>>> +{
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	int				error = 0;
>>>> +
>>>> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>>>> +		/*
>>>> +		 * The caller wants us to finish all the deferred ops so that we
>>>> +		 * avoid pinning the log tail with a large number of deferred
>>>> +		 * ops.
>>>> +		 */
>>>> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>>>> +		error = xfs_defer_finish(&args->trans);
>>>> +		if (error)
>>>> +			return error;
>>>> +	}
>>>> +
>>>> +	return xfs_trans_roll_inode(&args->trans, args->dp);
>>>> +}
>>>
>>> (Mostly ignoring these functions since they all go away by the end of
>>> the patchset...)
>>>
>>>> +
>>>> +/*
>>>>     * Set the attribute specified in @args.
>>>>     */
>>>>    int
>>>> @@ -364,23 +391,54 @@ xfs_has_attr(
>>>>     */
>>>>    int
>>>>    xfs_attr_remove_args(
>>>> -	struct xfs_da_args      *args)
>>>> +	struct xfs_da_args	*args)
>>>>    {
>>>> -	struct xfs_inode	*dp = args->dp;
>>>> -	int			error;
>>>> +	int				error = 0;
>>>> +	struct xfs_delattr_context	dac = {
>>>> +		.da_args	= args,
>>>> +	};
>>>> +
>>>> +	do {
>>>> +		error = xfs_attr_remove_iter(&dac);
>>>> +		if (error != -EAGAIN)
>>>> +			break;
>>>> +
>>>> +		error = xfs_attr_trans_roll(&dac);
>>>> +		if (error)
>>>> +			return error;
>>>> +
>>>> +	} while (true);
>>>> +
>>>> +	return error;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Remove the attribute specified in @args.
>>>> + *
>>>> + * This function may return -EAGAIN to signal that the transaction needs to be
>>>> + * rolled.  Callers should continue calling this function until they receive a
>>>> + * return value other than -EAGAIN.
>>>> + */
>>>> +int
>>>> +xfs_attr_remove_iter(
>>>> +	struct xfs_delattr_context	*dac)
>>>> +{
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_inode		*dp = args->dp;
>>>> +
>>>> +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
>>>> +		goto node;
>>>
>>> Might as well just make this part of the if statement dispatch:
>>>
>>> 	if (dac->dela_state == XFS_DAS_RM_SHRINK)
>>> 		return xfs_attr_node_removename_iter(dac);
>>> 	else if (!xfs_inode_hasattr(dp))
>>> 		return -ENOATTR;
>> I think we did this once, but then people disliked having the same call in
>> two places.  We call the node function if XFS_DAS_RM_SHRINK is set OR if the
>> other two cases fail which is actually the initial point of entry.
>>
>> I think probably we need a comment somewhere.  I've realized every time a
>> question gets re-raised, it means we need a comment so we dont forget why
>> :-)
>>
>> Maybe for the goto we can have:
>> /* If we are shrinking a node, resume shrink */
>>
>> and.....
> 
> <shrug> This was a pretty minor point in my review, so if there's a
> better way of doing it, please feel free. :)
> 
> Admittedly I assume that a modern day compiler will slice and dice and
> rearrange to its heart's content, so for the most part I'm looking for
> higher level design errors and more or less don't care about the nitty
> gritty of what kind of machine code this all turns into.
> 
> (I'm probably doing that at everyone's peril, sadly...)
No worries, I just try my best to keep everyones commentary from prior 
review concidered.  Just to make sure things keep moving in a 
progressive direction.  At least as much as possible :-)

> 
>>
>>>
>>>>    	if (!xfs_inode_hasattr(dp)) {
>>>> -		error = -ENOATTR;
>>>> +		return -ENOATTR;
>>>>    	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>>>>    		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>>>> -		error = xfs_attr_shortform_remove(args);
>>>> +		return xfs_attr_shortform_remove(args);
>>>>    	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>>> -		error = xfs_attr_leaf_removename(args);
>>>> -	} else {
>>>> -		error = xfs_attr_node_removename(args);
>>>> +		return xfs_attr_leaf_removename(args);
>>>>    	}
>>>> -
>>>> -	return error;
>>>> +node:
>> 	/* If we are not short form or leaf, then remove node */
>> ?
>>>> +	return  xfs_attr_node_removename_iter(dac);
>>>>    }
>>>>    /*
>>>> @@ -1178,10 +1236,11 @@ xfs_attr_leaf_mark_incomplete(
>>>>     */
>>>>    STATIC
>>>>    int xfs_attr_node_removename_setup(
>>>> -	struct xfs_da_args	*args,
>>>> -	struct xfs_da_state	**state)
>>>> +	struct xfs_delattr_context	*dac,
>>>> +	struct xfs_da_state		**state)
>>>
>>> AFAICT *state == &dac->da_state by the end of the series; can you
>>> should remove this argument too?
>>>
>> Sure, I will see if I can collapse it down
>>
>>>>    {
>>>> -	int			error;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	int				error;
>>>>    	error = xfs_attr_node_hasname(args, state);
>>>>    	if (error != -EEXIST)
>>>> @@ -1191,6 +1250,12 @@ int xfs_attr_node_removename_setup(
>>>>    	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
>>>>    		XFS_ATTR_LEAF_MAGIC);
>>>> +	/*
>>>> +	 * Store state in the context incase we need to cycle out the
>>>> +	 * transaction
>>>> +	 */
>>>> +	dac->da_state = *state;
>>>> +
>>>>    	if (args->rmtblkno > 0) {
>>>>    		error = xfs_attr_leaf_mark_incomplete(args, *state);
>>>
>>> It doesn't make a lot of logical sense to me "we marked the attr
>>> incomplete to hide it" is the same state (UNINIT) as "we haven't done
>>> anything yet".
>> Not sure I quite follow what you mean here.  This little function is just a
>> set up helper.  It doesnt jump in an out like the other functions do with
>> the state machine.  We separated it out for that reason.  This routine
>> executes once to stash the state. The da_state. not the dela_state.
>> Different states :-)
>>
>> So after we have that stored away, the calling function moves onto
>> xfs_attr_node_remove_step, which does get recalled quite a bit until there
>> are no more remote blocks to remove.
> 
> <nod> I got that; I think my confusion here is that I was expecting each
> and every step to get its own state (which I think you said was how this
> used to be some ~5 revisions ago) even if it doesn't result in a
> transaction roll, whereas now the delattr code only introduces a new
> state when it needs to roll the transaction.
Well, I think the correct way to phrase it would be: all states are 
associated with an EAGAIN return (and thus a transaction roll), but not 
all such returns require a state.  If there is something else that can 
be used in place of a state, we use that instead.  Such at the state of 
the tree for example.

> 
> Hm.  I've been reviewing this patchset by puzzling out each of the steps
> of the old attr setting and removing code, and then figuring out how the
> old code got from one step to another.  Then I look at the end product
> of this whole patchset and try to figure out how the new state machine
> maps onto the old sequences, to determine if there are any serious
> discrepancies that also break things.
Oh gosh, that's a lot.  Thank you for the thorough review though!

> 
> So I think in the first round of this review I was treading awfully
> close to suggesting that every little step of the old system had to
> become an explicit state in the new system's state machine, so that I
> could do a 1:1 comparison.  That isn't the code that's before me now,
> and reworking all that sounds like (a) a big pain and (b) probably not
> where you and Brian were heading.
mmm, it wouldnt be tooooo bad.  But I do think it's important for people 
to be on the same page about it so that everybody is happy and 
comfortable with the result.  And to make sure development is moving in 
a progressive direction.

To be clear, putting back the explicit states would mean the 
re-installment of the pattern:

		dac->dela_state = XFS_DAS_NEW_STATE;
		return -EAGAIN;
das_new_state:


For every "return -EAGAIN" that doesnt have an explicit state.

For the most part, I got the impression that people perceive this to be 
a sort of unpleasant pattern to look at, and would like to see it culled 
away where it can be though.

> 
> Perhaps an easier way to bridge the gap between the old way and the new
> way would be to make the ASCII art diagram call out each of these little
> steps (marking the attr incomplete, removing the value blocks, erasing
> the attr key, shrinking the attr tree, etc.) and then show where each of
> the XFS_DAS_* steps fall into that?
Sure, I can flesh out the diagram a bit more

> 
> That way, the ASCII art would show that we start in XFS_DAS_UNINIT, mark
> the attr "incomplete", move on to XFS_DAS_RM_SHRINK, start removing attr
> blocks, etc.  The machinery can omit the unnecessary pieces, so long as
> we have a map of the overall process.
> 
> How does that sound?
That sounds reasonable :-)

> 
>>>
>>>>    		if (error)
>>>> @@ -1203,13 +1268,16 @@ int xfs_attr_node_removename_setup(
>>>>    }
>>>>    STATIC int
>>>> -xfs_attr_node_remove_rmt(
>>>> -	struct xfs_da_args	*args,
>>>> -	struct xfs_da_state	*state)
>>>> +xfs_attr_node_remove_rmt (
>>>> +	struct xfs_delattr_context	*dac,
>>>> +	struct xfs_da_state		*state)
>>>>    {
>>>> -	int			error = 0;
>>>> +	int				error = 0;
>>>> -	error = xfs_attr_rmtval_remove(args);
>>>> +	/*
>>>> +	 * May return -EAGAIN to request that the caller recall this function
>>>> +	 */
>>>> +	error = __xfs_attr_rmtval_remove(dac);
>>>>    	if (error)
>>>>    		return error;
>>>> @@ -1221,21 +1289,27 @@ xfs_attr_node_remove_rmt(
>>>>    }
>>>>    /*
>>>> - * Remove a name from a B-tree attribute list.
>>>> + * Step through removeing a name from a B-tree attribute list.
>>>>     *
>>>>     * This will involve walking down the Btree, and may involve joining
>>>>     * leaf nodes and even joining intermediate nodes up to and including
>>>>     * the root node (a special case of an intermediate node).
>>>> + *
>>>> + * This routine is meant to function as either an inline or delayed operation,
>>>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>>>> + * functions will need to handle this, and recall the function until a
>>>> + * successful error code is returned.
>>>>     */
>>>>    STATIC int
>>>>    xfs_attr_node_remove_step(
>>>> -	struct xfs_da_args	*args,
>>>> -	struct xfs_da_state	*state)
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	struct xfs_da_state_blk	*blk;
>>>> -	int			retval, error;
>>>> -	struct xfs_inode	*dp = args->dp;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_da_state		*state;
>>>> +	struct xfs_da_state_blk		*blk;
>>>> +	int				retval, error = 0;
>>>> +	state = dac->da_state;
>>>
>>> Might as well initialize this when you declare state above.
>> Sure
>>
>>>
>>>>    	/*
>>>>    	 * If there is an out-of-line value, de-allocate the blocks.
>>>> @@ -1243,7 +1317,10 @@ xfs_attr_node_remove_step(
>>>>    	 * overflow the maximum size of a transaction and/or hit a deadlock.
>>>>    	 */
>>>>    	if (args->rmtblkno > 0) {
>>>> -		error = xfs_attr_node_remove_rmt(args, state);
>>>> +		/*
>>>> +		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
>>>> +		 */
>>>> +		error = xfs_attr_node_remove_rmt(dac, state);
>>>>    		if (error)
>>>>    			return error;
>>>>    	}
>>>> @@ -1257,21 +1334,18 @@ xfs_attr_node_remove_step(
>>>>    	xfs_da3_fixhashpath(state, &state->path);
>>>>    	/*
>>>> -	 * Check to see if the tree needs to be collapsed.
>>>> +	 * Check to see if the tree needs to be collapsed.  Set the flag to
>>>> +	 * indicate that the calling function needs to move the to shrink
>>>> +	 * operation
>>>>    	 */
>>>>    	if (retval && (state->path.active > 1)) {
>>>>    		error = xfs_da3_join(state);
>>>>    		if (error)
>>>>    			return error;
>>>> -		error = xfs_defer_finish(&args->trans);
>>>> -		if (error)
>>>> -			return error;
>>>> -		/*
>>>> -		 * Commit the Btree join operation and start a new trans.
>>>> -		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>>> -		if (error)
>>>> -			return error;
>>>> +
>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>> +		dac->dela_state = XFS_DAS_RM_SHRINK;
>>>> +		return -EAGAIN;
>>>>    	}
>>>>    	return error;
>>>> @@ -1282,31 +1356,53 @@ xfs_attr_node_remove_step(
>>>>     *
>>>>     * This routine will find the blocks of the name to remove, remove them and
>>>>     * shirnk the tree if needed.
>>>
>>> "...and shrink the tree..."
>>>
>> Will fix the shirnk :-)
>>
>>>> + *
>>>> + * This routine is meant to function as either an inline or delayed operation,
>>>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>>>> + * functions will need to handle this, and recall the function until a
>>>> + * successful error code is returned.
>>>>     */
>>>>    STATIC int
>>>> -xfs_attr_node_removename(
>>>> -	struct xfs_da_args	*args)
>>>> +xfs_attr_node_removename_iter(
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	struct xfs_da_state	*state;
>>>> -	int			error;
>>>> -	struct xfs_inode	*dp = args->dp;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_da_state		*state;
>>>> +	int				error;
>>>> +	struct xfs_inode		*dp = args->dp;
>>>>    	trace_xfs_attr_node_removename(args);
>>>> +	state = dac->da_state;
>>>> -	error = xfs_attr_node_removename_setup(args, &state);
>>>> -	if (error)
>>>> -		goto out;
>>>> +	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
>>>> +		dac->flags |= XFS_DAC_NODE_RMVNAME_INIT;
>>>
>>> Can we determine if it's necessary to call _removename_setup by checking
>>> dac->da_state directly instead of having a flag?
>>
>> Initially I think I had another XFS_DAS_RMTVAL_REMOVE state for this.
>> Alternatly we also discussed using the inverse like this:
>>
>> if (dac->dela_state != XFS_DAS_RMTVAL_REMOVE)
>> 	do setup....
>>
>> Though I think people liked having the init flag, since init routines we a
>> sort of re-occuring pattern.  So that's why were using the flag now.
> 
> Oh, so (da_state != NULL) and (flags & XFS_DAC_NODE_RMVNAME_INIT) aren't
> a 1:1 correlation?
Oooh, sorry... I was refering to the wrong state variable.  Yes, 
da_state should never be null after it is set, so that should work. 
Will update :-)


> 
>>>
>>>> +		error = xfs_attr_node_removename_setup(dac, &state);
>>>> +		if (error)
>>>> +			goto out;
>>>> +	}
>>>> -	error = xfs_attr_node_remove_step(args, state);
>>>> -	if (error)
>>>> -		goto out;
>>>> +	switch (dac->dela_state) {
>>>> +	case XFS_DAS_UNINIT:
>>>> +		error = xfs_attr_node_remove_step(dac);
>>>> +		if (error)
>>>> +			break;
>>>> -	/*
>>>> -	 * If the result is small enough, push it all into the inode.
>>>> -	 */
>>>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>> -		error = xfs_attr_node_shrink(args, state);
>>>> +		/* do not break, proceed to shrink if needed */
>>>
>>> /* fall through */
>>>
>>> ...because otherwise the static checkers will get mad.
>>>
>>> (Well clang will anyway because gcc, llvm, and the C18 body all have
>>> different incompatible ideas of what should be the magic tag that
>>> signals an intentional fall through, but this should at least be
>>> consistent with the rest of xfs.)
>> Oh ok then, I did not know.  Will update the comment
>>
>>>
>>>> +	case XFS_DAS_RM_SHRINK:
>>>> +		/*
>>>> +		 * If the result is small enough, push it all into the inode.
>>>> +		 */
>>>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>> +			error = xfs_attr_node_shrink(args, state);
>>>> +		break;
>>>> +	default:
>>>> +		ASSERT(0);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	if (error == -EAGAIN)
>>>> +		return error;
>>>>    out:
>>>>    	if (state)
>>>>    		xfs_da_state_free(state);
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>> index 3e97a93..64dcf0f 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>> @@ -74,6 +74,74 @@ struct xfs_attr_list_context {
>>>>    };
>>>> +/*
>>>> + * ========================================================================
>>>> + * Structure used to pass context around among the delayed routines.
>>>> + * ========================================================================
>>>> + */
>>>> +
>>>> +/*
>>>> + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
>>>> + * states indicate places where the function would return -EAGAIN, and then
>>>> + * immediately resume from after being recalled by the calling function. States
>>>> + * marked as a "subroutine state" indicate that they belong to a subroutine, and
>>>> + * so the calling function needs to pass them back to that subroutine to allow
>>>> + * it to finish where it left off. But they otherwise do not have a role in the
>>>> + * calling function other than just passing through.
>>>> + *
>>>> + * xfs_attr_remove_iter()
>>>> + *	  XFS_DAS_RM_SHRINK ─┐
>>>> + *	  (subroutine state) │
>>>> + *	                     └─>xfs_attr_node_removename()
>>>> + *	                                      │
>>>> + *	                                      v
>>>> + *	                                   need to
>>>> + *	                                shrink tree? ─n─┐
>>>> + *	                                      │         │
>>>> + *	                                      y         │
>>>> + *	                                      │         │
>>>> + *	                                      v         │
>>>> + *	                              XFS_DAS_RM_SHRINK │
>>>> + *	                                      │         │
>>>> + *	                                      v         │
>>>> + *	                                     done <─────┘
>>>> + *
>>>> + */
>>>> +
>>>> +/*
>>>> + * Enum values for xfs_delattr_context.da_state
>>>> + *
>>>> + * These values are used by delayed attribute operations to keep track  of where
>>>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>>>> + * calling function to roll the transaction, and then recall the subroutine to
>>>> + * finish the operation.  The enum is then used by the subroutine to jump back
>>>> + * to where it was and resume executing where it left off.
>>>> + */
>>>> +enum xfs_delattr_state {
>>>> +	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>>>> +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>>>> +};
>>>> +
>>>> +/*
>>>> + * Defines for xfs_delattr_context.flags
>>>> + */
>>>> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>>>> +#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
>>>> +
>>>> +/*
>>>> + * Context used for keeping track of delayed attribute operations
>>>> + */
>>>> +struct xfs_delattr_context {
>>>> +	struct xfs_da_args      *da_args;
>>>> +
>>>> +	/* Used in xfs_attr_node_removename to roll through removing blocks */
>>>> +	struct xfs_da_state     *da_state;
>>>> +
>>>> +	/* Used to keep track of current state of delayed operation */
>>>> +	unsigned int            flags;
>>>> +	enum xfs_delattr_state  dela_state;
>>>> +};
>>>> +
>>>>    /*========================================================================
>>>>     * Function prototypes for the kernel.
>>>>     *========================================================================*/
>>>> @@ -91,6 +159,10 @@ int xfs_attr_set(struct xfs_da_args *args);
>>>>    int xfs_attr_set_args(struct xfs_da_args *args);
>>>>    int xfs_has_attr(struct xfs_da_args *args);
>>>>    int xfs_attr_remove_args(struct xfs_da_args *args);
>>>> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>>> +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>>>>    bool xfs_attr_namecheck(const void *name, size_t length);
>>>> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>>> +			      struct xfs_da_args *args);
>>>>    #endif	/* __XFS_ATTR_H__ */
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> index bb128db..338377e 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> @@ -19,8 +19,8 @@
>>>>    #include "xfs_bmap_btree.h"
>>>>    #include "xfs_bmap.h"
>>>>    #include "xfs_attr_sf.h"
>>>> -#include "xfs_attr_remote.h"
>>>>    #include "xfs_attr.h"
>>>> +#include "xfs_attr_remote.h"
>>>>    #include "xfs_attr_leaf.h"
>>>>    #include "xfs_error.h"
>>>>    #include "xfs_trace.h"
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> index 48d8e9c..1426c15 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
>>>>     */
>>>>    int
>>>>    xfs_attr_rmtval_remove(
>>>> -	struct xfs_da_args      *args)
>>>> +	struct xfs_da_args		*args)
>>>>    {
>>>> -	int			error;
>>>> -	int			retval;
>>>> +	int				error;
>>>> +	struct xfs_delattr_context	dac  = {
>>>> +		.da_args	= args,
>>>> +	};
>>>>    	trace_xfs_attr_rmtval_remove(args);
>>>> @@ -685,19 +687,17 @@ xfs_attr_rmtval_remove(
>>>>    	 * Keep de-allocating extents until the remote-value region is gone.
>>>>    	 */
>>>>    	do {
>>>> -		retval = __xfs_attr_rmtval_remove(args);
>>>> -		if (retval && retval != -EAGAIN)
>>>> -			return retval;
>>>> +		error = __xfs_attr_rmtval_remove(&dac);
>>>> +		if (error != -EAGAIN)
>>>> +			break;
>>>> -		/*
>>>> -		 * Close out trans and start the next one in the chain.
>>>> -		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>> +		error = xfs_attr_trans_roll(&dac);
>>>>    		if (error)
>>>>    			return error;
>>>> -	} while (retval == -EAGAIN);
>>>> -	return 0;
>>>> +	} while (true);
>>>> +
>>>> +	return error;
>>>>    }
>>>>    /*
>>>> @@ -707,9 +707,10 @@ xfs_attr_rmtval_remove(
>>>>     */
>>>>    int
>>>>    __xfs_attr_rmtval_remove(
>>>> -	struct xfs_da_args	*args)
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	int			error, done;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	int				error, done;
>>>>    	/*
>>>>    	 * Unmap value blocks for this attr.
>>>> @@ -719,12 +720,10 @@ __xfs_attr_rmtval_remove(
>>>>    	if (error)
>>>>    		return error;
>>>> -	error = xfs_defer_finish(&args->trans);
>>>> -	if (error)
>>>> -		return error;
>>>> -
>>>> -	if (!done)
>>>> +	if (!done) {
>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>    		return -EAGAIN;
>>>
>>> What state are we in when we return -EAGAIN here?
>>>
>>> [jumps back to his whole-branch diff]
>>>
>>> Hm, oh, I see, the next state could be a number of things--
>>>
>>> RM_LBLK if we're removing an old remote value from a leaf block as part
>>> of an attr set operation; or
>>>
>>> RM_NBLK if we're removing an old remote value from a node block as part
>>> of an attr set operation; and
>>>
>>> UNINIT if we're removing a remote value as part of an attr set
>>> operation.
>>>
>>> Oh!  For the first two, it looks to me as though either we're already in
>>> the state we're setting (RM_[LN]BLK) or we were in either of the
>>> FLIP_[LN]FLAG state.
>>>
>>> I think it would make more sense if you set the state before calling the
>>> rmtval_remove function, and leave a comment here saying that the caller
>>> is responsible for figuring out the next state.
>> Sure, it should be ok
>>
>>>
>>> For removals, I wonder if we should have advanced beyond UNINIT by the
>>> time we get here?  I think you've added the minimum states that are
>>> necessary to resume work after a transaction roll, but from this and the
>>> next patch I feel like we do a lot of work while dela_state == UNINIT.
>> Yes, I think I went over that a little in my replies to your earlier
>> reviews.  Many times we can get away with out setting a state to accomplish
>> the same behavior, though it may make it a little harder to visualize where
>> it comes back.
>>
>> I dunno this one seems like a preference in so far as what people want to
>> see for simplification.  I think haveing the explicit state setting makes
>> the code easier for a reader to follow, though I will concede they dont
>> actually have to be there to make it work.
> 
> <nod> Maybe (as I said earlier in this reply) we can get by with having
> the ascii art diagram point out all the things that happen while we're
> in "UNINIT" state before the first transaction roll.
> 
> I suspect that showing the steps and how the DAC state machine relates
> to those steps is the best we're going to be able to do w.r.t.
> restructuring a general key-value store implemented inside the kernel.
> :)
> 
Alrighty, that sounds reasonable

Thank you for all the feed back!!
Allison
>>>
>>> FWIW I will be taking a close look at all the new 'return -EAGAIN'
>>> statements to see if I can tell what state we're in when we trigger a
>>> transaction roll.
>> Well, ok, a lot of them are UNINIT.  If we continue in the direrction of
>> removing all unnecessary states, really it's the combination of the tree and
>> the state that actually lands us back to where we need to be when the
>> function is recalled.
>>
>> If, for debugging or readability purposes, we wanted an explicit state for
>> each EAGAIN, we would reintroduce a lot of states we've simplifid away over
>> the reviews.
>>
>> Maybe give it a day or two to sleep on, and let me know what you think :-)
> 
> <nod> OK.
> 
> --D
> 
>> Thanks for the reviews, I know it's really complicated.
>> Allison
>>
>>>
>>> --D
>>>
>>>> +	}
>>>>    	return error;
>>>>    }
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> index 9eee615..002fd30 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>>    int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>>>    		xfs_buf_flags_t incore_flags);
>>>>    int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>>>    #endif /* __XFS_ATTR_REMOTE_H__ */
>>>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>>>> index bfad669..aaa7e66 100644
>>>> --- a/fs/xfs/xfs_attr_inactive.c
>>>> +++ b/fs/xfs/xfs_attr_inactive.c
>>>> @@ -15,10 +15,10 @@
>>>>    #include "xfs_da_format.h"
>>>>    #include "xfs_da_btree.h"
>>>>    #include "xfs_inode.h"
>>>> +#include "xfs_attr.h"
>>>>    #include "xfs_attr_remote.h"
>>>>    #include "xfs_trans.h"
>>>>    #include "xfs_bmap.h"
>>>> -#include "xfs_attr.h"
>>>>    #include "xfs_attr_leaf.h"
>>>>    #include "xfs_quota.h"
>>>>    #include "xfs_dir2.h"
>>>> -- 
>>>> 2.7.4
>>>>
