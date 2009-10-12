Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9CNbR5M061723 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 18:37:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECE29C17D7D
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 16:38:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EN1bkuwTPbR9SZ5j for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 16:38:56 -0700 (PDT)
Date: Mon, 12 Oct 2009 19:38:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091012233854.GA29446@infradead.org>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AD18C8D.90808@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Sun, Oct 11, 2009 at 09:43:09AM +0200, Patrick Schreurs wrote:
> Hello Christoph,
>
> Attached you'll find a screenshot from a 2.6.31.3 server, which includes  
> your patches and has XFS_DEBUG turned on. I truly hope this is useful to  
> you.

Thanks.  The patch below should fix the inode reclaim race that could
lead to the double free you're seeing.  To be applied ontop of all
the other patches I sent you.

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-10-11 19:09:43.828254119 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-10-12 13:48:14.886006087 +0200
@@ -670,22 +670,22 @@ xfs_reclaim_inode(
 {
 	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
 
-	/* The hash lock here protects a thread in xfs_iget_core from
-	 * racing with us on linking the inode back with a vnode.
-	 * Once we have the XFS_IRECLAIM flag set it will not touch
-	 * us.
+	/*
+	 * The hash lock here protects a thread in xfs_iget from racing with
+	 * us on recycling the inode.  Once we have the XFS_IRECLAIM flag set
+	 * it will not touch it.
 	 */
-	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
-	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
-	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
+	ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
 		spin_unlock(&ip->i_flags_lock);
 		write_unlock(&pag->pag_ici_lock);
-		return -EAGAIN;
+		return 0;
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
 	write_unlock(&pag->pag_ici_lock);
+
 	xfs_put_perag(ip->i_mount, pag);
 
 	/*
@@ -758,27 +758,107 @@ __xfs_inode_clear_reclaim_tag(
 			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
 }
 
-STATIC int
-xfs_reclaim_inode_now(
-	struct xfs_inode	*ip,
+STATIC xfs_inode_t *
+xfs_reclaim_ag_lookup(
+	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
+	uint32_t		*first_index)
+{
+	int			nr_found;
+	struct xfs_inode	*ip;
+
+	/*
+	 * use a gang lookup to find the next inode in the tree
+	 * as the tree is sparse and a gang lookup walks to find
+	 * the number of objects requested.
+	 */
+	write_lock(&pag->pag_ici_lock);
+	nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+			(void **)&ip, *first_index, 1, XFS_ICI_RECLAIM_TAG);
+	if (!nr_found)
+		goto unlock;
+
+	/*
+	 * Update the index for the next lookup. Catch overflows
+	 * into the next AG range which can occur if we have inodes
+	 * in the last block of the AG and we are currently
+	 * pointing to the last inode.
+	 */
+	*first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+	if (*first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+		goto unlock;
+
+	return ip;
+
+unlock:
+	write_unlock(&pag->pag_ici_lock);
+	return NULL;
+}
+
+STATIC int
+xfs_reclaim_ag_walk(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		ag,
 	int			flags)
 {
-	/* ignore if already under reclaim */
-	if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-		read_unlock(&pag->pag_ici_lock);
-		return 0;
+	struct xfs_perag	*pag = &mp->m_perag[ag];
+	uint32_t		first_index;
+	int			last_error = 0;
+	int			skipped;
+
+restart:
+	skipped = 0;
+	first_index = 0;
+	do {
+		int		error = 0;
+		xfs_inode_t	*ip;
+
+		ip = xfs_reclaim_ag_lookup(mp, pag, &first_index);
+		if (!ip)
+			break;
+
+		error = xfs_reclaim_inode(ip, flags);
+		if (error == EAGAIN) {
+			skipped++;
+			continue;
+		}
+		if (error)
+			last_error = error;
+		/*
+		 * bail out if the filesystem is corrupted.
+		 */
+		if (error == EFSCORRUPTED)
+			break;
+
+	} while (1);
+
+	if (skipped) {
+		delay(1);
+		goto restart;
 	}
-	read_unlock(&pag->pag_ici_lock);
 
-	return xfs_reclaim_inode(ip, flags);
+	xfs_put_perag(mp, pag);
+	return last_error;
 }
 
 int
 xfs_reclaim_inodes(
-	xfs_mount_t	*mp,
-	int		mode)
+	xfs_mount_t		*mp,
+	int			mode)
 {
-	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode_now, mode,
-					XFS_ICI_RECLAIM_TAG);
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		ag;
+
+	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
+		if (!mp->m_perag[ag].pag_ici_init)
+			continue;
+		error = xfs_reclaim_ag_walk(mp, ag, mode);
+		if (error) {
+			last_error = error;
+			if (error == EFSCORRUPTED)
+				break;
+		}
+	}
+	return XFS_ERROR(last_error);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
