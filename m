Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E08C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 22:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1A320784
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 22:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kERLNLV4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgDOWNn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 18:13:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgDOWNl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Apr 2020 18:13:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03FM7rvI170578;
        Wed, 15 Apr 2020 22:13:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=H+FYNhogWoM7DxVGd4ACcndR/XnVK9bzgw48wdTMkvQ=;
 b=kERLNLV4jIriYpIgVRAFoXBl4dP/Qwqx8NQrsTioYynf+w5nncV4X/sd1AGt04eDjlAG
 HwI5MCiB6Ai4PmGeW20E7i+rQslk2tEULQZly0IKRr6dMpN2C+46UWD4AI8FceXAXQjN
 C6y4g4qZ6k5IFc9We8JpNMxcjsvtcHji7Gyoy5rbvTMW8kZm2k/hqgvqs95BpAhZWYvd
 E/gOpuCfoYVG7DkYM5ec6x4QucwYMEsRxipLsNGXSepdAXgvAKz9e4jGrPtSZx5KuIO/
 P/w9LMvLgxKB84EWP20AF/eTLcR7Tk6ORC4a8st3El/W/bRHTmReyGH1W4MyN9P558EP kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30e0bfbq0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 22:13:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03FMDCHQ078702;
        Wed, 15 Apr 2020 22:13:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30dn8x483d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 22:13:37 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03FMDaHi017542;
        Wed, 15 Apr 2020 22:13:37 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Apr 2020 15:13:35 -0700
Subject: Re: [PATCH v8 11/20] xfs: Add helper function xfs_attr_node_shrink
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-12-allison.henderson@oracle.com>
 <2127078.fSUztT9pNN@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <06692d90-4535-165e-c572-f908c63bc94a@oracle.com>
Date:   Wed, 15 Apr 2020 15:13:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2127078.fSUztT9pNN@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 suspectscore=2 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/15/20 3:16 AM, Chandan Rajendra wrote:
> On Saturday, April 4, 2020 3:42 AM Allison Collins wrote:
>> This patch adds a new helper function xfs_attr_node_shrink used to
>> shrink an attr name into an inode if it is small enough.  This helps to
>> modularize the greater calling function xfs_attr_node_removename.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 67 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 42 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index db5a99c..27a9bb5 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1103,6 +1103,45 @@ xfs_attr_node_addname(
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
>> @@ -1115,8 +1154,7 @@ xfs_attr_node_removename(
>>   {
>>   	struct xfs_da_state	*state;
>>   	struct xfs_da_state_blk	*blk;
>> -	struct xfs_buf		*bp;
>> -	int			retval, error, forkoff;
>> +	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>> @@ -1197,31 +1235,10 @@ xfs_attr_node_removename(
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
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		error = xfs_attr_node_shrink(args, state);
> 
> If a non-zero error value is returned by the above statement, the following
> statement i.e. "error = 0" will overwrite it.
> Apart from that everything else looks fine.
> 
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Yep, I've removed the trailing error = 0; in the new v9.  Thanks for the 
review!

Allison
> 
>>   
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
>>   	error = 0;
>> -
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>>
> 
> 
