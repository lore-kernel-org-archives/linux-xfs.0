Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCCAC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3191207DD
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d3Y1V320"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEDXQy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 19:16:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45654 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgEDXQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 19:16:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NDMUf092620
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xwLZwT2Cw6jNAEO2ieYSmkD1HGewc6CQWrBGEv7DgY0=;
 b=d3Y1V320JJUJYN+BR9CE1J7sne8/tZOuTARu5e5wQkuyLHq1F61WGUjCOfuSipc+2+67
 s30I0Xhcg39oMQY2MsagM0nldNFCrL1zaKqCFeLCPrpmOYbm7WNC6mjL7/emAywm3L8+
 HxcYDdThiZLxzAf0GshZR4/pZpFVyYdgnCfj4h6gtN7qGtaMp3EsVrGeQTAt25IPtmOF
 IAA8rHy6msUBdyKUh5NmHEqq4y7d17Y7pBlvSqMnSIcRDyPbJbZMAMN485lUuafNlwSb
 Nf4U2Za5SXK3g6bz2/doy/rbwQ6FthP0OnfeJjZfAI0oYPjf0eBvP2GrJU+CtfRWq5AW Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tm9skr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:16:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NBbT8103670
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:16:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30t1r3hms1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:16:51 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044NGoYf001510
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:16:50 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:16:50 -0700
Subject: Re: [PATCH v9 20/24] xfs: Simplify xfs_attr_node_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-21-allison.henderson@oracle.com>
 <20200504190612.GG5703@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <461b1dc8-4ccf-ff88-1a91-1b452ec7ab3a@oracle.com>
Date:   Mon, 4 May 2020 16:16:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504190612.GG5703@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 12:06 PM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:12PM -0700, Allison Collins wrote:
>> Quick patch to unnest the rename logic in the node code path.  This will
>> help simplify delayed attr logic later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 131 +++++++++++++++++++++++------------------------
>>   1 file changed, 64 insertions(+), 67 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 1810f90..9171895 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1030,83 +1030,80 @@ xfs_attr_node_addname(
>>   			return error;
>>   	}
>>   
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the
>> -	 * incomplete flags on the "new" and "old" attribute/value pairs
>> -	 * so that one disappears and one appears atomically.  Then we
>> -	 * must remove the "old" attribute/value pair.
>> -	 */
>> -	if (args->op_flags & XFS_DA_OP_RENAME) {
>> -		/*
>> -		 * In a separate transaction, set the incomplete flag on the
>> -		 * "old" attr and clear the incomplete flag on the "new" attr.
>> -		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			goto out;
>> +	if ((args->op_flags & XFS_DA_OP_RENAME) == 0) {
> 
> Same comments about the commit message and the if test as the previous
> patch.
> 
> Admittedly I'm now starting to wonder if this patch and the previous one
> should really just hoist the taken and not-taken branches into separate
> functions, but maybe you've already gone around and around on that, and
> everyone else already thought we have too many small functions...
Yes, I had played with that and even suggested it myself in the last 
review.  What I didnt like about it after prototyping it, was having to 
plumb around the leaf_bp that is still needed for a rename, and also the 
state machine logic ends up getting plumbed downward, instead of trying 
to keep it up in one high level function.

Really the initial motivation for this patch was to just avoid putting 
xfs_das_* labels in the middle of if{} statements or loops when we get 
further down the set.  With that goal in mind, this solution seemed like 
the least amount of required surgery.  Though the patch itself tends to 
suggest a helper, I figure I'd let people consider this first before 
jumping to the later option which will end up with more plumbing.

Allison

> 
> --D
> 
>>   		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series
>> +		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			goto out;
>> +		if (args->rmtblkno > 0)
>> +			error = xfs_attr3_leaf_clearflag(args);
>> +		retval = error;
>> +		goto out;
>> +	}
>>   
>> -		/*
>> -		 * Dismantle the "old" attribute/value pair by removing
>> -		 * a "remote" value (if it exists).
>> -		 */
>> -		xfs_attr_restore_rmt_blk(args);
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the incomplete
>> +	 * flags on the "new" and "old" attribute/value pairs so that one
>> +	 * disappears and one appears atomically.  Then we must remove the "old"
>> +	 * attribute/value pair.
>> +	 *
>> +	 * In a separate transaction, set the incomplete flag on the "old" attr
>> +	 * and clear the incomplete flag on the "new" attr.
>> +	 */
>> +	error = xfs_attr3_leaf_flipflags(args);
>> +	if (error)
>> +		goto out;
>> +	/*
>> +	 * Commit the flag value change and start the next trans in series
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +	if (error)
>> +		goto out;
>>   
>> -		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_invalidate(args);
>> -			if (error)
>> -				return error;
>> +	/*
>> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> +	 * (if it exists).
>> +	 */
>> +	xfs_attr_restore_rmt_blk(args);
>>   
>> -			error = xfs_attr_rmtval_remove(args);
>> -			if (error)
>> -				return error;
>> -		}
>> +	if (args->rmtblkno) {
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
>>   
>> -		/*
>> -		 * Re-find the "old" attribute entry after any split ops.
>> -		 * The INCOMPLETE flag means that we will find the "old"
>> -		 * attr, not the "new" one.
>> -		 */
>> -		args->attr_filter |= XFS_ATTR_INCOMPLETE;
>> -		state = xfs_da_state_alloc();
>> -		state->args = args;
>> -		state->mp = mp;
>> -		state->inleaf = 0;
>> -		error = xfs_da3_node_lookup_int(state, &retval);
>> +		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>> -			goto out;
>> +			return error;
>> +	}
>>   
>> -		/*
>> -		 * Remove the name and update the hashvals in the tree.
>> -		 */
>> -		blk = &state->path.blk[ state->path.active-1 ];
>> -		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> -		error = xfs_attr3_leaf_remove(blk->bp, args);
>> -		xfs_da3_fixhashpath(state, &state->path);
>> +	/*
>> +	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>> +	 * flag means that we will find the "old" attr, not the "new" one.
>> +	 */
>> +	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>> +	state = xfs_da_state_alloc();
>> +	state->args = args;
>> +	state->mp = mp;
>> +	state->inleaf = 0;
>> +	error = xfs_da3_node_lookup_int(state, &retval);
>> +	if (error)
>> +		goto out;
>>   
>> -		/*
>> -		 * Check to see if the tree needs to be collapsed.
>> -		 */
>> -		if (retval && (state->path.active > 1)) {
>> -			error = xfs_da3_join(state);
>> -			if (error)
>> -				goto out;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				goto out;
>> -		}
>> +	/*
>> +	 * Remove the name and update the hashvals in the tree.
>> +	 */
>> +	blk = &state->path.blk[state->path.active-1];
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +	error = xfs_attr3_leaf_remove(blk->bp, args);
>> +	xfs_da3_fixhashpath(state, &state->path);
>>   
>> -	} else if (args->rmtblkno > 0) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		error = xfs_attr3_leaf_clearflag(args);
>> +	/*
>> +	 * Check to see if the tree needs to be collapsed.
>> +	 */
>> +	if (retval && (state->path.active > 1)) {
>> +		error = xfs_da3_join(state);
>> +		if (error)
>> +			goto out;
>> +		error = xfs_defer_finish(&args->trans);
>>   		if (error)
>>   			goto out;
>>   	}
>> -- 
>> 2.7.4
>>
