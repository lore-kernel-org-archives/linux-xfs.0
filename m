Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511C0C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21971206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gh6Ug9oE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgAABJs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53350 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABJs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001191v8109731
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yM4L5lqj7e/lftvqVOX/k5304v0dG8SNaXmQQTmW+Ag=;
 b=Gh6Ug9oEGu0mLDz46chjYPcdH6ZC7qx0omI0poKXKDFVfASqQrGKE7QjXuwLW5D1LOXJ
 Xd4VuKYbNU3HUcmiVndd4/k7slffyIKwQum8itzEu+1xqyUx0ZUhlkqqEIR72tMAbSQD
 cpB1VN1S488gZ2OXsncOLieh3YagRaLCC4S3Hyq1cy54FY2/ok7wuwEd87ahr6l5hfKd
 l81ISOb1+vK5jYX3viOBenZiLILunG9sl4nLoACiUDCOsOF85b6F1lrQ/g5iq/Mc1LAp
 F6wNqss/4Kcxn1OIW1wmoYIMBCGc4WEaKVtRAPkMSsFtQFlNKdNYhhvPyqqbb7lS/nEE zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vI5045385
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x7medfbfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00119jC3027758
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:45 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:45 -0800
Subject: [PATCH 10/10] xfs: create a polled function to force inode
 inactivation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:43 -0800
Message-ID: <157784098338.1362752.12534751621591800147.stgit@magnolia>
In-Reply-To: <157784092020.1362752.15046503361741521784.stgit@magnolia>
References: <157784092020.1362752.15046503361741521784.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a polled version of xfs_inactive_force so that we can force
inactivation while holding a lock (usually the umount lock) without
tripping over the softlockup timer.  This is for callers that hold vfs
locks while calling inactivation, which is currently unmount, iunlink
processing during mount, and rw->ro remount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_icache.h |    2 ++
 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_mount.h  |    6 ++++++
 fs/xfs/xfs_super.c  |    3 ++-
 5 files changed, 61 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5240e9e517d7..892bb789dcbf 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -25,6 +25,7 @@
 #include "xfs_health.h"
 
 #include <linux/iversion.h>
+#include <linux/nmi.h>
 
 STATIC int xfs_inode_free_eofblocks(struct xfs_inode *ip, struct xfs_perag *pag,
 		void *args);
@@ -2284,8 +2285,12 @@ static int
 xfs_inactive_inodes_pag(
 	struct xfs_perag	*pag)
 {
-	return xfs_ici_walk_ag(pag, &xfs_inactive_iwalk_ops, 0, NULL,
+	int			error;
+
+	error = xfs_ici_walk_ag(pag, &xfs_inactive_iwalk_ops, 0, NULL,
 			XFS_ICI_INACTIVE_TAG);
+	wake_up(&pag->pag_mount->m_inactive_wait);
+	return error;
 }
 
 /*
@@ -2298,8 +2303,12 @@ xfs_inactive_inodes(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_ici_walk_fns(mp, &xfs_inactive_iwalk_ops, 0, eofb,
+	int			error;
+
+	error = xfs_ici_walk_fns(mp, &xfs_inactive_iwalk_ops, 0, eofb,
 			XFS_ICI_INACTIVE_TAG);
+	wake_up(&mp->m_inactive_wait);
+	return error;
 }
 
 /* Try to get inode inactivation moving. */
@@ -2406,3 +2415,42 @@ xfs_inactive_schedule_now(
 		spin_unlock(&pag->pag_ici_lock);
 	}
 }
+
+/* Return true if there are inodes still being inactivated. */
+static bool
+xfs_inactive_pending(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = 0;
+	bool			ret = false;
+
+	while (!ret &&
+	       (pag = xfs_perag_get_tag(mp, agno, XFS_ICI_INACTIVE_TAG))) {
+		agno = pag->pag_agno + 1;
+		spin_lock(&pag->pag_ici_lock);
+		if (pag->pag_ici_inactive)
+			ret = true;
+		spin_unlock(&pag->pag_ici_lock);
+		xfs_perag_put(pag);
+	}
+
+	return ret;
+}
+
+/*
+ * Flush all pending inactivation work and poll until finished.  This function
+ * is for callers that must flush with vfs locks held, such as unmount,
+ * remount, and iunlinks processing during mount.
+ */
+void
+xfs_inactive_force_poll(
+	struct xfs_mount	*mp)
+{
+	xfs_inactive_schedule_now(mp);
+
+	while (!wait_event_timeout(mp->m_inactive_wait,
+				   xfs_inactive_pending(mp) == false, HZ)) {
+		touch_softlockup_watchdog();
+	}
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index a82b473b88a2..75332d4450ba 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -89,4 +89,6 @@ void xfs_inactive_shutdown(struct xfs_mount *mp);
 void xfs_inactive_cancel_work(struct xfs_mount *mp);
 void xfs_inactive_schedule_now(struct xfs_mount *mp);
 
+void xfs_inactive_force_poll(struct xfs_mount *mp);
+
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b9b37eff4063..5e2ce91f4ab8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1066,7 +1066,7 @@ xfs_unmountfs(
 	 * Since this can involve finobt updates, do it now before we lose the
 	 * per-AG space reservations.
 	 */
-	xfs_inactive_force(mp);
+	xfs_inactive_force_poll(mp);
 
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 87a62b0543ec..237a15a136c8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -206,6 +206,12 @@ typedef struct xfs_mount {
 	 * into a single flush.
 	 */
 	struct work_struct	m_flush_inodes_work;
+
+	/*
+	 * Use this to wait for the inode inactivation workqueue to finish
+	 * inactivating all the inodes.
+	 */
+	struct wait_queue_head	m_inactive_wait;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fced499ecdc9..af1fe32247cf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1736,7 +1736,7 @@ xfs_remount_ro(
 	 * Since this can involve finobt updates, do it now before we lose the
 	 * per-AG space reservations.
 	 */
-	xfs_inactive_force(mp);
+	xfs_inactive_force_poll(mp);
 
 	/* Free the per-AG metadata reservation pool. */
 	error = xfs_fs_unreserve_ag_blocks(mp);
@@ -1859,6 +1859,7 @@ static int xfs_init_fs_context(
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
+	init_waitqueue_head(&mp->m_inactive_wait);
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
 	 * recovery, so we must set this to true so that an ifree transaction

