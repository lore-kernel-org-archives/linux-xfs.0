Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793846953;
	b=ICfjjsbBbTeOWJ5cNB2pkBleo7TV8wULDHjr5qumDWZi+WkvarWPFeP7TMVml5wwQJuU
	 i7tXnkfBreDDfse29Ez/K4FsvGHC8mZkSTPrnb0yLd9V/R3slgd4cypOGEt1CMyE+JIPK
	 5zu9lAF/abTGYdeuyEHphgGOUo0H8FHcc+kvTwjFSHh8erdvN+0h6g1vcsT9OHn7B/iLD
	 crEK6eytgCn4bSZN0WYN3HU7t4bB6R8NpdHiAObJyGdWHsY97UNuxGts/jRPVaKgEtJER
	 C9AKTAlmN+nPUtRH5bklwqljW07kTkXfk/GU8e8X0ifzgGU+es0qp4jbKuf9lezNecA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793846953;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DCLGFdYvcqObMFyzLQJG/0MKrtziKFlAkpQcicWA5bo=;
	b=mDyXY2moYqsvb427CFzZ0NsdiIA0RZo6TSI9gtOFfAkxwJC+rUTTFMaffM/pM4Gz1Rc/
	 xlcMmLvly7CPnJR5azzd3XzD7QMX3BDCyFjHt74xsX8gPKQm1sCWsS8UHAUrttg00A0AA
	 UdWQGqOyvDu/x1Ii69PvYBhkP4nqSKpGElkHBDT+4vxjM3vCcVjRcssT/xaTtxeG8qH/C
	 bLG0lF3EvWsT1hg7L0TXtwws2qIbfU6CmWI/SxOoPULDJhap7qx4IfBmZFxE9vrVtQElO
	 Tf6L0qBpGJQRMd5Dt/GZZRmm9zQMjAZQo333aYkuw8CIR3idS6MPo6KwkhXjugnMYxg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZjgEJw+K;
	arc=fail smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A826606A32E;
	Thu,  5 Nov 2026 02:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZjgEJw+K
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793846953;
	b=kdd7fAxF2xUhKsRe8PhZRnsgE9yHTnavOKsyGCVg87USz/xVGrJ6xEYHR4NmF56i8iyk
	 TJaDxgckOY+uTeNbzVUfW4YnNFvVTNzEf62wrJz5VIEQ4J8/q+JF5IDjADjAHMHEx9IHc
	 ysWYD+36KREWo5iv3/KmhoVmoayUlGNyjAe70j3wVRDH8acxufyrPyli3qb9D344cFlzQ
	 L/OOadfyOhH+X9r1ePqQ22KeiV/bZwFCK6NOhvxLsrPmBCKiydgiVvZBmENLsR18puKks
	 NeOe4hoDq3KkTwUBjizqGxK/7Zh7EslZFeruZAde4Hd8Nr/r3aQUOTGYhN/KablqCxw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793846953;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DCLGFdYvcqObMFyzLQJG/0MKrtziKFlAkpQcicWA5bo=;
	b=RERPXBIZ68E561rmNhnQfEGYBo3MfYJNykDgo6xmxNTG6GifJl4x8BOyUJGzf7+rLGC3
	 /c1GkaHagsVcW43EwkBzqMlPVJK3HmRB/AQEQ1EX3SYr+8Ap71qIVu0PVCqnA7dTruthS
	 SyVlrg/EpzrhJv2uXZxJ1TjY1uiYxkuJXNjuGNCybsuOxaWn8aLArc6BhW+knya6IP7pN
	 a7by1FWjC0xb1Cer/28zIx32r/9BcocYa3drOtYjeXZ+PbTzFNnIjHFfJITr6tUUem7r7
	 /em5/IcxeCY+8kZ7HIT6elSXZmqsLz/brgqBpexWoY9zcIskPbpxviGis767fgJZT9g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 933291F0093A;
	Thu,  5 Nov 2026 02:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793846953;
	bh=DCLGFdYvcqObMFyzLQJG/0MKrtziKFlAkpQcicWA5bo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZjgEJw+KzU6mkeeSR6RE6pdYKTOPQ89tLFerYJ2YP2GYRJDEOsbPDkoaHJVX3uL4q
	 r+AWMyud8x7BRShCqqPANCsobzbyHagZdABbI4rvMmgCaTzuoX8wPI/Qb2GFbNrxpG
	 Gwp0C8+B5vIphcBk3B935b5U4BnvTIRopv2JCHgpeyUSJatRrH4hIl/thmx2QMZmaJ
	 KLeQAua2C5B59+SQIYbWI3hLT8arza0eCsU62kc62VkopGx4q6ZMv3QI/D17xQX0XO
	 sLh0UkcsWH17auFNyWJqq1sHWQ/33+ZBr1k4W3o+cI0q7WBVgycaTdMxXrYwOTOd+b
	 evjRxt5HqwKdg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 22D7247059;
	Thu,  5 Nov 2026 02:49:12 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 05 Nov 2026 11:49:13 +0900
