Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FC9C55181
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05545206F4
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BpfJ9CR1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgDTWqF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:46:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42870 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDTWqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 18:46:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KMcU5j130161;
        Mon, 20 Apr 2020 22:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6LnVmaa4+u2GriDXCP1saqocy7ZmnhrWSpIIyeXr4Lo=;
 b=BpfJ9CR1SDfZ4yJiNyLcQ2IuHA8mSUFBEeOIRNk7auPTBLGwKhK8yulJoj3I31r2+fDb
 o99SFjX+7WVMuLi+u4hYg8ibEYT3Kd0jG4HH6glcXiK0KI9cAwSX5Z8OzrjTm4UCpTr2
 5QGf12Yv0urBZ4cdUnnQ3BXUAE4jS48VxPCaYmFEsKTzKf+FJEu9t8p9W8xbUHNZzznM
 eCXE16VyvBDCFEqtiqO0Paa/l9/RuZ4Ba3dP7Nh9nFZGONQ2xnCNv9opyFQafSXOGvfK
 jIfho8vG54mik30jghUBytbrtGUDVqwrhCirNEjas3RRgfW5VEHAjVbNp7BF7+ED0tTE iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n1wp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 22:46:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KMbewd150359;
        Mon, 20 Apr 2020 22:46:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3r7sf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 22:46:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03KMk1hC016220;
        Mon, 20 Apr 2020 22:46:01 GMT
Received: from [10.65.145.61] (/10.65.145.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 15:46:01 -0700
Subject: Re: [PATCH v8 16/20] xfs: Add helper function
 xfs_attr_node_removename_setup
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-17-allison.henderson@oracle.com>
 <4316392.Z7yW20nrPr@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a8981569-a6f4-bfa9-7253-33b93218d66f@oracle.com>
Date:   Mon, 20 Apr 2020 15:46:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4316392.Z7yW20nrPr@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/19/20 11:25 PM, Chandan Rajendra wrote:
> On Saturday, April 4, 2020 3:42 AM Allison Collins wrote:
>> This patch adds a new helper function xfs_attr_node_removename_setup.
>> This will help modularize xfs_attr_node_removename when we add delay
>> ready attributes later.
>>
> The changes look good to me,
> 
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Alrighty, thank you!

Allison

> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 40 +++++++++++++++++++++++++++++++---------
>>   1 file changed, 31 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index f70b4f2..3c33dc5 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1193,6 +1193,35 @@ xfs_attr_leaf_mark_incomplete(
>>   }
>>   
>>   /*
>> + * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
>> + * the blocks are valid.  Any remote blocks will be marked incomplete.
>> + */
>> +STATIC
>> +int xfs_attr_node_removename_setup(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	**state)
>> +{
>> +	int			error;
>> +	struct xfs_da_state_blk	*blk;
>> +
>> +	error = xfs_attr_node_hasname(args, state);
>> +	if (error != -EEXIST)
>> +		return error;
>> +
>> +	blk = &(*state)->path.blk[(*state)->path.active - 1];
>> +	ASSERT(blk->bp != NULL);
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +
>> +	if (args->rmtblkno > 0) {
>> +		error = xfs_attr_leaf_mark_incomplete(args, *state);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * Remove a name from a B-tree attribute list.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>> @@ -1210,8 +1239,8 @@ xfs_attr_node_removename(
>>   
>>   	trace_xfs_attr_node_removename(args);
>>   
>> -	error = xfs_attr_node_hasname(args, &state);
>> -	if (error != -EEXIST)
>> +	error = xfs_attr_node_removename_setup(args, &state);
>> +	if (error)
>>   		goto out;
>>   
>>   	/*
>> @@ -1219,14 +1248,7 @@ xfs_attr_node_removename(
>>   	 * This is done before we remove the attribute so that we don't
>>   	 * overflow the maximum size of a transaction and/or hit a deadlock.
>>   	 */
>> -	blk = &state->path.blk[ state->path.active-1 ];
>> -	ASSERT(blk->bp != NULL);
>> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_leaf_mark_incomplete(args, state);
>> -		if (error)
>> -			goto out;
>> -
>>   		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>>   			goto out;
>>
> 
> 
