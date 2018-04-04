Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751231AbeDDTGT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 15:06:19 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC374C03D46B
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 19:06:18 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1EA47F6D9
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 19:06:18 +0000 (UTC)
Subject: [PATCH 4/6] xfs: quieter quota initialization with bad dquots
From: Eric Sandeen <sandeen@redhat.com>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Message-ID: <2ce33875-44dc-539c-50a9-c8808bd4b185@redhat.com>
Date: Wed, 4 Apr 2018 14:06:17 -0500
MIME-Version: 1.0
In-Reply-To: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

As of now, when we start quotacheck we read quotas with verifiers,
then reread without them, if we saw corruption.  This is so the
corruption is noted in the logs; this is all well and good, except that
the verifier errors instruct the user to run xfs_repair, which won't
actually do anything for corrupt dqblks.

We can quiet this down by doing the initial read without verifiers,
knowing that we're going to validate the dqblks manually in later
stages, and repair them if needed.

This adds new (more terse) messages stating whether a corrupted
dquot was found and fixed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I'm a bit on the fence about this one; we lose the hexdump too so we won't
see what was wrong (I could add that back in, I suppose).

 fs/xfs/libxfs/xfs_dquot_buf.c |  4 ++++
 fs/xfs/xfs_qm.c               | 30 +++++++++++++-----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 9f8b2c5..c13d440 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -136,6 +136,10 @@
 				 XFS_DQUOT_CRC_OFF);
 	}
 
+	xfs_alert(mp, "Repaired %s quota block for id %d.",
+		  type == XFS_DQ_USER ? "user" :
+		    (type == XFS_DQ_GROUP ? "group" : "project"), id);
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b422382..328d770 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -868,8 +868,12 @@ struct xfs_qm_isolate {
 		 * xfs_dquot_verify.
 		 */
 		fa = xfs_dquot_verify(mp, &dqb[j], id + j, type);
-		if (fa)
+		if (fa) {
+			xfs_alert(mp,
+"Metadata corruption error detected at %pS, xfs_dquot block 0x%llx.",
+				  __this_address, bp->b_bn);
 			xfs_dquot_repair(mp, &dqb[j], id + j, type);
+		}
 
 		/*
 		 * Reset type in case we are reusing group quota file for
@@ -922,24 +926,16 @@ struct xfs_qm_isolate {
 	 * everything if we were to crash in the middle of this loop.
 	 */
 	while (blkcnt--) {
-		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
-			      XFS_FSB_TO_DADDR(mp, bno),
-			      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
-			      &xfs_dquot_buf_ops);
-
 		/*
-		 * CRC and validation errors will return a EFSCORRUPTED here. If
-		 * this occurs, re-read without CRC validation so that we can
-		 * repair the damage via xfs_qm_reset_dqcounts(). This process
-		 * will leave a trace in the log indicating corruption has
-		 * been detected.
+		 * CRC and validation errors are possible here.  Because
+		 * this may occur, we read without CRC validation so that we can
+		 * repair the damage via xfs_qm_reset_dqcounts().
+		 * Errors will be detected, declared, and repaired later in the
+		 * quotacheck process.
 		 */
-		if (error == -EFSCORRUPTED) {
-			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
-				      XFS_FSB_TO_DADDR(mp, bno),
-				      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
-				      NULL);
-		}
+		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+			      XFS_FSB_TO_DADDR(mp, bno),
+			      mp->m_quotainfo->qi_dqchunklen, 0, &bp, NULL);
 
 		if (error)
 			break;
-- 
1.8.3.1


