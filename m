Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16AEE7F4E
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 01:50:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E75DF8F8033
	for <xfs@oss.sgi.com>; Sat, 28 Sep 2013 23:50:51 -0700 (PDT)
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142]) by
	cuda.sgi.com with ESMTP id mG4D41ukIWq9D0Ra (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Sep 2013 23:50:50 -0700 (PDT)
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Sun, 29 Sep 2013 16:50:47 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 12DA12CE8051
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:50:45 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8T6Y0Y661276292
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:34:00 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8T6oihS027106 for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:50:44 +1000
Message-ID: <1380437441.3811.9.camel@ThinkPad-T5421>
Subject: [PATCH v2] xfsprogs: make log/size consistent for mkfs's -s option
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Sun, 29 Sep 2013 14:50:41 +0800
In-Reply-To: <5245C07A.3000700@sandeen.net>
References: <1380272973.2836.5.camel@ThinkPad-T5421>
	<5245C07A.3000700@sandeen.net>
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
v2: fix an error in v1 found by Eric reviewing the code.

 mkfs/xfs_mkfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index eafbed3..34bf2ff 100644
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
+	if (ft.sectoralign || (!ssflag && !slflag)) {
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
