Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7ACCC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 21:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4B9206B9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 21:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vSYBQUrA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgEDVhW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 17:37:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDVhW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 17:37:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LXlK0128335;
        Mon, 4 May 2020 21:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uNLds5ApzXAAIGsoe/vmRWib6qFVn+OpEDf6T9iBNTI=;
 b=vSYBQUrANbfLDBxCbGunKi7LFjWAGeSDYJTZnVy/SUK1pSJuIlKekmS3BOxVEsMp3AZ5
 l5Ou1kR1UhcTqlB10bBGEmPIFweuG63k2gy0kGeP2OgyB2piLEI0yEbsNGQgzXGe0aiP
 lZNJRXkV9eGIFvHohHSHsDtuSA+1zkTzvo9m7+KAjMkHzvwtqcngxIsrdSirdB79RmZK
 OLdLWf0+rm4aS6Gtbnp+tuz9F0MnBQWNNUY6lG2FDeRHVy0kW6GcrhmajHiQZQuWW95A
 INpilBVjnN51NbKdF/+1RFdyEcUu6vCKVxH/HEAXuxq0g7o7QHFadU/8m9vSsxBnjtSs rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn1apt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:37:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LaqN6080769;
        Mon, 4 May 2020 21:37:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdrfxvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:37:17 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044LbHb0029982;
        Mon, 4 May 2020 21:37:17 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 14:37:16 -0700
Subject: Re: [PATCH v9 11/24] xfs: Pull up xfs_attr_rmtval_invalidate
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-12-allison.henderson@oracle.com>
 <20200504132730.GB54625@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c901cb63-b2ee-3587-b17a-a432e11952a4@oracle.com>
Date:   Mon, 4 May 2020 14:37:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504132730.GB54625@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 6:27 AM, Brian Foster wrote:
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
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, thank you!

Allison

> 
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
> 
