Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QpPLt1bw"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0CA8E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fDIvf/zhljpeH51Rpr21V2Rs6SiEf/AWtdIbMGOklv8=; b=QpPLt1bw8pPcuRCRUGftubc+sO
	jqixltL40wIH25VL8iBit19nNyRZiqNQMWIx/CbVJ++dDxiSyfbtEtI/izfDVK0rBznAPUaevROKM
	fAZ1k1nsZ+1M7+N3tW0ycP0OElgzr0ZFc/PRn5xdOj5TTNS75jRQnzpB6kwosp7caw7g/ygNxKCYD
	pKAjg91UV1VPCTdOK57HFWraVCioRIZdJH19vNi/NFyu36l+FaqhsioXy2v7GiwREr0hHtGXF0CH3
	KIDUKq1gywAQuO235eHY0fT+9UHlC2GwfkOUIkbx7o3Z9cb9Th45KCXN6sdWLrLE5HgxbvkkPgDCT
	5Bmswbvw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIZ-005tE3-0h;
	Mon, 11 Dec 2023 16:38:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/23] libxfs: making passing flags to libxfs_init less confusing
Date: Mon, 11 Dec 2023 17:37:33 +0100
Message-Id: <20231211163742.837427-15-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The libxfs_xinit stucture has four different ways to pass flags to
libxfs_init:

 - the isreadonly argument despite it's name contains various LIBXFS_
   flags that go beyond just the readonly flag
 - the isdirect flag contains a single LIBXFS_ flag from the same name
 - the usebuflock is an integer used as bool
 - the bcache_flags member is used to pass flags directly to cache_init()
   for the buffer cache

While there is good arguments for keeping the last one separate, all the
others are rather confusing.  Consolidate them into a single flags member
using flags in the LIBXFS_* namespace.
---
 copy/xfs_copy.c     |  4 +---
 db/crc.c            |  2 +-
 db/fuzz.c           |  2 +-
 db/init.c           |  6 +++---
 db/sb.c             |  6 +++---
 db/write.c          |  2 +-
 growfs/xfs_growfs.c |  2 +-
 include/libxfs.h    | 26 ++++++++++++++++++--------
 libxfs/init.c       | 17 +++++++----------
 logprint/logprint.c |  2 +-
 mkfs/xfs_mkfs.c     |  5 ++---
 repair/init.c       | 15 ++++++++-------
 12 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 2f98ae8fb..bd7c6d334 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -715,9 +715,7 @@ main(int argc, char **argv)
 	/* prepare the libxfs_init structure */
 
 	memset(&xargs, 0, sizeof(xargs));
-	xargs.isdirect = LIBXFS_DIRECT;
-	xargs.isreadonly = LIBXFS_ISREADONLY;
-
+	xargs.flags = LIBXFS_ISREADONLY | LIBXFS_DIRECT;
 	xargs.dname = source_name;
 	xargs.disfile = source_is_file;
 