Subject: [PATCH 2/2] xfs: skip the fsync flush when a later flush has
 completed
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261105-xfs-fsync-flush-seq-v1-2-299bdf5e28c3@samsung.com>
References: <20261105-xfs-fsync-flush-seq-v1-0-299bdf5e28c3@samsung.com>
In-Reply-To: <20261105-xfs-fsync-flush-seq-v1-0-299bdf5e28c3@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793846951; l=5190;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=CP7EIACxnvec5vGCIOS285YW810d9eW4b4Yw8xE5yJ0=;
 b=yCLjYvB4h1N4WikF8IL9ngx0V236OUzrUIe7C7Wl3iaYQoEQQF9sVeb/YT07vIjb60JRlMDoY
 aDYX3acWrSECc1M14Zd7VntKsIBIRHaeEfdw/FQcZOSWxKPI5kz0dAd
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Since commit 47c7d0b19502 ("xfs: fix incorrect log_flushed on
fsync"), fsync sends its own cache flush whenever another task wrote
out the iclog it waited for. With concurrent fsyncs, these flushes can
limit throughput.

Skip the flush when a flush submitted after the data writes completed
has finished. Number the fsync's own flush too, so that concurrent
fsyncs can share it. DAX does not use the new skip, because DAX writes
do not go through block I/O.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
16 fio jobs of 4k append + fsync, QEMU guest on a 990 PRO without
power loss protection (virtio-blk, cache=none): 809 -> 4185 fsyncs/s,
mean fsync latency 19.8 -> 3.8 ms.

dm-log-writes with 8 fsync writers: no fsync-ed block was lost in 528
replays, while at least 33257 of 48048 fsyncs skipped their flush
through the new check. Taking the snapshot before the writeback loses
15 of 528. The test needs "dm-log-writes: log earlier flushes' writes
when a later flush completes", sent to dm-devel.
---
 fs/xfs/xfs_buf.c  | 26 ++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h  | 19 +++++++++++++++++++
 fs/xfs/xfs_file.c | 21 +++++++++++++++------
 3 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9025b177931..6b545d79a41 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1785,6 +1785,32 @@ xfs_buftarg_flush_done(
 		;
 }
 
+/*
+ * Return true if a flush numbered above @seq has completed. All writes that
+ * completed before @seq was read are then on stable storage.
+ */
+bool
+xfs_buftarg_flushed_since(
+	struct xfs_buftarg	*btp,
+	s64			seq)
+{
+	return atomic64_read(&btp->bt_flush_completed) > seq;
+}
+
+/* Flush the device cache and record it. */
+int
+xfs_buftarg_flush(
+	struct xfs_buftarg	*btp)
+{
+	s64			seq = xfs_buftarg_flush_start(btp);
+	int			error;
+
+	error = blkdev_issue_flush(btp->bt_bdev);
+	if (!error)
+		xfs_buftarg_flush_done(btp, seq);
+	return error;
+}
+
 struct xfs_buftarg *
 xfs_alloc_buftarg(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index e8ca4452025..0f48ee6d3f2 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -368,6 +368,23 @@ struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
 		struct file *bdev_file);
 extern void xfs_free_buftarg(struct xfs_buftarg *);
 
+/*
+ * Call after the writes that a flush must cover have completed, and pass the
+ * result to xfs_buftarg_flushed_since().
+ */
+static inline s64
+xfs_buftarg_flush_seq(
+	struct xfs_buftarg	*btp)
+{
+	/*
+	 * Order the read after the write completions the caller waited for.
+	 * Pairs with the fully ordered atomic64_inc_return() that
+	 * xfs_buftarg_flush_start() does before the flush is submitted.
+	 */
+	smp_mb();
+	return atomic64_read(&btp->bt_flush_submitted);
+}
+
 /* Call right before submitting a cache flush to @btp. */
 static inline s64
 xfs_buftarg_flush_start(
@@ -377,6 +394,8 @@ xfs_buftarg_flush_start(
 }
 
 void xfs_buftarg_flush_done(struct xfs_buftarg *btp, s64 seq);
+bool xfs_buftarg_flushed_since(struct xfs_buftarg *btp, s64 seq);
+int xfs_buftarg_flush(struct xfs_buftarg *btp);
 extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
 int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 396aca8c66a..a98361e9ead 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -87,7 +87,9 @@ xfs_file_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
+	struct xfs_buftarg	*btp = xfs_inode_buftarg(ip);
 	int			log_flushed = 0;
+	s64			flush_seq;
 	int			error;
 
 	trace_xfs_file_fsync(ip);
@@ -95,6 +97,7 @@ xfs_file_fsync(
 	error = file_write_and_wait_range(file, start, end);
 	if (error)
 		return error;
+	flush_seq = xfs_buftarg_flush_seq(btp);
 
 	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
@@ -115,16 +118,22 @@ xfs_file_fsync(
 	}
 
 	/*
-	 * If the log force was a no-op, we may still need to flush the
-	 * file data target cache here. This can happen for fdatasync/O_DSYNC
-	 * when no metadata needed to be committed.
+	 * Flush the file data target unless a flush submitted to it after the
+	 * data writes above completed has already finished. That is usually
+	 * the flush before an iclog written out by this log force or by
+	 * another task, or another fsync's flush.
+	 *
+	 * DAX writes are CPU stores, not block I/O, and the check above
+	 * relies on REQ_PREFLUSH covering completed block I/O. So DAX only
+	 * skips the flush when this log force flushed, as before.
 	 *
 	 * Use the inode's actual file data target rather than assuming the
 	 * main data device.
 	 */
-	if (!log_flushed)
-		return blkdev_issue_flush(xfs_inode_buftarg(ip)->bt_bdev);
-	return 0;
+	if (log_flushed ||
+	    (!IS_DAX(VFS_I(ip)) && xfs_buftarg_flushed_since(btp, flush_seq)))
+		return 0;
+	return xfs_buftarg_flush(btp);
 }
 
 static int

-- 
2.43.0


