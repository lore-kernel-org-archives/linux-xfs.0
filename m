Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434397;
	b=zUD0/HaIjFcwioQ5VZXsQwGtSudGZFni6flBVGeTE35BJh/y/E5NorWp0y8kx2ycysMZ
	 IYDd6DOff/dJjsojxCHejOKizkOcJhZtdE7DDIzHitP2Z3niVRJi/cnHmYPFSBWal+epA
	 R63f1up1424bkbINrO0brj3dswBKNxeJ6qQLHtMFvZh0rXYiXjIWHf/Mi9dqwsErkor+S
	 Bt52W7SNIqF30GLm89xVVRCh6cRnjbcBkeS+h2lQGxVH9L5/N1ec1BpxIDW7R1euThZXz
	 neN5FJNWRdLxDDkXNTjvo/XH0i6CxWUSvS7HpxHibkqa5OO84n0+dOiNCrQZcHRySUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434397;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g7K7JZ47EPLtKhGQtYvaK17kyBjl3FpAoJBu58Q0HwU=;
	b=GcokzH/eHGX4IErWiK9ZX+lD/N2B2u/iwOpSqo5KMEdSrx3p4oTQHsTQtDGv8DTMgr7M
	 gTtHoWS+zcp8QX7urEFbhY8kasog7aAGZKVZ6PZaj4cQ0RJa+dQcRraM4KfQRHU6aYfD4
	 PQweMrTKEVeGlekDzVexpTHb+F1hg8v2qsRSzhSa2PZAdaaCS1q7Ab9I/KE05t0zMr9f6
	 BD7OseCce5kItpqo9l+UTbPqnFybrFBf0bBeNCegj/Cxu1uSTi6ltlVV3RlGD+GviUVvg
	 hCJoLiistxSPZO0nKlqp0AcXh+kZjaWmwvxpc/ZyW5zbeWiwl7eD86tGv7PZWooxV5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P5DBMWYx;
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A66F60A2613
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 18:26:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A66F60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P5DBMWYx
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e9d7791b00so6935935ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 11:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792434395; x=1793039195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=g7K7JZ47EPLtKhGQtYvaK17kyBjl3FpAoJBu58Q0HwU=;
        b=P5DBMWYx/KuMU3ZepioSYUI593w6JOyNNKDOLV5qQz2ydj+8YFbUpHzJD9m/veXXDb
         u85pLLqXDUPRWrOW1t0VcejOaEO+Qt4plgZ/uBnDKKCSoS1SAa203HtVQgha5oxWPfNf
         4Tdv/eVaYgMPtPtx3BA5ZVBC9Foa+5KdKtboC56m3iN1d9nE0nQMW8QpoBcPj04hD/w+
         h412JO3BlS+McWgjv26CzY6Trj9HYYefCysYzjxn9T8v9cdhnAFQmeDgpoq1Wmw3UMlm
         giN0BmR0Br9+qfEGRhKhePpn3d4sBVw6vCg/lAbxkFQ1rUTyt9t1CBCOsBfIW3HU7nnJ
         E3KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434395; x=1793039195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=g7K7JZ47EPLtKhGQtYvaK17kyBjl3FpAoJBu58Q0HwU=;
        b=dHLiu0z1voFMBt3W0FWhvcls7WkwJ0s5NKQ00oQUxt08HBXO6Jsl7Cd1Z2MnqENMSX
         vaKKOxlJ4R/7JLineQcE+8x55C4gKVxI1rAKz0v1q0+KUmym4zlDtniLsaC279kxrZZU
         x1z8MEGN4Pf0b56+WtVnrlzx/JrRcPFNHR7GnCjj1L3kRcVOkv1nMIAQquf04QRW+vv2
         11cSVt7NDvIWG7wAf1Rl/gK5+im3SwX4hiTDJOtMwT/cIfvcPx/NMNi2ArL6423hHsTz
         wWnVMJBc6uDG1aVCToBWaKJyTqIX6RB+T+kYGCqgCSbSj13egYYLIQ0AoETSYhgphMsT
         LmuQ==
X-Gm-Message-State: AFq9FYKCed328TnWMwy/UWi3wtxursbHJn6WsXGBERpqpoWoUAVshLDe
	/f3AGRQ508Ob0NHlmD3yoJbxdixif5vCQtqGv0EZwadvGqsTbohM808GdONaSXmJ
