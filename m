Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C9E46C831;
	Thu, 24 Sep 2026 10:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244143; cv=none; b=JLkY/l2MEVbFvhF6noBKzdJzYa8RlALI0xo+KPGp9jNj+6lmIzkCLvmkQllEwIccFazS6VT1BO339wjQxiNHjuh4um+0E3XF8oE9kDzl76rn761S1Din384MhlOCN7UoiQwNyHdqSddMjN4A51MnkvE0zN3S14cES8PcOtdGQ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244143; c=relaxed/simple;
	bh=Z0r1wTK8bGpsKRFnB33ykrrPmi5j4oHqcZ459esDxkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/Q4uBGhss+G3u206JAEBaZr19z6jzEJesMmyRjEUpmhZAKo6SA4JkTt5lePJ88jBmzGZ5p1RUWtyUpdMYjNpvQfbiOBiuCRlLReWXfdcN3nq4G/e9Hos62EWh8BJFJnXhO7Etq/KbFfBqsj/AGEKhJE5/iQezVRzX4476Pt5nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qQkfnU4M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qQkfnU4M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=33sU0H/XDVxXsGb/GYo7Jnngk9mRy3dKwaZGdg5Vni0=; b=qQkfnU4MqVrtOMvu9lpV/+xZJ7
	bPqz5iJEe1Gq/XCzFcQDXa4kx/8Oon5lrP2mH/ieXNjalCBs1Ck8lwwGoy7j7k259lVRnsv9IEAAk
	N22ygFVUiJ0m+fKQgksw6AyhZoJmDu1hgoGWRW5fc2XHUyFYiqf9pgSeulOwdEiLju4rAdnSYUKIK
	bqRjRabZbW5JoMMzSSOjYpBTVBClvGD26J0AUYk+Rf3OBcYbRPTg8vlCqP/Hg9d8kZtTA0qpVTfjS
	EZbJw16Uy0XP1NmUPjrXzwYA+LR6VS9KH3H2zJGsDAdJTnTafV9zPo1WJa1UlUe1U4C1xLIuU2JhI
	GnebTsQw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gHK-0000000AegH-14IK;
	Thu, 24 Sep 2026 10:02:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 18/21] xfs: don't try to verify checksums on empty zones
Date: Thu, 24 Sep 2026 11:59:50 +0200
Message-ID: <20260924100032.2733101-19-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_scrub can sometimes send XFS_IOC_VERIFY_MEDIA ioctls for ranges
that have never been written since the last zone reset, which will
lead to checksum verification failures.

Protect against this by checking that the range is valid.  If the report
flag is set, a verification failure could lead to health reports and
the file system being marked corrupt, so lock out zone racing reset
completions for this case as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_verify_media.c | 44 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 46a19405c9e5..fc739f7ffa4e 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -25,6 +25,8 @@
 #include "xfs_rtcsum.h"
 #include "xfs_trace.h"
 #include "xfs_verify_media.h"
+#include "xfs_zone_alloc.h"
+#include "xfs_zone_priv.h"
 
 #include <linux/fserror.h>
 
@@ -288,6 +290,43 @@ xfs_submit_verify_bio(
 	return 0;
 }
 
+static int
+xfs_csum_verify_metafile(
+	struct xfs_mount	*mp,
+	struct bio		*bio,
+	struct bvec_iter	*saved_iter,
+	void			*csum_buf,
+	xfs_fsblock_t		bno)
+{
+	struct xfs_rtgroup	*rtg;
+	int			error = 0;
+
+	rtg = xfs_rtgroup_get(mp, xfs_rtb_to_rgno(mp, bno));
+	if (!rtg)
+		return -EFSCORRUPTED;
+
+	/*
+	 * Only validate the checksums for valid data, as data never written
+	 * will not have valid checksums.  We need to hold the ilock on the rmap
+	 * inode to prevent freeing of blocks and thus a zone reset to happen
+	 * underneath us.
+	 *
+	 * Note that this still relies on cooperating userspace, as there also
+	 * can be blocks that were written but never recorded after an unclean
+	 * shutdown, which this check does not catch.  It purely tries to deal
+	 * with races vs the previous FSMAP output used by xfs_scrub.
+	 */
+	xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
+	if (!xa_get_mark(&mp->m_groups[XG_TYPE_RTG].xa, rtg_rgno(rtg),
+			XFS_RTG_FREE)) {
+		error = xfs_csum_verify(mp, bio, saved_iter, csum_buf, bno,
+				false);
+	}
+	xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
+	xfs_rtgroup_put(rtg);
+	return error;
+}
+
 static int
 xfs_submit_verify_bio_csum(
 	struct xfs_mount	*mp,
@@ -332,9 +371,8 @@ xfs_submit_verify_bio_csum(
 	if (error)
 		goto out_buf_rele;
 
-	error = xfs_csum_verify(mp, &bio, &saved_iter,
-			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
-			false);
+	error = xfs_csum_verify_metafile(mp, &bio, &saved_iter,
+			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno);
 	if (error)
 		goto out_media_error;
 
-- 
2.53.0

