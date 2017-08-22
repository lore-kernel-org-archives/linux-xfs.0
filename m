Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34864 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752622AbdHVVT7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 17:19:59 -0400
Subject: [PATCH 3/3] xfs_io: add io_cvtnum wrapper
References: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ac54796d-2a07-1066-a581-0d485d4496c9@sandeen.net>
Date: Tue, 22 Aug 2017 16:19:58 -0500
MIME-Version: 1.0
In-Reply-To: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Now that we set blcok & sector size into each file's geometry,
even for foreign files, add a new wrapper io_cvtnum() which
passes the current file's ->geom into cvtnum() rather than
needing to fill in local vars via cvtnum_init, only to pass
them back into cvtnum().

Switch all cvtnum() to io_cvtnum(), and remove cvtnum_init().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 cowextsize.c      |    4 +---
 fadvise.c         |    7 ++-----
 fsmap.c           |    7 ++-----
 init.c            |   19 ++++++++-----------
 init.h            |    2 +-
 madvise.c         |    6 ++----
 mincore.c         |    6 ++----
 mmap.c            |   35 +++++++++++------------------------
 open.c            |   27 +++++++++++++++++++--------
 pread.c           |   11 +++++------
 prealloc.c        |    7 ++-----
 pwrite.c          |   13 ++++++-------
 readdir.c         |    7 ++-----
 reflink.c         |   16 ++++++----------
 resblks.c         |    2 +-
 seek.c            |    4 +---
 sendfile.c        |    6 ++----
 sync_file_range.c |    6 ++----
 truncate.c        |    4 +---
 19 files changed, 76 insertions(+), 113 deletions(-)


