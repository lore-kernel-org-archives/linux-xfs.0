Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SIMEW7004128 for <xfs@oss.sgi.com>; Thu, 28 May 2009 13:22:14 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85BC82B8338
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 11:22:27 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id lvH5vcjIIgqD70PG for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 11:22:27 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4SIMRuI020923
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 14:22:27 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4SIMQUW029500
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 14:22:26 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4SIMPsm004414
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 14:22:26 -0400
Message-ID: <4A1ED661.5020202@sandeen.net>
Date: Thu, 28 May 2009 13:22:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove remaining useless if-before-frees
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

Just janitorial work, but this removes the last couple
if-before-frees I could find in xfs with the tool from

http://git.savannah.gnu.org/cgit/gnulib.git/plain/build-aux/useless-if-before-free

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6/fs/xfs/xfs_da_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_da_btree.c
+++ linux-2.6/fs/xfs/xfs_da_btree.c
@@ -2116,9 +2116,7 @@ xfs_da_do_buf(
 			goto exit1;
 		}
 	}
-	if (bplist) {
-		kmem_free(bplist);
-	}
+	kmem_free(bplist);
 	if (mapp != &map) {
 		kmem_free(mapp);
 	}
Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c
+++ linux-2.6/fs/xfs/xfs_mount.c
@@ -211,8 +211,7 @@ xfs_free_perag(
 		int	agno;
 
 		for (agno = 0; agno < mp->m_maxagi; agno++)
-			if (mp->m_perag[agno].pagb_list)
-				kmem_free(mp->m_perag[agno].pagb_list);
+			kmem_free(mp->m_perag[agno].pagb_list);
 		kmem_free(mp->m_perag);
 	}
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
