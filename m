Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434395;
	b=s7H6f40gKAKm+d67q3ESjpUuTZJIio0m/pA7mzZeYGOQblsJiXm1lugc3CCraaGStnj/
	 kg43rtVY1jDz5Jab+avRx73CQkNk9qqA0HakqguzxmybnVcR2pkoIQy7wMdT3bp+kQBHh
	 nR/VOp6ivn6x33JUMbBtGBixcBWYVV5S3JgLPCT6oVydGusQ0ame3OP/JW86+ZWDMpkrT
	 hIwya3L2EYvf3IbT0JBuyW02jZOT7cEwJEq6Uqu7uEqCiFxsNYTcActPMPw4UaQV/gqoX
	 kow0IF5cY8JeZ3xTbbwp5EVCiqtNZUbXaYQht5Afp7bGssPv6KaDZqUFYR/f6P1CtdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434395;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UqLjn5GWDvuliqY9aeggxZV+Rj2OLIvaTYeqRpPN0nY=;
	b=3cz4KsaikHWpVIRWd+1MLsM8zObkCM7rotnVDJej8ZN8rqVntQdlhLa5pIPD2Le8vjn0
	 ZeaKj17MW8sb3ZHvT4juTxUC8hBbDCRYXbhI8IpoX26j296coLY4LadR/qo8gKiGMieOs
	 bDlMwC/R+5xkLPYAaCumYuvU839a4TiFiuGF0RgQN61XdPpwJyCVbu/AAA5korPIRh6Rb
	 GerJoAXLo86ypubUFN+CkOK5qi9C4yEyd0JaGF3anu2SNW99Ox1q2L+lcA1hB2Iq/ThdJ
	 phIjcwixHjfBVM7/AmeB9ov8BqVKPxEm+0ZSc8uZ4fZk2N2ZWZrfO/t78Ck3EJWbngA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ilk2zbQi;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5799606A323
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 18:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5799606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ilk2zbQi
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e942864693so11037335ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 11:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792434394; x=1793039194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UqLjn5GWDvuliqY9aeggxZV+Rj2OLIvaTYeqRpPN0nY=;
        b=ilk2zbQiuGmzzRgq30lHYxtCLqMrpsFy29KLIRkS/ueXzOhzbi8C8EZ+9HAm1TkTJA
         I0Ey/egeCcOGkw3fA1Ji2W1yYlQFFJ/KQ03qQvsAQszymShkS7+38Kg4TK4O5eYU+rz4
         vqofLjDsBCufOlwQ2nphn+4lqCFBDByD9ynjskMqvtIVu02wD+areMMDNa9nYetZrIZF
         MYe2G0/GqXavURqbc1YfzuLRtFNeBpTMShfEbGpFmaJUPQGCaKwehHugPlGrN4SLVVxe
         HSwv+C1c4CfgN6WrimpzyQBBBIbZaogsxe51pYvOBrfRL1jEGEVmUtpDqojgcj26CF+h
         P3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434394; x=1793039194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UqLjn5GWDvuliqY9aeggxZV+Rj2OLIvaTYeqRpPN0nY=;
        b=GbJ8YzSxETTGa/cU4yA8ZruniIVtIU6t5JLJjABMpcMUl2eKzV+oIC2NN6TrZAtSbn
         VfSlgJMAnxDzFqgkzgrV1l+JlaDXSLjRefoChNBErVa0KnqnfQ7iSdSiH5AR/0vYtIHU
         tP6ZTW/2eku3kw57wPSu1iyoPC/kNMDGv0ilQcDn71NgUrfdGi8jOdGIxKcsCglvid21
         ZkQ/DccX8/MTecKwENGZkOzoKqWSoHGPYl/peSGbGSdYbK7Puk8oRIjlLI9ETD7TFpyj
         4H9jWW/pHnd54KW+YDeMEi6EfczWoYcTJTll+19Sod/aYL3xz5HrsPKJEielozdv5cHd
         9jhg==
X-Gm-Message-State: AFq9FYLtbp19Ov5zX2ZU+EDEhWsqRgbSNwGyp2y3reR43Wxc5ctJGWWA
	Xz81oTsrq03Vzh3G/Cayk357mJKaUj5zTkY3kuvk6274KLb7FUPI0UdtNTTxyHpL
