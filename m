Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCB6C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 20:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22112206BA
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 20:08:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BU304/6/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfKKUIL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 15:08:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKUIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 15:08:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABJsEh1183289;
        Mon, 11 Nov 2019 20:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cxhvAeZQUDvgqDBaGxQYkMH7iPZOsBdGAXCtGjgUchQ=;
 b=BU304/6/eduFfUJKURE2L7Q+IMCNDI26jNBBBC7bJJcWm4N3rAiGbuzj/XpASak/9yLA
 zBg88B1gluOEU1fcP5loG8o73RaUV/WS9xtfcDtvoxH6b5gCrHst6qli2fg960HUyEqh
 mA8y6rlS7fKQakE+CHnkqZt1enVvZwwEhbkDnZGfBHO8g8yKu2N45ewZlkv9dYeqW7UJ
 4aY1A2s5Az9NV0Lomv+gGIJBvuRaBMXaKIxn7U4688fQeecTBxKad12Hzls47Ej1EDbd
 gxwgGQmpOiAeuZbAsv6Gabz+rx7mNcdxKcUCkuiQzwFTQNV86qgswTOVy6A0CRDxDVsT iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w5mvtgs2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 20:07:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABJs3Ye159608;
        Mon, 11 Nov 2019 20:07:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w66wmnh14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 20:07:52 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABK7nlV024708;
        Mon, 11 Nov 2019 20:07:50 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 12:07:49 -0800
Subject: Re: [PATCH v4 02/17] xfs: Replace attribute parameters with struct
 xfs_name
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-3-allison.henderson@oracle.com>
 <20191111174924.GB28708@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c2571406-6a30-e4ea-496a-71572199f906@oracle.com>
Date:   Mon, 11 Nov 2019 13:07:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111174924.GB28708@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/11/19 10:49 AM, Christoph Hellwig wrote:
> On Wed, Nov 06, 2019 at 06:27:46PM -0700, Allison Collins wrote:
>> This patch replaces the attribute name and length parameters with a
>> single struct xfs_name parameter.  This helps to clean up the numbers of
>> parameters being passed around and pre-simplifies the code some.
> 
> Does it?  As-is the patch doesn't look too bad, although it adds more
> lines than it removes.  But together with the next patch that embedds
> an xfs_name into the xfs_da_args structure and the now added memcpys
> it doesn't really look very helpful to me.
> 
It has evolved a bit since its initial proposition.  Maybe it would help 
to raise the question of: is patch 2 or 3 alone more helpful than the 
combination of them?  I think initially Dave had suggested the clean up 
in one of the earlier reviews a while ago, so he may have an opinion here.

Personally I'm not super opinionated about it if people have strong 
feelings toward keeping or pitching it.  I will say after having worked 
with it as it is, I'm not sure I'm particularly fond of having a name 
struct in the param, and another in the args.  I think eventually 
someones going to forget that args supersedes the param after the init 
routine.  People will probably figure it out pretty quick if they get 
bit I suppose, but I do think it's a sort of wart to consider.

Allison
