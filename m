Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E9DC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F3C4206EB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:57:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TOg/2Gl0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgEDW5T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 18:57:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgEDW5T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 18:57:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MleYR141529
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=INFS9T/baxZsIXRnaQ174uZvGxbacoDPKlZ2bVAtnBc=;
 b=TOg/2Gl06sCS0obrr+txcCdWgrLwcE9lgC/8oTMbk2CwPc5Lq5YVAo8SDqKfj4a7vJm1
 bP9YEI9MvXTvuE2edYlNHEyU7urDry6Cg41hiyELqFWlNDzdDRdoyWI/tBPZPta6tfjq
 jGKuR+iYu5xT9nL3nfqpDotYP88V6LLJ3BiE8i7XA0CgPoZlqsbOTEIRQfJhvo8oJN/2
 ewkY/kQ2k7wRd/jk4rsUKTkB6TG/pHHwJhwPIpOUzCxsLOloGdgkR29AVTn0O0ZL6ywR
 CjvN7q68ox2uOwfQoW431fJjayNxN3bNqY0jno4hT9ULSkqFnT+WAfEKS1OsHzQJIGDC Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r1snr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:57:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MlLpc132138
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:55:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjnc9d1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 22:55:17 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044MtG7L014671
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 22:55:16 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 15:55:16 -0700
Subject: Re: [PATCH v9 11/24] xfs: Pull up xfs_attr_rmtval_invalidate
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-12-allison.henderson@oracle.com>
 <20200504174146.GE13783@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2a4b97e2-fa77-3465-1e92-880e2ad8ccfe@oracle.com>
Date:   Mon, 4 May 2020 15:55:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504174146.GE13783@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 10:41 AM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:03PM -0700, Allison Collins wrote:
>> This patch pulls xfs_attr_rmtval_invalidate out of
>> xfs_attr_rmtval_remove and into the calling functions.  Eventually
>> __xfs_attr_rmtval_remove will replace xfs_attr_rmtval_remove when we
>> introduce delayed attributes.  These functions are exepcted to return
>> -EAGAIN when they need a new transaction.  Because the invalidate does
>> not need a new transaction, we need to separate it from the rest of the
>> function that does.  This will enable __xfs_attr_rmtval_remove to
>> smoothly replace xfs_attr_rmtval_remove later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Looks good to me,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thank you!

Allison
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 12 ++++++++++++
>>   fs/xfs/libxfs/xfs_attr_remote.c |  3 ---
>>   2 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 0fc6436..4fdfab9 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -669,6 +669,10 @@ xfs_attr_leaf_addname(
>>   		args->rmtblkcnt = args->rmtblkcnt2;
>>   		args->rmtvaluelen = args->rmtvaluelen2;
>>   		if (args->rmtblkno) {
>> +			error = xfs_attr_rmtval_invalidate(args);
>> +			if (error)
>> +				return error;
>> +
>>   			error = xfs_attr_rmtval_remove(args);
>>   			if (error)
>>   				return error;
>> @@ -1027,6 +1031,10 @@ xfs_attr_node_addname(
>>   		args->rmtblkcnt = args->rmtblkcnt2;
>>   		args->rmtvaluelen = args->rmtvaluelen2;
>>   		if (args->rmtblkno) {
>> +			error = xfs_attr_rmtval_invalidate(args);
>> +			if (error)
>> +				return error;
>> +
>>   			error = xfs_attr_rmtval_remove(args);
>>   			if (error)
>>   				return error;
>> @@ -1152,6 +1160,10 @@ xfs_attr_node_removename(
>>   		if (error)
>>   			goto out;
>>   
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
>> +
>>   		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>>   			goto out;
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 02d1a44..f770159 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -685,9 +685,6 @@ xfs_attr_rmtval_remove(
>>   
>>   	trace_xfs_attr_rmtval_remove(args);
>>   
>> -	error = xfs_attr_rmtval_invalidate(args);
>> -	if (error)
>> -		return error;
>>   	/*
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>> -- 
>> 2.7.4
>>
