Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF3E17F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 01:16:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 864558F8033
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 23:16:39 -0700 (PDT)
Received: from emh03.mail.saunalahti.fi (emh03.mail.saunalahti.fi
	[62.142.5.109]) by cuda.sgi.com with ESMTP id l6VFv4ebnzVN8WmC
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 23:16:35 -0700 (PDT)
From: Mika Eloranta <mel@ohmu.fi>
Subject: [PATCH] mkfs.xfs: option for using a pre-defined filesystem UUID
Date: Wed, 23 Sep 2015 09:16:13 +0300
Message-Id: <1442988973-43165-1-git-send-email-mel@ohmu.fi>
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
Cc: Mika Eloranta <mel@ohmu.fi>

Usage: mkfs.xfs -m uuid=<uuid> <device>

The filesystem UUID can now be optionally specified during filesystem
creation. The default behavior is still to generate a random UUID.

Allows using pre-generated UUIDs for identifying a filesystem based
on the metadata stored inside the filesystem. Filesystem labels can
be used for the same purpose, but are limited by their length
(12 chars in the case of xfs) whereas the UUID field can store an
entire 128bit UUID, which is plenty for e.g. random ID collision
avoidance.

Random UUID generated during the creation of the filesystem is not
always feasible when an external DB or other system is used to track
the created filesystem, e.g. in automated VM provisioning systems,
as this would require a feedback mechanism which is not always
available. In these cases the best approach often is to generate
a random UUID for the filesystem before the filesystem even exists,
store it in the tracking DB and later create the filesystem directly
with the correct UUID (instead of "mkfs.xfs + xfs_admin -U <new_uuid>").

Signed-off-by: Mika Eloranta <mel@ohmu.fi>
---
 man/man8/mkfs.xfs.8 |  4 ++++
 mkfs/xfs_mkfs.c     | 12 ++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 6260e0c..e98b94d 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -169,6 +169,10 @@ will create free inode btrees for filesystems created with the (default)
 option set. When the option
 .B \-m crc=0
 is used, the free inode btree feature is not supported and is disabled.
+.TP
+.BI uuid= value
+Use the given value as the filesystem UUID for the newly created filesystem.
+The default is to generate a random UUID.
 .RE
 .TP
 .BI \-d " data_section_options"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d993fc0..84f99b0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -181,6 +181,8 @@ char	*mopts[] = {
 	"crc",
 #define M_FINOBT	1
 	"finobt",
+#define M_UUID		2
+	"uuid",
 	NULL
 };
 
@@ -948,6 +950,7 @@ main(
 	bool			finobtflag;
 	int			spinodes;
 
+	platform_uuid_generate(&uuid);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -1488,6 +1491,12 @@ main(
 					finobt = c;
 					finobtflag = true;
 					break;
+				case M_UUID:
+					if (!value || *value == '\0')
+						reqval('m', mopts, M_UUID);
+					if (platform_uuid_parse(value, &uuid))
+						illegal(optarg, "m uuid");
+					break;
 				default:
 					unknown('m', value);
 				}
@@ -2550,7 +2559,6 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_dblocks = dblocks;
 	sbp->sb_rblocks = rtblocks;
 	sbp->sb_rextents = rtextents;
-	platform_uuid_generate(&uuid);
 	platform_uuid_copy(&sbp->sb_uuid, &uuid);
 	/* Only in memory; libxfs expects this as if read from disk */
 	platform_uuid_copy(&sbp->sb_meta_uuid, &uuid);
@@ -3163,7 +3171,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b log=n|size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectlog=n|sectsize=num\n\
-- 
2.3.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
