Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794367033;
	b=XQvdmK5xEiig40AMRyqcvIdlQOT9H5nGersixFpRHWnnuu7x878RlTiefELe8GqLWrQt
	 y0WvTSBkhQd5dVZTX2DdXFDrimaO9aZ3E5qkE/2qql9M6WZEqRZsFawF9mh8lyhiJSwl0
	 rwAPLrh+WW/QjUeEiY7QERa+WWqkBPiUXmNdCX/6cHxYB/I2sUG4Q0yFuqMFIt4GfNktw
	 UEAnZYKBHx6CUlmFDaibnUDTFthXmXdxO9m52+EUbzo/RTvEy5iR+/f16BU//in8sJCmm
	 FWpIJow3zUYXnhODeIRRMXjysnL/TdQyYIg5P7e4YJrqg3hVo6ROtvonn0v0hhWGXBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794367033;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+wI1mZWoT6Mnke7scNGse6Cr/qexVaiKrujtoyz4/OI=;
	b=XfOcSKAQ+QX1CGI8ZQdTyaN3cXW6kljxt1PbOP+jEi00YwUzuv5A7dZrbbX8avT69FjG
	 DYI09fxg9/RIQOLGBzYXTUHkwHagMzpPhOQagnfSyr5TQAC+Iotn8GVZ6czMUWL5l8B7k
	 AofEHiOkTl71Ca5/3t9ezAw6U3sZYGdyr3sIlvuzPUMbWBsmpBrQdG8oMPzMsxx/IuLxS
	 lCLjAEmKNk+6fSCHsga8fuOqrfk6mbvXZ32AowKiA2GslzfXqLW86qqCbYr/j9TKZD4VV
	 v2xBAgFgOa/7bhRQY8wvUzXSv73xsrh8ZsXNO9L/I7mw2wP6dAHs+VMmhqqiotqNKWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cliLVGLe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94D360A2619;
	Wed, 11 Nov 2026 03:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cliLVGLe
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794367033;
	b=qhxWSkEX6mHGQkKV5z+nLxn66lWWsCnVaS/VlNOkQ45IdtjcPbaUFNT/zx4yzdFvUzci
	 9ukhJLvfk8fZfKhATZO9KfdXDxUzZZhIHmiZBF4DtqGRDX7BB/Fg+k7+KTv8xuli2vsVx
	 QPCq87p6CHS9Zq1A0i1gKANTn7VSgf0f2xdQJCrmJ6ic9MDZwA+TklonYJHCTVSdv2APz
	 08li9zKcyMFQQzIFFVrFMMLg1OripeLbAtJDM/OWbhTZ1wgfVay/VI4ESjZewumdXJsP6
	 lmlhXHTiYck0XQW8Za7TMFzUpDmnQGVrIJvqNCV0FU8xZqvIcYa8IJjcgee1LFCqDuQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794367033;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+wI1mZWoT6Mnke7scNGse6Cr/qexVaiKrujtoyz4/OI=;
	b=gpUa/BfRhcLMuKlyIKuHQdEwMruzCUw5UwU/tF/mjOgwYR9XEIXagHnl06FHPcmKz12A
	 5WyKGKtCbQVJGyz2mYg4el5P10ZSHGV7E44N8oEItzbz9Dcb5U+PJ9d13fYdHL/qWu1Ko
	 QNwq2skXPi/IvXcdPgj7SQ3+7bSrSYHWBk486vhNfKmpmN/K4buc1pK2dlkM/Vr2cnEDW
	 yht/ycnm4n4iAGt2mKlELl5WWotlWsq4+X0ILCUq9poEz0rCQPzx8CXvTSmggyNjtnFfV
	 hFIn8yYramKMzDGCN+N0K63dqNZgIRw10/Rw6WwPrG5KgSpmaicpZZeHFeEkXWhpEYg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 44E291F00A00;
	Wed, 11 Nov 2026 03:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794367033;
	bh=+wI1mZWoT6Mnke7scNGse6Cr/qexVaiKrujtoyz4/OI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cliLVGLechOC7+NiBdWiTobtRHdANR1QaPsXl1rut34awzgvFIpNw6/meHNW031Vo
	 LhtjaJ5cL1HBpbbFsiJTTutYOsjrvIwrf33OeJzfA3AlgXwXgvkOPqX5XMHcWl5oeR
	 srlXwbm536Y++ntzpaPwnhv9fpE8N2xdBSmNYxIz4QuoAbHI2CiLs9dXO/sy9q7i7S
	 CDBA7RNRpbhOyIMrsbpMt5VYx1yoUAgTI52py/X7Fm4+KmMeW0GypFFEMSYkNjLaLL
	 dLKlEVzBPuWq5JDCfSc0dYwbtm2fxrdho0rTEUXH4Gn4/5RrnzgoREgEglhqOl51uz
	 hGgNYhjm4qrVw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B69B848D48;
	Wed, 11 Nov 2026 03:17:11 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 11 Nov 2026 12:17:12 +0900
