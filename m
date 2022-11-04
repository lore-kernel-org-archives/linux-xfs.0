Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD574C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 18:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiKDSZX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 14:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiKDSZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 14:25:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEEE121275
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 11:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667586233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vv7Ueb+sj7o+jJmlQoW8tsGT6dXLspFGmGj6oqgOXvI=;
        b=XON5lzfszt19izTSpA9nacb4oTP4zFXhyoXJfU8U9i18XMH7b5ZFFmxOLjUNfiv3xdmODk
        oxTh0hh9J05z85TwIv/TKshJJdojFa01ZUjPooZu8R8Tzfpy077iNCRQ59n4h4K75VmwxH
        amKHcXyvc83iZVftz8bg1q0QsbQDXPk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-CjFZUo9pOo-JD2YCW9SW-w-1; Fri, 04 Nov 2022 14:23:52 -0400
X-MC-Unique: CjFZUo9pOo-JD2YCW9SW-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38ED1811E7A
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 18:23:52 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 192F82166B26
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 18:23:52 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: move truncate zeroing flush into ->iomap_begin()
Date:   Fri,  4 Nov 2022 14:23:58 -0400
Message-Id: <20221104182358.2007475-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The truncate code has a tortured history of hacks trying to prevent
various consistency problems. The most recent example is the flush
introduced by commit 869ae85dae64b ("xfs: flush new eof page on
truncate to avoid post-eof corruption") to work around the fact that
iomap zeroing doesn't handle certain extent types properly when
backed by dirty pagecache. Unfortunately, this workaround has shown
to cause a significant performance impact in certain small file
overwrite and truncate workloads.

The ideal solution here is for iomap to learn to handle such dirty
cache scenarios and perform proper zeroing, but that is not a
trivial endeavor and may depend on additional functionality that is
not currently complete. In lieu of that goal, we can move the
unconditional flush in the truncate path one step closer to iomap by
moving it into ->iomap_begin(). This allows selective invocation for
only the scenarios where the mapping type can change in the
background, and therefore avoids the flush completely in the
aforementioned overwrite scenario and provides a significant
improvement in latency of such operations. For example, from a test
program doing a small, fixed size overwrite and truncate:

On recent master:

path /mnt/file, 100000 iters
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 81.56    1.626925          16    100000           ftruncate
 18.42    0.367488           3    100000           pwrite64
...

v6.1.0-rc3 with this patch:

path /mnt/file, 100000 iters
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 74.76    1.077406          10    100000           ftruncate
 25.19    0.363060           3    100000           pwrite64
...

This also has the side effect of helping to prevent further
outstanding post-eof data zeroing issues caused by the same
fundamental iomap problem. For example, consider the following
(somewhat contrived) example that demonstrates a potential stale
data exposure vector.

On recent mainline:

$ xfs_io -fc "falloc 0 1k" -c "pwrite 0 1k" \
  -c "mmap 0 4k" -c "mwrite 3k 1k" \
  -c "pwrite 32k 4k" -c fsync -c "pread -v 3k 32" <file>
...
00000c00:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58  XXXXXXXXXXXXXXXX
00000c10:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58  XXXXXXXXXXXXXXXX

... while the same command with this patch produces:

00000c00:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000c10:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

... which also happens to match behavior with the first falloc
subcommand removed.

While this patch does not implement full iomap based handling of
dirty pagecache data, it improves correctness, performance, is
simple enough for stable backports, and doesn't preclude replacement
by more advanced or efficient solutions via iomap in the future.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is a followup to the RFC and discussion here[1]. Towards the end,
Dave describes an approach to implement iomap pagecache zeroing based on
the recently posted iomap stale mapping detection. While that sounds
plausible, it's a notable jump in complexity and test scope and a more
involved dependency chain than is necessary to fix the performance and
stale data exposure problems.

Therefore I'm posting this modified variant as an intermediate step
toward that goal. Since there is apparent overlap between the iomap
based RFC and stale iomap detection, this instead relocates the
flush/retry step into the ->iomap_begin() callback such that it can be
lifted into iomap sometime later when proper support mechanisms to
validate pagecache state against extent state are stabilized. This can
potentially enable a higher level folio state check or more explicit
folio zeroing to avoid the need to flush entirely.

Brian

[1] https://lore.kernel.org/linux-xfs/20221028130411.977076-1-bfoster@redhat.com/

 fs/xfs/xfs_iomap.c | 65 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_iops.c  | 10 -------
 2 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 07da03976ec1..de61d68b2f77 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -895,6 +895,25 @@ const struct iomap_ops xfs_dax_write_iomap_ops = {
 	.iomap_end	= xfs_dax_write_iomap_end,
 };
 
+/*
+ * Determine whether a mapping requires a flush and retry before returning to
+ * iomap. This is restricted to cases where a flush may change extent state in a
+ * way known to change iomap behavior.
+ */
+static inline bool
+imap_needs_flush(
+	unsigned		flags,
+	bool			range_dirty,
+	struct xfs_bmbt_irec	*imap)
+{
+	if (!(flags & IOMAP_ZERO))
+		return false;
+	if (!range_dirty)
+		return false;
+	return imap->br_startblock == HOLESTARTBLOCK ||
+		imap->br_state == XFS_EXT_UNWRITTEN;
+}
+
 static int
 xfs_buffered_write_iomap_begin(
 	struct inode		*inode,
@@ -908,10 +927,12 @@ xfs_buffered_write_iomap_begin(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
+	loff_t			endoff = offset + count - 1;
 	struct xfs_bmbt_irec	imap, cmap;
 	struct xfs_iext_cursor	icur, ccur;
 	xfs_fsblock_t		prealloc_blocks = 0;
 	bool			eof = false, cow_eof = false, shared = false;
+	bool			range_dirty;
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 	unsigned int		lockmode = XFS_ILOCK_EXCL;
@@ -926,6 +947,8 @@ xfs_buffered_write_iomap_begin(
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 
+restart:
+	range_dirty = false;
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -942,6 +965,24 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * Certain operations may not work correctly if the associated file
+	 * range is dirty in pagecache. For example, zeroing skips unwritten
+	 * extents even if uptodate and dirty folios exist in cache. This can
+	 * cause various sorts of stale data exposure problems where zeroing is
+	 * used as part of truncate or size extending I/O operations that don't
+	 * typically flush and invalidate cache beforehand.
+	 *
+	 * To prevent this problem, flush and convert any such extent mappings
+	 * before returning to iomap. Ideally, iomap should learn to handle
+	 * pagecache correctly on its own so this can be removed. Note that this
+	 * flush should be relatively uncommon as most heavy zero range users
+	 * flush and invalidate the entire target range, so this is a simple,
+	 * low overhead step to prevent data corruption issues.
+	 */
+	if (filemap_range_needs_writeback(inode->i_mapping, offset, endoff))
+		range_dirty = true;
+
 	/*
 	 * Search the data fork first to look up our source mapping.  We
 	 * always need the data fork map, as we have to return it to the
@@ -952,8 +993,18 @@ xfs_buffered_write_iomap_begin(
 	if (eof)
 		imap.br_startoff = end_fsb; /* fake hole until the end */
 
-	/* We never need to allocate blocks for zeroing a hole. */
+	/*
+	 * We never need to allocate blocks for zeroing a hole, but we might
+	 * need to flush the mapping if dirty. This could mean the range is at
+	 * least partially backed by the COW fork. This is generally unexpected,
+	 * but writeback handles this situation so let it resolve the conflict
+	 * and ensure zeroing does the right thing.
+	 */
 	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
+		if (imap_needs_flush(flags, range_dirty, &imap)) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			goto flush_restart;
+		}
 		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
 		goto out_unlock;
 	}
@@ -1100,11 +1151,15 @@ xfs_buffered_write_iomap_begin(
 
 found_imap:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (imap_needs_flush(flags, range_dirty, &imap))
+		goto flush_restart;
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
 
 found_cow:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (imap.br_startoff <= offset_fsb) {
+		if (imap_needs_flush(flags, range_dirty, &imap))
+			goto flush_restart;
 		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0);
 		if (error)
 			return error;
@@ -1112,12 +1167,20 @@ xfs_buffered_write_iomap_begin(
 					 IOMAP_F_SHARED);
 	}
 
+	if (imap_needs_flush(flags, range_dirty, &cmap))
+		goto flush_restart;
 	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
+
+flush_restart:
+	error = filemap_write_and_wait_range(inode->i_mapping, offset, endoff);
+	if (!error)
+		goto restart;
+	return error;
 }
 
 static int
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2e10e1c66ad6..3c40a81d6da0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -840,16 +840,6 @@ xfs_setattr_size(
 		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
 				&did_zeroing);
 	} else {
-		/*
-		 * iomap won't detect a dirty page over an unwritten block (or a
-		 * cow block over a hole) and subsequently skips zeroing the
-		 * newly post-EOF portion of the page. Flush the new EOF to
-		 * convert the block before the pagecache truncate.
-		 */
-		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
-						     newsize);
-		if (error)
-			return error;
 		error = xfs_truncate_page(ip, newsize, &did_zeroing);
 	}
 
-- 
2.37.3

