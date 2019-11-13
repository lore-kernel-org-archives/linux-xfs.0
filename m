Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE7DC432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 23:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA474206EE
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 23:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gVg7bjb6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfKMXj2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 18:39:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41532 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfKMXj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 18:39:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADNZJkk174263;
        Wed, 13 Nov 2019 23:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=jvrbSmz2AeRldmueu22Atfrrps54lXjJz8qGfm1UBBA=;
 b=gVg7bjb6FHpobMewsc6IEIc7bDe902iTf64p4hxzQdndltG7Zh33ztX7MhyBcGw/srXu
 x579I1z6JPlObJT5rfnlB1Ez3eGkZagvo4udZJbJ9Ieqxoi9wK7PIEcpSaD1U/AbBv8f
 dNiDIbRiHxMvn+LQNSCBJmYc0yLHy40dljdklurXD1/ZIMM2MiluRezQAwx8owmiEfNA
 CBkopxXqOvTdMb4PUQsandPQB7iiKjQYQe3OCSobmfQq8UxRsy9acS1qYCy/iNmZxiig
 T5Y10waJ9lu5wQUlk59fMosz01aDcVxc0he1AInk+Juj27Yt3//HayuELIeQyNxu0r7j uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndqfw1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 23:39:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADNXbYH052293;
        Wed, 13 Nov 2019 23:39:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w7vbdsn3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 23:39:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xADNdJkl029317;
        Wed, 13 Nov 2019 23:39:19 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 15:39:19 -0800
Subject: Re: [PATCH v4 16/17] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-17-allison.henderson@oracle.com>
 <20191112133702.GA46980@bfoster>
 <a90fd70a-9c5c-d82e-e889-be489b33b330@oracle.com>
 <20191113115416.GA54921@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c2e5f4ab-b8a2-8d41-468d-e3debb87b6bf@oracle.com>