X-Gm-Gg: AYBFou1+jPuMICqlULVt8b74/+BtSLtVJchKhdOT6OMIrwVwO9WMITOL/25hVqUj6Yu
	xr/OeW2OZsCE065zmCLssUfrPCo5HUZn4z7Y+pqqkBNz/WHmJJrD1RLc1iEn6hex4jY7xAkOvHl
	/TZNeF7cpfHyUx88NG6Qw2bzsY3YXRFdEBrfpgA/QzOqhmfNCXRm+8D1GizoSz32NGCIHtQ5mfk
	MyPG4GKoqSyIDOBMx4EFO6+pZYF4RJpfuaCEgPPy8/DrSCPfZXKBu+9sAttf0p1QNcOoIqHkc3y
	Eu3980+i2R1UF96DDx86wnaFEuvhe7y4SkAHHywhY2vem8321D33d0vg6yiJJRr8YaQ3lt+DrT6
	W9kMv+L+rsxAv7+62UPsU53vt+gkrM+e7N4mpvGY4+m9HWQChZjQ7HReGMXCIbK1sBcSlzCx+N9
	Y5mvdEfPbnvR6AbOTG6DVSVhZ2ycRzy4sUfTb6LLyTit69YQYTaHcqQNJBIC/3k0KJVjrsnqeo+
	78lig/HEBHq0z47LRLpKUUYE+zIawjSobCM1qJML5Vht42h
X-Received: by 2002:a17:903:946:b0:2e8:591a:fa36 with SMTP id d9443c01a7336-2e9a73565a5mr64639875ad.72.1792434395264;
        Mon, 19 Oct 2026 11:26:35 -0700 (PDT)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1517e7cfsm4156375ad.58.2026.10.19.11.26.34
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:26:34 -0700 (PDT)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 6/6] xfs: use range-based DIO draining for post-EOF zeroing
Date: Mon, 19 Oct 2026 11:26:20 -0700
Message-ID: <20261019182620.1527591-7-vlovich@gmail.com>
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

Zeroing a gap before a direct write normally drains DIO with exclusive
IOLOCK. Use range draining for block-aligned, non-atomic data-device
writes entering write checks beyond EOF with shared IOLOCK.

Drop IOLOCK before obtaining the lazy drain state and its mutex, then
reacquire through xfs_ilock_iocb_for_write() and repeat write checks.
A drainer may need IOLOCK_EXCL during these checks; a second drainer must
not hold shared IOLOCK while waiting for its mutex, or both would block.
Publish the exclusion under shared IOLOCK, demoting first if required,
and drain the pre-cutover cohort while admitting disjoint new DIO.

Round the exclusion outward to the larger of the filesystem block size
and mapping_max_folio_size() to cover every folio touched by zeroing and
invalidation. Recheck EOF after draining because completions can advance
it, then zero any remaining gap under MMAPLOCK_EXCL.

Finish the exclusion before submitting the triggering write, which can
share its final folio. Release the drain mutex on every write-check exit.
Ineligible writes retain existing handling; allocation and drain-start
errors propagate to the caller.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/xfs/xfs_file.c | 109 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 94 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c8b3c4657bcb..0daa73871986 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -449,6 +449,55 @@ xfs_file_splice_read(
 	return ret;
 }
 
+/*
+ * Serialize zeroing with I/O to all cache folios that can cover the old EOF
+ * block and gap, not unrelated requests outside those folios. Clear the
+ * exclusion before submitting this write, which can share the final folio.
+ * Drain the finite cohort admitted before the generation cutover, including
+ * COW end-I/O remapping. New unrelated requests can proceed under shared IOLOCK.
+ */
+static int
+xfs_file_write_zero_eof_range(
+	struct kiocb		*iocb,
+	loff_t			isize,
+	unsigned int		*iolock,
+	struct inode_dio_drain	*drain)
+{
+	struct inode		*inode = file_inode(iocb->ki_filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t			granularity = max_t(loff_t, i_blocksize(inode),
+					mapping_max_folio_size(inode->i_mapping));
+	loff_t			start = round_down(isize, granularity);
+	loff_t			last = (iocb->ki_pos - 1) | (granularity - 1);
+	int			error = 0;
+
+	error = kiocb_modified(iocb);
+	if (error)
+		return error;
+	if (*iolock == XFS_IOLOCK_EXCL) {
+		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		*iolock = XFS_IOLOCK_SHARED;
+	}
+	/* Folio invalidation is wider than zeroing, even for sub-page blocks. */
+	error = inode_dio_drain_start(inode, drain, start, last);
+	if (error)
+		return error;
+	inode_dio_drain_wait(inode, drain);
+	spin_lock(&ip->i_flags_lock);
+	isize = i_size_read(inode);
+	spin_unlock(&ip->i_flags_lock);
+	if (iocb->ki_pos > isize) {
+		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
+		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
+				NULL, &xfs_buffered_write_iomap_ops,
+				&xfs_iomap_write_ops, NULL);
+		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+	}
+	inode_dio_drain_finish(inode, drain);
+	return error;
+}
+
 /*
  * Take care of zeroing post-EOF blocks when they might exist.
  *
@@ -463,20 +512,17 @@ xfs_file_write_zero_eof(
 	unsigned int		*iolock,
 	size_t			count,
 	bool			*drained_dio,
-	struct xfs_zone_alloc_ctx *ac)
+	struct xfs_zone_alloc_ctx *ac,
+	struct inode_dio_drain	*drain)
 {
 	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
 	loff_t			isize;
 	int			error;
 
 	/*
-	 * We need to serialise against EOF updates that occur in IO completions
-	 * here. We want to make sure that nobody is changing the size while
-	 * we do this check until we have placed an IO barrier (i.e. hold
-	 * XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.  The
-	 * spinlock effectively forms a memory barrier once we have
-	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value and
-	 * hence be able to correctly determine if we need to run zeroing.
+	 * Pair with EOF updates in DIO completion. The IOLOCK excludes truncate,
+	 * so EOF can only move forwards. Recheck after establishing either a
+	 * range exclusion or the exclusive IOLOCK and draining the relevant I/O.
 	 */
 	spin_lock(&ip->i_flags_lock);
 	isize = i_size_read(VFS_I(ip));
