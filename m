Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D12C433E2
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 705E7208C7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mg/gw2bC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgIGRxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:53:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57278 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgIGRxH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:53:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HnrHI043246;
        Mon, 7 Sep 2020 17:53:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pkA/Ld/GEwt/h+wC1sPCqhNTsJ1v9d+yZz56BL3DpuE=;
 b=mg/gw2bCDbQe0BTOeuHRrE0iX/7HYCn1jsqybIUYTWgpuRlDz6IQA2ZBDI76GcKkxCtC
 iZqi8T3ViQ63ktJPqVGXN7nI7gQKH77hlJs0Kmf3ycEGmJhlrcHjhA9sHPznljmB1f5u
 YrN44GM6JZmwO6Urct0pTGHJKSaqVVuCqYO65LKlXcGqUJibB03nvO7nks4DUkAUL/FV
 DztSzVuLSQ1o8zYCGUDeSa5F/8yNOXY5N9aPc914+EI+aT1Cvxu9oMuTFt4PjvP6YQ0R
 UpmvmLkT0tsHIxexuXwROkioEOTOonCHGAetADcGTp91pI5VpU7oYQygPhgka9LY6U6H Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3amqgmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:53:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HovxB017069;
        Mon, 7 Sep 2020 17:53:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33cmk15nfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:53:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087Hr08A021789;
        Mon, 7 Sep 2020 17:53:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:51:56 -0700
Subject: [PATCH 4/4] mkfs: set required parts of the realtime geometry before
 computing log geometry
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:51:55 -0700
Message-ID: <159950111530.567664.7302518339658104292.stgit@magnolia>
In-Reply-To: <159950108982.567664.1544351129609122663.stgit@magnolia>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The minimum log size depends on the transaction reservation sizes, which
in turn depend on the realtime device geometry.  Therefore, we need to
set up some of the rt geometry before we can compute the real minimum
log size.

This fixes a problem where mkfs, given a small data device and a
realtime volume, formats a filesystem with a log that is too small to
pass the mount time log size checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6b55ca3e4c57..408198e9ec70 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3237,6 +3237,9 @@ start_superblock_setup(
 	} else
 		sbp->sb_logsunit = 0;
 
+	/* log reservation calculations depend on rt geometry */
+	sbp->sb_rblocks = cfg->rtblocks;
+	sbp->sb_rextsize = cfg->rtextblocks;
 }
 
 static void
@@ -3274,14 +3277,12 @@ finish_superblock_setup(
 	}
 
 	sbp->sb_dblocks = cfg->dblocks;
-	sbp->sb_rblocks = cfg->rtblocks;
 	sbp->sb_rextents = cfg->rtextents;
 	platform_uuid_copy(&sbp->sb_uuid, &cfg->uuid);
 	/* Only in memory; libxfs expects this as if read from disk */
 	platform_uuid_copy(&sbp->sb_meta_uuid, &cfg->uuid);
 	sbp->sb_logstart = cfg->logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
-	sbp->sb_rextsize = cfg->rtextblocks;
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
 	sbp->sb_rbmblocks = cfg->rtbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;

