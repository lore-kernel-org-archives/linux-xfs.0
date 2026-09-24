Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34094455617;
	Thu, 24 Sep 2026 10:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244139; cv=none; b=qsU3gONSCQ8dZlSIiQkYblzqDT/seDM8ksFB5ZFfQWaq84msy7Gv82aVT/3if0vVZz2vOLtHGwx4WnKgUV6oGd+nelzjvMAVqb0roLKWGpotKVTViqzwDt++sge9MRS3HTU7INjRbZcwiYRkLvAbUC7rStQV6PcNig9tCsRkEsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244139; c=relaxed/simple;
	bh=v4+ObU+RXgH2Pbz76WVlPjVqZayo1O4mPGpvruL/Wic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJhyXo67sgbUj/vR4ppEEs1ON4M8jfPQioMuOWBzwoR9nHm8WGHirVSn0B3MQfL+GXhu4MTaLNp8jdPd+QUX7bCHy3Mxx9LX2hiUr+umtDRjpGkY/vyHBVwXZtKbCXRRh1zAn8AEckT/R1EMHinmk9u6J1hT/40a9ABMVKT/lK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b1PWHe8m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b1PWHe8m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+jvftfNeHos3moDlJ5FyMJQB8XxGiVhgVSn6DcFwTaE=; b=b1PWHe8mPEfy4YqDLS6g/2NXRv
	mTJcWQLwPmfH37ViYKEn2y5e2csrqPJZl4tHg1iA5BDJsQDLrkwkThjcwnrWb+J6qmO0CxqHFxqMn
	mEF/3XVVoXgGq+PFdXpDTCdnnlCy36Knj3jdBuYYONSjxEQ7dyb5H6MaQA59/c0OPdJ/4Etyzwbxp
	mqc0JoZWLttmYltxgYwAR777Hg9aj1/bpxx3E/JyJEuHrwr1bO04KG5hdH3DcdtaRXZyaJ5uHhMmi
	+LoWLa3dYAkoWPHeA3vGVo78tZ5+jnktZA/qNr0iIoQK9I7A1Vne7dZEffzG++2bzAWSJjmKN7IgF
	7B1n06TA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gHG-0000000Aefe-2ffp;
	Thu, 24 Sep 2026 10:02:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 17/21] xfs: verify data checksums during media verification
Date: Thu, 24 Sep 2026 11:59:49 +0200
Message-ID: <20260924100032.2733101-18-hch@lst.de>
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

Wire up reading and verifying data checksums during media verification.
This is very similar to the file read path in that it kicks of an async
read for the checksum buffer before reading the data, and then validating
once both are read in.

To support this, split the per-read logic in xfs_verify_media into a
separate helpers for the data checksums vs no checksum cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_verify_media.c | 131 +++++++++++++++++++++++++++++++-------
 1 file changed, 107 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 71f4d6c832a9..46a19405c9e5 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -22,6 +22,7 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
+#include "xfs_rtcsum.h"
 #include "xfs_trace.h"
 #include "xfs_verify_media.h"
 
@@ -261,6 +262,95 @@ xfs_verify_media_error(
 	}
 }
 
