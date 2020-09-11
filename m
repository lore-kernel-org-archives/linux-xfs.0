Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE08C43461
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DCD020829
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WxIYgfKR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgIKC6C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:58:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgIKC6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 22:58:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B2tLvH189035;
        Fri, 11 Sep 2020 02:57:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ftLc2t+FTL+wLZ20gOGWI28iIW+N77APc3FM7tFCIRI=;
 b=WxIYgfKR584Fh659GUPuEKRwV35Dkzs2iZUL7Idcca3+O1jWQjGjuyvkxoORH6XDjE+X
 486nKl95rRUA+tPGqtPv8nRoP2y2EyNhwPJ+l5YsQC/cT48Fo0G/n3liqQYUc7uGIPaR
 7j9Mq4WchbqKOZJ55YN4GbgTybti+7gQ7G3DGRhTC2lb1wLYnIuPpWtJUHYRysR0wgZv
 VwSmz9ywQhoQxgD2fxpabqDeeJiCGFKZQmyIJua+zqdyA117dL5bKAaGvotHK8DthWT/
 HJK/TjJQoU++rdESXDqgRLsabN6qaxcVIxYNJOS5C0BLaj/VJxaXBibuXjl4R2LY9fOK EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33c23rbn34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 02:57:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B2tBOM116058;
        Fri, 11 Sep 2020 02:57:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33cmkbh41k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 02:57:57 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08B2vvwe025581;
        Fri, 11 Sep 2020 02:57:57 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 19:57:56 -0700
Subject: Re: [PATCH 3/4] mkfs: fix reflink/rmap logic w.r.t. realtime devices
 and crc=0 support
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950110896.567664.15989009829117632135.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <677a25f9-fc75-a72f-c03c-469a97a82540@oracle.com>
Date:   Thu, 10 Sep 2020 19:57:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159950110896.567664.15989009829117632135.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/7/20 10:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> mkfs has some logic to deal with situations where reflink or rmapbt are
> turned on and the administrator has configured a realtime device or a V4
> filesystem; such configurations are not allowed.
> 
> The logic ought to disable reflink and/or rmapbt if they're enabled due
> to being the defaults, and it ought to complain and abort if they're
> enabled because the admin explicitly turned them on.
> 
> Unfortunately, the logic here doesn't do that and makes no sense at all
> since usage() exits the program.  Fix it to follow what everything else
> does.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok makes sense
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   mkfs/xfs_mkfs.c |   18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 39fad9576088..6b55ca3e4c57 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1973,7 +1973,7 @@ _("sparse inodes not supported without CRC support\n"));
>   		}
>   		cli->sb_feat.spinodes = false;
>   
> -		if (cli->sb_feat.rmapbt) {
> +		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
>   			fprintf(stderr,
>   _("rmapbt not supported without CRC support\n"));
>   			usage();
> @@ -1995,17 +1995,19 @@ _("cowextsize not supported without reflink support\n"));
>   		usage();
>   	}
>   
> -	if (cli->sb_feat.reflink && cli->xi->rtname) {
> -		fprintf(stderr,
> +	if (cli->xi->rtname) {
> +		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
> +			fprintf(stderr,
>   _("reflink not supported with realtime devices\n"));
> -		usage();
> +			usage();
> +		}
>   		cli->sb_feat.reflink = false;
> -	}
>   
> -	if (cli->sb_feat.rmapbt && cli->xi->rtname) {
> -		fprintf(stderr,
> +		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
> +			fprintf(stderr,
>   _("rmapbt not supported with realtime devices\n"));
> -		usage();
> +			usage();
> +		}
>   		cli->sb_feat.rmapbt = false;
>   	}
>   
> 
