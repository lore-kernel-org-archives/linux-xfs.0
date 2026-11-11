Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794367033;
	b=Sv0HcHINp23ADuLvWL/TK4EYRQqKukezbvmf8/1Ps+boKtSC9sd/w8zTYjkcJ0Ur369W
	 Akv2wzzUAuk1wGJ8Py+TcgzE0iDWR6SKQIXHnu02+HN9eVa44abt2LKjuQGWJGxFcFHNS
	 lFC9mW7YWmVa8M7FbICUL3HRUPYy1pqRE5dVqcQN4/cYGobNOT7D/wuxo/qM0ztqAal/8
	 GJJvFW4zQxg73HgJrrME2b9tT/sbLY73XgOZkb+hhhUHmEk5CVWxfqU6ClBduAK9lzzcC
	 r+JfTZWmOa/BIvLFzfE7vkXhRC8pVRj7HrC5U4GwbsWhGfLjPYsBm7QIEB9a2SwybFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794367033;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hVUd/DRXCspK9V2Lzg5Oynqn82hdtWRNBwzwhiBD+hk=;
	b=cHgMUKkpCq9rOfR00PYAgS69cUzEzX45myf4oGClVwYyoduT43PVHPkcimb5VnVfCVkm
	 zHaEmmh8TcJNmJoUmFb0NOOocUIsA03fxeB2ajYAa+q1ViFmnetbRMgsMssreav/ZJRnX
	 Htx/A9yAH5PLi2ejU3GeaMehQ6Me/JddsYjPW3uy+zfskl1S9upUL7OJDsiv0mgtOQD7V
	 nP+GRRARBQBEPtwiLJpa5TQa6J0pOeHrHg++kZtaIf3awkEwhJLMe/K74WM0JFaCyn9xC
	 ddrTS7q1TV3UfahuAhMspImH0vu8tYP0o/45nxC6bnypw9FeU2x3Ff3MoQ1ZyQiUiWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRJOI55N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D953E60A261A;
	Wed, 11 Nov 2026 03:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRJOI55N
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794367033;
	b=LM8wLSZPf74O2tTq0BF4BqPm1syPvsq7A1FWQ5Eo3vq8vEmPO/uBvjTq90iE+QRyUcCA
	 Z5hZ8kXCDXEfjcWKFd9RknboJkIKK2mG6Btp0VHzjE+loDOKpnknJ0rxvDDoBzrhJfC/f
	 uIpweP6uME6bldAOGMFBXJFjg2evHyHnSrO754XH+Y+z9IOMKDK7JG7//oTdx8AjgOrG2
	 idWFwCs3MG/jbhRLMxabB8oguDIPq+dga32MWiXVhNrunILHouTlQ612kCnRFOiu3zIKd
	 5rNTHSrJcImjP8TmwGmbOOq4P46bsRIwoeVKg5t+XizH0saU74iDa/XYUYVHindjwSw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794367033;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hVUd/DRXCspK9V2Lzg5Oynqn82hdtWRNBwzwhiBD+hk=;
	b=CPn1wRxzIypbvVrs4m15rRM9jbhNkn71Vb98nAeO3L6i4qSdMUSIc8CZG3LdYn9z8A95
	 rLJ3ThE4SQY/lGwRykmtiLDWcaLZkJKMnLrDVAewzXSUZujuBKW/xVPs09Sjijkho6nhS
	 oBC4/mUeLxgeNjQiUs0cKLA1lNVMWXHgJkf0ndT+5ywCk5NR2AUHoxnIOP+5lfLN8cIvG
	 7ph8StUTLEyTOFP1H0rlnwwPfSiG//j8aT19jp11iBCScu9A9mg6pYl4oMERreF1VsWq6
	 Psz79J1Lo/aSBDosNCQZDsXSZ1lV7Kvo9hx7i+F/b1jcEvFMW/T0dm5YAbDqBfApWyg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 439AB1F0089F;
	Wed, 11 Nov 2026 03:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794367033;
	bh=hVUd/DRXCspK9V2Lzg5Oynqn82hdtWRNBwzwhiBD+hk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dRJOI55N4VrFhPkfqyPOqabWSuc8K0gxlsc313+kiYqdk292ad1M/H9ejbjRMAqM5
	 1ZpTMhA4omNevAselpN8Sg/6shsTvWnawUqmTtDbzO9xLEaFQ2OAz5oEN58oopcUpb
	 zb0SL1WuUvQbFBLQjstTKHDAqvc1rv8bLByJ5V2hNUg0sOz8VkQyN54XUMDiLVgpHX
	 bbNghFDnEI9KHBWJx/jCCpyAqGRxskOIPaXCiBvuxFO3/tElJ/Uu6tSn81nwwS7Kjp
	 /EiHUiAhOrY5OZ0YtP6IhAKcrvCl7o+J8lvrLA70K3J4QQ4/S/FrwEjMXEzuNqxzq2
	 sGSkN4IzU/N5A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A467548D26;
	Wed, 11 Nov 2026 03:17:11 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 11 Nov 2026 12:17:11 +0900
