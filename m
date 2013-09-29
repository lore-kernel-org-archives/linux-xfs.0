Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 850627F54
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 04:13:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 496078F8040
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 02:13:04 -0700 (PDT)
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141]) by
	cuda.sgi.com with ESMTP id hs2BnXrZvnN3rMgd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 02:12:59 -0700 (PDT)
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Sun, 29 Sep 2013 19:12:57 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 423D52BB0040
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 19:12:54 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8T8u0e16750536
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 18:56:00 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8T9CrPJ001003 for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 19:12:53 +1000
Message-ID: <1380445971.3811.14.camel@ThinkPad-T5421>
Subject: [PATCH] xfsprogs: cleanup size/log setting flags of mkfs
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Sun, 29 Sep 2013 17:12:51 +0800
In-Reply-To: <1380437441.3811.9.camel@ThinkPad-T5421>
References: <1380272973.2836.5.camel@ThinkPad-T5421>
	<5245C07A.3000700@sandeen.net> <1380437441.3811.9.camel@ThinkPad-T5421>
Mime-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfsprogs <xfs@oss.sgi.com>

As Eric suggested, we could set both of the size/log flags after we have
parsed the options - and from there on it simply means "manually set".

After that, we could use just one flag, e.g. *sflag, to check whether 
the corresponding value is manually set or not.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 mkfs/xfs_mkfs.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 34bf2ff..aa3f391 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1667,11 +1667,26 @@ main(
 		dfile = xi.dname;
 
 	/*
+	 * Later code wants to know if the user manually set a value.
+	 * There are two ways to specify on the cmdline; as size or as a log.
+	 * if either was used, set both flags - from here on it simply means
+	 * "manually set"
+	 */
+	if (bsflag || blflag)
+		bsflag = blflag = 1;
+	if (ssflag || slflag)
+		ssflag = slflag = 1;
+	if (isflag || ilflag)
+		isflag = ilflag = 1;
+	if (nsflag || nlflag)
+		nsflag = nlflag = 1;
+
+	/*
 	 * Blocksize and sectorsize first, other things depend on them
 	 * For RAID4/5/6 we want to align sector size and block size,
 	 * so we need to start with the device geometry extraction too.
 	 */
-	if (!blflag && !bsflag) {
+	if (!bsflag) {
 		blocklog = XFS_DFL_BLOCKSIZE_LOG;
 		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
 	}
@@ -1693,7 +1708,7 @@ main(
 		 * ft.sectoralign will never be set.
 		 */
 		sectorsize = blocksize;
-	} else if (!ssflag && !slflag) {
+	} else if (!ssflag) {
 		/*
 		 * Unless specified manually on the command line use the
 		 * advertised sector size of the device.  We use the physical
@@ -1721,7 +1736,7 @@ _("switching to logical sector size %d\n"),
 		}
 	}
 
-	if (ft.sectoralign || (!ssflag && !slflag)) {
+	if (ft.sectoralign || !ssflag) {
 		sectorlog = libxfs_highbit32(sectorsize);
 		if (loginternal) {
 			lsectorsize = sectorsize;
@@ -1731,7 +1746,7 @@ _("switching to logical sector size %d\n"),
 
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
 	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
-		if (ssflag || slflag)
+		if (ssflag)
 			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
 		else
 			fprintf(stderr,
@@ -1760,7 +1775,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 	 */
 	if (crcs_enabled) {
 		/* minimum inode size is 512 bytes, ipflag checked later */
-		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+		if (isflag && inodelog < XFS_DINODE_DFL_CRC_LOG) {
 			fprintf(stderr,
 _("Minimum inode size for CRCs is %d bytes\n"),
 				1 << XFS_DINODE_DFL_CRC_LOG);
@@ -1804,7 +1819,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		}
 	}
 
-	if (nsflag || nlflag) {
+	if (nsflag) {
 		if (dirblocksize < blocksize ||
 					dirblocksize > XFS_MAX_BLOCKSIZE) {
 			fprintf(stderr, _("illegal directory block size %d\n"),
@@ -1850,7 +1865,7 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 	if (ipflag) {
 		inodelog = blocklog - libxfs_highbit32(inopblock);
 		isize = 1 << inodelog;
-	} else if (!ilflag && !isflag) {
+	} else if (!isflag) {
 		inodelog = crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
 					: XFS_DINODE_DFL_LOG;
 		isize = 1 << inodelog;
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
