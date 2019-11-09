Return-Path: <SRS0=uP9V=ZB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678B0C17441
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 00:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38F0020869
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 00:11:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K1PQCPn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfKIALU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 19:11:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45018 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKIALU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 19:11:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA909MVx089627
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=voqu25x710wnCKmhD6O7VYGFiJstZhpqa/GGtv8iNW0=;
 b=K1PQCPn+lNEEe4TX9k+40xdY2cgqmvfJouXIogmX6L/AW4QqOHPRgNHvqzl5HuOX/YZj
 /B0ZVc3bo8IY5zxFIOn2hhpYEgomABSpLJdV08jUlsyUzG1RoY4pvYGOYRDpeLjgD/7q
 whz03iqX6SJXMZUaXSrFpDtluSN27DEOu16Z5rtCWU2GPh1iZLl0klnPTs1B92sugwYa
 KjGCtA78JGaXzujhvhD7GuUYPD4crz5VNzdTvf2Y6xu7PSpWmN4G9YyyNe+mh9tWxRLq
 MWCcQZJBnxclc4p6mJIiFXcE9hVkYZRkaCH5CFyqoYCswIWTuwiU4f4HZgltBdtuhKID 5Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5hgv85qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 00:11:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA909Fcr013866
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:11:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w5hgx4ruq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 00:11:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA90BHiG023826
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:11:17 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 16:11:17 -0800
Subject: Re: [PATCH v4 13/17] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-14-allison.henderson@oracle.com>
 <20191108211947.GD6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <fb8bbd9f-2646-bac3-97b3-3f4a5003d14e@oracle.com>
Date:   Fri, 8 Nov 2019 17:11:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108211947.GD6219@magnolia>
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
> On Wed, Nov 06, 2019 at 06:27:57PM -0700, Allison Collins wrote:
>> New delayed allocation routines cannot be handling
>> transactions so factor them up into the calling functions
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Looks pretty straightforward,
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
Thanks!

Allison

> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 16 ++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>>   2 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 2f9fb7a..5dcb19f 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -797,6 +797,14 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>>   		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>>   		error = xfs_attr3_leaf_clearflag(args);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   	}
>>   	return error;
>>   }
>> @@ -1154,6 +1162,14 @@ xfs_attr_node_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   		if (error)
>>   			goto out;
>> +
>> +		 /*
>> +		  * Commit the flag value change and start the next trans in
>> +		  * series.
>> +		  */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			goto out;
>>   	}
>>   	retval = error = 0;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 023c616..07eee3ff 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2802,10 +2802,7 @@ xfs_attr3_leaf_clearflag(
>>   			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>>   	}
>>   
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	return xfs_trans_roll_inode(&args->trans, args->dp);
>> +	return error;
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
