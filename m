Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9E74028F2
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 08:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788768068; cv=none; b=lF2ztq8bDySD2Pjq3xapMT/vevHxqUM4hk5p4MrGyGO7tkvX0/vPbVtmeVipMM+G75r5rOfSF8/sNZVJ7geSSKU+GbMBrzelGfke+YI9axXp/kpIDK1MWd99Um0Yd3XWDYvWQWfvfZGKGnhU4NDPfqGygqEZQc1nQ8hSRJ9Cca8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788768068; c=relaxed/simple;
	bh=PtjNZqMQQiAfg7DvITLF8dp5u+nnWtdT0HqI4qL2moc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BdNF5Dxq6HtzfHlQjrIMiYdW9Fh18Ej96P0gd9UaZjx571VeYW3QEmGcFpWA03BrhZ5RiZxf/ePg6keVY9HOHpUFbbf311giZGxzUYPA2u8g8OBIb/F6sykRei1vg7nkjxbzNx4/U2gTf1mqs11CofsMy4tmlwGJugNzmegnll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SvBey8mN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SvBey8mN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Km1AcRy68j68nxt3xy7EDcl7FgdrVE1wbW1tQ8r53G8=; b=SvBey8mNEKqhCXkWkktoKkGOCw
	DLnrnoG7tPIlU+S/aqTFyE2PM59l1iideFINTZelBj5Cbd5xsI3Z5oOCwHhwmTaOIFv12JZyQgDvF
	vTCoWQzhESvkLB8wamuYPAuGyI2yctqwk6QIUOdzkiY94/9KOtQdKQxya0LwNtSjpeGkRblLIU7IM
	ubD0f0rJM8oM2JM8vwCPjyCB+gh/MSrbZ9edgCv68U8QRM3cQZ7fLAINgKbkq+x8jeEgk3FrRL9EU
	PGPb40EjG8cSNnFh+0KD+6SaiD42pF7hup5m6QIRqtl7TJenEH0lr6T7GA8uoZWQyGHz8es13W0wH
	+eW/hJpw==;
Received: from [93.123.20.121] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3UHo-00000006DQx-209t;
	Mon, 07 Sep 2026 08:01:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_io: cleanup headers
Date: Mon,  7 Sep 2026 11:01:00 +0300
Message-ID: <20260907080100.749981-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Drop extra externs and deep tab indentation of the function and
variable names.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io/init.h |  10 ++--
 io/io.h   | 164 +++++++++++++++++++++++++++---------------------------
 2 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/io/init.h b/io/init.h
index d4d1968cc1e1..97a93761d64f 100644
--- a/io/init.h
+++ b/io/init.h
@@ -8,10 +8,10 @@
 #define CMD_NOMAP_OK	(1<<1)	/* command doesn't need a mapped region	*/
 #define CMD_FOREIGN_OK	CMD_FLAG_FOREIGN_OK
 
-extern char	*progname;
-extern int	exitcode;
-extern int	expert;
-extern size_t	pagesize;
+extern char *progname;
+extern int exitcode;
+extern int expert;
+extern size_t pagesize;
 extern struct timeval stopwatch;
 
-extern void init_cvtnum(size_t *blocksize, size_t *sectsize);
+void init_cvtnum(size_t *blocksize, size_t *sectsize);
diff --git a/io/io.h b/io/io.h
index 5f1f278d14a0..50e01b3cd229 100644
--- a/io/io.h
+++ b/io/io.h
@@ -45,11 +45,13 @@ typedef struct fileio {
 	struct fs_path	fs_path;	/* XFS path information */
 } fileio_t;
 
-extern fileio_t		*filetable;	/* open file table */
-extern int		filecount;	/* number of open files */
-extern fileio_t		*file;		/* active file in file table */
-extern int filelist_f(void);
-extern int stat_f(int argc, char **argv);
+extern fileio_t *filetable;	/* open file table */
+extern int filecount;		/* number of open files */
+extern fileio_t *file;		/* active file in file table */
+
+int filelist_f(void);
+int stat_f(int argc, char **argv);
+
 /*
  * Memory mapped file regions
  */
@@ -62,111 +64,109 @@ typedef struct mmap_region {
 	char		*name;		/* name of backing file */
 } mmap_region_t;
 
-extern mmap_region_t	*maptable;	/* mmap'd region array */
-extern int		mapcount;	/* #entries in the mapping table */
-extern mmap_region_t	*mapping;	/* active mapping table entry */
-extern int maplist_f(void);
-extern void *check_mapping_range(mmap_region_t *, off_t, size_t, int);
+extern mmap_region_t *maptable;	/* mmap'd region array */
+extern int mapcount;		/* #entries in the mapping table */
+extern mmap_region_t *mapping;	/* active mapping table entry */
+
+int maplist_f(void);
+void *check_mapping_range(mmap_region_t *, off_t, size_t, int);
 
 /*
  * Various xfs_io helper routines/globals
  */
 
