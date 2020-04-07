Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4717AC2D0EC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 21:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1972F20769
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 21:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jhd2WZZs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDGVx4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 17:53:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgDGVx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 17:53:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037LmH9d182756;
        Tue, 7 Apr 2020 21:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/cDQO+SZNfSFn9zNHThmnZTMW6I4PSiSrnWBPK69vuw=;
 b=jhd2WZZsb3tl1WZIjwEIqrfWmDUwOjODo+NsEY2i4gmJ8+jwGOCBBEYo+aeySZIJX4X0
 UN7DHC0suIS0W6CJAUwoTiDhcUTfluD/remG0xwPB91pAS6eJuDIpAk5N2uVFXkjz+ni
 2/VJAhstF3TnEkeM719vB8KKygW/G1TLL+a+VoraB/ZUo2HCE8JuG6YyLDBU1dtWrW3b
 9qDHsPaboYxc2le5XoeT1WqHXdy+wqDhbXoQ10GLQkI4Uo5+Oa2HFDmzmmJolp9rOU7a
 fQJVjJJq+JeIrr5LfyjVI9ebrFH5myCYp/1gM13S92/P7hXoLZ0EcEEL+7VubVx3XtXg 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3091m381tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 21:53:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037Lkdmk183117;
        Tue, 7 Apr 2020 21:53:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3091kg0jxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 21:53:51 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 037Lrn6l014558;
        Tue, 7 Apr 2020 21:53:50 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 14:53:49 -0700
Subject: Re: [PATCH v8 14/20] xfs: Add helper function
 xfs_attr_leaf_mark_incomplete
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-15-allison.henderson@oracle.com>
 <20200407152310.GF28936@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2a9336dd-ebbe-6299-38d7-42ddc8f4aeb5@oracle.com>
Date:   Tue, 7 Apr 2020 14:53:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200407152310.GF28936@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/7/20 8:23 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:23PM -0700, Allison Collins wrote:
>> This patch helps to simplify xfs_attr_node_removename by modularizing
>> the code around the transactions into helper functions.  This will make
>> the function easier to follow when we introduce delayed attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>>   1 file changed, 31 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ba26ffe..8d7a5db 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1153,6 +1153,36 @@ xfs_attr_node_shrink(
>>   }
>>   
>>   /*
>> + * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
>> + * for later deletion of the entry.
>> + */
>> +STATIC int
>> +xfs_attr_leaf_mark_incomplete(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	int error;
> 
> 	int			error;
> 
>> +
>> +	/*
>> +	 * Fill in disk block numbers in the state structure
>> +	 * so that we can get the buffers back after we commit
>> +	 * several transactions in the following calls.
>> +	 */
>> +	error = xfs_attr_fillstate(state);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Mark the attribute as INCOMPLETE
>> +	 */
>> +	error = xfs_attr3_leaf_setflag(args);
>> +	if (error)
>> +		return error;
>> +
>> +	return 0;
> 
> 	return xfs_attr3_leaf_setflag(args);
> 
> Otherwise looks good:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Alrighty, will update.  Thank you!

Allison
> 
>> +}
>> +
>> +/*
>>    * Remove a name from a B-tree attribute list.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>> @@ -1183,20 +1213,7 @@ xfs_attr_node_removename(
>>   	ASSERT(blk->bp != NULL);
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   	if (args->rmtblkno > 0) {
>> -		/*
>> -		 * Fill in disk block numbers in the state structure
>> -		 * so that we can get the buffers back after we commit
>> -		 * several transactions in the following calls.
>> -		 */
>> -		error = xfs_attr_fillstate(state);
>> -		if (error)
>> -			goto out;
>> -
>> -		/*
>> -		 * Mark the attribute as INCOMPLETE, then bunmapi() the
>> -		 * remote value.
>> -		 */
>> -		error = xfs_attr3_leaf_setflag(args);
>> +		error = xfs_attr_leaf_mark_incomplete(args, state);
>>   		if (error)
>>   			goto out;
>>   
>> -- 
>> 2.7.4
>>
> 
