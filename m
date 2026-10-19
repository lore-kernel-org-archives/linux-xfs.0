Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434396;
	b=ay074jpBrufvrjmWKcXsrwMwymXZZf7I7uxcfR2FYMX7VsjhEh1Li4qLUNADzSORgfh0
	 90SrO8zhiz4/mGJVZ5htUk6C4A+pE9YWWegyOUv3ptZgTqPFp3NiDH6pbV8e+3pcwGdrj
	 1qQqNyQXK0AxOhiQejuvWnJPqFZn4f6w3ksvivo6RG1PriPiVFDScVRC6nIbw9mkFJrWz
	 Q3oCX9FNvyAnFy64rMOfpvXZk6AluCB2KzrGNAl0XG38mLAwxJ/Anprp0GigInn87bmEC
	 8ZIlqt1nKXoUHhFY/lIVrPMm06FPIKjhDL9vV8j27Njre+McDQ3cdCrR21g/HVetbag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434396;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=C5DssFWTfSFqPs7HzLyNini8RqcvmAnqa+Ewza4j5ps=;
	b=HIXBoZBhH0EviYVu3WdbOpuiF5NB4ifiDWDgKgoZS9HsrDqAQ67RwgjRqA9kWeSjlgxX
	 1Rs2Bz3A3Ugj7riU/4lw4DOWazVXZG//7TlmXnqoGFHSOPk+Cxxsx1J4YDwLx8k6ToTaB
	 9kPHKu4vjrg0LNlfpbf0uWbEJ8DR7wc4FOCt5w0jJbQaoDaHQsnMhhPGrYT6AeWNML+D3
	 m1lQZUosgZPISS5ZC9p8drXiAzhuOnjMKMz83IiQOofQGCIqLqaPR1dSASbevBLdHJZaw
	 FrtMF4zAD/B/g7s1Kj6cS6ga4+0fmVqAgzRICDTkV85LAdXJKz93oDgnfCSbXDxcNwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UmKtvMpF;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E75606A336
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 18:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95E75606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UmKtvMpF
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e60f9af6e6so19059105ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 11:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792434395; x=1793039195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=C5DssFWTfSFqPs7HzLyNini8RqcvmAnqa+Ewza4j5ps=;
        b=UmKtvMpFiVPL3X6ctPslXJNDb63NWfmPcYpAf7M6aTd6bI147GX+5pMYPOeBEHNxBY
         PQ3VloLz/XEnf13tiSncjX3WIPohzMGUQho+mTFEBPSNPiBj4a63hLpnOBLb0bdFY3hT
         0hyOrqxT7yLS06/loRLMbzs9a2bURMb0narclVulO5k2m3NqUXQ5lItzKYs03YG+HdiW
         3sDw4efFlDaILMugq0sG9JWZID6esjvw2xNo5XO2w61aSY/Rgawa7MEco2UGY5L8Lu1N
         2C3JGaQZXbrqdFVitRw08QxoLsXvyGjtJGEEhuqptnTJt0DlDMi5PpZY0RA+xxCjC5nl
         5OnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434395; x=1793039195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=C5DssFWTfSFqPs7HzLyNini8RqcvmAnqa+Ewza4j5ps=;
        b=e9M+ee9IumGPp/wvKotisomuGk8jF3A5yh3pmkHbT5EghpS8nrTf5e2+HCoYyqZQPa
         1H8s7kmFqubnPf20XToHSqk64Rsxh6BkPQzGMdBxmm+7xsmJNvf+TaewfgzW8vTOOIOo
         loFEQDgBw/XGbgcQadr3uOsZ9aM/H024WK/4R28GuE/dIzJ7znIukCOEF5cuy0U90qBf
         igAihEKeAvXYgglIkLdVot8oJvRs3BN2unULXmYIeSriTBX9Qn1HDUVeoZgG23lHcdei
         k4Uwynvfnkc1J0f8d3Cqlyj/wc0/PJepAOcAjSk1SvW5jqULpyD0SfBABJRmAyZSNje8
         EOZw==
X-Gm-Message-State: AFq9FYIrA3RAPfDp86eZD5q7ed9ANcx1dupAQHSCiCtZwSNRBjJgfi8w
	fbtL2T1moVKGVb4WBIJCk6KkypPKDwn0QEqzZ3pYU1Y6fny18TwLP/l15kQ8X4nH