X-Gm-Gg: AYBFou1PBmSrQWnTQQ3re+mYA+IJQTvHQcAe8GoUpEXvY3rZXmriXuiBoAf4zn26csB
	K/ZOzqK1Ygjj4DnLQ0LTU8xg6bK8BfudmsYHvg6L4C4xrrgz/qW+ulXUq2OMyJvXHAVyprNNNNM
	R7NLsAXpN7HyIOGD8LUVFgSQ9O7c37OMNz5slJaMgKxM3GXBI7PSrBRRaNpdFYR/Gt1WkAcMY7A
	WemUz27l5srt8D8uAXuyjdWRbw9JmCgevk9yqeBxbltBikGkPodbYQKoyYvNlrW/AZzJaCpg0B9
	7CRLujz+ylY9HZPE/eV8p3ce+2wolsQ0CiU9MpG3RYYZwLIfYw+6d+JtMZGj0JTf/T1K1zo3WBh
	MbCpt4Wu8KkadiCh32aMuA67T00C+6yqx4y/grneYYYAsr+JZGNWLQDWoFq8bSJruBGaoK7iTyS
	tmhF+XXhAQ1EeEnNQeHrDloaLvlOmJ3oAVfug8ia+FsXS4U80rioB8rdjRzm1gAQt+sn3blPKQf
	Imu/pi7P4aqht1Oqad1VHysx2yl1ZQ+RjljjB761zd5uXc7Jje7XH88guc=
X-Received: by 2002:a17:903:3904:b0:2e2:d77b:e586 with SMTP id d9443c01a7336-2e9a6d41400mr81456985ad.60.1792434393973;
        Mon, 19 Oct 2026 11:26:33 -0700 (PDT)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1517e7cfsm4156375ad.58.2026.10.19.11.26.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:26:33 -0700 (PDT)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 4/6] xfs: add range-drain state and latch-based DIO admission
Date: Mon, 19 Oct 2026 11:26:18 -0700
Message-ID: <20261019182620.1527591-5-vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019182620.1527591-1-vlovich@gmail.com>
References: <20261019182620.1527591-1-vlovich@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare XFS for range draining with lazily allocated inode-private state,
retained across VFS inode recycling and freed at XFS inode reclamation.
Provide ->dio_drain_complete to resolve the state for older requests.

Register provisionally before the final latch range snapshot for every
direct read and write submission. Transfer the token to iomap, and obtain
a fresh admission for simple-read fallback or write-check retries.

Overlapping IOCB_NOWAIT requests return -EAGAIN. Blocking requests drop
IOLOCK before waiting for a nonoverlapping snapshot and contribute no DIO
count while asleep. Writers reacquire through
xfs_ilock_iocb_for_write(), repeat append and limit checks, and recheck
unaligned COW eligibility because a clone can share blocks while IOLOCK
is dropped.

Establish the final admission and ownership rules before enabling either
range-drain consumer.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/xfs/xfs_file.c   | 148 ++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_icache.c |   2 +
 fs/xfs/xfs_inode.h  |   1 +
 fs/xfs/xfs_iops.c   |   9 +++
 4 files changed, 149 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d4446887453f..33c8edab4054 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/wait_bit.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -227,6 +228,78 @@ xfs_dio_read_bounce_submit_io(
 	submit_bio(bio);
 }
 
