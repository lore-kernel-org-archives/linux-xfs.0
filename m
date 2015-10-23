Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61B7F7F9C
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 14:17:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4839C8F804B
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:17:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GWwpK498XkEI5ts1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:17:18 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 2/4] mkfs.xfs: Add support for the richacl feature flag
Date: Fri, 23 Oct 2015 21:17:06 +0200
Message-Id: <1445627828-14661-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445627828-14661-1-git-send-email-agruenba@redhat.com>
References: <1445627828-14661-1-git-send-email-agruenba@redhat.com>
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
To: xfs@oss.sgi.com, david@fromorbit.com
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>

From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>

Add option "mkfs.xfs -m richacl={0|1}" for explicitly enabling or disabling
richacl support.  The feature flag is disabled by default.

Signed-off-by: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
---
 man/man8/mkfs.xfs.8 |  9 +++++++++
 mkfs/xfs_mkfs.c     | 20 ++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index e98b94d..99ef6a6 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -173,6 +173,15 @@ is used, the free inode btree feature is not supported and is disabled.
 .BI uuid= value
 Use the given value as the filesystem UUID for the newly created filesystem.
 The default is to generate a random UUID.
+.BI richacl= value
+This option is used to create a filesystem with support for Rich Access Control
+Lists (richacls). The value is either 0 to disable the feature, or 1 to enable
+richacls. Filesystems with richacl support require richacl support in the
+kernel to be mounted.
+.IP
+By default,
+.B mkfs.xfs
+will disable richacls.
 .RE
 .TP
 .BI \-d " data_section_options"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7cba41a..300333f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -185,6 +185,8 @@ char	*mopts[] = {
 	"finobt",
 #define M_UUID		2
 	"uuid",
+#define M_RICHACL	3
+	"richacl",
 	NULL
 };
 
@@ -983,6 +985,7 @@ main(
 	int			crcs_enabled;
 	int			finobt;
 	bool			finobtflag;
+	int			richacls_enabled;
 	int			spinodes;
 
 	platform_uuid_generate(&uuid);
@@ -1021,6 +1024,7 @@ main(
 	crcs_enabled = 1;
 	finobt = 1;
 	finobtflag = false;
+	richacls_enabled = 0;
 	spinodes = 0;
 	memset(&fsx, 0, sizeof(fsx));
 
@@ -1532,6 +1536,14 @@ main(
 					if (platform_uuid_parse(value, &uuid))
 						illegal(optarg, "m uuid");
 					break;
+				case M_RICHACL:
+					if (!value || *value == '\0')
+						reqval('m', mopts, M_RICHACL);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "m richacl");
+					richacls_enabled = c;
+					break;
 				default:
 					unknown('m', value);
 				}
@@ -2562,11 +2574,15 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		dirftype = 1;
 	}
 
+	if (richacls_enabled) {
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_RICHACL;
+	}
+
 	if (!qflag || Nflag) {
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u, sparse=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u, richacl=%d, sparse=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -2575,7 +2591,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled, finobt, spinodes,
+			"", crcs_enabled, finobt, richacls_enabled, spinodes,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci, dirftype,
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
