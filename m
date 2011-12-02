Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2Hpd4u093067 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:51:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A605C1F3F476
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 09:47:43 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SdG910pZauekD7H7 for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 09:47:43 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RWXD4-0000lo-IW
	for xfs@oss.sgi.com; Fri, 02 Dec 2011 17:47:42 +0000
Message-Id: <20111202174742.515301323@bombadil.infradead.org>
Date: Fri, 02 Dec 2011 12:46:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/12] repair: handle filesystems with the log in allocation
	group 0
References: <20111202174619.179530033@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-fix-geomety-detection
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Sindre Skogen reported that repair chokes on a very small filesystem created
by mkfs.xfs from xfsprogs 2.9.4.  It turned out that for some reason this
filesystem had the log in allocation group 0 and thus repairs validation
of the root inode number was off.  Fix this by adding the log blocks if
the log is allocated in allocation group 0.

Reported-by: Sindre Skogen <sindre@workzone.no>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/xfs_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/xfs_repair.c	2011-12-01 16:17:07.000000000 +0000
+++ xfsprogs-dev/repair/xfs_repair.c	2011-12-01 16:17:58.000000000 +0000
@@ -417,12 +417,16 @@ calc_mkfs(xfs_mount_t *mp)
 	fino_bno = inobt_root + XFS_MIN_FREELIST_RAW(1, 1, mp) + 1;
 
 	/*
-	 * If we only have a single allocation group the log is also allocated
-	 * in the first allocation group and we need to add the number of
-	 * blocks used by the log to the above calculation.
-	 * All this of course doesn't apply if we have an external log.
+	 * If the log is allocated in the first allocation group we need to
+	 * add the number of blocks used by the log to the above calculation.
+	 *
+	 * This can happens with filesystems that only have a single
+	 * allocation group, or very odd geometries created by old mkfs
+	 * versions on very small filesystems.
 	 */
-	if (mp->m_sb.sb_agcount == 1 && mp->m_sb.sb_logstart) {
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0) {
+
 		/*
 		 * XXX(hch): verify that sb_logstart makes sense?
 		 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