+static int
+xfs_submit_verify_bio(
+	struct xfs_mount	*mp,
+	struct xfs_verify_media	*me,
+	struct xfs_buftarg	*btp,
+	struct folio		*folio,
+	xfs_daddr_t		*daddr,
+	uint64_t		*bbcount)
+{
+	unsigned int		bio_bbcount;
+	int			error;
+
+	bio_bbcount = min(*bbcount, folio_size(folio) >> SECTOR_SHIFT);
+	error = bdev_rw_virt(btp->bt_bdev, *daddr, folio_address(folio),
+			bio_bbcount << SECTOR_SHIFT,
+			REQ_OP_READ);
+	if (error) {
+		xfs_verify_media_error(mp, me, btp, *daddr, bio_bbcount, error);
+		return 1;
+	}
+
+	*daddr += bio_bbcount;
+	*bbcount -= bio_bbcount;
+	return 0;
+}
+
+static int
+xfs_submit_verify_bio_csum(
+	struct xfs_mount	*mp,
+	struct xfs_verify_media	*me,
+	struct xfs_buftarg	*btp,
+	struct folio		*folio,
+	xfs_daddr_t		*daddr,
+	uint64_t		*bbcount)
+{
+	struct xfs_buf		*csum_bp = NULL;
+	unsigned int		bio_bbcount;
+	struct bvec_iter	saved_iter;
+	xfs_fsblock_t		bno, end;
+	xfs_filblks_t		len;
+	struct bio		bio;
+	struct bio_vec		bv;
+	int			error;
+
+	bno = xfs_daddr_to_rtb(mp, *daddr);
+	end = xfs_daddr_to_rtb(mp, *daddr + *bbcount);
+	len = min(end - bno, XFS_B_TO_FSBT(mp, folio_size(folio)));
+	len = min(len, xfs_rtcsum_max_len(mp, bno));
+
+	error = xfs_rtcsum_read_async(mp, bno, &csum_bp);
+	if (error)
+		return error;
+
+	*daddr = xfs_rtb_to_daddr(mp, bno);
+	bio_bbcount = XFS_FSB_TO_BB(mp, len);
+
+	bio_init(&bio, btp->bt_bdev, &bv, 1, REQ_OP_READ);
+	bio.bi_iter.bi_sector = *daddr;
+	bio_add_folio_nofail(&bio, folio,
+			min(bio_bbcount << SECTOR_SHIFT, folio_size(folio)), 0);
+	saved_iter = bio.bi_iter;
+
+	error = submit_bio_wait(&bio);
+	if (error)
+		goto out_media_error;
+
+	error = xfs_buf_read_async_wait(csum_bp);
+	if (error)
+		goto out_buf_rele;
+
+	error = xfs_csum_verify(mp, &bio, &saved_iter,
+			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
+			false);
+	if (error)
+		goto out_media_error;
+
+	*daddr += bio_bbcount;
+	*bbcount -= bio_bbcount;
+
+out_buf_rele:
+	xfs_buf_rele(csum_bp);
+	bio_uninit(&bio);
+	return error;
+out_media_error:
+	xfs_verify_media_error(mp, me, btp, *daddr, bio_bbcount, error);
+	error = 1;
+	goto out_buf_rele;
+}
+
 /* Verify the media of an xfs device by submitting read requests to the disk. */
 static int
 xfs_verify_media(
@@ -310,18 +400,13 @@ xfs_verify_media(
 		return 0;
 
 	/*
-	 * There are three ranges involved here:
-	 *
-	 *  - [me->me_start_daddr, me->me_end_daddr) is the range that the
-	 *    user wants to verify.  end_daddr can be beyond the end of the
-	 *    disk; we'll constrain it to the end if necessary.
+	 * [me->me_start_daddr, me->me_end_daddr) is the range that the user
+	 * wants to verify.  end_daddr can be beyond the end of the disk; we'll
+	 * constrain it to the end if necessary.
 	 *
-	 *  - [daddr, me->me_end_daddr) is the range that we have not yet
-	 *    verified.  We update daddr after each successful read.
-	 *    me->me_start_daddr is set to daddr before returning.
-	 *
-	 *  - [daddr, daddr + bio_bbcount) is the range that we're currently
-	 *    verifying.
+	 * [daddr, me->me_end_daddr) is the range that we have not yet verified.
+	 * We update daddr after each successful read.  me->me_start_daddr is
+	 * set to daddr before returning.
 	 */
 	daddr = me->me_start_daddr;
 	bbcount = min_t(sector_t, me->me_end_daddr, btp->bt_nr_sectors) -
@@ -334,22 +419,20 @@ xfs_verify_media(
 	trace_xfs_verify_media(mp, me, btp->bt_dev, daddr, bbcount, folio);
 
 	for (;;) {
-		unsigned int	bio_bbcount;
-
-		bio_bbcount = min(bbcount, folio_size(folio) >> SECTOR_SHIFT);
-		error = bdev_rw_virt(btp->bt_bdev, daddr, folio_address(folio),
-				bio_bbcount << SECTOR_SHIFT,
-				REQ_OP_READ);
+		if (IS_ENABLED(CONFIG_XFS_RT) &&
+		    me->me_dev == XFS_DEV_RT &&
+		    xfs_has_rtcsum(mp)) {
+			error = xfs_submit_verify_bio_csum(mp, me, btp, folio,
+					&daddr, &bbcount);
+		} else {
+			error = xfs_submit_verify_bio(mp, me, btp, folio,
+					&daddr, &bbcount);
+		}
 		if (error) {
-			xfs_verify_media_error(mp, me, btp, daddr, bio_bbcount,
-					error);
-			error = 0;
+			if (error == 1)
+				error = 0;
 			break;
 		}
-
-		daddr += bio_bbcount;
-		bbcount -= bio_bbcount;
-
 		if (bbcount == 0)
 			break;
 
-- 
2.53.0

