Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 407F0C11D2F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13C2E20CC7
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CjYjUCsB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgBXQZH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:25:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59960 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgBXQZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 11:25:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OG9Fws083739;
        Mon, 24 Feb 2020 16:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/eQ7hPB4RNPRMB0GcbLax0ZuK7ujJ5hS4HRztk8djlk=;
 b=CjYjUCsBUehSmpxL4HS/fxtwZSgUwtmtxW3et2q6phR5OUk9ATOWbZb3hfSlz2Z5p6Sj
 t409SB/eCT5Lf6XPYeBWECdRHHsKTg9xLIqPXAOxlZLfeP2zX83lzsbCSxw9wu1xRXHH
 +Lq06E0xt8CZ+HnuuXcyS/iHRHI6Y2zoSjm2GNYGl8pXusrGMz6aCCRp04f2oQvAKTzL
 BSWPnW0vMvAGq/hbw8ge8ZpcuBmvJPb+8lS1deFgtCVJDNCZjsfdFId7AnCRwT61x42u
 CdxJKpf8tq47L3mAeAMsTFp739idIyRXr7M1zdWvOBtNgo948Xx53A3sVCs4nN3anAO7 AA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yauqu8edn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 16:25:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OG86NH130275;
        Mon, 24 Feb 2020 16:25:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ybdsh3p78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 16:25:03 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01OGP2J5032709;
        Mon, 24 Feb 2020 16:25:02 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 08:25:02 -0800
Subject: Re: [PATCH v7 01/19] xfs: Replace attribute parameters with struct
 xfs_name
To:     Chandan Rajendra <chandan@linux.ibm.com>, linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-2-allison.henderson@oracle.com>
 <1635715.8B5ru1jVeS@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <813d6144-3ce7-5731-d60d-67e8fc188a77@oracle.com>
Date:   Mon, 24 Feb 2020 09:25:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1635715.8B5ru1jVeS@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/20 5:08 AM, Chandan Rajendra wrote:
> On Sunday, February 23, 2020 7:35 AM Allison Collins wrote:
>> This patch replaces the attribute name and length parameters with a single struct
>> xfs_name parameter.  This helps to clean up the numbers of parameters being passed
>> around and pre-simplifies the code some.
>>
> 
> I don't see any logical errors.
> 
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Alrighty, thank you!

Allison

> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c  | 22 +++++++++-------------
>>   fs/xfs/libxfs/xfs_attr.h  | 12 +++++-------
>>   fs/xfs/libxfs/xfs_types.c | 11 +++++++++++
>>   fs/xfs/libxfs/xfs_types.h |  1 +
>>   fs/xfs/xfs_acl.c          | 25 +++++++++++--------------
>>   fs/xfs/xfs_ioctl.c        | 23 +++++++++++++----------
>>   fs/xfs/xfs_iops.c         |  6 +++---
>>   fs/xfs/xfs_xattr.c        | 28 ++++++++++++++++------------
>>   8 files changed, 69 insertions(+), 59 deletions(-)
>>
