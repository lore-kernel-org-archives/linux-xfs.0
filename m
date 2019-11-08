Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FF4C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB4A52067B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:52:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lkUzMVaH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfKHTwb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 14:52:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39936 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfKHTwb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 14:52:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JmvCE129355
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GaeIyFw4dsb2zNgVsyh1RZ37y7uMZQtnQzNbffWi/dg=;
 b=lkUzMVaHq+S0YPKlMC45ZKZHLGOa2JH8gtDVcYeYYP4N7Ki0zS4ROPZGAGqqJSDJG2Xe
 x9dd0nwMaunGoePA4x/nwvUDDqioPpE8Vqn562luKQoIpODWZNS1NFmLHhrjlhTQDF1K
 o7irf7Bn9VqFpVzkmpFnwGGsVeBn0ceT9nV0FGj1M1DTigpa1dKZMbJTlDqu/WAYzwav
 bYGKIAV8RRDdj0o1uobwEEuCFMN78uDbRJULUXE35916XlZKY8HW0lh/QQY2VyZ1nj7w
 uH0VQkmp+soV/meDCbzE9wQEupeeDylL1siw6zY5jUWMpDvR+FuSe7JQYUpeizLqJGPJ Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w1fdwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:52:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8Jn122119627
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:52:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w5cxk9fhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:52:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8JqP5g028787
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:52:25 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 11:52:25 -0800
Subject: Re: [PATCH v4 07/17] xfs: Factor up trans handling in
 xfs_attr3_leaf_flipflags
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-8-allison.henderson@oracle.com>
 <20191108193515.GY6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8f67894f-bec4-3cfb-da64-87112ce83c01@oracle.com>
Date:   Fri, 8 Nov 2019 12:52:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108193515.GY6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/8/19 12:35 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:51PM -0700, Allison Collins wrote:
>> Since delayed operations cannot roll transactions, factor
>> up the transaction handling into the calling function
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Thank you!
Allison

> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  5 -----
>>   2 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index c8a3273..212995f 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -721,6 +721,13 @@ xfs_attr_leaf_addname(
>>   		error = xfs_attr3_leaf_flipflags(args);
>>   		if (error)
>>   			return error;
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			return error;
>>   
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing
>> @@ -1057,6 +1064,13 @@ xfs_attr_node_addname(
>>   		error = xfs_attr3_leaf_flipflags(args);
>>   		if (error)
>>   			goto out;
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			goto out;
>>   
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index d06cfd6..134eb00 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2973,10 +2973,5 @@ xfs_attr3_leaf_flipflags(
>>   			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>>   	}
>>   
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -
>>   	return error;
>>   }
>> -- 
>> 2.7.4
>>
