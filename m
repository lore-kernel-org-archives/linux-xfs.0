Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHY9MZ123131 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:34:09 -0600
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id dBYztzW8DqijUc2G for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:34:08 -0800 (PST)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 23 Jan 2012 10:34:06 -0700
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 5BE201FF0049
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:33:12 -0700 (MST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0NHXBiW266794 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 12:33:11 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q0NHXBn0028292 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 15:33:11 -0200
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 23 Jan 2012 11:33:10 -0600
Message-Id: <20120123173310.31735.28918.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 4/4] xfsprogs: Add support to mkfs to add pquotino by adding a
	new option.
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

>From 77152735d6bc893b3a724d7a6ff4bb747fb23aec Mon Sep 17 00:00:00 2001
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 13 Dec 2011 16:10:07 -0600
Subject: [PATCH 4/4] Add support to mkfs to have a separate inode field for project quota.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 mkfs/xfs_mkfs.c |   22 +++++++++++++++++-----
 mkfs/xfs_mkfs.h |    3 ++-
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f527f3d..872a304 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -90,6 +90,8 @@ char	*dopts[] = {
 	"projinherit",
 #define D_EXTSZINHERIT	14
 	"extszinherit",
+#define D_NO_OQUOTA	15
+	"seppquota",
 	NULL
 };
 
@@ -922,6 +924,7 @@ main(
 	libxfs_init_t		xi;
 	struct fs_topology	ft;
 	int			lazy_sb_counters;
+	int			seppquota;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -930,6 +933,7 @@ main(
 
 	attrversion = 2;
 	projid32bit = 0;
+	seppquota = 1;
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
 	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
@@ -1178,6 +1182,14 @@ main(
 					fsx.fsx_xflags |= \
 						XFS_DIFLAG_EXTSZINHERIT;
 					break;
+				case D_NO_OQUOTA:
+					if (!value)
+						value = "0";
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "d seppquota");
+					seppquota = c;
+					break;
 				default:
 					unknown('d', value);
 				}
@@ -2278,7 +2290,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	if (!qflag || Nflag) {
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
-		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
+		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u, seppquota=%d\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
@@ -2286,7 +2298,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
-			"", sectorsize, attrversion, projid32bit,
+			"", sectorsize, attrversion, projid32bit, seppquota,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci,
@@ -2330,7 +2342,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	sbp->sb_fdblocks = dblocks - agcount * XFS_PREALLOC_BLOCKS(mp) -
 		(loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
-	sbp->sb_uquotino = sbp->sb_gquotino = 0;
+	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
 	sbp->sb_qflags = 0;
 	sbp->sb_unit = dsunit;
 	sbp->sb_width = dswidth;
@@ -2353,7 +2365,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		sbp->sb_logsectsize = 0;
 	}
 	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(lazy_sb_counters,
-					attrversion == 2, projid32bit == 1, 0);
+					attrversion == 2, projid32bit == 1, 0, seppquota);
 	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(iaflag, dsunit != 0,
 					logversion == 2, attrversion == 1,
 					(sectorsize != BBSIZE ||
@@ -2821,7 +2833,7 @@ usage( void )
 /* blocksize */		[-b log=n|size=num]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num),\n\
-			    sectlog=n|sectsize=num\n\
+			    sectlog=n|sectsize=num,seppquota=0|1\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
diff --git a/mkfs/xfs_mkfs.h b/mkfs/xfs_mkfs.h
index f25a7f3..d597bb3 100644
--- a/mkfs/xfs_mkfs.h
+++ b/mkfs/xfs_mkfs.h
@@ -36,11 +36,12 @@
 	        XFS_DFL_SB_VERSION_BITS |                               \
 	0 ) : XFS_SB_VERSION_1 )
 
-#define XFS_SB_VERSION2_MKFS(lazycount, attr2, projid32bit, parent) (\
+#define XFS_SB_VERSION2_MKFS(lazycount, attr2, projid32bit, parent, seppquota) (\
 	((lazycount) ? XFS_SB_VERSION2_LAZYSBCOUNTBIT : 0) |		\
 	((attr2) ? XFS_SB_VERSION2_ATTR2BIT : 0) |			\
 	((projid32bit) ? XFS_SB_VERSION2_PROJID32BIT : 0) |		\
 	((parent) ? XFS_SB_VERSION2_PARENTBIT : 0) |			\
+	((seppquota) ? XFS_SB_VERSION2_NO_OQUOTA : 0) |			\
 	0 )
 
 #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
