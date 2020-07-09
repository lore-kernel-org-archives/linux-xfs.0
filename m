Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D63C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39C1720672
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x1d6aBk+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgGIWBn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 18:01:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGIWBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 18:01:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069LurVB102325;
        Thu, 9 Jul 2020 22:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5J1ZvWDfKExKvnjJCVYtY3YgG1VhXv8jCrXFc3Kflks=;
 b=x1d6aBk+7Gab6YahFYCPWHZVKpIc+OlWMm9qTKZ6LB0961ZazEU+DWn/oSKew3NKzTLd
 rcunjM3Rgqb3csa22PkooYJd9Hlm2URmdCcU6HcSkKZ+RWMdSy8EdWynmLvq5LNL+O3h
 sQXggck9Hnsnqru5Eypi3pY9kkvr8aO5lL73Y/2wB2c41EeH2EEIXryYof9ZZ7BSJaQI
 RvmBJvMgRWENctQoMaDIaIuaPsB8kLCdwOMQVNU6wvSm5k0OVh8IfgZzt2/9FD/s1XL6
 jg0rKrVZbI2eW/LNvWtgUi1izRMXAuQeuaVhgefo121JGN1vzFabecCHjzO7QmhkfqGi Hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 325y0amb4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 22:01:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069LxMQa012672;
        Thu, 9 Jul 2020 22:01:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 325k3j1snf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 22:01:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 069M1cE0023651;
        Thu, 9 Jul 2020 22:01:39 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 15:01:38 -0700
Subject: Re: [PATCH v10 13/25] xfs: Remove unneeded xfs_trans_roll_inode calls
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200625233018.14585-1-allison.henderson@oracle.com>
 <20200625233018.14585-14-allison.henderson@oracle.com>
 <20200708124137.GA53550@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <f462a636-c728-940b-8815-6556763e7955@oracle.com>
Date:   Thu, 9 Jul 2020 15:01:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200708124137.GA53550@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/8/20 5:41 AM, Brian Foster wrote:
> On Thu, Jun 25, 2020 at 04:30:06PM -0700, Allison Collins wrote:
>> Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
>> needed. If they are the last operations executed in these functions, and
>> no further changes are made, then higher level routines will roll or
>> commit the tranactions.
> 
> 	     transactions
will fix

> 
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> This one LGTM now:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Great, thanks!
Allison

> 
>>   fs/xfs/libxfs/xfs_attr.c | 61 ++++++------------------------------------------
>>   1 file changed, 7 insertions(+), 54 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4eff875..1a78023 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -693,34 +693,15 @@ xfs_attr_leaf_addname(
>>   		/*
>>   		 * If the result is small enough, shrink it all into the inode.
>>   		 */
>> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +		if (forkoff)
>>   			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>>   			/* bp is gone due to xfs_da_shrink_inode */
>> -			if (error)
>> -				return error;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				return error;
>> -		}
>> -
>> -		/*
>> -		 * Commit the remove and start the next trans in series.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -
>>   	} else if (args->rmtblkno > 0) {
>>   		/*
>>   		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>>   		error = xfs_attr3_leaf_clearflag(args);
>> -		if (error)
>> -			return error;
>> -
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   	}
>>   	return error;
>>   }
>> @@ -780,15 +761,11 @@ xfs_attr_leaf_removename(
>>   	/*
>>   	 * If the result is small enough, shrink it all into the inode.
>>   	 */
>> -	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +	if (forkoff)
>> +		return xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>>   		/* bp is gone due to xfs_da_shrink_inode */
>> -		if (error)
>> -			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> -	}
>> +
>>   	return 0;
>>   }
>>   
>> @@ -1070,18 +1047,8 @@ xfs_attr_node_addname(
>>   			error = xfs_da3_join(state);
>>   			if (error)
>>   				goto out;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				goto out;
>>   		}
>>   
>> -		/*
>> -		 * Commit and start the next trans in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			goto out;
>> -
>>   	} else if (args->rmtblkno > 0) {
>>   		/*
>>   		 * Added a "remote" value, just clear the incomplete flag.
>> @@ -1089,14 +1056,6 @@ xfs_attr_node_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   		if (error)
>>   			goto out;
>> -
>> -		 /*
>> -		  * Commit the flag value change and start the next trans in
>> -		  * series.
>> -		  */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			goto out;
>>   	}
>>   	retval = error = 0;
>>   
>> @@ -1135,16 +1094,10 @@ xfs_attr_node_shrink(
>>   	if (forkoff) {
>>   		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>>   		/* bp is gone due to xfs_da_shrink_inode */
>> -		if (error)
>> -			return error;
>> -
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>>   	} else
>>   		xfs_trans_brelse(args->trans, bp);
>>   
>> -	return 0;
>> +	return error;
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
> 
