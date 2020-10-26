Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D70C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E33FA20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w+rOZhGP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407144AbgJZXgO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44248 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407121AbgJZXgO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPR14177127;
        Mon, 26 Oct 2020 23:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EhhIgA2MsuQt18BuRPWm72CQT2P50BXW6z9ecQn61jA=;
 b=w+rOZhGPa8QnPbp5eM0lB1AGwjnaLEv40iONjobsfAPas4UgtDHqaI6UEF6pfGmApR6l
 85ufyn/FNtk0mBDorgutDB1z9+/l7ncAsBMc6NRHIX/YxCMxfWGvdIuImwwRoG9Kr2P7
 wdwd8ggqEgtSOLlld8beCfFKUTGQjXG5w4ItcVdcxCej1iIRaAydjs2ab8PtjOSIFzsq
 uWXO8p1oXQ2DhJc5nmH2yjCV5TqLDToPIxHtMKNPO1rW+k1B3ph2p+VseHx3iGeGgPCe
 7zxUUypI+giTvtrt1MkPq50Yhebsnoryn+uRkWcfO4SYzEP/wjTAX7oVkCl734cAWfOB bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqd6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxkC110446;
        Mon, 26 Oct 2020 23:36:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wfsxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:12 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNaBmS006264;
        Mon, 26 Oct 2020 23:36:11 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:10 -0700
Subject: [PATCH 19/26] libfrog: list the bigtime feature when reporting
 geometry
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:10 -0700
Message-ID: <160375537005.881414.6068353624094235785.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're reporting on a filesystem's geometry, report if the bigtime
feature is enabled on this filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index bd93924ea795..14507668e41b 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -28,6 +28,7 @@ xfs_report_geom(
 	int			spinodes;
 	int			rmapbt_enabled;
 	int			reflink_enabled;
+	int			bigtime_enabled;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -43,12 +44,13 @@ xfs_report_geom(
 	spinodes = geo->flags & XFS_FSOP_GEOM_FLAGS_SPINODES ? 1 : 0;
 	rmapbt_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
 	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
+	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -58,7 +60,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled,
+		"", reflink_enabled, bigtime_enabled,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,

