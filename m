Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C794EC3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 23:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9408A20578
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 23:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iTTKj8s6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfH3XdK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 19:33:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43228 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbfH3XdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 19:33:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UNV7qb140220;
        Fri, 30 Aug 2019 23:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=oaNHYlhAwZm6beg+Hy8Nb0ebpiX1W3NJhuxwVH4ri74=;
 b=iTTKj8s6ApgYPs98R3/gbeLdiv8p7CtEq8tF1fgxJtfeavHsnU90vBBkzQRl24FOU3Y6
 A6BqkRHz0UTSJASxLGgRISvPuFgJXOds8SWrCSjQGXp6lXItjCcC4iYP8vkdi1eT2xIR
 Vyj7UHma/6+HG9gYX9piRm2myhHmvKabbJWzjry+in6aVs/c9nhQcs+xdnPWgwmS4KVw
 A03qIGnPhBjM7x92A3T+yHq5ALh7Z2qy5vK0nwqpG1187xkbr3mtYR8/QCygQ4HCddI/
 E2ewUOR4lJriaAJsHLq3gw7F4bEeIymX7r1//whOwLHKFxwfsRFBC0stgJO2GiB9E4oQ jQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uqdhm80ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 23:33:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UNX3DS002649;
        Fri, 30 Aug 2019 23:33:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uphavu9wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 23:33:06 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UNWpDo006150;
        Fri, 30 Aug 2019 23:32:51 GMT
Received: from localhost (/10.159.246.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 16:32:51 -0700
Date:   Fri, 30 Aug 2019 16:32:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: define a version field for the AG geometry ioctl
 structure
Message-ID: <20190830233250.GL5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=996
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300231
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300230
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define a version field for the AG geometry ioctl structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c |    1 +
 fs/xfs/libxfs/xfs_fs.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5de296b34ab1..c54f7e6661d8 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -566,6 +566,7 @@ xfs_ag_get_geometry(
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
 	ageo->ag_number = agno;
+	ageo->ag_version = XFS_AG_GEOM_VERSION_V0;
 
 	agi = XFS_BUF_TO_AGI(agi_bp);
 	ageo->ag_icount = be32_to_cpu(agi->agi_count);
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 52d03a3a02a4..9da8e602131b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -287,7 +287,7 @@ struct xfs_ag_geometry {
 	uint32_t	ag_ifree;	/* o: inodes free */
 	uint32_t	ag_sick;	/* o: sick things in ag */
 	uint32_t	ag_checked;	/* o: checked metadata in ag */
-	uint32_t	ag_reserved32;	/* o: zero */
+	uint32_t	ag_version;	/* o: version of this structure */
 	uint64_t	ag_reserved[12];/* o: zero */
 };
 #define XFS_AG_GEOM_SICK_SB	(1 << 0)  /* superblock */
@@ -301,6 +301,8 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
 
+#define XFS_AG_GEOM_VERSION_V0	(0)
+
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
  */