X-Gm-Gg: AYBFou2SB4T0hztMq2kC9e6XrT/cWzyoqj9Uta72ip7h6E+zoFjtZcdKuZxe0pOEi8X
	cV/X6sJ63OLLpAbjVc1h4tRlo9L4y0bdzFYWZJ0PCBz/fW3h+7bHDLm+06vefWlthGrw2XBzofj
	g9sfCAGIo4tlfRvVpoQk75kjNC9orKYLxsl5lHKkCKCacSM1HBL68A0YRVTL6TvWR2qI2aXYC9l
	IcX62cEFSwo4D+Qc/KxY5NpJ3xcB7L5V/Hjjx/P+JNzW8bbsK1cai2XK5mr4WC3vjbq+Qo57EM9
	kZbVFYrWoXc1xJL/2UGtgD212OOXKY4NCikBob0R5Ll7Yt9jY/q5QC3w66SrDWW0sq5U1nXG8c7
	Gp3O11wpWPpdDbFYOYV8gFweUP/bGuC+fp+BNyKpBoLIeIk5oOmCtNe4dNAiXfeYcxHuMO9v85S
	CmlBNw5Htaww6gh5k7uyGbS1C50FqoAfrDfcofVDMp5jMpuqiqcEiP+uoDCk5nSGPRlgIt6T2O+
	NOH/j393QkUoo4zsQoM56hIsL/ZK/Rs+8TaLrurOZdQF+m0q5x9fGm2F8nPSAlrdIHl3vnwz1//
	yUdFUX6JuWduXLVr0RCZwqXeeAbZjQ==
X-Received: by 2002:a17:902:dac2:b0:2e5:98d7:8202 with SMTP id d9443c01a7336-2e9a69e4716mr74671375ad.13.1792434394564;
        Mon, 19 Oct 2026 11:26:34 -0700 (PDT)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1517e7cfsm4156375ad.58.2026.10.19.11.26.34
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:26:34 -0700 (PDT)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 5/6] xfs: use range-based DIO draining for aligned hole punches
Date: Mon, 19 Oct 2026 11:26:19 -0700
Message-ID: <20261019182620.1527591-6-vlovich@gmail.com>
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

Hole punching holds exclusive IOLOCK while draining DIO and modifying
the range, blocking new submissions throughout the inode. Use shared
IOLOCK and a latch-published range exclusion for eligible aligned
data-device punches so disjoint new DIO can proceed.

Reject obvious ineligible requests before allocating drain state or
taking the drain mutex. Obtain the drain mutex before IOLOCK and recheck
eligibility under shared IOLOCK. A waiter must not hold shared IOLOCK
while the mutex owner may drop and reacquire IOLOCK exclusively during
write checks. Retain the existing path for DAX, realtime,
privilege/capability stripping (!IS_NOSEC), reflink remapping, unaligned
punches, layout breaking, or an unrepresentable rounded endpoint. Round
the exclusion to the larger of the allocation unit and PAGE_SIZE,
matching cache invalidation.

Drain the pre-cutover cohort before taking MMAPLOCK: an in-flight DIO
can fault in a buffer backed by the same file. Skip unnecessary partial
block zeroing for aligned data-device punches so the operation can retain
shared IOLOCK. Keep the exclusion through extent removal and any required
synchronous log force, and report allocation or drain-start errors.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/xfs/xfs_bmap_util.c |  9 ++++-
 fs/xfs/xfs_file.c      | 88 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c     | 10 +++++
 3 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 865aec3ae5ab..30759c6f94d3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -889,8 +889,8 @@ xfs_free_file_space(
 		return 0;
 
 	/*
-	 * Now AIO and DIO has drained we flush and (if necessary) invalidate
-	 * the cached range over the first operation we are about to run.
+	 * The caller has excluded and drained DIO over the affected range.
+	 * Flush and invalidate the cached range before removing its mappings.
 	 */
 	error = xfs_flush_unmap_range(ip, offset, len);
 	if (error)
@@ -917,6 +917,11 @@ xfs_free_file_space(
 		}
 	}
 