+static bool
+xfs_dio_range_overlap(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	size_t			len)
+{
+	struct inode_dio_drain	*drain;
+	bool			overlap;
+
+	/* Acquire the initialized allocation published by inode_dio_drain_get(). */
+	drain = smp_load_acquire(&ip->i_dio_drain);
+	overlap = inode_dio_drain_overlap(VFS_I(ip), drain, pos, len);
+	return overlap;
+}
+
+/* Register provisionally before the final exclusion snapshot. */
+static bool
+xfs_dio_try_begin(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	size_t			len,
+	unsigned int		*dio_flags)
+{
+	bool			generation;
+
+	if (!inode_dio_try_begin(VFS_I(ip), &ip->i_dio_drain, pos, len,
+			&generation))
+		return false;
+	*dio_flags &= ~IOMAP_DIO_GENERATION;
+	*dio_flags |= IOMAP_DIO_ACCOUNTED;
+	if (generation)
+		*dio_flags |= IOMAP_DIO_GENERATION;
+	return true;
+}
+
+/* No request is counted while waiting for an overlapping exclusion. */
+static int
+xfs_dio_range_wait(
+	struct kiocb		*iocb,
+	size_t			len,
+	unsigned int		*iolock,
+	bool			write)
+{
+	struct inode		*inode = file_inode(iocb->ki_filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct inode_dio_drain	*drain;
+	int			waited = 0;
+	int			error;
+
+	while (xfs_dio_range_overlap(ip, iocb->ki_pos, len)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		/* The successful overlap check acquired this permanent allocation. */
+		drain = READ_ONCE(ip->i_dio_drain);
+		xfs_iunlock(ip, *iolock);
+		wait_var_event(&inode->i_dio_count,
+			!inode_dio_drain_overlap(inode, drain, iocb->ki_pos, len));
+		/* Re-evaluate the required write lock mode after dropping IOLOCK. */
+		if (write) {
+			error = xfs_ilock_iocb_for_write(iocb, iolock);
+			if (error) {
+				*iolock = 0;
+				return error;
+			}
+		} else {
+			xfs_ilock(ip, *iolock);
+		}
+		waited = 1;
+	}
+	return waited;
+}
+
 static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
 	.submit_io	= xfs_dio_read_bounce_submit_io,
 	.bio_set	= &iomap_ioend_bioset,
@@ -238,6 +311,10 @@ xfs_file_dio_read(
 	struct iov_iter		*to)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+	unsigned int		iolock = XFS_IOLOCK_SHARED;
+	unsigned int		dio_flags = 0;
+	bool			bounce = mapping_stable_writes(iocb->ki_filp->f_mapping);
+	bool			simple = !bounce;
 	ssize_t			ret;
 
 	trace_xfs_file_direct_read(iocb, to);
@@ -250,16 +327,27 @@ xfs_file_dio_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
-	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
+retry:
+	ret = xfs_dio_range_wait(iocb, iov_iter_count(to), &iolock, false);
+	if (ret < 0)
+		goto out_unlock;
+	if (!xfs_dio_try_begin(ip, iocb->ki_pos, iov_iter_count(to), &dio_flags))
+		goto retry;
+	if (!simple) {
 		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
-				&xfs_dio_read_bounce_ops, IOMAP_DIO_BOUNCE,
-				NULL, 0);
+					bounce ? &xfs_dio_read_bounce_ops : NULL,
+					dio_flags | (bounce ? IOMAP_DIO_BOUNCE : 0),
+					NULL, 0);
 	} else {
-		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin, 0);
-		if (ret == -ENOTBLK)
-			ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
-					0, NULL, 0);
+		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin,
+				dio_flags);
+		if (ret == -ENOTBLK) {
+			/* Fallback needs a fresh admission and registration. */
+			simple = false;
+			goto retry;
+		}
 	}
