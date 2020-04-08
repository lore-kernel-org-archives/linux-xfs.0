Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217CEC2D0F4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 16:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA3DC20769
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 16:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FFFFAWGX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgDHQeh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 12:34:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgDHQeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 12:34:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038GO7QN170546;
        Wed, 8 Apr 2020 16:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xpNJ/0KJca+19+hnjqqwUijLm/SKSksbXZgrod+dyug=;
 b=FFFFAWGXSdPvaIk9sxEmBDk9zR7jkBNbsejjPUoH6hQWubIhoFI5vKkhFES/EINTgsEj
 UdXTCZxQVdcPr0ie2rWOvjWWG91xsmvYB16vTRjhRbhfwNHQun/2HF6lhDSsmoTvRTrW
 mhyWT5UNyxzU1cbmyaNr5TlmX/AiTwkv3cCiYmdJhSsomsYrJ7Z7gMBFQaZVZPIDvGQP
 SV78iTDbjRBoTkvYb+MPjaYpxlAwAk0XzG3yVc+GrVjwikcD6Y1zCMfjGbpDoKKTGGkN
 oBowTRg2mi2+CzZ9kljRwhdGRIExxD/1r810ldG3AuIYZDZmdG+dNIIlWd9Qz0FKS0L0 AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3091m3cnyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 16:34:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038GMj13080648;
        Wed, 8 Apr 2020 16:32:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 309ag26gcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 16:32:31 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 038GWUId005232;
        Wed, 8 Apr 2020 16:32:30 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 09:32:30 -0700
Subject: Re: [PATCH v8 15/20] xfs: Add remote block helper functions
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-16-allison.henderson@oracle.com>
 <20200408120948.GB33192@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <5de43fc8-c119-d6a8-62a6-d253dedc687e@oracle.com>
Date:   Wed, 8 Apr 2020 09:32:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200408120948.GB33192@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080127
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
> On Fri, Apr 03, 2020 at 03:12:24PM -0700, Allison Collins wrote:
>> This patch adds two new helper functions xfs_attr_store_rmt_blk and
>> xfs_attr_restore_rmt_blk. These two helpers assist to remove redundant
>> code associated with storing and retrieving remote blocks during the
>> attr set operations.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Alrighty, thank you!

Allison
> 
>>   fs/xfs/libxfs/xfs_attr.c | 50 +++++++++++++++++++++++++++++-------------------
>>   1 file changed, 30 insertions(+), 20 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 8d7a5db..f70b4f2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -565,6 +565,30 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    * External routines when attribute list is one block
>>    *========================================================================*/
>>   
>> +/* Store info about a remote block */
>> +STATIC void
>> +xfs_attr_save_rmt_blk(
>> +	struct xfs_da_args	*args)
>> +{
>> +	args->blkno2 = args->blkno;
>> +	args->index2 = args->index;
>> +	args->rmtblkno2 = args->rmtblkno;
>> +	args->rmtblkcnt2 = args->rmtblkcnt;
>> +	args->rmtvaluelen2 = args->rmtvaluelen;
>> +}
>> +
>> +/* Set stored info about a remote block */
>> +STATIC void
>> +xfs_attr_restore_rmt_blk(
>> +	struct xfs_da_args	*args)
>> +{
>> +	args->blkno = args->blkno2;
>> +	args->index = args->index2;
>> +	args->rmtblkno = args->rmtblkno2;
>> +	args->rmtblkcnt = args->rmtblkcnt2;
>> +	args->rmtvaluelen = args->rmtvaluelen2;
>> +}
>> +
>>   /*
>>    * Tries to add an attribute to an inode in leaf form
>>    *
>> @@ -599,11 +623,7 @@ xfs_attr_leaf_try_add(
>>   
>>   		/* save the attribute state for later removal*/
>>   		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
>> -		args->blkno2 = args->blkno;		/* set 2nd entry info*/
>> -		args->index2 = args->index;
>> -		args->rmtblkno2 = args->rmtblkno;
>> -		args->rmtblkcnt2 = args->rmtblkcnt;
>> -		args->rmtvaluelen2 = args->rmtvaluelen;
>> +		xfs_attr_save_rmt_blk(args);
>>   
>>   		/*
>>   		 * clear the remote attr state now that it is saved so that the
>> @@ -702,11 +722,8 @@ xfs_attr_leaf_addname(
>>   		 * Dismantle the "old" attribute/value pair by removing
>>   		 * a "remote" value (if it exists).
>>   		 */
>> -		args->index = args->index2;
>> -		args->blkno = args->blkno2;
>> -		args->rmtblkno = args->rmtblkno2;
>> -		args->rmtblkcnt = args->rmtblkcnt2;
>> -		args->rmtvaluelen = args->rmtvaluelen2;
>> +		xfs_attr_restore_rmt_blk(args);
>> +
>>   		if (args->rmtblkno) {
>>   			error = xfs_attr_rmtval_remove(args);
>>   			if (error)
>> @@ -934,11 +951,7 @@ xfs_attr_node_addname(
>>   
>>   		/* save the attribute state for later removal*/
>>   		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
>> -		args->blkno2 = args->blkno;		/* set 2nd entry info*/
>> -		args->index2 = args->index;
>> -		args->rmtblkno2 = args->rmtblkno;
>> -		args->rmtblkcnt2 = args->rmtblkcnt;
>> -		args->rmtvaluelen2 = args->rmtvaluelen;
>> +		xfs_attr_save_rmt_blk(args);
>>   
>>   		/*
>>   		 * clear the remote attr state now that it is saved so that the
>> @@ -1050,11 +1063,8 @@ xfs_attr_node_addname(
>>   		 * Dismantle the "old" attribute/value pair by removing
>>   		 * a "remote" value (if it exists).
>>   		 */
>> -		args->index = args->index2;
>> -		args->blkno = args->blkno2;
>> -		args->rmtblkno = args->rmtblkno2;
>> -		args->rmtblkcnt = args->rmtblkcnt2;
>> -		args->rmtvaluelen = args->rmtvaluelen2;
>> +		xfs_attr_restore_rmt_blk(args);
>> +
>>   		if (args->rmtblkno) {
>>   			error = xfs_attr_rmtval_remove(args);
>>   			if (error)
>> -- 
>> 2.7.4
>>
> 
