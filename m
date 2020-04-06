Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA89C2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EECE2082D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WkBBk8Ks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgDFXQk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 19:16:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44760 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgDFXQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 19:16:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036NFVZK038662;
        Mon, 6 Apr 2020 23:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=djexbyPdGipUigD7k6SF6KCq8nY/dP0xINPzd9NDUOI=;
 b=WkBBk8Kstsv8VMwNsiy11fYw2wliDqR2gM7C+UqGnTBk70Uld0i2eCw+yOVhZ+PLaxyw
 zDgcCQyRK9gAQT7tTLyzulS16kJVdoYLT8G3WgzIcYaAjwxiLDCGJcOSVeVfmqg5/wcY
 ZKcwTlCr+0TMJs/6KsrSVMobBcQgU382h7Hhhuo51jaHzE2mGbsjsTUzYArXQuYfeC0N
 e09RwVr7XvXSRonXmmShkiZmFbJgdSd0dIO+kTKgEo0IzSmkYmW/px18to/lLZ80MfZO
 hSxPbsxLwhEwl0WT0P2M9fZSJCVh0C2n4/L7yApa1NgTvYlLHXDZ+bkLQSp2PqiMINyG jA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 306hnr1rfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 23:16:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036NCeBL167216;
        Mon, 6 Apr 2020 23:14:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3073sqtwhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 23:14:35 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036NEXDr027662;
        Mon, 6 Apr 2020 23:14:34 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 16:14:33 -0700
Subject: Re: [PATCH v8 02/20] xfs: Check for -ENOATTR or -EEXIST
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-3-allison.henderson@oracle.com>
 <20200406143155.GD20708@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e4120453-09ad-95ae-cb77-764f4177f433@oracle.com>
Date:   Mon, 6 Apr 2020 16:14:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200406143155.GD20708@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/20 7:31 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:11PM -0700, Allison Collins wrote:
>> Delayed operations cannot return error codes.  So we must check for
>> these conditions first before starting set or remove operations
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 2a0d3d3..f7e289e 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -404,6 +404,17 @@ xfs_attr_set(
>>   				args->total, 0, quota_flags);
>>   		if (error)
>>   			goto out_trans_cancel;
>> +
>> +		error = xfs_has_attr(args);
>> +		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
>> +			goto out_trans_cancel;
>> +
>> +		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
>> +			goto out_trans_cancel;
>> +
>> +		if (error != -ENOATTR && error != -EEXIST)
>> +			goto out_trans_cancel;
> 
> I'd kill off the whitespace between the above error checks. Otherwise
> looks good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Alrighty, will do.  Thanks!

Allison
> 
>> +
>>   		error = xfs_attr_set_args(args);
>>   		if (error)
>>   			goto out_trans_cancel;
>> @@ -411,6 +422,10 @@ xfs_attr_set(
>>   		if (!args->trans)
>>   			goto out_unlock;
>>   	} else {
>> +		error = xfs_has_attr(args);
>> +		if (error != -EEXIST)
>> +			goto out_trans_cancel;
>> +
>>   		error = xfs_attr_remove_args(args);
>>   		if (error)
>>   			goto out_trans_cancel;
>> -- 
>> 2.7.4
>>
> 
