Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1587C2D0F4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 16:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C190A20787
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 16:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cijdqnr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgDHQcn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 12:32:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33142 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgDHQcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 12:32:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038GODC9170652;
        Wed, 8 Apr 2020 16:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=c0LybRmoLrImHpKKpPmFACa/7ZU8BIKutR2t/5nyDmM=;
 b=cijdqnr7AuW5J8FumqBLgOJK4tdutArOaNzX+rd0hKxbJ0yj7s2svyLipoCL1YhUwLjk
 NtgkVWCDio1WTdmop665JRBe9ugZGDElzRkVIhtEmXk6++nuMWcslilGl9VJ492zYjpg
 HlMHlFw2AYuIDqL/zBLU+03vM5cuK8RefbAjJ6ysRIe01lRGayXYgbQQU9G1R33AdfsY
 SgHXwK0ovvfxdxNXaxxeA/NwSPDUNOnhJAbwBXz7qBc+cbZL4Vk8R+ySjhB/8IlUjvHL
 LtsBLwFdB4ObAn9c412lxqeU6Ve/nOrz5VNlmqnkQAUmAwoj/fmQQhpZawVb0s3BDfc1 Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3091m3cnnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 16:32:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038GMaoh061426;
        Wed, 8 Apr 2020 16:32:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 309gd91n3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 16:32:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 038GWZi9005245;
        Wed, 8 Apr 2020 16:32:35 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 09:32:34 -0700
Subject: Re: [PATCH v8 16/20] xfs: Add helper function
 xfs_attr_node_removename_setup
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-17-allison.henderson@oracle.com>
 <20200408120956.GC33192@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <42b07c88-16ba-99b1-8ec1-8c9b50c4d297@oracle.com>
Date:   Wed, 8 Apr 2020 09:32:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200408120956.GC33192@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/8/20 5:09 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:25PM -0700, Allison Collins wrote:
>> This patch adds a new helper function xfs_attr_node_removename_setup.
>> This will help modularize xfs_attr_node_removename when we add delay
>> ready attributes later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, thank you!

Allison
> 
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
>> -- 
>> 2.7.4
>>
> 