Subject: [PATCH v2 1/2] xfs: number the cache flushes submitted to each
 buftarg
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
Message-Id: <20261111-xfs-fsync-flush-seq-v2-1-b5c00c25d276@samsung.com>
References: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
In-Reply-To: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
 Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794367030; l=6071;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=mlu8b3VIDIEC+tkvxr/Au3ocaXOUYf50xG4hnTEy3s4=;
 b=sYLoC4RZKmMayZoSju20I/1KilbVxs6ON7SxQUo80Xqj/cmUQP+eaXG5TFitoDl2VxKk3LcZJ
 usoKvYZEClIBkWKUYJnEpELbR53j/DWPqNH4CncHCUOXedYlsd6xPZO
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

fsync can only skip its own cache flush when its log force wrote out
the iclog. It cannot tell whether a flush that another task submitted
covers its data.

Number the cache flushes that the log code submits to each buftarg,
and record the highest number that completed without error. Nothing
reads the numbers yet.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_buf.c      | 13 +++++++++++++
 fs/xfs/xfs_buf.h      | 21 +++++++++++++++++++++
 fs/xfs/xfs_log.c      | 28 +++++++++++++++++++++-------
 fs/xfs/xfs_log_priv.h |  1 +
 4 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6c93b4f5629..9025b177931 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1772,6 +1772,19 @@ xfs_init_buftarg(
 	return -ENOMEM;
 }
 
