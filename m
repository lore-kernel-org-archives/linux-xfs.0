Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2894C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3650206E0
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:43:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ap1P4z+y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBWSnK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 13:43:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWSnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 13:43:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIh8rl106380;
        Sun, 23 Feb 2020 18:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fwkA+/nRjaF6Ksyf0ns2/a7zIek9Hp2l7q9PBgrGAII=;
 b=Ap1P4z+yuIHlGbl943AKhxSSlQBEKveV0v1TKK2AyVKHGblvFPd/LMoCRZOfLZ3oV1oa
 Rc6xUG2Wwh5M3oFwcGHG+lm9AlJYoeyyov+fwPUFj3U7Y3/wyTF/3nANPPhuoULWswq0
 Yyzv+kTMfpok9nZot9mlAO5cgSdhrms81qDF5vKGfjf3WBARdftkOrIK3e0tEphOlYyK
 oHyqtQXBsg5EoQaWCyYCESvbvK7b+lf1YsNwMVaxoIs37xdXs6WEgC4o5nAIZPmVzDDL
 QYLOOuYqHXUmwtzxDcBoV9ysIcGJEoHUYAitiymEhKBC7mXUsND3EWOWta24ofkMPTq0 xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yavxrbvmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:43:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIgbSu163437;
        Sun, 23 Feb 2020 18:43:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ybdusqu8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:43:07 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01NIh6Nl005452;
        Sun, 23 Feb 2020 18:43:06 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 10:43:06 -0800
Subject: Re: [PATCH v7 17/19] xfs: Add helper function
 xfs_attr_leaf_mark_incomplete
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-18-allison.henderson@oracle.com>
 <CAOQ4uxh-ybRSFX4v3x6m6H0+8iC7Guoa5_tAoF1Drpw8Q5sOuw@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d1d4779e-92e9-a9f7-b590-89cad5d799a9@oracle.com>
Date:   Sun, 23 Feb 2020 11:43:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxh-ybRSFX4v3x6m6H0+8iC7Guoa5_tAoF1Drpw8Q5sOuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 6:47 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> This patch helps to simplify xfs_attr_node_removename by modularizing the code
>> around the transactions into helper functions.  This will make the function easier
>> to follow when we introduce delayed attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Found no surprises here, you may add:
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Thanks,
> Amir.

Alrighty then.  Thank you!

Allison

> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>>   1 file changed, 31 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index dd935ff..b9728d1 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1416,6 +1416,36 @@ xfs_attr_node_shrink(
>>   }
>>
>>   /*
>> + * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
>> + * for later deletion of the entry.
>> + */
>> +STATIC int
>> +xfs_attr_leaf_mark_incomplete(
>> +       struct xfs_da_args      *args,
>> +       struct xfs_da_state     *state)
>> +{
>> +       int error;
>> +
>> +       /*
>> +        * Fill in disk block numbers in the state structure
>> +        * so that we can get the buffers back after we commit
>> +        * several transactions in the following calls.
>> +        */
>> +       error = xfs_attr_fillstate(state);
>> +       if (error)
>> +               return error;
>> +
>> +       /*
>> +        * Mark the attribute as INCOMPLETE
>> +        */
>> +       error = xfs_attr3_leaf_setflag(args);
>> +       if (error)
>> +               return error;
>> +
>> +       return 0;
>> +}
>> +
>> +/*
>>    * Remove a name from a B-tree attribute list.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>> @@ -1473,20 +1503,7 @@ xfs_attr_node_removename(
>>          args->dac.da_state = state;
>>
>>          if (args->rmtblkno > 0) {
>> -               /*
>> -                * Fill in disk block numbers in the state structure
>> -                * so that we can get the buffers back after we commit
>> -                * several transactions in the following calls.
>> -                */
>> -               error = xfs_attr_fillstate(state);
>> -               if (error)
>> -                       goto out;
>> -
>> -               /*
>> -                * Mark the attribute as INCOMPLETE, then bunmapi() the
>> -                * remote value.
>> -                */
>> -               error = xfs_attr3_leaf_setflag(args);
>> +               error = xfs_attr_leaf_mark_incomplete(args, state);
>>                  if (error)
>>                          goto out;
>>
>> --
>> 2.7.4
>>
