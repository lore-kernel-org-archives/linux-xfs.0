Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17IMTJB251229 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 12:22:30 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ep775X18yzTrCY0I (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 10:22:28 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RupgS-0004ti-91
	for xfs@oss.sgi.com; Tue, 07 Feb 2012 18:22:28 +0000
Date: Tue, 7 Feb 2012 13:22:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] libxfs: stop caching inode structures
Message-ID: <20120207182228.GA18801@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently libxfs has a cache for xfs_inode structures.  Unlike in kernelspace
where the inode cache, and the associated page cache for file data is used
for all filesystem operations the libxfs inode cache is only used in few
places:

 - the libxfs init code reads the root and realtime inodes when called from
   xfs_db using a special flag, but these inode structure are never referenced
   again
 - mkfs uses namespace and bmap routines that take the xfs_inode structure
   to create the root and realtime inodes, as well as any additional files
   specified in the proto file
 - the xfs_db attr code uses xfs_inode-based attr routines in the attrset
   and attrget commands
 - phase6 of xfs_repair uses xfs_inode-based routines for rebuilding
   directories and moving files to the lost+found directory.
 - phase7 of xfs_repair uses struct xfs_inode to modify the nlink count
   of inodes.

So except in repair we never ever reuse a cached inode, and in repair we can
easily read the information from the more compact cached buffers (or even
better rewrite phase7 to operate on the raw on-disk inodes).  Given these
facts stop caching the inodes to reduce memory usage especially in xfs_repair.

With this we probably could increase the memory available to the buffer
cache in xfs_repair, but trying to do so I got a bit lost - the current
formula seems to magic to me to make any sense, and simply doubling the
buffer cache size causes us to run out of memory given that the data cached
in the buffer cache (typically lots of 8k inode buffers and few 4k other
metadata buffers) are much bigger than the inodes cached in the inode
cache.  We probably need a sizing scheme that takes the actual amount
of memory allocated to the buffer cache into account to solve this better.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/include/libxfs.h
===================================================================
--- xfsprogs-dev.orig/include/libxfs.h	2012-02-06 15:22:51.000000000 +0000
+++ xfsprogs-dev/include/libxfs.h	2012-02-06 15:31:05.000000000 +0000
@@ -207,7 +207,6 @@ typedef struct xfs_mount {
 #define LIBXFS_MOUNT_COMPAT_ATTR	0x0010
 #define LIBXFS_MOUNT_ATTR2		0x0020
 
-#define LIBXFS_IHASHSIZE(sbp)		(1<<10)
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
 extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
@@ -335,7 +334,6 @@ extern int	libxfs_writebuf_int(xfs_buf_t
 extern int	libxfs_readbufr(dev_t, xfs_daddr_t, xfs_buf_t *, int, int);
 
 extern int libxfs_bhash_size;
-extern int libxfs_ihash_size;
 
 #define LIBXFS_BREAD	0x1
 #define LIBXFS_BWRITE	0x2
@@ -455,9 +453,6 @@ extern int	libxfs_iread (xfs_mount_t *,
 				xfs_inode_t *, xfs_daddr_t);
 
 /* Inode Cache Interfaces */
-extern struct cache	*libxfs_icache;
-extern struct cache_operations	libxfs_icache_operations;
-extern void	libxfs_icache_purge (void);
 extern int	libxfs_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
 				uint, xfs_inode_t **, xfs_daddr_t);
 extern void	libxfs_iput (xfs_inode_t *, uint);
Index: xfsprogs-dev/libxfs/init.c
===================================================================
--- xfsprogs-dev.orig/libxfs/init.c	2012-02-06 15:22:51.000000000 +0000
+++ xfsprogs-dev/libxfs/init.c	2012-02-06 15:30:51.000000000 +0000
@@ -22,9 +22,6 @@
 
 char *progname = "libxfs";	/* default, changed by each tool */
 
-struct cache *libxfs_icache;	/* global inode cache */
-int libxfs_ihash_size;		/* #buckets in icache */
-
 struct cache *libxfs_bcache;	/* global buffer cache */
 int libxfs_bhash_size;		/* #buckets in bcache */
 
@@ -333,9 +330,6 @@ libxfs_init(libxfs_init_t *a)
 	}
 	if (needcd)
 		chdir(curdir);
