Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7A2477F3F
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 14:12:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 641C6304048
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 12:12:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XKRARZThh7EpsHeK for <xfs@oss.sgi.com>;
	Fri, 11 Oct 2013 12:12:32 -0700 (PDT)
Message-ID: <52584D9F.9000202@sandeen.net>
Date: Fri, 11 Oct 2013 14:12:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/4] xfs: don't emit corruption noise on fs probes
References: <52584C8A.1060808@redhat.com>
In-Reply-To: <52584C8A.1060808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

If we get EWRONGFS due to probing of non-xfs filesystems,
there's no need to issue the scary corruption error and backtrace.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index a5b59d9..d327b2c 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -624,8 +624,9 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     mp, bp->b_addr);
+		if (error != EWRONGFS)
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+					     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
 	}
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
