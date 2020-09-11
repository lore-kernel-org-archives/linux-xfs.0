Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C44BC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45D3220829
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HRG3vCyq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgIKC5z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:57:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgIKC5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 22:57:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B2sJ1L191869;
        Fri, 11 Sep 2020 02:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QW/f2UFYM0BuQ8VD7RxIIZ+Z4zkyhCyVe9x52WYLppk=;
 b=HRG3vCyqyDdRX0++D5D0v+W+sd7IpBjPdwdTagjUNLpwsTtVwONmTG4lO2aB0ifxhKnm
 lP0pl51BMkMzaLjzPYmpCkpcjC86X100KbVq1B8+XENS9tciTWbcQsAVjO/CgF3TaCZh
 tsgMFmDr5062J2/jvqFR9kSNLdqthBzi9ZCo/xncjBysolEjAxrYV92IYEOc8PHvwA18
 reH4JW5lKusHtihP93g1B+3VBLSeQtT7Ry0onCcETAW3TWcoa6rY9t/7G9ootZ+plGM7
 zJP5HQEt8l74hWNNUeNjLEYo6W9EMVreoIt+CYC9jdyBayrQrCLZ4BbcmL5jtRMp3OVh qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3anbfxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 02:57:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B2tA3C115926;
        Fri, 11 Sep 2020 02:57:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33cmkbh3pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 02:57:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08B2vmxc025488;
        Fri, 11 Sep 2020 02:57:49 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 19:57:48 -0700
Subject: Re: [PATCH 2/4] mkfs.xfs: tweak wording of external log device size
 complaint
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950110270.567664.7772913999736955021.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ef05e7f2-840e-9dbb-8325-7f434bc91e7e@oracle.com>
Date:   Thu, 10 Sep 2020 19:57:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159950110270.567664.7772913999736955021.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/7/20 10:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the external log device is too small to satisfy minimum requirements,
> mkfs will complain about "external log device 512 too small...".  That
> doesn't make any sense, so add a few missing words to clarify what we're
> talking about:
> 
> "external log device size 512 blocks too small..."
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>   mkfs/xfs_mkfs.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a687f385a9c1..39fad9576088 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3095,7 +3095,7 @@ calculate_log_size(
>   	if (!cfg->loginternal) {
>   		if (min_logblocks > cfg->logblocks) {
>   			fprintf(stderr,
> -_("external log device %lld too small, must be at least %lld blocks\n"),
> +_("external log device size %lld blocks too small, must be at least %lld blocks\n"),
>   				(long long)cfg->logblocks,
>   				(long long)min_logblocks);
>   			usage();
> 
