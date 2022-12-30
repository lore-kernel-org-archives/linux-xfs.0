Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625ADC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbiLaALo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaALn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:11:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB61D5F5E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B98E61CE1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FC0C433D2;
        Sat, 31 Dec 2022 00:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445500;
        bh=AqkH6y6TAKOH0/PszLxvfuO2B526VzI9qyebTk30fr4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nSecbn3XhG1Sc+9tuDYFvKEz2KadENArVOadzeXFdwBtg6cmgAVUGgvCmFBQQhgUs
         33GkhE1FZAsN9pSkuwnnHnJvRxodGCEveFgKv+eLezWkPttzLVAs61EZC/KWIotf9I
         7pFepOHWUKX5Q0HizPNdQtB6umoChor9XzgH7xol9f05IyfYIlmID0gsKXphvyMmRB
         Vn1BxqzR6TfPnUx9DNSOURUrYbLUv41FM0fVK0Kp8/cVQ72Pxj1496gHPTOkL1B9In
         as+4gh6ubM/Udn7dPxgjGZ6maOY13pWMT4sFE/bsotoQ9mVRTtOJf22+Lg0DNl3Hip
         tTN7H67rL1GAQ==
Subject: [PATCH 2/9] libxfs: teach buftargs to maintain their own buffer
 hashtable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866184.711834.9648436964411711614.stgit@magnolia>
In-Reply-To: <167243866153.711834.17585439086893346840.stgit@magnolia>
References: <167243866153.711834.17585439086893346840.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, cached buffers are indexed with a single global bcache
structure.  This works ok for the limited use case where we only support
reading from the data device, but will fail badly when we want to
support buffers from in-memory btrees.  Move the bcache structure into
the buftarg.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c     |    2 +
 db/init.c           |    7 +++-
 db/sb.c             |    3 +-
 include/libxfs.h    |    3 --
 include/xfs_mount.h |    2 +
 libxfs/init.c       |   81 +++++++++++++++++++++++++++++----------------------
 libxfs/libxfs_io.h  |   14 +++++----
 libxfs/rdwr.c       |   40 +++++++++++++++++--------
 logprint/logprint.c |    2 +
 mkfs/xfs_mkfs.c     |    4 +--
 repair/prefetch.c   |   12 +++++---
 repair/prefetch.h   |    1 +
 repair/progress.c   |   14 ++++++---
 repair/progress.h   |    2 +
 repair/scan.c       |    2 +
 repair/xfs_repair.c |   32 +++++++++++---------
 16 files changed, 130 insertions(+), 91 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 79f65946709..45f8485799e 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -733,7 +733,7 @@ main(int argc, char **argv)
 	memset(&mbuf, 0, sizeof(xfs_mount_t));
 
 	/* We don't yet know the sector size, so read maximal size */
