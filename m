Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBEDC35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE56021569
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oTa9zYIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgAXARr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34712 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729616AbgAXARr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O08mbf024614;
        Fri, 24 Jan 2020 00:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GpHvEWcZReaWylEgfeiVILojJZeJJoOInPnYwY6LYPU=;
 b=oTa9zYIH8705UskBllg6W0oeZY01dABBDgb+fgkFVTYSNAhwopoMLhnxCMV+Z6bptBPs
 moFWx7VNhNhnuH2smSvuolHT9drGd94VW4TSQmGjrDljpoe5XAskmEP0MtmwnvrR9qWj
 Ay4ejKySyAGIQ2XqIJfI+b+GtuCqmTPfQxe06KfT8TlMI0AoS4SrY2c73gTJuwiaz8CK
 WfHN7V7GRoN7NRfSQcETbhfVNziR9mp5gzK8yVJflFXdjQQ4z0y6zej069NZjfQyR7gl
 VCpyuyOBQMOUFspS9tvb1f6XhE7jgCY0QKr5SFdCCkOZ5U/TFiSc+zrl5437qz/O0kG0 cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuwvxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0E7Mc111177;
        Fri, 24 Jan 2020 00:17:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xqmwb1j3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0Hf7v031002;
        Fri, 24 Jan 2020 00:17:41 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:41 -0800
Subject: [PATCH 2/6] xfs_repair: enforce that inode btree chunks can't point
 to AG headers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Thu, 23 Jan 2020 16:17:39 -0800
Message-ID: <157982505923.2765631.10587375380960098225.stgit@magnolia>
In-Reply-To: <157982504556.2765631.630298760136626647.stgit@magnolia>
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
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

