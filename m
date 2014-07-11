Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7EDD67F47
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 18:02:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BF92304039
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 16:02:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7VQhrrg3N4TGRJNF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Jul 2014 16:02:03 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6BN22ac030216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 19:02:02 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6BN20GX026958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 19:02:01 -0400
Message-ID: <53C06CE9.9000209@redhat.com>
Date: Fri, 11 Jul 2014 18:02:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: copy, don't clear, stripe geometry in backup
 SB
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
To: xfs-oss <xfs@oss.sgi.com>

Today, if we have a filesystem with stripe geometry and
a damaged primary superblock, we will zero out stripe geometry
if we have copied the backup.

I'm guessing this might be because changing geometry with mount
options only updates the primary, so backups aren't guaranteed
to be current or correct.

Unfortunately, that leaves us with sb 0 w/ no geom, and backups
*with* geom, so the next repair finds the mismatch, and complains.
(In other words, the 2nd repair does not come up clean.)_
And ... the second repair copies the backup stripe geometry back
into the primary!

Rather than clearing stripe geometry in this case, just leave it
at what was found in the backup super, and inform the user that this
was done.  This leaves a consistent filesystem, and gives the user
a heads-up to double-check the result.

This can all be demonstrated and tested by running xfs/030 with
geometry set in MKFS_OPTIONS.  (To really make the test pass, 
we need to filter the warning out of repair output.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/globals.h b/repair/globals.h
index f6e0a22..6207ca1 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -124,7 +124,7 @@ EXTERN int	lazy_count;		/* What to set if to if converting */
 
 EXTERN int		primary_sb_modified;
 EXTERN int		bad_ino_btree;
-EXTERN int		clear_sunit;
+EXTERN int		copied_sunit;
 EXTERN int		fs_is_dirty;
 
 /* for hunting down the root inode */
diff --git a/repair/sb.c b/repair/sb.c
index bc421cc..ad27756 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -151,7 +151,7 @@ find_secondary_sb(xfs_sb_t *rsb)
 			 */
 			memmove(rsb, &bufsb, sizeof(xfs_sb_t));
 			rsb->sb_inprogress = 0;
-			clear_sunit = 1;
+			copied_sunit = 1;
 
 			if (verify_set_primary_sb(rsb, 0, &dirty) == XR_OK)  {
 				do_warn(
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9eb2fa4..834697a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -193,7 +193,7 @@ process_args(int argc, char **argv)
 	delete_attr_ok = 1;
 	force_geo = 0;
 	assume_xfs = 0;
-	clear_sunit = 0;
+	copied_sunit = 0;
 	sb_inoalignmt = 0;
 	sb_unit = 0;
 	sb_width = 0;
@@ -898,13 +898,11 @@ _("Warning:  project quota information would be cleared.\n"
 		dsb->sb_qflags &= cpu_to_be16(~XFS_ALL_QUOTA_CHKD);
 	}
 
-	if (clear_sunit) {
+	if (copied_sunit) {
 		do_warn(
-_("Note - stripe unit (%d) and width (%d) fields have been reset.\n"
-  "Please set with mount -o sunit=<value>,swidth=<value>\n"),
+_("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\n"
+  "Please reset with mount -o sunit=<value>,swidth=<value> if necessary\n"),
 			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
-		dsb->sb_unit = 0;
-		dsb->sb_width = 0;
 	}
 
 	libxfs_writebuf(sbp, 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
