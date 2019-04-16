Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfDPATn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 20:19:43 -0400
Subject: [PATCH 1/5] xfs: refactor scrub context initialization
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Apr 2019 17:19:37 -0700
Message-ID: <155537397718.27935.17999873230143153206.stgit@magnolia>
In-Reply-To: <155537397092.27935.16073573221774618735.stgit@magnolia>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

It's a little silly how the memset in scrub context initialization
forces us to declare stack variables to preserve context variables
across a retry.  Since the teardown functions already null out most of
the ephemeral state (buffer pointers, btree cursors, etc.), just skip
the memset and move the initialization as needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/scrub.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1b2344d00525..08df00911dd3 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -186,8 +186,10 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
-	if (sc->has_quotaofflock)
+	if (sc->has_quotaofflock) {
 		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
+		sc->has_quotaofflock = false;
+	}
 	if (sc->buf) {
 		kmem_free(sc->buf);
 		sc->buf = NULL;
@@ -466,9 +468,14 @@ xfs_scrub_metadata(
 	struct xfs_inode		*ip,
 	struct xfs_scrub_metadata	*sm)
 {
-	struct xfs_scrub		sc;
+	struct xfs_scrub		sc = {
+		.mp			= ip->i_mount,
+		.sm			= sm,
+		.sa			= {
+			.agno		= NULLAGNUMBER,
+		},
+	};
 	struct xfs_mount		*mp = ip->i_mount;
-	bool				try_harder = false;
 	bool				already_fixed = false;
 	int				error = 0;
 
@@ -491,21 +498,16 @@ xfs_scrub_metadata(
 
 	xchk_experimental_warning(mp);
 
+	sc.ops = &meta_scrub_ops[sm->sm_type];
 retry_op:
 	/* Set up for the operation. */
-	memset(&sc, 0, sizeof(sc));
-	sc.mp = ip->i_mount;
-	sc.sm = sm;
-	sc.ops = &meta_scrub_ops[sm->sm_type];
-	sc.try_harder = try_harder;
-	sc.sa.agno = NULLAGNUMBER;
 	error = sc.ops->setup(&sc, ip);
 	if (error)
 		goto out_teardown;
 
 	/* Scrub for errors. */
 	error = sc.ops->scrub(&sc);
-	if (!try_harder && error == -EDEADLOCK) {
+	if (!sc.try_harder && error == -EDEADLOCK) {
 		/*
 		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
 		 * Tear down everything we hold, then set up again with
@@ -514,7 +516,7 @@ xfs_scrub_metadata(
 		error = xchk_teardown(&sc, ip, 0);
 		if (error)
 			goto out;
-		try_harder = true;
+		sc.try_harder = true;
 		goto retry_op;
 	} else if (error)
 		goto out_teardown;
@@ -544,8 +546,11 @@ xfs_scrub_metadata(
 		 */
 		error = xrep_attempt(ip, &sc, &already_fixed);
 		if (error == -EAGAIN) {
-			if (sc.try_harder)
-				try_harder = true;
+			/*
+			 * Either the repair function succeeded or it couldn't
+			 * get all the resources it needs; either way, we go
+			 * back to the beginning and call the scrub function.
+			 */
 			error = xchk_teardown(&sc, ip, 0);
 			if (error) {
 				xrep_failure(mp);
