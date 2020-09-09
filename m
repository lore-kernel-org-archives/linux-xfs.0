Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BC4C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 18:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96EE120C09
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 18:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pqXxk0jX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgIISwQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 14:52:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIISwM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 14:52:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089InQks133666;
        Wed, 9 Sep 2020 18:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wRQMBbgyE780H9oZKmHohxX9YEocjPdiZcrrNX6RqgU=;
 b=pqXxk0jXvuvIc0hLSHZJ8pDjnjfKnkusrAvXzr8/LuidugfJQKnKWUvszi3ETv/buWPc
 iK95IV+VUDlrikw1Wz288I6ALUieGSQZvwYBaEIXSirgwqumJwFm5LiK+L5Ils2sXEn4
 WR+zbLwzIJ25eWXFNJ+GpTE6HLcDmqt04S6m3qJ+m2A16nuLUuJw7yWLYxqcD/aFKkG7
 k+YaL9zsqlVExxR1eJmuOs2gvv7bPOUtv/6miM6nWz8Cvd7z1YLdAeXR1tLK6VENT7f1
 nGSSMcFaY//gI5paTTnJxeU64wABVAXLn3LRTAUSknOU80Jy41FtitOQ6AjM3rOG1Er5 HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33c23r3rkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 18:52:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089IjcEk041590;
        Wed, 9 Sep 2020 18:52:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33dackwt8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 18:52:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 089Iq2TE026548;
        Wed, 9 Sep 2020 18:52:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 11:52:02 -0700
Date:   Wed, 9 Sep 2020 11:52:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com
Subject: Re: [PATCH -next] xfs: Remove unneeded semicolon
Message-ID: <20200909185200.GL7955@magnolia>
References: <20200909120733.115415-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909120733.115415-1-zhengbin13@huawei.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 09, 2020 at 08:07:32PM +0800, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> fs/xfs/xfs_icache.c:1214:2-3: Unneeded semicolon
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 101028ebb571..5e926912e507 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1211,7 +1211,7 @@ xfs_reclaim_inodes(
>  	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
>  		xfs_ail_push_all_sync(mp->m_ail);
>  		xfs_reclaim_inodes_ag(mp, &nr_to_scan);
> -	};
> +	}
>  }
> 
>  /*
> --
> 2.26.0.106.g9fadedd
> 
