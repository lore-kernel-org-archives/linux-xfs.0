Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2800FC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E005720882
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vkDaOkB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgIKC6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:58:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52126 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgIKC6D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 22:58:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B2t2MT026840;
        Fri, 11 Sep 2020 02:58:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ENgbjNRw2ilMRP6bbvLM0qKAbNWzokSbSVtzZfQb21E=;
 b=vkDaOkB+erfi8Rmbo1zHGxwQEWzUEbvDiiAEfxOyhNTseKtYB7JmsCuR75B0FEYo3xRJ
 XwleQhyzMWnSx8vVc1rAK2sJLA3Z/9TbbUpqAlp76uSB/7FIvJc74kJ7YA9lDox+h8Al
 2Iw0nwpHXcCn6EIXJeqqXkgz9tLNL/PiX640KaU/PtqaU1/bQu76Sc+hxa8O8iWpUp1R
 KFnxWtLs8hox+Xd+JY9QEg5NAajX4qk8RFwQMzxEBYPlzTM2c/acx6s275JUo9HLhlr9
 73XVHO4APmZeiOHdo3Y+gS0P9cifLTaXHaLpJFDITKB9TlVsPhzmZxuoKJIal8DEb7LC aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mmbjbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 02:58:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B2tBur116016;
        Fri, 11 Sep 2020 02:58:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmkbh46p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 02:58:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08B2w1Ln019545;
        Fri, 11 Sep 2020 02:58:01 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 19:58:00 -0700
Subject: Re: [PATCH 4/4] mkfs: set required parts of the realtime geometry
 before computing log geometry
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950111530.567664.7302518339658104292.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b0d8c204-38b6-60de-51e2-f10207eccc70@oracle.com>
Date:   Thu, 10 Sep 2020 19:58:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159950111530.567664.7302518339658104292.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/7/20 10:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The minimum log size depends on the transaction reservation sizes, which
> in turn depend on the realtime device geometry.  Therefore, we need to
> set up some of the rt geometry before we can compute the real minimum
> log size.
> 
> This fixes a problem where mkfs, given a small data device and a
> realtime volume, formats a filesystem with a log that is too small to
> pass the mount time log size checks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok looks good
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>   mkfs/xfs_mkfs.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6b55ca3e4c57..408198e9ec70 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3237,6 +3237,9 @@ start_superblock_setup(
>   	} else
>   		sbp->sb_logsunit = 0;
>   
> +	/* log reservation calculations depend on rt geometry */
> +	sbp->sb_rblocks = cfg->rtblocks;
> +	sbp->sb_rextsize = cfg->rtextblocks;
>   }
>   
>   static void
> @@ -3274,14 +3277,12 @@ finish_superblock_setup(
>   	}
>   
>   	sbp->sb_dblocks = cfg->dblocks;
> -	sbp->sb_rblocks = cfg->rtblocks;
>   	sbp->sb_rextents = cfg->rtextents;
>   	platform_uuid_copy(&sbp->sb_uuid, &cfg->uuid);
>   	/* Only in memory; libxfs expects this as if read from disk */
>   	platform_uuid_copy(&sbp->sb_meta_uuid, &cfg->uuid);
>   	sbp->sb_logstart = cfg->logstart;
>   	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
> -	sbp->sb_rextsize = cfg->rtextblocks;
>   	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
>   	sbp->sb_rbmblocks = cfg->rtbmblocks;
>   	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;
> 
