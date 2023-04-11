Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C64C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 22:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDKWxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 18:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDKWxl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 18:53:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321843A9B
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 15:53:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 926D561011
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 22:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EC7C433EF;
        Tue, 11 Apr 2023 22:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681253619;
        bh=n7hQAYEVWykNuF02Pg1u4kNgJG87aYUR8gfr+P+G6b8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ip/TTzhMtYED6JgUWNwNJn1h7xMHyxHvKsQ4f2lc8xqmoCF0lptKal4cPOVi4PvXb
         bA5snNj2Pp0WlW539gH/cyXAFzlqvO4w7wT1KGJ7YymwwhbrhIdefOzr9L+afQ2HEg
         SJQ/JpVshWlBrRpAFQVSbzvq2l3iar+p+2TYhSHYVHTf16XiydqSjqQErvDoTJJAf9
         jToJ9KGxvO/LcxY12j06l438oZp3D7J0yfQIS5cqxGA/AR4N2HebPnif6Ak3FZA01Z
         T/AWAz5mv3jREmtB6U0FkZLCjrDwX4UnyWJt6UBXroGygBfaAi17n7+U3JaysuvI19
         RvtZJL8TB9fRQ==
Date:   Tue, 11 Apr 2023 15:53:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfsprogs: _{attr,data}_map_shared should take ILOCK_EXCL
 until iread_extents is completely done
Message-ID: <20230411225338.GL360889@frogsfrogsfrogs>
References: <20230411184934.GK360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411184934.GK360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While fuzzing the data fork extent count on a btree-format directory
with xfs/375, I observed the following (excerpted) splat:

XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
------------[ cut here ]------------
WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
Call Trace:
 <TASK>
 xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 __x64_sys_ioctl+0x82/0xa0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The cause of this is a race condition in xfs_ilock_data_map_shared,
which performs an unlocked access to the data fork to guess which lock
mode it needs:

Thread 0                          Thread 1

xfs_need_iread_extents
<observe no iext tree>
xfs_ilock(..., ILOCK_EXCL)
xfs_iread_extents
<observe no iext tree>
<check ILOCK_EXCL>
<load bmbt extents into iext>
<notice iext size doesn't
 match nextents>
                                  xfs_need_iread_extents
                                  <observe iext tree>
                                  xfs_ilock(..., ILOCK_SHARED)
<tear down iext tree>
xfs_iunlock(..., ILOCK_EXCL)
                                  xfs_iread_extents
                                  <observe no iext tree>
                                  <check ILOCK_EXCL>
                                  *BOOM*

Fix this race by adding a flag to the xfs_ifork structure to indicate
that we have not yet read in the extent records and changing the
predicate to look at the flag state, not if_height.  The memory barrier
ensures that the flag will not be set until the very end of the
function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
Here's the userspace version, which steals heavily from the kernel but
otherwise uses liburcu underneath.
---
 include/atomic.h        |  100 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h    |    3 -
 libxfs/xfs_bmap.c       |    6 +++
 libxfs/xfs_inode_fork.c |   16 +++++++-
 libxfs/xfs_inode_fork.h |    6 ++-
 5 files changed, 125 insertions(+), 6 deletions(-)

diff --git a/include/atomic.h b/include/atomic.h
index 9c4aa5849ae..98889190bb0 100644
--- a/include/atomic.h
+++ b/include/atomic.h
@@ -118,4 +118,104 @@ atomic64_set(atomic64_t *a, int64_t v)
 
 #endif /* HAVE_URCU_ATOMIC64 */
 
