Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD3A17F63
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 08:06:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 682F1AC002
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 06:06:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VexGRq5rmYH5Z70c for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 06:06:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkwNX-0005aQ-HV
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkwNX-0003pA-D8
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfstests: add a multithreaded mode to bstat
Date: Fri,  7 Jun 2013 23:06:38 +1000
Message-Id: <1370610398-14630-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1370610398-14630-1-git-send-email-david@fromorbit.com>
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

For benchmarking of bulkstat, add a multithreaded mode that spawns a
thread per AG and runs bulkstat on every AG in parallel. There is a
small amount of overlap between each AG because of the way the
interface works only on inode numbers, so some inodes are reported
twice. A real implementation of this sort of parallelism would be
greatly helped by adding an AG parameter to the bulkstat interface.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 src/Makefile |    2 +-
 src/bstat.c  |  388 +++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 302 insertions(+), 88 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index c18ffc9..243a432 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -22,7 +22,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 
 SUBDIRS =
 
-LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
+LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL) -lpthread
 
 ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
 LINUX_TARGETS += loggen
diff --git a/src/bstat.c b/src/bstat.c
index 4e22ecd..0fc7d9d 100644
--- a/src/bstat.c
+++ b/src/bstat.c
@@ -18,6 +18,60 @@
 
 #include "global.h"
 #include <xfs/jdm.h>
+#include <pthread.h>
+
+
+int	debug;
+int	quiet;
+int	statit;
+int	verbose;
+int	threaded;
+
+unsigned int
+libxfs_log2_roundup(unsigned int i)
+{
+	unsigned int    rval;
+
+	for (rval = 0; rval < NBBY * sizeof(i); rval++) {
+		if ((1 << rval) >= i)
+			break;
+	}
+	return rval;
+}
+static inline int fls(int x)
+{
+	int r = 32;
+
+	if (!x)
+		return 0;
+	if (!(x & 0xffff0000u)) {
+		x <<= 16;
+		r -= 16;
+	}
+	if (!(x & 0xff000000u)) {
+		x <<= 8;
+		r -= 8;
+	}
+	if (!(x & 0xf0000000u)) {
+		x <<= 4;
+		r -= 4;
+	}
+	if (!(x & 0xc0000000u)) {
+		x <<= 2;
+		r -= 2;
+	}
+	if (!(x & 0x80000000u)) {
+		x <<= 1;
+		r -= 1;
+	}
+	return r;
+}
+
+static inline int xfs_highbit32(__uint32_t v)
+{
+	return fls(v) - 1;
+}
+
 
 void
 dotime(void *ti, char *s)
@@ -62,87 +116,21 @@ printstat(struct stat64 *sp)
 	dotime(&sp->st_ctime, "ctime");
 }
 
