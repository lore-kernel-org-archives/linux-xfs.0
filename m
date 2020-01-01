Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01457C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C905E20718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SG1eY+nD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAABVB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:21:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58076 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:21:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EA8p092020;
        Wed, 1 Jan 2020 01:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GpHvEWcZReaWylEgfeiVILojJZeJJoOInPnYwY6LYPU=;
 b=SG1eY+nD67p+QOqPH9vZw7E8cTvlHIDJT+l8/c7c3EWnTAjfdCfXk34knmBAzIE82d5X
 TZcGkMKtofW4tLhOkqNfQoBY/2FtiMMQLrI09xSYmKm47eS4qijMZsYN6+uam7HGrB8/
 zCxiS2+UXO4UKeZB6AvXSw2BaooT9QvFyeg3BdAj1JADnD8fcD+BAJk+U5hnZzOHxvk1
 jy2zCAEivSA+YdwNHPPHjSdtBMRtuq+lzS2ddNuIQ5x1hXsIKtLYn3ravPmEuT+c5kAL
 9e5UxLwVrQRH3c5OAVk14XhepnyqWafeL+OsqDdmiE0gqgyuQ8Y7Y/M7aMPRLzTfuHAs 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:20:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011J7Fe184942;
        Wed, 1 Jan 2020 01:20:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2x8gj91d50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:20:58 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Kv7M030871;
        Wed, 1 Jan 2020 01:20:57 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:20:57 -0800
Subject: [PATCH 2/6] xfs_repair: enforce that inode btree chunks can't point
 to AG headers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Tue, 31 Dec 2019 17:20:54 -0800
Message-ID: <157784165438.1371066.4301130203678483556.stgit@magnolia>
In-Reply-To: <157784164200.1371066.15490825981810186191.stgit@magnolia>
References: <157784164200.1371066.15490825981810186191.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_repair has a very old check that evidently excuses the AG 0 inode
btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
AG headers).  mkfs never formats filesystems that way and it looks like
an error, so purge the check.  After this, we always complain if inodes
overlap with AG headers because that should never happen.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/globals.c    |    1 -
 repair/globals.h    |    1 -
 repair/scan.c       |   19 -------------------
 repair/xfs_repair.c |    7 -------
 4 files changed, 28 deletions(-)


diff --git a/repair/globals.c b/repair/globals.c
index dcd79ea4..8a60e706 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -73,7 +73,6 @@ int	lost_gquotino;
 int	lost_pquotino;
 
 xfs_agino_t	first_prealloc_ino;
-xfs_agino_t	last_prealloc_ino;
 xfs_agblock_t	bnobt_root;
 xfs_agblock_t	bcntbt_root;
 xfs_agblock_t	inobt_root;
diff --git a/repair/globals.h b/repair/globals.h
index 008bdd90..2ed5c894 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -114,7 +114,6 @@ extern int		lost_gquotino;
 extern int		lost_pquotino;
 
 extern xfs_agino_t	first_prealloc_ino;
-extern xfs_agino_t	last_prealloc_ino;
 extern xfs_agblock_t	bnobt_root;
 extern xfs_agblock_t	bcntbt_root;
 extern xfs_agblock_t	inobt_root;
diff --git a/repair/scan.c b/repair/scan.c
index c383f3aa..05707dd2 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1645,13 +1645,6 @@ scan_single_ino_chunk(
 				break;
 			case XR_E_INUSE_FS:
 			case XR_E_INUSE_FS1:
-				if (agno == 0 &&
-				    ino + j >= first_prealloc_ino &&
-				    ino + j < last_prealloc_ino) {
-					set_bmap(agno, agbno, XR_E_INO);
-					break;
-				}
-				/* fall through */
 			default:
 				/* XXX - maybe should mark block a duplicate */
 				do_warn(
@@ -1782,18 +1775,6 @@ _("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\
 				break;
 			case XR_E_INUSE_FS:
 			case XR_E_INUSE_FS1:
-				if (agno == 0 &&
-				    ino + j >= first_prealloc_ino &&
-				    ino + j < last_prealloc_ino) {
-					do_warn(
-_("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\n"),
-						agno, agbno, mp->m_sb.sb_inopblock);
-
-					set_bmap(agno, agbno, XR_E_INO);
-					suspect++;
-					break;
-				}
-				/* fall through */
 			default:
 				do_warn(
 _("inode chunk claims used block, finobt block - agno %d, bno %d, inopb %d\n"),
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9295673d..3e9059f3 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -460,13 +460,6 @@ calc_mkfs(xfs_mount_t *mp)
 		first_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno);
 	}
 
-	ASSERT(M_IGEO(mp)->ialloc_blks > 0);
-
-	if (M_IGEO(mp)->ialloc_blks > 1)
-		last_prealloc_ino = first_prealloc_ino + XFS_INODES_PER_CHUNK;
-	else
-		last_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno + 1);
-
 	/*
 	 * now the first 3 inodes in the system
 	 */

