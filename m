Return-Path: <SRS0=bcFD=6A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F27C2BB55
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Apr 2020 22:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A3F22201
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Apr 2020 22:57:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0E1HUeff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgDPW5D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 18:57:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgDPW5C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Apr 2020 18:57:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GMmsXI161072;
        Thu, 16 Apr 2020 22:56:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=J45uoQAvgzu05T6i25tqVrU4/hYCM7OajCPe8c6kLaQ=;
 b=0E1HUeffXgrkahwbtNEA6xxlzHRWt+1mayH0TKYeuR5UctJo/kGNPljJUAoXkhdv5Ex1
 PWXHqKideycrb8V+dWYfoQ6SUPylepUtMRICZJY8csB0fRnQTzbqX3MeBLht1Gc0iToL
 YgYNR/i0EqxKthPDVRupnTwmaOeUvp8nTYprIElrZMXv4gQTqWlZexNpD7FvxR/IkB+M
 mi08589lxIwnM2H05Iy6H8d2Z3pvi+NUe/AY9NX7pIwrZZ4KtYhNQARWgKObP8jtDTTI
 jAZukOgR6U6ShEJW+7Ps8iBqBExgbNhf7MC7u/g+qBcdxT+ayrCc0ktCiN4EQWDnKC5K qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30dn95v9na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 22:56:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GMbx9J172803;
        Thu, 16 Apr 2020 22:54:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30dyp0vd0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 22:54:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03GMspbX005897;
        Thu, 16 Apr 2020 22:54:51 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Apr 2020 15:54:50 -0700
Subject: Re: [PATCH v8 19/20] xfs: Add delay ready attr set routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-20-allison.henderson@oracle.com>
 <20200413134035.GD57285@bfoster>
 <75c97cd3-8953-3e8d-232b-53e09d76675b@oracle.com>
 <20200416110106.GB6945@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <1a6b233b-b97d-1351-0efa-8afdf364aa9d@oracle.com>