+out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
@@ -438,9 +526,10 @@ xfs_file_write_zero_eof(
 /*
  * Common pre-write limit and setup checks.
  *
- * Called with the iolock held either shared and exclusive according to
- * @iolock, and returns with it held.  Might upgrade the iolock to exclusive
- * if called for a direct write beyond i_size.
+ * Called with the iolock held shared or exclusive according to @iolock.
+ * Returns with it held unless reacquisition fails, in which case *@iolock
+ * is set to zero.  Might upgrade the iolock to exclusive if called for a
+ * direct write beyond i_size.
  */
 STATIC ssize_t
 xfs_file_write_checks(
@@ -455,10 +544,23 @@ xfs_file_write_checks(
 	ssize_t			error;
 
 restart:
+	/* Normalize append position and enforce limits before range admission. */
 	error = generic_write_checks(iocb, from);
 	if (error <= 0)
 		return error;
 
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		error = xfs_dio_range_wait(iocb, iov_iter_count(from), iolock,
+				true);
+		if (error < 0)
+			return error;
+		if (error) {
+			iov_iter_reexpand(from, count);
+			/* EOF and limits can change while IOLOCK is dropped. */
+			goto restart;
+		}
+	}
+
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		error = break_layout(inode, false);
 		if (error == -EWOULDBLOCK)
@@ -737,6 +839,7 @@ xfs_file_dio_write_aligned(
 {
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	unsigned int		dio_flags = 0;
+	size_t			count = iov_iter_count(from);
 	ssize_t			ret;
 
 	/*
@@ -750,6 +853,7 @@ xfs_file_dio_write_aligned(
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
+retry_checks:
 	ret = xfs_file_write_checks(iocb, from, &iolock, ac);
 	if (ret)
 		goto out_unlock;
@@ -765,10 +869,15 @@ xfs_file_dio_write_aligned(
 	}
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		dio_flags |= IOMAP_DIO_BOUNCE;
+	if (!xfs_dio_try_begin(ip, iocb->ki_pos, iov_iter_count(from), &dio_flags)) {
+		iov_iter_reexpand(from, count);
+		goto retry_checks;
+	}
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, ops, dops, dio_flags, ac, 0);
 out_unlock:
-	xfs_iunlock(ip, iolock);
+	if (iolock)
+		xfs_iunlock(ip, iolock);
 	return ret;
 }
 
@@ -829,6 +938,7 @@ xfs_file_dio_write_atomic(
 	if (ret)
 		return ret;
 
+retry_checks:
 	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out_unlock;
@@ -842,6 +952,10 @@ xfs_file_dio_write_atomic(
 	trace_xfs_file_direct_write(iocb, from);
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		dio_flags |= IOMAP_DIO_BOUNCE;
+	if (!xfs_dio_try_begin(ip, iocb->ki_pos, iov_iter_count(from), &dio_flags)) {
+		iov_iter_reexpand(from, ocount);
+		goto retry_checks;
+	}
 	ret = iomap_dio_rw(iocb, from, dops, &xfs_dio_write_ops, dio_flags,
 			NULL, 0);
 
@@ -919,10 +1033,18 @@ xfs_file_dio_write_unaligned(
 		goto out_unlock;
 	}
 
+retry_checks:
 	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out_unlock;
 
+	/* The checks can drop IOLOCK, allowing a clone to share this block. */
+	if (xfs_is_cow_inode(ip)) {
+		trace_xfs_reflink_bounce_dio_write(iocb, from);
+		ret = -ENOTBLK;
+		goto out_unlock;
+	}
+
 	/*
 	 * If we are doing exclusive unaligned I/O, this must be the only I/O
 	 * in-flight.  Otherwise we risk data corruption due to unwritten extent
@@ -934,6 +1056,10 @@ xfs_file_dio_write_unaligned(
 
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		flags |= IOMAP_DIO_BOUNCE;
+	if (!xfs_dio_try_begin(ip, iocb->ki_pos, iov_iter_count(from), &flags)) {
+		iov_iter_reexpand(from, count);
+		goto retry_checks;
+	}
 
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index de8be344e987..e26df6894618 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -110,6 +110,7 @@ xfs_inode_alloc(
 	ip->i_mount = mp;
 	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
 	ip->i_cowfp = NULL;
+	ip->i_dio_drain = NULL;
 	memset(&ip->i_af, 0, sizeof(ip->i_af));
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
@@ -156,6 +157,7 @@ xfs_inode_free_callback(
 		xfs_inode_item_destroy(ip);
 	}
 
+	kfree(ip->i_dio_drain);
 	kmem_cache_free(xfs_inode_cache, ip);
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1602027cd0aa..a537f0416a47 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -41,6 +41,7 @@ typedef struct xfs_inode {
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	struct rw_semaphore	i_lock;		/* inode lock */
 	atomic_t		i_pincount;	/* inode pin count */
+	struct inode_dio_drain	*i_dio_drain; /* lazily allocated DIO drain */
 	struct llist_node	i_gclist;	/* deferred inactivation list */
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d1306e723899..9dbd15ff0d0d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1260,6 +1260,14 @@ xfs_vn_tmpfile(
 	return finish_open_simple(file, err);
 }
 
+static void
+xfs_vn_dio_drain_complete(
+	struct inode		*inode)
+{
+	/* The generation cutover orders i_dio_drain initialization before this callback. */
+	inode_dio_drain_complete(inode, READ_ONCE(XFS_I(inode)->i_dio_drain));
+}
+
 static const struct inode_operations xfs_inode_operations = {
 	.get_inode_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
@@ -1271,6 +1279,7 @@ static const struct inode_operations xfs_inode_operations = {
 	.sync_lazytime		= xfs_vn_sync_lazytime,
 	.fileattr_get		= xfs_fileattr_get,
 	.fileattr_set		= xfs_fileattr_set,
+	.dio_drain_complete	= xfs_vn_dio_drain_complete,
 };
 
 static const struct inode_operations xfs_dir_inode_operations = {
-- 
2.56.0

