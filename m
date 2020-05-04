Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A552C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 21:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 479BB206B8
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 21:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oSYskwDK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgEDViz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 17:38:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgEDViz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 17:38:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LXGJH129421;
        Mon, 4 May 2020 21:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XFxbFpE8KMWeKgbarOY7WxtVKAKbONmkTBJtQvTd+4c=;
 b=oSYskwDKdiahUs8sEdHmIPRNsUTH7T2giw7iFmAnAMbxZL6oRfX4xMcDc7EXiwBZ1KAu
 rIzykSfoMY6fYcmSrXZmV9roWxNDHrbI6vmn796qqhrklMuXxXL4/PeJBPwRSmaFZX4A
 qEgrxvgFppDWaIWkDNFJWG/zZyS/CxeYsOhhDPCrcICB2HTOk/+IrZ3FXhsPf3Qc43Ad
 OUFsvtkW4ARb/k4evYsawV00mBHOPxAcFvmwKvJb6q2kn/JchRg30PVutsPhq9S6xvJD
 GKk3eCrjCi+Zhbq5VtKBzb/zN5XEjVIVL5TwFDihp6dF6HccPZZNpMbexq+rKb3aPMgg qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30s0tm9ft2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:38:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044Larfq080779;
        Mon, 4 May 2020 21:36:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjdrfwtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:36:52 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044LaeoN006105;
        Mon, 4 May 2020 21:36:40 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 14:36:40 -0700
Subject: Re: [PATCH v9 10/24] xfs: Add helper function
 __xfs_attr_rmtval_remove
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-11-allison.henderson@oracle.com>
 <20200504132722.GA54625@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d2effe05-04da-3c8d-5020-4fca83875051@oracle.com>
Date:   Mon, 4 May 2020 14:36:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504132722.GA54625@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 6:27 AM, Brian Foster wrote:
> On Thu, Apr 30, 2020 at 03:50:02PM -0700, Allison Collins wrote:
>> This function is similar to xfs_attr_rmtval_remove, but adapted to
>> return EAGAIN for new transactions. We will use this later when we
>> introduce delayed attributes.  This function will eventually replace
>> xfs_attr_rmtval_remove
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> ---
> 
> Looks like the commit log needs some rewording now that this is a
> refactor patch. With that fixed:
Ok, maybe just an extra line like "Refactor xfs_attr_rmtval_remove to 
add helper function __xfs_attr_rmtval_remove" ?

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Alrighty, thank you!

Allison

> 
>>   fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 37 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 4d51969..02d1a44 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -681,7 +681,7 @@ xfs_attr_rmtval_remove(
>>   	xfs_dablk_t		lblkno;
>>   	int			blkcnt;
>>   	int			error = 0;
>> -	int			done = 0;
>> +	int			retval = 0;
>>   
>>   	trace_xfs_attr_rmtval_remove(args);
>>   
>> @@ -693,14 +693,10 @@ xfs_attr_rmtval_remove(
>>   	 */
>>   	lblkno = args->rmtblkno;
>>   	blkcnt = args->rmtblkcnt;
>> -	while (!done) {
>> -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>> -				    XFS_BMAPI_ATTRFORK, 1, &done);
>> -		if (error)
>> -			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +	do {
>> +		retval = __xfs_attr_rmtval_remove(args);
>> +		if (retval && retval != EAGAIN)
>> +			return retval;
>>   
>>   		/*
>>   		 * Close out trans and start the next one in the chain.
>> @@ -708,6 +704,36 @@ xfs_attr_rmtval_remove(
>>   		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   		if (error)
>>   			return error;
>> -	}
>> +	} while (retval == -EAGAIN);
>> +
>>   	return 0;
>>   }
>> +
>> +/*
>> + * Remove the value associated with an attribute by deleting the out-of-line
>> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>> + * transaction and recall the function
>> + */
>> +int
>> +__xfs_attr_rmtval_remove(
>> +	struct xfs_da_args	*args)
>> +{
>> +	int			error, done;
>> +
>> +	/*
>> +	 * Unmap value blocks for this attr.
>> +	 */
>> +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
>> +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
>> +	if (error)
>> +		return error;
>> +
>> +	error = xfs_defer_finish(&args->trans);
>> +	if (error)
>> +		return error;
>> +
>> +	if (!done)
>> +		return -EAGAIN;
>> +
>> +	return error;
>> +}
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index eff5f95..ee3337b 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> -- 
>> 2.7.4
>>
> 
