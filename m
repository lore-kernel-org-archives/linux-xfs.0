Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4BBC32765
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13E5220718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kuGJZyZ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgAABJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51804 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118x4i089127
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LkXB8zbbC2+Dlm5jyy7/uIL6dJhEHIKMxgpli7JOZsw=;
 b=kuGJZyZ8Fsm33GHY/w5bnZNPzhn3fY3XGNljmyrStuLqMYic0GsTXD91I2XPbtA81LE9
 /sFkdaKh3rKTNwrZjKbzrPfCf1pmqCBjqU/RZPXcQj9HUaP3/ge0PlRD4sXOwmaCJET0
 2MgNDgS1axxsumOv63xSmgiJs8RhS10QDqsK3Q0MldBTmdDvL1bDaAJzWHy5M3sQdMUU
 Ht6c9JUWRkck6ErVOgMr5PaYcZDlAsG4psNkasnDoug0l2PkXhlr8m4xzeVBtGYgectK
 uZXnXt3VADARbFEud9Ptr+l05YKH1Gaa3Zc4nUmkrq9pW1wqIwrm7ok7NcqOjAhvqlU9 GQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118ukL045262
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x7medfav1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:57 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00118V1U031208
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:31 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:08:31 -0800
Subject: [PATCH 5/6] xfs: rename block gc start and stop functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:29 -0800
Message-ID: <157784090914.1361683.10419637110812284133.stgit@magnolia>
In-Reply-To: <157784087594.1361683.5987233633798863051.stgit@magnolia>
References: <157784087594.1361683.5987233633798863051.stgit@magnolia>
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

Shorten the names of the two functions that start and stop block
preallocation garbage collection and move them up to the other blockgc
functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |    4 ++--
 fs/xfs/xfs_icache.c   |   32 ++++++++++++++++----------------
 fs/xfs/xfs_icache.h   |    4 ++--
 fs/xfs/xfs_mount.c    |    2 +-
 fs/xfs/xfs_super.c    |    8 ++++----
 5 files changed, 25 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index abe88fa756aa..52fc05ee7ef8 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -909,7 +909,7 @@ xchk_stop_reaping(
 	struct xfs_scrub	*sc)
 {
 	sc->flags |= XCHK_REAPING_DISABLED;
-	xfs_stop_block_reaping(sc->mp);
+	xfs_blockgc_stop(sc->mp);
 }
 
 /* Restart background reaping of resources. */
@@ -917,6 +917,6 @@ void
 xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
-	xfs_start_block_reaping(sc->mp);
+	xfs_blockgc_start(sc->mp);
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b930ce69e055..622fdd747099 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1013,6 +1013,22 @@ xfs_blockgc_worker(
 	xfs_queue_blockgc(mp);
 }
 
+/* Disable post-EOF and CoW block auto-reclamation. */
+void
+xfs_blockgc_stop(
+	struct xfs_mount	*mp)
+{
+	cancel_delayed_work_sync(&mp->m_blockgc_work);
+}
+
+/* Enable post-EOF and CoW block auto-reclamation. */
+void
+xfs_blockgc_start(
+	struct xfs_mount	*mp)
+{
+	xfs_queue_blockgc(mp);
+}
+
 /*
  * Grab the inode for reclaim exclusively.
  * Return 0 if we grabbed it, non-zero otherwise.
@@ -1833,19 +1849,3 @@ xfs_inode_clear_cowblocks_tag(
 	trace_xfs_inode_clear_cowblocks_tag(ip);
 	return __xfs_inode_clear_blocks_tag(ip, XFS_ICOWBLOCKS);
 }
-
-/* Disable post-EOF and CoW block auto-reclamation. */
-void
-xfs_stop_block_reaping(
-	struct xfs_mount	*mp)
-{
-	cancel_delayed_work_sync(&mp->m_blockgc_work);
-}
-
-/* Enable post-EOF and CoW block auto-reclamation. */
-void
-xfs_start_block_reaping(
-	struct xfs_mount	*mp)
-{
-	xfs_queue_blockgc(mp);
-}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index b155cffb9d77..ee4e05b59afb 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -76,7 +76,7 @@ int xfs_ici_walk_all(struct xfs_mount *mp,
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
-void xfs_stop_block_reaping(struct xfs_mount *mp);
-void xfs_start_block_reaping(struct xfs_mount *mp);
+void xfs_blockgc_stop(struct xfs_mount *mp);
+void xfs_blockgc_start(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8c068d5e54cb..626c62bbe8d6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1055,7 +1055,7 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1092ee25a148..e734a2a663ac 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -915,7 +915,7 @@ xfs_fs_freeze(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
 	return xfs_sync_sb(mp, true);
@@ -929,7 +929,7 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-	xfs_start_block_reaping(mp);
+	xfs_blockgc_start(mp);
 	return 0;
 }
 
@@ -1619,7 +1619,7 @@ xfs_remount_rw(
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
 	}
-	xfs_start_block_reaping(mp);
+	xfs_blockgc_start(mp);
 
 	/* Create the per-AG metadata reservation pool .*/
 	error = xfs_fs_reserve_ag_blocks(mp);
@@ -1639,7 +1639,7 @@ xfs_remount_ro(
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
 	 */
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 
 	/* Get rid of any leftover CoW reservations... */
 	error = xfs_icache_free_cowblocks(mp, NULL);

