Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12B3C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 21:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiHIVIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiHIVHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 17:07:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C40D4AD7E
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 14:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F00D60BD6
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 21:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5473C433D6;
        Tue,  9 Aug 2022 21:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660079217;
        bh=cY6ET367PRc3HFiPGsJuREIjCwUljNexXdGEekM8ZlQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QCGJ5Rz502ylqIEikLlnJP2Lo/xbugnL1BKl35uN3+Wyv3X97jM2RbqYyrdq52fap
         pHYMSExk1lp+uL076vBU1RSCVv/jk62NR0yoQKTTbS+S+blIFM5OM8Izd8tQsGt+85
         0prrhWSOQRzuBH8X9FqJFHeTM2u+/uKl1uS+ylK5jCKjGK6EFJlIyGmrCqDiJYVWLq
         SQvMOflbTyvO93hNn5sh8tki4669eSxs9JdUVelUv9qFtUFr4gDu+a2tFWDk7kV0eK
         emquYFwGHvrZaJjuNBdsIPcpF+FRnWaMr7vTVGETwyMGN6fp0uKPol+opWnSZt/onj
         wdZSLmYe7ffPw==
Subject: [PATCH 2/2] xfs_repair: retain superblock buffer to avoid write hook
 deadlock
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 14:06:57 -0700
Message-ID: <166007921743.3294543.7334567013352169774.stgit@magnolia>
In-Reply-To: <166007920625.3294543.10714247329798384513.stgit@magnolia>
References: <166007920625.3294543.10714247329798384513.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then I experience the following deadlock in xfs_repair
when I'm running the offline repair fuzz tests:

#0  futex_wait (private=0, expected=2, futex_word=0x55555566df70) at ../sysdeps/nptl/futex-internal.h:146
#1  __GI___lll_lock_wait (futex=futex@entry=0x55555566df70, private=0) at ./nptl/lowlevellock.c:49
#2  lll_mutex_lock_optimized (mutex=0x55555566df70) at ./nptl/pthread_mutex_lock.c:48
#3  ___pthread_mutex_lock (mutex=mutex@entry=0x55555566df70) at ./nptl/pthread_mutex_lock.c:93
#4  cache_shake (cache=cache@entry=0x55555566de60, priority=priority@entry=2, purge=purge@entry=false) at cache.c:231
#5  cache_node_get (cache=cache@entry=0x55555566de60, key=key@entry=0x7fffe55e01b0, nodep=nodep@entry=0x7fffe55e0168) at cache.c:452
#6  __cache_lookup (key=key@entry=0x7fffe55e01b0, flags=0, bpp=bpp@entry=0x7fffe55e0228) at rdwr.c:405
#7  libxfs_getbuf_flags (btp=0x55555566de00, blkno=0, len=<optimized out>, flags=<optimized out>, bpp=0x7fffe55e0228) at rdwr.c:457
#8  libxfs_buf_read_map (btp=0x55555566de00, map=map@entry=0x7fffe55e0280, nmaps=nmaps@entry=1, flags=flags@entry=0, bpp=bpp@entry=0x7fffe55e0278, ops=0x5555556233e0 <xfs_sb_buf_ops>)
    at rdwr.c:704
#9  libxfs_buf_read (ops=<optimized out>, bpp=0x7fffe55e0278, flags=0, numblks=<optimized out>, blkno=0, target=<optimized out>)
    at /storage/home/djwong/cdev/work/xfsprogs/build-x86_64/libxfs/libxfs_io.h:195