-	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
+	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
 	error = -libxfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &sbp, NULL);
 	if (error) {
diff --git a/db/init.c b/db/init.c
index eec65d0884d..9f045d27076 100644
--- a/db/init.c
+++ b/db/init.c
@@ -97,7 +97,6 @@ init(
 	else
 		x.dname = fsdevice;
 
-	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
 	if (!libxfs_init(&x)) {
 		fputs(_("\nfatal error -- couldn't initialize XFS library\n"),
 			stderr);
@@ -109,7 +108,8 @@ init(
 	 * tool and so need to be able to mount busted filesystems.
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
-	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
+	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev,
+			XFS_BUFTARG_MISCOMPARE_PURGE);
 	error = -libxfs_buf_read_uncached(xmount.m_ddev_targp, XFS_SB_DADDR,
 			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
 	if (error) {
@@ -134,7 +134,8 @@ init(
 
 	agcount = sbp->sb_agcount;
 	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
-			  LIBXFS_MOUNT_DEBUGGER);
+			  LIBXFS_MOUNT_DEBUGGER |
+			  LIBXFS_MOUNT_CACHE_MISCOMPARE_PURGE);
 	if (!mp) {
 		fprintf(stderr,
 			_("%s: device %s unusable (not an XFS filesystem?)\n"),
diff --git a/db/sb.c b/db/sb.c
index 2d508c26a3b..fd81286cd60 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -233,7 +233,8 @@ sb_logcheck(void)
 		}
 	}
 
-	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
+	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev,
+			XFS_BUFTARG_MISCOMPARE_PURGE);
 
 	dirty = xlog_is_dirty(mp, mp->m_log, &x, 0);
 	if (dirty == -1) {
diff --git a/include/libxfs.h b/include/libxfs.h
index 915bf511313..b07da6c03ee 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -123,8 +123,6 @@ typedef struct libxfs_xinit {
 	int             dfd;            /* data subvolume file descriptor */
 	int             logfd;          /* log subvolume file descriptor */
 	int             rtfd;           /* realtime subvolume file descriptor */
-	int		icache_flags;	/* cache init flags */
-	int		bcache_flags;	/* cache init flags */
 } libxfs_init_t;
 
 #define LIBXFS_ISREADONLY	0x0002	/* disallow all mounted filesystems */
@@ -141,7 +139,6 @@ extern int	libxfs_device_to_fd (dev_t);
 extern dev_t	libxfs_device_open (char *, int, int, int);
 extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
-extern void	libxfs_report(FILE *);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef char	*(libxfs_get_block_t)(char *, int, void *);
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index acd9214da3a..6be85bf21d2 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -256,6 +256,8 @@ __XFS_UNSUPP_OPSTATE(shutdown)
 #define LIBXFS_MOUNT_DEBUGGER		(1U << 0)
 /* report metadata corruption to stdout */
 #define LIBXFS_MOUNT_REPORT_CORRUPTION	(1U << 1)
+/* purge buffer cache on miscompares */
+#define LIBXFS_MOUNT_CACHE_MISCOMPARE_PURGE	(1U << 2)
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
diff --git a/libxfs/init.c b/libxfs/init.c
index f21dbc6732b..5e90bf733b7 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -31,7 +31,6 @@ pthread_mutex_t	atomic64_lock = PTHREAD_MUTEX_INITIALIZER;
 
 char *progname = "libxfs";	/* default, changed by each tool */
 
-struct cache *libxfs_bcache;	/* global buffer cache */
 int libxfs_bhash_size;		/* #buckets in bcache */
 
 int	use_xfs_buf_lock;	/* global flag: use xfs_buf locks for MT */
@@ -407,8 +406,6 @@ libxfs_init(libxfs_init_t *a)
 	}
 	if (!libxfs_bhash_size)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
-	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
-				   &libxfs_bcache_operations);
 	use_xfs_buf_lock = a->usebuflock;
 	xfs_dir_startup();
 	init_caches();
@@ -592,9 +589,14 @@ static struct xfs_buftarg *
 libxfs_buftarg_alloc(
 	struct xfs_mount	*mp,
 	dev_t			dev,
-	unsigned long		write_fails)
+	unsigned long		write_fails,
+	unsigned int		buftarg_flags)
 {
 	struct xfs_buftarg	*btp;
+	unsigned int		bcache_flags = 0;
+
+	if (!write_fails)
+		buftarg_flags &= ~XFS_BUFTARG_INJECT_WRITE_FAIL;
 
 	btp = malloc(sizeof(*btp));
 	if (!btp) {
@@ -604,13 +606,15 @@ libxfs_buftarg_alloc(
 	}
 	btp->bt_mount = mp;
 	btp->bt_bdev = dev;
-	btp->flags = 0;
-	if (write_fails) {
-		btp->writes_left = write_fails;
-		btp->flags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
-	}
+	btp->flags = buftarg_flags;
+	btp->writes_left = write_fails;
+	if (btp->flags & XFS_BUFTARG_MISCOMPARE_PURGE)
+		bcache_flags |= CACHE_MISCOMPARE_PURGE;
 	pthread_mutex_init(&btp->lock, NULL);
 
+	btp->bcache = cache_init(bcache_flags, libxfs_bhash_size,
+			&libxfs_bcache_operations);
+
 	return btp;
 }
 
@@ -633,10 +637,12 @@ libxfs_buftarg_init(
 	struct xfs_mount	*mp,
 	dev_t			dev,
 	dev_t			logdev,
-	dev_t			rtdev)
+	dev_t			rtdev,
+	unsigned int		btflags)
 {
 	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
 	unsigned long		dfail = 0, lfail = 0, rfail = 0;
+	unsigned int		dflags = 0, lflags = 0, rflags = 0;
 
 	/* Simulate utility crash after a certain number of writes. */
 	while (p && *p) {
@@ -650,6 +656,8 @@ libxfs_buftarg_init(
 				exit(1);
 			}
 			dfail = strtoul(val, NULL, 0);
+			if (dfail)
+				dflags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
 			break;
 		case WF_LOG:
 			if (!val) {
@@ -658,6 +666,8 @@ libxfs_buftarg_init(
 				exit(1);
 			}
 			lfail = strtoul(val, NULL, 0);
+			if (lfail)
+				lflags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
 			break;
 		case WF_RT:
 			if (!val) {
@@ -666,6 +676,8 @@ libxfs_buftarg_init(
 				exit(1);
 			}
 			rfail = strtoul(val, NULL, 0);
+			if (rfail)
+				rflags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
 			break;
 		default:
 			fprintf(stderr, _("unknown write fail type %s\n"),
@@ -708,12 +720,15 @@ libxfs_buftarg_init(
 		return;
 	}
 
-	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev, dfail);
+	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev, dfail,
+			dflags | btflags);
 	if (!logdev || logdev == dev)
 		mp->m_logdev_targp = mp->m_ddev_targp;
 	else
-		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev, lfail);
-	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev, rfail);
+		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev, lfail,
+				lflags | btflags);
+	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev, rfail,
+			rflags | btflags);
 }
 
 /* Compute maximum possible height for per-AG btree types for this fs. */
