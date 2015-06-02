Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 44DF27F77
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1E73AC009
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UJmOflgwmOSsyhoT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id B9284B1F88
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:04 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig49I019886
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 11/28] mkfs: sparse inode chunk support
Date: Tue,  2 Jun 2015 14:41:44 -0400
Message-Id: <1433270521-62026-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

Allow format of sparse inode chunk enabled filesystems via the '-i
sparse' flag. Note that sparse inode chunk support requires a v5
superblock (-m crc=1).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 man/man8/mkfs.xfs.8 | 17 +++++++++++++++++
 mkfs/xfs_mkfs.c     | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index ad9ff3d..542dea9 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -409,6 +409,23 @@ This is used to enable 32bit quota project identifiers. The
 is either 0 or 1, with 1 signifying that 32bit projid are to be enabled.
 If the value is omitted, 1 is assumed.  (This default changed
 in release version 3.2.0.)
+.TP
+.BI sparse[= value ]
+Enable sparse inode chunk allocation. The
+.I value
+is either 0 or 1, with 1 signifying that sparse allocation is enabled.
+If the value is omitted, 1 is assumed. Sparse inode allocation is
+disabled by default. This feature is only available for filesystems
+formatted with
+.B \-m crc=1.
+.IP
+When enabled, sparse inode allocation allows the filesystem to allocate
+smaller than the standard 64-inode chunk when free space is severely
+limited. This feature is useful for filesystems that might fragment free
+space over time such that no free extents are large enough to
+accommodate a chunk of 64 inodes. Without this feature enabled, inode
+allocations can fail with out of space errors under severe fragmented
+free space conditions.
 .RE
 .TP
 .BI \-l " log_section_options"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1770666..a3f29e0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -109,6 +109,8 @@ char	*iopts[] = {
 	"attr",
 #define	I_PROJID32BIT	6
 	"projid32bit",
+#define I_SPINODES	7
+	"sparse",
 	NULL
 };
 
@@ -1004,6 +1006,7 @@ main(
 	int			lazy_sb_counters;
 	int			crcs_enabled;
 	int			finobt;
+	int			spinodes;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -1038,6 +1041,7 @@ main(
 	lazy_sb_counters = 1;
 	crcs_enabled = 0;
 	finobt = 0;
+	spinodes = 0;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1359,6 +1363,13 @@ main(
 						illegal(value, "i projid32bit");
 					projid16bit = c ? 0 : 1;
 					break;
+				case I_SPINODES:
+					if (!value || *value == '\0')
+						value = "1";
+					spinodes = atoi(value);
+					if (spinodes < 0 || spinodes > 1)
+						illegal(value, "i spinodes");
+					break;
 				default:
 					unknown('i', value);
 				}
@@ -1890,6 +1901,12 @@ _("warning: finobt not supported without CRC support, disabled.\n"));
 		finobt = 0;
 	}
 
+	if (spinodes && !crcs_enabled) {
+		fprintf(stderr,
+_("warning: sparse inodes not supported without CRC support, disabled.\n"));
+		spinodes = 0;
+	}
+
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
@@ -2568,7 +2585,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
-		   "         =%-22s crc=%-8u finobt=%u\n"
+		   "         =%-22s crc=%-8u finobt=%u, sparse=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
@@ -2577,7 +2594,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion, !projid16bit,
-			"", crcs_enabled, finobt,
+			"", crcs_enabled, finobt, spinodes,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci, dirftype,
@@ -2646,6 +2663,20 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_logsectsize = 0;
 	}
 
+	/*
+	 * Sparse inode chunk support has two main inode alignment requirements.
+	 * First, sparse chunk alignment must match the cluster size. Second,
+	 * full chunk alignment must match the inode chunk size.
+	 *
+	 * Copy the already calculated/scaled inoalignmt to spino_align and
+	 * update the former to the full inode chunk size.
+	 */
+	if (spinodes) {
+		sbp->sb_spino_align = sbp->sb_inoalignmt;
+		sbp->sb_inoalignmt = XFS_INODES_PER_CHUNK * isize >> blocklog;
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
+	}
+
 	if (force_overwrite)
 		zero_old_xfs_structures(&xi, sbp);
 
@@ -3193,7 +3224,7 @@ usage( void )
 			    sectlog=n|sectsize=num\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
-			    projid32bit=0|1]\n\
+			    projid32bit=0|1,sparse=0|1]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
