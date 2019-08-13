Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfHMCVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 22:21:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D2J1ah029250
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:21:22 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u9nbtb5nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:21:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D2HeBd085502
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:19:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nregjvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:19:21 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D2JL6G029516
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:19:21 GMT
Subject: Re: [PATCH v2 15/18] xfs: Add delayed attribute routines
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-16-allison.henderson@oracle.com>
 <20190812172933.GI7138@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <238c7754-f75f-1afa-f361-20d981b2f0e7@oracle.com>
Date: Mon, 12 Aug 2019 19:19:20 -0700
MIME-Version: 1.0
In-Reply-To: <20190812172933.GI7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 10:29 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:23PM -0700, Allison Collins wrote:
>> This patch adds new delayed attribute routines:
>>
>> xfs_attr_da_set_args
>> xfs_attr_da_remove_args
>> xfs_attr_da_leaf_addname
>> xfs_attr_da_node_addname
>> xfs_attr_da_node_removename
> 
> I think the "_da_" thing is shorthand for "deferred attr", right?
> 
> If so, it's way too close to the other "_da_" (which is shorthand for
> "directory/attr") for my taste.
> 
> xfs_attr_set_later()
> xfs_attr_remove_later()
> xfs_leaf_addname_later()
> xfs_node_addname_later()
> xfs_node_remove_later() ?

Sure, I'm not very particular about the names, I think the later scheme 
is fine.

> 
>> These routines are similar to their existing counter parts,
>> but they do not roll or commit transactions.  They instead
>> return -EGAIN to allow the calling function to roll the
> 
> EAGAIN...
> 
>> transaction and recall the function.  This allows the
>> attribute operations to be logged in multiple smaller
>> transactions.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 720 +++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr.h |   2 +
>>   2 files changed, 722 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ca57202..9931e50 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -47,6 +47,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>    */
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_da_leaf_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>   STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);
>>   
>> @@ -55,12 +56,16 @@ STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_da_node_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_da_node_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>   
>> +STATIC int
>> +xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
> 
> STATIC int xfs_attr_leaf_try_add(...)
> 
> (no newline between the return type and the function name)
Ok, will clean out

> 
>>   
>>   int
>>   xfs_attr_args_init(
> 
> <snip>
> 
>> +STATIC int
>> +xfs_attr_da_leaf_addname(
>> +	struct xfs_da_args	*args)
>> +{
>> +	int			error, forkoff, nmap;
>> +	struct xfs_buf		*bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_bmbt_irec	*map = &args->dc.map;
> 
> <snip>
> 
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the
>> +	 * incomplete flags on the "new" and "old" attribute/value pairs
>> +	 * so that one disappears and one appears atomically.  Then we
>> +	 * must remove the "old" attribute/value pair.
>> +	 */
>> +	if (args->op_flags & XFS_DA_OP_RENAME) {
>> +		/*
>> +		 * In a separate transaction, set the incomplete flag on the
>> +		 * "old" attr and clear the incomplete flag on the "new" attr.
> 
> Echoing Christoph, can this new attr implementation set the attr value
> through the log so we can get rid of the INCOMPLETE flag switcheroo
> business?  I see a lot of nearly duplicated code and if we're going to
> have to support having two paths through the attr set/remove code, we
> could at least avoid the weird warts of the old path when designing the
> new one.

Hmm, Ok, I will see what I can do. I dont know that we could completely 
remove it since the old code path will still need it but maybe we can 
get away from it in the delayed code path here.

> 
> <snip more>
> 
>> +STATIC int
>> +xfs_attr_da_node_removename(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_da_state	*state = NULL;
>> +	struct xfs_da_state_blk	*blk;
>> +	struct xfs_buf		*bp;
>> +	int			error, forkoff, retval = 0;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			done = 0;
>> +
>> +	trace_xfs_attr_node_removename(args);
>> +
>> +	if (args->dc.state == NULL) {
>> +		error = xfs_attr_node_hasname(args, &args->dc.state);
>> +		if (error != -EEXIST)
>> +			goto out;
>> +		else
>> +			error = 0;
>> +
>> +		/*
>> +		 * If there is an out-of-line value, de-allocate the blocks.
>> +		 * This is done before we remove the attribute so that we don't
>> +		 * overflow the maximum size of a transaction and/or hit a
>> +		 * deadlock.
>> +		 */
>> +		state = args->dc.state;
>> +		args->dc.blk = &state->path.blk[state->path.active - 1];
>> +		ASSERT(args->dc.blk->bp != NULL);
>> +		ASSERT(args->dc.blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +	}
>> +	state = args->dc.state;
>> +	blk = args->dc.blk;
>> +
>> +	if (args->rmtblkno > 0 && !(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
>> +		if (!xfs_attr3_leaf_flag_is_set(args)) {
>> +			/*
>> +			 * Fill in disk block numbers in the state structure
>> +			 * so that we can get the buffers back after we commit
>> +			 * several transactions in the following calls.
>> +			 */
>> +			error = xfs_attr_fillstate(state);
>> +			if (error)
>> +				goto out;
>> +
>> +			/*
>> +			 * Mark the attribute as INCOMPLETE, then bunmapi() the
>> +			 * remote value.
>> +			 */
>> +			error = xfs_attr3_leaf_setflag(args);
>> +			if (error)
>> +				goto out;
>> +
>> +			return -EAGAIN;
>> +		}
>> +
>> +		if (!(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
>> +			error = xfs_attr_rmtval_remove_value(args);
>> +			if (error)
>> +				goto out;
>> +		}
>> +
>> +		args->dc.flags |= XFS_DC_RM_NODE_BLKS;
> 
> This ought to be set in the if clause above...
Ok, will tuck that in

> 
>> +		while (!done && !error) {
>> +			error = xfs_bunmapi(args->trans, args->dp,
>> +				    args->rmtblkno, args->rmtblkcnt,
>> +				    XFS_BMAPI_ATTRFORK, 1, &done);
>> +			if (error)
>> +				return error;
>> +
>> +			if (!done)
>> +				return -EAGAIN;
>> +		}
> 
> Probably worth a comment to make it a little clearer that this is the
> bottom part of xfs_attr_rmtval_remove but open-coded for this case.
> 
> I wish this new attr path could share more code with the old one,
> though I dunno, probably you've already done that analysis and decided
> that cutting this up into ~30 tiny functions isn't worth it...?

Ok, I will work in some comments.  Yes, at one point I finally decided 
that further modularizing every little bit was starting to make things 
more complicated than not.

> 
> (Yeah, snip all the way to the end because I need to go rest my eyes for
> a bit but didn't want to delay this reply further.)
> 
> --D
> 

Yes, it is convoluted to follow.  Truth be told, I do think the set is a 
bit complex, but also good illustration of what the -EAGAIN solution 
looks like in practice.  I'm not really sure if there are better 
approaches, but I'm certainly open to ideas or optimizations!  :-)

Thanks!
Allison
