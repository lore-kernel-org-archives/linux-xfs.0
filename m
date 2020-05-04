Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9FFC47247
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D5420735
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wDq82HPi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgEDWfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 18:35:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35056 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgEDWfL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 18:35:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MXgrY119382
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bxUCQ8pzZJZqsWV9WKGH2SDa9enOvyXwnWbVYNaXWGw=;
 b=wDq82HPiBpcMcXvZWDhf8yo3neh7L9U1OZGVz7GPK7zc7Ruv0J4etGnF9zJTJOCzRZR/
 ia3x4/dE3ELO0yusVgAmQiqynudkd2EC0xrwi1REvqOU7vDqWGyIwGlR0U8SBcoB5M/L
 a+UYj2q+OaZYUbcf1tVgo3VU77XkEYxhIMoPeUWuV6XJVEgQ9CbjAexgfV7Gzl5GQoAZ
 PXgzoiPoNHEvuj5jeTtTMoanQ4XsZUnpW9Cz/wK6Pxg/azNz543FWbOH7QNuVsj/tBVP
 VK+cQM5YSMuNZkT4ZFgb44pVw88Fq0jR0E6KRnTrFBMQtNu8ozxRirPtH8dW/nfswrjV VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r1qr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:35:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MVbKN187400
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:33:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r3fkcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:33:09 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044MX9mq023497
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:33:09 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 15:33:08 -0700
Subject: Re: [PATCH v9 24/43] xfsprogs: Split apart xfs_attr_leaf_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430224700.4183-1-allison.henderson@oracle.com>
 <20200430224700.4183-25-allison.henderson@oracle.com>
 <20200504173234.GB13783@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <42a034b5-36bd-604a-db83-1225ded7fa1a@oracle.com>
Date:   Mon, 4 May 2020 15:33:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504173234.GB13783@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 10:32 AM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:46:41PM -0700, Allison Collins wrote:
>> Split out new helper function xfs_attr_leaf_try_add from
>> xfs_attr_leaf_addname. Because new delayed attribute routines cannot
>> roll transactions, we split off the parts of xfs_attr_leaf_addname that
>> we can use, and move the commit into the calling function.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> ---
>>   libxfs/xfs_attr.c | 94 +++++++++++++++++++++++++++++++++++--------------------
>>   1 file changed, 60 insertions(+), 34 deletions(-)
>>
>> diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
>> index 1cdebec..5f622c8 100644
>> --- a/libxfs/xfs_attr.c
>> +++ b/libxfs/xfs_attr.c
>> @@ -257,10 +257,30 @@ xfs_attr_set_args(
>>   		}
>>   	}
>>   
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_addname(args);
>> -	else
>> -		error = xfs_attr_node_addname(args);
>> +		if (error != -ENOSPC)
>> +			return error;
>> +
>> +		/*
>> +		 * Commit that transaction so that the node_addname()
>> +		 * call can manage its own transactions.
>> +		 */
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Commit the current trans (including the inode) and
>> +		 * start a new one.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		if (error)
>> +			return error;
> 
> I was just about to debate myself (again) on why it's still necessary to
> call _defer_finish and then _trans_roll_inode, but then I remembered the
> actual reason I unearthed for that, like 5 revisions ago.
> 
> xfs_defer_trans_roll looks for all buffer and inode items attached to a
> transaction.  If it finds bhold'ed buffers or inodes that were ijoined
> with lock_flags==0, it will log and rejoin those items to the new
> transaction after rolling.  Therefore, the xfs_trans_roll_inode here
> makes sure that any buffers that might have been bhold'ed have been
> released.  The goal here is to start each step of an xattr operation
> with the transaction in the same state (clean transaction, inode locked
> and joined) no matter how we got to that step.  That's what "manage its
> own transactions" means, though that's apparently too vague for me to
> pick up on.
> 
> With that in mind, could you change the comments for both to state why
> we're doing this more explicitly? e.g.
> 
> 	/*
> 	 * Finish any deferred work items and roll the transaction once
> 	 * more.  The goal here is to call node_addname with the inode
> 	 * and transaction in the same state (inode locked and joined,
> 	 * transaction clean) no matter how we got to this step.
> 	 */
> 	error = xfs_defer_finish(&args->trans);
> 	if (error)
> 		return error;
> 	error = xfs_trans_roll_inode(&args->trans, dp);
> 	if (error)
> 		return error;
> 
>> +
> 
> Unnecessary blank line here.
> 
Sure, will fix these.  Thanks for the reviews!

Allison

> --D
> 
>> +	}
>> +
>> +	error = xfs_attr_node_addname(args);
>>   	return error;
>>   }
>>   
>> @@ -508,20 +528,21 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    *========================================================================*/
>>   
>>   /*
>> - * Add a name to the leaf attribute list structure
>> + * Tries to add an attribute to an inode in leaf form
>>    *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + * This function is meant to execute as part of a delayed operation and leaves
>> + * the transaction handling to the caller.  On success the attribute is added
>> + * and the inode and transaction are left dirty.  If there is not enough space,
>> + * the attr data is converted to node format and -ENOSPC is returned. Caller is
>> + * responsible for handling the dirty inode and transaction or adding the attr
>> + * in node format.
>>    */
>>   STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_leaf_try_add(
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
>> @@ -563,31 +584,39 @@ xfs_attr_leaf_addname(
>>   	retval = xfs_attr3_leaf_add(bp, args);
>>   	if (retval == -ENOSPC) {
>>   		/*
>> -		 * Promote the attribute list to the Btree format, then
>> -		 * Commit that transaction so that the node_addname() call
>> -		 * can manage its own transactions.
>> +		 * Promote the attribute list to the Btree format. Unless an
>> +		 * error occurs, retain the -ENOSPC retval
>>   		 */
>>   		error = xfs_attr3_leaf_to_node(args);
>>   		if (error)
>>   			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +	}
>> +	return retval;
>> +out_brelse:
>> +	xfs_trans_brelse(args->trans, bp);
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
>> +xfs_attr_leaf_addname(
>> +	struct xfs_da_args	*args)
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
>> @@ -682,9 +711,6 @@ xfs_attr_leaf_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   	}
>>   	return error;
>> -out_brelse:
>> -	xfs_trans_brelse(args->trans, bp);
>> -	return retval;
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