@@ -489,6 +535,9 @@ xfs_file_write_zero_eof(
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
+	if (drain)
+		return xfs_file_write_zero_eof_range(iocb, isize, iolock, drain);
+
 	if (!*drained_dio) {
 		/*
 		 * If zeroing is needed and we are currently holding the iolock
@@ -539,21 +588,47 @@ xfs_file_write_checks(
 	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct inode_dio_drain	*drain = NULL;
 	size_t			count = iov_iter_count(from);
 	bool			drained_dio = false;
 	ssize_t			error;
 
+	/*
+	 * Another drainer may need IOLOCK_EXCL during write checks. Do not pin
+	 * shared IOLOCK while waiting for its drain mutex.
+	 */
+	if (*iolock == XFS_IOLOCK_SHARED &&
+	    (iocb->ki_flags & IOCB_DIRECT) &&
+	    !(iocb->ki_flags & IOCB_ATOMIC) &&
+	    !XFS_IS_REALTIME_INODE(XFS_I(inode)) &&
+	    IS_ALIGNED(iocb->ki_pos | count, i_blocksize(inode)) &&
+	    iocb->ki_pos > i_size_read(inode)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		xfs_iunlock(XFS_I(inode), *iolock);
+		drain = inode_dio_drain_get(&XFS_I(inode)->i_dio_drain);
+		if (IS_ERR(drain)) {
+			xfs_ilock(XFS_I(inode), *iolock);
+			return PTR_ERR(drain);
+		}
+		mutex_lock(&drain->lock);
+		error = xfs_ilock_iocb_for_write(iocb, iolock);
+		if (error) {
+			*iolock = 0;
+			goto out;
+		}
+	}
 restart:
 	/* Normalize append position and enforce limits before range admission. */
 	error = generic_write_checks(iocb, from);
 	if (error <= 0)
-		return error;
+		goto out;
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		error = xfs_dio_range_wait(iocb, iov_iter_count(from), iolock,
 				true);
 		if (error < 0)
-			return error;
+			goto out;
 		if (error) {
 			iov_iter_reexpand(from, count);
 			/* EOF and limits can change while IOLOCK is dropped. */
@@ -570,7 +645,7 @@ xfs_file_write_checks(
 	}
 
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * For changing security info in file_remove_privs() we need i_rwsem
@@ -582,7 +657,7 @@ xfs_file_write_checks(
 		error = xfs_ilock_iocb(iocb, *iolock);
 		if (error) {
 			*iolock = 0;
-			return error;
+			goto out;
 		}
 		goto restart;
 	}
@@ -599,14 +674,18 @@ xfs_file_write_checks(
 	 */
 	if (iocb->ki_pos > i_size_read(inode)) {
 		error = xfs_file_write_zero_eof(iocb, from, iolock, count,
-				&drained_dio, ac);
+				&drained_dio, ac, drain);
 		if (error == 1)
 			goto restart;
 		if (error)
-			return error;
+			goto out;
 	}
 
-	return kiocb_modified(iocb);
+	error = kiocb_modified(iocb);
+out:
+	if (drain)
+		mutex_unlock(&drain->lock);
+	return error;
 }
 
 static ssize_t
-- 
2.56.0

