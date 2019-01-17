Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbfAQQhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 11:37:09 -0500
Received: from 089144213167.atnat0022.highway.a1.net ([89.144.213.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gkAfE-00048g-9u
        for linux-xfs@vger.kernel.org; Thu, 17 Jan 2019 16:37:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/11] xfs: introduce an always_cow mode
Date: Thu, 17 Jan 2019 17:36:36 +0100
Message-Id: <20190117163636.23171-12-hch@lst.de>
In-Reply-To: <20190117163636.23171-1-hch@lst.de>
References: <20190117163636.23171-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add a mode where XFS never overwrites existing blocks in place.  This
is to aid debugging our COW code, and also put infatructure in place
for things like possible future support for zoned block devices, which
can't support overwrites.

This mode is enabled globally by doing a:

    echo 1 > /sys/fs/xfs/debug/always_cow

Note that the parameter is global to allow running all tests in xfstests
easily in this mode, which would not easily be possible with a per-fs
sysfs file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c    |  2 +-
 fs/xfs/xfs_file.c    | 11 ++++++++++-
 fs/xfs/xfs_iomap.c   | 28 ++++++++++++++++++----------
 fs/xfs/xfs_reflink.c | 28 ++++++++++++++++++++++++----
 fs/xfs/xfs_reflink.h | 13 +++++++++++++
 fs/xfs/xfs_super.c   | 13 +++++++++----
 fs/xfs/xfs_sysctl.h  |  1 +
 fs/xfs/xfs_sysfs.c   | 24 ++++++++++++++++++++++++
 8 files changed, 100 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 64dd16712dc3..19cba00d3269 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -986,7 +986,7 @@ xfs_vm_bmap(
 	 * Since we don't pass back blockdev info, we can't return bmap
 	 * information for rt files either.
 	 */
-	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
+	if (xfs_is_cow_inode(ip) || XFS_IS_REALTIME_INODE(ip))
 		return 0;
 	return iomap_bmap(mapping, block, &xfs_iomap_ops);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e47425071e65..8d2be043590a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -507,7 +507,7 @@ xfs_file_dio_aio_write(
 		 * We can't properly handle unaligned direct I/O to reflink
 		 * files yet, as we can't unshare a partial block.
 		 */
-		if (xfs_is_reflink_inode(ip)) {
+		if (xfs_is_cow_inode(ip)) {
 			trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
 			return -EREMCHG;
 		}
@@ -806,6 +806,15 @@ xfs_file_fallocate(
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, iolock);
+	/*
+	 * If always_cow mode we can't use preallocation and thus should not
+	 * allow creating them.
+	 */
+	if (xfs_is_always_cow_inode(ip) && (mode & ~FALLOC_FL_KEEP_SIZE) == 0) {
+		error = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
 	if (error)
 		goto out_unlock;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 95d7a21a8152..99454be3d2b5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -395,12 +395,13 @@ xfs_quota_calc_throttle(
 STATIC xfs_fsblock_t
 xfs_iomap_prealloc_size(
 	struct xfs_inode	*ip,
+	int			whichfork,
 	loff_t			offset,
 	loff_t			count,
 	struct xfs_iext_cursor	*icur)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	struct xfs_bmbt_irec	prev;
 	int			shift = 0;
@@ -593,7 +594,11 @@ xfs_file_iomap_begin_delay(
 	 * themselves.  Second the lookup in the extent list is generally faster
 	 * than going out to the shared extent tree.
 	 */
-	if (xfs_is_reflink_inode(ip)) {
+	if (xfs_is_cow_inode(ip)) {
+		if (!ip->i_cowfp) {
+			ASSERT(!xfs_is_reflink_inode(ip));
+			xfs_ifork_init_cow(ip);
+		}
 		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
 				&ccur, &cmap);
 		if (!cow_eof && cmap.br_startoff <= offset_fsb) {
@@ -609,7 +614,7 @@ xfs_file_iomap_begin_delay(
 		 * overwriting shared extents.   This includes zeroing of
 		 * existing extents that contain data.
 		 */
-		if (!xfs_is_reflink_inode(ip) ||
+		if (!xfs_is_cow_inode(ip) ||
 		    ((flags & IOMAP_ZERO) && imap.br_state != XFS_EXT_NORM)) {
 			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
 					&imap);
@@ -619,7 +624,7 @@ xfs_file_iomap_begin_delay(
 		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 
 		/* Trim the mapping to the nearest shared extent boundary. */
-		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
+		error = xfs_inode_need_cow(ip, &imap, &shared);
 		if (error)
 			goto out_unlock;
 
@@ -648,15 +653,18 @@ xfs_file_iomap_begin_delay(
 		 */
 		count = min_t(loff_t, count, 1024 * PAGE_SIZE);
 		end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
+
+		if (xfs_is_always_cow_inode(ip))
+			whichfork = XFS_COW_FORK;
 	}
 
 	error = xfs_qm_dqattach_locked(ip, false);
 	if (error)
 		goto out_unlock;
 
-	if (eof && whichfork == XFS_DATA_FORK) {
-		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count,
-				&icur);
+	if (eof) {
+		prealloc_blocks = xfs_iomap_prealloc_size(ip, whichfork, offset,
+				count, &icur);
 		if (prealloc_blocks) {
 			xfs_extlen_t	align;
 			xfs_off_t	end_offset;
@@ -988,7 +996,7 @@ xfs_ilock_for_iomap(
 	 * COW writes may allocate delalloc space or convert unwritten COW
 	 * extents, so we need to make sure to take the lock exclusively here.
 	 */
-	if (xfs_is_reflink_inode(ip) && is_write) {
+	if (xfs_is_cow_inode(ip) && is_write) {
 		/*
 		 * FIXME: It could still overwrite on unshared extents and not
 		 * need allocation.
@@ -1022,7 +1030,7 @@ xfs_ilock_for_iomap(
 	 * check, so if we got ILOCK_SHARED for a write and but we're now a
 	 * reflink inode we have to switch to ILOCK_EXCL and relock.
 	 */
-	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_reflink_inode(ip)) {
+	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_cow_inode(ip)) {
 		xfs_iunlock(ip, mode);
 		mode = XFS_ILOCK_EXCL;
 		goto relock;
@@ -1094,7 +1102,7 @@ xfs_file_iomap_begin(
 	 * Break shared extents if necessary. Checks for non-blocking IO have
 	 * been done up front, so we don't need to do them here.
 	 */
-	if (xfs_is_reflink_inode(ip)) {
+	if (xfs_is_cow_inode(ip)) {
 		struct xfs_bmbt_irec	orig = imap;
 
 		/* if zeroing doesn't need COW allocation, then we are done. */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f84b37fa4f17..e2d9179bd50d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -192,7 +192,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
+	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
@@ -234,6 +234,23 @@ xfs_reflink_trim_around_shared(
 	}
 }
 
+bool
+xfs_inode_need_cow(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	bool			*shared)
+{
+	/* We can't update any real extents in always COW mode. */
+	if (xfs_is_always_cow_inode(ip) &&
+	    !isnullstartblock(imap->br_startblock)) {
+		*shared = true;
+		return 0;
+	}
+
+	/* Trim the mapping to the nearest shared extent boundary. */
+	return xfs_reflink_trim_around_shared(ip, imap, shared);
+}
+
 static int
 xfs_reflink_convert_cow_locked(
 	struct xfs_inode	*ip,
@@ -321,7 +338,7 @@ xfs_find_trim_cow_extent(
 	if (got.br_startoff > offset_fsb) {
 		xfs_trim_extent(imap, imap->br_startoff,
 				got.br_startoff - imap->br_startoff);
-		return xfs_reflink_trim_around_shared(ip, imap, shared);
+		return xfs_inode_need_cow(ip, imap, shared);
 	}
 
 	*shared = true;
@@ -356,7 +373,10 @@ xfs_reflink_allocate_cow(
 	xfs_extlen_t		resblks = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(xfs_is_reflink_inode(ip));
+	if (!ip->i_cowfp) {
+		ASSERT(!xfs_is_reflink_inode(ip));
+		xfs_ifork_init_cow(ip);
+	}
 
 	error = xfs_find_trim_cow_extent(ip, imap, shared, &found);
 	if (error || !*shared)
@@ -542,7 +562,7 @@ xfs_reflink_cancel_cow_range(
 	int			error;
 
 	trace_xfs_reflink_cancel_cow_range(ip, offset, count);
-	ASSERT(xfs_is_reflink_inode(ip));
+	ASSERT(ip->i_cowfp);
 
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	if (count == NULLFILEOFF)
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 4a9e3cd4768a..aad222aa0b23 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -6,11 +6,24 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
+static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
+{
+	return xfs_globals.always_cow &&
+		xfs_sb_version_hasreflink(&ip->i_mount->m_sb);
+}
+
+static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
+{
+	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
+}
+
 extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
 		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
+bool xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
+		bool *shared);
 
 extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c9097cb0b955..0835eed77295 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1729,11 +1729,16 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb) && mp->m_sb.sb_rblocks) {
-		xfs_alert(mp,
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		if (mp->m_sb.sb_rblocks) {
+			xfs_alert(mp,
 	"reflink not compatible with realtime device!");
-		error = -EINVAL;
-		goto out_filestream_unmount;
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
+
+		if (xfs_globals.always_cow)
+			xfs_info(mp, "using DEBUG-only always_cow mode.");
 	}
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 168488130a19..ad7f9be13087 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -85,6 +85,7 @@ struct xfs_globals {
 	int	log_recovery_delay;	/* log recovery delay (secs) */
 	int	mount_delay;		/* mount setup delay (secs) */
 	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
+	bool	always_cow;		/* use COW fork for all overwrites */
 };
 extern struct xfs_globals	xfs_globals;
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index cd6a994a7250..cabda13f3c64 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -183,10 +183,34 @@ mount_delay_show(
 }
 XFS_SYSFS_ATTR_RW(mount_delay);
 
+static ssize_t
+always_cow_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	ssize_t		ret;
+
+	ret = kstrtobool(buf, &xfs_globals.always_cow);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+static ssize_t
+always_cow_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.always_cow);
+}
+XFS_SYSFS_ATTR_RW(always_cow);
+
 static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(bug_on_assert),
 	ATTR_LIST(log_recovery_delay),
 	ATTR_LIST(mount_delay),
+	ATTR_LIST(always_cow),
 	NULL,
 };
 
-- 
2.20.1
