Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D497C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 062AE22AAD
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbhAKQNr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731126AbhAKQNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 11:13:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC13C06179F
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 08:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=cbIw9yTpmiqE5A5cQSUB1pHaMENT83rXvBIEE+JumTg=; b=mhCQ0lOdJgyhqES/4r7k5S5wgl
        bTD4iQTq0rOjHJFNWQG07Ad3gcalhQBCmEILwCdxp1Dgb3bLe5KiIDhsa5/edyKMovbv23yjJf/ii
        /b+8nuz7qrOJ6jBooSO5gtkQ4au9c0ylwW7QUG6zrhzpr3G+2+6rrFZ+ARABIS0+SI2jecv5IolPA
        MqX0JgmTFyH5cUuYhr3WBOtpVjHfzebi/jPNToJrBXx1UyBsw72RlFTfkCjuU8YrGdiXc7k5KpbH7
        pdXeY73lizNUkw6IIRFUTwF0TI2gZs+FPxnYurPWMt356LmXvg+ZvCOgfNhaGeb0vJ2GMfgxB0PL9
        nDVmTicQ==;
Received: from [2001:4bb8:19b:e528:814e:4181:3d37:5818] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyzoT-003TWz-HS; Mon, 11 Jan 2021 16:13:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Avi Kivity <avi@scylladb.com>, Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/3] xfs: try to avoid the iolock exclusive for non-aligned direct writes
Date:   Mon, 11 Jan 2021 17:12:12 +0100
Message-Id: <20210111161212.1414034-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111161212.1414034-1-hch@lst.de>
References: <20210111161212.1414034-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We only need the exclusive iolock for direct writes to protect sub-block
zeroing after an allocation or conversion of unwritten extents, and the
synchronous execution of these writes is also only needed because the
iolock is dropped early for the dodgy i_dio_count synchronisation.

Always start out with the shared iolock in xfs_file_dio_aio_write for
non-appending writes and only upgrade it to exclusive if the start and
end of the write range are not already allocated and in written
state.  This means one or two extra lookups in the in-core extent tree,
but with our btree data structure those lookups are very cheap and do
not show up in profiles on NVMe hardware for me.  On the other hand
avoiding the lock allows for a high concurrency using aio or io_uring.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Avi Kivity <avi@scylladb.com>
Suggested-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c | 127 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 96 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1470fc4f2e0255..59d4c6e90f06c1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -521,6 +521,57 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
 	.end_io		= xfs_dio_write_end_io,
 };
 
+static int
+xfs_dio_write_exclusive(
+	struct kiocb		*iocb,
+	size_t			count,
+	bool			*exclusive_io)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = &ip->i_df;
+	loff_t			offset = iocb->ki_pos;
+	loff_t			end = offset + count;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end);
+	struct xfs_bmbt_irec	got = { };
+	struct xfs_iext_cursor	icur;
+	int			ret;
+
+	*exclusive_io = true;
+
+	/*
+	 * Bmap information not read in yet or no blocks allocated at all?
+	 */
+	if (!(ifp->if_flags & XFS_IFEXTENTS) || !ip->i_d.di_nblocks)
+		return 0;
+
+	ret = xfs_ilock_iocb(iocb, XFS_ILOCK_SHARED);
+	if (ret)
+		return ret;
+
+	if (offset & mp->m_blockmask) {
+		if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got) ||
+		    got.br_startoff > offset_fsb ||
+		    got.br_state == XFS_EXT_UNWRITTEN)
+		    	goto out_unlock;
+	}
+
+	if ((end & mp->m_blockmask) &&
+	    got.br_startoff + got.br_blockcount <= end_fsb) {
+		if (!xfs_iext_lookup_extent(ip, ifp, end_fsb, &icur, &got) ||
+		    got.br_startoff > end_fsb ||
+		    got.br_state == XFS_EXT_UNWRITTEN)
+		    	goto out_unlock;
+	}
+
+	*exclusive_io = false;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return ret;
+}
+
 /*
  * xfs_file_dio_aio_write - handle direct IO writes
  *
@@ -557,8 +608,9 @@ xfs_file_dio_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
-	int			unaligned_io = 0;
-	int			iolock;
+	int			iolock = XFS_IOLOCK_SHARED;
+	bool			subblock_io = false;
+	bool			exclusive_io = false;
 	size_t			count = iov_iter_count(from);
 	struct xfs_buftarg      *target = xfs_inode_buftarg(ip);
 
@@ -566,45 +618,58 @@ xfs_file_dio_aio_write(
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
 		return -EINVAL;
 
-	/*
-	 * Don't take the exclusive iolock here unless the I/O is unaligned to
-	 * the file system block size.  We don't need to consider the EOF
-	 * extension case here because xfs_file_aio_write_checks() will relock
-	 * the inode as necessary for EOF zeroing cases and fill out the new
-	 * inode size as appropriate.
-	 */
+	/* I/O that is not aligned to the fsblock size will need special care */
 	if ((iocb->ki_pos & mp->m_blockmask) ||
-	    ((iocb->ki_pos + count) & mp->m_blockmask)) {
-		unaligned_io = 1;
+	    ((iocb->ki_pos + count) & mp->m_blockmask))
+		subblock_io = true;
 
