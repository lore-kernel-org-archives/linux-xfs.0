Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59666 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfDKBsg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 21:48:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1hPXF051514
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:48:35 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2rpmrqe2x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:48:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1juFW151707
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2rpkek76h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3B1kXnw013569
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:33 GMT
Subject: [PATCH 2/4] xfs: collapse scrub bool state flags into a single
 unsigned int
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 10 Apr 2019 18:46:31 -0700
Message-ID: <155494719169.1090718.8828591491718849977.stgit@magnolia>
In-Reply-To: <155494717912.1090718.9199703658765720229.stgit@magnolia>
References: <155494717912.1090718.9199703658765720229.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Combine all the boolean state flags in struct xfs_scrub into a single
unsigned int, because we're going to be adding more state flags soon.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    4 ++--
 fs/xfs/scrub/parent.c |    2 +-
 fs/xfs/scrub/quota.c  |    2 +-
 fs/xfs/scrub/repair.c |    4 ++--
 fs/xfs/scrub/scrub.c  |    8 ++++----
 fs/xfs/scrub/scrub.h  |    9 +++++++--
 6 files changed, 17 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 700114f79a7d..693eb51f5efb 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -39,7 +39,7 @@ xchk_setup_ag_iallocbt(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
-	return xchk_setup_ag_btree(sc, ip, sc->try_harder);
+	return xchk_setup_ag_btree(sc, ip, sc->flags & XCHK_TRY_HARDER);
 }
 
 /* Inode btree scrubber. */
@@ -185,7 +185,7 @@ xchk_iallocbt_check_cluster_ifree(
 	if (error == -ENODATA) {
 		/* Not cached, just read the disk buffer */
 		freemask_ok = irec_free ^ !!(dip->di_mode);
-		if (!bs->sc->try_harder && !freemask_ok)
+		if (!(bs->sc->flags & XCHK_TRY_HARDER) && !freemask_ok)
 			return -EDEADLOCK;
 	} else if (error < 0) {
 		/*
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 1c9d7c7f64f5..d5d197f1b80f 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -320,7 +320,7 @@ xchk_parent(
 	 * If we failed to lock the parent inode even after a retry, just mark
 	 * this scrub incomplete and return.
 	 */
-	if (sc->try_harder && error == -EDEADLOCK) {
+	if ((sc->flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
 		error = 0;
 		xchk_set_incomplete(sc);
 	}
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 782d582d3edd..5dfe2b5924db 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -60,7 +60,7 @@ xchk_setup_quota(
 	dqtype = xchk_quota_to_dqtype(sc);
 	if (dqtype == 0)
 		return -EINVAL;
-	sc->has_quotaofflock = true;
+	sc->flags |= XCHK_HAS_QUOTAOFFLOCK;
 	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (!xfs_this_quota_on(sc->mp, dqtype))
 		return -ENOENT;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f28f4bad317b..c093939fe35a 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -71,8 +71,8 @@ xrep_attempt(
 	case -EDEADLOCK:
 	case -EAGAIN:
 		/* Tell the caller to try again having grabbed all the locks. */
-		if (!sc->try_harder) {
-			sc->try_harder = true;
+		if (!(sc->flags & XCHK_TRY_HARDER)) {
+			sc->flags |= XCHK_TRY_HARDER;
 			return -EAGAIN;
 		}
 		/*
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 08df00911dd3..6e18a1178e26 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -186,9 +186,9 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
-	if (sc->has_quotaofflock) {
+	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
 		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
-		sc->has_quotaofflock = false;
+		sc->flags &= ~XCHK_HAS_QUOTAOFFLOCK;
 	}
 	if (sc->buf) {
 		kmem_free(sc->buf);
@@ -507,7 +507,7 @@ xfs_scrub_metadata(
 
 	/* Scrub for errors. */
 	error = sc.ops->scrub(&sc);
-	if (!sc.try_harder && error == -EDEADLOCK) {
+	if (!(sc.flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
 		/*
 		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
 		 * Tear down everything we hold, then set up again with
@@ -516,7 +516,7 @@ xfs_scrub_metadata(
 		error = xchk_teardown(&sc, ip, 0);
 		if (error)
 			goto out;
-		sc.try_harder = true;
+		sc.flags |= XCHK_TRY_HARDER;
 		goto retry_op;
 	} else if (error)
 		goto out_teardown;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 22f754fba8e5..60359e7de930 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -62,13 +62,18 @@ struct xfs_scrub {
 	struct xfs_inode		*ip;
 	void				*buf;
 	uint				ilock_flags;
-	bool				try_harder;
-	bool				has_quotaofflock;
+
+	/* See the XCHK state flags below. */
+	unsigned int			flags;
 
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
 };
 
+/* XCHK state flags */
+#define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
+#define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
