Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72E306B25
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 06:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765778821; cv=none; b=bwDCGKyIMLpIZygM46KBXqRixo1W59NnJyFKvfbedIA3IJ8zN7A4rgCaEUlHpLiI1DQUd1es1ImMPvqvraGyVewQpWlqm8WP6+nHmf1WB4O1YPqPgK1LXsyBIu9YUMWvlFAEuqWzRQtksx7iBvnxnm+vqhmEWQCvexs0NRLc2uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765778821; c=relaxed/simple;
	bh=R8TNxy87mQTegydJK5VwpfDKloN3fbjIJGu1y7JSovg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ULZD5PPZh5eQbbIj/Ou3XB5CqNy9C0t16lKdpxmuAPdbXTZNlznzTFUmKg9oPqYcGKZYcdrUQftDXp1KkWmzmZj98o5O0Y8mLXTs6Ew4psLgEQuPTckIenhQBHR09wRjn1AA2VaTQ8VjY1ajwOqxCKX/rTpaHTZy2WSXpmecjmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OG1NjQ9s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OG1NjQ9s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0HTDbKlf4FkEEpe8ZMIEfzPhRUeLybutlySROmMeEXE=; b=OG1NjQ9sBJna3rBZugLO9ZlLGY
	lpb0DlPZhW22f4Vb4aeil3KwT3ACNtHKGl+7t6XKPhQsbcWX6giNH83/ERzVA/N04odhvJXdXCkQ4
	SwAkAKgPdImQbhiJ7+FnHW1eoL2AuYmWWmZbmdGy1iJ8xJI/pRcOrvGsUvwFpxITSUOAvMXIoasF3
	BE3YrglGl1r8SyUKfGI1sIZgXLpJpOxpimdkcVB0yJEtfTcyMsV0e7S34MxFf1sMQ2Dpcsicfp8Tk
	HTi3hEj+JQer4jlW07Xi4Q8cBX9NTyV86/UpylIj82TYnT4h2FM4vyCTOV1kbY7U1EGTAYKe/S5lx
	j5u04o0Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV1jV-000000038fj-2xiR;
	Mon, 15 Dec 2025 06:06:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: bfoster@redhat.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file system
Date: Mon, 15 Dec 2025 07:05:46 +0100
Message-ID: <20251215060654.478876-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The new XFS_ERRTAG_FORCE_ZERO_RANGE error tag added by commit
ea9989668081 ("xfs: error tag to force zeroing on debug kernels") fails
to account for the zoned space reservation rules and this reliably fails
xfs/131 because the zeroing operation returns -EIO.

Fix this by reserving enough space to zero the entire range, which
requires a bit of (fairly ugly) reshuffling to do the error injection
early enough to affect the space reservation.

Fixes: ea9989668081 ("xfs: error tag to force zeroing on debug kernels")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

Changes since v1:
 - only do early injection for zoned mode to declutter the non-zoned
   path a bit

 fs/xfs/xfs_file.c | 58 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6108612182e2..8f753ad284a0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1240,6 +1240,38 @@ xfs_falloc_insert_range(
 	return xfs_insert_file_space(XFS_I(inode), offset, len);
 }
 
+/*
+ * For various operations we need to zero up to one block each at each end of
+ * the affected range.  For zoned file systems this will require a space
+ * allocation, for which we need a reservation ahead of time.
+ */
+#define XFS_ZONED_ZERO_EDGE_SPACE_RES		2
+
+/*
+ * Zero range implements a full zeroing mechanism but is only used in limited
+ * situations. It is more efficient to allocate unwritten extents than to
+ * perform zeroing here, so use an errortag to randomly force zeroing on DEBUG
+ * kernels for added test coverage.
+ *
+ * On zoned file systems, the error is already injected by
+ * xfs_file_zoned_fallocate, which then reserves the additional space needed.
+ * We only check for this extra space reservation here.
+ */
+static inline bool
+xfs_falloc_force_zero(
+	struct xfs_inode		*ip,
+	struct xfs_zone_alloc_ctx	*ac)
+{
+	if (xfs_is_zoned_inode(ip)) {
+		if (ac->reserved_blocks > XFS_ZONED_ZERO_EDGE_SPACE_RES) {
+			ASSERT(IS_ENABLED(CONFIG_XFS_DEBUG));
+			return true;
+		}
+		return false;
+	}
+	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
+}
+
 /*
  * Punch a hole and prealloc the range.  We use a hole punch rather than
  * unwritten extent conversion for two reasons:
@@ -1268,14 +1300,7 @@ xfs_falloc_zero_range(
 	if (error)
 		return error;
 
-	/*
-	 * Zero range implements a full zeroing mechanism but is only used in
-	 * limited situations. It is more efficient to allocate unwritten
-	 * extents than to perform zeroing here, so use an errortag to randomly
-	 * force zeroing on DEBUG kernels for added test coverage.
-	 */
-	if (XFS_TEST_ERROR(ip->i_mount,
-			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
+	if (xfs_falloc_force_zero(ip, ac)) {
 		error = xfs_zero_range(ip, offset, len, ac, NULL);
 	} else {
 		error = xfs_free_file_space(ip, offset, len, ac);
@@ -1423,13 +1448,26 @@ xfs_file_zoned_fallocate(
 {
 	struct xfs_zone_alloc_ctx ac = { };
 	struct xfs_inode	*ip = XFS_I(file_inode(file));
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_filblks_t		count_fsb;
 	int			error;
 
-	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
+	/*
+	 * If full zeroing is forced by the error injection knob, we need a
+	 * space reservation that covers the entire range.  See the comment in
+	 * xfs_zoned_write_space_reserve for the rationale for the calculation.
+	 * Otherwise just reserve space for the two boundary blocks.
+	 */
+	count_fsb = XFS_ZONED_ZERO_EDGE_SPACE_RES;
+	if ((mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ZERO_RANGE &&
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_FORCE_ZERO_RANGE))
+		count_fsb += XFS_B_TO_FSB(mp, len) + 1;
+
+	error = xfs_zoned_space_reserve(mp, count_fsb, XFS_ZR_RESERVED, &ac);
 	if (error)
 		return error;
 	error = __xfs_file_fallocate(file, mode, offset, len, &ac);
-	xfs_zoned_space_unreserve(ip->i_mount, &ac);
+	xfs_zoned_space_unreserve(mp, &ac);
 	return error;
 }
 
-- 
2.47.3