+/* Record that the flush numbered @seq completed successfully. */
+void
+xfs_buftarg_flush_done(
+	struct xfs_buftarg	*btp,
+	s64			seq)
+{
+	s64			old = atomic64_read(&btp->bt_flush_completed);
+
+	while (seq > old &&
+	       !atomic64_try_cmpxchg(&btp->bt_flush_completed, &old, seq))
+		;
+}
+
 struct xfs_buftarg *
 xfs_alloc_buftarg(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a4729253b56..6e6f0dbfef6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -103,6 +103,17 @@ struct xfs_buftarg {
 	unsigned int		bt_awu_max;
 
 	struct rhashtable	bt_hash;
+
+	/*
+	 * Cache flush tracking: a flush that takes the next number from
+	 * xfs_buftarg_flush_start() before it is submitted records it here
+	 * once it completes without error, keeping the highest number. A
+	 * completed flush with a number above a sample taken after some
+	 * writes completed covers those writes. Flushes without a number
+	 * are not counted.
+	 */
+	atomic64_t		bt_flush_submitted;
+	atomic64_t		bt_flush_completed;
 };
 
 struct xfs_buf_map {
@@ -356,6 +367,16 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
 		struct file *bdev_file);
 extern void xfs_free_buftarg(struct xfs_buftarg *);
+
+/* Call right before submitting a cache flush to @btp. */
+static inline s64
+xfs_buftarg_flush_start(
+	struct xfs_buftarg	*btp)
+{
+	return atomic64_inc_return(&btp->bt_flush_submitted);
+}
+
+void xfs_buftarg_flush_done(struct xfs_buftarg *btp, s64 seq);
 extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
 int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 74b324f915a..d99a5b678cf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1211,6 +1211,8 @@ xlog_ioend_work(
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	}
 
+	if (!error && iclog->ic_flush_seq)
+		xfs_buftarg_flush_done(log->l_targ, iclog->ic_flush_seq);
 	xlog_state_done_syncing(iclog);
 	bio_uninit(&iclog->ic_bio);
 
@@ -1570,19 +1572,21 @@ xlog_flush_end_io(
 	bio_put(bio);
 }
 
-static void
+static s64
 xlog_flush_async(
 	struct xlog_flush_done	*done,
-	struct block_device	*bdev)
+	struct xfs_buftarg	*btp)
 {
 	struct bio		*bio;
+	s64			seq = xfs_buftarg_flush_start(btp);
 
-	bio = bio_alloc(bdev, 0, REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
+	bio = bio_alloc(btp->bt_bdev, 0, REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
 			GFP_NOFS);
 	bio->bi_private = done;
 	bio->bi_end_io = xlog_flush_end_io;
 	atomic_inc(&done->pending);
 	submit_bio(bio);
+	return seq;
 }
 
 /*
@@ -1605,16 +1609,17 @@ xlog_flush_data_caches(
 		.pending	= ATOMIC_INIT(1),
 		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
 	};
+	s64			dseq = 0, rseq = 0, lseq;
 
 	*did_flush = false;
 	if (mp->m_ddev_targp != mp->m_logdev_targp &&
 	    bdev_write_cache(mp->m_ddev_targp->bt_bdev)) {
-		xlog_flush_async(&done, mp->m_ddev_targp->bt_bdev);
+		dseq = xlog_flush_async(&done, mp->m_ddev_targp);
 		*did_flush = true;
 	}
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp &&
 	    bdev_write_cache(mp->m_rtdev_targp->bt_bdev)) {
-		xlog_flush_async(&done, mp->m_rtdev_targp->bt_bdev);
+		rseq = xlog_flush_async(&done, mp->m_rtdev_targp);
 		*did_flush = true;
 	}
 
@@ -1623,12 +1628,17 @@ xlog_flush_data_caches(
 		 * If we flushed any other device, also use an async flush for
 		 * the log device so that all flushes happen in parallel.
 		 */
-		xlog_flush_async(&done, mp->m_logdev_targp->bt_bdev);
+		lseq = xlog_flush_async(&done, mp->m_logdev_targp);
 
 		xlog_flush_done(&done);
 		wait_for_completion(&done.done);
 		if (done.status)
 			return -EIO;
+		if (dseq)
+			xfs_buftarg_flush_done(mp->m_ddev_targp, dseq);
+		if (rseq)
+			xfs_buftarg_flush_done(mp->m_rtdev_targp, rseq);
+		xfs_buftarg_flush_done(mp->m_logdev_targp, lseq);
 	}
 
 	return 0;
@@ -1678,14 +1688,18 @@ xlog_write_iclog(
 	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
 	iclog->ic_bio.bi_end_io = xlog_bio_end_io;
 	iclog->ic_bio.bi_private = iclog;
+	iclog->ic_flush_seq = 0;
 
 	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
 		if (xlog_flush_data_caches(log->l_mp, &did_flush))
 			goto shutdown;
 	}
 	if (!did_flush &&
-	    (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG)))
+	    (iclog->ic_flags &
+	     (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG))) {
 		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
+		iclog->ic_flush_seq = xfs_buftarg_flush_start(log->l_targ);
+	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 529720a4984..df0f13c4e04 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -222,6 +222,7 @@ struct xlog_in_core {
 #endif
 	struct semaphore	ic_sema;
 	struct work_struct	ic_end_io_work;
+	s64			ic_flush_seq;	/* buftarg flush number */
 	struct bio		ic_bio;
 	struct bio_vec		ic_bvec[];
 };

-- 
2.43.0


