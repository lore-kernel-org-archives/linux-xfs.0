Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E43AF7F50
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 04:09:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B835B304066
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 02:09:49 -0700 (PDT)
Received: from e28smtp05.in.ibm.com (e28smtp05.in.ibm.com [122.248.162.5]) by
	cuda.sgi.com with ESMTP id K3Ri1ARatVi3uugv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 02:09:43 -0700 (PDT)
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Fri, 27 Sep 2013 14:39:39 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 86EA21258055
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 14:39:51 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8R9Bxwi40042674
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 14:41:59 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8R99aW8019380 for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 14:39:36 +0530
Received: from [9.123.210.162] (thinkpad-t5421.cn.ibm.com [9.123.210.162])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id
	r8R99Yid019288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 14:39:35 +0530
Message-ID: <1380272973.2836.5.camel@ThinkPad-T5421>
Subject: [PATCH] xfsprogs: make log/size consistent for mkfs's -s option
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Fri, 27 Sep 2013 17:09:33 +0800
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
To: xfsprogs <xfs@oss.sgi.com>

It seems using -s log is not able to set the sectsz correctly. Because slflag
is set but ignored by later codes, so the advertised sector size of the device
is used instead.

$ mkfs.xfs -f -s size=4096 /dev/sdd
meta-data=/dev/sdd               isize=256    agcount=2, agsize=4096 blks
         =                       sectsz=4096  attr=2, projid32bit=1
	 ......

$ mkfs.xfs -f -s log=12 /dev/sdd
meta-data=/dev/sdd               isize=256    agcount=2, agsize=4096 blks
         =                       sectsz=2048  attr=2, projid32bit=1
	 ......

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 mkfs/xfs_mkfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index eafbed3..9243044 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1693,7 +1693,7 @@ main(
 		 * ft.sectoralign will never be set.
 		 */
 		sectorsize = blocksize;
-	} else if (!ssflag) {
+	} else if (!ssflag && !slflag) {
 		/*
 		 * Unless specified manually on the command line use the
 		 * advertised sector size of the device.  We use the physical
@@ -1721,7 +1721,7 @@ _("switching to logical sector size %d\n"),
 		}
 	}
 
-	if (ft.sectoralign || !ssflag) {
+	if (ft.sectoralign || !ssflag || !slflag) {
 		sectorlog = libxfs_highbit32(sectorsize);
 		if (loginternal) {
 			lsectorsize = sectorsize;
@@ -1731,7 +1731,7 @@ _("switching to logical sector size %d\n"),
 
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
 	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
-		if (ssflag)
+		if (ssflag || slflag)
 			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
 		else
 			fprintf(stderr,
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
