Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 071377CAF
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 16:51:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66B14AC001
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:26 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id sa9GO2JuQYhbgXLh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:24 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bbaeJ-0002Tb-AP
	for xfs@oss.sgi.com; Sun, 21 Aug 2016 21:51:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] xfs: make xfs_inode_set_eofblocks_tag cheaper for the
	common case
Date: Sun, 21 Aug 2016 23:51:12 +0200
Message-Id: <1471816273-28940-4-git-send-email-hch@lst.de>
In-Reply-To: <1471816273-28940-1-git-send-email-hch@lst.de>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

For long growing file writes we will usually already have the eofblocks
tag set when adding more speculative preallocations.  Add a flag in the
inode to allow us to skip the the fairly expensive AG-wide spinlocks
and multiple radix tree operations in that case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 14 ++++++++++++++
 fs/xfs/xfs_inode.h  |  1 +
 2 files changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index fb39a66..65b2e3f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1414,6 +1414,16 @@ xfs_inode_set_eofblocks_tag(
 	struct xfs_perag *pag;
 	int tagged;
 
+	/*
+	 * Don't bother locking the AG and looking up in the radix trees
+	 * if we already know that we have the tag set.
+	 */
+	if (ip->i_flags & XFS_IEOFBLOCKS)
+		return;
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags |= XFS_IEOFBLOCKS;
+	spin_unlock(&ip->i_flags_lock);
+
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 	trace_xfs_inode_set_eofblocks_tag(ip);
@@ -1449,6 +1459,10 @@ xfs_inode_clear_eofblocks_tag(
 	struct xfs_mount *mp = ip->i_mount;
 	struct xfs_perag *pag;
 
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags &= ~XFS_IEOFBLOCKS;
+	spin_unlock(&ip->i_flags_lock);
+
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 	trace_xfs_inode_clear_eofblocks_tag(ip);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e1a411e..8f30d25 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -216,6 +216,7 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
 #define XFS_IDONTCACHE		(1 << 9) /* don't cache the inode long term */
+#define XFS_IEOFBLOCKS		(1 << 10)/* has the preallocblocks tag set */
 
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
