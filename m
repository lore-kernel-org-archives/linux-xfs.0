Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56060 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbeCVTff (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 15:35:35 -0400
Subject: [PATCH 1.5/4] xfs_repair: use custom ifork verifier in mv_orphanage
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <152151530602.18312.5227395146899805650.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9cf10ff8-878a-b4dc-1e32-c657c0d2354a@sandeen.net>
Date: Thu, 22 Mar 2018 14:35:34 -0500
MIME-Version: 1.0
In-Reply-To: <152151530602.18312.5227395146899805650.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Now that we have a custom verifier which can ignore parent
inode numbers, use it in mv_orphanage() as well; orphan inodes
may have invalid parents, and we're about to reconnect
them anyway, so override that test when we get them off disk.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index ed005e8..498a3b5 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1138,7 +1138,8 @@ mv_orphanage(
 		xname.len = snprintf((char *)fname, sizeof(fname), "%llu.%d",
 					(unsigned long long)ino, ++incr);
 
-	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &xfs_default_ifork_ops);
+	/* Orphans may not have a proper parent, so use custom ops here */
+	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &phase6_ifork_ops);
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 

