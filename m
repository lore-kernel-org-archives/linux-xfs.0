Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42714 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:24:45 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LOiCK015335
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52LOi21005383
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:44 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52LOh74028405
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:44 GMT
Subject: [PATCH 07/13] xfs: check if an inode is cached and allocated
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:24:43 -0700
Message-ID: <149643868294.23065.8094890990886436794.stgit@birch.djwong.org>
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the inode cache for a particular inode number.  If it's in the
cache, check that it's not currently being reclaimed.  If it's not being
reclaimed, return zero if the inode is allocated.  This function will be
used by various scrubbers to decide if the cache is more up to date
than the disk in terms of checking if an inode is allocated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h |    3 ++
 2 files changed, 86 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f61c84f8..d610a7e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -633,6 +633,89 @@ xfs_iget(
 }
 
 /*
+ * "Is this a cached inode that's also allocated?"
+ *
+ * Look up an inode by number in the given file system.  If the inode is
+ * in cache and isn't in purgatory, return 1 if the inode is allocated
+ * and 0 if it is not.  For all other cases (not in cache, being torn
+ * down, etc.), return a negative error code.
+ *
+ * (The caller has to prevent inode allocation activity.)
+ */
+int
+xfs_icache_inode_is_allocated(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	bool			*inuse)
+{
+	struct xfs_inode	*ip;
+	struct xfs_perag	*pag;
+	xfs_agino_t		agino;
+	int			ret = 0;
+
+	/* reject inode numbers outside existing AGs */
+	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+
+	/* get the perag structure and ensure that it's inode capable */
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
+	agino = XFS_INO_TO_AGINO(mp, ino);
+
+	rcu_read_lock();
+	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
+	if (!ip) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	/*
+	 * Is the inode being reused?  Is it new?  Is it being
+	 * reclaimed?  Is it being torn down?  For any of those cases,
+	 * fall back.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (ip->i_ino != ino ||
+	    (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_IRECLAIMABLE))) {
+		ret = -EAGAIN;
+		goto out_istate;
+	}
+
+	/*
+	 * If lookup is racing with unlink, jump out immediately.
+	 */
+	if (VFS_I(ip)->i_mode == 0) {
+		*inuse = false;
+		ret = 0;
+		goto out_istate;
+	}
+
+	/* If the VFS inode is being torn down, forget it. */
+	if (!igrab(VFS_I(ip))) {
+		ret = -EAGAIN;
+		goto out_istate;
+	}
+
+	/* We've got a live one. */
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
+	xfs_perag_put(pag);
+
+	*inuse = !!(VFS_I(ip)->i_mode);
+	ret = 0;
+	IRELE(ip);
+
+	return ret;
+
+out_istate:
+	spin_unlock(&ip->i_flags_lock);
+out:
+	rcu_read_unlock();
+	xfs_perag_put(pag);
+	return ret;
+}
+
+/*
  * The inode lookup is done in batches to keep the amount of lock traffic and
  * radix tree lookups to a minimum. The batch size is a trade off between
  * lookup reduction and stack usage. This is in the reclaim path, so we can't
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 9183f77..eadf718 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -126,4 +126,7 @@ xfs_fs_eofblocks_from_user(
 	return 0;
 }
 
+int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
+				  xfs_ino_t ino, bool *inuse);
+
 #endif

