Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815977;
	b=uLKmSY9UrdVI+466CcQ9SHFMiJaMpA8zKNTjj8fup2X/CJrfcAx0/zOrLS1HLPujxgRH
	 qCmpSqjT6ma5zEpYypqa1nknWlPbqq0uUOt81Mclxnxli+ZB/PkmGrg4+P6/LSg5mPZcR
	 yH8/7Ff3OnHbkxdvFVEATR6NJtNRgKLbM7FLxw0b+MrNerCVfY0RbZNfc3dBIcJKNHCdO
	 DAHYLunscsKNVCWbHHfnlAQdBuJzQ/aW7E3UVdF7RuMTcUM2mrhNK22D7Cw+JypzQV2ER
	 f/klIPEPpuTFG6+rzpWG3xVpEo5QyJ/ClBby9UtUCtFIdZzHxK6wx5mMiBXx+bBzAZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815977;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Enh3DX3qSjm2edHW5Rh2OeU55mJDNu85bt2+Ev8Rvg=;
	b=Ie1Ut/qVuMH58RnBYr8gGm5QWpvk6YzLcL8FLv/GsL+kPffRZywae9rBB9f7znStRmR5
	 Jaim1WWk/S6DxsRkwQjXRK27PVEQXZH+ksKtjIWo6c8z8u8pwlNkEtzTDAtk+6se62NGL
	 kc9XZKGxvpO9DeYem48zoO1UVBPofgZVauR8nCkNxXlVAG/3zvVNc8335gg4vpRijLOcy
	 b6tCDNhbFtKr3+MEW1dreTjVnLEWmz/tPOJh/am4x3Qe8wfZ3VpF32Cc6ZVOhcd6ehlSU
	 orZjnF0+ygxCXDuq2xD6qoh54UduXmvbpAQmJYeVf0GFMmdpSGe0qIXDC3A2vHiNC6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zo5TsIx7;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF432606B22C
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 18:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF432606B22C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zo5TsIx7
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd623dfe420so880526a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2026 10:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793815976; x=1794420776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Enh3DX3qSjm2edHW5Rh2OeU55mJDNu85bt2+Ev8Rvg=;
        b=Zo5TsIx7SjIsRoKYAl3OT6TsA7pJ1csrJuN5ViIZQkQDdRKodOaOCIM8rUMOd++F20
         T6Qm1fCys3TduXj+k6FtztFzMw7A5r67o8PJ1nHooAy3EOqW6w/7wSlcgxXi75LJAExx
         Fh7jPubSl8qMUWpopZ3buum3/YLvSP7lIcdD2aEgp+ywl6pcPJL20Pwez/hyK2bSm89H
         2N6iX/8G8L6FsMsLt9CrxVTgKW24wcBWmiwLfsbuAClaqR1xN2k7CLNzuU1UJD7hE/6r
         XmpZV8/Vk4aCQaYiKsIc5p/AntbUY1UCQSbZ3g9+ZT/kmKLICUfmDmHFVdZzMNkPHq1m
         5lMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815976; x=1794420776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Enh3DX3qSjm2edHW5Rh2OeU55mJDNu85bt2+Ev8Rvg=;
        b=c2d4oMizhhvINO2+q8j8lQMoT8YbT53ZlQttCzPYgJaS7KBOUS8P2EvDSpiRBKT1Um
         pP8URRinJA/3SACg/IU/lJtgoPvkISC218Ey/zT/Sh4TDrZc3XNHyIqCDun+iaMIBJuo
         1xpD4q2JJTlDc3i7CWm3Oc6W93wZ+ui1MEI1r3HQP+Lffd6HWC50+Qu6FJNffWDW9XOD
         7ycuOxDPIPua1xR8P2a5Fj1sP1Jxga9k+w3HD2a/iIkqbNuc4TnM+I6bBhxHhLiZz4eV
         0zJHzRf/0MgBJbxTI3yQTet+i90OBHUwHIoY09Q5zIJtXKhtL8tYWhe3e/ZS+uLnNQ/g
         SeWg==
X-Forwarded-Encrypted: i=1; AKwUvBzv5SGR9bepwcLSkvxV7yDXluIvYrctGB3O4c3N29zxCcJrxBBjtLXYgYjeO+lRWJopBoqgU4ib53c=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Sp1dc/xAz1IX8ZFo9Kap7FFIDYpTuth9LbFZB7dcI/XmkO+Nx
	hYjv4LTTk9jgQp4YSsTYFjNFswRCD6aBquD/F/EpyX4gx/vCarSgEBv8