diff --git a/io/cowextsize.c b/io/cowextsize.c
index c4cd6de..5eff9ef 100644
--- a/io/cowextsize.c
+++ b/io/cowextsize.c
@@ -143,11 +143,9 @@ cowextsize_f(
 	int		argc,
 	char		**argv)
 {
-	size_t			blocksize, sectsize;
 	int			c;
 
 	recurse_all = recurse_dir = 0;
-	init_cvtnum(&blocksize, &sectsize);
 	while ((c = getopt(argc, argv, "DR")) != EOF) {
 		switch (c) {
 		case 'D':
@@ -164,7 +162,7 @@ cowextsize_f(
 	}
 
 	if (optind < argc) {
-		cowextsize = (long)cvtnum(blocksize, sectsize, argv[optind]);
+		cowextsize = (long)io_cvtnum(argv[optind]);
 		if (cowextsize < 0) {
 			printf(_("non-numeric cowextsize argument -- %s\n"),
 				argv[optind]);
diff --git a/io/fadvise.c b/io/fadvise.c
index 46174f3..9a38ce4 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -81,19 +81,16 @@ fadvise_f(
 		}
 	}
 	if (range) {
-		size_t	blocksize, sectsize;
-
 		if (optind != argc - 2)
 			return command_usage(&fadvise_cmd);
-		init_cvtnum(&blocksize, &sectsize);
-		offset = cvtnum(blocksize, sectsize, argv[optind]);
+		offset = io_cvtnum(argv[optind]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
 			return 0;
 		}
 		optind++;
-		length = cvtnum(blocksize, sectsize, argv[optind]);
+		length = io_cvtnum(argv[optind]);
 		if (length < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
diff --git a/io/fsmap.c b/io/fsmap.c
index 9e70c7b..920241d 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -396,14 +396,11 @@ fsmap_f(
 	int			i = 0;
 	int			c;
 	unsigned long long	nr = 0;
-	size_t			fsblocksize, fssectsize;
 	struct fs_path		*fs;
 	static bool		tab_init;
 	bool			dumped_flags = false;
 	int			dflag, lflag, rflag;
 
-	init_cvtnum(&fsblocksize, &fssectsize);
-
 	dflag = lflag = rflag = 0;
 	while ((c = getopt(argc, argv, "dlmn:rv")) != EOF) {
 		switch (c) {
@@ -437,7 +434,7 @@ fsmap_f(
 		return command_usage(&fsmap_cmd);
 
 	if (argc > optind) {
-		start = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		start = io_cvtnum(argv[optind]);
 		if (start < 0) {
 			fprintf(stderr,
 				_("Bad rmap start_bblock %s.\n"),
@@ -448,7 +445,7 @@ fsmap_f(
 	}
 
 	if (argc > optind + 1) {
-		end = cvtnum(fsblocksize, fssectsize, argv[optind + 1]);
+		end = io_cvtnum(argv[optind + 1]);
 		if (end < 0) {
 			fprintf(stderr,
 				_("Bad rmap end_bblock %s.\n"),
diff --git a/io/init.c b/io/init.c
index 20d5f80..e54d4c8 100644
--- a/io/init.c
+++ b/io/init.c
@@ -39,18 +39,15 @@ _("Usage: %s [-adfinrRstVx] [-m mode] [-p prog] [[-c|-C] cmd]... file\n"),
 	exit(1);
 }
 
-void
-init_cvtnum(
-	size_t *blocksize,
-	size_t *sectsize)
+long long
+io_cvtnum(
+	char	*s)
 {
-	if (!file || (file->flags & IO_FOREIGN)) {
-		*blocksize = 4096;
-		*sectsize = 512;
-	} else {
-		*blocksize = file->geom.blocksize;
-		*sectsize = file->geom.sectsize;
-	}
+	/* addfile() should always set up this much geometry */
+	ASSERT(file->geom.blocksize);
+	ASSERT(file->geom.sectsize);
+
+	return cvtnum(file->geom.blocksize, file->geom.sectsize, s);
 }
 
 static void
diff --git a/io/init.h b/io/init.h
index bb25242..628e863 100644
--- a/io/init.h
+++ b/io/init.h
@@ -26,4 +26,4 @@ extern int	expert;
 extern size_t	pagesize;
 extern struct timeval stopwatch;
 
-extern void init_cvtnum(size_t *blocksize, size_t *sectsize);
+extern long long io_cvtnum(char *s);
diff --git a/io/madvise.c b/io/madvise.c
index 1d8b53c..456d3b0 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -55,7 +55,6 @@ madvise_f(
 	size_t		length;
 	void		*start;
 	int		advise = MADV_NORMAL, c;
-	size_t		blocksize, sectsize;
 
 	while ((c = getopt(argc, argv, "drsw")) != EOF) {
 		switch (c) {
@@ -80,15 +79,14 @@ madvise_f(
 		offset = mapping->offset;
 		length = mapping->length;
 	} else if (optind == argc - 2) {
-		init_cvtnum(&blocksize, &sectsize);
-		offset = cvtnum(blocksize, sectsize, argv[optind]);
+		offset = io_cvtnum(argv[optind]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
 			return 0;
 		}
 		optind++;
-		llength = cvtnum(blocksize, sectsize, argv[optind]);
+		llength = io_cvtnum(argv[optind]);
 		if (llength < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
diff --git a/io/mincore.c b/io/mincore.c
index 9e0d3a6..179fd4d 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -31,7 +31,6 @@ mincore_f(
 {
 	off64_t		offset, llength;
 	size_t		length;
-	size_t		blocksize, sectsize;
 	void		*start;
 	void		*current, *previous;
 	unsigned char	*vec;
@@ -41,14 +40,13 @@ mincore_f(
 		offset = mapping->offset;
 		length = mapping->length;
 	} else if (argc == 3) {
-		init_cvtnum(&blocksize, &sectsize);
-		offset = cvtnum(blocksize, sectsize, argv[1]);
+		offset = io_cvtnum(argv[1]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[1]);
 			return 0;
 		}
-		llength = cvtnum(blocksize, sectsize, argv[2]);
+		llength = io_cvtnum(argv[2]);
 		if (llength < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[2]);
diff --git a/io/mmap.c b/io/mmap.c
index 7a8150e..5bf90e2 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -160,7 +160,6 @@ mmap_f(
 	ssize_t		length = 0, length2 = 0;
 	void		*address = NULL;
 	char		*filename;
-	size_t		blocksize, sectsize;
 	int		c, prot = 0;
 
 	if (argc == 1) {
@@ -182,8 +181,6 @@ mmap_f(
 		return 0;
 	}
 
-	init_cvtnum(&blocksize, &sectsize);
-
 	while ((c = getopt(argc, argv, "rwxs:")) != EOF) {
 		switch (c) {
 		case 'r':
@@ -196,7 +193,7 @@ mmap_f(
 			prot |= PROT_EXEC;
 			break;
 		case 's':
-			length2 = cvtnum(blocksize, sectsize, optarg);
+			length2 = io_cvtnum(optarg);
 			break;
 		default:
 			return command_usage(&mmap_cmd);
@@ -208,13 +205,13 @@ mmap_f(
 	if (optind != argc - 2)
 		return command_usage(&mmap_cmd);
 
-	offset = cvtnum(blocksize, sectsize, argv[optind]);
+	offset = io_cvtnum(argv[optind]);
 	if (offset < 0) {
 		printf(_("non-numeric offset argument -- %s\n"), argv[optind]);
 		return 0;
 	}
 	optind++;
-	length = cvtnum(blocksize, sectsize, argv[optind]);
+	length = io_cvtnum(argv[optind]);
 	if (length < 0) {
 		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
 		return 0;
@@ -292,7 +289,6 @@ msync_f(
 	ssize_t		length;
 	void		*start;
 	int		c, flags = 0;
-	size_t		blocksize, sectsize;
 
 	while ((c = getopt(argc, argv, "ais")) != EOF) {
 		switch (c) {
@@ -314,15 +310,14 @@ msync_f(
 		offset = mapping->offset;
 		length = mapping->length;
 	} else if (optind == argc - 2) {
-		init_cvtnum(&blocksize, &sectsize);
-		offset = cvtnum(blocksize, sectsize, argv[optind]);
+		offset = io_cvtnum(argv[optind]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
 			return 0;
 		}
 		optind++;
-		length = cvtnum(blocksize, sectsize, argv[optind]);
+		length = io_cvtnum(argv[optind]);
 		if (length < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
@@ -378,7 +373,6 @@ mread_f(
 	char		*bp;
 	void		*start;
 	int		dump = 0, rflag = 0, c;
-	size_t		blocksize, sectsize;
 
 	while ((c = getopt(argc, argv, "frv")) != EOF) {
 		switch (c) {
@@ -400,15 +394,14 @@ mread_f(
 		offset = mapping->offset;
 		length = mapping->length;
 	} else if (optind == argc - 2) {
-		init_cvtnum(&blocksize, &sectsize);
-		offset = cvtnum(blocksize, sectsize, argv[optind]);
+		offset = io_cvtnum(argv[optind]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
 			return 0;
 		}
 		optind++;
-		length = cvtnum(blocksize, sectsize, argv[optind]);
+		length = io_cvtnum(argv[optind]);
 		if (length < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
@@ -536,7 +529,6 @@ mwrite_f(
 	int		seed = 'X';
 	int		rflag = 0;
 	int		c;
-	size_t		blocksize, sectsize;
 
 	while ((c = getopt(argc, argv, "rS:")) != EOF) {
 		switch (c) {
@@ -559,15 +551,14 @@ mwrite_f(
 		offset = mapping->offset;
 		length = mapping->length;
 	} else if (optind == argc - 2) {
-		init_cvtnum(&blocksize, &sectsize);
-		offset = cvtnum(blocksize, sectsize, argv[optind]);
+		offset = io_cvtnum(argv[optind]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
 			return 0;
 		}
 		optind++;
-		length = cvtnum(blocksize, sectsize, argv[optind]);
+		length = io_cvtnum(argv[optind]);
 		if (length < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
@@ -620,16 +611,12 @@ mremap_f(
 	void		*new_addr = NULL;
 	int		flags = 0;
 	int		c;
-	size_t		blocksize, sectsize;
-
-	init_cvtnum(&blocksize, &sectsize);
 
 	while ((c = getopt(argc, argv, "f:m")) != EOF) {
 		switch (c) {
 		case 'f':
 			flags = MREMAP_FIXED|MREMAP_MAYMOVE;
-			new_addr = (void *)(unsigned long)cvtnum(blocksize,
-			                          sectsize, optarg);
+			new_addr = (void *)(unsigned long)io_cvtnum(optarg);
 			break;
 		case 'm':
 			flags = MREMAP_MAYMOVE;
@@ -642,7 +629,7 @@ mremap_f(
 	if (optind != argc - 1)
 		return command_usage(&mremap_cmd);
 
-	new_length = cvtnum(blocksize, sectsize, argv[optind]);
+	new_length = io_cvtnum(argv[optind]);
 	if (new_length < 0) {
 		printf(_("non-numeric offset argument -- %s\n"),
 			argv[optind]);
diff --git a/io/open.c b/io/open.c
index f2ea7c3..b0dcabc 100644
--- a/io/open.c
+++ b/io/open.c
@@ -576,11 +589,9 @@ extsize_f(
 	int		argc,
 	char		**argv)
 {
-	size_t			blocksize, sectsize;
 	int			c;
 
 	recurse_all = recurse_dir = 0;
-	init_cvtnum(&blocksize, &sectsize);
 	while ((c = getopt(argc, argv, "DR")) != EOF) {
 		switch (c) {
 		case 'D':
@@ -597,7 +608,7 @@ extsize_f(
 	}
 
 	if (optind < argc) {
-		extsize = (long)cvtnum(blocksize, sectsize, argv[optind]);
+		extsize = (long)io_cvtnum(argv[optind]);
 		if (extsize < 0) {
 			printf(_("non-numeric extsize argument -- %s\n"),
 				argv[optind]);
diff --git a/io/pread.c b/io/pread.c
index 3395503..2d7ccda 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -381,7 +381,6 @@ pread_f(
 	off64_t		offset;
 	unsigned int	zeed = 0;
 	long long	count, total, tmp;
-	size_t		fsblocksize, fssectsize;
 	struct timeval	t1, t2;
 	char		*sp;
 	int		Cflag, qflag, uflag, vflag;
@@ -389,13 +388,13 @@ pread_f(
 	int		c;
 
 	Cflag = qflag = uflag = vflag = 0;
-	init_cvtnum(&fsblocksize, &fssectsize);
-	bsize = fsblocksize;
+	bsize = file->geom.blocksize;
+	ASSERT(bsize);
 
 	while ((c = getopt(argc, argv, "b:BCFRquvV:Z:")) != EOF) {
 		switch (c) {
 		case 'b':
-			tmp = cvtnum(fsblocksize, fssectsize, optarg);
+			tmp = io_cvtnum(optarg);
 			if (tmp < 0) {
 				printf(_("non-numeric bsize -- %s\n"), optarg);
 				return 0;
@@ -447,7 +446,7 @@ pread_f(
 	if (optind != argc - 2)
 		return command_usage(&pread_cmd);
 
-	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	offset = io_cvtnum(argv[optind]);
 	if (offset < 0 && (direction & (IO_RANDOM|IO_BACKWARD))) {
 		eof = -1;	/* read from EOF */
 	} else if (offset < 0) {
@@ -455,7 +454,7 @@ pread_f(
 		return 0;
 	}
 	optind++;
-	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	count = io_cvtnum(argv[optind]);
 	if (count < 0 && (direction & (IO_RANDOM|IO_FORWARD))) {
 		eof = -1;	/* read to EOF */
 	} else if (count < 0) {
diff --git a/io/prealloc.c b/io/prealloc.c
index 1a1c9ca..bade708 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -63,17 +63,14 @@ offset_length(
 	char		*length,
 	xfs_flock64_t	*segment)
 {
-	size_t		blocksize, sectsize;
-
-	init_cvtnum(&blocksize, &sectsize);
 	memset(segment, 0, sizeof(*segment));
 	segment->l_whence = SEEK_SET;
-	segment->l_start = cvtnum(blocksize, sectsize, offset);
+	segment->l_start = io_cvtnum(offset);
 	if (segment->l_start < 0) {
 		printf(_("non-numeric offset argument -- %s\n"), offset);
 		return 0;
 	}
-	segment->l_len = cvtnum(blocksize, sectsize, length);
+	segment->l_len = io_cvtnum(length);
 	if (segment->l_len < 0) {
 		printf(_("non-numeric length argument -- %s\n"), length);
 		return 0;
diff --git a/io/pwrite.c b/io/pwrite.c
index 1c5dfca..89b3357 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -252,7 +252,6 @@ pwrite_f(
 	off64_t		offset, skip = 0;
 	long long	count, total, tmp;
 	unsigned int	zeed = 0, seed = 0xcdcdcdcd;
-	size_t		fsblocksize, fssectsize;
 	struct timeval	t1, t2;
 	char		*sp, *infile = NULL;
 	int		Cflag, qflag, uflag, dflag, wflag, Wflag;
@@ -260,13 +259,13 @@ pwrite_f(
 	int		c, fd = -1;
 
 	Cflag = qflag = uflag = dflag = wflag = Wflag = 0;
-	init_cvtnum(&fsblocksize, &fssectsize);
-	bsize = fsblocksize;
+	bsize = file->geom.blocksize;
+	ASSERT(bsize);
 
 	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
 		switch (c) {
 		case 'b':
-			tmp = cvtnum(fsblocksize, fssectsize, optarg);
+			tmp = io_cvtnum(optarg);
 			if (tmp < 0) {
 				printf(_("non-numeric bsize -- %s\n"), optarg);
 				return 0;
@@ -293,7 +292,7 @@ pwrite_f(
 			infile = optarg;
 			break;
 		case 's':
-			skip = cvtnum(fsblocksize, fssectsize, optarg);
+			skip = io_cvtnum(optarg);
 			if (skip < 0) {
 				printf(_("non-numeric skip -- %s\n"), optarg);
 				return 0;
@@ -341,13 +340,13 @@ pwrite_f(
 		return command_usage(&pwrite_cmd);
 	if (infile && direction != IO_FORWARD)
 		return command_usage(&pwrite_cmd);
-	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	offset = io_cvtnum(argv[optind]);
 	if (offset < 0) {
 		printf(_("non-numeric offset argument -- %s\n"), argv[optind]);
 		return 0;
 	}
 	optind++;
-	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	count = io_cvtnum(argv[optind]);
 	if (count < 0) {
 		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
 		return 0;
diff --git a/io/readdir.c b/io/readdir.c
index ca7a881..af6ea4c 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -140,7 +140,6 @@ readdir_f(
 	int cnt;
 	unsigned long long total;
 	int c;
-	size_t fsblocksize, fssectsize;
 	struct timeval t1, t2;
 	char s1[64], s2[64], ts[64];
 	long long offset = -1;
@@ -149,15 +148,13 @@ readdir_f(
 	DIR *dir;
 	int dfd;
 
-	init_cvtnum(&fsblocksize, &fssectsize);
-
 	while ((c = getopt(argc, argv, "l:o:v")) != EOF) {
 		switch (c) {
 		case 'l':
-			length = cvtnum(fsblocksize, fssectsize, optarg);
+			length = io_cvtnum(optarg);
 			break;
 		case 'o':
-			offset = cvtnum(fsblocksize, fssectsize, optarg);
+			offset = io_cvtnum(optarg);
 			break;
 		case 'v':
 			verbose = 1;
diff --git a/io/reflink.c b/io/reflink.c
index f584e8f..ba08152 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -113,12 +113,10 @@ dedupe_f(
 	long long	count, total;
 	char		*infile;
 	int		condensed, quiet_flag;
-	size_t		fsblocksize, fssectsize;
 	struct timeval	t1, t2;
 	int		c, ops = 0, fd = -1;
 
 	condensed = quiet_flag = 0;
-	init_cvtnum(&fsblocksize, &fssectsize);
 
 	while ((c = getopt(argc, argv, "Cq")) != EOF) {
 		switch (c) {
@@ -136,19 +134,19 @@ dedupe_f(
 		return command_usage(&dedupe_cmd);
 	infile = argv[optind];
 	optind++;
-	soffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	soffset = io_cvtnum(argv[optind]);
 	if (soffset < 0) {
 		printf(_("non-numeric src offset argument -- %s\n"), argv[optind]);
 		return 0;
 	}
 	optind++;
-	doffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	doffset = io_cvtnum(argv[optind]);
 	if (doffset < 0) {
 		printf(_("non-numeric dest offset argument -- %s\n"), argv[optind]);
 		return 0;
 	}
 	optind++;
-	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	count = io_cvtnum(argv[optind]);
 	if (count < 0) {
 		printf(_("non-positive length argument -- %s\n"), argv[optind]);
 		return 0;
@@ -233,13 +231,11 @@ reflink_f(
 	long long	count = 0, total;
 	char		*infile = NULL;
 	int		condensed, quiet_flag;
-	size_t		fsblocksize, fssectsize;
 	struct timeval	t1, t2;
 	int		c, ops = 0, fd = -1;
 
 	condensed = quiet_flag = 0;
 	doffset = soffset = 0;
-	init_cvtnum(&fsblocksize, &fssectsize);
 
 	while ((c = getopt(argc, argv, "Cq")) != EOF) {
 		switch (c) {
@@ -259,19 +255,19 @@ reflink_f(
 	optind++;
 	if (optind == argc)
 		goto clone_all;
-	soffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	soffset = io_cvtnum(argv[optind]);
 	if (soffset < 0) {
 		printf(_("non-numeric src offset argument -- %s\n"), argv[optind]);
 		return 0;
 	}
 	optind++;
-	doffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	doffset = io_cvtnum(argv[optind]);
 	if (doffset < 0) {
 		printf(_("non-numeric dest offset argument -- %s\n"), argv[optind]);
 		return 0;
 	}
 	optind++;
-	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	count = io_cvtnum(argv[optind]);
 	if (count < 0) {
 		printf(_("non-positive length argument -- %s\n"), argv[optind]);
 		return 0;
diff --git a/io/resblks.c b/io/resblks.c
index 06903f5..337ea32 100644
--- a/io/resblks.c
+++ b/io/resblks.c
@@ -33,7 +33,7 @@ resblks_f(
 	long long		blks;
 
 	if (argc == 2) {
-		blks = cvtnum(file->geom.blocksize, file->geom.sectsize, argv[1]);
+		blks = io_cvtnum(argv[1]);
 		if (blks < 0) {
 			printf(_("non-numeric argument -- %s\n"), argv[1]);
 			return 0;
diff --git a/io/seek.c b/io/seek.c
index 871b472..51c070f 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -105,14 +105,12 @@ seek_f(
 	char	**argv)
 {
 	off64_t		offset, start;
-	size_t		fsblocksize, fssectsize;
 	int		c;
 	int		current;	/* specify data or hole */
 	int		flag;
 	int		startflag;
 
 	flag = startflag = 0;
-	init_cvtnum(&fsblocksize, &fssectsize);
 
 	while ((c = getopt(argc, argv, "adhrs")) != EOF) {
 		switch (c) {
@@ -138,7 +136,7 @@ seek_f(
 	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) || optind != argc - 1)
 		return command_usage(&seek_cmd);
 
-	start = offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	start = offset = io_cvtnum(argv[optind]);
 	if (offset < 0)
 		return command_usage(&seek_cmd);
 
diff --git a/io/sendfile.c b/io/sendfile.c
index 063fa7f..c03b422 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -79,14 +79,12 @@ sendfile_f(
 {
 	off64_t		offset = 0;
 	long long	count, total;
-	size_t		blocksize, sectsize;
 	struct timeval	t1, t2;
 	char		*infile = NULL;
 	int		Cflag, qflag;
 	int		c, fd = -1;
 
 	Cflag = qflag = 0;
-	init_cvtnum(&blocksize, &sectsize);
 	while ((c = getopt(argc, argv, "Cf:i:q")) != EOF) {
 		switch (c) {
 		case 'C':
@@ -119,14 +117,14 @@ sendfile_f(
 		return 0;
 
 	if (optind == argc - 2) {
-		offset = cvtnum(blocksize, sectsize, argv[optind]);
+		offset = io_cvtnum(argv[optind]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
 			goto done;
 		}
 		optind++;
-		count = cvtnum(blocksize, sectsize, argv[optind]);
+		count = io_cvtnum(argv[optind]);
 		if (count < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 7e4f3e6..6634032 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -44,7 +44,6 @@ sync_range_f(
 {
 	off64_t		offset = 0, length = 0;
 	int		c, sync_mode = 0;
-	size_t		blocksize, sectsize;
 
 	while ((c = getopt(argc, argv, "abw")) != EOF) {
 		switch (c) {
@@ -68,15 +67,14 @@ sync_range_f(
 
 	if (optind != argc - 2)
 		return command_usage(&sync_range_cmd);
-	init_cvtnum(&blocksize, &sectsize);
-	offset = cvtnum(blocksize, sectsize, argv[optind]);
+	offset = io_cvtnum(argv[optind]);
 	if (offset < 0) {
 		printf(_("non-numeric offset argument -- %s\n"),
 			argv[optind]);
 		return 0;
 	}
 	optind++;
-	length = cvtnum(blocksize, sectsize, argv[optind]);
+	length = io_cvtnum(argv[optind]);
 	if (length < 0) {
 		printf(_("non-numeric length argument -- %s\n"),
 			argv[optind]);
diff --git a/io/truncate.c b/io/truncate.c
index 20bada8..abfee9f 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -29,10 +29,8 @@ truncate_f(
 	char		**argv)
 {
 	off64_t		offset;
-	size_t		blocksize, sectsize;
 
-	init_cvtnum(&blocksize, &sectsize);
-	offset = cvtnum(blocksize, sectsize, argv[1]);
+	offset = io_cvtnum(argv[1]);
 	if (offset < 0) {
 		printf(_("non-numeric truncate argument -- %s\n"), argv[1]);
 		return 0;

