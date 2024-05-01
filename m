Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D2E160884;
	Wed,  1 May 2024 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588887; cv=none; b=LT6u5yvVQ88OCUk7Y8920JZfjjCNLbxRWVJ95459khIEgrSAezMcVmo2PPJPRnP0pXjcWe/tKZ3Lhji4QFAR1RbQf3yCMHOs5eSBoeU6rxk6bFMm2gVq2O+bAEvfk/s0lpOL1rJHHr8t+Oi+0rf8aLIW1e9IyTbeHoJgxJOZGuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588887; c=relaxed/simple;
	bh=mJXBPCeFwIP+RCT+2Q90DUoZyzvIVI8xihCedJDK56o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzfQwI9ffxHJr4RevGayr8tzXYTEKfxGNyJDjiBcka1YBRH/nKuOp/8h6FNa1gKNMsParKA4A/Q4xiBdlZPpJ7p2t5Fv0IYGJhMux6TxnYcZsZvkHz0L6GajzpgVmB1kkR8gaJ6MNEn3U9zjEXhFV03XyncMMfAmXuH18l5SqKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C3qp0h6g; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3qp0h6g"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6edb76d83d0so6160799b3a.0;
        Wed, 01 May 2024 11:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588885; x=1715193685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CIaCl8E3vGVy5frd2y7gV/ROcIZy671UztqSAEii3qE=;
        b=C3qp0h6gmfCtBnXsVja1scYXFg39zwwrv0BwomBNVmehgYCdh+6mkdL0+G0W/OesQ8
         ZpODPKXInYr/NVCe/CmIJBq0P5VyIyP9FnocX2zHDTJIiPBXd0211KJgtRvulehfYeht
         e6fk0muaVvLP/t28Nvbo/uTWSZAiwoQFAacXuLGhlK6y+B6wwPuEAuC7tOmcxY4beJSn
         P7Azs9WlfOme1/sVCbaLAla985TK8QNMzXUY8WZ6bTZSnpz7WKdlSxzVBN6d9k+AZmoF
         EfwdJUWh8Kszexhw42itZ+ZXyhd2WOW3TqK/DLo2/kWA0jm/RnyAsai1n9VSbIoQjMSs
         1C1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588885; x=1715193685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CIaCl8E3vGVy5frd2y7gV/ROcIZy671UztqSAEii3qE=;
        b=l3Dozw6LF5teIXhdsgQF0V9+bWM7e9pMfayPye9Dl2ePI4NnkPi9TguCdNqSPgWMcd
         Pd5g9Pdf6oDNYTgKWeMX14tDXsXLzPDNQEw0dGaFYEwdBRrDq39lHHbwjlnTai/XZz1s
         iX4h2Xb0lflGJbkL6twNMge3O0aFdexTLUIV4ocbA2wTctSQRVrWwKO/DBPzEUqAluTP
         6MUUAd11tpJNQmKnr6nZF5zXUwKyLmsBePpE1UH7mpmF1y0QvGHXNkjf56VsVT/S2lGs
         60QW91f+gM8x+T3oiisKOu6LlyKEarXK48kS7Q+olK+0nEFeV6WtDWaP6+M7jInH1Fbn
         p8+w==
X-Gm-Message-State: AOJu0Yy9hrXE7x48U1PHsqRiLFRdKgd/M9n57jxe1wH6DfkxL07L5g83
	Z634rwsLUCsmccCCqk0pYXbaRSMU8j0g/ojIDBpoM9YrgzdkerToE7kY4VAK
X-Google-Smtp-Source: AGHT+IFl+oJnoGLd93QJSf8ssEIo4cuMsxamRWWsuGhtiEGnHBSQu4KvG+jstMGpdqgYLOwNbjw+Yw==
X-Received: by 2002:a05:6a00:244b:b0:6f3:368d:6f64 with SMTP id d11-20020a056a00244b00b006f3368d6f64mr3751579pfj.2.1714588884910;
        Wed, 01 May 2024 11:41:24 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:24 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 09/24] xfs: drop write error injection is unfixable, remove it
