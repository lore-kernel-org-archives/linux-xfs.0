Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbeBGByz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Feb 2018 20:54:55 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 730CC83F42
        for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2018 01:54:55 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4163F5EDE6
        for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2018 01:54:55 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove unused m_dmevmask from xfs_mount struct
Message-ID: <e62db8d7-73d8-c47c-cd42-977d24aba0ce@redhat.com>
Date: Tue, 6 Feb 2018 19:54:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The dmevmask structure member is a dmapi leftover; it's
set here and there but never actually used.  Remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 00240c9..1937a93 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5127,16 +5127,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	xfs_agino_t	agino;
 	int		bucket;
 	int		error;
-	uint		mp_dmevmask;
 
 	mp = log->l_mp;
 
-	/*
-	 * Prevent any DMAPI event from being sent while in this function.
-	 */
-	mp_dmevmask = mp->m_dmevmask;
-	mp->m_dmevmask = 0;
-
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		/*
 		 * Find the agi for this ag.
@@ -5172,8 +5165,6 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 		}
 		xfs_buf_rele(agibp);
 	}
-
-	mp->m_dmevmask = mp_dmevmask;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 98fd41c..6f5a5e6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -803,8 +803,6 @@
 		 get_unaligned_be16(&sbp->sb_uuid.b[4]);
 	mp->m_fixedfsid[1] = get_unaligned_be32(&sbp->sb_uuid.b[0]);
 
-	mp->m_dmevmask = 0;	/* not persistent; set after each mount */
-
 	error = xfs_da_mount(mp);
 	if (error) {
 		xfs_warn(mp, "Failed dir/attr init: %d", error);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e0792d0..44a63c5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -138,7 +138,6 @@ struct xfs_error_cfg {
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
-	uint			m_dmevmask;	/* DMI events for this FS */
 	uint64_t		m_flags;	/* global mount flags */
 	bool			m_inotbt_nores; /* no per-AG finobt resv. */
 	int			m_ialloc_inos;	/* inodes in inode allocation */