-		/*
-		 * We can't properly handle unaligned direct I/O to reflink
-		 * files yet, as we can't unshare a partial block.
-		 */
-		if (xfs_is_cow_inode(ip)) {
-			trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
-			return -ENOTBLK;
-		}
-		iolock = XFS_IOLOCK_EXCL;
-	} else {
-		iolock = XFS_IOLOCK_SHARED;
+	/*
+	 * We can't properly handle unaligned direct I/O to reflink files yet,
+	 * as we can't unshare a partial block.
+	 */
+	if (subblock_io && xfs_is_cow_inode(ip)) {
+		trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
+		return -ENOTBLK;
 	}
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		/* unaligned dio always waits, bail */
-		if (unaligned_io)
-			return -EAGAIN;
-		if (!xfs_ilock_nowait(ip, iolock))
+	/*
+	 * Racy shortcut for obvious appends to avoid too much relocking:
+	 */
+	if (iocb->ki_pos > i_size_read(inode)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
 			return -EAGAIN;
-	} else {
-		xfs_ilock(ip, iolock);
+		iolock = XFS_IOLOCK_EXCL;
 	}
 
+relock:
+	ret = xfs_ilock_iocb(iocb, iolock);
+	if (ret)
+		return ret;
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
 	count = iov_iter_count(from);
 
+	/*
+	 * Upgrade to an exclusive lock and force synchronous completion if the
+	 * I/O will require partial block zeroing.
+	 * We don't need to consider the EOF extension case here because
+	 * xfs_file_aio_write_checks() will relock the inode as necessary for
+	 * EOF zeroing cases and fill out the new inode size as appropriate.
+	 */
+	if (iolock != XFS_IOLOCK_EXCL && subblock_io) {
+		ret = xfs_dio_write_exclusive(iocb, count, &exclusive_io);
+		if (ret)
+			goto out;
+		if (exclusive_io) {
+			xfs_iunlock(ip, iolock);
+			if (iocb->ki_flags & IOCB_NOWAIT)
+				return -EAGAIN;
+			iolock = XFS_IOLOCK_EXCL;
+			goto relock;
+		}
+	}
+
 	/*
 	 * If we are doing unaligned IO, we can't allow any other overlapping IO
 	 * in-flight at the same time or we risk data corruption. Wait for all
@@ -612,7 +677,7 @@ xfs_file_dio_aio_write(
 	 * iolock if we had to take the exclusive lock in
 	 * xfs_file_aio_write_checks() for other reasons.
 	 */
-	if (unaligned_io) {
+	if (exclusive_io) {
 		inode_dio_wait(inode);
 	} else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
@@ -626,7 +691,7 @@ xfs_file_dio_aio_write(
 	 */
 	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
 			   &xfs_dio_write_ops,
-			   is_sync_kiocb(iocb) || unaligned_io);
+			   is_sync_kiocb(iocb) || exclusive_io);
 out:
 	if (iolock)
 		xfs_iunlock(ip, iolock);
-- 
2.29.2

