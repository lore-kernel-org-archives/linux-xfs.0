Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B98B3B14C0
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785225885; cv=none; b=BZabVPvBbrZpoKd1BXydS/e7nKwDEx1tB9p3vV1RojTfbvM5tN3cA7KVTzbqQl2POlj+Vp0tRPu70recyzg3NkmvQ2icvihlh6ybpDakdpVRUWfc6ZkQEnI95IvUf9AVrUGRuR1a0X0viv7y6U3Az1JCYYTFtsaAQeNAgxEkFrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785225885; c=relaxed/simple;
	bh=MMWZA20UMM3x6qfSbv6dcvh8XemV3dpgd3fl4VQ3vrk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F+8xxVg3tfj5wAv1ZZn6TH34N8YeFe/JRGuLMOf9G2TXE0uGV5yihb261G6vRTKhPiRj8GSm2ZaEnP7rRfssmfGdXCMu4GuOXyDbUZuRLGiXMTgyLM63i2gSxcLdIbyRHoVd7uFYYIDlIFfz1hspKfKYq9yWTEBHJxxlCzJqw1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j1TtEBQV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j1TtEBQV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4qBQkI0nJDEHZy7+OrGTXcLAuYxitmJsM4DqM80LGOc=; b=j1TtEBQVYYsHA4mXun4syh1V0m
	PG76Zbkxs5hZvwx8UZzI5kyrPRNT3x5/dL5d0M4R7+kHO8m4AtOmUQGFuQS2DVNnNJ368cremiHep
	ksG28mTpRkB25wy0tAlZBj2HYBsbPbDMAVibCoKI7cU8B1KG0piSlzHhlCMxZxC5av/WpZ+6dueE0
	fFgV6ACMPPPbnO6dvC1iYQFDJSDaTj7CG+J2Eipooaz9XqEPG62p/dkCqz5c6qx5y09IS0TwX6fU5
	eTkv034SznzXYjmpxBg5fMlYmG0ypiINpgaouMxJhY6wg5KyLESBWH9I53ymh2pY11fQiun9jYU39
	QCQd4/QA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocnn-00000004fyx-0Z7k;
	Tue, 28 Jul 2026 08:04:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: darrick.wong@oracle.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: check v5 superblock features early
Date: Tue, 28 Jul 2026 10:04:35 +0200
Message-ID: <20260728080435.1777362-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When working on a new features that reuses the existing pad in the
superblock, I noticed that mounting such a file system on an old kernel
logs a rather confusing warning:

    XFS (vdc): Metadir superblock padding fields must be zero.

This is because we only validate the various feature fields in v5
superblocks after the common superblock validation helper is called.

Fix this by calling the feature validation first.  To make this more
obvious, rename xfs_validate_sb_read to xfs_validate_sb_features and only
call it for v5 file systems.

Fixes: eca383fcd63b ("xfs: refactor superblock verifiers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 47322adb7690..e3fc19440e0f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -189,15 +189,12 @@ xfs_sb_version_to_features(
 	return features;
 }
 
-/* Check all the superblock fields we care about when reading one in. */
+/* Check for compatible v5 superblock features when reading a superblock */
 STATIC int
-xfs_validate_sb_read(
+xfs_validate_sb_features(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	if (!xfs_sb_is_v5(sbp))
-		return 0;
-
 	/*
 	 * Version 5 superblock feature mask validation. Reject combinations
 	 * the kernel cannot support up front before checking anything else.
@@ -1118,10 +1115,12 @@ xfs_sb_read_verify(
 	 * because _verify_common checks the on-disk values.
 	 */
 	__xfs_sb_from_disk(&sb, dsb, false);
+	if (xfs_sb_is_v5(&sb)) {
+		error = xfs_validate_sb_features(mp, &sb);
+		if (error)
+			goto out_error;
+	}
 	error = xfs_validate_sb_common(mp, bp, &sb);
-	if (error)
-		goto out_error;
-	error = xfs_validate_sb_read(mp, &sb);
 
 out_error:
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
-- 
2.53.0