#10 libxfs_getsb (mp=mp@entry=0x7fffffffd690) at rdwr.c:162
#11 force_needsrepair (mp=0x7fffffffd690) at xfs_repair.c:924
#12 repair_capture_writeback (bp=<optimized out>) at xfs_repair.c:1000
#13 libxfs_bwrite (bp=0x7fffe011e530) at rdwr.c:869
#14 cache_shake (cache=cache@entry=0x55555566de60, priority=priority@entry=2, purge=purge@entry=false) at cache.c:240
#15 cache_node_get (cache=cache@entry=0x55555566de60, key=key@entry=0x7fffe55e0470, nodep=nodep@entry=0x7fffe55e0428) at cache.c:452
#16 __cache_lookup (key=key@entry=0x7fffe55e0470, flags=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:405
#17 libxfs_getbuf_flags (btp=0x55555566de00, blkno=12736, len=<optimized out>, flags=<optimized out>, bpp=0x7fffe55e0538) at rdwr.c:457
#18 __libxfs_buf_get_map (btp=<optimized out>, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flags=flags@entry=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:501
#19 libxfs_buf_get_map (btp=<optimized out>, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flags=flags@entry=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:525
#20 pf_queue_io (args=args@entry=0x5555556722c0, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flag=flag@entry=11) at prefetch.c:124
#21 pf_read_bmbt_reclist (args=0x5555556722c0, rp=<optimized out>, numrecs=78) at prefetch.c:220
#22 pf_scan_lbtree (dbno=dbno@entry=1211, level=level@entry=1, isadir=isadir@entry=1, args=args@entry=0x5555556722c0, func=0x55555557f240 <pf_scanfunc_bmap>) at prefetch.c:298
#23 pf_read_btinode (isadir=1, dino=<optimized out>, args=0x5555556722c0) at prefetch.c:385
#24 pf_read_inode_dirs (args=args@entry=0x5555556722c0, bp=bp@entry=0x7fffdc023790) at prefetch.c:459
#25 pf_read_inode_dirs (bp=<optimized out>, args=0x5555556722c0) at prefetch.c:411
#26 pf_batch_read (args=args@entry=0x5555556722c0, which=which@entry=PF_PRIMARY, buf=buf@entry=0x7fffd001d000) at prefetch.c:609
#27 pf_io_worker (param=0x5555556722c0) at prefetch.c:673
#28 start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:442
#29 clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81