+	/* An aligned data-device punch needs no partial-block zeroing. */
+	if (!XFS_IS_REALTIME_INODE(ip) &&
+	    !((offset | len) & mp->m_blockmask))
+		return 0;
+
 	/*
 	 * Now that we've unmap all full blocks we'll have to zero out any
 	 * partial block at the beginning and/or end.  xfs_zero_range is smart
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 33c8edab4054..c8b3c4657bcb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1668,6 +1668,90 @@ xfs_falloc_allocate_range(
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
 		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
+/*
+ * Aligned punches do not change the file size or zero partial
+ * blocks.  Exclude only the range that cache invalidation can touch, while
+ * retaining the shared IOLOCK to exclude truncate and buffered writes.
+ */
+STATIC bool
+xfs_file_punch_hole_range(
+	struct file		*file,
+	loff_t			offset,
+	loff_t			len,
+	long			*result)
+{
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct inode_dio_drain	*drain;
+	loff_t			rounding, start, last;
+	unsigned int		inode_flags = READ_ONCE(inode->i_flags);
+	unsigned int		iolock = XFS_IOLOCK_SHARED;
+	bool			handled = false;
+	int			error;
+
+	/*
+	 * Avoid drain allocation and serialization for obvious fallbacks.
+	 * Only data-device files qualify, so check alignment to the filesystem
+	 * block size. Recheck mutable inode state after acquiring IOLOCK.
+	 */
+	if ((inode_flags & S_DAX) || !(inode_flags & S_NOSEC) ||
+	    (READ_ONCE(ip->i_diflags) & XFS_DIFLAG_REALTIME) ||
+	    (READ_ONCE(ip->i_flags) & XFS_IREMAPPING) ||
+	    !IS_ALIGNED(offset | len, i_blocksize(inode)))
+		return false;
+
+	drain = inode_dio_drain_get(&ip->i_dio_drain);
+	if (IS_ERR(drain)) {
+		*result = PTR_ERR(drain);
+		return true;
+	}
+	mutex_lock(&drain->lock);
+	xfs_ilock(ip, iolock);
+	if (IS_DAX(inode) || XFS_IS_REALTIME_INODE(ip) || !IS_NOSEC(inode) ||
+	    xfs_iflags_test(ip, XFS_IREMAPPING) ||
+	    !xfs_is_falloc_aligned(ip, offset, len))
+		goto out_unlock;
+
+	rounding = max_t(loff_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
+	/* The invalidation range must remain representable even beyond EOF. */
+	if (offset + len > rounddown_64(LLONG_MAX, rounding))
+		goto out_unlock;
+	start = rounddown_64(offset, rounding);
+	last = roundup_64(offset + len, rounding) - 1;
+
+	/* Fall back to the exclusive path if breaking a layout would block or fail. */
+	if (break_layout(inode, false))
+		goto out_unlock;
+
+	handled = true;
+	/*
+	 * IS_NOSEC was checked under shared IOLOCK, which excludes chmod and
+	 * security xattr changes that could clear S_NOSEC. file_modified() can
+	 * update timestamps without stripping privileges under shared IOLOCK.
+	 */
+	error = file_modified(file);
+	if (error)
+		goto out_result;
+
+	/* DIO can fault in a buffer from this file. Drain before MMAPLOCK. */
+	error = inode_dio_drain_start(inode, drain, start, last);
+	if (error)
+		goto out_result;
+	inode_dio_drain_wait(inode, drain);
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	error = xfs_free_file_space(ip, offset, len, NULL);
+	if (!error && xfs_file_sync_writes(file))
+		error = xfs_log_force_inode(ip);
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+	inode_dio_drain_finish(inode, drain);
+out_result:
+	*result = error;
+out_unlock:
+	xfs_iunlock(ip, iolock);
+	mutex_unlock(&drain->lock);
+	return handled;
+}
+
 STATIC long
 __xfs_file_fallocate(
 	struct file		*file,
@@ -1681,6 +1765,10 @@ __xfs_file_fallocate(
 	long			error;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 
+	if (mode == (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE) &&
+	    xfs_file_punch_hole_range(file, offset, len, &error))
+		return error;
+
 	xfs_ilock(ip, iolock);
 	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
 	if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 621513d7215e..97eb239858cb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -118,6 +118,16 @@ xfs_lock_flags_assert(
  *
  * i_rwsem -> invalidate_lock -> page_lock -> i_ilock
  *
+ * DIO range drainers add an outer mutex:
+ *
+ * i_dio_drain->lock -> i_rwsem -> invalidate_lock -> page_lock -> i_ilock
+ *
+ * Never wait for the drain mutex while holding IOLOCK: its owner may drop
+ * shared IOLOCK and reacquire it exclusively during write checks. A waiter
+ * holding shared IOLOCK would prevent that upgrade and deadlock both drainers.
+ * The mutex stays held through exclusion removal, including extent freeing
+ * and any synchronous log force. DIO admission and completion do not take it.
+ *
  * mmap_lock locking order:
  *
  * i_rwsem -> page lock -> mmap_lock
-- 
2.56.0

