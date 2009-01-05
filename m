Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n05KJhTE016718 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 14:19:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9514517A8DD9
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 12:19:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yREe4xw18JfcV8xU for
	<xfs@oss.sgi.com>; Mon, 05 Jan 2009 12:19:43 -0800 (PST)
Date: Mon, 5 Jan 2009 15:19:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs_repair: allow filesystems with a single allocation group
Message-ID: <20090105201942.GA6960@infradead.org>
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
To: xfs@oss.sgi.com

Currently xfs_repair bails out on a filesystem with just a single AG.
But that's a perfectly valid configureation, so we should allow it.

Because we could cause harm only allow it when using the force_geometry
suboption.  But we nice enough to tell the user about it when he needs it.

Also make sure to take the internal log into account when guestimating the
first inode cluster offset.

I'll also cook up a testcase for repair on single AG filesystems.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-By: Arkadiusz Miskiewicz <arekm@maven.pl>

Index: xfsprogs-dev/repair/sb.c
===================================================================
--- xfsprogs-dev.orig/repair/sb.c	2009-01-03 21:57:42.415546683 +0100
+++ xfsprogs-dev/repair/sb.c	2009-01-05 21:19:01.706752325 +0100
@@ -760,27 +760,37 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 	switch (num_sbs)  {
 	case 2:
 		/*
-		 * all them have to be right.  if not, report geometry
-		 * and get out unless force option is in effect (-F)
+		 * If we only have two allocation groups, and the superblock
+		 * in the second allocation group differs from the primary
+		 * superblock we can't verify the geometry information.
+		 * Warn the user about this situation and get out unless
+		 * explicitly overridden.
 		 */
 		if (current->refs != 2)  {
 			if (!force_geo)  {
 				do_warn(
-	_("Only two AGs detected and they do not match - cannot proceed.\n"));
+	_("Only two AGs detected and they do not match - "
+	  "cannot validate filesystem geometry.\n"
+	  "Use the -o force_geometry option to proceed.\n"));
 				exit(1);
 			}
 		}
-		break;
+		goto out_free_list;
 	case 1:
 		/*
-		 * just report the geometry info and get out.
-		 * refuse to run further unless the force (-F)
-		 * option is in effect.
+		 * If we only have a single allocation group there is no
+		 * secondary superblock that we can use to verify the geometry
+		 * information.  Warn the user about this situation and get
+		 * out unless explicitly overridden.
 		 */
 		if (!force_geo)  {
-			do_warn(_("Only one AG detected - cannot proceed.\n"));
+			do_warn(
+	_("Only one AG detected - "
+	  "cannot validate filesystem geometry.\n"
+	  "Use the -o force_geometry option to proceed.\n"));
 			exit(1);
 		}
+		goto out_free_list;
 	default:
 		/*
 		 * at least half of the probed superblocks have
@@ -820,6 +830,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 		sb_width = sb->sb_width;
 	}
 
+out_free_list:
 	free_geo(list);
 out:
 	free(sb);
Index: xfsprogs-dev/repair/xfs_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/xfs_repair.c	2009-01-03 21:57:42.416547229 +0100
+++ xfsprogs-dev/repair/xfs_repair.c	2009-01-05 20:53:24.810738262 +0100
@@ -62,6 +62,8 @@ char *o_opts[] = {
 	"bhash",
 #define	AG_STRIDE	4
 	"ag_stride",
+#define FORCE_GEO	5
+	"force_geometry",
 	NULL
 };
 
@@ -258,6 +260,13 @@ process_args(int argc, char **argv)
 				case AG_STRIDE:
 					ag_stride = (int)strtol(val, NULL, 0);
 					break;
+				case FORCE_GEO:
+					if (val)
+						noval('o', o_opts, FORCE_GEO);
+					if (force_geo)
+						respec('o', o_opts, FORCE_GEO);
+					force_geo = 1;
+					break;
 				default:
 					unknown('o', val);
 					break;
@@ -409,6 +418,19 @@ calc_mkfs(xfs_mount_t *mp)
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
Index: xfsprogs-dev/man/man8/xfs_repair.8
===================================================================
--- xfsprogs-dev.orig/man/man8/xfs_repair.8	2009-01-05 21:11:50.054546919 +0100
+++ xfsprogs-dev/man/man8/xfs_repair.8	2009-01-05 21:14:49.228027165 +0100
@@ -146,6 +146,15 @@ RAM size.
 This creates additional processing threads to parallel process
 AGs that span multiple concat units. This can significantly
 reduce repair times on concat based filesystems.
+.TP
+.BI force_geometry
+Check the filesystem even if geometry information could not be validate.
+Geometry information can not be validated if there is only a single
+allocation group exists and thus no backups superblock exists, or
+if there are two allocation groups and the two superblocks do not
+agree on the filesystem geometry.  Only use this option if you validated
+the geometry yourself and know what your doing.  In doubt do a run
+in no modify mode first.
 .RE
 .TP
 .B \-t " interval"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
