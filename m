Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3BsW9A005568 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 06:54:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EED816CD9F2
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 04:54:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KEWrsN0AVU4T9hil for <xfs@oss.sgi.com>;
	Thu, 03 Nov 2011 04:54:30 -0700 (PDT)
Date: Thu, 3 Nov 2011 07:54:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair fails with corrupt dinode 17491441757, extent total =
	1, nblocks = 0.  This is a bug.
Message-ID: <20111103115429.GA15726@infradead.org>
References: <201110311156.20421.arekm@maven.pl>
	<201111031140.46783.arekm@maven.pl>
	<20111103104850.GA26259@infradead.org>
	<201111031157.39179.arekm@maven.pl>
	<20111103110306.GA8382@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20111103110306.GA8382@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Can you give this patch a quick try on the image in that constrained
setup?



--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=libxfs-estimate-free-memory-better

Index: xfsprogs-dev/libxfs/linux.c
===================================================================
--- xfsprogs-dev.orig/libxfs/linux.c	2011-11-03 12:01:14.213689743 +0100
+++ xfsprogs-dev/libxfs/linux.c	2011-11-03 12:46:56.928191650 +0100
@@ -207,8 +207,13 @@ platform_nproc(void)
 	return sysconf(_SC_NPROCESSORS_ONLN);
 }
 
+/*
+ * Return the memory that we can use freely.
+ *
+ * The return value is in kilobytes.
+ */
 unsigned long
-platform_physmem(void)
+platform_freemem(void)
 {
 	struct sysinfo  si;
 
@@ -217,5 +222,14 @@ platform_physmem(void)
 			progname);
 		exit(1);
 	}
-	return (si.totalram >> 10) * si.mem_unit;	/* kilobytes */
+
+	/*
+	 * Assume we can use memory that is marked free.  This is a very
+	 * conservative approximation given that there might be a lot of
+	 * pagecache that is easily reclaimable, but the only way to figure
+	 * out pagecache size is by parsing /proc/meminfo, and the format
+	 * of that file keeps changing.  This approach is still better than
+	 * guessing based on si.totalram which might be highly overestimated.
+	 */
+	return (si.freeram >> 10) * si.mem_unit;
 }
Index: xfsprogs-dev/include/libxfs.h
===================================================================
--- xfsprogs-dev.orig/include/libxfs.h	2011-11-03 12:29:02.001691672 +0100
+++ xfsprogs-dev/include/libxfs.h	2011-11-03 12:31:49.780691838 +0100
@@ -475,7 +475,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE
 
 #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
 extern int		libxfs_nproc(void);
-extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
+extern unsigned long	libxfs_freemem(void);	/* in kilobytes */
 
 #include <xfs/xfs_ialloc.h>
 #include <xfs/xfs_rtalloc.h>
Index: xfsprogs-dev/libxfs/darwin.c
===================================================================
--- xfsprogs-dev.orig/libxfs/darwin.c	2011-11-03 12:29:02.017691106 +0100
+++ xfsprogs-dev/libxfs/darwin.c	2011-11-03 12:40:10.720691752 +0100
@@ -128,18 +128,27 @@ platform_nproc(void)
 	return ncpu;
 }
 
+/*
+ * Return the memory that we can use freely.
+ *
+ * The return value is in kilobytes.
+ */
 unsigned long
-platform_physmem(void)
+platform_freemem(void)
 {
-	unsigned long	physmem;
-	size_t		len = sizeof(physmem);
+	unsigned long	freemem;
+	size_t		len = sizeof(freemem);
 	static int	mib[2] = {CTL_HW, HW_PHYSMEM};
 
-	if (sysctl(mib, 2, &physmem, &len, NULL, 0) < 0) {
+	if (sysctl(mib, 2, &freemem, &len, NULL, 0) < 0) {
 		fprintf(stderr, _("%s: can't determine memory size\n"),
 			progname);
 		exit(1);
 	}
-	return physmem >> 10;
+
+ 	/*
+	 * Assume we can use approximately 3/4 of the physical memory.
+	 */
+	return (freemem >> (10 + 2)) * 3;
 }
 
Index: xfsprogs-dev/libxfs/freebsd.c
===================================================================
--- xfsprogs-dev.orig/libxfs/freebsd.c	2011-11-03 12:29:02.037693919 +0100
+++ xfsprogs-dev/libxfs/freebsd.c	2011-11-03 12:40:19.000190942 +0100
@@ -187,17 +187,26 @@ platform_nproc(void)
 	return ncpu;
 }
 
