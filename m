Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B4A97F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 14:15:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9538AC004
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 12:15:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BD6alBtu7RFEAzJG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 12:15:05 -0800 (PST)
Message-ID: <54F61641.1010708@redhat.com>
Date: Tue, 03 Mar 2015 14:14:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: don't release NULL pip in xfs_filestream_lookup_ag()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Adrien Nader <adrien@notk.org>

If xfs_filestream_get_parent() fails, we have a null pip,
goto out, and attempt to IRELE(NULL).  This causes a null
pointer dereference and BUG().

Fix this by testing for pip before trying to release it.

Reported-by: Adrien Nader <adrien@notk.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index a2e86e8..fb09a63 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -348,7 +348,8 @@ xfs_filestream_lookup_ag(
 	if (xfs_filestream_pick_ag(pip, startag, &ag, 0, 0))
 		ag = NULLAGNUMBER;
 out:
-	IRELE(pip);
+	if (pip)
+		IRELE(pip);
 	return ag;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
