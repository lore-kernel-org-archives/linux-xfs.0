Return-Path: <SRS0=uP9V=ZB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E2DC43331
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 21:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAC702075C
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 21:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KbI0nv3T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfKIVlI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Nov 2019 16:41:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfKIVlI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Nov 2019 16:41:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA9Ld9pr106175
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 21:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=3C5xnc2PwXhONwHYMbuTnGFSCiBob9HlTRlmdjo4coc=;
 b=KbI0nv3TKzH1xJy8EvBPffkL9erG8azbFFCd1MZyk8GQCcUIV/uHkivtZEn0d5AWl6Bo
 zf4aAXcsE+Zi1acI8HtXou8s0PetWrY2O9TKZz1hc040/CvMJdoAByz8uuZwF/HpbofO
 M4Okg3u2vbzR/8LY+59/mjSefsvbtWtVA5pYo1hgdDmG9UFuvVzNgZs+DQbXl1CS94QU
 3LjZX5DuitIHUEnjBpgDaRM/yrIKZZ0nbN2wxGw6qd0homSl9MsyXvPYr16qEMuenv6W
 QS54YzAYwvf0n968ARyFRQFpdDCfrc7Vld3QTbDnAmbNB85jX6PSSd12nP30Ijqlukij HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndpsvvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 21:41:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA9LcaT0004403
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 21:41:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w5mt4h31u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 21:41:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA9Lf497002236
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 21:41:04 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Nov 2019 21:41:04 +0000
Subject: Re: [PATCH v4 08/17] xfs: Factor out xfs_attr_leaf_addname helper
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-9-allison.henderson@oracle.com>
 <20191108205748.GZ6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <1824cddb-1b0b-c3f0-8eaa-77305e399c2d@oracle.com>
Date:   Sat, 9 Nov 2019 14:41:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108205748.GZ6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911090220
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911090221
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/8/19 1:57 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:52PM -0700, Allison Collins wrote:
>> Factor out new helper function xfs_attr_leaf_try_add.
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_leaf_addname that we can use.  This will help
>> to reduce repetitive code later when we introduce
>> delayed attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 84 +++++++++++++++++++++++++++++-------------------
>>   1 file changed, 51 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 212995f..dda2eba 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -305,10 +305,33 @@ xfs_attr_set_args(
>>   		}
>>   	}
>>   
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_addname(args);
>> -	else
>> +		if (error == -ENOSPC) {
>> +			/*
>> +			 * Commit that transaction so that the node_addname()
>> +			 * call can manage its own transactions.
>> +			 */
>> +			error = xfs_defer_finish(&args->trans);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Commit the current trans (including the inode) and
>> +			 * start a new one.
>> +			 */
>> +			error = xfs_trans_roll_inode(&args->trans, dp);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Fob the rest of the problem off on the Btree code.
>> +			 */
>> +			error = xfs_attr_node_addname(args);
>> +		}
>> +	} else {
>>   		error = xfs_attr_node_addname(args);
>> +	}
>>   	return error;
> 
> 
>>   }
>>   
>> @@ -601,21 +624,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    * External routines when attribute list is one block
>>    *========================================================================*/
>>   
>> -/*
>> - * Add a name to the leaf attribute list structure
>> - *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> - */
>>   STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_leaf_try_add(
> 
> (total stream of consciousness here...)
> 
> AFAICT the old _addname function's responsibilities were:
> 
> 1 Try to add a new attr key entry to the leaf block, with INCOMPLETE set
>    if it's a rename op or we need to set a remote value.
> 2 If there wasn't space in the leaf block, convert to node format, call
>    the node version of this function, and exit.
> 3 Allocating blocks for the remote attr value and writing them, if
>    applicable
> 4 If it's a rename operation, clearing the INCOMPLETE flag on the new
>    entry; setting it on the old entry; and then removing the old entry.
> 5 Clearing the INCOMPLETE flag on the new entry when we're done writing
>    a remote value (if applicable)
> 
> I think we arrive at this split so that we don't have a transaction roll
> in the middle of the function, right?  And also to make the "convert to
> node format and roll" bits go elsewhere?
> 
> The way I'm thinking about how to accomplish this is...
> 
> xfs_attr_leaf_addname should be renamed xfs_attr_leaf_setname, and then
> hoist (1) into a separate function, move (2) into xfs_attr_set_args, and
> hoist (4) into a separate function.
> 
> ...ok, so let's test how closely my understanding fits the changes made
> in this patch:
> 
> _try_add is basically (1).
> 
> Most of (2) happened, though the call to xfs_attr3_leaf_to_node ought to
> go into the caller so that the conversion stays with the defer_finish
> and roll.
> 
> (4) could still be done, maybe as a separate prep patch.
> 

I think you're on the right track.  Perhaps the diff made it look a 
little crazier than it seems. Maybe its easier to describe it as this:

I renamed xfs_attr_leaf_addname to xfs_attr_leaf_try_add,
and then deleted (2) out of the body of the function.  The upper half 
(1) became the helper function, and lower half (3, 4, and 5) became the 
new xfs_attr_leaf_addname, which now calls the helper at the start of 
the routine. Finally (2) got factored up into the caller.

Hope that helps some :-)  The point of all this being to jigsaw out (1) 
into a stand alone routine that we can use later in delayed attrs.


