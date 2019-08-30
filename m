Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE8DC3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 21:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E2223431
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 21:54:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SjoFdz+9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfH3Vy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 17:54:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbfH3Vy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 17:54:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7ULsTlE077193;
        Fri, 30 Aug 2019 21:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Chm994TwjX6z+NCoql52OSrfDqgo8oUwIP2mQPS3CJA=;
 b=SjoFdz+9koIdSLJdY637BvbEGqv0yqXQD/jicAErbgTEN7gpPspy0XDvi4dg8VUtTR60
 /nSfWmNfa+wpSPaQ4pJubj6lBkYVEnh4YmWxZS3F1HyM2GUIQYIAeEDui657WRCzviZh
 CWgXeFX47AB0sjEwx7GL0uOWinaDNnMTwOqEUgfHwJ49lCKl9iNuNUH1pfXA6cUWtBSp
 dna7aelMLSaeF08oJOZswujXRmdn3CR+6RT/gXTfWLfmPjz7gr6ITt9inXs2r4mRru8G
 r4rMtay9RChWfCWQKdaUiiHpV0zVGjWLjYWhNDRC9c4ckc3JdDqcl0x5P/Id7V6+f6Va vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uqc400066-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 21:54:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7ULrcvL061656;
        Fri, 30 Aug 2019 21:54:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2upxabuwun-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 21:54:53 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7UL3e6W003115;
        Fri, 30 Aug 2019 21:03:40 GMT
Received: from [192.168.1.9] (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 14:03:40 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/9] xfsprogs: update spdx tags in LICENSES/
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713883483.386621.11761019405847468101.stgit@magnolia>
Message-ID: <71de628b-4e17-f0ba-2ef5-9cefb221656e@oracle.com>
Date:   Fri, 30 Aug 2019 14:03:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156713883483.386621.11761019405847468101.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/29/19 9:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Update the GPL related SPDX tags in LICENSES to reflect the SPDX 3.0
> tagging formats.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   LICENSES/GPL-2.0 |    6 ++++++
>   1 file changed, 6 insertions(+)
> 
> 
> diff --git a/LICENSES/GPL-2.0 b/LICENSES/GPL-2.0
> index b8db91d3..ff0812fd 100644
> --- a/LICENSES/GPL-2.0
> +++ b/LICENSES/GPL-2.0
> @@ -1,5 +1,7 @@
>   Valid-License-Identifier: GPL-2.0
> +Valid-License-Identifier: GPL-2.0-only
>   Valid-License-Identifier: GPL-2.0+
> +Valid-License-Identifier: GPL-2.0-or-later
>   SPDX-URL: https://urldefense.proofpoint.com/v2/url?u=https-3A__spdx.org_licenses_GPL-2D2.0.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=yyH1nLyiAZtlQ8oRe73p1JKOpwh3hOylOYJJHf-fb-E&s=u5TL_q2un4FyVTyZCtV7gVqpRynFeNAyAB6R2fcd82I&e=
>   Usage-Guide:
>     To use this license in source code, put one of the following SPDX
> @@ -7,8 +9,12 @@ Usage-Guide:
>     guidelines in the licensing rules documentation.
>     For 'GNU General Public License (GPL) version 2 only' use:
>       SPDX-License-Identifier: GPL-2.0
> +  or
> +    SPDX-License-Identifier: GPL-2.0-only
>     For 'GNU General Public License (GPL) version 2 or any later version' use:
>       SPDX-License-Identifier: GPL-2.0+
> +  or
> +    SPDX-License-Identifier: GPL-2.0-or-later
>   License-Text:
>   
>   		    GNU GENERAL PUBLIC LICENSE
> 


Looks ok to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
