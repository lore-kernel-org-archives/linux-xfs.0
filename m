Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00725C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21D620707
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:53:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0XIvxy2F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgEDWx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 18:53:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgEDWx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 18:53:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MlkAD050688
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:53:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=N4m82rWxawX/Ijc1fRafX2HyvwEP/JcRllKuAynEz4s=;
 b=0XIvxy2FBYWRuHbiN86EUcLGdg/eQIm78f+9LM8LZN1w2ZzaVY5q9zNj75BPffXAgYPe
 q8gDhJUyWiaWBWMrnBe5HZ4wKXQm41sPP5VkfLS60M9hFDUXbE+4do8G2vyvGR1QHB67
 hs8pxoszAwj58eqHDvhpvjpodlkvCjvsvSSNQZrOe0Q/DApo1h/VoMAVFXATCMj9UikH
 EdKW8q1CDOU8vWF4jHYwXtKUFsnWiYR/gmSyYK2hV88e/ZsnSkumYOriBA9SQPFTsX7D
 +0L8QpNF55kQRlxTfDw4Rx0bPLzbkk0NgYCCgkHxb/DsOydT9wTUneN37Lh5yt78gTMb mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gn1jh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:53:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MlLiq132119
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:53:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjnc977m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:53:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044MrQMv013971
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:53:26 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 15:53:26 -0700
Subject: Re: [PATCH v9 10/24] xfs: Add helper function
 __xfs_attr_rmtval_remove
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-11-allison.henderson@oracle.com>
 <20200504174125.GD13783@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7b551e24-1da1-384a-b679-609865402921@oracle.com>
Date:   Mon, 4 May 2020 15:53:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504174125.GD13783@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 10:41 AM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:02PM -0700, Allison Collins wrote:
>> This function is similar to xfs_attr_rmtval_remove, but adapted to
>> return EAGAIN for new transactions. We will use this later when we
>> introduce delayed attributes.  This function will eventually replace
>> xfs_attr_rmtval_remove
> 
> Like Brian suggested, this changelog could probably just say that we're
> hoisting the loop body into a separate function so that delayed attrs
> can manage the transaction rolling.
> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> ---
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
> 
> recall the function...?
> 
> Oh.  "re-call" the function.
Will fix

> 
>> + */
>> +int
>> +__xfs_attr_rmtval_remove(
> 
> xfs_attr_rmtval_remove_extent() ?
Well, this would be the third rename for this function though. 
Initially I think we named it xfs_attr_rmtval_unmap, and then later we 
changed it to __xfs_attr_rmtval_remove.  Ultimatly, it really doesn't 
matter what the name is, because it's going to get renamed at the end of 
the set anyway.  Eventually it replaces the calling function and becomes 
xfs_attr_rmtval_remove.

So the name it gets here is just sort of a transient name, and it doesnt 
effect much in the greater scheme of things.  If people really feel 
strongly about it though, it wont hurt much to change it again.  I do 
try to point out the history of it though to avoid too much churn.  :-)

Allison

> 
> --D
> 
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
