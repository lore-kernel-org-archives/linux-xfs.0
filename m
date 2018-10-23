Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45062 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbeJWMaW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 08:30:22 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 77F51B6A
        for <linux-xfs@vger.kernel.org>; Mon, 22 Oct 2018 23:08:17 -0500 (CDT)
Subject: [PATCH 2/2] xfs_repair: continue after xfs_bunmapi deadlock avoidance
From: Eric Sandeen <sandeen@sandeen.net>
References: <9070c949-2720-75ea-01c3-74261bf62f87@sandeen.net>
Message-ID: <18102abe-0101-bd08-dc5b-2f288dc0d8d3@sandeen.net>
Date: Mon, 22 Oct 2018 23:08:49 -0500
MIME-Version: 1.0
In-Reply-To: <9070c949-2720-75ea-01c3-74261bf62f87@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

After commit:

15a8bcc xfs: fix multi-AG deadlock in xfs_bunmapi

xfs_bunmapi can legitimately return before all work is done.
Sadly nobody told xfs_repair, so it fires an assert:

 phase6.c:1410: longform_dir2_rebuild: Assertion `done' failed. 

Fix this by calling back in until all work is done, as we do
in the kernel.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1641116
Reported-by: Tomasz Torcz <tomek@pipebreaker.pl>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index e017326..b87c751 100644
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
@@ -1352,12 +1352,25 @@ longform_dir2_rebuild(
 			error);
 
 	/* free all data, leaf, node and freespace blocks */
-	error = -libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA, 0,
-				&done);
-	if (error) {
-		do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
-		goto out_bmap_cancel;
-	}
+	while (!done) {
+	       error = -libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA,
+			               0, &done);
+	       if (error) {
+		       do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
+		       goto out_bmap_cancel;
+	       }
+	       error = xfs_defer_finish(&tp);
+	       if (error) {
+		       do_warn(("defer_finish failed -- error - %d\n"), error);
+		       goto out_bmap_cancel;
+	       }
+	       /*
+		* Close out trans and start the next one in the chain.
+		*/
+	       error = xfs_trans_roll_inode(&tp, ip);
+	       if (error)
+			goto out_bmap_cancel;
+        }
 
 	ASSERT(done);
 
