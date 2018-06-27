Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45344 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752213AbeF0CsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 22:48:19 -0400
Subject: [PATCH 03/10] xfs_scrub: destroy workqueues when erroring out
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 Jun 2018 19:48:04 -0700
Message-ID: <153006768447.20121.17161456551475897498.stgit@magnolia>
In-Reply-To: <153006766483.20121.9285982017465570544.stgit@magnolia>
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a couple of code paths that forgot to tear down a workqueue when
erroring out, because if we don't the wq threads keep running even after
we've freed the wq memory.

Found by fuzzing core.nlinkv2=0 in xfs/377, but only because the fs will
shut down when it hits an error destroying the incore (corrupt) inode
after the scrub.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase2.c |    2 +-
 scrub/vfs.c    |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index ad736bf5..7078e38d 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -102,7 +102,7 @@ xfs_scan_metadata(
 	 */
 	moveon = xfs_scrub_primary_super(ctx);
 	if (!moveon)
-		return moveon;
+		goto out;
 
 	for (agno = 0; moveon && agno < ctx->geo.agcount; agno++) {
 		ret = workqueue_add(&wq, xfs_scan_ag_metadata, agno, &moveon);
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 77df2874..12a6a860 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -210,7 +210,7 @@ scan_fs_tree(
 	if (ret) {
 		str_info(ctx, ctx->mntpoint,
 _("Could not queue directory scan work."));
-		goto out_free;
+		goto out_wq;
 	}
 
 	pthread_mutex_lock(&sft.lock);
@@ -220,6 +220,8 @@ _("Could not queue directory scan work."));
 	workqueue_destroy(&wq);
 
 	return sft.moveon;
+out_wq:
+	workqueue_destroy(&wq);
 out_free:
 	free(sftd->path);
 	free(sftd);