> Hm, ok, I think I understand what this patch does.  The call site in
> xfs_attr_set_args would be clearer (and less indenty) if it looked like:
> 
> 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> 		error = xfs_attr_leaf_addname(args);
> 		if (error == 0 || error != -ENOSPC)
> 			return error;
> 
> 		/* Promote the attribute list to node format. */
> 		error = xfs_attr3_leaf_to_node(args);
> 		if (error)
> 			return error;
I think this part here is already taken care of in 
xfs_attr_leaf_addname, but otherwise, I think the rest of this is 
equivalent.  Will update in the next set.

Thanks for the reviews!
Allison



> 
> 		/*
> 		 * Commit that transaction so that the node_addname()
> 		 * call can manage its own transactions.
> 		 */
> 		error = xfs_defer_finish(&args->trans);
> 		if (error)
> 			return error;
> 
> 		/*
> 		 * Commit the current trans (including the inode) and
> 		 * start a new one.
> 		 */
> 		error = xfs_trans_roll_inode(&args->trans, dp);
> 		if (error)
> 			return error;
> 	}
> 
> 	return xfs_attr_node_addname(args);
> 
> But otherwise it looks decent, assuming I understood any of it. :)
> 
> --D
> 
>> +	struct xfs_da_args	*args,
>> +	struct xfs_buf		*bp)
>>   {
>> -	struct xfs_buf		*bp;
>> -	int			retval, error, forkoff;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> -	trace_xfs_attr_leaf_addname(args);
>> +	int			retval, error;
>>   
>>   	/*
>>   	 * Look up the given attribute in the leaf block.  Figure out if
>> @@ -661,31 +675,35 @@ xfs_attr_leaf_addname(
>>   	retval = xfs_attr3_leaf_add(bp, args);
>>   	if (retval == -ENOSPC) {
>>   		/*
>> -		 * Promote the attribute list to the Btree format, then
>> -		 * Commit that transaction so that the node_addname() call
>> -		 * can manage its own transactions.
>> +		 * Promote the attribute list to the Btree format.
>> +		 * Unless an error occurs, retain the -ENOSPC retval
>>   		 */
>>   		error = xfs_attr3_leaf_to_node(args);
>>   		if (error)
>>   			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +	}
>> +	return retval;
>> +}
>>   
>> -		/*
>> -		 * Commit the current trans (including the inode) and start
>> -		 * a new one.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>>   
>> -		/*
>> -		 * Fob the whole rest of the problem off on the Btree code.
>> -		 */
>> -		error = xfs_attr_node_addname(args);
>> +/*
>> + * Add a name to the leaf attribute list structure
>> + *
>> + * This leaf block cannot have a "remote" value, we only call this routine
>> + * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + */
>> +STATIC int
>> +xfs_attr_leaf_addname(struct xfs_da_args	*args)
>> +{
>> +	int			error, forkoff;
>> +	struct xfs_buf		*bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +
>> +	trace_xfs_attr_leaf_addname(args);
>> +
>> +	error = xfs_attr_leaf_try_add(args, bp);
>> +	if (error)
>>   		return error;
>> -	}
>>   
>>   	/*
>>   	 * Commit the transaction that added the attr name so that
>> -- 
>> 2.7.4
>>