Date: Wed,  1 May 2024 11:40:57 -0700
Message-ID: <20240501184112.3799035-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 6e8af15ccdc4e138a5b529c1901a0013e1dcaa09 ]

With the changes to scan the page cache for dirty data to avoid data
corruptions from partial write cleanup racing with other page cache
operations, the drop writes error injection no longer works the same
way it used to and causes xfs/196 to fail. This is because xfs/196
writes to the file and populates the page cache before it turns on
the error injection and starts failing -overwrites-.

The result is that the original drop-writes code failed writes only
-after- overwriting the data in the cache, followed by invalidates
the cached data, then punching out the delalloc extent from under
that data.

On the surface, this looks fine. The problem is that page cache
invalidation *doesn't guarantee that it removes anything from the
page cache* and it doesn't change the dirty state of the folio. When
block size == page size and we do page aligned IO (as xfs/196 does)
everything happens to align perfectly and page cache invalidation
removes the single page folios that span the written data. Hence the
followup delalloc punch pass does not find cached data over that
range and it can punch the extent out.

IOWs, xfs/196 "works" for block size == page size with the new
code. I say "works", because it actually only works for the case
where IO is page aligned, and no data was read from disk before
writes occur. Because the moment we actually read data first, the
readahead code allocates multipage folios and suddenly the
invalidate code goes back to zeroing subfolio ranges without
changing dirty state.

Hence, with multipage folios in play, block size == page size is
functionally identical to block size < page size behaviour, and
drop-writes is manifestly broken w.r.t to this case. Invalidation of
a subfolio range doesn't result in the folio being removed from the
cache, just the range gets zeroed. Hence after we've sequentially
walked over a folio that we've dirtied (via write data) and then
invalidated, we end up with a dirty folio full of zeroed data.

And because the new code skips punching ranges that have dirty
folios covering them, we end up leaving the delalloc range intact
after failing all the writes. Hence failed writes now end up
writing zeroes to disk in the cases where invalidation zeroes folios
rather than removing them from cache.

This is a fundamental change of behaviour that is needed to avoid
the data corruption vectors that exist in the old write fail path,
and it renders the drop-writes injection non-functional and
unworkable as it stands.

As it is, I think the error injection is also now unnecessary, as
partial writes that need delalloc extent are going to be a lot more
common with stale iomap detection in place. Hence this patch removes
the drop-writes error injection completely. xfs/196 can remain for
testing kernels that don't have this data corruption fix, but those
that do will report:

xfs/196 3s ... [not run] XFS error injection drop_writes unknown on this kernel.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_errortag.h | 12 +++++-------
 fs/xfs/xfs_error.c           | 27 ++++++++++++++++++++-------
 fs/xfs/xfs_iomap.c           |  9 ---------
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 5362908164b0..580ccbd5aadc 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -40,13 +40,12 @@
 #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
 #define XFS_ERRTAG_AG_RESV_CRITICAL			27
+
 /*
- * DEBUG mode instrumentation to test and/or trigger delayed allocation
- * block killing in the event of failed writes. When enabled, all
- * buffered writes are silenty dropped and handled as if they failed.
- * All delalloc blocks in the range of the write (including pre-existing
- * delalloc blocks!) are tossed as part of the write failure error
- * handling sequence.
+ * Drop-writes support removed because write error handling cannot trash
+ * pre-existing delalloc extents in any useful way anymore. We retain the
+ * definition so that we can reject it as an invalid value in
+ * xfs_errortag_valid().
  */
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29
@@ -95,7 +94,6 @@
 #define XFS_RANDOM_REFCOUNT_FINISH_ONE			1
 #define XFS_RANDOM_BMAP_FINISH_ONE			1
 #define XFS_RANDOM_AG_RESV_CRITICAL			4
