Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2110C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 21:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79611206B9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 21:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a/yMLkXV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgEDVhr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 17:37:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgEDVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 17:37:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LbhtS131479;
        Mon, 4 May 2020 21:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=d4PtFsPj38sTFYmiQTuXgjxtp8+zZOBAjQyMqYhiVy4=;
 b=a/yMLkXVm36UgywNt6EI5qTk/u1xJnssd3qio4XaJTeVKdGuLSBShlcybZ0DYVw8Hmov
 Ls5YDmn1/KPR5oJp27volNFfOkGAFjeazkdxytkcajRjCCjd9eblULqPiAWUTe+Sk0fA
 xwq2ka9ZDyuO8Sjj3e3UjlWYRpQqNzvKqp7sOpY9W/EGji74C6qDunyC++r8pz5y7LYP
 H38qAmoyTvulZjUWL90L93IidCNRMRD57LkrCRQQ3YNVOB7C8yvzBfkqehiU0Si2enB2
 SBLEE4A+aPpy33hPO5TXfy8XqaDGmxqhYH/BVQxbNOkOS+YXx1hlMz6y8JoRTatGr5wE gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn1ar4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:37:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LarM6080862;
        Mon, 4 May 2020 21:37:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdrg00t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:37:42 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044LbgHY030047;
        Mon, 4 May 2020 21:37:42 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 14:37:42 -0700
Subject: Re: [PATCH v9 12/24] xfs: Add helper function xfs_attr_node_shrink
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-13-allison.henderson@oracle.com>
 <20200504132737.GC54625@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e965f10e-c238-60ef-6f9a-f4e029d22ec7@oracle.com>
Date:   Mon, 4 May 2020 14:37:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504132737.GC54625@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 6:27 AM, Brian Foster wrote:
> On Thu, Apr 30, 2020 at 03:50:04PM -0700, Allison Collins wrote:
>> This patch adds a new helper function xfs_attr_node_shrink used to
>> shrink an attr name into an inode if it is small enough.  This helps to
>> modularize the greater calling function xfs_attr_node_removename.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Great!  Thanks!

Allison

> 
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
> 
