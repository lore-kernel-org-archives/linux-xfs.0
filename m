Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1C5C43465
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55308206D7
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:07:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HHh2f4MB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGYAH3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 20:07:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59578 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgGYAH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 20:07:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONpRdx186803
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=A0hKVlmSpXLfDAdDHePbC1TJqXNeH0dxmaRVzUs/zsI=;
 b=HHh2f4MB5hPja3+fNJRB7YogiTEevW5iGnsDMum2AS2P41zVxOxO95oMRjNQ2WslhREJ
 q9ivBG7ZVqOf5mtidwxgjna5S3d650DzWQ4uRUZXQ5n2VNpspAwFW3OrOhjrpyiIcP2F
 rbMG1tbaeLc0PxTAj6oDzTr0kbQkqT1Sav5TQsRy5+cvEeymjM+xXz40IXRmmY5J6Vvn
 APpdTp8XiwUFNxJ81MOhjsrW2lL2jE+8aXKlq3OcNEhHkqWtIzhY3js2Wx9CX9QwuFGO
 quNaAs3rvbIUFokoWYalBbYKCuDeQRpDL7PF5ojLIn30kZWydFBMPQYizAxo7xXaX8fc RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32d6kt5ve5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P02s4d188003
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32g9uu0547-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P07Pcu024744
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:25 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 17:07:25 -0700
Subject: Re: [PATCH v11 10/25] xfs: Refactor xfs_attr_rmtval_remove
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-11-allison.henderson@oracle.com>
 <20200721233118.GH3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a54cf20c-7ce1-f333-1805-333f147463eb@oracle.com>
Date:   Fri, 24 Jul 2020 17:07:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721233118.GH3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/21/20 4:31 PM, Darrick J. Wong wrote:
> On Mon, Jul 20, 2020 at 05:15:51PM -0700, Allison Collins wrote:
>> Refactor xfs_attr_rmtval_remove to add helper function
>> __xfs_attr_rmtval_remove. We will use this later when we introduce
>> delayed attributes.  This function will eventually replace
>> xfs_attr_rmtval_remove
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 37 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 4d51969..9b4c173 100644
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
> 
> Er... I think these local variables can go away here, right?
I think so, this whole function sort of get phased out over the last 
three patches, so they dont live long.  Should be fine to clean out here 
though.

Allison

> 
> --D
> 
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
>> + * transaction and re-call the function
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
>> index 3616e88..9eee615 100644
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
