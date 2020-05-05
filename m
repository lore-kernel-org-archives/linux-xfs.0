Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3567CC47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 17:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03A6D206CC
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 17:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xd/1B1JQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgEERhr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 13:37:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730242AbgEERhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 13:37:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045HXbnZ195774;
        Tue, 5 May 2020 17:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7keiZyyQs735bT/gjfy3WRGXfuQuaPctq2+Btien9aQ=;
 b=Xd/1B1JQ0OEmQCXGv/G/xt3a6rQoUR4/ZG6P58rqf6oQECJJv4Im5iNQ91aUnyi4yN4M
 SyZ+3XdQygsn7iHWkN1krkIzA+XUFu/sX7ar7JiDCvfJi16ewRvpl3y/ni0Pw0eCTncQ
 grXpcqcG4cKG8DGsX6EMMe94hjCMpADIJ9G5/pfqZ6bwLwTZV/wfCUp3eIzrFPWaDMez
 o/pPV0n1TUdX3ikiUdYeSZ9Fn9FlO8ODQscb08XEeKM6snZd4FrCFZDuu4n05awqwVS/
 v+FGjYpW8pWdi/9t+DssaRguYgz4fW3luKvQG9VQ8YtoRkSzI0ST5P6Y6mVmrtk1eqsQ Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30s09r679s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 17:37:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045HWZ36018704;
        Tue, 5 May 2020 17:35:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjk06r15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 17:35:43 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045HZghe024828;
        Tue, 5 May 2020 17:35:42 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 10:35:42 -0700
Subject: Re: [PATCH v9 20/24] xfs: Simplify xfs_attr_node_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-21-allison.henderson@oracle.com>
 <20200505131235.GD60048@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <57115064-b276-8ff1-6cc5-b09ab14de25c@oracle.com>
Date:   Tue, 5 May 2020 10:35:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200505131235.GD60048@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/5/20 6:12 AM, Brian Foster wrote:
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
> 
> Can we just init retval to 0 and avoid this assignment? With that and
> similar fixups to the previous patch:
> 
Sure, will do.

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Note that I'm also of the mind to break this down into smaller functions
> depending on what later patches look like, but if there's more to
> consider around that this seems like a good step in that direction.
Sure, and that's fine too if we change our minds later.  I just figured 
I see what people thought of this first.  Thanks for the reviews!

Allison

> 
> Brian
> 
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
> 