-	if (!libxfs_ihash_size)
-		libxfs_ihash_size = LIBXFS_IHASHSIZE(sbp);
-	libxfs_icache = cache_init(libxfs_ihash_size, &libxfs_icache_operations);
 	if (!libxfs_bhash_size)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
 	libxfs_bcache = cache_init(libxfs_bhash_size, &libxfs_bcache_operations);
@@ -817,7 +811,6 @@ libxfs_umount(xfs_mount_t *mp)
 	int			agno;
 
 	libxfs_rtmount_destroy(mp);
-	libxfs_icache_purge();
 	libxfs_bcache_purge();
 
 	for (agno = 0; agno < mp->m_maxagi; agno++) {
@@ -833,7 +826,6 @@ void
 libxfs_destroy(void)
 {
 	manage_zones(1);
-	cache_destroy(libxfs_icache);
 	cache_destroy(libxfs_bcache);
 }
 
@@ -849,7 +841,6 @@ libxfs_report(FILE *fp)
 	time_t t;
 	char *c;
 
-	cache_report(fp, "libxfs_icache", libxfs_icache);
 	cache_report(fp, "libxfs_bcache", libxfs_bcache);
 
 	t = time(NULL);
Index: xfsprogs-dev/libxfs/rdwr.c
===================================================================
--- xfsprogs-dev.orig/libxfs/rdwr.c	2012-02-06 15:22:07.000000000 +0000
+++ xfsprogs-dev/libxfs/rdwr.c	2012-02-06 15:29:03.000000000 +0000
@@ -710,58 +710,29 @@ struct cache_operations libxfs_bcache_op
 
 
 /*
- * Inode cache interfaces
+ * Inode cache stubs.
  */
 
 extern kmem_zone_t	*xfs_ili_zone;
 extern kmem_zone_t	*xfs_inode_zone;
 
-static unsigned int
-libxfs_ihash(cache_key_t key, unsigned int hashsize)
-{
-	return ((unsigned int)*(xfs_ino_t *)key) % hashsize;
-}
-
-static int
-libxfs_icompare(struct cache_node *node, cache_key_t key)
-{
-	xfs_inode_t	*ip = (xfs_inode_t *)node;
-
-	return (ip->i_ino == *(xfs_ino_t *)key);
-}
-
 int
 libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
 		xfs_inode_t **ipp, xfs_daddr_t bno)
 {
-	xfs_inode_t	*ip;
 	int		error = 0;
 
-	if (cache_node_get(libxfs_icache, &ino, (struct cache_node **)&ip)) {
-#ifdef INO_DEBUG
-		fprintf(stderr, "%s: allocated inode, ino=%llu(%llu), %p\n",
-			__FUNCTION__, (unsigned long long)ino, bno, ip);
-#endif
-		if ((error = libxfs_iread(mp, tp, ino, ip, bno))) {
-			cache_node_purge(libxfs_icache, &ino,
-					(struct cache_node *)ip);
-			ip = NULL;
-		}
+	*ipp = kmem_zone_zalloc(xfs_inode_zone, 0);
+	if (!*ipp)
+		return ENOMEM;
+
+	error = libxfs_iread(mp, tp, ino, *ipp, bno);
+	if (error) {
+		kmem_zone_free(xfs_inode_zone, *ipp);
+		*ipp = NULL;
 	}
-	*ipp = ip;
-	return error;
-}
-
-void
-libxfs_iput(xfs_inode_t *ip, uint lock_flags)
-{
-	cache_node_put(libxfs_icache, (struct cache_node *)ip);
-}
 
-static struct cache_node *
-libxfs_ialloc(cache_key_t key)
-{
-	return kmem_zone_zalloc(xfs_inode_zone, 0);
+	return error;
 }
 
 static void
@@ -778,32 +749,12 @@ libxfs_idestroy(xfs_inode_t *ip)
 		libxfs_idestroy_fork(ip, XFS_ATTR_FORK);
 }
 
-static void
-libxfs_irelse(struct cache_node *node)
-{
-	xfs_inode_t	*ip = (xfs_inode_t *)node;
-
-	if (ip != NULL) {
-		if (ip->i_itemp)
-			kmem_zone_free(xfs_ili_zone, ip->i_itemp);
-		ip->i_itemp = NULL;
-		libxfs_idestroy(ip);
-		kmem_zone_free(xfs_inode_zone, ip);
-		ip = NULL;
-	}
-}
-
 void
