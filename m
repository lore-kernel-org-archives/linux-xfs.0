Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27352C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F116B20705
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:55:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aV0VvwS9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgEDWzl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 18:55:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57986 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgEDWzl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 18:55:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MnH4d052047
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0+KBM3w9P/8StBg11jL9h9TaBVmiWRFf8TTHq92zwrY=;
 b=aV0VvwS9RtIZmNDrj3pySZlsdlzJAx/kQrgah3+Gi4BwFHpNLmxLVk7yxBPK8eXPg1D5
 Hkwsk1JVW0t9wHMtD4PVB3YOP561zlwGEga5sIrX710NS+ZGp2lpLuSIQQTpZ+OUJ41k
 hCNvvx1cHsdtcl8Ta8OXwd3VX4kP7fd1tbloXZSwoxAX+LPQzZX7JqWGPXW90kEWzCDL
 q4WS3LVSVxW1mVOmMhNWMFW9+EalxkWeMfN152ElQVMxESfjrfjdlWWY+uE6DKa5FosZ
 i3yRVAlNuBEkuGfb7NuO+47QQDmeZiseCGNcrYX0nX1JJSm1x33+Q48GJALWrXXAs9Lu uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30s0tm9qm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:55:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MlNlH132359
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:55:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnc9e86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:55:39 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044Mtc13000766
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:55:38 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 15:55:38 -0700
Subject: Re: [PATCH v9 12/24] xfs: Add helper function xfs_attr_node_shrink
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-13-allison.henderson@oracle.com>
 <20200504174231.GF13783@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8b6f7758-8843-e685-e267-f191f806be82@oracle.com>
Date:   Mon, 4 May 2020 15:55:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504174231.GF13783@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 10:42 AM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:04PM -0700, Allison Collins wrote:
>> This patch adds a new helper function xfs_attr_node_shrink used to
>> shrink an attr name into an inode if it is small enough.  This helps to
>> modularize the greater calling function xfs_attr_node_removename.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Simple enough looking hoist;
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Great, thanks!

Allison
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 68 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 42 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4fdfab9..d83443c 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1108,6 +1108,45 @@ xfs_attr_node_addname(
>>   }
>>   
>>   /*
>> + * Shrink an attribute from leaf to shortform
>> + */
>> +STATIC int
>> +xfs_attr_node_shrink(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state     *state)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error, forkoff;
>> +	struct xfs_buf		*bp;
>> +
>> +	/*
>> +	 * Have to get rid of the copy of this dabuf in the state.
>> +	 */
>> +	ASSERT(state->path.active == 1);
>> +	ASSERT(state->path.blk[0].bp);
>> +	state->path.blk[0].bp = NULL;
>> +
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>> +	if (error)
>> +		return error;
>> +
>> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +	if (forkoff) {
>> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +		/* bp is gone due to xfs_da_shrink_inode */
>> +		if (error)
>> +			return error;
>> +
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			return error;
>> +	} else
>> +		xfs_trans_brelse(args->trans, bp);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * Remove a name from a B-tree attribute list.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>> @@ -1120,8 +1159,7 @@ xfs_attr_node_removename(
>>   {
>>   	struct xfs_da_state	*state;
>>   	struct xfs_da_state_blk	*blk;
>> -	struct xfs_buf		*bp;
>> -	int			retval, error, forkoff;
>> +	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>> @@ -1206,30 +1244,8 @@ xfs_attr_node_removename(
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		/*
>> -		 * Have to get rid of the copy of this dabuf in the state.
>> -		 */
>> -		ASSERT(state->path.active == 1);
>> -		ASSERT(state->path.blk[0].bp);
>> -		state->path.blk[0].bp = NULL;
>> -
>> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>> -		if (error)
>> -			goto out;
>> -
>> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -			/* bp is gone due to xfs_da_shrink_inode */
>> -			if (error)
>> -				goto out;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				goto out;
>> -		} else
>> -			xfs_trans_brelse(args->trans, bp);
>> -	}
>> -	error = 0;
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		error = xfs_attr_node_shrink(args, state);
>>   
>>   out:
>>   	if (state)
>> -- 
>> 2.7.4
>>