+#define __smp_mb()		cmm_smp_mb()
+
+/* from compiler_types.h */
+/*
+ * __unqual_scalar_typeof(x) - Declare an unqualified scalar type, leaving
+ *			       non-scalar types unchanged.
+ */
+/*
+ * Prefer C11 _Generic for better compile-times and simpler code. Note: 'char'
+ * is not type-compatible with 'signed char', and we define a separate case.
+ */
+#define __scalar_type_to_expr_cases(type)				\
+		unsigned type:	(unsigned type)0,			\
+		signed type:	(signed type)0
+
+#define __unqual_scalar_typeof(x) typeof(				\
+		_Generic((x),						\
+			 char:	(char)0,				\
+			 __scalar_type_to_expr_cases(char),		\
+			 __scalar_type_to_expr_cases(short),		\
+			 __scalar_type_to_expr_cases(int),		\
+			 __scalar_type_to_expr_cases(long),		\
+			 __scalar_type_to_expr_cases(long long),	\
+			 default: (x)))
+
+/* Is this type a native word size -- useful for atomic operations */
+#define __native_word(t) \
+	(sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
+	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
+
+#define compiletime_assert(foo, str)	BUILD_BUG_ON(!(foo))
+
+#define compiletime_assert_atomic_type(t)				\
+	compiletime_assert(__native_word(t),				\
+		"Need native word sized stores/loads for atomicity.")
+
+/* from barrier.h */
+#ifndef __smp_store_release
+#define __smp_store_release(p, v)					\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	__smp_mb();							\
+	WRITE_ONCE(*p, v);						\
+} while (0)
+#endif
+
+#ifndef __smp_load_acquire
+#define __smp_load_acquire(p)						\
+({									\
+	__unqual_scalar_typeof(*p) ___p1 = READ_ONCE(*p);		\
+	compiletime_assert_atomic_type(*p);				\
+	__smp_mb();							\
+	(typeof(*p))___p1;						\
+})
+#endif
+
+#ifndef smp_store_release
+#define smp_store_release(p, v) __smp_store_release((p), (v))
+#endif
+
+#ifndef smp_load_acquire
+#define smp_load_acquire(p) __smp_load_acquire(p)
+#endif
+
+/* from rwonce.h */
+/*
+ * Yes, this permits 64-bit accesses on 32-bit architectures. These will
+ * actually be atomic in some cases (namely Armv7 + LPAE), but for others we
+ * rely on the access being split into 2x32-bit accesses for a 32-bit quantity
+ * (e.g. a virtual address) and a strong prevailing wind.
+ */
+#define compiletime_assert_rwonce_type(t)					\
+	compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),	\
+		"Unsupported access size for {READ,WRITE}_ONCE().")
+
+/*
+ * Use __READ_ONCE() instead of READ_ONCE() if you do not require any
+ * atomicity. Note that this may result in tears!
+ */
+#ifndef __READ_ONCE
+#define __READ_ONCE(x)	(*(const volatile __unqual_scalar_typeof(x) *)&(x))
+#endif
+
+#define READ_ONCE(x)							\
+({									\
+	compiletime_assert_rwonce_type(x);				\
+	__READ_ONCE(x);							\
+})
+
+#define __WRITE_ONCE(x, val)						\
+do {									\
+	*(volatile typeof(x) *)&(x) = (val);				\
+} while (0)
+
+#define WRITE_ONCE(x, val)						\
+do {									\
+	compiletime_assert_rwonce_type(x);				\
+	__WRITE_ONCE(x, val);						\
+} while (0)
+
 #endif /* __ATOMIC_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e5f37df28c0..5fdfeeea060 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -222,9 +222,6 @@ static inline bool WARN_ON(bool expr) {
 #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
 #define percpu_counter_sum(x)		(*x)
 
-#define READ_ONCE(x)			(x)
-#define WRITE_ONCE(x, val)		((x) = (val))
-
 /*
  * get_random_u32 is used for di_gen inode allocation, it must be zero for
  * libxfs or all sorts of badness can occur!
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 76591d07766..957fc96bfa0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1164,6 +1164,12 @@ xfs_iread_extents(
 		goto out;
 	}
 	ASSERT(ir.loaded == xfs_iext_count(ifp));
+	/*
+	 * Use release semantics so that we can use acquire semantics in
+	 * xfs_need_iread_extents and be guaranteed to see a valid mapping tree
+	 * after that load.
+	 */
+	smp_store_release(&ifp->if_needextents, 0);
 	return 0;
 out:
 	xfs_iext_destroy(ifp);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index f16b8ccc059..af00479469b 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -224,10 +224,15 @@ xfs_iformat_data_fork(
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
-	 * depend on it.
+	 * depend on it.  Use release semantics to set needextents /after/ we
+	 * set the format. This ensures that we can use acquire semantics on
+	 * needextents in xfs_need_iread_extents() and be guaranteed to see a
+	 * valid format value after that load.
 	 */
 	ip->i_df.if_format = dip->di_format;
 	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
+	smp_store_release(&ip->i_df.if_needextents,
+			   ip->i_df.if_format == XFS_DINODE_FMT_BTREE ? 1 : 0);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -280,8 +285,17 @@ xfs_ifork_init_attr(
 	enum xfs_dinode_fmt	format,
 	xfs_extnum_t		nextents)
 {
+	/*
+	 * Initialize the extent count early, as the per-format routines may
+	 * depend on it.  Use release semantics to set needextents /after/ we
+	 * set the format. This ensures that we can use acquire semantics on
+	 * needextents in xfs_need_iread_extents() and be guaranteed to see a
+	 * valid format value after that load.
+	 */
 	ip->i_af.if_format = format;
 	ip->i_af.if_nextents = nextents;
+	smp_store_release(&ip->i_af.if_needextents,
+			   ip->i_af.if_format == XFS_DINODE_FMT_BTREE ? 1 : 0);
 }
 
 void
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index d3943d6ad0b..96d307784c8 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -24,6 +24,7 @@ struct xfs_ifork {
 	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
+	uint8_t			if_needextents;	/* extents have not been read */
 };
 
 /*
@@ -260,9 +261,10 @@ int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
 
 /* returns true if the fork has extents but they are not read in yet. */
-static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
+static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)
 {
-	return ifp->if_format == XFS_DINODE_FMT_BTREE && ifp->if_height == 0;
+	/* see xfs_iformat_{data,attr}_fork() for needextents semantics */
+	return smp_load_acquire(&ifp->if_needextents) != 0;
 }
 
 #endif	/* __XFS_INODE_FORK_H__ */
