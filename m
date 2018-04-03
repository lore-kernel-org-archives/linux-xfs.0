Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753645AbeDCWTz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Apr 2018 18:19:55 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AFDF0C057EC3
        for <linux-xfs@vger.kernel.org>; Tue,  3 Apr 2018 22:19:55 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86AE867F17
        for <linux-xfs@vger.kernel.org>; Tue,  3 Apr 2018 22:19:55 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: factor out xfs_dquot_verify_crc for use in quotacheck
 rebuild
Message-ID: <42e7adc1-9fa5-e606-000e-f8a89494c97c@redhat.com>
Date: Tue, 3 Apr 2018 17:19:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Today, if a quota block has a bad UUID or CRC, it will never get
rebuilt or repaired.

xfs_repair does not check or validate quota blocks, leaving that task
to in-kernel quotacheck.  In-kernel quotacheck does not validate the
UUID or CRC.  So the problem remains indefinitely.

To remedy this:

* Factor out xfs_dquot_verify_crc from xfs_dquot_buf_verify_crc
* Call this new function from xfs_qm_reset_dqcounts for V5 fs

If an invalid UUID or CRC is found, this will trigger xfs_dquot_repair
which rewrites them.

Also, since xfs_dquot_repair() operates on the disk block, just
send that in directly since we have it handy.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

djwong: It's not clear to me if I should be using a failaddr_t here,
it's not used directly at all.  Is it anything you need for scrub or
should I change it to return a bool?

And for that matter, do we /need/ to have a separate CRC validating routine?
I've kind of lost the thread on when we need a distinct failaddr (for
EFSBADCRC  vs. EFSCORRUPTED for example...)

I think that in i.e. log replay we aren't validating crc or uuid either,
so I'm wondering if I need to explicitly break this out in all those
places, or if I could just bury the crc/uuid check in xfs_dquot_verify()
and get it for free ...

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 8b7a6c3..267519b 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -39,6 +39,21 @@
 	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
 }
 
+xfs_failaddr_t
+xfs_dquot_verify_crc(
+	struct xfs_mount	*mp,
+	struct xfs_dqblk	*d)
+{
+
+	if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
+			 XFS_DQUOT_CRC_OFF))
+		return __this_address;
+	if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
+		return __this_address;
+
+	return NULL;
+}
+
 /*
  * Do some primitive error checking on ondisk dquot data structures.
  */
@@ -105,13 +120,10 @@
 int
 xfs_dquot_repair(
 	struct xfs_mount	*mp,
-	struct xfs_disk_dquot	*ddq,
+	struct xfs_dqblk	*d,
 	xfs_dqid_t		id,
 	uint			type)
 {
-	struct xfs_dqblk	*d = (struct xfs_dqblk *)ddq;
-
-
 	/*
 	 * Typically, a repair is only requested by quotacheck.
 	 */
@@ -138,6 +150,7 @@
 	struct xfs_buf		*bp)
 {
 	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	xfs_failaddr_t		fa;
 	int			ndquots;
 	int			i;
 
@@ -155,10 +168,8 @@
 		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
 
 	for (i = 0; i < ndquots; i++, d++) {
-		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
-				 XFS_DQUOT_CRC_OFF))
-			return false;
-		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
+		fa = xfs_dquot_verify_crc(mp, d);
+		if (fa)
 			return false;
 	}
 	return true;
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index bb1b13a..413ee9b 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -151,11 +151,13 @@
 		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
+extern xfs_failaddr_t xfs_dquot_verify_crc(struct xfs_mount *mp,
+		struct xfs_dqblk *d);
 extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
 		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type,
 		uint flags);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
-extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
+extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_dqblk *d,
 		xfs_dqid_t id, uint type);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5b848f4..19f63d1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -842,7 +842,7 @@ struct xfs_qm_isolate {
 {
 	struct xfs_dqblk	*dqb;
 	int			j;
-	xfs_failaddr_t		fa;
+	xfs_failaddr_t		fa = NULL;
 
 	trace_xfs_reset_dqcounts(bp, _RET_IP_);
 
@@ -867,10 +867,12 @@ struct xfs_qm_isolate {
 		 * find uninitialised dquot blks. See comment in
 		 * xfs_dquot_verify.
 		 */
-		fa = xfs_dquot_verify(mp, ddq, id + j, type, 0);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			fa = xfs_dquot_verify_crc(mp, &dqb[j]);
+		if (!fa)
+			fa = xfs_dquot_verify(mp, ddq, id + j, type, 0);
 		if (fa)
-			xfs_dquot_repair(mp, ddq, id + j, type);
-
+			xfs_dquot_repair(mp, dqb, id + j, type);
 		/*
 		 * Reset type in case we are reusing group quota file for
 		 * project quotas or vice versa

