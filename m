Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41618 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfENSv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 May 2019 14:51:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id z3so10310pgp.8
        for <linux-xfs@vger.kernel.org>; Tue, 14 May 2019 11:51:27 -0700 (PDT)
From: Jorge Guerra <jorge.guerra@gmail.com>
Subject: [PATCH] xfs_db: add extent count and file size histograms
Date: Tue, 14 May 2019 11:50:26 -0700
Message-Id: <20190514185026.73788-1-jorgeguerra@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: osandov@osandov.com, Jorge Guerra <jorgeguerra@fb.com>

From: Jorge Guerra <jorgeguerra@fb.com>

In this change we add two feature to the xfs_db 'frag' command:

1) Extent count histogram [-e]: This option enables tracking the
   number of extents per inode (file) as the we traverse the file
   system.  The end result is a histogram of the number of extents per
   file in power of 2 buckets.

2) File size histogram and file system internal fragmentation stats
   [-s]: This option enables tracking file sizes both in terms of what
   has been physically allocated and how much has been written to the
   file.  In addition, we track the amount of internal fragmentation
   seen per file.  This is particularly useful in the case of real
   time devices where space is allocated in units of fixed sized
   extents.

The man page for xfs_db has been updated to reflect these new command
line arguments.

Tests:

We tested this change on several XFS file systems with different
configurations:

1) regular XFS:

[root@m1 ~]# xfs_info /mnt/d0
meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=2441608704, imaxpct=100
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@m1 ~]# echo "frag -e -s" | xfs_db -r /dev/sdb1
xfs_db> actual 494393, ideal 489246, fragmentation factor 1.04%
Note, this number is largely meaningless.
Files on this filesystem average 1.01 extents per file
Maximum extents in a file 17
Histogram of number of extents per file:
    bucket =       count        % of total
<=       1 =      486157        99.573 %
<=       2 =         768        0.157 %
<=       4 =         371        0.076 %
<=       8 =         947        0.194 %
<=      16 =           0        0.000 %
<=      32 =           1        0.000 %
Maximum file size 64.512 MB
Histogram of file size:
    bucket =        used        overhead(bytes)
<=    4 KB =      180515                   0 0.00%
<=    8 KB =       23604          4666970112 44.31%
<=   16 KB =        2712          1961668608 18.62%
<=   32 KB =        1695           612319232 5.81%
<=   64 KB =         290           473210880 4.49%
<=  128 KB =         214           270184448 2.56%
<=  256 KB =         186           269856768 2.56%
<=  512 KB =         201            67203072 0.64%
<=    1 MB =         325           267558912 2.54%
<=    2 MB =         419           596860928 5.67%
<=    4 MB =         436           454148096 4.31%
<=    8 MB =        1864           184532992 1.75%
<=   16 MB =       16084           111964160 1.06%
<=   32 MB =      258910           395116544 3.75%
<=   64 MB =          61           202104832 1.92%
<=  128 MB =         728                   0 0.00%
capacity used (bytes): 7210847514624 (6.558 TB)
block overhead (bytes): 10533699584 (0.146 %)
xfs_db>

2) XFS with a realtime device configured with 256 KiB extents:

[root@m2 ~]# xfs_info /mnt/d0
meta-data=/dev/nvme0n1p1         isize=2048   agcount=15, agsize=434112 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=6104576, imaxpct=100
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =/dev/sdaa1             extsz=262144 blocks=2439872256, rtextents=38123004

[root@m2 ~]# echo "frag -s -e" | xfs_db -r /dev/nvme0n1p1
xfs_db> actual 11851552, ideal 1264416, fragmentation factor 89.33%
Note, this number is largely meaningless.
Files on this filesystem average 9.37 extents per file
Maximum extents in a file 129956
Histogram of number of extents per file:
    bucket =       count        % of total
<=       1 =      331951        26.295 %
<=       2 =       82720        6.553 %
<=       4 =      160041        12.677 %
<=       8 =      205312        16.263 %
<=      16 =      267145        21.161 %
<=      32 =      197625        15.655 %
<=      64 =       17610        1.395 %
<=     128 =           8        0.001 %
<=     256 =           1        0.000 %
<=     512 =           0        0.000 %
<=    1024 =           0        0.000 %
<=    2048 =           0        0.000 %
<=    4096 =           0        0.000 %
<=    8192 =           0        0.000 %
<=   16384 =           0        0.000 %
<=   32768 =           0        0.000 %
<=   65536 =           0        0.000 %
<=  131072 =           1        0.000 %
Maximum file size 15.522 GB
Histogram of file size:
    bucket =    allocated           used        overhead(bytes)