Date:   Thu, 16 Apr 2020 15:54:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200416110106.GB6945@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=2
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/16/20 4:01 AM, Brian Foster wrote:
> On Wed, Apr 15, 2020 at 03:08:11PM -0700, Allison Collins wrote:
>>
>>
>> On 4/13/20 6:40 AM, Brian Foster wrote:
>>> On Fri, Apr 03, 2020 at 03:12:28PM -0700, Allison Collins wrote:
>>>> This patch modifies the attr set routines to be delay ready. This means
>>>> they no longer roll or commit transactions, but instead return -EAGAIN
>>>> to have the calling routine roll and refresh the transaction.  In this
>>>> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
>>>> state machine like switch to keep track of where it was when EAGAIN was
>>>> returned.
>>>>
>>>> Two new helper functions have been added: xfs_attr_rmtval_set_init and
>>>> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
>>>> xfs_attr_rmtval_set, but they store the current block in the delay attr
>>>> context to allow the caller to roll the transaction between allocations.
>>>> This helps to simplify and consolidate code used by
>>>> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
>>>> now become a simple loop to refresh the transaction until the operation
>>>> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
>>>> removed.
>>>>
>>>> Below is a state machine diagram for attr set operations. The XFS_DAS_*
>>>> states indicate places where the function would return -EAGAIN, and then
>>>> immediately resume from after being recalled by the calling function.
>>>> States marked as a "subroutine state" indicate that they belong to a
>>>> subroutine, and so the calling function needs to pass them back to that
>>>> subroutine to allow it to finish where it left off.  But they otherwise
>>>> do not have a role in the calling function other than just passing
>>>> through.
>>>>
>>>>    xfs_attr_set_iter()
>>>>                    │
>>>>                    v
>>>>              need to upgrade
>>>>             from sf to leaf? ──n─┐
>>>>                    │             │
>>>>                    y             │
>>>>                    │             │
>>>>                    V             │
>>>>             XFS_DAS_ADD_LEAF     │
>>>>                    │             │
>>>>                    v             │
>>>>     ┌──────n── fork has   <──────┘
>>>>     │         only 1 blk?
>>>>     │              │
>>>>     │              y
>>>>     │              │
>>>>     │              v
>>>>     │     xfs_attr_leaf_try_add()
>>>>     │              │
>>>>     │              v
>>>>     │          had enough
>>>>     ├──────n──   space?
>>>>     │              │
>>>>     │              y
>>>>     │              │
>>>>     │              v
>>>>     │      XFS_DAS_FOUND_LBLK  ──┐
>>>>     │                            │
>>>>     │      XFS_DAS_FLIP_LFLAG  ──┤
>>>>     │      (subroutine state)    │
>>>>     │                            │
>>>>     │      XFS_DAS_ALLOC_LEAF  ──┤
>>>>     │      (subroutine state)    │
>>>>     │                            └─>xfs_attr_leaf_addname()
>>>>     │                                              │
>>>>     │                                              v
>>>>     │                                ┌─────n──  need to
>>>>     │                                │        alloc blks?
>>>>     │                                │             │
>>>>     │                                │             y
>>>>     │                                │             │
>>>>     │                                │             v
>>>>     │                                │  ┌─>XFS_DAS_ALLOC_LEAF
>>>>     │                                │  │          │
>>>>     │                                │  │          v
>>>>     │                                │  └──y── need to alloc
>>>>     │                                │         more blocks?
>>>>     │                                │             │
>>>>     │                                │             n
>>>>     │                                │             │
>>>>     │                                │             v
>>>>     │                                │          was this
>>>>     │                                └────────> a rename? ──n─┐
>>>>     │                                              │          │
>>>>     │                                              y          │
>>>>     │                                              │          │
>>>>     │                                              v          │
>>>>     │                                        flip incomplete  │
>>>>     │                                            flag         │
>>>>     │                                              │          │
>>>>     │                                              v          │
>>>>     │                                      XFS_DAS_FLIP_LFLAG │
>>>>     │                                              │          │
>>>>     │                                              v          │
>>>>     │                                            remove       │
>>>>     │                        XFS_DAS_RM_LBLK ─> old name      │
>>>>     │                                 ^            │          │
>>>>     │                                 │            v          │
>>>>     │                                 └──────y── more to      │
>>>>     │                                            remove       │
>>>>     │                                              │          │
>>>>     │                                              n          │
>>>>     │                                              │          │
>>>>     │                                              v          │
>>>>     │                                             done <──────┘
>>>>     └────> XFS_DAS_LEAF_TO_NODE ─┐
>>>>                                  │
>>>>            XFS_DAS_FOUND_NBLK  ──┤
>>>>            (subroutine state)    │
>>>>                                  │
>>>>            XFS_DAS_ALLOC_NODE  ──┤
>>>>            (subroutine state)    │
>>>>                                  │
>>>>            XFS_DAS_FLIP_NFLAG  ──┤
>>>>            (subroutine state)    │
>>>>                                  │
>>>>                                  └─>xfs_attr_node_addname()
>>>>                                                    │
>>>>                                                    v
>>>>                                            find space to store
>>>>                                           attr. Split if needed
>>>>                                                    │
>>>>                                                    v
>>>>                                            XFS_DAS_FOUND_NBLK
>>>>                                                    │
>>>>                                                    v
>>>>                                      ┌─────n──  need to
>>>>                                      │        alloc blks?
>>>>                                      │             │
>>>>                                      │             y
>>>>                                      │             │
>>>>                                      │             v
>>>>                                      │  ┌─>XFS_DAS_ALLOC_NODE
>>>>                                      │  │          │
>>>>                                      │  │          v
>>>>                                      │  └──y── need to alloc
>>>>                                      │         more blocks?
>>>>                                      │             │
>>>>                                      │             n
>>>>                                      │             │
>>>>                                      │             v
>>>>                                      │          was this
>>>>                                      └────────> a rename? ──n─┐
>>>>                                                    │          │
>>>>                                                    y          │
>>>>                                                    │          │
>>>>                                                    v          │
>>>>                                              flip incomplete  │
>>>>                                                  flag         │
>>>>                                                    │          │
>>>>                                                    v          │
>>>>                                            XFS_DAS_FLIP_NFLAG │
>>>>                                                    │          │
>>>>                                                    v          │
>>>>                                                  remove       │
>>>>                              XFS_DAS_RM_NBLK ─> old name      │
>>>>                                       ^            │          │
>>>>                                       │            v          │
>>>>                                       └──────y── more to      │
>>>>                                                  remove       │
>>>>                                                    │          │
>>>>                                                    n          │
>>>>                                                    │          │
>>>>                                                    v          │
>>>>                                                   done <──────┘
>>>>
>>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>>> ---
>>>
>>> Only a cursory pass given the previous feedback...
>>>
>>>>    fs/xfs/libxfs/xfs_attr.c        | 384 +++++++++++++++++++++++++++-------------
>>>>    fs/xfs/libxfs/xfs_attr.h        |  16 ++
>>>>    fs/xfs/libxfs/xfs_attr_leaf.c   |   1 +
>>>>    fs/xfs/libxfs/xfs_attr_remote.c | 111 +++++++-----
>>>>    fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>>>>    fs/xfs/xfs_attr_inactive.c      |   1 +
>>>>    fs/xfs/xfs_trace.h              |   1 -
>>>>    7 files changed, 351 insertions(+), 167 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index f700976..c160b7a 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>> @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>>>     * Internal routines when attribute list is one block.
>>>>     */
>>>>    STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>>> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>>>> +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
>>>>    STATIC int xfs_attr_leaf_removename(struct xfs_delattr_context *dac);
>>>>    STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>> @@ -52,12 +52,13 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>>     * Internal routines when attribute list is more than one block.
>>>>     */
>>>>    STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>>> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>>> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
>>>>    STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
>>>>    STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>>    				 struct xfs_da_state **state);
>>>>    STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>>    STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>>>>    STATIC void
>>>>    xfs_delattr_context_init(
>>>> @@ -227,8 +228,11 @@ xfs_attr_is_shortform(
>>>>    /*
>>>>     * Attempts to set an attr in shortform, or converts the tree to leaf form if
>>>> - * there is not enough room.  If the attr is set, the transaction is committed
>>>> - * and set to NULL.
>>>> + * there is not enough room.  This function is meant to operate as a helper
>>>> + * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
>>>> + * that the calling function should roll the transaction, and then proceed to
>>>> + * add the attr in leaf form.  This subroutine does not expect to be recalled
>>>> + * again like the other delayed attr routines do.
>>>>     */
>>>>    STATIC int
>>>>    xfs_attr_set_shortform(
>>>> @@ -236,16 +240,16 @@ xfs_attr_set_shortform(
>>>>    	struct xfs_buf		**leaf_bp)
>>>>    {
>>>>    	struct xfs_inode	*dp = args->dp;
>>>> -	int			error, error2 = 0;
>>>> +	int			error = 0;
>>>>    	/*
>>>>    	 * Try to add the attr to the attribute list in the inode.
>>>>    	 */
>>>>    	error = xfs_attr_try_sf_addname(dp, args);
>>>> +
>>>> +	/* Should only be 0, -EEXIST or ENOSPC */
>>>>    	if (error != -ENOSPC) {
>>>> -		error2 = xfs_trans_commit(args->trans);
>>>> -		args->trans = NULL;
>>>> -		return error ? error : error2;
>>>> +		return error;
>>>>    	}
>>>>    	/*
>>>>    	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>>>> @@ -258,18 +262,10 @@ xfs_attr_set_shortform(
>>>>    	/*
>>>>    	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>>>>    	 * push cannot grab the half-baked leaf buffer and run into problems
>>>> -	 * with the write verifier. Once we're done rolling the transaction we
>>>> -	 * can release the hold and add the attr to the leaf.
>>>> +	 * with the write verifier.
>>>>    	 */
>>>>    	xfs_trans_bhold(args->trans, *leaf_bp);
>>>> -	error = xfs_defer_finish(&args->trans);
>>>> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
>>>> -	if (error) {
>>>> -		xfs_trans_brelse(args->trans, *leaf_bp);
>>>> -		return error;
>>>> -	}
>>>> -
>>>> -	return 0;
>>>> +	return -EAGAIN;
>>>>    }
>>>>    /*
>>>> @@ -279,9 +275,83 @@ int
>>>>    xfs_attr_set_args(
>>>>    	struct xfs_da_args	*args)
>>>>    {
>>>> -	struct xfs_inode	*dp = args->dp;
>>>> -	struct xfs_buf          *leaf_bp = NULL;
>>>> -	int			error = 0;
>>>> +	struct xfs_buf			*leaf_bp = NULL;
>>>> +	int				error = 0;
>>>> +	struct xfs_delattr_context	dac;
>>>> +
>>>> +	xfs_delattr_context_init(&dac, args);
>>>> +
>>>> +	do {
>>>> +		error = xfs_attr_set_iter(&dac, &leaf_bp);
>>>> +		if (error != -EAGAIN)
>>>> +			break;
>>>> +
>>>> +		if (dac.flags & XFS_DAC_DEFER_FINISH) {
>>>> +			dac.flags &= ~XFS_DAC_DEFER_FINISH;
>>>> +			error = xfs_defer_finish(&args->trans);
>>>> +			if (error)
>>>> +				break;
>>>> +		}
>>>> +
>>>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>> +		if (error)
>>>> +			break;
>>>> +
>>>> +		if (leaf_bp) {
>>>> +			xfs_trans_bjoin(args->trans, leaf_bp);
>>>> +			xfs_trans_bhold(args->trans, leaf_bp);
>>>> +		}
>>>> +
>>>> +	} while (true);
>>>> +
>>>> +	return error;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Set the attribute specified in @args.
>>>> + * This routine is meant to function as a delayed operation, and may return
>>>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>>>> + * to handle this, and recall the function until a successful error code is
>>>> + * returned.
>>>> + */
>>>> +int
>>>> +xfs_attr_set_iter(
>>>> +	struct xfs_delattr_context	*dac,
>>>> +	struct xfs_buf			**leaf_bp)
>>>> +{
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_inode		*dp = args->dp;
>>>> +	int				error = 0;
>>>> +	int				sf_size;
>>>> +
>>>> +	/* State machine switch */
>>>> +	switch (dac->dela_state) {
>>>> +	case XFS_DAS_ADD_LEAF:
>>>> +		goto das_add_leaf;
>>>> +	case XFS_DAS_ALLOC_LEAF:
>>>> +	case XFS_DAS_FLIP_LFLAG:
>>>> +	case XFS_DAS_FOUND_LBLK:
>>>> +		goto das_leaf;
>>>> +	case XFS_DAS_FOUND_NBLK:
>>>> +	case XFS_DAS_FLIP_NFLAG:
>>>> +	case XFS_DAS_ALLOC_NODE:
>>>> +	case XFS_DAS_LEAF_TO_NODE:
>>>> +		goto das_node;
>>>> +	default:
>>>> +		break;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * New inodes may not have an attribute fork yet. So set the attribute
>>>> +	 * fork appropriately
>>>> +	 */
>>>> +	if (XFS_IFORK_Q((args->dp)) == 0) {
>>>> +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
>>>> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
>>>> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
>>>> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
>>>> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
>>>> +	}
>>>
>>> Is this hunk moved from somewhere? If so, we should probably handle that
>>> in a separate patch. I think we really want these last couple of patches
>>> to introduce the state/markers and not much else.
>> Oh, this hunk is new, not moved, I believe it's been here since I picked up
>> the series quite a while ago.  It actually has more to do with parent
>> pointers than delayed atts.  Basically when we try to add the parent pointer
>> during a create, the inode isnt fully constructed yet, so we have add the
>> fork here. I will put this in a separate patch and move it further up the
>> set.
>>
> 
> Ok.
> 
>>>
>>>>    	/*
>>>>    	 * If the attribute list is already in leaf format, jump straight to
>>>> @@ -292,40 +362,53 @@ xfs_attr_set_args(
>>>>    	if (xfs_attr_is_shortform(dp)) {
>>>>    		/*
>>>> -		 * If the attr was successfully set in shortform, the
>>>> -		 * transaction is committed and set to NULL.  Otherwise, is it
>>>> -		 * converted from shortform to leaf, and the transaction is
>>>> -		 * retained.
>>>> +		 * If the attr was successfully set in shortform, no need to
>>>> +		 * continue.  Otherwise, is it converted from shortform to leaf
>>>> +		 * and -EAGAIN is returned.
>>>>    		 */
>>>> -		error = xfs_attr_set_shortform(args, &leaf_bp);
>>>> -		if (error || !args->trans)
>>>> -			return error;
>>>> +		error = xfs_attr_set_shortform(args, leaf_bp);
>>>> +		if (error == -EAGAIN) {
>>>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>> +			dac->dela_state = XFS_DAS_ADD_LEAF;
>>>> +		}
>>>> +		return error;
>>>
>>> Similar to the previous patch, I wonder if we need the explicit states
>>> that are otherwise handled by existing inode state. For example, if the
>>> above returns -EAGAIN, xfs_attr_is_shortform() is no longer true on
>>> reentry, right? If that's the case for the other conversions, it seems
>>> like we might only need one state (XFS_DAS_FOUND_LBLK) for this
>>> function.
>> Ok, it looks like I can get away with out XFS_DAS_ADD_LEAF and
>> XFS_DAS_LEAF_TO_NODE.
>>
>> This is actually a little similar to how it was done when I was trying to
>> use flags instead of the state enums a long time ago.  At the time, I got
>> the impression people were concerned about the complexity and
>> maintainability.  So we went back to the enums because the explicite jumping
>> made it clear where the re-entry was to resume, and reduced the risk that a
>> person may mistakenly introduce a change that disrupts the reentry flow.
>> Though perhaps the current arrangement of refactoring has made that less
>> concerning?
>>
> 
> Perhaps. I think it just depends on context. It might not make sense to
> try and implement such a reentry model down in the node code where we
> have N different non-deterministic states to deal with; as opposed to
> here where we're looking at one of a handful of high level formats and
> the behavior is very predictable: try to add to the current format, else
> convert to the next.
Alrighty then, that sounds reasonable.  I try my best to recall history 
of the decisions just as a sort of guide of where we've been and where 
to go next.

> 
>>>
>>> BTW, that general approach might be more clear if we lifted the format
>>> conversions into this level from down in the format specific add
>>> handlers. The goal would be to make the high level flow look something
>>> like:
>>>
>>> 	if (shortform) {
>>> 		error = sf_try_add();
>>> 		if (error == -ENOSPC) {
>>> 			shortform_to_leaf(...);
>>> 			...
>>> 			return -EAGAIN;
>>> 		}
>> Well, actually this piece was hoisted out into the helper function in patch
>> 13.  So pulling this up is sort of like letting go of patch 13. :-)
>>
>> The history is: initially I had tried to reduce indentation here in v6 by
>> taking advantage of the _add_leaf label. Because I think in v5 we were
>> trying to unnest where some of the jump points were.  So in v6 I had:
>> "if(!shortform) goto leaf;" Which un-nests this shortform code.
>>
>> Then in the v7 review I think Dave suggested I should add the helper and
>> invert the check. So now we have "if(shortform()){ call_helper(); handle
>> -EAGAIN; }"
>>
>> So pulling up is a bit of a circle now.  But still functional if people
>> prefer it as it was.  Just need to keep track of the history so we avoid
>> going around again. :-)
>>
> 
> I don't think you need to drop that patch necessarily, but perhaps keep
> the conversion part to a separate helper and then introduce a similar
> patch for other formats..? In any event, that was just a followup
> thought so it might be reasonable to defer it to the next version and
> for now just see what it looks like to rely on the format states.
> 
>>
>>> 	} else if (xfs_bmap_one_block(...)) {
>> Mmm.... cant jump into the leaf logic right away.  We need to handle
>> releasing leaf_bp which looks like it got lost in the pseudo code?  IIRC
>> there is a race condition with the AIL that is resolved by holding the leaf
>> buffer across the transaction roll.  So we need to check for that and
>> release it upon reentry.
>>
> 
> That sounds more like an implementation detail. leaf_bp is set when we
> convert from shortform, so isn't this the next state either way?
Sort of, I think when we convert out of shortform, and we dont fit in a 
block, we skip over the leaf logic.  But the leaf_bp release should 
happen either way, so it cant belong to either state.

It is an implementation detail, it just sort of breaks up the if/else 
logic in this example.  So I just meant to point it out so that there 
isnt confusion as to why the next patch may not look quite like the 
pseudo code. Or unless I'm overlooking something?

> 
>>
>>> 		error = xfs_attr_leaf_try_add(args, *leaf_bp);
>>> 		if (error == -ENOSPC) {
>>> 			leaf_to_node(...);
>>> 			return -EAGAIN;
>>> 		}
>> Ok, so lift ENOSPC handler from xfs_attr_leaf_try_add
>>
>>>
>>> 		... state stuff for leaf add ...
>>> 	} else {
>>> 		error = xfs_attr_node_addname(dac);
>>> 	}
>>>
>>> Hm? Of course, something like that should be incorporated via
>>> independent refactoring patches.
>> I think what this becomes right now is:
>>
>> Drop patch 13
>> Add new patch xfs: Lift ENOSPC handler from xfs_attr_leaf_try_add
>>
>> ?
>>
> 
> Re: above, I don't think the patch needs to necessarily go away. Feel
> free to table this for now, just something to think about...
Ok, I may fiddle around with some other arrangements or table it if I 
dont see anything particuarly elegant

> 
>>>
>>>>    	}
>>>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>>> -		error = xfs_attr_leaf_addname(args);
>>>> -		if (error != -ENOSPC)
>>>> -			return error;
>>>> +das_add_leaf:
>>>> -		/*
>>>> -		 * Commit that transaction so that the node_addname()
>>>> -		 * call can manage its own transactions.
>>>> -		 */
>>>> -		error = xfs_defer_finish(&args->trans);
>>>> -		if (error)
>>>> -			return error;
>>>> +	/*
>>>> +	 * After a shortform to leaf conversion, we need to hold the leaf and
>>>> +	 * cylce out the transaction.  When we get back, we need to release
>>>> +	 * the leaf.
>>>> +	 */
>>>> +	if (*leaf_bp != NULL) {
>>>> +		xfs_trans_brelse(args->trans, *leaf_bp);
>>>> +		*leaf_bp = NULL;
>>>> +	}
>>>> -		/*
>>>> -		 * Commit the current trans (including the inode) and
>>>> -		 * start a new one.
>>>> -		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>>> -		if (error)
>>>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>>> +		error = xfs_attr_leaf_try_add(args, *leaf_bp);
>>>> +		switch (error) {
>>>> +		case -ENOSPC:
>>>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>> +			dac->dela_state = XFS_DAS_LEAF_TO_NODE;
>>>> +			return -EAGAIN;
>>>> +		case 0:
>>>> +			dac->dela_state = XFS_DAS_FOUND_LBLK;
>>>> +			return -EAGAIN;
>>>> +		default:
>>>>    			return error;
>>>> -
>>>> +		}
>>>> +das_leaf:
>>>> +		error = xfs_attr_leaf_addname(dac);
>>>> +		if (error == -ENOSPC) {
>>>> +			dac->dela_state = XFS_DAS_LEAF_TO_NODE;
>>>> +			return -EAGAIN;
>>>> +		}
>>>> +		return error;
>>>>    	}
>>>> -
>>>> -	error = xfs_attr_node_addname(args);
>>>> +das_node:
>>>> +	error = xfs_attr_node_addname(dac);
>>>>    	return error;
>>>>    }
>>>> @@ -716,28 +799,32 @@ xfs_attr_leaf_try_add(
>>>>     *
>>>>     * This leaf block cannot have a "remote" value, we only call this routine
>>>>     * if bmap_one_block() says there is only one block (ie: no remote blks).
>>>> + *
>>>> + * This routine is meant to function as a delayed operation, and may return
>>>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>>>> + * to handle this, and recall the function until a successful error code is
>>>> + * returned.
>>>>     */
>>>>    STATIC int
>>>>    xfs_attr_leaf_addname(
>>>> -	struct xfs_da_args	*args)
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	int			error, forkoff;
>>>> -	struct xfs_buf		*bp = NULL;
>>>> -	struct xfs_inode	*dp = args->dp;
>>>> -
>>>> -	trace_xfs_attr_leaf_addname(args);
>>>> -
>>>> -	error = xfs_attr_leaf_try_add(args, bp);
>>>> -	if (error)
>>>> -		return error;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_buf			*bp = NULL;
>>>> +	int				error, forkoff;
>>>> +	struct xfs_inode		*dp = args->dp;
>>>> -	/*
>>>> -	 * Commit the transaction that added the attr name so that
>>>> -	 * later routines can manage their own transactions.
>>>> -	 */
>>>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>>>> -	if (error)
>>>> -		return error;
>>>> +	/* State machine switch */
>>>> +	switch (dac->dela_state) {
>>>> +	case XFS_DAS_FLIP_LFLAG:
>>>> +		goto das_flip_flag;
>>>> +	case XFS_DAS_ALLOC_LEAF:
>>>> +		goto das_alloc_leaf;
>>>> +	case XFS_DAS_RM_LBLK:
>>>> +		goto das_rm_lblk;
>>>> +	default:
>>>> +		break;
>>>> +	}
>>>>    	/*
>>>>    	 * If there was an out-of-line value, allocate the blocks we
>>>> @@ -746,7 +833,28 @@ xfs_attr_leaf_addname(
>>>>    	 * maximum size of a transaction and/or hit a deadlock.
>>>>    	 */
>>>>    	if (args->rmtblkno > 0) {
>>>> -		error = xfs_attr_rmtval_set(args);
>>>> +
>>>> +		/* Open coded xfs_attr_rmtval_set without trans handling */
>>>> +		error = xfs_attr_rmtval_set_init(dac);
>>>> +		if (error)
>>>> +			return error;
>>>> +
>>>> +		/*
>>>> +		 * Roll through the "value", allocating blocks on disk as
>>>> +		 * required.
>>>> +		 */
>>>> +das_alloc_leaf:
>>>
>>> If we filter out the setup above, it seems like this state could be
>>> reduced to check for ->blkcnt > 0.
>> By filter out the set up, you mean to introduce the setup flag like you
>> mentioned earlier? For example:
>> 	if(flags & setup == 0){
>> 		setup();
>> 		flags |= setup;
>> 	}
>>
>> To be clear, if we did that, we're talking about adding an "int setup_flags"
>> to the dac. And then defineing a XFS_DAC_SETUP_* scheme. Like a
>> XFS_DAC_SETUP_ADD_NAME, and an XFS_DAC_SETUP_NODE_REMVE_NAME and so on.
>> Because we cant have multiple functions sharing the same set up flag if they
>> ever call each others.
>>
>> Is that what you mean to imply?  Otherwise I may not be clear on what you
>> mean by filtering out the set up.
>>
> 
> Well we already have a flag scheme for the defer thing, right? Is there
> any reason we couldn't define a similar DAC_DEFER_INIT and let each
> operation (add/remove) use it as appropriate? 
You're right, I momentarily forgot I had added the flag memmber to hoist 
the defer finish out.  Yes, I think using it here would be appropriate. :-)

Note again that I'm just
> trying to think about potential simplifications. If there are isolated
> functions that can be made clearly/simply idempotent (like init/setup
> helpers tend to be), then doing so might be helpful. I.e., if
> xfs_attr_rmtval_set_init() could do something like:
> 
> {
> 	if (dax->flags & DAC_RMTVAL_SET_INIT)
> 		return;
> 
> 	dax->flags |= DAC_RMTVAL_SET_INIT;
> 	...
> }
This seems reasonable, sorry for the earlier confusion.  On a side note 
though, a bit ago Dave had suggested we select a different acronym 
because "dac" is too easy to mix up with other existing schemes like dax 
;-)  I'm not super concerned about it right now because it's purely an 
asthetic thing, but eventuallly we probably should come up with 
something. :-)

