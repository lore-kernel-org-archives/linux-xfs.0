Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27D3429E87
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:10:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E28C48F8070
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:49 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id X9mhXpm44mRz8Bow (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:48 -0800 (PST)
Subject: [PATCH 52/53] libxfs: try to prevent failed rmap btree expansion
	during cow
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:10:44 -0800
Message-ID: <20151219091044.14255.41920.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

It's possible, if reflink and rmap are both enabled, for CoW to create
a lot of small mappings that cause an rmap btree expansion to run out
of space.  If both are enabled, keep the AGFL fully stocked at all
times, refuse to CoW if we start to run out of space in the AGFL, and
hope that's good enough.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c  |    8 ++++++++
 repair/xfs_repair.c |    5 +++++
 2 files changed, 13 insertions(+)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 619e06d..86bc620 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1997,6 +1997,14 @@ xfs_alloc_min_freelist(
 		min_free += min_t(unsigned int,
 				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
 				  mp->m_ag_maxlevels);
+	/*
+	 * The rmapbt can explode if we have reflink enabled and someone
+	 * creates a lot of small mappings... so max out the AGFL to try
+	 * to prevent that.
+	 */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    xfs_sb_version_hasreflink(&mp->m_sb))
+		min_free = XFS_AGFL_SIZE(mp) - min_free;
 
 	return min_free;
 }
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 1d402a5..372c8f8 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -424,6 +424,11 @@ calc_mkfs(xfs_mount_t *mp)
 	}
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		fino_bno++;
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    xfs_sb_version_hasreflink(&mp->m_sb)) {
+		fino_bno = XFS_AGFL_SIZE(mp) + (fino_bno -
+				(6 * min(2, mp->m_ag_maxlevels)));
+	}
 
 	/*
 	 * If the log is allocated in the first allocation group we need to

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