<=    4 KB =           0            2054          8924143616 3.80%
<=    8 KB =           0           57684         14648967168 6.23%
<=   16 KB =           0           24280          6032441344 2.57%
<=   32 KB =           0           18351          4340473856 1.85%
<=   64 KB =           0           20064          4280770560 1.82%
<=  128 KB =        1002           25287          4138127360 1.76%
<=  256 KB =      163110           17548          1264742400 0.54%
<=  512 KB =       19898           19863          2843152384 1.21%
<=    1 MB =       32687           32617          4361404416 1.86%
<=    2 MB =       38395           38324          5388206080 2.29%
<=    4 MB =       82700           82633         10549821440 4.49%
<=    8 MB =      208576          208477         34238386176 14.57%
<=   16 MB =      715937          715092        134046113792 57.02%
<=   32 MB =         107             107             6332416 0.00%
<=   64 MB =           0               0                   0 0.00%
<=  128 MB =           1               1              157611 0.00%
<=  256 MB =           0               0                   0 0.00%
<=  512 MB =           0               0                   0 0.00%
<=    1 GB =           0               0                   0 0.00%
<=    2 GB =           0               0                   0 0.00%
<=    4 GB =           0               0                   0 0.00%
<=    8 GB =           0               0                   0 0.00%
<=   16 GB =           1               1                   0 0.00%
capacity used (bytes): 7679537216535 (6.984 TB)
capacity allocated (bytes): 7914608582656 (7.198 TB)
block overhead (bytes): 235071366121 (3.061 %)
xfs_db>

3) XFS with a realtime device configured with 1044 KiB extents:

[root@m3 ~]# xfs_info /mnt/d0
meta-data=/dev/sdb1              isize=2048   agcount=4, agsize=1041728 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=4166912, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =/dev/sdc1              extsz=1069056 blocks=1949338880, rtextents=7468731
[root@m3 ~]# echo "frag -s -e" | /tmp/xfs_db -r /dev/sdc1
xfs_db: /dev/sdc1 is not a valid XFS filesystem (unexpected SB magic number 0x68656164)
Use -F to force a read attempt.
[root@m3 ~]# echo "frag -s -e" | /tmp/xfs_db -r /dev/sdb1
xfs_db> actual 732480, ideal 360707, fragmentation factor 50.76%
Note, this number is largely meaningless.
Files on this filesystem average 2.03 extents per file
Maximum extents in a file 14
Histogram of number of extents per file:
    bucket =       count        % of total
<=       1 =      350934        97.696 %
<=       2 =        6231        1.735 %
<=       4 =        1001        0.279 %
<=       8 =         953        0.265 %
<=      16 =          92        0.026 %
Maximum file size 26.508 MB
Histogram of file size:
    bucket =    allocated           used        overhead(bytes)
<=    4 KB =           0              62           314048512 0.13%
<=    8 KB =           0          119911        127209263104 53.28%
<=   16 KB =           0           14543         15350194176 6.43%
<=   32 KB =         909           12330         11851161600 4.96%
<=   64 KB =          92            6704          6828642304 2.86%
<=  128 KB =           1            7132          6933372928 2.90%
<=  256 KB =           0           10013          8753799168 3.67%
<=  512 KB =           0           13616          9049227264 3.79%
<=    1 MB =           1           15056          4774912000 2.00%
<=    2 MB =      198662           17168          9690226688 4.06%
<=    4 MB =       28639           21073         11806654464 4.94%
<=    8 MB =       35169           29878         14200553472 5.95%
<=   16 MB =       95667           91633         11939287040 5.00%
<=   32 MB =          71              62            28471742 0.01%
capacity used (bytes): 1097735533058 (1022.346 GB)
capacity allocated (bytes): 1336497410048 (1.216 TB)
block overhead (bytes): 238761885182 (21.750 %)
xfs_db>

Signed-off-by: Jorge Guerra <jorgeguerra@fb.com>
---
 db/frag.c         | 210 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 man/man8/xfs_db.8 |   8 ++-
 2 files changed, 211 insertions(+), 7 deletions(-)

diff --git a/db/frag.c b/db/frag.c
index 91395234..5d569325 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -15,6 +15,31 @@
 #include "init.h"
 #include "malloc.h"
 
