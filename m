Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89FC1E7C2E
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942452; cv=none; b=VabGJvkgQKSk8W6OuvUxlwznL3ex0XtlBZflIIOl/BWpzRmG8aS0yTAvGA3av42j9X7pjrCiAZve2BAz8atH4E8FIOrpnzj1tyzWN9Aqy1zaR/QKGBcUUEkeNxW+nq4+aBsRh2UruDoMoNUDDW4D2Xjt52tNnmoDxx51gmk8Rt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942452; c=relaxed/simple;
	bh=KPU8uD93xQfEG/8OpEg4mKTIfX2bV4qWr1ohNj05FpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/MPPJAIOBpJyNknhpIlbik9g9nRm5GSpU6aqmxa7EowQ19IxezySi4T0AoWd4NcppzmedxDGfp6U0Ci8KcLudij5BAtIcO6oan/V6nfWUAZpP21T0rkKTevX7O7wwK77HM+BWzfR+Hbk8bogBkqZBcK2Ev1cfJZumeFg62L5Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q4d7UQDN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q4d7UQDN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7okHoTsThYjxJHr4I2rSNcTsPCn9ZECiJTJ5IZrSoqw=; b=q4d7UQDN7hFPMPPC79Pu8qLK4d
	oNZnHAxE7f97aBwgej+Xrh5quNzIENU7OXFW13310CHO0DegQlPNeOgXCLmN9xw4YtQm81l2fdA1g
	egt5/9Ev0LPLdZzZ+FU2/bpAev57Q3Fh4oQE6XmNTdjyfOu+C/tkYavI9oazmha0tS1gu6AchHPP9
	Na7HMxIlt1lgQ89rWJWJTGwN+6iutQNSxhaby+ZpFl2QpzJ6c0QxRDs9wLbPbT6qXOqCEqe/0nZJ7
	B4sL8GTT6cOvDRdOn3zbqCvql8CJe+1a2hxAbXHomcFA01s1yme00RJspdhaRVbLu3MoIlpHL1aLM
	RYI1aImw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy98U-00000004IMJ-09WI;
	Mon, 15 Sep 2025 13:20:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: rename the old_crc variable in xlog_recover_process
Date: Mon, 15 Sep 2025 06:20:29 -0700
Message-ID: <20250915132047.159473-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915132047.159473-1-hch@lst.de>
References: <20250915132047.159473-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

old_crc is a very misleading name.  Rename it to expected_crc as that
described the usage much better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e6ed9e09c027..0a4db8efd903 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2894,20 +2894,19 @@ xlog_recover_process(
 	int			pass,
 	struct list_head	*buffer_list)
 {
-	__le32			old_crc = rhead->h_crc;
-	__le32			crc;
+	__le32			expected_crc = rhead->h_crc, crc;
 
 	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 
 	/*
 	 * Nothing else to do if this is a CRC verification pass. Just return
 	 * if this a record with a non-zero crc. Unfortunately, mkfs always
-	 * sets old_crc to 0 so we must consider this valid even on v5 supers.
-	 * Otherwise, return EFSBADCRC on failure so the callers up the stack
-	 * know precisely what failed.
+	 * sets expected_crc to 0 so we must consider this valid even on v5
+	 * supers.  Otherwise, return EFSBADCRC on failure so the callers up the
+	 * stack know precisely what failed.
 	 */
 	if (pass == XLOG_RECOVER_CRCPASS) {
-		if (old_crc && crc != old_crc)
+		if (expected_crc && crc != expected_crc)
 			return -EFSBADCRC;
 		return 0;
 	}
@@ -2918,11 +2917,11 @@ xlog_recover_process(
 	 * zero CRC check prevents warnings from being emitted when upgrading
 	 * the kernel from one that does not add CRCs by default.
 	 */
-	if (crc != old_crc) {
-		if (old_crc || xfs_has_crc(log->l_mp)) {
+	if (crc != expected_crc) {
+		if (expected_crc || xfs_has_crc(log->l_mp)) {
 			xfs_alert(log->l_mp,
 		"log record CRC mismatch: found 0x%x, expected 0x%x.",
-					le32_to_cpu(old_crc),
+					le32_to_cpu(expected_crc),
 					le32_to_cpu(crc));
 			xfs_hex_dump(dp, 32);
 		}
-- 
2.47.2