+/*
+ * Return the memory that we can use freely.
+ *
+ * The return value is in kilobytes.
+ */
 unsigned long
-platform_physmem(void)
+platform_freemem(void)
 {
-	unsigned long	physmem;
-	size_t		len = sizeof(physmem);
+	unsigned long	freemem;
+	size_t		len = sizeof(freemem);
 	static int	mib[2] = {CTL_HW, HW_PHYSMEM};
 
-	if (sysctl(mib, 2, &physmem, &len, NULL, 0) < 0) {
+	if (sysctl(mib, 2, &freemem, &len, NULL, 0) < 0) {
 		fprintf(stderr, _("%s: can't determine memory size\n"),
 			progname);
 		exit(1);
 	}
-	return physmem >> 10;
+
+ 	/*
+	 * Assume we can use approximately 3/4 of the physical memory.
+	 */
+	return (freemem >> (10 + 2)) * 3;
 }
Index: xfsprogs-dev/libxfs/init.c
===================================================================
--- xfsprogs-dev.orig/libxfs/init.c	2011-11-03 12:29:02.057690208 +0100
+++ xfsprogs-dev/libxfs/init.c	2011-11-03 12:29:50.044192568 +0100
@@ -862,7 +862,7 @@ libxfs_nproc(void)
 }
 
 unsigned long
-libxfs_physmem(void)
+libxfs_freemem(void)
 {
-	return platform_physmem();
+	return platform_freemem();
 }
Index: xfsprogs-dev/libxfs/init.h
===================================================================
--- xfsprogs-dev.orig/libxfs/init.h	2011-11-03 12:29:02.077690698 +0100
+++ xfsprogs-dev/libxfs/init.h	2011-11-03 12:29:52.296691230 +0100
@@ -32,7 +32,7 @@ extern char *platform_findblockpath (cha
 extern int platform_direct_blockdev (void);
 extern int platform_align_blockdev (void);
 extern int platform_nproc(void);
-extern unsigned long platform_physmem(void);	/* in kilobytes */
+extern unsigned long platform_freemem(void);	/* in kilobytes */
 extern int platform_has_uuid;
 
 #endif	/* LIBXFS_INIT_H */
Index: xfsprogs-dev/libxfs/irix.c
===================================================================
--- xfsprogs-dev.orig/libxfs/irix.c	2011-11-03 12:29:02.097691363 +0100
+++ xfsprogs-dev/libxfs/irix.c	2011-11-03 12:42:59.724691783 +0100
@@ -97,8 +97,13 @@ platform_nproc(void)
 	return sysmp(MP_NPROCS);
 }
 
+/*
+ * Return the memory that we can use freely.
+ *
+ * The return value is in kilobytes.
+ */
 unsigned long
-platform_physmem(void)
+platform_freemem(void)
 {
 	struct rminfo ri;
 
@@ -107,5 +112,9 @@ platform_physmem(void)
 			progname);
 		exit(1);
 	}
-	return (ri.physmem >> 10) * getpagesize();	/* kilobytes */
-}
\ No newline at end of file
+
+	/*
+	 * Assume we can use all free memory.
+	 */
+	return (ri.freemem >> 10) * getpagesize();	/* kilobytes */
+}
Index: xfsprogs-dev/repair/xfs_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/xfs_repair.c	2011-11-03 12:29:02.117690613 +0100
+++ xfsprogs-dev/repair/xfs_repair.c	2011-11-03 12:32:42.348190446 +0100
@@ -631,8 +631,11 @@ main(int argc, char **argv)
 		mem_used = (mp->m_sb.sb_icount >> (10 - 2)) +
 					(mp->m_sb.sb_dblocks >> (10 + 1)) +
 					50000;	/* rough estimate of 50MB overhead */
-		max_mem = max_mem_specified ? max_mem_specified * 1024 :
-						libxfs_physmem() * 3 / 4;
+
+		if (max_mem_specified)
+			max_mem = max_mem_specified * 1024;
+		else
+			max_mem = libxfs_freemem();
 
 		if (getrlimit(RLIMIT_AS, &rlim) != -1 &&
 					rlim.rlim_cur != RLIM_INFINITY) {

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--zYM0uCDKw75PZbzx--
