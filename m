Return-Path: <SRS0=uP9V=ZB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B2BBC17440
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 00:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C22420869
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 00:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hurOKz9T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfKIAKv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 19:10:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKIAKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 19:10:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA909RMt089688
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gmvNkDGM2SF9DBwb9nMPDHsbdKcchr9RSTj2UFZL20s=;
 b=hurOKz9TOuxqxnBqFY8RgSK50ETROpRKxNlKALaLq/SQPzlUAbxJvj5h+7XuR//u9igx
 ptSt1xqpTMjJaRFeoGqxXMbxeA58wtc63HTzMx6LbN6dCYWg/kg5rwnG7mJCtJXhlchk
 LhhYEQQiGNLLIHjY9t5aCxBdyYpljfNi3TVsSVigoMJBga3EFG+RRJQeU9nW6v5NIrjk
 ACe20DSch84hMLEqHT/orkyMT1GzBn2oQgerJyGMbR9ZABzgUqUKsN+j2ZY+8x22ezoV
 VBT3RUK3nqDFT/VaetAyO/yLDlqh5c5uveeESXcEQxpu+Tt9SqGIYL19rx4B2EOxbOWe 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5hgv85q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 00:10:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA908BjO144196
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:10:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w5jkcgdfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 00:10:49 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA90Amx8023601
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:10:48 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 16:10:48 -0800
Subject: Re: [PATCH v4 12/17] xfs: Factor out xfs_attr_rmtval_invalidate
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-13-allison.henderson@oracle.com>
 <20191108211909.GC6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <3444c9e5-e68e-0f8a-d177-02590a956ef1@oracle.com>
Date:   Fri, 8 Nov 2019 17:10:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108211909.GC6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911090000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911090000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/8/19 2:19 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:56PM -0700, Allison Collins wrote:
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_rmtval_remove that we can use.  This will help to
>> reduce repetitive code later when we introduce delayed
>> attributes.
> 
> Looks good.
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
Ok, thank you!

Allison

> 
> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 30 +++++++++++++++++++++---------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 22 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index db51388..1544138 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -588,21 +588,14 @@ xfs_attr_rmtval_set_value(
>>   	return 0;
>>   }
>>   
>> -/*
>> - * Remove the value associated with an attribute by deleting the
>> - * out-of-line buffer that it is stored on.
>> - */
>>   int
>> -xfs_attr_rmtval_remove(
>> +xfs_attr_rmtval_invalidate(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_mount	*mp = args->dp->i_mount;
>>   	xfs_dablk_t		lblkno;
>>   	int			blkcnt;
>>   	int			error;
>> -	int			done;
>> -
>> -	trace_xfs_attr_rmtval_remove(args);
>>   
>>   	/*
>>   	 * Roll through the "value", invalidating the attribute value's blocks.
>> @@ -644,13 +637,32 @@ xfs_attr_rmtval_remove(
>>   		lblkno += map.br_blockcount;
>>   		blkcnt -= map.br_blockcount;
>>   	}
>> +	return 0;
>> +}
>>   
>> +/*
>> + * Remove the value associated with an attribute by deleting the
>> + * out-of-line buffer that it is stored on.
>> + */
>> +int
>> +xfs_attr_rmtval_remove(
>> +	struct xfs_da_args      *args)
>> +{
>> +	xfs_dablk_t		lblkno;
>> +	int			blkcnt;
>> +	int			error = 0;
>> +	int			done = 0;
>> +
>> +	trace_xfs_attr_rmtval_remove(args);
>> +
>> +	error = xfs_attr_rmtval_invalidate(args);
>> +	if (error)
>> +		return error;
>>   	/*
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>>   	lblkno = args->rmtblkno;
>>   	blkcnt = args->rmtblkcnt;
>> -	done = 0;
>>   	while (!done) {
>>   		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>>   				    XFS_BMAPI_ATTRFORK, 1, &done);
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index cd7670d..b6fd35a 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>>   int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> -- 
>> 2.7.4
>>
