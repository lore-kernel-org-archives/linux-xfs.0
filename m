Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90116C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 21:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4415A22C9C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 21:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgLUVy2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 16:54:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUVy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Dec 2020 16:54:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BLLmZqp173099;
        Mon, 21 Dec 2020 21:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VzDOROEvLbonAlxpfB/Jje43dCGu1H+VfpseDOIUHdY=;
 b=L0XwBV3KNtiAFeRDU5smSlymxKZg1HMoYNeIL8xcOdr9S9X9zUjRE4a6dX3s2vEpc9X8
 QB1RumPBHTqBxtpFL7ytvbxVPElAZC+Fdc3UoCiru0vDK6edEREF6yEJC4Tpq9TPUryz
 G00Lbm/TM4ldXh1dL6wr4i1wdHbtNBwKElv06VLHUVG04LE1SU3Ek+4miH46yoMy0Ug0
 SsKINAGGdNzxKMaHJjLNYmhAdVAEbh7C6C27cMYISWxIA0tE/hVl2sZdGlJ1/VtJDWaA
 m2xdKnBIkcFqrtY01MAp3jlH8A598iGfm+SEQ6V1VAVlHCbxM/BGpU9OuKcWIKZvVZA8 AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35k0d88vu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 21:53:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BLLpWfX155453;
        Mon, 21 Dec 2020 21:51:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35k0e09edp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 21:51:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BLLpj4S008084;
        Mon, 21 Dec 2020 21:51:45 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Dec 2020 13:51:44 -0800
Subject: Re: [PATCH v14 03/15] xfs: Hoist transaction handling in
 xfs_attr_node_remove_step
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-4-allison.henderson@oracle.com>
 <4105761.l86rmMIxAI@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6828829c-c2b3-9835-393a-a42a223c5909@oracle.com>
Date:   Mon, 21 Dec 2020 14:51:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4105761.l86rmMIxAI@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012210146
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/20/20 11:45 PM, Chandan Babu R wrote:
> On Fri, 18 Dec 2020 00:29:05 -0700, Allison Henderson wrote:
>> This patch hoists transaction handling in xfs_attr_node_remove to
> 
> ... "transaction handling in xfs_attr_node_removename"
> 
>> xfs_attr_node_remove_step.  This will help keep transaction handling in
>> higher level functions instead of buried in subfunctions when we
>> introduce delay attributes
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 43 ++++++++++++++++++++++---------------------
>>   1 file changed, 22 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index e93d76a..1969b88 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1251,7 +1251,7 @@ xfs_attr_node_remove_step(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_da_state	*state)
>>   {
>> -	int			retval, error;
>> +	int			error;
>>   	struct xfs_inode	*dp = args->dp;
> 
> The declaration of "dp" variable can be removed since there are no references
> to it left after the removal of the following hunk.
Ok, will remove

> 
>>   
>>   
>> @@ -1265,25 +1265,6 @@ xfs_attr_node_remove_step(
>>   		if (error)
>>   			return error;
>>   	}
>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>> -
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>> -	}
>>   
>>   	return error;
>>   }
>> @@ -1299,7 +1280,7 @@ xfs_attr_node_removename(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_da_state	*state = NULL;
>> -	int			error;
>> +	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>> @@ -1312,6 +1293,26 @@ xfs_attr_node_removename(
>>   	if (error)
>>   		goto out;
>>   
>> +	retval = xfs_attr_node_remove_cleanup(args, state);
>> +
>> +	/*
>> +	 * Check to see if the tree needs to be collapsed.
>> +	 */
>> +	if (retval && (state->path.active > 1)) {
>> +		error = xfs_da3_join(state);
>> +		if (error)
>> +			return error;
> 
> When a non-zero value is returned by xfs_da3_join(), the code would fail to
> free the memory pointed to by "state". Same review comment applies to the two
> return statements below.
Ok, these need to be "goto out".  Will fix, thx!
Allison

> 
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			return error;
>> +		/*
>> +		 * Commit the Btree join operation and start a new trans.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>>
> 
> 