+#define	PERCENT(x, y)	(((double)(x) * 100)/(y))
+//#define	ARRAY_SIZE(a)	(sizeof((a))/sizeof((a)[0]))
+#define	BLOCKS_2_BYTES(b)	((b) << 12)
+#define	CLZ(n)	(__builtin_clzl(n))
+#define	CTZ(n)	(__builtin_ctzl(n))
+
+#define	N_BUCKETS	64
+
+typedef struct extentstats {
+	uint64_t	allocsize[N_BUCKETS + 1];
+	uint64_t	usedsize[N_BUCKETS + 1];
+	uint64_t	wastedsize[N_BUCKETS + 1];
+	uint64_t	maxfilesize;
+	uint64_t	logicalused;
+	uint64_t	physicalused;
+	uint64_t	wastedspace;
+	bool		realtime;
+} extentstats_t;
+
+typedef struct fileextstats {
+	uint64_t	extsbuckets[N_BUCKETS + 1];
+	uint64_t	maxexts;
+	uint64_t	numfiles;
+} fileextstats_t;
+
 typedef struct extent {
 	xfs_fileoff_t	startoff;
 	xfs_filblks_t	blockcount;
@@ -38,6 +63,10 @@ static int		qflag;
 static int		Rflag;
 static int		rflag;
 static int		vflag;
+static int		eflag;
+static extentstats_t	extstats;
+static int		sflag;
+static fileextstats_t	festats;
 
 typedef void	(*scan_lbtree_f_t)(struct xfs_btree_block *block,
 				   int			level,
@@ -49,7 +78,7 @@ typedef void	(*scan_sbtree_f_t)(struct xfs_btree_block *block,
 				   xfs_agf_t		*agf);
 
 static extmap_t		*extmap_alloc(xfs_extnum_t nex);
-static xfs_extnum_t	extmap_ideal(extmap_t *extmap);
+static xfs_extnum_t	extmap_ideal(extmap_t *extmap, uint64_t *fallocsize);
 static void		extmap_set_ext(extmap_t **extmapp, xfs_fileoff_t o,
 				       xfs_extlen_t c);
 static int		frag_f(int argc, char **argv);
@@ -77,9 +106,46 @@ static void		scanfunc_ino(struct xfs_btree_block *block, int level,
 
 static const cmdinfo_t	frag_cmd =
 	{ "frag", NULL, frag_f, 0, -1, 0,
-	  "[-a] [-d] [-f] [-l] [-q] [-R] [-r] [-v]",
+	  "[-a] [-d] [-e] [-f] [-l] [-q] [-R] [-r] [-s] [-v]",
 	  "get file fragmentation data", NULL };
 
+// IEC 2^10 standard prefixes
+static const char	iec_prefixes[] =
+	{ ' ', 'K', 'M', 'G', 'T', 'P', 'E', 'Z'};
+
+static double
+bytes_2_human(
+	uint64_t bytes,
+	int *iecprefix)
+{
+	double answer;
+	int i;
+
+	for (i = 0, answer = (double)bytes;
+		answer > 1024 && i < ARRAY_SIZE(iec_prefixes);
+		i++, answer /= 1024);
+	*iecprefix = i;
+
+	return answer;
+}
+
+static uint8_t
+get_bucket(
+	uint64_t	val)
+{
+	uint8_t	bucket;
+	uint8_t	msbidx = 63 - CLZ(val);
+	uint8_t	lsbidx = CTZ(val);
+
+	/*
+	 * The bucket is computed as ceiling(s, 2^CLZ(s)), but this method is
+	 * faster.
+	 */
+	bucket = msbidx + (msbidx != lsbidx ? 1 : 0);
+
+	return MIN(bucket, N_BUCKETS);
+}
+
 static extmap_t *
 extmap_alloc(
 	xfs_extnum_t	nex)
@@ -96,18 +162,23 @@ extmap_alloc(
 
 static xfs_extnum_t
 extmap_ideal(
-	extmap_t	*extmap)
+	extmap_t	*extmap,
+	uint64_t	*fallocsize)
 {
 	extent_t	*ep;
 	xfs_extnum_t	rval;
+	uint64_t	fsize = 0;
 
 	for (ep = &extmap->ents[0], rval = 0;
 	     ep < &extmap->ents[extmap->nents];
 	     ep++) {
+		fsize += BLOCKS_2_BYTES(ep->blockcount);
 		if (ep == &extmap->ents[0] ||
 		    ep->startoff != ep[-1].startoff + ep[-1].blockcount)
 			rval++;
 	}
+	*fallocsize = fsize;
+
 	return rval;
 }
 
@@ -133,6 +204,80 @@ extmap_set_ext(
 }
 
 void
+print_extents_histo(void)
+{
+	int		i;
+	int		nfiles = 0;
+
+	dbprintf(_("Maximum extents in a file %lu\n"), festats.maxexts);
+	dbprintf(_("Histogram of number of extents per file:\n"));
+	dbprintf(_("   %7s =\t%8s\t%s\n"), "bucket", "count", "\% of total");
+	for (i = 0;
+		i <= N_BUCKETS && nfiles < festats.numfiles; i++) {
+		nfiles += festats.extsbuckets[i];
+		if (nfiles == 0)
+			continue;
+		dbprintf(_("<= %7u = \t%8u\t%.3f \%\n"), 1 << i, festats.extsbuckets[i],
+			PERCENT(festats.extsbuckets[i], festats.numfiles));
+	}
+}
+
+void
+print_file_size_histo(void)
+{
+	double		answer;
+	int		i;
+	int		nfiles = 0;
+	int		ufiles = 0;
+
+	answer = bytes_2_human(extstats.maxfilesize, &i);
+	dbprintf(_("Maximum file size %.3f %cB\n"), answer, iec_prefixes[i]);
+	dbprintf(_("Histogram of file size:\n"));
+	if (extstats.realtime) {
+		dbprintf(_("   %7s =\t%8s\t%8s\t%12s\n"),
+		 "bucket", "allocated", "used", "overhead(bytes)");
+		for (i = 10; i <= N_BUCKETS && nfiles < festats.numfiles; i++) {
+			nfiles += extstats.allocsize[i];
+			ufiles += extstats.usedsize[i];
+			if (ufiles == 0)
+				continue;
+		dbprintf(_("<= %4u %cB =\t%8lu\t%8lu\t%12lu %.2f\%\n"), 1 << (i % 10),
+			iec_prefixes[i/10],
+			extstats.allocsize[i], extstats.usedsize[i],
+			extstats.wastedsize[i],
+			PERCENT(extstats.wastedsize[i], extstats.wastedspace));
+		}
+		answer = bytes_2_human(extstats.logicalused, &i);
+		dbprintf(_("capacity used (bytes): %llu (%.3f %cB)\n"),
+		extstats.logicalused, answer, iec_prefixes[i]);
+		answer = bytes_2_human(extstats.physicalused, &i);
+		dbprintf(_("capacity allocated (bytes): %llu (%.3f %cB)\n"),
+			extstats.physicalused, answer, iec_prefixes[i]);
+		answer = PERCENT(extstats.wastedspace, extstats.logicalused);
+	} else {
+		dbprintf(_("   %7s =\t%8s\t%12s\n"),
+		 "bucket", "used", "overhead(bytes)");
+		for (i = 10; i <= N_BUCKETS && nfiles < festats.numfiles; i++) {
+			nfiles += extstats.allocsize[i];
+			ufiles += extstats.usedsize[i];
+			if (ufiles == 0)
+				continue;
+		dbprintf(_("<= %4u %cB =\t%8lu\t%12lu %.2f\%\n"), 1 << (i % 10),
+			iec_prefixes[i/10],
+			extstats.allocsize[i],
+			extstats.wastedsize[i],
+			PERCENT(extstats.wastedsize[i], extstats.wastedspace));
+		}
+		answer = bytes_2_human(extstats.physicalused, &i);
+		dbprintf(_("capacity used (bytes): %llu (%.3f %cB)\n"),
+			extstats.physicalused, answer, iec_prefixes[i]);
+		answer = PERCENT(extstats.wastedspace, extstats.physicalused);
+	}
+	dbprintf(_("block overhead (bytes): %llu (%.3f \%)\n"),
+		extstats.wastedspace, answer);
+}
+
+void
 frag_init(void)
 {
 	add_command(&frag_cmd);
@@ -164,6 +309,12 @@ frag_f(
 	answer = (double)extcount_actual / (double)extcount_ideal;
 	dbprintf(_("Files on this filesystem average %.2f extents per file\n"),
 		answer);
+	if (eflag) {
+		print_extents_histo();
+	}
+	if (sflag) {
+		print_file_size_histo();
+	}
 	return 0;
 }
 
@@ -174,9 +325,10 @@ init(
 {
 	int		c;
 
-	aflag = dflag = fflag = lflag = qflag = Rflag = rflag = vflag = 0;
+	aflag = dflag = eflag = fflag = lflag = qflag = Rflag =
+		rflag = sflag = vflag = 0;
 	optind = 0;
-	while ((c = getopt(argc, argv, "adflqRrv")) != EOF) {
+	while ((c = getopt(argc, argv, "adeflqRrsv")) != EOF) {
 		switch (c) {
 		case 'a':
 			aflag = 1;
@@ -184,6 +336,9 @@ init(
 		case 'd':
 			dflag = 1;
 			break;
+		case 'e':
+			eflag = 1;
+			break;
 		case 'f':
 			fflag = 1;
 			break;
@@ -199,6 +354,9 @@ init(
 		case 'r':
 			rflag = 1;
 			break;
+		case 's':
+			sflag = 1;
+			break;
 		case 'v':
 			vflag = 1;
 			break;
@@ -210,6 +368,8 @@ init(
 	if (!aflag && !dflag && !fflag && !lflag && !qflag && !Rflag && !rflag)
 		aflag = dflag = fflag = lflag = qflag = Rflag = rflag = 1;
 	extcount_actual = extcount_ideal = 0;
+	memset(&extstats, 0 , sizeof(extstats));
+	memset(&festats, 0 , sizeof(festats));
 	return 1;
 }
 
@@ -274,6 +434,10 @@ process_fork(
 {
 	extmap_t	*extmap;
 	int		nex;
+	int	bucket;
+	uint64_t	fallocsize;
+	uint64_t	fusedsize;
+	uint64_t	fwastedsize;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	if (!nex)
@@ -288,7 +452,41 @@ process_fork(
 		break;
 	}
 	extcount_actual += extmap->nents;
-	extcount_ideal += extmap_ideal(extmap);
+	extcount_ideal += extmap_ideal(extmap, &fallocsize);
+
+	if (sflag) {
+		// Record file size stats
+		fusedsize = be64_to_cpu(dip->di_size);
+		bucket = get_bucket(fallocsize);
+		extstats.allocsize[bucket]++;
+		bucket = get_bucket(fusedsize);
+		extstats.usedsize[bucket]++;
+
+		if (fallocsize > fusedsize) {
+			fwastedsize = fallocsize - fusedsize;
+			extstats.wastedspace += fwastedsize;
+			extstats.wastedsize[bucket] += fwastedsize;
+		}
+		extstats.logicalused += fusedsize;
+		extstats.physicalused += fallocsize;
+		extstats.maxfilesize = MAX(extstats.maxfilesize, fallocsize);
+		if (be16_to_cpu(dip->di_flags) & XFS_DIFLAG_REALTIME) {
+			extstats.realtime = true;
+		}
+	}
+
+	if (eflag) {
+		// Record file extent stats
+		bucket = get_bucket(extmap->nents);
+		if (be16_to_cpu(dip->di_flags) & XFS_DIFLAG_REALTIME) {
+			// Realtime inodes have an additional extent
+			bucket = get_bucket(MAX(extmap->nents - 1, 1));
+		}
+		festats.extsbuckets[bucket]++;
+		festats.maxexts = MAX(festats.maxexts, extmap->nents);
+	}
+	festats.numfiles++;
+
 	xfree(extmap);
 }
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index a1ee3514..52d5f18a 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -489,7 +489,7 @@ command.
 .B forward
 Move forward to the next entry in the position ring.
 .TP
-.B frag [\-adflqRrv]
+.B frag [\-adeflqRrsv]
 Get file fragmentation data. This prints information about fragmentation
 of file data in the filesystem (as opposed to fragmentation of freespace,
 for which see the
@@ -510,6 +510,9 @@ enables processing of attribute data.
 .B \-d
 enables processing of directory data.
 .TP
+.B \-e
+enables computing extent count per inode histogram.
+.TP
 .B \-f
 enables processing of regular file data.
 .TP
@@ -524,6 +527,9 @@ enables processing of realtime control file data.
 .TP
 .B \-r
 enables processing of realtime file data.
+.TP
+.B \-s
+enables computing file size histogram and file system overheads.
 .RE
 .TP
 .BI "freesp [\-bcds] [\-A " alignment "] [\-a " ag "] ... [\-e " i "] [\-h " h1 "] ... [\-m " m ]
-- 
2.13.5
