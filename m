Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55548 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbeECSGC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:06:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w43I1NuW160284
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:02 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2hmeg634m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 03 May 2018 18:06:02 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w43I61qc005386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:01 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w43I608B002641
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:06:01 GMT
Subject: [PATCH 01/12] xfs: bmap debugging should never panic the system
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:05:59 -0700
Message-ID: <152537075974.16676.4678069099698404803.stgit@magnolia>
In-Reply-To: <152537075334.16676.10600900179473864298.stgit@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't panic() the system if the bmap records are garbage, just call
ASSERT which gives us the same backtrace but enables developers to
control if the system goes down or not.  This makes debugging with
generic/388 much easier because it won't reboot the machine midway
through a run just because btree_read_bufl returns EIO when the fs has
already shut down.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a7c2f03ea11..393b4e2c63ad 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -312,8 +312,10 @@ xfs_check_block(
 				xfs_warn(mp, "%s: thispa(%d) == pp(%d) %Ld",
 					__func__, j, i,
 					(unsigned long long)be64_to_cpu(*thispa));
-				panic("%s: ptrs are equal in node\n",
+				xfs_err(mp, "%s: ptrs are equal in node\n",
 					__func__);
+				ASSERT(XFS_FORCED_SHUTDOWN(mp));
+				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 			}
 		}
 	}
@@ -483,7 +485,9 @@ xfs_bmap_check_leaf_extents(
 error_norelse:
 	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
 		__func__, i);
-	panic("%s: CORRUPTED BTREE OR SOMETHING", __func__);
+	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
+	ASSERT(XFS_FORCED_SHUTDOWN(mp));
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	return;
 }
 