-libxfs_icache_purge(void)
+libxfs_iput(xfs_inode_t *ip, uint lock_flags)
 {
-	cache_purge(libxfs_icache);
+	if (ip->i_itemp)
+		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
+	ip->i_itemp = NULL;
+	libxfs_idestroy(ip);
+	kmem_zone_free(xfs_inode_zone, ip);
 }
-
-struct cache_operations libxfs_icache_operations = {
-	/* .hash */	libxfs_ihash,
-	/* .alloc */	libxfs_ialloc,
-	/* .flush */	NULL,
-	/* .relse */	libxfs_irelse,
-	/* .compare */	libxfs_icompare,
-	/* .bulkrelse */ NULL
-};
Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2012-02-06 15:22:51.000000000 +0000
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2012-02-06 15:22:59.000000000 +0000
@@ -2698,7 +2698,6 @@ an AG size that is one stripe unit small
 	 * Need to drop references to inodes we still hold, first.
 	 */
 	libxfs_rtmount_destroy(mp);
-	libxfs_icache_purge();
 	libxfs_bcache_purge();
 
 	/*
Index: xfsprogs-dev/repair/xfs_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/xfs_repair.c	2012-02-06 15:22:51.000000000 +0000
+++ xfsprogs-dev/repair/xfs_repair.c	2012-02-06 15:38:25.000000000 +0000
@@ -69,7 +69,6 @@ static char *c_opts[] = {
 };
 
 
-static int	ihash_option_used;
 static int	bhash_option_used;
 static long	max_mem_specified;	/* in megabytes */
 static int	phase2_threads = 32;
@@ -239,13 +238,13 @@ process_args(int argc, char **argv)
 					pre_65_beta = 1;
 					break;
 				case IHASH_SIZE:
-					libxfs_ihash_size = (int)strtol(val, NULL, 0);
-					ihash_option_used = 1;
+					do_warn(
+		_("-o ihash option has been removed and will be ignored\n"));
 					break;
 				case BHASH_SIZE:
 					if (max_mem_specified)
 						do_abort(
-			_("-o bhash option cannot be used with -m option\n"));
+		_("-o bhash option cannot be used with -m option\n"));
 					libxfs_bhash_size = (int)strtol(val, NULL, 0);
 					bhash_option_used = 1;
 					break;
@@ -646,9 +645,7 @@ main(int argc, char **argv)
 		unsigned long	max_mem;
 		struct rlimit	rlim;
 
-		libxfs_icache_purge();
 		libxfs_bcache_purge();
-		cache_destroy(libxfs_icache);
 		cache_destroy(libxfs_bcache);
 
 		mem_used = (mp->m_sb.sb_icount >> (10 - 2)) +
@@ -707,11 +704,6 @@ main(int argc, char **argv)
 			do_log(_("        - block cache size set to %d entries\n"),
 				libxfs_bhash_size * HASH_CACHE_RATIO);
 
-		if (!ihash_option_used)
-			libxfs_ihash_size = libxfs_bhash_size;
-
-		libxfs_icache = cache_init(libxfs_ihash_size,
-						&libxfs_icache_operations);
 		libxfs_bcache = cache_init(libxfs_bhash_size,
 						&libxfs_bcache_operations);
 	}
Index: xfsprogs-dev/man/man8/xfs_repair.8
===================================================================
--- xfsprogs-dev.orig/man/man8/xfs_repair.8	2012-02-06 15:32:57.000000000 +0000
+++ xfsprogs-dev/man/man8/xfs_repair.8	2012-02-06 15:33:08.000000000 +0000
@@ -130,12 +130,6 @@ The
 supported are:
 .RS 1.0i
 .TP
-.BI ihash= ihashsize
-overrides the default inode cache hash size. The total number of
-inode cache entries are limited to 8 times this amount. The default
-.I ihashsize
-is 1024 (for a total of 8192 entries).
-.TP
 .BI bhash= bhashsize
 overrides the default buffer cache hash size. The total number of
 buffer cache entries are limited to 8 times this amount. The default

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