X-Gm-Gg: AYBFou2Syp04dYPgxPBb5loRlX/ANCXwcsKv99/faDkN61bKM6NnZIWxwxKpNKxwQ59
	7znM3gLHg5GUjNhn7zy5n6mjonLDu2WVFoIjriGMC8yQVDFgaD/24CbpSre55kotdocXapTXBFd
	csm73Dwz/xautauqDJuK6g6Zs5enjbz/oLqDnvy661xhT8EAOq/B6gO62mLbZTne/ejTCG6QSnc
	RCivECriPFKZRFPb5rOjdQ1CJ5xhJwcwZ87+AZYLo5GpxrbxRkBlbgA7f4T4RKimnLT5ugV+XCa
	VB2H0Y/MRfP9TxdN7O7l9E2FkKj5EhIwfL5pd1yCkgNsKVYsvtWCTNjfnswMF7mXdMuhPx81/Mc
	sj4F7WpuDP7a5s47XUsjoshhZobQVrhFiv830NmlAswD8YzQA42gWjaBQN9GJ4JqMmmglN+2I5a
	qraXv6mXyI6JAlcp0QBlwFT7GqsITy6PMIMMdH5V+BgQe2maty1eI0y7yWPgjs0sBeW6sPTx4X5
	gH7W+VLz4FmH+ZyMTh5ec2rJNrtV0YAOJnmAVOalm5ejoYholFvpna2aRKhSEeEVR8HigOpDbQp
	aXFdxW294m+0yT7d3/IGzGpzh+uVIZeWlSb4WD9Tm4Nseefphg/u0RlqYnO2dxP3MTPGenNxql2
	ztWVcHDgjAZqjK1ryLpQ/ezOwEN0=
X-Received: by 2002:a17:90b:534d:b0:3ac:ffb8:183b with SMTP id 98e67ed59e1d1-3ae898392e6mr14508147a91.51.1793815975958;
        Wed, 04 Nov 2026 10:12:55 -0800 (PST)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31a3efasm78326a91.9.2026.11.04.10.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:12:55 -0800 (PST)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	cem@kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 6/6] xfs: use range-based DIO draining for post-EOF zeroing
Date: Wed,  4 Nov 2026 10:12:46 -0800
Message-ID: <65b0070006e404009cf16bc78989f43fae20acb8.1793815542.git.vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793815542.git.vlovich@gmail.com>
References: <cover.1793815542.git.vlovich@gmail.com>
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

Extend the filesystem selftest to check the post-EOF drain consumer:
park an old registered request, observe the gap exclusion, and verify
disjoint progress, overlapping NOWAIT rejection, and preserved data.