@@ -760,14 +775,18 @@ libxfs_mount(
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
 	xfs_daddr_t		d;
+	unsigned int		btflags = 0;
 	int			error;
 
+
 	mp->m_features = xfs_sb_version_to_features(sb);
 	if (flags & LIBXFS_MOUNT_DEBUGGER)
 		xfs_set_debugger(mp);
 	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
 		xfs_set_reporting_corruption(mp);
-	libxfs_buftarg_init(mp, dev, logdev, rtdev);
+	if (flags & LIBXFS_MOUNT_CACHE_MISCOMPARE_PURGE)
+		btflags |= XFS_BUFTARG_MISCOMPARE_PURGE;
+	libxfs_buftarg_init(mp, dev, logdev, rtdev, btflags);
 
 	mp->m_finobt_nores = true;
 	xfs_set_inode32(mp);
@@ -975,7 +994,7 @@ libxfs_flush_mount(
 	 * LOST_WRITE flag to be set in the buftarg.  Once that's done,
 	 * instruct the disks to persist their write caches.
 	 */
-	libxfs_bcache_flush();
+	libxfs_bcache_flush(mp);
 
 	/* Flush all kernel and disk write caches, and report failures. */
 	if (mp->m_ddev_targp) {
@@ -1001,6 +1020,14 @@ libxfs_flush_mount(
 	return error;
 }
 
+static void
+libxfs_buftarg_free(
+	struct xfs_buftarg	*btp)
+{
+	cache_destroy(btp->bcache);
+	kmem_free(btp);
+}
+
 /*
  * Release any resource obtained during a mount.
  */
@@ -1017,7 +1044,7 @@ libxfs_umount(
 	 * all incore buffers, then pick up the outcome when we tell the disks
 	 * to persist their write caches.
 	 */
-	libxfs_bcache_purge();
+	libxfs_bcache_purge(mp);
 	error = libxfs_flush_mount(mp);
 
 	/*
@@ -1028,10 +1055,10 @@ libxfs_umount(
 		libxfs_free_perag(mp);
 
 	xfs_da_unmount(mp);
-	kmem_free(mp->m_rtdev_targp);
+	libxfs_buftarg_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
-		kmem_free(mp->m_logdev_targp);
-	kmem_free(mp->m_ddev_targp);
+		libxfs_buftarg_free(mp->m_logdev_targp);
+	libxfs_buftarg_free(mp->m_ddev_targp);
 
 	return error;
 }
@@ -1047,10 +1074,7 @@ libxfs_destroy(
 
 	libxfs_close_devices(li);
 
-	/* Free everything from the buffer cache before freeing buffer cache */
-	libxfs_bcache_purge();
 	libxfs_bcache_free();
-	cache_destroy(libxfs_bcache);
 	leaked = destroy_caches();
 	rcu_unregister_thread();
 	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
@@ -1062,16 +1086,3 @@ libxfs_device_alignment(void)
 {
 	return platform_align_blockdev();
 }
-
-void
-libxfs_report(FILE *fp)
-{
-	time_t t;
-	char *c;
-
-	cache_report(fp, "libxfs_bcache", libxfs_bcache);
-
-	t = time(NULL);
-	c = asctime(localtime(&t));
-	fprintf(fp, "%s", c);
-}
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 4ffe788d446..3fa9e75dcaa 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -26,6 +26,7 @@ struct xfs_buftarg {
 	unsigned long		writes_left;
 	dev_t			bt_bdev;
 	unsigned int		flags;
+	struct cache		*bcache;	/* global buffer cache */
 };
 
 /* We purged a dirty buffer and lost a write. */
@@ -34,6 +35,8 @@ struct xfs_buftarg {
 #define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
 /* Simulate failure after a certain number of writes. */
 #define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
+/* purge buffers when lookups find a size mismatch */
+#define XFS_BUFTARG_MISCOMPARE_PURGE	(1 << 3)
 
 /* Simulate the system crashing after a certain number of writes. */
 static inline void
@@ -50,8 +53,8 @@ xfs_buftarg_trip_write(
 	pthread_mutex_unlock(&btp->lock);
 }
 
-extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
-				    dev_t logdev, dev_t rtdev);
+void libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev, dev_t logdev,
+		dev_t rtdev, unsigned int btflags);
 int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
 
 #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
@@ -139,7 +142,6 @@ int libxfs_buf_priority(struct xfs_buf *bp);
 
 /* Buffer Cache Interfaces */
 
-extern struct cache	*libxfs_bcache;
 extern struct cache_operations	libxfs_bcache_operations;
 
 #define LIBXFS_GETBUF_TRYLOCK	(1 << 0)
@@ -183,10 +185,10 @@ libxfs_buf_read(
 
 int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
-extern void	libxfs_bcache_purge(void);
+extern void	libxfs_bcache_purge(struct xfs_mount *mp);
 extern void	libxfs_bcache_free(void);
-extern void	libxfs_bcache_flush(void);
-extern int	libxfs_bcache_overflowed(void);
+extern void	libxfs_bcache_flush(struct xfs_mount *mp);
+extern int	libxfs_bcache_overflowed(struct xfs_mount *mp);
 
 /* Buffer (Raw) Interfaces */
 int		libxfs_bwrite(struct xfs_buf *bp);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index d5aad3ea210..5d63ec4f6de 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -198,18 +198,21 @@ libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
 }
 
 static int
-libxfs_bcompare(struct cache_node *node, cache_key_t key)
+libxfs_bcompare(
+	struct cache_node	*node,
+	cache_key_t		key)
 {
 	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
 						   b_node);
 	struct xfs_bufkey	*bkey = (struct xfs_bufkey *)key;
+	struct cache		*bcache = bkey->buftarg->bcache;
 
 	if (bp->b_target->bt_bdev == bkey->buftarg->bt_bdev &&
 	    bp->b_cache_key == bkey->blkno) {
 		if (bp->b_length == bkey->bblen)
 			return CACHE_HIT;
 #ifdef IO_BCOMPARE_CHECK
-		if (!(libxfs_bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
+		if (!(bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
 			fprintf(stderr,
 	"%lx: Badness in key lookup (length)\n"
 	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
@@ -399,11 +402,12 @@ __cache_lookup(
 	struct xfs_buf		**bpp)
 {
 	struct cache_node	*cn = NULL;
+	struct cache		*bcache = key->buftarg->bcache;
 	struct xfs_buf		*bp;
 
 	*bpp = NULL;
 
-	cache_node_get(libxfs_bcache, key, &cn);
+	cache_node_get(bcache, key, &cn);
 	if (!cn)
 		return -ENOMEM;
 	bp = container_of(cn, struct xfs_buf, b_node);
@@ -415,7 +419,7 @@ __cache_lookup(
 		if (ret) {
 			ASSERT(ret == EAGAIN);
 			if (flags & LIBXFS_GETBUF_TRYLOCK) {
-				cache_node_put(libxfs_bcache, cn);
+				cache_node_put(bcache, cn);
 				return -EAGAIN;
 			}
 
@@ -434,7 +438,7 @@ __cache_lookup(
 		bp->b_holder = pthread_self();
 	}
 
-	cache_node_set_priority(libxfs_bcache, cn,
+	cache_node_set_priority(bcache, cn,
 			cache_node_get_priority(cn) - CACHE_PREFETCH_PRIORITY);
 	*bpp = bp;
 	return 0;
@@ -550,7 +554,7 @@ libxfs_buf_relse(
 	}
 
 	if (!list_empty(&bp->b_node.cn_hash))
-		cache_node_put(libxfs_bcache, &bp->b_node);
+		cache_node_put(bp->b_target->bcache, &bp->b_node);
 	else if (--bp->b_node.cn_count == 0) {
 		if (bp->b_flags & LIBXFS_B_DIRTY)
 			libxfs_bwrite(bp);
@@ -1004,21 +1008,31 @@ libxfs_bflush(
 }
 
 void
-libxfs_bcache_purge(void)
+libxfs_bcache_purge(struct xfs_mount *mp)
 {
-	cache_purge(libxfs_bcache);
+	if (!mp)
+		return;
+	cache_purge(mp->m_ddev_targp->bcache);
+	cache_purge(mp->m_logdev_targp->bcache);
+	cache_purge(mp->m_rtdev_targp->bcache);
 }
 
 void
-libxfs_bcache_flush(void)
+libxfs_bcache_flush(struct xfs_mount *mp)
 {
-	cache_flush(libxfs_bcache);
+	if (!mp)
+		return;
+	cache_flush(mp->m_ddev_targp->bcache);
+	cache_flush(mp->m_logdev_targp->bcache);
+	cache_flush(mp->m_rtdev_targp->bcache);
 }
 
 int
-libxfs_bcache_overflowed(void)
+libxfs_bcache_overflowed(struct xfs_mount *mp)
 {
-	return cache_overflowed(libxfs_bcache);
+	return cache_overflowed(mp->m_ddev_targp->bcache) ||
+		cache_overflowed(mp->m_logdev_targp->bcache) ||
+		cache_overflowed(mp->m_rtdev_targp->bcache);
 }
 
 struct cache_operations libxfs_bcache_operations = {
@@ -1460,7 +1474,7 @@ libxfs_buf_set_priority(
 	struct xfs_buf	*bp,
 	int		priority)
 {
-	cache_node_set_priority(libxfs_bcache, &bp->b_node, priority);
+	cache_node_set_priority(bp->b_target->bcache, &bp->b_node, priority);
 }
 
 int
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 9a8811f467c..df70553543b 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -213,7 +213,7 @@ main(int argc, char **argv)
 		exit(1);
 
 	logstat(&mount);
-	libxfs_buftarg_init(&mount, x.ddev, x.logdev, x.rtdev);
+	libxfs_buftarg_init(&mount, x.ddev, x.logdev, x.rtdev, 0);
 
 	logfd = (x.logfd < 0) ? x.dfd : x.logfd;
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 31861a2eb3c..638e7ce6ea4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4518,7 +4518,7 @@ main(
 	/*
 	 * we need the libxfs buffer cache from here on in.
 	 */
-	libxfs_buftarg_init(mp, xi.ddev, xi.logdev, xi.rtdev);
+	libxfs_buftarg_init(mp, xi.ddev, xi.logdev, xi.rtdev, 0);
 
 	/*
 	 * Before we mount the filesystem we need to make sure the devices have
@@ -4587,7 +4587,7 @@ main(
 	 * Need to drop references to inodes we still hold, first.
 	 */
 	libxfs_rtmount_destroy(mp);
-	libxfs_bcache_purge();
+	libxfs_bcache_purge(mp);
 
 	/*
 	 * Mark the filesystem ok.
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 017750e9a92..5665e0a224c 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -886,10 +886,12 @@ init_prefetch(
 
 prefetch_args_t *
 start_inode_prefetch(
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	int			dirs_only,
 	prefetch_args_t		*prev_args)
 {
+	struct cache		*bcache = mp->m_ddev_targp->bcache;
 	prefetch_args_t		*args;
 	long			max_queue;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
@@ -914,7 +916,7 @@ start_inode_prefetch(
 	 * and not any other associated metadata like directories
 	 */
 
-	max_queue = libxfs_bcache->c_maxcount / thread_count / 8;
+	max_queue = bcache->c_maxcount / thread_count / 8;
 	if (igeo->inode_cluster_size > mp->m_sb.sb_blocksize)
 		max_queue = max_queue * igeo->blocks_per_cluster /
 				igeo->ialloc_blks;
@@ -970,14 +972,16 @@ prefetch_ag_range(
 	void			(*func)(struct workqueue *,
 					xfs_agnumber_t, void *))
 {
+	struct xfs_mount	*mp = work->wq_ctx;
 	int			i;
 	struct prefetch_args	*pf_args[2];
 
-	pf_args[start_ag & 1] = start_inode_prefetch(start_ag, dirs_only, NULL);
+	pf_args[start_ag & 1] = start_inode_prefetch(mp, start_ag, dirs_only,
+			NULL);
 	for (i = start_ag; i < end_ag; i++) {
 		/* Don't prefetch end_ag */
 		if (i + 1 < end_ag)
-			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
+			pf_args[(~i) & 1] = start_inode_prefetch(mp, i + 1,
 						dirs_only, pf_args[i & 1]);
 		func(work, i, pf_args[i & 1]);
 	}
@@ -1027,7 +1031,7 @@ do_inode_prefetch(
 	 * filesystem - it's all in the cache. In that case, run a thread per
 	 * CPU to maximise parallelism of the queue to be processed.
 	 */
-	if (check_cache && !libxfs_bcache_overflowed()) {
+	if (check_cache && !libxfs_bcache_overflowed(mp)) {
 		queue.wq_ctx = mp;
 		create_work_queue(&queue, mp, platform_nproc());
 		for (i = 0; i < mp->m_sb.sb_agcount; i++)
diff --git a/repair/prefetch.h b/repair/prefetch.h
index 54ece48ad22..a8c52a1195b 100644
--- a/repair/prefetch.h
+++ b/repair/prefetch.h
@@ -39,6 +39,7 @@ init_prefetch(
 
 prefetch_args_t *
 start_inode_prefetch(
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	int			dirs_only,
 	prefetch_args_t		*prev_args);
diff --git a/repair/progress.c b/repair/progress.c
index f6c4d988444..625dc41c289 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -383,14 +383,18 @@ timediff(int phase)
 **  array.
 */
 char *
-timestamp(int end, int phase, char *buf)
+timestamp(
+	struct xfs_mount	*mp,
+	int			end,
+	int			phase,
+	char			*buf)
 {
 
-	time_t    now;
-	struct tm *tmp;
+	time_t			now;
+	struct tm		*tmp;
 
-	if (verbose > 1)
-		cache_report(stderr, "libxfs_bcache", libxfs_bcache);
+	if (verbose > 1 && mp && mp->m_ddev_targp)
+		cache_report(stderr, "libxfs_bcache", mp->m_ddev_targp->bcache);
 
 	now = time(NULL);
 
diff --git a/repair/progress.h b/repair/progress.h
index 2c1690db1b1..75b751b783b 100644
--- a/repair/progress.h
+++ b/repair/progress.h
@@ -37,7 +37,7 @@ extern void stop_progress_rpt(void);
 extern void summary_report(void);
 extern int  set_progress_msg(int report, uint64_t total);
 extern uint64_t print_final_rpt(void);
-extern char *timestamp(int end, int phase, char *buf);
+extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
 extern char *duration(int val, char *buf);
 extern int do_parallel;
 
diff --git a/repair/scan.c b/repair/scan.c
index 008ef65ac75..ac2233b93b7 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -42,7 +42,7 @@ struct aghdr_cnts {
 void
 set_mp(xfs_mount_t *mpp)
 {
-	libxfs_bcache_purge();
+	libxfs_bcache_purge(mp);
 	mp = mpp;
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ff29bea9743..e49d4292ad4 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -944,9 +944,11 @@ repair_capture_writeback(
 }
 
 static inline void
-phase_end(int phase)
+phase_end(
+	struct xfs_mount	*mp,
+	int			phase)
 {
-	timestamp(PHASE_END, phase, NULL);
+	timestamp(mp, PHASE_END, phase, NULL);
 
 	/* Fail if someone injected an post-phase error. */
 	if (fail_after_phase && phase == fail_after_phase)
@@ -981,8 +983,8 @@ main(int argc, char **argv)
 
 	msgbuf = malloc(DURATION_BUF_SIZE);
 
-	timestamp(PHASE_START, 0, NULL);
-	phase_end(0);
+	timestamp(temp_mp, PHASE_START, 0, NULL);
+	phase_end(temp_mp, 0);
 
 	/* -f forces this, but let's be nice and autodetect it, as well. */
 	if (!isa_file) {
@@ -1005,7 +1007,7 @@ main(int argc, char **argv)
 
 	/* do phase1 to make sure we have a superblock */
 	phase1(temp_mp);
-	phase_end(1);
+	phase_end(temp_mp, 1);
 
 	if (no_modify && primary_sb_modified)  {
 		do_warn(_("Primary superblock would have been modified.\n"
@@ -1142,8 +1144,8 @@ main(int argc, char **argv)
 		unsigned long	max_mem;
 		struct rlimit	rlim;
 
-		libxfs_bcache_purge();
-		cache_destroy(libxfs_bcache);
+		libxfs_bcache_purge(mp);
+		cache_destroy(mp->m_ddev_targp->bcache);
 
 		mem_used = (mp->m_sb.sb_icount >> (10 - 2)) +
 					(mp->m_sb.sb_dblocks >> (10 + 1)) +
@@ -1203,7 +1205,7 @@ main(int argc, char **argv)
 			do_log(_("        - block cache size set to %d entries\n"),
 				libxfs_bhash_size * HASH_CACHE_RATIO);
 
-		libxfs_bcache = cache_init(0, libxfs_bhash_size,
+		mp->m_ddev_targp->bcache = cache_init(0, libxfs_bhash_size,
 						&libxfs_bcache_operations);
 	}
 
@@ -1231,16 +1233,16 @@ main(int argc, char **argv)
 
 	/* make sure the per-ag freespace maps are ok so we can mount the fs */
 	phase2(mp, phase2_threads);
-	phase_end(2);
+	phase_end(mp, 2);
 
 	if (do_prefetch)
 		init_prefetch(mp);
 
 	phase3(mp, phase2_threads);
-	phase_end(3);
+	phase_end(mp, 3);
 
 	phase4(mp);
-	phase_end(4);
+	phase_end(mp, 4);
 
 	if (no_modify) {
 		printf(_("No modify flag set, skipping phase 5\n"));
@@ -1250,7 +1252,7 @@ main(int argc, char **argv)
 	} else {
 		phase5(mp);
 	}
-	phase_end(5);
+	phase_end(mp, 5);
 
 	/*
 	 * Done with the block usage maps, toss them...
@@ -1260,10 +1262,10 @@ main(int argc, char **argv)
 
 	if (!bad_ino_btree)  {
 		phase6(mp);
-		phase_end(6);
+		phase_end(mp, 6);
 
 		phase7(mp, phase2_threads);
-		phase_end(7);
+		phase_end(mp, 7);
 	} else  {
 		do_warn(
 _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
@@ -1388,7 +1390,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	 * verifiers are run (where we discover the max metadata LSN), reformat
 	 * the log if necessary and unmount.
 	 */
-	libxfs_bcache_flush();
+	libxfs_bcache_flush(mp);
 	format_log_max_lsn(mp);
 
 	if (xfs_sb_version_needsrepair(&mp->m_sb))

