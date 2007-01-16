Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Jan 2007 22:15:19 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0G6FDqw016970
	for <xfs@oss.sgi.com>; Mon, 15 Jan 2007 22:15:15 -0800
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0G5h0Nj007175
	for <xfs@oss.sgi.com>; Tue, 16 Jan 2007 14:43:07 +0900 (JST)
Received: from mailgate4.nec.co.jp (mailgate53.nec.co.jp [10.7.69.184])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0G5bJro003972
	for <xfs@oss.sgi.com>; Tue, 16 Jan 2007 14:37:19 +0900 (JST)
Received: (from root@localhost) by mailgate4.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l0G5bJf21908 for xfs@oss.sgi.com; Tue, 16 Jan 2007 14:37:19 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l0G5bJI18645 for <xfs@oss.sgi.com>; Tue, 16 Jan 2007 14:37:19 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070116.143718.67102512 for <xfs@oss.sgi.com>
	; Tue, 16 Jan 2007 14:37:18 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id EA456AE4B3
	for <xfs@oss.sgi.com>; Tue, 16 Jan 2007 14:37:16 +0900 (JST)
Message-Id: <200701160537.AA04877@TNESG9305.tnes.nec.co.jp>
Date: Tue, 16 Jan 2007 14:37:04 +0900
Subject: [PATCH] fix extent length in xfs_io bmap
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

In bmap command in xfs_io, there is a difference in the length of the extent group
between "bmap" and "bmap -n nn". 
It occurs if the file size > max extent size and the extents are allocated contiguously.
This patch fixes it.

Test fs:
# xfs_info /dev/sx8/14p1
meta-data=/dev/sx8/14p1          isize=256    agcount=16, agsize=7631000 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=122096000, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=4096   blocks=0, rtextents=0


Example:
u.bmx[0-5] = [startoff,startblock,blockcount,extentflag]
 0:[      0, 1048588,2097088,0]
 1:[2097088, 3145676,2097088,0]
 2:[4194176, 5242764,2097088,0]
 3:[6291264, 7339852, 291136,0]
 4:[6582400, 8388616,2097088,0]
 5:[8679488,10485704,1806272,0]

# xfs_io file2
xfs_io> bmap -v
file2:
 EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET              TOTAL
   0: [0..52659199]:        8388704..61047903   0 (8388704..61047903) 52659200   ...*
   1: [52659200..83886079]: 61048064..92274943  1 (64..31226943)      31226880   ...**
xfs_io> bmap -v -n 1
file2:
 EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET              TOTAL
   0: [0..16776703]:   8388704..25165407  0 (8388704..25165407) 16776704         ...*
xfs_io> bmap -v -n 2
file2:
 EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET              TOTAL
   0: [0..52659199]:        8388704..61047903   0 (8388704..61047903) 52659200
   1: [52659200..69435903]: 61048064..77824767  1 (64..16776767)      16776704   ...**


Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.18-orgn/io/bmap.c	2006-12-13 13:57:22.000000000 +0900
+++ xfsprogs-2.8.18/io/bmap.c	2006-12-21 11:07:09.573116475 +0900
@@ -78,6 +78,7 @@ bmap_f(
 	int			bmv_iflags = 0;	/* flags for XFS_IOC_GETBMAPX */
 	int			i = 0;
 	int			c;
+	int			egcnt;
 
 	while ((c = getopt(argc, argv, "adln:pv")) != EOF) {
 		switch (c) {
@@ -136,7 +137,7 @@ bmap_f(
 		}
 	}
 
-	map_size = nflag ? nflag+1 : 32;	/* initial guess - 256 */
+	map_size = nflag ? nflag+2 : 32;	/* initial guess - 256 */
 	map = malloc(map_size*sizeof(*map));
 	if (map == NULL) {
 		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
@@ -232,9 +233,10 @@ bmap_f(
 			return 0;
 		}
 	}
+	egcnt = nflag ? min(nflag, map->bmv_entries) : map->bmv_entries;
 	printf("%s:\n", file->name);
 	if (!vflag) {
-		for (i = 0; i < map->bmv_entries; i++) {
+		for (i = 0; i < egcnt; i++) {
 			printf("\t%d: [%lld..%lld]: ", i,
 				(long long) map[i + 1].bmv_offset,
 				(long long)(map[i + 1].bmv_offset +
@@ -288,7 +290,7 @@ bmap_f(
 		 * Go through the extents and figure out the width
 		 * needed for all columns.
 		 */
-		for (i = 0; i < map->bmv_entries; i++) {
+		for (i = 0; i < egcnt; i++) {
 			snprintf(rbuf, sizeof(rbuf), "[%lld..%lld]:",
 				(long long) map[i + 1].bmv_offset,
 				(long long)(map[i + 1].bmv_offset +
@@ -325,7 +327,7 @@ bmap_f(
 			aoff_w, _("AG-OFFSET"),
 			tot_w, _("TOTAL"),
 			flg ? _(" FLAGS") : "");
-		for (i = 0; i < map->bmv_entries; i++) {
+		for (i = 0; i < egcnt; i++) {
 			flg = FLG_NULL;
 			if (map[i + 1].bmv_oflags & BMV_OF_PREALLOC) {
 				flg |= FLG_PRE;
