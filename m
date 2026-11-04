Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782834;
	b=lHeCMKyFnwVAwf5r/YBpWPXwrSDp4hXqLjEZcwHr2dAHKFpxdhsbdfYmd4mxN9FIo5N9
	 sdKSuIYI4/FSVb86t4ZvYB9u2hAzxk1qCXmpWDuRQ3g+USYtc2nv0bTcntGFq5MbDLJDp
	 QWG2IS/iZq8wJt8AUuoPabSoGJ2wJWKm3G/lX9/J0//9FOYfTRK89SLM2ia9sOqL0lieQ
	 RNlZJw94ODT3D20j7VEgQ/pIrGRSjY2pbfH3hHGdSGpyOfw+GaO04vGg+e72lpy49rgL8
	 Og4ac/il8utWbZBDbW9xGItur5KUWEqNvxIDZKOHXhyJkiGpKhUemrhX6eLgrf+gtzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782834;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=mq/fIeDzXgigUAbEc4Pr7j1E7gw2CVJ/NaLzWXar24E=;
	b=2oD7q4bWkqas5t5tSaHS1ccOmCVhRxokP04ASjKU4VEQq6u00UdraL8BGpP+Ya9GuHad
	 fvGUSMYiuTPDS29UfYUdENF53qD8evuzpDbGKr3AQgUdHig7HJ7If59eks4KFukyqqAXi
	 6CmwJ5Be80IHGagWSODOG5tT2579R1b/zXm85gctjFNW2w66SkejEC6vkjM5kYQ8Ol1d6
	 YGHiBs3Fk1gwWaCJnhC+R833o/MxGAoyvNZNSJ7cbORVeLN4HkjVXelP2105qbDene/7z
	 Zk4zXpbGsyRxasNnur4dx5nZgwngeLf7pwunzmsa6f1YjJ6poLf7x0qeUI4jar6VeFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=b9mmaMkE;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DD8606A332;
	Wed,  4 Nov 2026 09:00:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6DD8606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=b9mmaMkE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mq/fIeDzXgigUAbEc4Pr7j1E7gw2CVJ/NaLzWXar24E=; b=b9mmaMkEChDp37A8IXX4vyCVqk
	kpfsEfYLz0M3f4xC9feNXDaB5zqYgUfF4YG8btH/uhLPFYaoYtle0b+VS9Xl325uJoACZx6265K9Z
	BypMsfS5bzO2miNm4fls5fCbRV1VyCAvKAzB2Zp07Lr4iVQ7RyU/yqJps1dp9rB0D6eYOsODJAU5k
	UNUKUj34LAHWOpKBSwbJPipPFmpfymDR2kvOHm6sTnz1ZKClh32U66/DALCh5/rxd8AL9BWredcmx
	VUEO2L1KOe+8y/j9aWvaluSMMZGlcPIX314IQbPkAIO7+WW/N2yXUTWfAq4pZgv1UrkqHA1wx+LFH
	rLadzsxA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWrA-00000004oYQ-3fgC;
	Wed, 04 Nov 2026 09:00:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 21/25] xfs: don't try to verify checksums on empty zones
Date: Wed,  4 Nov 2026 09:57:25 +0100
Message-ID: <20261104085929.317544-22-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_scrub can sometimes send XFS_IOC_VERIFY_MEDIA ioctls for ranges
that have never been written since the last zone reset, which will
lead to checksum verification failures.

Protect against this by checking that the range is valid.  To make the
range-check non-racy hold the IOLOCK of the rmap inode over the entire
media verification and cycle through it before resetting a zone, as that
is the only way to rewrite data in a zone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_verify_media.c | 46 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_zone_gc.c      |  7 ++++++
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index bafaac2f3ea8..d94bee0b9b6b 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -25,6 +25,7 @@
 #include "xfs_rtcsum.h"
 #include "xfs_trace.h"
 #include "xfs_verify_media.h"
+#include "xfs_zone_alloc.h"
 
 #include <linux/fserror.h>
 
@@ -291,6 +292,46 @@ xfs_submit_verify_bio(
  *
  * When the alignment leads to an empty range, give up.
  */
+static int
+xfs_csum_verify_metafile(
+	struct xfs_mount	*mp,
+	struct bio		*bio,
+	struct bvec_iter	*saved_iter,
+	void			*csum_buf,
+	xfs_fsblock_t		bno)
+{
+	struct xfs_rtgroup	*rtg;
+	bool			is_valid;
+	int			error = 0;
+
+	rtg = xfs_rtgroup_get(mp, xfs_rtb_to_rgno(mp, bno));
+	if (!rtg)
+		return -EFSCORRUPTED;
+
+	/*
+	 * Only validate the checksums for valid data, as data never written
+	 * will not have valid checksums.  We need to hold the iolock on the
+	 * rmap inode over the actual verification to prevent freeing of blocks
+	 * and thus a zone reset to happen underneath us.
+	 *
+	 * Note that this still relies on cooperating userspace, as there also
+	 * can be blocks that were written but never recorded after an unclean
+	 * shutdown, which this check does not catch.  It purely tries to deal
+	 * with races vs the previous FSMAP output used by xfs_scrub.
+	 */
+	xfs_ilock(rtg_rmap(rtg), XFS_IOLOCK_SHARED);
+	xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
+	is_valid = xfs_zone_rgbno_is_valid(rtg, xfs_rtb_to_rgbno(mp, bno));
+	xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
+
+	if (is_valid)
+		error = xfs_csum_verify(mp, bio, saved_iter, csum_buf, bno,
+				false);
+	xfs_iunlock(rtg_rmap(rtg), XFS_IOLOCK_SHARED);
+	xfs_rtgroup_put(rtg);
+	return error;
+}
+
 static int
 xfs_submit_verify_bio_csum(
 	struct xfs_mount	*mp,
@@ -339,9 +380,8 @@ xfs_submit_verify_bio_csum(
 	if (error)
 		goto out_buf_rele;
 
-	error = xfs_csum_verify(mp, &bio, &saved_iter,
-			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
-			false);
+	error = xfs_csum_verify_metafile(mp, &bio, &saved_iter,
+			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno);
 	if (error) {
 		xfs_verify_media_error(mp, me, btp, *daddr, bbcount, error);
 		error = 1;
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 9296f584282a..7e04693fd573 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -1001,6 +1001,13 @@ xfs_submit_zone_reset_bio(
 
 	trace_xfs_zone_reset(rtg);
 
+	/*
+	 * Cycle through the rmap inode iolock to synchronize against
+	 * xfs_csum_verify_metafile.
+	 */
+	xfs_ilock(rtg_rmap(rtg), XFS_IOLOCK_SHARED);
+	xfs_iunlock(rtg_rmap(rtg), XFS_IOLOCK_SHARED);
+
 	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
 
 	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_ZONE_RESET)) {
-- 
2.53.0

