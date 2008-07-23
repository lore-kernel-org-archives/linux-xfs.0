Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 07:29:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NET58w014093
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 07:29:05 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE5A4319A6E
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 07:30:14 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id QYvCR65D1KbqByIf for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 07:30:14 -0700 (PDT)
Date: Thu, 24 Jul 2008 00:30:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] XFS: replace the mount inode list with radix tree
	traversals V2
Message-ID: <20080723143009.GM6761@disturbed>
References: <1216773673-3620-1-git-send-email-david@fromorbit.com> <20080723071748.GA25807@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723071748.GA25807@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 03:17:48AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 23, 2008 at 10:41:09AM +1000, Dave Chinner wrote:
> > The list of all inodes on a mount is superfluous. We can traverse
> > all inodes now by walking the per-AG inode radix trees without
> > needing a separate list. This enables us to remove a bunch of
> > complex list traversal code and remove another two pointers from
> > the xfs_inode.
> > 
> > Also, by replacing the sync traversal with an ascending inode
> > number traversal, we will issue better inode I/O patterns for
> > writeback triggered by xfssyncd or unmount.
> 
> All patches looks good to me.  Well, minus the xfsidbg issue in 4
> which would be a merge blocker for that patch.

Compile tested version of the xfsidbg code. I have no kdb enabled
machines to test it on, so this is as good as I can do right
now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


Kill the idbg users of the mount inode list and
replace with radix tree walks.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfsidbg.c |  124 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 76 insertions(+), 48 deletions(-)

Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-07-24 00:20:26.886167169 +1000
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-07-24 00:20:39.950162171 +1000
@@ -5734,20 +5734,27 @@ xfsidbg_xiclogtrace(xlog_in_core_t *iclo
 static void
 xfsidbg_xinodes(xfs_mount_t *mp)
 {
-	xfs_inode_t	*ip;
+	int		i;
 
 	kdb_printf("xfs_mount at 0x%p\n", mp);
-	ip = mp->m_inodes;
-	if (ip != NULL) {
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		xfs_perag_t	*pag = &mp->m_perag[i];
+		xfs_inode_t	*ip = NULL;
+		int		first_index = 0;
+		int		nr_found;
+
+		if (!pag->pag_ici_init)
+			continue;
 		do {
-			if (ip->i_mount == NULL) {
-				ip = ip->i_mnext;
-				continue;
-			}
+			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+						(void**)&ip, first_index, 1);
+			if (!nr_found)
+				break;
+			/* update the index for the next lookup */
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			kdb_printf("\n");
 			xfsidbg_xnode(ip);
-			ip = ip->i_mnext;
-		} while (ip != mp->m_inodes);
+		} while (nr_found);
 	}
 	kdb_printf("\nEnd of Inodes\n");
 }
@@ -5755,23 +5762,30 @@ xfsidbg_xinodes(xfs_mount_t *mp)
 static void
 xfsidbg_delayed_blocks(xfs_mount_t *mp)
 {
-	xfs_inode_t	*ip;
 	unsigned int	total = 0;
 	unsigned int	icount = 0;
+	int		i;
 
-	ip = mp->m_inodes;
-	if (ip != NULL) {
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		xfs_perag_t	*pag = &mp->m_perag[i];
+		xfs_inode_t	*ip = NULL;
+		int		first_index = 0;
+		int		nr_found;
+
+		if (!pag->pag_ici_init)
+			continue;
 		do {
-			if (ip->i_mount == NULL) {
-				ip = ip->i_mnext;
-				continue;
-			}
+			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+						(void**)&ip, first_index, 1);
+			if (!nr_found)
+				break;
+			/* update the index for the next lookup */
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (ip->i_delayed_blks) {
 				total += ip->i_delayed_blks;
 				icount++;
 			}
-			ip = ip->i_mnext;
-		} while (ip != mp->m_inodes);
+		} while (nr_found);
 	}
 	kdb_printf("delayed blocks total: %d in %d inodes\n", total, icount);
 }
