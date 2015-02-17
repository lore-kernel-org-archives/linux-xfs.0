Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 752647F5A
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 11:49:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 61F38304059
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 09:49:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AWZkwF5BaZlTeXno (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2015 09:49:27 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1HHnPQL019904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 12:49:26 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1HHnNrV013644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 12:49:25 -0500
Message-ID: <54E37F24.10300@redhat.com>
Date: Tue, 17 Feb 2015 11:49:24 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove deprecated mount options
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

We recently removed deprecated sysctls; may as well
remove deprecated mount options as well, we've stated
that they'd be gone by now in the docs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 7077103..03a3d03 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -228,30 +228,19 @@ default behaviour.
 Deprecated Mount Options
 ========================
 
-  delaylog/nodelaylog
-	Delayed logging is the only logging method that XFS supports
-	now, so these mount options are now ignored.
-
-	Due for removal in 3.12.
-
-  ihashsize=value
-	In memory inode hashes have been removed, so this option has
-	no function as of August 2007. Option is deprecated.
-
-	Due for removal in 3.12.
+None at present.
 
-  irixsgid
-	This behaviour is now controlled by a sysctl, so the mount
-	option is ignored.
 
-	Due for removal in 3.12.
+Removed Mount Options
+=====================
 
-  osyncisdsync
-  osyncisosync
-	O_SYNC and O_DSYNC are fully supported, so there is no need
-	for these options any more.
+  Name				Removed
+  ----				-------
+  delaylog/nodelaylog		v3.20
+  ihashsize			v3.20
+  irixsgid			v3.20
+  osyncisdsync/osyncisosync	v3.20
 
-	Due for removal in 3.12.
 
 sysctls
 =======
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5ce76d0..31852cc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -109,8 +109,6 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #define MNTOPT_GQUOTANOENF "gqnoenforce"/* group quota limit enforcement */
 #define MNTOPT_PQUOTANOENF "pqnoenforce"/* project quota limit enforcement */
 #define MNTOPT_QUOTANOENF  "qnoenforce"	/* same as uqnoenforce */
-#define MNTOPT_DELAYLOG    "delaylog"	/* Delayed logging enabled */
-#define MNTOPT_NODELAYLOG  "nodelaylog"	/* Delayed logging disabled */
 #define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
 #define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
 
@@ -361,28 +359,10 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
 			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
-		} else if (!strcmp(this_char, MNTOPT_DELAYLOG)) {
-			xfs_warn(mp,
-	"delaylog is the default now, option is deprecated.");
-		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
-			xfs_warn(mp,
-	"nodelaylog support has been removed, option is deprecated.");
 		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
 			mp->m_flags |= XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
-		} else if (!strcmp(this_char, "ihashsize")) {
-			xfs_warn(mp,
-	"ihashsize no longer used, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisdsync")) {
-			xfs_warn(mp,
-	"osyncisdsync has no effect, option is deprecated.");
-		} else if (!strcmp(this_char, "osyncisosync")) {
-			xfs_warn(mp,
-	"osyncisosync has no effect, option is deprecated.");
-		} else if (!strcmp(this_char, "irixsgid")) {
-			xfs_warn(mp,
-	"irixsgid is now a sysctl(2) variable, option is deprecated.");
 		} else {
 			xfs_warn(mp, "unknown mount option [%s].", this_char);
 			return -EINVAL;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