Date:   Wed, 13 Nov 2019 16:39:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113115416.GA54921@bfoster>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/13/19 4:54 AM, Brian Foster wrote:
> On Tue, Nov 12, 2019 at 05:43:04PM -0700, Allison Collins wrote:
>>
>>
>> On 11/12/19 6:37 AM, Brian Foster wrote:
>>> On Wed, Nov 06, 2019 at 06:28:00PM -0700, Allison Collins wrote:
>>>> This patch modifies the attr remove routines to be delay ready.
>>>> This means they no longer roll or commit transactions, but instead
>>>> return -EAGAIN to have the calling routine roll and refresh the
>>>> transaction.  In this series, xfs_attr_remove_args has become
>>>> xfs_attr_remove_later, which uses a state machine to keep track
>>>> of where it was when EAGAIN was returned.  xfs_attr_node_removename
>>>> has also been modified to use the state machine, and a  new version of
>>>> xfs_attr_remove_args consists of a simple loop to refresh the
>>>> transaction until the operation is completed.
>>>>
>>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>>> ---
>>>
>>> On a cursory look, this is definitely more along the lines of what I was
>>> thinking on the previous revisions. I would like to see if we can get a
>>> bit more refactoring/cleanup before this point though. Further thoughts
>>> inline..
>>>
>>>>    fs/xfs/libxfs/xfs_attr.c | 123 +++++++++++++++++++++++++++++++++++++++--------
>>>>    fs/xfs/libxfs/xfs_attr.h |   1 +
>>>>    2 files changed, 104 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index 626d4a98..38d5c5c 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>> @@ -369,10 +369,56 @@ xfs_has_attr(
>>>>     */
>>>>    int
>>>>    xfs_attr_remove_args(
>>>> +	struct xfs_da_args	*args)
>>>> +{
>>>> +	int			error = 0;
>>>> +	int			err2 = 0;
>>>> +
>>>> +	do {
>>>> +		error = xfs_attr_remove_later(args);
>>>> +		if (error && error != -EAGAIN)
>>>> +			goto out;
>>>
>>> xfs_attr_remove_later() strikes me as an odd name with respect to the
>>> functionality. Perhaps something like xfs_attr_remove_step() is
>>> (slightly) more accurate..?
>> Sure that's fine.  I think Darrick had proposed the *_later scheme in an
>> earlier review but that was when the code paths were split.  Darrick, does
>> the *_step scheme work for you?
>>
> 
> FWIW, xfs_attr_remove_iter() also came to mind after sending the
> previous mail.
Alrighty, I am fine with a *_iter scheme then

> 
>>>
>>>> +
>>>> +		xfs_trans_log_inode(args->trans, args->dp,
>>>> +			XFS_ILOG_CORE | XFS_ILOG_ADATA);
>>>> +
>>>> +		err2 = xfs_trans_roll(&args->trans);
>>>> +		if (err2) {
>>>> +			error = err2;
>>>
>>> Also do we really need two error codes in this function? It seems like
>>> we should be able to write this with one, but I haven't tried it..
>> No, because then we'll loose the xfs_attr_remove_later return code, which is
>> either 0 or EAGAIN at this point.  And we need that to drive the loop.  To
>> get rid of err2, we'd need another "not_done" variable or something.  Like:
>>
>> do {
>> 	...
>> 	not_done = (error == -EAGAIN);
>> 	...
>> } while (not_done)
>>
>>
>> Not sure if not_done is really preferable to err2?
>>
> 
> Eh, NBD. It just looked like potentially verbose logic on a quick scan.
> On a closer look, I see that we want to handle both error == 0 and error
> == -EAGAIN, so this seems fine as is to me.
> 
>>>
>>>> +			goto out;
>>>> +		}
>>>> +
>>>> +		/* Rejoin inode */
>>>> +		xfs_trans_ijoin(args->trans, args->dp, 0);
>>>> +
>>>> +	} while (error == -EAGAIN);
>>>> +out:
>>>> +	return error;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Remove the attribute specified in @args.
>>>> + * This routine is meant to function as a delayed operation, and may return
>>>> + * -EGAIN when the transaction needs to be rolled.  Calling functions will need
>>>> + * to handle this, and recall the function until a successful error code is
>>>> + * returned.
>>>> + */
>>>> +int
>>>> +xfs_attr_remove_later(
>>>>    	struct xfs_da_args      *args)
>>>>    {
>>>>    	struct xfs_inode	*dp = args->dp;
>>>> -	int			error;
>>>> +	int			error = 0;
>>>> +
>>>> +	/* State machine switch */
>>>> +	switch (args->dc.dc_state) {
>>>> +	case XFS_DC_RM_INVALIDATE:
>>>> +	case XFS_DC_RM_SHRINK:
>>>> +	case XFS_DC_RM_NODE_BLKS:
>>>> +		goto node;
>>>> +	default:
>>>> +		break;
>>>> +	}
>>>>    	if (!xfs_inode_hasattr(dp)) {
>>>>    		error = -ENOATTR;
>>>> @@ -382,6 +428,7 @@ xfs_attr_remove_args(
>>>>    	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>>>    		error = xfs_attr_leaf_removename(args);
>>>>    	} else {
>>>> +node:
>>>>    		error = xfs_attr_node_removename(args);
>>>>    	}
>>>> @@ -892,9 +939,6 @@ xfs_attr_leaf_removename(
>>>>    		/* bp is gone due to xfs_da_shrink_inode */
>>>>    		if (error)
>>>>    			return error;
>>>> -		error = xfs_defer_finish(&args->trans);
>>>> -		if (error)
>>>> -			return error;
>>>>    	}
>>>>    	return 0;
>>>>    }
>>>> @@ -1212,6 +1256,11 @@ xfs_attr_node_addname(
>>>>     * This will involve walking down the Btree, and may involve joining
>>>>     * leaf nodes and even joining intermediate nodes up to and including
>>>>     * the root node (a special case of an intermediate node).
>>>> + *
>>>> + * This routine is meant to function as a delayed operation, and may return
>>>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions
>>>> + * will need to handle this, and recall the function until a successful error
>>>> + * code is returned.
>>>>     */
>>>>    STATIC int
>>>>    xfs_attr_node_removename(
>>>> @@ -1222,12 +1271,29 @@ xfs_attr_node_removename(
>>>>    	struct xfs_buf		*bp;
>>>>    	int			retval, error, forkoff;
>>>>    	struct xfs_inode	*dp = args->dp;
>>>> +	int			done = 0;
>>>>    	trace_xfs_attr_node_removename(args);
>>>> +	state = args->dc.da_state;
>>>> +	blk = args->dc.blk;
>>>> +
>>>> +	/* State machine switch */
>>>> +	switch (args->dc.dc_state) {
>>>> +	case XFS_DC_RM_NODE_BLKS:
>>>> +		goto rm_node_blks;
>>>> +	case XFS_DC_RM_INVALIDATE:
>>>> +		goto rm_invalidate;
>>>> +	case XFS_DC_RM_SHRINK:
>>>> +		goto rm_shrink;
>>>> +	default:
>>>> +		break;
>>>
>>> I wonder if it's worth having an explicit state for the initial path.
>>> That could be useful for readability and debuggability in the future.
>> We could, it will just require to the calling function to set that before
>> state calling it.
>>
> 
> Looking back, I see we have XFS_DC_INIT in the enum, but it isn't used.
> What is that particular state for? Any reason the enum doesn't start
> with a value of 0?
Yes, sorry, it's used in the next patch series when we get into to the 
real delayed attr infrastructure.  I just forgot to take it out of the 
smaller subset here.

Basically all the use cases thus far already have args initialized, but 
in the log replay, we have to construct args from the log entry.  So we 
need the extra state to not re-initialize it every time and wipe out the 
state.  That use case is little more unique in that we have to set up 
the state machine after the ping pong has already started.

> 
>> Mechanically, I dont think it would hurt anything, but it may lead to
>> developer wonderments like... "Where's the EAGAIN for this state?" "Shouldnt
>> this state appear in the switch up top too?"  Or if it does "Why do we have
>> it here, if it never executes?"  "I wonder if i should sent a patch to take
>> it out..." :-)
>>
> 
> Perhaps, though some of those questions already exist with the current
> code. Not every function cares about every state from what I can tell.
> Also, not every state that can return -EAGAIN is guaranteed to do so.
> 
>> Puzzlement aside though, I cant quite think of what condition it would help
>> to debug?  It's not an error for the statemachine to hold a value outside of
>> the helpers scope.  It just means the caller was using it up to this point.
>> Helpers really shouldnt have enough context about their callers to know or
>> care what the caller states mean.  If we added a special init state, all the
>> default statement would really mean is: "The caller forgot to set the init
>> state".
>>
> 
> See my question above around the existing init state. However that is
> intended to be used is not really clear to me. BTW, it might be better
> to introduce the core structures in one patch and add the individual
> states as they are used by the subsequent patches that use them.
Ok, I will introduce the states progressively then, I think that caused 
the confusion

> 
> WRT to readability/debuggability, I suppose a simple example would be to
> consider if we had a tracepoint somewhere in the higher level code that
> printed state and error code and we wanted to use that to identify an
> unexpected error that occurs during an attr op. With the current code,
> if that printed something like:
> 
> 	state INVALIDATE error -EIO
> 
> ... that doesn't tell us a whole lot about what happened beyond
> something failed sometime after the setflag state. The attr itself might
> not even have remote blocks to invalidate, which is slightly confusing.
> This is handwavy/subjective, of course..
Yes, as it is, it doesn't really have any way of detecting a corrupt 
state.  Really though, if we want to do that what we need is another 
layer of modeling where we enforce the sequence of the states.  So for 
example, some sort of mapping or tree that defines: XFS_DC_LEAF_TO_NODE 
and XFS_DC_FOUND_LBLK as being children (or mappings) of 
XFS_DC_SF_TO_LEAF.

In other words, if the state is XFS_DC_SF_TO_LEAF, you can change it to 
XFS_DC_FOUND_LBLK or XFS_DC_LEAF_TO_NODE, but you can't go to say 
XFS_DC_RM_SHRINK, that would generate an error.  And then we have some 
sort of set_state() routine to enforce these rules.

That's a lot of extra overhead though, and could be more of a burden 
than a help.  But it's something we could explore if people think it's 
worth the pursuit.

Allison
> 
>> Thoughts?
>>
>>>
>>>> +	}
>>>>    	error = xfs_attr_node_hasname(args, &state);
>>>>    	if (error != -EEXIST)
>>>>    		goto out;
>>>> +	else
>>>> +		error = 0;
>>>>    	/*
>>>>    	 * If there is an out-of-line value, de-allocate the blocks.
>>>> @@ -1237,6 +1303,14 @@ xfs_attr_node_removename(
>>>>    	blk = &state->path.blk[ state->path.active-1 ];
>>>>    	ASSERT(blk->bp != NULL);
>>>>    	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>>> +
>>>> +	/*
>>>> +	 * Store blk and state in the context incase we need to cycle out the
>>>> +	 * transaction
>>>> +	 */
>>>> +	args->dc.blk = blk;
>>>> +	args->dc.da_state = state;
>>>> +
>>>>    	if (args->rmtblkno > 0) {
>>>>    		/*
>>>>    		 * Fill in disk block numbers in the state structure
>>>> @@ -1255,13 +1329,30 @@ xfs_attr_node_removename(
>>>>    		if (error)
>>>>    			goto out;
>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>> +		args->dc.dc_state = XFS_DC_RM_INVALIDATE;
>>>> +		return -EAGAIN;
>>>> +rm_invalidate:
>>>> +		error = xfs_attr_rmtval_invalidate(args);
>>>>    		if (error)
>>>>    			goto out;
>>>> +rm_node_blks:
>>>
>>> While I think the design is the right idea, jumping down into a function
>>> like this is pretty hairy. I think we should try to further break this
>>> function down into smaller elements one way or another that model the
>>> steps defined by the state structure. There's probably multiple ways to
>>> do that. For example, the remote attr bits could be broken down into
>>> a subfunction that processes the couple of states associated with remote
>>> blocks. That said, ISTM it might be wiser to try and keep the state
>>> processing in one place if possible. That would imply to break the
>>> remote processing loop down into a couple functions. All in all, this
>>> function might end up looking something like:
>>>
>>> xfs_attr_node_removename()
>>> {
>>> 	/* switch statement and comment to document each state */
>>>
>>> 	error = xfs_attr_node_hasname(args, &state);
>>> 	...
>>>
>>> 	if (remote) {
>>> 		error = do_setflag();
>>> 		if (error)
>>> 			return error;
>>>
>>> 		/* roll */
>>> 		state = INVALIDATE;
>>> 		return -EAGAIN;
>>> 	}
>>>
>>> rmt_invalidate:
>>> 	state = INVALIDATE;
>>> 	if (remote)
>>> 		do_invalidate();
>>> 	/* fallthru */
>>>
>>> rmt_rm_blks:
>>> 	state = RM_NODE_BLKS;
>>> 	if (remote) {
>>> 		/* loops and returns -EAGAIN until we fallthru */
>>> 		error = rmt_remove_step();
>>> 		if (error)
>>> 			return error;
>>>
>>> 		xfs_attr_refillstate();
>>> 	}
>>>
>>> /* maybe worth a new state here? */
>>> removename:
>>> 	state = REMOVENAME;
>>> 	xfs_attr3_leaf_remove();
>>> 	...
>>> 	if (...) {
>>> 		state = SHRINK;
>>> 		return -EAGAIN;
>>> 	}
>>>
>>> shrink:
>>> 	state = SHRINK;
>>> 	error = do_shrink();
>>>
>>> 	return 0;
>>> }
>> Ok, I had to go over this a few times, but I think I understand what you're
>> describing.  Will update in the next version
>>>
>>> I'm not totally sold on the idea of rolling the state forward explicitly
>>> like this, but it seems like it could be a bit more maintainable.
>> I think it is.  Having a dedicated struct just for this purpose alleviates a
>> lot of struggle with trying to grab onto things like the fork or the
>> incomplete flags to represent what we're trying to do here. Doing so also
>> overloads their original intent in that if these structures ever change in
>> the future, it may break something that the state machine depends on.  In
>> this solution, they remain disjoint concepts dedicated to their purpose.
>> And anyway, I couldn't completely escape the state machine in the previous
>> set.  I still had to add the extra flag space which functioned more or less
>> like "i was here" tick marks.  If we have to have it, we may as well
>> leverage what it can do. For example I can drop patch 11 from this set
>> because I don't need the extra isset helpers to see if it's already been
>> done.
>>
> 
> Right.. I agree that the "bookmark" like approach in the current scheme
> makes the state implementation (and not necessarily the operational
> implementation) a little hard to follow and review. Note again that what
> I wrote up here was just a quick example for that higher level feedback
> of somehow or another trying to isolate state updates from state
> implementation, so I'm not necessarily tied to that specific approach if
> there are other ways to similarly simplify things.
> 
> I do think fixing up the code to avoid jumping into loops and whatnot is
> more important. It could also be that just continuing to break things
> down into as small functions as possible (i.e. with a goal of 1 function
> per state) kind of forces a natural separation.
> 
> Brian
> 
>>   All in
>>> all this is still fairly ugly, but this is mostly a mechanical attempt
>>> to keep state management isolated and we can polish it up from there.
>>> Thoughts?
>>
>> Yes, at this point, I do kind of feel like it's the least of the ugly
>> prototypes.  So I'm just kind of proceeding, with caution. :-)
>>
>> Thanks for the in depths reviews!!  I know its a lot!  Much appreciated!!
>>
>> Allison
>>
>>>
>>> Brian
>>>
>>>> +		/*
>>>> +		 * Unmap value blocks for this attr.  This is similar to
>>>> +		 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
>>>> +		 * for new transactions
>>>> +		 */
>>>> +		while (!done && !error) {
>>>> +			error = xfs_bunmapi(args->trans, args->dp,
>>>> +				    args->rmtblkno, args->rmtblkcnt,
>>>> +				    XFS_BMAPI_ATTRFORK, 1, &done);
>>>> +			if (error)
>>>> +				return error;
>>>> -		error = xfs_attr_rmtval_remove(args);
>>>> -		if (error)
>>>> -			goto out;
>>>> +			if (!done) {
>>>> +				args->dc.dc_state = XFS_DC_RM_NODE_BLKS;
>>>> +				return -EAGAIN;
>>>> +			}
>>>> +		}
>>>>    		/*
>>>>    		 * Refill the state structure with buffers, the prior calls
>>>> @@ -1287,17 +1378,12 @@ xfs_attr_node_removename(
>>>>    		error = xfs_da3_join(state);
>>>>    		if (error)
>>>>    			goto out;
>>>> -		error = xfs_defer_finish(&args->trans);
>>>> -		if (error)
>>>> -			goto out;
>>>> -		/*
>>>> -		 * Commit the Btree join operation and start a new trans.
>>>> -		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>>> -		if (error)
>>>> -			goto out;
>>>> +
>>>> +		args->dc.dc_state = XFS_DC_RM_SHRINK;
>>>> +		return -EAGAIN;
>>>>    	}
>>>> +rm_shrink:
>>>>    	/*
>>>>    	 * If the result is small enough, push it all into the inode.
>>>>    	 */
>>>> @@ -1319,9 +1405,6 @@ xfs_attr_node_removename(
>>>>    			/* bp is gone due to xfs_da_shrink_inode */
>>>>    			if (error)
>>>>    				goto out;
>>>> -			error = xfs_defer_finish(&args->trans);
>>>> -			if (error)
>>>> -				goto out;
>>>>    		} else
>>>>    			xfs_trans_brelse(args->trans, bp);
>>>>    	}
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>> index 3b5dad4..fb8bf5b 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>> @@ -152,6 +152,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>>>>    int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>>>>    int xfs_has_attr(struct xfs_da_args *args);
>>>>    int xfs_attr_remove_args(struct xfs_da_args *args);
>>>> +int xfs_attr_remove_later(struct xfs_da_args *args);
>>>>    int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>>>    		  int flags, struct attrlist_cursor_kern *cursor);
>>>>    bool xfs_attr_namecheck(const void *name, size_t length);
>>>> -- 
>>>> 2.7.4
>>>>
>>>
>>
> 
