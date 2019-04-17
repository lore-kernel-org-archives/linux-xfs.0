Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38284 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbfDQBkT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:40:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1cSnW097296
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:18 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2rusnewxmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1d2VY109512
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ru4vtgwx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3H1eGTS007261
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:16 GMT
Subject: [PATCH 2/3] xfs: allow scrubbers to pause background reclaim
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Apr 2019 18:40:12 -0700
Message-ID: <155546521227.176278.16067700926705972688.stgit@magnolia>
In-Reply-To: <155546519998.176278.8300210828717055034.stgit@magnolia>
References: <155546519998.176278.8300210828717055034.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The forthcoming summary counter patch races with regular filesystem
activity to compute rough expected values for the counters.  This design
was chosen to avoid having to freeze the entire filesystem to check the
counters, but while that's running we'd prefer to minimize background
reclamation activity to reduce the perturbations to the incore free
block count.  Therefore, provide a way for scrubbers to disable
background posteof and cowblock reclamation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   18 ++++++++++++++++++
 fs/xfs/scrub/common.h |    2 ++
 fs/xfs/scrub/scrub.c  |    2 ++
 fs/xfs/scrub/scrub.h  |    1 +
 4 files changed, 23 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7076d5c98151..a406a22a734f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -894,3 +894,21 @@ xchk_ilock_inverted(
 	}
 	return -EDEADLOCK;
 }
+
+/* Pause background reclamation and inactivation. */
+void
+xchk_disable_reclaim(
+	struct xfs_scrub	*sc)
+{
+	sc->flags |= XCHK_RECLAIM_DISABLED;
+	xfs_icache_disable_reclaim(sc->mp);
+}
+
+/* Unpause background reclamation and inactivation. */
+void
+xchk_enable_reclaim(
+	struct xfs_scrub	*sc)
+{
+	xfs_icache_enable_reclaim(sc->mp);
+	sc->flags &= ~XCHK_RECLAIM_DISABLED;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e26a430bd466..2288f45a5606 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -137,5 +137,7 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
+void xchk_disable_reclaim(struct xfs_scrub *sc);
+void xchk_enable_reclaim(struct xfs_scrub *sc);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 93b0f075a4d3..421c22a0bf39 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -187,6 +187,8 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
+	if (sc->flags & XCHK_RECLAIM_DISABLED)
+		xchk_enable_reclaim(sc);
 	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
 		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
 		sc->flags &= ~XCHK_HAS_QUOTAOFFLOCK;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1b280f8f185a..1f6de7bbb9f5 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -80,6 +80,7 @@ struct xfs_scrub {
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
 #define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
+#define XCHK_RECLAIM_DISABLED	(1 << 2)  /* background reclaim is paused */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 /* Metadata scrubbers */