@@ -5779,21 +5793,28 @@ xfsidbg_delayed_blocks(xfs_mount_t *mp)
 static void
 xfsidbg_xinodes_quiesce(xfs_mount_t *mp)
 {
-	xfs_inode_t	*ip;
+	int		i;
 
 	kdb_printf("xfs_mount at 0x%p\n", mp);
-	ip = mp->m_inodes;
-	if (ip != NULL) {
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		xfs_perag_t	*pag = &mp->m_perag[i];
+		xfs_inode_t	*ip = NULL;
+		int		first_index = 0;
+		int		nr_found;
+
+		if (!pag->pag_ici_init)
+			continue;
 		do {
-			if (ip->i_mount == NULL) {
-				ip = ip->i_mnext;
-				continue;
-			}
+			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+						(void**)&ip, first_index, 1);
+			if (!nr_found)
+				break;
+			/* update the index for the next lookup */
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (!(ip->i_flags & XFS_IQUIESCE)) {
 				kdb_printf("ip 0x%p not quiesced\n", ip);
 			}
-			ip = ip->i_mnext;
-		} while (ip != mp->m_inodes);
+		} while (nr_found);
 	}
 	kdb_printf("\nEnd of Inodes\n");
 }
@@ -6319,8 +6340,8 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		mp->m_rtdev_targp ? mp->m_rtdev_targp->bt_dev : 0);
 	kdb_printf("bsize %d agfrotor %d xfs_rotorstep %d agirotor %d\n",
 		mp->m_bsize, mp->m_agfrotor, xfs_rotorstep, mp->m_agirotor);
-	kdb_printf("inodes 0x%p ilock 0x%p ireclaims 0x%x\n",
-		mp->m_inodes, &mp->m_ilock, mp->m_ireclaims);
+	kdb_printf("ilock 0x%p ireclaims 0x%x\n",
+		&mp->m_ilock, mp->m_ireclaims);
 	kdb_printf("readio_log 0x%x readio_blocks 0x%x ",
 		mp->m_readio_log, mp->m_readio_blocks);
 	kdb_printf("writeio_log 0x%x writeio_blocks 0x%x\n",
@@ -6409,11 +6430,7 @@ xfsidbg_xnode(xfs_inode_t *ip)
 		NULL
 	};
 
-	kdb_printf("mount 0x%p mnext 0x%p mprev 0x%p vnode 0x%p \n",
-		ip->i_mount,
-		ip->i_mnext,
-		ip->i_mprev,
-		XFS_ITOV_NULL(ip));
+	kdb_printf("mount 0x%p vnode 0x%p \n", ip->i_mount, XFS_ITOV_NULL(ip));
 	kdb_printf("dev %x ino %s\n",
 		ip->i_mount->m_ddev_targp->bt_dev,
 		xfs_fmtino(ip->i_ino, ip->i_mount));
@@ -6614,22 +6631,33 @@ xfsidbg_xqm_dquot(xfs_dquot_t *dqp)
 static void
 xfsidbg_xqm_dqattached_inos(xfs_mount_t	*mp)
 {
-	xfs_inode_t	*ip;
-	int		n = 0;
+	int		i, n = 0;
 
-	ip = mp->m_inodes;
-	do {
-		if (ip->i_mount == NULL) {
-			ip = ip->i_mnext;
+	kdb_printf("xfs_mount at 0x%p\n", mp);
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		xfs_perag_t	*pag = &mp->m_perag[i];
+		xfs_inode_t	*ip = NULL;
+		int		first_index = 0;
+		int		nr_found;
+
+		if (!pag->pag_ici_init)
 			continue;
-		}
-		if (ip->i_udquot || ip->i_gdquot) {
-			n++;
-			kdb_printf("inode = 0x%p, ino %d: udq 0x%p, gdq 0x%p\n",
-				ip, (int)ip->i_ino, ip->i_udquot, ip->i_gdquot);
-		}
-		ip = ip->i_mnext;
-	} while (ip != mp->m_inodes);
+		do {
+			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+						(void**)&ip, first_index, 1);
+			if (!nr_found)
+				break;
+			/* update the index for the next lookup */
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (ip->i_udquot || ip->i_gdquot) {
+				n++;
+				kdb_printf("inode = 0x%p, ino %d: udq 0x%p, gdq 0x%p\n",
+					ip, (int)ip->i_ino, ip->i_udquot, ip->i_gdquot);
+			}
+			kdb_printf("\n");
+			xfsidbg_xnode(ip);
+		} while (nr_found);
+	}
 	kdb_printf("\nNumber of inodes with dquots attached: %d\n", n);
 }
 