diff --git a/db/crc.c b/db/crc.c
index 1c73f9803..9043b3f48 100644
--- a/db/crc.c
+++ b/db/crc.c
@@ -98,7 +98,7 @@ crc_f(
 	}
 
 	if ((invalidate || recalculate) &&
-	    ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode)) {
+	    ((x.flags & LIBXFS_ISREADONLY) || !expert_mode)) {
 		dbprintf(_("%s not in expert mode, writing disabled\n"),
 			progname);
 		return 0;
diff --git a/db/fuzz.c b/db/fuzz.c
index ba64bad7a..fafbca3e3 100644
--- a/db/fuzz.c
+++ b/db/fuzz.c
@@ -77,7 +77,7 @@ fuzz_f(
 	struct xfs_buf_ops local_ops;
 	const struct xfs_buf_ops *stashed_ops = NULL;
 
-	if (x.isreadonly & LIBXFS_ISREADONLY) {
+	if (x.flags & LIBXFS_ISREADONLY) {
 		dbprintf(_("%s started in read only mode, fuzzing disabled\n"),
 			progname);
 		return 0;
diff --git a/db/init.c b/db/init.c
index 8bd8e83f6..f240d0f66 100644
--- a/db/init.c
+++ b/db/init.c
@@ -67,13 +67,13 @@ init(
 			force = 1;
 			break;
 		case 'i':
-			x.isreadonly = (LIBXFS_ISREADONLY|LIBXFS_ISINACTIVE);
+			x.flags = LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE;
 			break;
 		case 'p':
 			progname = optarg;
 			break;
 		case 'r':
-			x.isreadonly = LIBXFS_ISREADONLY;
+			x.flags = LIBXFS_ISREADONLY;
 			break;
 		case 'l':
 			x.logname = optarg;
@@ -92,7 +92,7 @@ init(
 		usage();
 
 	x.dname = argv[optind];
-	x.isdirect = LIBXFS_DIRECT;
+	x.flags |= LIBXFS_DIRECT;
 
 	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
 	if (!libxfs_init(&x)) {
diff --git a/db/sb.c b/db/sb.c
index 30709e84e..b2aa4a626 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -374,7 +374,7 @@ uuid_f(
 
 	if (argc == 2) {	/* WRITE UUID */
 
-		if ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode) {
+		if ((x.flags & LIBXFS_ISREADONLY) || !expert_mode) {
 			dbprintf(_("%s: not in expert mode, writing disabled\n"),
 				progname);
 			return 0;
@@ -542,7 +542,7 @@ label_f(
 
 	if (argc == 2) {	/* WRITE LABEL */
 
-		if ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode) {
+		if ((x.flags & LIBXFS_ISREADONLY) || !expert_mode) {
 			dbprintf(_("%s: not in expert mode, writing disabled\n"),
 				progname);
 			return 0;
@@ -727,7 +727,7 @@ version_f(
 
 	if (argc == 2) {	/* WRITE VERSION */
 
-		if ((x.isreadonly & LIBXFS_ISREADONLY) || !expert_mode) {
+		if ((x.flags & LIBXFS_ISREADONLY) || !expert_mode) {
 			dbprintf(_("%s: not in expert mode, writing disabled\n"),
 				progname);
 			return 0;
diff --git a/db/write.c b/db/write.c
index 6c67e839a..96dea7051 100644
--- a/db/write.c
+++ b/db/write.c
@@ -88,7 +88,7 @@ write_f(
 	struct xfs_buf_ops local_ops;
 	const struct xfs_buf_ops *stashed_ops = NULL;
 
-	if (x.isreadonly & LIBXFS_ISREADONLY) {
+	if (x.flags & LIBXFS_ISREADONLY) {
 		dbprintf(_("%s started in read only mode, writing disabled\n"),
 			progname);
 		return 0;
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 802e01154..05aea3496 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -186,7 +186,7 @@ main(int argc, char **argv)
 	xi.dname = datadev;
 	xi.logname = logdev;
 	xi.rtname = rtdev;
-	xi.isreadonly = LIBXFS_ISREADONLY;
+	xi.flags = LIBXFS_ISREADONLY;
 
 	if (!libxfs_init(&xi))
 		usage();
diff --git a/include/libxfs.h b/include/libxfs.h
index 6da8fd1c8..9ee3dd979 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -97,8 +97,7 @@ struct libxfs_init {
 	char            *dname;         /* pathname of data "subvolume" */
 	char            *logname;       /* pathname of log "subvolume" */
 	char            *rtname;        /* pathname of realtime "subvolume" */
-	int             isreadonly;     /* filesystem is only read in applic */
-	int             isdirect;       /* we can attempt to use direct I/O */
+	unsigned	flags;		/* LIBXFS_* flags below */
 	int             disfile;        /* data "subvolume" is a regular file */
 	int             dcreat;         /* try to create data subvolume */
 	int             lisfile;        /* log "subvolume" is a regular file */
@@ -106,7 +105,6 @@ struct libxfs_init {
 	int             risfile;        /* realtime "subvolume" is a reg file */
 	int             rcreat;         /* try to create realtime subvolume */
 	int		setblksize;	/* attempt to set device blksize */
-	int		usebuflock;	/* lock xfs_buf's - for MT usage */
 				/* output results */
 	dev_t           ddev;           /* device for data subvolume */
 	dev_t           logdev;         /* device for log subvolume */
@@ -125,11 +123,23 @@ struct libxfs_init {
 	int		bcache_flags;	/* cache init flags */
 };
 
-#define LIBXFS_ISREADONLY	0x0002	/* disallow all mounted filesystems */
-#define LIBXFS_ISINACTIVE	0x0004	/* allow mounted only if mounted ro */
-#define LIBXFS_DANGEROUSLY	0x0008	/* repairing a device mounted ro    */
-#define LIBXFS_EXCLUSIVELY	0x0010	/* disallow other accesses (O_EXCL) */
-#define LIBXFS_DIRECT		0x0020	/* can use direct I/O, not buffered */
+/* disallow all mounted filesystems: */
+#define LIBXFS_ISREADONLY	(1U << 0)
+
+/* allow mounted only if mounted ro: */
+#define LIBXFS_ISINACTIVE	(1U << 1)
+
+/* repairing a device mounted ro: */
+#define LIBXFS_DANGEROUSLY	(1U << 2)
+
+/* disallow other accesses (O_EXCL): */
+#define LIBXFS_EXCLUSIVELY	(1U << 3)
+
+/* can use direct I/O, not buffered: */
+#define LIBXFS_DIRECT		(1U << 4)
+
+/* lock xfs_buf's - for MT usage */
+#define LIBXFS_USEBUFLOCK	(1U << 5)
 
 extern char	*progname;
 extern xfs_lsn_t libxfs_max_lsn;
diff --git a/libxfs/init.c b/libxfs/init.c
index 86b810bfe..de1e588f1 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -296,7 +296,6 @@ libxfs_init(struct libxfs_init *a)
 	char		*dname;
 	char		*logname;
 	char		*rtname;
-	int		flags;
 
 	dname = a->dname;
 	logname = a->logname;
@@ -306,33 +305,31 @@ libxfs_init(struct libxfs_init *a)
 	a->dsize = a->lbsize = a->rtbsize = 0;
 	a->dbsize = a->logBBsize = a->rtsize = 0;
 
-	flags = (a->isreadonly | a->isdirect);
-
 	rcu_init();
 	rcu_register_thread();
 	radix_tree_init();
 
 	if (dname) {
-		if (!a->disfile && !check_open(dname, flags))
+		if (!a->disfile && !check_open(dname, a->flags))
 			goto done;
-		a->ddev = libxfs_device_open(dname, a->dcreat, flags,
+		a->ddev = libxfs_device_open(dname, a->dcreat, a->flags,
 				a->setblksize);
 		a->dfd = libxfs_device_to_fd(a->ddev);
 		platform_findsizes(dname, a->dfd, &a->dsize, &a->dbsize);
 	}
 	if (logname) {
-		if (!a->lisfile && !check_open(logname, flags))
+		if (!a->lisfile && !check_open(logname, a->flags))
 			goto done;
-		a->logdev = libxfs_device_open(logname, a->lcreat, flags,
+		a->logdev = libxfs_device_open(logname, a->lcreat, a->flags,
 				a->setblksize);
 		a->logfd = libxfs_device_to_fd(a->logdev);
 		platform_findsizes(logname, a->logfd, &a->logBBsize,
 				&a->lbsize);
 	}
 	if (rtname) {
-		if (a->risfile && !check_open(rtname, flags))
+		if (a->risfile && !check_open(rtname, a->flags))
 			goto done;
-		a->rtdev = libxfs_device_open(rtname, a->rcreat, flags,
+		a->rtdev = libxfs_device_open(rtname, a->rcreat, a->flags,
 				a->setblksize);
 		a->rtfd = libxfs_device_to_fd(a->rtdev);
 		platform_findsizes(dname, a->rtfd, &a->rtsize, &a->rtbsize);
@@ -357,7 +354,7 @@ libxfs_init(struct libxfs_init *a)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
 	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
 				   &libxfs_bcache_operations);
-	use_xfs_buf_lock = a->usebuflock;
+	use_xfs_buf_lock = a->flags & LIBXFS_USEBUFLOCK;
 	xfs_dir_startup();
 	init_caches();
 	return 1;
diff --git a/logprint/logprint.c b/logprint/logprint.c
index c2976333d..5349e7838 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -208,7 +208,7 @@ main(int argc, char **argv)
 	if (x.dname == NULL)
 		usage();
 
-	x.isreadonly = LIBXFS_ISINACTIVE;
+	x.flags = LIBXFS_ISINACTIVE;
 	printf(_("xfs_logprint:\n"));
 	if (!libxfs_init(&x))
 		exit(1);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 50b0a7e19..dd5f4c8b6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1984,7 +1984,7 @@ validate_sectorsize(
 	 * host filesystem.
 	 */
 	if (cli->xi->disfile || cli->xi->lisfile || cli->xi->risfile)
-		cli->xi->isdirect = 0;
+		cli->xi->flags &= ~LIBXFS_DIRECT;
 
 	memset(ft, 0, sizeof(*ft));
 	get_topology(cli->xi, ft, force_overwrite);
@@ -4057,8 +4057,7 @@ main(
 	int			worst_freelist = 0;
 
 	struct libxfs_init	xi = {
-		.isdirect = LIBXFS_DIRECT,
-		.isreadonly = LIBXFS_EXCLUSIVELY,
+		.flags = LIBXFS_EXCLUSIVELY | LIBXFS_DIRECT,
 	};
 	struct xfs_mount	mbuf = {};
 	struct xfs_mount	*mp = &mbuf;
diff --git a/repair/init.c b/repair/init.c
index 1c562fb34..2dc439a22 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -72,21 +72,22 @@ xfs_init(struct libxfs_init *args)
 		/* XXX assume data file also means rt file */
 	}
 
-	args->usebuflock = do_prefetch;
 	args->setblksize = 0;
-	args->isdirect = LIBXFS_DIRECT;
 	if (no_modify)
-		args->isreadonly = (LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE);
+		args->flags = LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE;
 	else if (dangerously)
-		args->isreadonly = (LIBXFS_ISINACTIVE | LIBXFS_DANGEROUSLY);
+		args->flags = LIBXFS_ISINACTIVE | LIBXFS_DANGEROUSLY;
 	else
-		args->isreadonly = LIBXFS_EXCLUSIVELY;
+		args->flags = LIBXFS_EXCLUSIVELY;
+	args->flags |= LIBXFS_DIRECT;
+	if (do_prefetch)
+		args->flags |= LIBXFS_USEBUFLOCK;
 
 	if (!libxfs_init(args)) {
 		/* would -d be an option? */
 		if (!no_modify && !dangerously) {
-			args->isreadonly = (LIBXFS_ISINACTIVE |
-					    LIBXFS_DANGEROUSLY);
+			args->flags &= ~LIBXFS_EXCLUSIVELY;
+			args->flags |= LIBXFS_ISINACTIVE | LIBXFS_DANGEROUSLY;
 			if (libxfs_init(args))
 				fprintf(stderr,
 _("Unmount or use the dangerous (-d) option to repair a read-only mounted filesystem\n"));
-- 
2.39.2

