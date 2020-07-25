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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C49EC433E3
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6EC220737
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VGB1hK/D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgGYAI1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 20:08:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36184 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgGYAI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 20:08:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONr5iu171202
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IRUEK2b5lfMLMiRMBPU+IY+baChdBbuHyWaHT+ykzm8=;
 b=VGB1hK/D/rQe6+5MCMQ42ZY3xP0/UYs3tzZhiyMzBGUQ7DYSI5yPBrgMYFqbJR4seIZF
 MAyDnuzvj+PFJsHXcGEzFxGV/MMWRqq4uqt1v08zlG8udNeCB1mnmLxT2C5p3tZrxcoc
 mO4miSJ5MOSaPk5H7ZJwoZLu2zEyk2NGy9X7cwXJIi/lHT5fyzIIOjMGkWn8sR0Pvydg
 wIKN5FdPVeuJc03yNj85uwMAt+UF7c1jHXsQYR0hVu/+FLlpsmHe7aT4BPNIOhnDkp1b
 H/U7KK85qUb2Hkxl8zf6grRqCnpFLyA3iEwe2/JPJF1Jwa+8EwkO/CpaOZddHXYlQxS+ KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgs1pca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P02t6F188038
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32g9uu061u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P08OZM013695
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:24 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 17:08:24 -0700
Subject: Re: [PATCH v11 13/25] xfs: Remove unneeded xfs_trans_roll_inode calls
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-14-allison.henderson@oracle.com>
 <20200721233449.GI3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <960333df-29b2-64d8-d1c4-789566b9f462@oracle.com>
Date:   Fri, 24 Jul 2020 17:08:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721233449.GI3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/21/20 4:34 PM, Darrick J. Wong wrote:
> On Mon, Jul 20, 2020 at 05:15:54PM -0700, Allison Collins wrote:
>> Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
>> needed. If they are the last operations executed in these functions, and
>> no further changes are made, then higher level routines will roll or
>> commit the transactions.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Looks decent,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Alrighty, thanks!

Allison

> 
> --D
> 
>> ---
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
