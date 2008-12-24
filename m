Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBONJej7031357 for <xfs@oss.sgi.com>; Wed, 24 Dec 2008 17:19:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F7981788B26
	for <xfs@oss.sgi.com>; Wed, 24 Dec 2008 15:19:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3ffXSDH5kZAtXQzK for
	<xfs@oss.sgi.com>; Wed, 24 Dec 2008 15:19:33 -0800 (PST)
Date: Wed, 24 Dec 2008 18:19:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfs_repair: allow filesystems with a single AG
Message-ID: <20081224231901.GA652@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

Currently xfs_repair bails out on a filesystem with just a single AG.
But that's a perfectly valid configureation, so we should allow it.

Skip the geomery validation because we simply can't do it if we don't
have a secondary SB, and make sure to take the internal log into account
when guestimating the first inode cluster.

I'll also cook up a testcase for repair on single AG filesystems.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-By: Arkadiusz Miskiewicz <arekm@maven.pl>

Index: xfsprogs/repair/sb.c
===================================================================
--- xfsprogs.orig/repair/sb.c	2008-12-24 23:36:29.946033933 +0100
+++ xfsprogs/repair/sb.c	2008-12-24 23:42:08.101044710 +0100
@@ -773,14 +773,17 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 		break;
 	case 1:
 		/*
-		 * just report the geometry info and get out.
-		 * refuse to run further unless the force (-F)
-		 * option is in effect.
+		 * If we only have a single allocation group there is no
+		 * secondary superblock that we can use to verify the geometry
+		 * information.  Not much we can do here, as we don't want
+		 * to prevent the user from checking the filesystem.
+		 *
+		 * XXX(hch): We should allow putting a secondary superblock
+		 *	     into the last sector of a filesystem to so that
+		 *	     we can still have a backup for single allocation
+		 *	     group filesystems.
 		 */
-		if (!force_geo)  {
-			do_warn(_("Only one AG detected - cannot proceed.\n"));
-			exit(1);
-		}
+		break;
 	default:
 		/*
 		 * at least half of the probed superblocks have
Index: xfsprogs/repair/xfs_repair.c
===================================================================
--- xfsprogs.orig/repair/xfs_repair.c	2008-12-25 00:00:09.116033372 +0100
+++ xfsprogs/repair/xfs_repair.c	2008-12-25 00:07:50.295036179 +0100
@@ -409,6 +409,19 @@ calc_mkfs(xfs_mount_t *mp)
 	fino_bno = inobt_root + XFS_MIN_FREELIST_RAW(1, 1, mp) + 1;
 
 	/*
+	 * If we only have a single allocation group the log is also allocated
+	 * in the first allocation group and we need to add the number of
+	 * blocks used by the log to the above calculation.
+	 * All this of course doesn't apply if we have an external log.
+	 */
+	if (mp->m_sb.sb_agcount == 1 && mp->m_sb.sb_logstart) {
+		/*
+		 * XXX(hch): verify that sb_logstart makes sense?
+		 */
+		 fino_bno += mp->m_sb.sb_logblocks;
+	}
+
+	/*
 	 * ditto the location of the first inode chunks in the fs ('/')
 	 */
 	if (xfs_sb_version_hasdalign(&mp->m_sb) && do_inoalign)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
