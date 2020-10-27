Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E14DC4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 22:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9708221FB
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 22:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RAk/bJ0v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374851AbgJ0WZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 18:25:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59912 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374850AbgJ0WZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 18:25:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RMP3Qi097089;
        Tue, 27 Oct 2020 22:25:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+zeqmvwJwN6sBYcApM0Fxq9Chrt42BfCMFfk577kfdY=;
 b=RAk/bJ0voHkSMWScgNtPRnIepBc+lj2cwEvBi3hs96OJhN6LJN/k3QDM4qaC4h6z1ba+
 o/Ks4EmadGofMfeMHS/5KxSlsW4ZPh7y2g1Zxo72HfPmaxmB/gO9e7us5aTHMnbFgnSY
 KIxB/gA/goDR45J+6CcfJUbDWOy0Hekl4sx8vfwQJEsIPgLk9fpKKRavXUnibrpRpi4C
 oW8dUrm7H9JG8EjXWQwFFzSpNdx3cRjzFya2qFc+9D2pr4rcGJqw8gzJv4b4GcyVjCoN
 PreOx6buyueOnTB05cxpqWkh2CCN3jvesX5ohxXRpnG1V1R6wS7elt5S1zanztkin+Fu dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kvm5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 22:25:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RMASCc029820;
        Tue, 27 Oct 2020 22:23:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwumwq2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 22:23:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RMNNs1025096;
        Tue, 27 Oct 2020 22:23:23 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 15:23:23 -0700
Subject: Re: [PATCH v13 01/10] xfs: Add helper xfs_attr_node_remove_step
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-2-allison.henderson@oracle.com>
 <2702981.IminquKMG5@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e734cad3-fcac-1eac-a20f-7b600807f9f4@oracle.com>
Date:   Tue, 27 Oct 2020 15:23:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2702981.IminquKMG5@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/27/20 12:03 AM, Chandan Babu R wrote:
> On Friday 23 October 2020 12:04:26 PM IST Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> This patch adds a new helper function xfs_attr_node_remove_step.  This
>> will help simplify and modularize the calling function
>> xfs_attr_node_remove.
> 
> The above should have been "xfs_attr_node_removename".
Sure, will fix. Thanks!

Allison

> 
> The code changes themselves are logically correct.
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 34 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index fd8e641..f4d39bf 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
>>    * the root node (a special case of an intermediate node).
>>    */
>>   STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_node_remove_step(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>>   {
>> -	struct xfs_da_state	*state;
>>   	struct xfs_da_state_blk	*blk;
>>   	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>> -	trace_xfs_attr_node_removename(args);
>> -
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> -	if (error)
>> -		goto out;
>>   
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.
>> @@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_node_remove_rmt(args, state);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   	}
>>   
>>   	/*
>> @@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
>>   	if (retval && (state->path.active > 1)) {
>>   		error = xfs_da3_join(state);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   		error = xfs_defer_finish(&args->trans);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   		/*
>>   		 * Commit the Btree join operation and start a new trans.
>>   		 */
>>   		error = xfs_trans_roll_inode(&args->trans, dp);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   	}
>>   
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove a name from a B-tree attribute list.
>> + *
>> + * This routine will find the blocks of the name to remove, remove them and
>> + * shirnk the tree if needed.
>> + */
>> +STATIC int
>> +xfs_attr_node_removename(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_da_state	*state;
>> +	int			error;
>> +	struct xfs_inode	*dp = args->dp;
>> +
>> +	trace_xfs_attr_node_removename(args);
>> +
>> +	error = xfs_attr_node_removename_setup(args, &state);
>> +	if (error)
>> +		goto out;
>> +
>> +	error = xfs_attr_node_remove_step(args, state);
>> +	if (error)
>> +		goto out;
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>>
> 
> 