Subject: [PATCH v2 2/2] xfs: skip the fsync flush when a later flush has
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
Message-Id: <20261111-xfs-fsync-flush-seq-v2-2-b5c00c25d276@samsung.com>
References: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
In-Reply-To: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
 Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794367030; l=6060;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=Bu2pX8WdvM2qQVP0L3dIEdFR9WG+YEt77lCKNNzn4Xs=;
 b=KkcbXmFSJU5ZJu6JFzfDkJZtrAPNcre9rxyAPMvJ9SsVlNcByyHo+0jwhbwvIGh2bJWXb3biL
 uK/Tk5l7xILA01rC+HOb3GwG9Ybw1skcrMaJE2B8wu3+IMOUokRVKKS
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
has finished. DAX files keep the old behavior.

fio 4k append + fsync in a QEMU guest, virtio-blk (cache=none) on a
Samsung 990 PRO NVMe SSD without power loss protection, before ->
after:

  16 jobs: 1111 -> 4498 fsyncs/s, mean fsync latency 14.4 -> 3.6 ms
   1 job:  399 -> 396 fsyncs/s

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Christoph's 2017 mail with the sequence counter idea:
https://lore.kernel.org/20170830142134.GA650@lst.de

A dm-log-writes test written for this series (8 fsync writers,
internal log) lost no fsync-ed block in 528 replays. At least 33319
of 48048 fsyncs skipped their flush through the new check. A variant
that samples before the writeback loses 16 of 528. The test needs
"dm-log-writes: log earlier flushes' writes when a later flush
completes", sent to dm-devel.

With an internal log, an fsync that takes the new skip can miss a
failed flush on bio-based dm. dm drops the error of a preflush sent
with data, unless the table is linear or stripe on a single device.
The skip trusts the status of the iclog bio, as the log and the fsync
that wrote the iclog already do. Before this patch the other fsyncs
sent their own flush and returned its result. With 8 writers on a
two-device linear table whose second device fails every flush, 2590
of 4000 fsyncs returned EIO before and 37 do now. From the code,
bcache in writeback mode drops that error too. md reports no flush
error at all. Neither was tested.
---
 fs/xfs/xfs_buf.c  | 27 +++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h  | 22 ++++++++++++++++++++++
 fs/xfs/xfs_file.c | 18 +++++++++++++++---
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9025b177931..2862cbdeda4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1785,6 +1785,33 @@ xfs_buftarg_flush_done(
 		;
 }
 
+/*
+ * Return true if a flush has been submitted and completed since @submit_seq
+ * was sampled. If so, all writes that completed before @submit_seq was sampled
+ * are on stable storage.
+ */
+bool
+xfs_buftarg_flushed_since(
+	struct xfs_buftarg	*btp,
+	s64			submit_seq)
+{
+	return atomic64_read(&btp->bt_flush_completed) > submit_seq;
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
index 6e6f0dbfef6..08282e1b3c8 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -368,6 +368,26 @@ struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
 		struct file *bdev_file);
 extern void xfs_free_buftarg(struct xfs_buftarg *);
 
+/*
+ * Sample the flush submit counter of @btp. Call this after the writes that a
+ * flush must cover have completed. Flushes take their number before they are
+ * submitted, so a flush numbered above the sample was submitted after it and
+ * covers those writes once it succeeds. xfs_buftarg_flushed_since() checks
+ * for such a flush.
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
@@ -377,6 +397,8 @@ xfs_buftarg_flush_start(
 }
 
 void xfs_buftarg_flush_done(struct xfs_buftarg *btp, s64 seq);
+bool xfs_buftarg_flushed_since(struct xfs_buftarg *btp, s64 submit_seq);
+int xfs_buftarg_flush(struct xfs_buftarg *btp);
 extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
 int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 396aca8c66a..5af00520cbe 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -87,7 +87,9 @@ xfs_file_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
+	struct xfs_buftarg	*btp = xfs_inode_buftarg(ip);
 	int			log_flushed = 0;
+	s64			submit_seq;
 	int			error;
 
 	trace_xfs_file_fsync(ip);
@@ -95,6 +97,7 @@ xfs_file_fsync(
 	error = file_write_and_wait_range(file, start, end);
 	if (error)
 		return error;
+	submit_seq = xfs_buftarg_flush_seq(btp);
 
 	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
@@ -119,12 +122,21 @@ xfs_file_fsync(
 	 * file data target cache here. This can happen for fdatasync/O_DSYNC
 	 * when no metadata needed to be committed.
 	 *
+	 * Flush the file data target unless a flush submitted to it after the
+	 * data writes above completed has already finished. That is usually
+	 * the flush before an iclog written out by this log force or by
+	 * another task, or another fsync's flush.
+	 *
+	 * DAX writes are not block I/O, so DAX only skips the flush when
+	 * this log force flushed, as before.
+	 *
 	 * Use the inode's actual file data target rather than assuming the
 	 * main data device.
 	 */
-	if (!log_flushed)
-		return blkdev_issue_flush(xfs_inode_buftarg(ip)->bt_bdev);
-	return 0;
+	if (log_flushed ||
+	    (!IS_DAX(VFS_I(ip)) && xfs_buftarg_flushed_since(btp, submit_seq)))
+		return 0;
+	return xfs_buftarg_flush(btp);
 }
 
 static int

-- 
2.43.0


