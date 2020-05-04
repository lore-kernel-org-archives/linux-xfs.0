Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD0AC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 749742075B
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JMKcf3Xz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgEDXEf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 19:04:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgEDXEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 19:04:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044N3aYB164502
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GSmcx+xUWt2p5u63KoHvBq9gHahlQFe9zcs7/8c3vbs=;
 b=JMKcf3Xz4ipfa4K2nIiQ2dXTlXqr+u9/evs+VCeTxNlnagBql9mwSUotZQDM6z3zps1g
 6hfGvlN4MuYXgW88AoUiTCSwklx9yAJKVXNhEYoK7XnZnXLA5q522PgiDW5W8Bbm4kJ1
 LSDLRtvFGj1JEbTxf+URUowDaR9cBoZEfcHaKBZPK9dP2vP381jNJJ4b6vOYGTn/JuEw
 SJZ9BXSirFTwJI5Zz/XMBGwwYraCIMubR2IDgIvwGga1BndVHZRI1WYcF4lX1Fe9EJ2u
 3bBXIAObK/S+MkcF/2oA2r27r2jdRqLLnEJbumzMVIEkuLHnspFohcS/x1BFntRjX7K4 Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30s09r1tay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:04:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044N2WRL157697
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:02:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjjx4fsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:02:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044N2MOZ003719
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:02:22 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:02:22 -0700
Subject: Re: [PATCH v9 17/24] xfs: Add helper function
 xfs_attr_node_removename_setup
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-18-allison.henderson@oracle.com>
 <20200504185812.GD5703@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e623b0ef-60f1-27af-096b-df30ebe45c10@oracle.com>
Date:   Mon, 4 May 2020 16:02:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504185812.GD5703@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 11:58 AM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:09PM -0700, Allison Collins wrote:
>> This patch adds a new helper function xfs_attr_node_removename_setup.
>> This will help modularize xfs_attr_node_removename when we add delay
>> ready attributes later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 48 +++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 35 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index feae122..c8226c6 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1184,6 +1184,39 @@ xfs_attr_leaf_mark_incomplete(
>>   }
>>   
>>   /*
>> + * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
>> + * the blocks are valid.  Any remote blocks will be marked incomplete.
> 
> "Attr keys with remote blocks will be marked incomplete."
Ok, will fix.

> 
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
>> +
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
> 
> 		return xfs_attr_rmtval_invalidate(args);
> 
> With those two things changed,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, thank you!

Allison
> 
> --D
> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * Remove a name from a B-tree attribute list.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>> @@ -1201,8 +1234,8 @@ xfs_attr_node_removename(
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
>> @@ -1210,18 +1243,7 @@ xfs_attr_node_removename(
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
>> -		error = xfs_attr_rmtval_invalidate(args);
>> -		if (error)
>> -			return error;
>> -
>>   		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>>   			goto out;
>> -- 
>> 2.7.4
>>
