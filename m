Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A232C031B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769530027; cv=none; b=VRKz2du0vrRM8AtxPlCGUYWhcsspyniIhXXZALgcLvU1XcV3p1p9wCO8h14fomG4n+EWVxZv4rZKIstA+Hn1I2hJSx6cdsMdZZW+O/Wvw+K5OT2SN833TPuNE2ftyeQw6OCSzDORnxaQdCwVBAtgxERctm/DnKYjN9KARB9gjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769530027; c=relaxed/simple;
	bh=joXRKmESvPIK8Xt9HvGBJxnBX3vqrebujRV9bEs06hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTNoGIh0ZZWHDsC7v0jnBQL2dG6aASyrNdEEnRWMovThKiFw/LMvM4tf1BfUDVKlZQElJUZMNc4P5F+5m2gXeWB9Hw0qCAef4BaiqB9aym85NJprSJltoJkCMerOvzUZZ9r/BBnZcWjMMqwMvVrtx3U0+CmsJiMBzg81XT1VbtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mAtQcbqI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mAtQcbqI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4itPerrE37i5Flo+sefwFraPMQsRvxUP7zqaOz5SGUM=; b=mAtQcbqI5i79z+wqKEwFpZwdyJ
	5WC0nSYJtqvuz/BvZR2PbJOMGVLiA32gLEP3zFpOdotHP8BDN5flb6eZesVx9puI92NkiNQFAx6vy
	MuOT8y07EBfrn1zwsgZ895kgbL/k8lWirMIOa45FoZHrd1ScKoq+kD9lj6ynkCdRpexnNxr+7R35j
	CwSerzCYXTdVE/BVRKglnztBQRuL/DGWftUO1Wes8NlvE0UjZlLav6jGMDz4vI8t3b9hF2xUwNQZ5
	mcM+vWcDl6y/XHoxI4ovguipglo4UZJbIXU+88AwFSUFcfinpK0ONd/K5UIicrMw5v129B2A9F51D
	Sk+SQFlQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklar-0000000Ebng-1Vb8;
	Tue, 27 Jan 2026 16:07:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/10] xfs: refactor zone reset handling
Date: Tue, 27 Jan 2026 17:05:48 +0100
Message-ID: <20260127160619.330250-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Include the actual bio submission in the common zone reset handler to
share more code and prepare for adding error injection for zone reset.

Note the I plan to refactor the block layer submit_bio_wait and
bio_await_chain code in the next merge window to remove some of the
code duplication added here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 49 +++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 60964c926f9f..4023448e85d1 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -893,40 +893,55 @@ xfs_zone_gc_finish_reset(
 	bio_put(&chunk->bio);
 }
 
-static bool
-xfs_zone_gc_prepare_reset(
-	struct bio		*bio,
-	struct xfs_rtgroup	*rtg)
+static void
+xfs_submit_zone_reset_bio(
+	struct xfs_rtgroup	*rtg,
+	struct bio		*bio)
 {
 	trace_xfs_zone_reset(rtg);
 
 	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
 	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
 	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
-		if (!bdev_max_discard_sectors(bio->bi_bdev))
-			return false;
+		/*
+		 * Also use the bio to drive the state machine when neither
+		 * zone reset nor discard is supported to keep things simple.
+		 */
+		if (!bdev_max_discard_sectors(bio->bi_bdev)) {
+			bio_endio(bio);
+			return;
+		}
 		bio->bi_opf &= ~REQ_OP_ZONE_RESET;
 		bio->bi_opf |= REQ_OP_DISCARD;
 		bio->bi_iter.bi_size =
 			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
 	}
 
-	return true;
+	submit_bio(bio);
+}
+
+static void xfs_bio_wait_endio(struct bio *bio)
+{
+	complete(bio->bi_private);
 }
 
 int
 xfs_zone_gc_reset_sync(
 	struct xfs_rtgroup	*rtg)
 {
-	int			error = 0;
+	DECLARE_COMPLETION_ONSTACK(done);
 	struct bio		bio;
+	int			error;
 
 	bio_init(&bio, rtg_mount(rtg)->m_rtdev_targp->bt_bdev, NULL, 0,
-			REQ_OP_ZONE_RESET);
-	if (xfs_zone_gc_prepare_reset(&bio, rtg))
-		error = submit_bio_wait(&bio);
-	bio_uninit(&bio);
+			REQ_OP_ZONE_RESET | REQ_SYNC);
+	bio.bi_private = &done;
+	bio.bi_end_io = xfs_bio_wait_endio;
+	xfs_submit_zone_reset_bio(rtg, &bio);
+	wait_for_completion_io(&done);
 
+	error = blk_status_to_errno(bio.bi_status);
+	bio_uninit(&bio);
 	return error;
 }
 
@@ -961,15 +976,7 @@ xfs_zone_gc_reset_zones(
 		chunk->data = data;
 		WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 		list_add_tail(&chunk->entry, &data->resetting);
-
-		/*
-		 * Also use the bio to drive the state machine when neither
-		 * zone reset nor discard is supported to keep things simple.
-		 */
-		if (xfs_zone_gc_prepare_reset(bio, rtg))
-			submit_bio(bio);
-		else
-			bio_endio(bio);
+		xfs_submit_zone_reset_bio(rtg, bio);
 	} while (next);
 }
 
-- 
2.47.3

