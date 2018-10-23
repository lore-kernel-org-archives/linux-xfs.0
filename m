Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51022 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbeJWWUj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 18:20:39 -0400
Subject: [PATCH 2/2 V2] xfs_repair: continue after xfs_bunmapi deadlock
 avoidance
From: Eric Sandeen <sandeen@sandeen.net>
References: <9070c949-2720-75ea-01c3-74261bf62f87@sandeen.net>
 <18102abe-0101-bd08-dc5b-2f288dc0d8d3@sandeen.net>
Message-ID: <7dbb215e-761d-8a9e-87e8-e285e551b64b@sandeen.net>
Date: Tue, 23 Oct 2018 08:57:03 -0500
MIME-Version: 1.0
In-Reply-To: <18102abe-0101-bd08-dc5b-2f288dc0d8d3@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>

xfs_bunmapi can legitimately return before all work is done, to
avoid deadlocks across AGs.

Sadly nobody told xfs_repair, so it fires an assert if this happens:

 phase6.c:1410: longform_dir2_rebuild: Assertion `done' failed. 

Fix this by calling back in until all work is done, as we do
in the kernel.

Fixes: 5a8bcc ("xfs: fix multi-AG deadlock in xfs_bunmapi")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1641116
Reported-by: Tomasz Torcz <tomek@pipebreaker.pl>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: libxfs-ify the code, remove now-pointless assert, thanks Darrick!


diff --git a/repair/phase6.c b/repair/phase6.c
index e017326..bdbbbaa 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1317,7 +1317,7 @@ longform_dir2_rebuild(
 	xfs_fileoff_t		lastblock;
 	xfs_inode_t		pip;
 	dir_hash_ent_t		*p;
-	int			done;
+	int			done = 0;
 
 	/*
 	 * trash directory completely and rebuild from scratch using the
@@ -1352,14 +1352,25 @@ longform_dir2_rebuild(
 			error);
 
 	/* free all data, leaf, node and freespace blocks */
-	error = -libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA, 0,
-				&done);
-	if (error) {
-		do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
-		goto out_bmap_cancel;
-	}
-
-	ASSERT(done);
+	while (!done) {
+	       error = -libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA,
+			               0, &done);
+	       if (error) {
+		       do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
+		       goto out_bmap_cancel;
+	       }
+	       error = -libxfs_defer_finish(&tp);
+	       if (error) {
+		       do_warn(("defer_finish failed -- error - %d\n"), error);
+		       goto out_bmap_cancel;
+	       }
+	       /*
+		* Close out trans and start the next one in the chain.
+		*/
+	       error = -libxfs_trans_roll_inode(&tp, ip);
+	       if (error)
+			goto out_bmap_cancel;
+        }
 
 	error = -libxfs_dir_init(tp, ip, &pip);
 	if (error) {