Also hold an old extending request while preparation drains, then verify
its completed bytes survive the post-drain EOF recheck and only the
remaining gap is zeroed.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/xfs/xfs_file.c                             | 109 +++++++++++++++---
 .../selftests/filesystems/xfs_dio_drain.c     |  41 +++++--
 2 files changed, 125 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ad83328b7350..53b3d6266e03 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -453,6 +453,55 @@ xfs_file_splice_read(
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
@@ -467,20 +516,17 @@ xfs_file_write_zero_eof(
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
@@ -493,6 +539,9 @@ xfs_file_write_zero_eof(
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
+	if (drain)
+		return xfs_file_write_zero_eof_range(iocb, isize, iolock, drain);
+
 	if (!*drained_dio) {
 		/*
 		 * If zeroing is needed and we are currently holding the iolock
@@ -543,23 +592,49 @@ xfs_file_write_checks(
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
 	xfs_dio_test_event(inode, XFS_DIO_TEST_WRITE_CHECKS,
 			iov_iter_count(from));
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
@@ -576,7 +651,7 @@ xfs_file_write_checks(
 	}
 
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * For changing security info in file_remove_privs() we need i_rwsem
@@ -588,7 +663,7 @@ xfs_file_write_checks(
 		error = xfs_ilock_iocb(iocb, *iolock);
 		if (error) {
 			*iolock = 0;
-			return error;
+			goto out;
 		}
 		goto restart;
 	}
@@ -605,14 +680,18 @@ xfs_file_write_checks(
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
diff --git a/tools/testing/selftests/filesystems/xfs_dio_drain.c b/tools/testing/selftests/filesystems/xfs_dio_drain.c
index f2e005f6e896..c84f298ff3e4 100644
--- a/tools/testing/selftests/filesystems/xfs_dio_drain.c
+++ b/tools/testing/selftests/filesystems/xfs_dio_drain.c
@@ -21,6 +21,7 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
+#include <sys/stat.h>
 #include <sys/statfs.h>
 #include <sys/syscall.h>
 #include <sys/uio.h>
@@ -122,16 +123,19 @@ static int faultfd(void *buffer, size_t length)
 }
 
 /*
- * Stop a real, registered DIO in GUP. A drain must wait for this old request,
- * although its file range is disjoint from the punch or post-EOF gap.
+ * Stop a real, registered DIO in GUP. A drain must wait for this old request.
+ * The overwrite cases use a disjoint range; the extending case starts exactly
+ * at EOF and must finish before the farther writer zeroes the remaining gap.
  * Probe the exclusion before checking that newer disjoint I/O can complete.
  */
-static int cohort_test(int fd, size_t unit, bool eof)
+static int cohort_test(int fd, size_t unit, bool eof, bool advance_eof)
 {
-	struct request old = { .fd = fd, .length = unit, .offset = unit };
+	struct request old = { .fd = fd, .length = unit,
+		.offset = (advance_eof ? 8 : 1) * unit };
 	struct request drain = { .fd = fd, .length = unit,
 		.offset = (eof ? 10 : 4) * unit, .punch = !eof };
 	struct uffd_msg message;
+	struct stat st;
 	struct uffdio_copy copy = { .len = unit };
 	struct pollfd pollfd;
 	struct iovec iov;
@@ -190,13 +194,14 @@ static int cohort_test(int fd, size_t unit, bool eof)
 	}
 	ok = excluded && progressed && rejected_write && !atomic_load(&drain.done) &&
 		!atomic_load(&old.done);
+	ok &= !fstat(fd, &st) && st.st_size == 8 * (off_t)unit;
 	if (!ok)
 		ksft_print_msg("%s: exclusion=%d disjoint-progress=%d drain-done=%d\n",
 			       eof ? "EOF" : "punch", excluded, progressed,
 			       atomic_load(&drain.done));
 	/* Resolve every missing source page and release both operations. */
-	memset(buffer, 0x5a, unit);
-	copy.src = (uintptr_t)buffer;
+	memset(buffer + 2 * unit, advance_eof ? 0xa5 : 0x5a, unit);
+	copy.src = (uintptr_t)(buffer + 2 * unit);
 	copy.dst = (uintptr_t)missing;
 	if (ioctl(uffd, UFFDIO_COPY, &copy))
 		ksft_exit_fail_msg("UFFDIO_COPY failed: %s\n", strerror(errno));
@@ -206,15 +211,19 @@ static int cohort_test(int fd, size_t unit, bool eof)
 	ok &= drain.result == (eof ? (ssize_t)unit : 0);
 	if (fsync(fd))
 		ok = false;
+	ok &= !fstat(fd, &st) &&
+		st.st_size == (eof ? 11 : 8) * (off_t)unit;
 	memset(buffer, 0xff, 12 * unit);
 	ret = pread(fd, buffer, (eof ? 11 : 8) * unit, 0);
 	ok &= ret == (eof ? 11 : 8) * (ssize_t)unit;
 	for (size_t i = 0; i < (eof ? 11 : 8) * unit; i++) {
 		unsigned char expected = 0x5a;
 
-		if (eof ? i >= 8 * unit && i < 10 * unit :
+		if (eof ? i >= (advance_eof ? 9 : 8) * unit && i < 10 * unit :
 			  i >= 4 * unit && i < 5 * unit)
 			expected = 0;
+		if (advance_eof && i >= 8 * unit && i < 9 * unit)
+			expected = 0xa5;
 		if (((unsigned char *)buffer)[i] != expected) {
 			ksft_print_msg("bad preserved data/gap at byte %zu\n", i);
 			ok = false;
@@ -341,9 +350,9 @@ int main(int argc, char **argv)
 	free(path);
 	signal(SIGALRM, timeout_handler);
 	alarm(30);
-	ksft_set_plan(3);
-	for (int eof = 0; eof < 1; eof++) {
-		result = cohort_test(fd, unit, eof);
+	ksft_set_plan(5);
+	for (int eof = 0; eof < 2; eof++) {
+		result = cohort_test(fd, unit, eof, false);
 		if (result < 0)
 			ksft_test_result_skip("%s drain needs kernel-fault userfaultfd support\n",
 					      eof ? "EOF" : "punch");
@@ -353,6 +362,18 @@ int main(int argc, char **argv)
 			failed |= !result;
 		}
 	}
+	/*
+	 * The old cohort member extends EOF from 8 to 9 units while the farther
+	 * writer is draining it. The preparer must reread i_size after draining:
+	 * zeroing from its original 8-unit snapshot would destroy the 0xa5 data.
+	 */
+	result = cohort_test(fd, unit, true, true);
+	if (result < 0)
+		ksft_test_result_skip("EOF advance needs kernel-fault userfaultfd support\n");
+	else {
+		ksft_test_result(result, "EOF advance during drain preserves completed data\n");
+		failed |= !result;
+	}
 	for (int cow = 0; cow < 2; cow++) {
 		result = mapped_source_test(fd, clonefd, unit, cow);
 		if (result < 0)
-- 
2.56.0

