Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBFAFC35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4C4D2067D
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KwstcYJN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgBWRdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:33:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgBWRdP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 12:33:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NHWH9u177748;
        Sun, 23 Feb 2020 17:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=l8pRcnncWLDNyGuhvmG+k6fFUlncQWECyccBclfwA4E=;
 b=KwstcYJNGC9zbTmZhEVADyz2/B9lRtWlLm76N9+LWrc636PibM37RScxQiIyCTwmw1gA
 cmFvLiDlcbagS1y7JfmpuCoFx9Gtq2+Dt/+i0vgZ3+ZKbqOnMHda5P3S47lho/NV+fsg
 UuGNPtCc7xdT9VypnAHHoPUC6zn78r4393JmSCBYZ60z3Re2sJd5ZHchLeLJHsm8kQPx
 fq9lTXAZAa/ke92qAlXPte/7zOTjX0N2+La0Alj6pAHZyiFomx9/B9gJehDDm/qfkGKA
 /cgUzGnpguRwPhf/7a6mA58SRtjvQwoq/FnKTq5umztqXucjDtTULQfQy2GnSJWNbvLn tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ybvr4g3gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:33:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NHWRUX092811;
        Sun, 23 Feb 2020 17:33:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ybdusmje5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:33:12 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01NHXBC1003172;
        Sun, 23 Feb 2020 17:33:11 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 09:33:11 -0800
Subject: Re: [PATCH v7 04/19] xfs: Check for -ENOATTR or -EEXIST
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-5-allison.henderson@oracle.com>
 <CAOQ4uxiO-1sMa8c5YNmd8+5DQCLN8ioj3cVsUTsuzcq4saTfqQ@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b25a0ce2-d0e0-d709-42ea-594e8883d52d@oracle.com>
Date:   Sun, 23 Feb 2020 10:33:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiO-1sMa8c5YNmd8+5DQCLN8ioj3cVsUTsuzcq4saTfqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/23/20 5:25 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> Delayed operations cannot return error codes.  So we must check for these conditions
>> first before starting set or remove operations
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 2255060..a2f812f 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -437,6 +437,14 @@ xfs_attr_set(
>>                  goto out_trans_cancel;
>>
>>          xfs_trans_ijoin(args.trans, dp, 0);
>> +
>> +       error = xfs_has_attr(&args);
>> +       if (error == -EEXIST && (name->type & ATTR_CREATE))
>> +               goto out_trans_cancel;
>> +
>> +       if (error == -ENOATTR && (name->type & ATTR_REPLACE))
>> +               goto out_trans_cancel;
>> +
> 
> And we do care about other errors?

I guess they would surface during the set operation as they do now, 
though it's probably better to catch it here.  Will add!  Thanks!

Allison

> 
> Thanks,
> Amir.
> 
