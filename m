Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F077AC35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 16:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB36C20836
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 16:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yW/vI6ls"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgBWQDK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 11:03:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37844 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgBWQDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 11:03:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NG38S3118312;
        Sun, 23 Feb 2020 16:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OR+05i2D6fWNUBqOWKW7vsloHKl2pPPMVchewC3wxQY=;
 b=yW/vI6lswkSUeE+nkgSp6RNjl+AMkuLxFuQOPEfJ5Ujx8ribIiklj0bZaB0fL7UJ5REX
 1FO8Lgb6mT0xCOSaJnc+u6jHFsZoR5sqorrwd6Z+jNGo+QNvcIzYFpg6MW6VK96bOrGR
 CE/sInVmHNJq7CuDByM/dagPodHpJJjN+YtKzAYEIIc44IXQ0BkQQGNiKDeXQ86M4EXc
 5YCMpoUmPqsfelv8K/Df892Qz1o0s/GiXLEgI9TwdbU/NQq2uW5DG5Plxx6TSfpECAol
 n0Vf5OY+RorDtW1Km/8YupOii2I+M5r5b8tmoTEcUVKvePYQTC1REpDJqgj8dDxXr7q8 nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yauqu3q9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 16:03:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NG20oP109510;
        Sun, 23 Feb 2020 16:03:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ybdsefeus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 16:03:07 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01NG36Nq006593;
        Sun, 23 Feb 2020 16:03:06 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 08:03:06 -0800
Subject: Re: [PATCH v7 01/19] xfs: Replace attribute parameters with struct
 xfs_name
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-2-allison.henderson@oracle.com>
 <CAOQ4uxhmsq9aDPPofS=UPrfcate=h-Jj_Qp95_7-N8_WuDCBTw@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b7183c7e-e046-13f0-92a6-efa94e0ecfcc@oracle.com>
Date:   Sun, 23 Feb 2020 09:03:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhmsq9aDPPofS=UPrfcate=h-Jj_Qp95_7-N8_WuDCBTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 2:34 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> This patch replaces the attribute name and length parameters with a single struct
>> xfs_name parameter.  This helps to clean up the numbers of parameters being passed
>> around and pre-simplifies the code some.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> I realize I am joining very late with lots of reviewed-by already applied,
> so unless I find anything big, please regard my comments and possible
> future improvements for the extended series rather than objections to this
> pretty much baked patch set.
Sure, no worries, it has a lot of history to keep track of.

> 
> [...]
> 
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index d42de92..28c07c9 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -357,7 +357,9 @@ xfs_attrmulti_attr_get(
>>   {
>>          unsigned char           *kbuf;
>>          int                     error = -EFAULT;
>> -       size_t                  namelen;
>> +       struct xfs_name         xname;
>> +
>> +       xfs_name_init(&xname, name);
>>
>>          if (*len > XFS_XATTR_SIZE_MAX)
>>                  return -EINVAL;
>> @@ -365,9 +367,7 @@ xfs_attrmulti_attr_get(
>>          if (!kbuf)
>>                  return -ENOMEM;
>>
>> -       namelen = strlen(name);
>> -       error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
>> -                            flags);
>> +       error = xfs_attr_get(XFS_I(inode), &xname, &kbuf, (int *)len, flags);
>>          if (error)
>>                  goto out_kfree;
>>
>> @@ -389,7 +389,9 @@ xfs_attrmulti_attr_set(
>>   {
>>          unsigned char           *kbuf;
>>          int                     error;
>> -       size_t                  namelen;
>> +       struct xfs_name         xname;
>> +
>> +       xfs_name_init(&xname, name);
>>
>>          if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>>                  return -EPERM;
>> @@ -400,8 +402,7 @@ xfs_attrmulti_attr_set(
>>          if (IS_ERR(kbuf))
>>                  return PTR_ERR(kbuf);
>>
>> -       namelen = strlen(name);
>> -       error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
>> +       error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len, flags);
>>          if (!error)
>>                  xfs_forget_acl(inode, name, flags);
>>          kfree(kbuf);
>> @@ -415,12 +416,14 @@ xfs_attrmulti_attr_remove(
>>          uint32_t                flags)
>>   {
>>          int                     error;
>> -       size_t                  namelen;
>> +       struct xfs_name         xname;
>> +
>> +       xfs_name_init(&xname, name);
>>
>>          if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>>                  return -EPERM;
>> -       namelen = strlen(name);
>> -       error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
>> +
>> +       error = xfs_attr_remove(XFS_I(inode), &xname, flags);
>>          if (!error)
>>                  xfs_forget_acl(inode, name, flags);
>>          return error;
> 
> 
> A struct inititializer macro would have been nice, so code like this:
> 
> +       struct xfs_name         xname;
> +
> +       xfs_name_init(&xname, name);
> 
> Would become:
> +       struct xfs_name         xname = XFS_NAME_STR_INIT(name);
> 
> As a matter of fact, in most of the cases a named local variable is
> not needed at
> all and the code could be written with an anonymous local struct variable macro:
> 
> +       error = xfs_attr_remove(XFS_I(inode), XFS_NAME_STR(name), flags);
> 
The macro does look nice.  I would be the third iteration of 
initializers that this patch has been through though.  Can I get a 
consensus of how many people like the macro?

Allison

> Thanks,
> Amir.
> 