> 
> ... and that removes an execution state, then that might be a win. If it
> requires more complexity than that, then perhaps the suggestion is not
> worthwile. ;P
I dont think it will be too complicated, and may be of use in the next 
phase of the series.  I will move forward with an init flag scheme in v9

> 
>>>
>>>> +		while (dac->blkcnt > 0) {
>>>> +			error = xfs_attr_rmtval_set_blk(dac);
>>>> +			if (error)
>>>> +				return error;
>>>> +
>>>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>> +			dac->dela_state = XFS_DAS_ALLOC_LEAF;
>>>> +			return -EAGAIN;
>>>> +		}
>>>> +
>>>> +		error = xfs_attr_rmtval_set_value(args);
>>>>    		if (error)
>>>>    			return error;
>>>>    	}
>>>> @@ -765,22 +873,25 @@ xfs_attr_leaf_addname(
>>>>    		error = xfs_attr3_leaf_flipflags(args);
>>>>    		if (error)
>>>>    			return error;
>>>> -		/*
>>>> -		 * Commit the flag value change and start the next trans in
>>>> -		 * series.
>>>> -		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>> -		if (error)
>>>> -			return error;
>>>> -
>>>> +		dac->dela_state = XFS_DAS_FLIP_LFLAG;
>>>> +		return -EAGAIN;
>>>> +das_flip_flag:
>>>>    		/*
>>>>    		 * Dismantle the "old" attribute/value pair by removing
>>>>    		 * a "remote" value (if it exists).
>>>>    		 */
>>>>    		xfs_attr_restore_rmt_blk(args);
>>>> +		xfs_attr_rmtval_invalidate(args);
>>>> +das_rm_lblk:
>>>>    		if (args->rmtblkno) {
>>>> -			error = xfs_attr_rmtval_remove(args);
>>>> +			error = __xfs_attr_rmtval_remove(args);
>>>> +
>>>> +			if (error == -EAGAIN) {
>>>> +				dac->dela_state = XFS_DAS_RM_LBLK;
>>>> +				return -EAGAIN;
>>>> +			}
>>>> +
>>>
>>> This whole function looks like it could use more refactoring to split
>>> out the rename case.
>> Hmm, how about we take every thing inside the "if (args->op_flags &
>> XFS_DA_OP_RENAME) {"  and put it in a xfs_attr_leaf_rename() helper? Then
>> pull the helper into the calling function?
>>
> 
> That would help. I'm not sure what the optimal breakdown is off the top
> of my head tbh. This function is kind of a logical beast between dealing
> with remote blocks and rename and combinations of the two, so I'd have
> to stare at that one some more. 
No worries, I think some versions just have to become exploratory 
efforts for that reason.

In general the goal should be to try and
> avoid jumping in the middle of logic branches as much as possible so
> there's a nice and visible distinction between the state code and the
> functional code.
> 
> Brian

Ok, I think the *_rename() helpers will help with the unnesting here. 
I'll put it together and see what folks think.

Thank you thank you thank you, for all your time and pateince with this, 
I know its super complicated and I really appreciate all the reviews!

Allison
> 
>>>
>>>>    			if (error)
>>>>    				return error;
>>>>    		}
>>>> @@ -799,15 +910,11 @@ xfs_attr_leaf_addname(
>>>>    		/*
>>>>    		 * If the result is small enough, shrink it all into the inode.
>>>>    		 */
>>>> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>>>> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
>>>> +		if (forkoff)
>>>>    			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>>>> -			/* bp is gone due to xfs_da_shrink_inode */
>>>> -			if (error)
>>>> -				return error;
>>>> -			error = xfs_defer_finish(&args->trans);
>>>> -			if (error)
>>>> -				return error;
>>>> -		}
>>>> +
>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>    	} else if (args->rmtblkno > 0) {
>>>>    		/*
>>>> @@ -967,16 +1074,23 @@ xfs_attr_node_hasname(
>>>>     *
>>>>     * "Remote" attribute values confuse the issue and atomic rename operations
>>>>     * add a whole extra layer of confusion on top of that.
>>>> + *
>>>> + * This routine is meant to function as a delayed operation, and may return
>>>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>>>> + * to handle this, and recall the function until a successful error code is
>>>> + *returned.
>>>>     */
>>>>    STATIC int
>>>>    xfs_attr_node_addname(
>>>> -	struct xfs_da_args	*args)
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	struct xfs_da_state	*state;
>>>> -	struct xfs_da_state_blk	*blk;
>>>> -	struct xfs_inode	*dp;
>>>> -	struct xfs_mount	*mp;
>>>> -	int			retval, error;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_da_state		*state = NULL;
>>>> +	struct xfs_da_state_blk		*blk;
>>>> +	struct xfs_inode		*dp;
>>>> +	struct xfs_mount		*mp;
>>>> +	int				retval = 0;
>>>> +	int				error = 0;
>>>>    	trace_xfs_attr_node_addname(args);
>>>> @@ -985,7 +1099,21 @@ xfs_attr_node_addname(
>>>>    	 */
>>>>    	dp = args->dp;
>>>>    	mp = dp->i_mount;
>>>> -restart:
>>>> +
>>>> +	/* State machine switch */
>>>> +	switch (dac->dela_state) {
>>>> +	case XFS_DAS_FLIP_NFLAG:
>>>> +		goto das_flip_flag;
>>>> +	case XFS_DAS_FOUND_NBLK:
>>>> +		goto das_found_nblk;
>>>> +	case XFS_DAS_ALLOC_NODE:
>>>> +		goto das_alloc_node;
>>>> +	case XFS_DAS_RM_NBLK:
>>>> +		goto das_rm_nblk;
>>>> +	default:
>>>> +		break;
>>>> +	}
>>>> +
>>>>    	/*
>>>>    	 * Search to see if name already exists, and get back a pointer
>>>>    	 * to where it should go.
>>>> @@ -1031,19 +1159,13 @@ xfs_attr_node_addname(
>>>>    			error = xfs_attr3_leaf_to_node(args);
>>>>    			if (error)
>>>>    				goto out;
>>>> -			error = xfs_defer_finish(&args->trans);
>>>> -			if (error)
>>>> -				goto out;
>>>>    			/*
>>>> -			 * Commit the node conversion and start the next
>>>> -			 * trans in the chain.
>>>> +			 * Restart routine from the top.  No need to set  the
>>>> +			 * state
>>>>    			 */
>>>> -			error = xfs_trans_roll_inode(&args->trans, dp);
>>>> -			if (error)
>>>> -				goto out;
>>>> -
>>>> -			goto restart;
>>>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>> +			return -EAGAIN;
>>>>    		}
>>>>    		/*
>>>> @@ -1055,9 +1177,7 @@ xfs_attr_node_addname(
>>>>    		error = xfs_da3_split(state);
>>>>    		if (error)
>>>>    			goto out;
>>>> -		error = xfs_defer_finish(&args->trans);
>>>> -		if (error)
>>>> -			goto out;
>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>    	} else {
>>>>    		/*
>>>>    		 * Addition succeeded, update Btree hashvals.
>>>> @@ -1072,13 +1192,9 @@ xfs_attr_node_addname(
>>>>    	xfs_da_state_free(state);
>>>>    	state = NULL;
>>>> -	/*
>>>> -	 * Commit the leaf addition or btree split and start the next
>>>> -	 * trans in the chain.
>>>> -	 */
>>>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>>>> -	if (error)
>>>> -		goto out;
>>>> +	dac->dela_state = XFS_DAS_FOUND_NBLK;
>>>> +	return -EAGAIN;
>>>> +das_found_nblk:
>>>
>>> Same deal here. Any time we have this return -EAGAIN followed by a label
>>> pattern I think we're going to want to think about refactoring things
>>> more first to avoid dumping it in the middle of some unnecessarily large
>>> function.
>> Ok, similar pattern here too then?  Everything in "if (args->op_flags &
>> XFS_DA_OP_RENAME) {" goes in a new xfs_attr_node_rename() helper?  Then
>> hoist upwards?
>>
>> Thanks for the reviewing!!
>> Allison
>>
>>>
>>> Brian
>>>
>>>>    	/*
>>>>    	 * If there was an out-of-line value, allocate the blocks we
>>>> @@ -1087,7 +1203,27 @@ xfs_attr_node_addname(
>>>>    	 * maximum size of a transaction and/or hit a deadlock.
>>>>    	 */
>>>>    	if (args->rmtblkno > 0) {
>>>> -		error = xfs_attr_rmtval_set(args);
>>>> +		/* Open coded xfs_attr_rmtval_set without trans handling */
>>>> +		error = xfs_attr_rmtval_set_init(dac);
>>>> +		if (error)
>>>> +			return error;
>>>> +
>>>> +		/*
>>>> +		 * Roll through the "value", allocating blocks on disk as
>>>> +		 * required.
>>>> +		 */
>>>> +das_alloc_node:
>>>> +		while (dac->blkcnt > 0) {
>>>> +			error = xfs_attr_rmtval_set_blk(dac);
>>>> +			if (error)
>>>> +				return error;
>>>> +
>>>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>> +			dac->dela_state = XFS_DAS_ALLOC_NODE;
>>>> +			return -EAGAIN;
>>>> +		}
>>>> +
>>>> +		error = xfs_attr_rmtval_set_value(args);
>>>>    		if (error)
>>>>    			return error;
>>>>    	}
>>>> @@ -1110,18 +1246,26 @@ xfs_attr_node_addname(
>>>>    		 * Commit the flag value change and start the next trans in
>>>>    		 * series
>>>>    		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>> -		if (error)
>>>> -			goto out;
>>>> -
>>>> +		dac->dela_state = XFS_DAS_FLIP_NFLAG;
>>>> +		return -EAGAIN;
>>>> +das_flip_flag:
>>>>    		/*
>>>>    		 * Dismantle the "old" attribute/value pair by removing
>>>>    		 * a "remote" value (if it exists).
>>>>    		 */
>>>>    		xfs_attr_restore_rmt_blk(args);
>>>> +		xfs_attr_rmtval_invalidate(args);
>>>> +
>>>> +das_rm_nblk:
>>>>    		if (args->rmtblkno) {
>>>> -			error = xfs_attr_rmtval_remove(args);
>>>> +			error = __xfs_attr_rmtval_remove(args);
>>>> +
>>>> +			if (error == -EAGAIN) {
>>>> +				dac->dela_state = XFS_DAS_RM_NBLK;
>>>> +				return -EAGAIN;
>>>> +			}
>>>> +
>>>>    			if (error)
>>>>    				return error;
>>>>    		}
>>>> @@ -1139,7 +1283,6 @@ xfs_attr_node_addname(
>>>>    		error = xfs_da3_node_lookup_int(state, &retval);
>>>>    		if (error)
>>>>    			goto out;
>>>> -
>>>>    		/*
>>>>    		 * Remove the name and update the hashvals in the tree.
>>>>    		 */
>>>> @@ -1147,7 +1290,6 @@ xfs_attr_node_addname(
>>>>    		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>>>    		error = xfs_attr3_leaf_remove(blk->bp, args);
>>>>    		xfs_da3_fixhashpath(state, &state->path);
>>>> -
>>>>    		/*
>>>>    		 * Check to see if the tree needs to be collapsed.
>>>>    		 */
>>>> @@ -1155,11 +1297,9 @@ xfs_attr_node_addname(
>>>>    			error = xfs_da3_join(state);
>>>>    			if (error)
>>>>    				goto out;
>>>> -			error = xfs_defer_finish(&args->trans);
>>>> -			if (error)
>>>> -				goto out;
>>>> -		}
>>>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>> +		}
>>>>    	} else if (args->rmtblkno > 0) {
>>>>    		/*
>>>>    		 * Added a "remote" value, just clear the incomplete flag.
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>> index 0e8ae1a..67af9d1 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>> @@ -93,6 +93,16 @@ enum xfs_delattr_state {
>>>>    				      /* Zero is uninitalized */
>>>>    	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
>>>>    	XFS_DAS_RMTVAL_REMOVE,	      /* We are removing remote value blocks */
>>>> +	XFS_DAS_ADD_LEAF,	      /* We are adding a leaf attr */
>>>> +	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
>>>> +	XFS_DAS_LEAF_TO_NODE,	      /* Converted leaf to node */
>>>> +	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
>>>> +	XFS_DAS_ALLOC_LEAF,	      /* We are allocating leaf blocks */
>>>> +	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
>>>> +	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
>>>> +	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
>>>> +	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
>>>> +	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
>>>>    };
>>>>    /*
>>>> @@ -105,8 +115,13 @@ enum xfs_delattr_state {
>>>>     */
>>>>    struct xfs_delattr_context {
>>>>    	struct xfs_da_args      *da_args;
>>>> +	struct xfs_bmbt_irec	map;
>>>> +	struct xfs_buf		*leaf_bp;
>>>> +	xfs_fileoff_t		lfileoff;
>>>>    	struct xfs_da_state     *da_state;
>>>>    	struct xfs_da_state_blk *blk;
>>>> +	xfs_dablk_t		lblkno;
>>>> +	int			blkcnt;
>>>>    	unsigned int            flags;
>>>>    	enum xfs_delattr_state  dela_state;
>>>>    };
>>>> @@ -126,6 +141,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>>>    int xfs_attr_get(struct xfs_da_args *args);
>>>>    int xfs_attr_set(struct xfs_da_args *args);
>>>>    int xfs_attr_set_args(struct xfs_da_args *args);
>>>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac, struct xfs_buf **leaf_bp);
>>>>    int xfs_has_attr(struct xfs_da_args *args);
>>>>    int xfs_attr_remove_args(struct xfs_da_args *args);
>>>>    int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> index f55402b..4d15f45 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> @@ -19,6 +19,7 @@
>>>>    #include "xfs_bmap_btree.h"
>>>>    #include "xfs_bmap.h"
>>>>    #include "xfs_attr_sf.h"
>>>> +#include "xfs_attr.h"
>>>>    #include "xfs_attr_remote.h"
>>>>    #include "xfs_attr.h"
>>>>    #include "xfs_attr_leaf.h"
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> index fd4be9d..9607fd2 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> @@ -443,7 +443,7 @@ xfs_attr_rmtval_get(
>>>>     * Find a "hole" in the attribute address space large enough for us to drop the
>>>>     * new attribute's value into
>>>>     */
>>>> -STATIC int
>>>> +int
>>>>    xfs_attr_rmt_find_hole(
>>>>    	struct xfs_da_args	*args)
>>>>    {
>>>> @@ -470,7 +470,7 @@ xfs_attr_rmt_find_hole(
>>>>    	return 0;
>>>>    }
>>>> -STATIC int
>>>> +int
>>>>    xfs_attr_rmtval_set_value(
>>>>    	struct xfs_da_args	*args)
>>>>    {
>>>> @@ -630,6 +630,71 @@ xfs_attr_rmtval_set(
>>>>    }
>>>>    /*
>>>> + * Find a hole for the attr and store it in the delayed attr context.  This
>>>> + * initializes the context to roll through allocating an attr extent for a
>>>> + * delayed attr operation
>>>> + */
>>>> +int
>>>> +xfs_attr_rmtval_set_init(
>>>> +	struct xfs_delattr_context	*dac)
>>>> +{
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_bmbt_irec		*map = &dac->map;
>>>> +	int error;
>>>> +
>>>> +	dac->lblkno = 0;
>>>> +	dac->lfileoff = 0;
>>>> +	dac->blkcnt = 0;
>>>> +	args->rmtblkcnt = 0;
>>>> +	args->rmtblkno = 0;
>>>> +	memset(map, 0, sizeof(struct xfs_bmbt_irec));
>>>> +
>>>> +	error = xfs_attr_rmt_find_hole(args);
>>>> +	if (error)
>>>> +		return error;
>>>> +
>>>> +	dac->blkcnt = args->rmtblkcnt;
>>>> +	dac->lblkno = args->rmtblkno;
>>>> +
>>>> +	return error;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Write one block of the value associated with an attribute into the
>>>> + * out-of-line buffer that we have defined for it. This is similar to a subset
>>>> + * of xfs_attr_rmtval_set, but records the current block to the delayed attr
>>>> + * context, and leaves transaction handling to the caller.
>>>> + */
>>>> +int
>>>> +xfs_attr_rmtval_set_blk(
>>>> +	struct xfs_delattr_context	*dac)
>>>> +{
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_inode		*dp = args->dp;
>>>> +	struct xfs_bmbt_irec		*map = &dac->map;
>>>> +	int nmap;
>>>> +	int error;
>>>> +
>>>> +	nmap = 1;
>>>> +	error = xfs_bmapi_write(args->trans, dp,
>>>> +		  (xfs_fileoff_t)dac->lblkno,
>>>> +		  dac->blkcnt, XFS_BMAPI_ATTRFORK,
>>>> +		  args->total, map, &nmap);
>>>> +	if (error)
>>>> +		return error;
>>>> +
>>>> +	ASSERT(nmap == 1);
>>>> +	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
>>>> +	       (map->br_startblock != HOLESTARTBLOCK));
>>>> +
>>>> +	/* roll attribute extent map forwards */
>>>> +	dac->lblkno += map->br_blockcount;
>>>> +	dac->blkcnt -= map->br_blockcount;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +/*
>>>>     * Remove the value associated with an attribute by deleting the
>>>>     * out-of-line buffer that it is stored on.
>>>>     */
>>>> @@ -671,48 +736,6 @@ xfs_attr_rmtval_invalidate(
>>>>    }
>>>>    /*
>>>> - * Remove the value associated with an attribute by deleting the
>>>> - * out-of-line buffer that it is stored on.
>>>> - */
>>>> -int
>>>> -xfs_attr_rmtval_remove(
>>>> -	struct xfs_da_args      *args)
>>>> -{
>>>> -	xfs_dablk_t		lblkno;
>>>> -	int			blkcnt;
>>>> -	int			error = 0;
>>>> -	int			done = 0;
>>>> -
>>>> -	trace_xfs_attr_rmtval_remove(args);
>>>> -
>>>> -	error = xfs_attr_rmtval_invalidate(args);
>>>> -	if (error)
>>>> -		return error;
>>>> -	/*
>>>> -	 * Keep de-allocating extents until the remote-value region is gone.
>>>> -	 */
>>>> -	lblkno = args->rmtblkno;
>>>> -	blkcnt = args->rmtblkcnt;
>>>> -	while (!done) {
>>>> -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>>>> -				    XFS_BMAPI_ATTRFORK, 1, &done);
>>>> -		if (error)
>>>> -			return error;
>>>> -		error = xfs_defer_finish(&args->trans);
>>>> -		if (error)
>>>> -			return error;
>>>> -
>>>> -		/*
>>>> -		 * Close out trans and start the next one in the chain.
>>>> -		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>> -		if (error)
>>>> -			return error;
>>>> -	}
>>>> -	return 0;
>>>> -}
>>>> -
>>>> -/*
>>>>     * Remove the value associated with an attribute by deleting the out-of-line
>>>>     * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>>>>     * transaction and recall the function
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> index ee3337b..482dff9 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> @@ -15,4 +15,8 @@ int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>>>    		xfs_buf_flags_t incore_flags);
>>>>    int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>>>    int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>>>> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>>>> +int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
>>>> +int xfs_attr_rmtval_set_init(struct xfs_delattr_context *dac);
>>>>    #endif /* __XFS_ATTR_REMOTE_H__ */
>>>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>>>> index c42f90e..3e8cec5 100644
>>>> --- a/fs/xfs/xfs_attr_inactive.c
>>>> +++ b/fs/xfs/xfs_attr_inactive.c
>>>> @@ -15,6 +15,7 @@
>>>>    #include "xfs_da_format.h"
>>>>    #include "xfs_da_btree.h"
>>>>    #include "xfs_inode.h"
>>>> +#include "xfs_attr.h"
>>>>    #include "xfs_attr_remote.h"
>>>>    #include "xfs_trans.h"
>>>>    #include "xfs_bmap.h"
>>>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>>>> index a4323a6..26dc8bf 100644
>>>> --- a/fs/xfs/xfs_trace.h
>>>> +++ b/fs/xfs/xfs_trace.h
>>>> @@ -1784,7 +1784,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
>>>>    DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
>>>>    DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
>>>> -DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
>>>>    #define DEFINE_DA_EVENT(name) \
>>>>    DEFINE_EVENT(xfs_da_class, name, \
>>>> -- 
>>>> 2.7.4
>>>>
>>>
>>
> 
