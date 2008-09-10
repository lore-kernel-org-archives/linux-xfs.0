Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Sep 2008 19:47:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8A2lNlO003019
	for <xfs@oss.sgi.com>; Tue, 9 Sep 2008 19:47:23 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F3598B7655
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2008 19:48:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 04k3gmjWrZJyUyCY for <xfs@oss.sgi.com>; Tue, 09 Sep 2008 19:48:50 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 05B53AC358F
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2008 21:48:49 -0500 (CDT)
Message-ID: <48C73592.6050806@sandeen.net>
Date: Tue, 09 Sep 2008 21:48:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] log reasons for mount-time sunit/swidth rejection
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

In xfs_mountfs ....

        /*
         * Check if sb_agblocks is aligned at stripe boundary
         * If sb_agblocks is NOT aligned turn off m_dalign since
         * allocator alignment is within an ag, therefore ag has
         * to be aligned at stripe boundary.
         */
        update_flags = 0LL;
        if (mp->m_dalign && !(mfsi_flags & XFS_MFSI_SECOND)) {
                /*
                 * If stripe unit and stripe width are not multiples
                 * of the fs blocksize turn off alignment.
                 */
                if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
                    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
                        if (mp->m_flags & XFS_MOUNT_RETERR) {
                                cmn_err(CE_WARN,
                                        "XFS: alignment check 1 failed");
                                error = XFS_ERROR(EINVAL);
                                goto error1;
                        }

^^^^ here we fail with an oh-so-helpful warning

                        mp->m_dalign = mp->m_swidth = 0;
                } else {
                        /*
                         * Convert the stripe unit and width to FSBs.
                         */
                        mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
                        if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
                                if (mp->m_flags & XFS_MOUNT_RETERR) {
                                        error = XFS_ERROR(EINVAL);
                                        goto error1;
                                }

^^^ here we fail with no message from mount whatsoever!

                                xfs_fs_cmn_err(CE_WARN, mp,
"stripe alignment turned off: sunit(%d)/swidth(%d) incompatible with agsize(%d)",
                                        mp->m_dalign, mp->m_swidth,
                                        sbp->sb_agblocks);

                                mp->m_dalign = 0;
                                mp->m_swidth = 0;
                        } else if (mp->m_dalign) {
                                mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
                        } else {
                                if (mp->m_flags & XFS_MOUNT_RETERR) {
                                        xfs_fs_cmn_err(CE_WARN, mp,
"stripe alignment turned off: sunit(%d) less than bsize(%d)",
                                                mp->m_dalign,
                                                mp->m_blockmask +1);
                                        error = XFS_ERROR(EINVAL);
                                        goto error1;
                                }

^^^ here we fail with a misleading message (it's not turned off; it's a failure
and we return as such).

                                mp->m_swidth = 0;
                        }
                }

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=1.342;r2=1.343

Did that commit just misplace one of the error messages?

I'm thinking that we should certainly printk a message in all cases, and the 
"turned off" messages should only come if !XFS_MOUNT_RETERR; something like this?
(might want to clean up messages or cmn_err vs. xfs_fs_cmn_err or whatnot,
but you get the idea ....

-----------------------------------

XFS: log reasons for mount-time sunit/swidth rejection

When mount-time sunit/swidth are deemed incompatible with fs
geometry, leave a message in the logs rather than failing
silently.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


Index: linux-2.6.26.x86_64/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.26.x86_64.orig/fs/xfs/xfs_mount.c
+++ linux-2.6.26.x86_64/fs/xfs/xfs_mount.c
@@ -745,11 +745,13 @@ xfs_update_alignment(xfs_mount_t *mp, in
 		 */
 		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
 		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
-			if (mp->m_flags & XFS_MOUNT_RETERR) {
-				cmn_err(CE_WARN,
-					"XFS: alignment check 1 failed");
+			cmn_err(CE_WARN,
+				"XFS: sunit (%d) or swidth (%d) not "
+				"blocksize (%d) multiples",
+				mp->m_dalign, mp->m_swidth,
+				mp->m_blockmask +1);
+			if (mp->m_flags & XFS_MOUNT_RETERR)
 				return XFS_ERROR(EINVAL);
-			}
 			mp->m_dalign = mp->m_swidth = 0;
 		} else {
 			/*
@@ -757,28 +759,26 @@ xfs_update_alignment(xfs_mount_t *mp, in
 			 */
 			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
 			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
-				if (mp->m_flags & XFS_MOUNT_RETERR) {
-					return XFS_ERROR(EINVAL);
-				}
 				xfs_fs_cmn_err(CE_WARN, mp,
-"stripe alignment turned off: sunit(%d)/swidth(%d) incompatible with agsize(%d)",
-					mp->m_dalign, mp->m_swidth,
-					sbp->sb_agblocks);
-
+					"agsize (%d) not multiple of sunit (%d)",
+					sbp->sb_agblocks, mp->m_dalign);
+				if (mp->m_flags & XFS_MOUNT_RETERR)
+					return XFS_ERROR(EINVAL);
 				mp->m_dalign = 0;
 				mp->m_swidth = 0;
 			} else if (mp->m_dalign) {
 				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 			} else {
-				if (mp->m_flags & XFS_MOUNT_RETERR) {
-					xfs_fs_cmn_err(CE_WARN, mp,
-"stripe alignment turned off: sunit(%d) less than bsize(%d)",
-                                        	mp->m_dalign,
-						mp->m_blockmask +1);
+				xfs_fs_cmn_err(CE_WARN, mp,
+					"sunit (%d) less than bsize (%d)",
+                                       	mp->m_dalign, mp->m_blockmask +1);
+				if (mp->m_flags & XFS_MOUNT_RETERR)
 					return XFS_ERROR(EINVAL);
-				}
 				mp->m_swidth = 0;
 			}
+			if (mp->m_dalign == 0 && mp->m_swidth == 0)
+				xfs_fs_cmn_err(CE_WARN, mp,
+					"stripe aligment turned off.");
 		}
 
 		/*
