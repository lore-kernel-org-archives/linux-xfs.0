Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9832C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E669206E0
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="umyVlxu8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgBWRvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:51:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51980 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWRvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 12:51:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NHlWbT171009;
        Sun, 23 Feb 2020 17:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aCpQdLSU0VFDTc/Ua6/bKCv4Q6s142yyJJnF/bXZ688=;
 b=umyVlxu8Rxeu+KYyRaZgUuLxOLORdOilDqIZLMZaB5F0bm8bDsrsJfaFrM3UkdkJYwPl
 eQfKMB+QLv8KN2PSxhSWuSuDZNHByeMQZf0TWu9SDplVikb+AIvJ3uvhuqjxQTCe/lOQ
 0I/XsoQ1qNWBZXpYBSzQ9XKU5qt5Kh1ABCTfjj7XlWYruB6xJW80n1z50wRdgwYNo+4r
 N766n9074wNtnpnKD2eV3YU8jKvpgUgkRFQ17RdvbdCkFKo09zim67kn0FFDkCBQWN4s
 LJ3sA2B5kLJh9iWqCfCggFyderdTEPSe9Yjb2hnU9238TG/RNZJ5/NtOY3O0zEfLduFj 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4g450-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:51:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NHlwXk075040;
        Sun, 23 Feb 2020 17:51:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ybe0y854p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:51:33 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01NHpWKD010119;
        Sun, 23 Feb 2020 17:51:32 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 09:51:32 -0800
Subject: Re: [PATCH v7 08/19] xfs: Refactor xfs_attr_try_sf_addname
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-9-allison.henderson@oracle.com>
 <CAOQ4uxiUHG+PihrP3FXJA_AV-oQ63HG8jrtUg8nMCB3vbhXtRA@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <be74fdd6-eaa1-0fdd-8116-91148cceedd7@oracle.com>
Date:   Sun, 23 Feb 2020 10:51:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiUHG+PihrP3FXJA_AV-oQ63HG8jrtUg8nMCB3vbhXtRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 6:04 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> To help pre-simplify xfs_attr_set_args, we need to hoist transacation handling up,
> 
> typo: transacation
Will fix :-)
> 
> 
>> while modularizing the adjacent code down into helpers. In this patch, hoist the
>> commit in xfs_attr_try_sf_addname up into the calling function, and also pull the
>> attr list creation down.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
> 
> And I don't think the subject (Refactoring) is a reliable description
> of this change,
> but if nobody else cares, I don't mind what you call it.
Yes, I struggled with that a bit since things are just generally being 
re-arranged, but if there's a more descriptive term folks prefer, please 
call it out.

> 
> As far as not changing logic, you may add:
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Thanks!

Allison

> 
> 
> Thanks,
> Amir.
> 