From this stack trace, we see that xfs_repair's prefetch module is
getting some xfs_buf objects ahead of initiating a read (#19).  The
buffer cache has hit its limit, so it calls cache_shake (#14) to free
some unused xfs_bufs.  The buffer it finds is a dirty buffer, so it
calls libxfs_bwrite to flush it out to disk, which in turn invokes the
buffer write hook that xfs_repair set up in 3b7667cb to mark the ondisk
filesystem's superblock as NEEDSREPAIR until repair actually completes.

Unfortunately, the NEEDSREPAIR handler itself needs to grab the
superblock buffer, so it makes another call into the buffer cache (#9),
which sees that the cache is full and tries to shake it(#4).  Hence we
deadlock on cm_mutex because shaking is not reentrant.

Fix this by retaining a reference to the superblock buffer when possible
so that the writeback hook doesn't have to access the buffer cache to
set NEEDSREPAIR.

Fixes: 3b7667cb ("xfs_repair: set NEEDSREPAIR the first time we write to a filesystem")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_io.h       |    1 +
 libxfs/rdwr.c            |    8 +++++
 repair/phase2.c          |    8 +++++
 repair/protos.h          |    1 +
 repair/xfs_repair.c      |   75 ++++++++++++++++++++++++++++++++++++++++------
 6 files changed, 86 insertions(+), 9 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 824f2c4d..7c59bd4b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -53,9 +53,11 @@
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
+#define xfs_buf_lock			libxfs_buf_lock
 #define xfs_buf_read			libxfs_buf_read
 #define xfs_buf_read_uncached		libxfs_buf_read_uncached
 #define xfs_buf_relse			libxfs_buf_relse
+#define xfs_buf_unlock			libxfs_buf_unlock
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 9c0e2704..fae86427 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -226,6 +226,7 @@ xfs_buf_hold(struct xfs_buf *bp)
 }
 
 void xfs_buf_lock(struct xfs_buf *bp);
+void xfs_buf_unlock(struct xfs_buf *bp);
 
 int libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags,
 		struct xfs_buf **bpp);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index fe69f9b4..61083dac 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -384,6 +384,14 @@ xfs_buf_lock(
 		pthread_mutex_lock(&bp->b_lock);
 }
 
+void
+xfs_buf_unlock(
+	struct xfs_buf	*bp)
+{
+	if (use_xfs_buf_lock)
+		pthread_mutex_unlock(&bp->b_lock);
+}
+
 static int
 __cache_lookup(
 	struct xfs_bufkey	*key,
diff --git a/repair/phase2.c b/repair/phase2.c
index 56a39bb4..2ada95ae 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -370,6 +370,14 @@ phase2(
 	} else
 		do_log(_("Phase 2 - using internal log\n"));
 
+	/*
+	 * Now that we've set up the buffer cache the way we want it, try to
+	 * grab our own reference to the primary sb so that the hooks will not
+	 * have to call out to the buffer cache.
+	 */
+	if (mp->m_buf_writeback_fn)
+		retain_primary_sb(mp);
+
 	/* Zero log if applicable */
 	do_log(_("        - zero log...\n"));
 
diff --git a/repair/protos.h b/repair/protos.h
index 03ebae14..83e471ff 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -16,6 +16,7 @@ int	get_sb(xfs_sb_t			*sbp,
 		xfs_off_t			off,
 		int			size,
 		xfs_agnumber_t		agno);
+int retain_primary_sb(struct xfs_mount *mp);
 void	write_primary_sb(xfs_sb_t	*sbp,
 			int		size);
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index c94671d8..d46870cc 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -749,6 +749,63 @@ check_fs_vs_host_sectsize(
 	}
 }
 
+/*
+ * If we set up a writeback function to set NEEDSREPAIR while the filesystem is
+ * dirty, there's a chance that calling libxfs_getsb could deadlock the buffer
+ * cache while trying to get the primary sb buffer if the first non-sb write to
+ * the filesystem is the result of a cache shake.  Retain a reference to the
+ * primary sb buffer to avoid all that.
+ */
+static struct xfs_buf *primary_sb_bp;	/* buffer for superblock */
+
+int
+retain_primary_sb(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = -libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR,
+			XFS_FSS_TO_BB(mp, 1), 0, &primary_sb_bp,
+			&xfs_sb_buf_ops);
+	if (error)
+		return error;
+
+	libxfs_buf_unlock(primary_sb_bp);
+	return 0;
+}
+
+static void
+drop_primary_sb(void)
+{
+	if (!primary_sb_bp)
+		return;
+
+	libxfs_buf_lock(primary_sb_bp);
+	libxfs_buf_relse(primary_sb_bp);
+	primary_sb_bp = NULL;
+}
+
+static int
+get_primary_sb(
+	struct xfs_mount	*mp,
+	struct xfs_buf		**bpp)
+{
+	int			error;
+
+	*bpp = NULL;
+
+	if (!primary_sb_bp) {
+		error = retain_primary_sb(mp);
+		if (error)
+			return error;
+	}
+
+	libxfs_buf_lock(primary_sb_bp);
+	xfs_buf_hold(primary_sb_bp);
+	*bpp = primary_sb_bp;
+	return 0;
+}
+
 /* Clear needsrepair after a successful repair run. */
 void
 clear_needsrepair(
@@ -769,15 +826,14 @@ clear_needsrepair(
 		do_warn(
 	_("Cannot clear needsrepair due to flush failure, err=%d.\n"),
 			error);
-		return;
+		goto drop;
 	}
 
 	/* Clear needsrepair from the superblock. */
-	bp = libxfs_getsb(mp);
-	if (!bp || bp->b_error) {
+	error = get_primary_sb(mp, &bp);
+	if (error) {
 		do_warn(
-	_("Cannot clear needsrepair from primary super, err=%d.\n"),
-			bp ? bp->b_error : ENOMEM);
+	_("Cannot clear needsrepair from primary super, err=%d.\n"), error);
 	} else {
 		mp->m_sb.sb_features_incompat &=
 				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
@@ -786,6 +842,8 @@ clear_needsrepair(
 	}
 	if (bp)
 		libxfs_buf_relse(bp);
+drop:
+	drop_primary_sb();
 }
 
 static void
@@ -808,11 +866,10 @@ force_needsrepair(
 	    xfs_sb_version_needsrepair(&mp->m_sb))
 		return;
 
-	bp = libxfs_getsb(mp);
-	if (!bp || bp->b_error) {
+	error = get_primary_sb(mp, &bp);
+	if (error) {
 		do_log(
-	_("couldn't get superblock to set needsrepair, err=%d\n"),
-				bp ? bp->b_error : ENOMEM);
+	_("couldn't get superblock to set needsrepair, err=%d\n"), error);
 	} else {
 		/*
 		 * It's possible that we need to set NEEDSREPAIR before we've