-#define XFS_RANDOM_DROP_WRITES				1
 #define XFS_RANDOM_LOG_BAD_CRC				1
 #define XFS_RANDOM_LOG_ITEM_PIN				1
 #define XFS_RANDOM_BUF_LRU_REF				2
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index c6b2aabd6f18..dea3c0649d2f 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -46,7 +46,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_REFCOUNT_FINISH_ONE,
 	XFS_RANDOM_BMAP_FINISH_ONE,
 	XFS_RANDOM_AG_RESV_CRITICAL,
-	XFS_RANDOM_DROP_WRITES,
+	0, /* XFS_RANDOM_DROP_WRITES has been removed */
 	XFS_RANDOM_LOG_BAD_CRC,
 	XFS_RANDOM_LOG_ITEM_PIN,
 	XFS_RANDOM_BUF_LRU_REF,
@@ -162,7 +162,6 @@ XFS_ERRORTAG_ATTR_RW(refcount_continue_update,	XFS_ERRTAG_REFCOUNT_CONTINUE_UPDA
 XFS_ERRORTAG_ATTR_RW(refcount_finish_one,	XFS_ERRTAG_REFCOUNT_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
-XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
 XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
@@ -206,7 +205,6 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(refcount_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(bmap_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
-	XFS_ERRORTAG_ATTR_LIST(drop_writes),
 	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
 	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
@@ -256,6 +254,19 @@ xfs_errortag_del(
 	kmem_free(mp->m_errortag);
 }
 
+static bool
+xfs_errortag_valid(
+	unsigned int		error_tag)
+{
+	if (error_tag >= XFS_ERRTAG_MAX)
+		return false;
+
+	/* Error out removed injection types */
+	if (error_tag == XFS_ERRTAG_DROP_WRITES)
+		return false;
+	return true;
+}
+
 bool
 xfs_errortag_test(
 	struct xfs_mount	*mp,
@@ -277,7 +288,9 @@ xfs_errortag_test(
 	if (!mp->m_errortag)
 		return false;
 
-	ASSERT(error_tag < XFS_ERRTAG_MAX);
+	if (!xfs_errortag_valid(error_tag))
+		return false;
+
 	randfactor = mp->m_errortag[error_tag];
 	if (!randfactor || prandom_u32_max(randfactor))
 		return false;
@@ -293,7 +306,7 @@ xfs_errortag_get(
 	struct xfs_mount	*mp,
 	unsigned int		error_tag)
 {
-	if (error_tag >= XFS_ERRTAG_MAX)
+	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
 
 	return mp->m_errortag[error_tag];
@@ -305,7 +318,7 @@ xfs_errortag_set(
 	unsigned int		error_tag,
 	unsigned int		tag_value)
 {
-	if (error_tag >= XFS_ERRTAG_MAX)
+	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
 
 	mp->m_errortag[error_tag] = tag_value;
@@ -319,7 +332,7 @@ xfs_errortag_add(
 {
 	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
 
-	if (error_tag >= XFS_ERRTAG_MAX)
+	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
 
 	return xfs_errortag_set(mp, error_tag,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 26ca3cc1a048..1bdd7afc1010 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1190,15 +1190,6 @@ xfs_buffered_write_iomap_end(
 	struct xfs_mount	*mp = XFS_M(inode->i_sb);
 	int			error;
 
-	/*
-	 * Behave as if the write failed if drop writes is enabled. Set the NEW
-	 * flag to force delalloc cleanup.
-	 */
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DROP_WRITES)) {
-		iomap->flags |= IOMAP_F_NEW;
-		written = 0;
-	}
-
 	error = iomap_file_buffered_write_punch_delalloc(inode, iomap, offset,
 			length, written, &xfs_buffered_write_delalloc_punch);
 	if (error && !xfs_is_shutdown(mp)) {
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