-extern off_t		filesize(void);
-extern int		openfile(char *, struct xfs_fsop_geom *, int, mode_t,
-				 struct fs_path *);
-extern int		addfile(char *, int , struct xfs_fsop_geom *, int,
-				struct fs_path *);
-extern int		closefile(void);
-extern void		print_xflags(uint, int, int, const char *, int, int);
-
-extern unsigned int	recurse_all;
-extern unsigned int	recurse_dir;
-
-extern void		*io_buffer;
-extern size_t		io_buffersize;
-extern int		vectors;
-extern struct iovec	*iov;
-extern int		alloc_buffer(size_t, int, unsigned int);
-extern int		read_buffer(int, off_t, long long, long long *,
-					int, int);
-extern void		dump_buffer(off_t, ssize_t);
-
-extern void		attr_init(void);
-extern void		bmap_init(void);
-extern void		encrypt_init(void);
-extern void		file_init(void);
-extern void		flink_init(void);
-extern void		freeze_init(void);
-extern void		fsuuid_init(void);
-extern void		fsync_init(void);
-extern void		getrusage_init(void);
-extern void		help_init(void);
-extern void		imap_init(void);
-extern void		inject_init(void);
-extern void		label_init(void);
-extern void		mmap_init(void);
-extern void		open_init(void);
-extern void		parent_init(void);
-extern void		pread_init(void);
-extern void		prealloc_init(void);
-extern void		pwrite_init(void);
-extern void		quit_init(void);
-extern void		resblks_init(void);
-extern void		seek_init(void);
-extern void		shutdown_init(void);
-extern void		stat_init(void);
-extern void		swapext_init(void);
-extern void		sync_init(void);
-extern void		truncate_init(void);
-extern void		utimes_init(void);
-extern void		fadvise_init(void);
-extern void		sendfile_init(void);
-extern void		madvise_init(void);
-extern void		mincore_init(void);
-extern void		fiemap_init(void);
+off_t  filesize(void);
+int openfile(char *, struct xfs_fsop_geom *, int, mode_t, struct fs_path *);
+int addfile(char *, int , struct xfs_fsop_geom *, int, struct fs_path *);
+int closefile(void);
+void print_xflags(uint, int, int, const char *, int, int);
+
+extern unsigned int recurse_all;
+extern unsigned int recurse_dir;
+
+extern void *io_buffer;
+extern size_t io_buffersize;
+extern int vectors;
+extern struct iovec *iov;
+
+int alloc_buffer(size_t, int, unsigned int);
+int read_buffer(int, off_t, long long, long long *, int, int);
+void dump_buffer(off_t, ssize_t);
+void attr_init(void);
+void bmap_init(void);
+void encrypt_init(void);
+void file_init(void);
+void flink_init(void);
+void freeze_init(void);
+void fsuuid_init(void);
+void fsync_init(void);
+void getrusage_init(void);
+void help_init(void);
+void imap_init(void);
+void inject_init(void);
+void label_init(void);
+void mmap_init(void);
+void open_init(void);
+void parent_init(void);
+void pread_init(void);
+void prealloc_init(void);
+void pwrite_init(void);
+void quit_init(void);
+void resblks_init(void);
+void seek_init(void);
+void shutdown_init(void);
+void stat_init(void);
+void swapext_init(void);
+void sync_init(void);
+void truncate_init(void);
+void utimes_init(void);
+void fadvise_init(void);
+void sendfile_init(void);
+void madvise_init(void);
+void mincore_init(void);
+void fiemap_init(void);
 
 #ifdef HAVE_COPY_FILE_RANGE
-extern void		copy_range_init(void);
+void copy_range_init(void);
 #else
 #define copy_range_init()	do { } while (0)
 #endif
 
 #ifdef HAVE_CACHESTAT
-extern void cachestat_init(void);
+void cachestat_init(void);
 #else
 #define cachestat_init() do { } while (0)
 #endif
 
-extern void		sync_range_init(void);
-extern void		readdir_init(void);
-extern void		reflink_init(void);
-extern void		cowextsize_init(void);
+void sync_range_init(void);
+void readdir_init(void);
+void reflink_init(void);
+void cowextsize_init(void);
 
 #ifdef HAVE_GETFSMAP
-extern void		fsmap_init(void);
+void fsmap_init(void);
 #else
 # define fsmap_init()	do { } while (0)
 #endif
 
 #ifdef HAVE_DEVMAPPER
-extern void		log_writes_init(void);
+void log_writes_init(void);
 #else
 #define log_writes_init()      do { } while (0)
 #endif
 
-extern void		scrub_init(void);
-extern void		repair_init(void);
-extern void		crc32cselftest_init(void);
-extern void		bulkstat_init(void);
-void			exchangerange_init(void);
-void			fsprops_init(void);
-void			aginfo_init(void);
-void			healthmon_init(void);
-void			verifymedia_init(void);
+void scrub_init(void);
+void repair_init(void);
+void crc32cselftest_init(void);
+void bulkstat_init(void);
+void exchangerange_init(void);
+void fsprops_init(void);
+void aginfo_init(void);
+void healthmon_init(void);
+void verifymedia_init(void);
 
 #ifdef HAVE_LISTMOUNT
-void			listmount_init(void);
+void listmount_init(void);
 #else
-# define		listmount_init()	do { } while (0)
+# define listmount_init()	do { } while (0)
 #endif
-- 
2.53.0