-int
-main(int argc, char **argv)
+static int
+do_bstat(
+	int		fsfd,
+	jdm_fshandle_t	*fshandlep,
+	char		*name,
+	int		nent,
+	__u64		first,
+	__u64		last)
 {
 	__s32		count;
 	int		total = 0;
-	int		fsfd;
-	int		i;
-	__u64		last = 0;
-	char		*name;
-	int		nent;
-	int		debug = 0;
-	int		quiet = 0;
-	int		statit = 0;
-	int		verbose = 0;
 	xfs_bstat_t	*t;
 	int		ret;
-	jdm_fshandle_t	*fshandlep = NULL;
-	int		fd;
-	struct stat64	sb;
-	int nread;
-	char *cc_readlinkbufp;
-	int cc_readlinkbufsz;
-	int 		c;
 	xfs_fsop_bulkreq_t bulkreq;
-
-	while ((c = getopt(argc, argv, "cdl:qv")) != -1) {
-		switch (c) {
-		case 'q':
-			quiet = 1;
-			break;
-		case 'v':
-			verbose = 1;
-			break;
-		case 'c':
-			statit = 1;
-			break;
-		case 'd':
-			debug = 1;
-			break;
-		case 'l':
-			last = atoi(optarg);
-			break;
-		case '?':
-		printf("usage: xfs_bstat [-c] [-q] [-v] [ dir [ batch_size ]]\n");
-		printf("   -c   Check the results against stat(3) output\n");
-		printf("   -q   Quiet\n");
-		printf("   -l _num_  Inode to start with\n");
-		printf("   -v   Verbose output\n");
-			exit(1);
-		}
-	}
-	argc -= optind;
-	argv += optind;
-
-	if (argc < 1)
-		name = ".";
-	else
-		name = *argv;
-
-	fsfd = open(name, O_RDONLY);
-	if (fsfd < 0) {
-		perror(name);
-		exit(1);
-	}
-	if (argc < 2)
-		nent = 4096;
-	else
-		nent = atoi(*++argv);
-
-	if (verbose)
-		printf("Bulkstat test on %s, batch size=%d statcheck=%d\n", 
-			name, nent, statit);
-
-	if (statit) {
-		fshandlep = jdm_getfshandle( name );
-		if (! fshandlep) {
-			printf("unable to construct sys handle for %s: %s\n",
-			  name, strerror(errno));
-			return -1;
-		}
-	}
+	__u64		ino;
 
 	t = malloc(nent * sizeof(*t));
 
@@ -150,23 +138,27 @@ main(int argc, char **argv)
 		printf(
 		  "XFS_IOC_FSBULKSTAT test: last=%lld nent=%d\n", (long long)last, nent);
 
-	bulkreq.lastip  = &last;
+	ino = first;
+
+	bulkreq.lastip  = &ino;
 	bulkreq.icount  = nent;
 	bulkreq.ubuffer = t;
 	bulkreq.ocount  = &count;
 
 	while ((ret = xfsctl(name, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
+		int		i;
+
 		total += count;
 
 		if (verbose)
 			printf(
-	    "XFS_IOC_FSBULKSTAT test: last=%lld ret=%d count=%d total=%d\n", 
-						(long long)last, ret, count, total);
+    "XFS_IOC_FSBULKSTAT test: first/last/ino=%lld/%lld/%lld ret=%d count=%d total=%d\n", 
+			(long long)first, (long long)last, (long long)ino, ret, count, total);
 		if (count == 0)
-			exit(0);
+			break;
 
 		if ( quiet && ! statit )
-			continue;
+			goto next;
 
 		for (i = 0; i < count; i++) {
 			if (! quiet) {
@@ -174,6 +166,12 @@ main(int argc, char **argv)
 			}
 	
 			if (statit) {
+				char *cc_readlinkbufp;
+				int cc_readlinkbufsz;
+				struct stat64	sb;
+				int nread;
+				int		fd;
+
 				switch(t[i].bs_mode & S_IFMT) {
 				case S_IFLNK:
 					cc_readlinkbufsz = MAXPATHLEN;
@@ -244,10 +242,231 @@ main(int argc, char **argv)
 				}
 			}
 		}
-
+next:
 		if (debug)
 			break;
+
+		if (ino >= last)
+			break;
 	}
+	if (verbose)
+		printf(
+	    "XFS_IOC_FSBULKSTAT test: last=%lld nent=%d ret=%d count=%d\n", 
+					       (long long)last, nent, ret, count);
+
+	return total;
+}
+
+struct thread_args {
+	pthread_t	tid;
+	int		fsfd;
+	jdm_fshandle_t	*fshandlep;
+	char		*name;
+	int		nent;
+	__u64		first;
+	__u64		last;
+	int		ret;
+};
+
+static void *
+do_bstat_thread(
+	void	*args)
+{
+	struct thread_args *targs = args;
+
+	targs->ret = do_bstat(targs->fsfd, targs->fshandlep, targs->name,
+			      targs->nent, targs->first, targs->last);
+	return NULL;
+}
+
+/*
+ *   XFS_AGINO_TO_INO(mp,a,i)        \
+ *           (((xfs_ino_t)(a) << XFS_INO_AGINO_BITS(mp)) | (i))
+ *
+ * 	i always zero, so:
+ * 			a << XFS_INO_AGINO_BITS(mp)
+ *
+ *   XFS_INO_AGINO_BITS(mp)          (mp)->m_agino_log
+ *
+ *   mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog
+ *
+ *   sb_inopblog = fsgeom.blocksize / fsgeom.inodesize
+ *   sb_agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)fsgeom.agblocks);
+ *
+ *	a << (libxfs_highbit32(fsgeom.blocksize /fsgeom.inodesize) +
+ *				libxfs_log2_roundup(fsgeom.agblocks));
+ */
+#define FSGEOM_INOPBLOG(fsg) \
+		(xfs_highbit32((fsg).blocksize / (fsg).inodesize))
+#define FSGEOM_AGINO_TO_INO(fsg, a, i) \
+	(((__u64)(a) << (FSGEOM_INOPBLOG(fsg) + \
+			libxfs_log2_roundup((fsg).agblocks))) | (i))
+
+/*
+ *    XFS_OFFBNO_TO_AGINO(mp,b,o)     \                                        
+ *            ((xfs_agino_t)(((b) << XFS_INO_OFFSET_BITS(mp)) | (o)))
+ *
+ *       i always zero, so:
+ *			b << XFS_INO_OFFSET_BITS(mp)
+ *
+ *    XFS_INO_OFFSET_BITS(mp)         (mp)->m_sb.sb_inopblog
+ */
+#define FSGEOM_OFFBNO_TO_AGINO(fsg, b, o) \
+		((__u32)(((b) << FSGEOM_INOPBLOG(fsg)) | (o)))
+static int
+do_threads(
+	int		fsfd,
+	jdm_fshandle_t	*fshandlep,
+	char		*name,
+	int		nent,
+	__u64		first)
+{
+	struct xfs_fsop_geom geom;
+	struct thread_args *targs;
+	int		ret;
+	int		i;
+	int		numthreads;
+	int		total = 0;
+
+
+	/* get number of AGs */
+	ret = ioctl(fsfd, XFS_IOC_FSGEOMETRY, &geom);
+	if (ret) {
+		perror("XFS_IOC_FSGEOMETRY");
+		exit(1);
+	}
+
+	/* allocate thread array */
+	targs = malloc(geom.agcount * sizeof(*targs));
+	if (ret) {
+		perror("malloc(targs)");
+		exit(1);
+	}
+
+	for (i = 0; i < geom.agcount; i++) {
+		__u64 last;
+
+		last = FSGEOM_AGINO_TO_INO(geom, i,
+					   FSGEOM_OFFBNO_TO_AGINO(geom,
+						       geom.agblocks - 1, 0));
+
+		if (first > last) {
+			i--;
+			continue;
+		}
+		first = MAX(first, FSGEOM_AGINO_TO_INO(geom, i, 0));
+
+		targs[i].fsfd = fsfd;
+		targs[i].fshandlep = fshandlep;
+		targs[i].name = name;
+		targs[i].nent = nent;
+		targs[i].first = first;
+		targs[i].last = last;
+		targs[i].ret = 0;
+	}
+	numthreads = i;
+
+	/* start threads */
+	for (i = 0; i< numthreads; i++) {
+		ret = pthread_create(&targs[i].tid, NULL, do_bstat_thread, &targs[i]);
+		if (ret) {
+			perror("pthread-create");
+			exit(1);
+		}
+	}
+
+
+	/* join threads */
+	for (i = 0; i < numthreads; i++) {
+		if (targs[i].tid) {
+			pthread_join(targs[i].tid, NULL);
+			total += targs[i].ret;
+		}
+	}
+
+	/* die */
+	return total;
+}
+
+
+int
+main(int argc, char **argv)
+{
+	int		fsfd;
+	__u64		first = 0;
+	char		*name;
+	int		nent;
+	int		ret;
+	jdm_fshandle_t	*fshandlep = NULL;
+	int 		c;
+
+	while ((c = getopt(argc, argv, "cdl:qtv")) != -1) {
+		switch (c) {
+		case 'q':
+			quiet = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'c':
+			statit = 1;
+			break;
+		case 'd':
+			debug = 1;
+			break;
+		case 'l':
+			first = atoi(optarg);
+			break;
+		case 't':
+			threaded = 1;
+			break;
+		case '?':
+		printf("usage: xfs_bstat [-c] [-q] [-v] [ dir [ batch_size ]]\n");
+		printf("   -c   Check the results against stat(3) output\n");
+		printf("   -q   Quiet\n");
+		printf("   -l _num_  Inode to start with\n");
+		printf("   -v   Verbose output\n");
+			exit(1);
+		}
+	}
+	argc -= optind;
+	argv += optind;
+
+	if (argc < 1)
+		name = ".";
+	else
+		name = *argv;
+
+	fsfd = open(name, O_RDONLY);
+	if (fsfd < 0) {
+		perror(name);
+		exit(1);
+	}
+	if (argc < 2)
+		nent = 4096;
+	else
+		nent = atoi(*++argv);
+
+	if (verbose)
+		printf("Bulkstat test on %s, batch size=%d statcheck=%d\n", 
+			name, nent, statit);
+
+	if (statit) {
+		fshandlep = jdm_getfshandle( name );
+		if (! fshandlep) {
+			printf("unable to construct sys handle for %s: %s\n",
+			  name, strerror(errno));
+			return -1;
+		}
+	}
+
+	if (threaded)
+		ret = do_threads(fsfd, fshandlep, name, nent, first);
+	else
+		ret = do_bstat(fsfd, fshandlep, name, nent, first, -1LL);
+
+	if (verbose)
+		printf("Bulkstat found %d inodes\n", ret);
 
 	if (fsfd)
 		close(fsfd);
@@ -255,10 +474,5 @@ main(int argc, char **argv)
 	if (ret < 0 )
 		perror("xfsctl(XFS_IOC_FSBULKSTAT)");
 
-	if (verbose)
-		printf(
-	    "XFS_IOC_FSBULKSTAT test: last=%lld nent=%d ret=%d count=%d\n", 
-					       (long long)last, nent, ret, count);
-
-	return 1;
+	return 0;
 }
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
