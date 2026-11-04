Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782831;
	b=LZ8+vHtgDsa/fXnRbYD60Gsl4mLHoI+8bHoG0KhvDYoIrny+i5P24+99S2rsBd6wmp+t
	 XgX+Av1W5IKQGpvakCMnSurmXq4kZvmJG/YqSoGB/i49ZxF2Eec40AVaZjBABDF2C+oDa
	 C9Uha3xLciAZS1oVw+/FVFXq93JLUFNYlSgsU/ZrbqOscbivL2SsdHKoWZmWnyxxRj/12
	 RAEeZtk7a3Oa8GP+lFopK7PgpCsXap1tpCbBz0DHAxXgLAZIwFERgIqdP+1aFmQzWxuei
	 4tcZq1ctDCuhMhrEtIh4ujF2m8murodUkI0Ta9KLXbys3qxabMNsI1VGUT8Au2wJJOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782831;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=q/1Y/Rds5orJjPsmLFm0V7zk5/KEgsW0ipG4zR6d6Qc=;
	b=xfh/YwRwy1g7NPsYLfCEFDukW/W/UboIN909vLJey8QtHIOBvXOtnFNy14yF5UUDtt9X
	 7MPDsRc5kkYzKNudsngy/8IBkbLYY+Hk92HQ/pFf/Wb0TVNaNzwHrqkxCATWNJwfrHs3z
	 NBGfxjkPbOsmaftdqQlnVOZrI09aMqaRPIxRoaIES8QWcrM4i4kM+eRSB/1rG2TCaAbqf
	 DUruM7mnLu6DPrpSQwDCsfXurAkIP0dvqSm276jtRIZ0FOrg4HsoM7PdmPhHjb76D4Yrs
	 NkhmZa/ZeWJ0KgK7ta3N3BH1OwYi5vaGhoHTqRmqaXP9GNjlbfihO8rPOFFM4QVxdLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=XQwHdf3k;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89F9606A329;
	Wed,  4 Nov 2026 09:00:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E89F9606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=XQwHdf3k
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q/1Y/Rds5orJjPsmLFm0V7zk5/KEgsW0ipG4zR6d6Qc=; b=XQwHdf3k56y+ppCMG3YzcOMKAS
	aVHtAghOzB6WPm5iuTzNJqVFhJs50NdqpKrHnMWKSIZ1IRF5jDP72EBRyYBo8WawUNrVhmCf5xqA7
	6UUDRBTeW3l1M8sL9F9lctH78dgE7WWT73m+zYzS1qHVbJIx/TwuoWx7DKlJTIf0XJLFlM0ROcRXi
	aYLyAiF70QXwZyNBfotqVGu8r1ZNDhRH6A1aYLhFJIK5l20eIqTs4RBQnu7oAT+lwvrZOiYfDdhkm
	GuOySUu+RQQsfIVMCs61V+A8t5xPitIQm7FwToYcHZNB9GS/DA8oNFaOP/24Rxy3FAGH26gr7WUgO
	pnm0eJNA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWr8-00000004oXE-0TqE;
	Wed, 04 Nov 2026 09:00:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 20/25] xfs: verify data checksums during media verification
Date: Wed,  4 Nov 2026 09:57:24 +0100
Message-ID: <20261104085929.317544-21-hch@lst.de>
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

Wire up reading and verifying data checksums during media verification.
This is very similar to the file read path in that it kicks of an async
read for the checksum buffer before reading the data, and then validating
once both are read in.

To support this, split the per-read logic in xfs_verify_media into a
separate helpers for the data checksums vs no checksum cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_verify_media.c | 116 ++++++++++++++++++++++++++++++++++----
 1 file changed, 105 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 382c46cdfb6a..bafaac2f3ea8 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -22,6 +22,7 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
+#include "xfs_rtcsum.h"
 #include "xfs_trace.h"
 #include "xfs_verify_media.h"
 
@@ -261,6 +262,99 @@ xfs_verify_media_error(
 	}
 }
 
+static int
+xfs_submit_verify_bio(
+	struct xfs_mount	*mp,
+	struct xfs_verify_media	*me,
+	struct xfs_buftarg	*btp,
+	struct folio		*folio,
+	xfs_daddr_t		*daddr)
+{
+	unsigned int		bbcount;
+	int			error;
+
+	bbcount = min(me->me_end_daddr - *daddr,
+			folio_size(folio) >> SECTOR_SHIFT);
+	error = bdev_rw_virt(btp->bt_bdev, *daddr, folio_address(folio),
+			bbcount << SECTOR_SHIFT, REQ_OP_READ);
+	if (error) {
+		xfs_verify_media_error(mp, me, btp, *daddr, bbcount, error);
+		return 1;
+	}
+
+	*daddr += bbcount;
+	return 0;
+}
+
+/*
+ * Data checksums are per-FSB, so we can only validate FSB-aligned regions.
+ *
+ * When the alignment leads to an empty range, give up.
+ */
+static int
+xfs_submit_verify_bio_csum(
+	struct xfs_mount	*mp,
+	struct xfs_verify_media	*me,
+	struct xfs_buftarg	*btp,
+	struct folio		*folio,
+	xfs_daddr_t		*daddr)
+{
+	xfs_fsblock_t		bno = xfs_daddr_to_rtb(mp, *daddr);
+	xfs_fsblock_t		end = xfs_daddr_to_rtb(mp, me->me_end_daddr);
+	struct xfs_buf		*csum_bp = NULL;
+	struct bvec_iter	saved_iter;
+	unsigned int		bbcount;
+	xfs_filblks_t		len;
+	struct bio		bio;
+	struct bio_vec		bv;
+	int			error;
+
+	len = min3(end - bno, xfs_rtcsum_max_len(mp, bno),
+			XFS_B_TO_FSBT(mp, folio_size(folio)));
+	if (!len) {
+		*daddr = me->me_end_daddr;
+		return 0;
+	}
+
+	error = xfs_rtcsum_read_async(mp, bno, &csum_bp);
+	if (error)
+		return error;
+
+	*daddr = xfs_rtb_to_daddr(mp, bno);
+	bbcount = XFS_FSB_TO_BB(mp, len);
+
+	bio_init(&bio, btp->bt_bdev, &bv, 1, REQ_OP_READ);
+	bio.bi_iter.bi_sector = *daddr;
+	bio_add_folio_nofail(&bio, folio, bbcount << SECTOR_SHIFT, 0);
+
+	saved_iter = bio.bi_iter;
+	error = submit_bio_wait(&bio);
+	if (error) {
+		xfs_verify_media_error(mp, me, btp, *daddr, bbcount, error);
+		error = 1;
+		goto out_buf_rele;
+	}
+
+	error = xfs_buf_read_async_wait(csum_bp);
+	if (error)
+		goto out_buf_rele;
+
+	error = xfs_csum_verify(mp, &bio, &saved_iter,
+			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
+			false);
+	if (error) {
+		xfs_verify_media_error(mp, me, btp, *daddr, bbcount, error);
+		error = 1;
+		goto out_buf_rele;
+	}
+
+	*daddr = xfs_rtb_to_daddr(mp, bno + len);
+out_buf_rele:
+	xfs_buf_rele(csum_bp);
+	bio_uninit(&bio);
+	return error;
+}
+
 /* Verify the media of an xfs device by submitting read requests to the disk. */
 static int
 xfs_verify_media(
@@ -328,20 +422,20 @@ xfs_verify_media(
 			me->me_end_daddr - daddr, folio);
 
 	for (;;) {
-		unsigned int	bio_bbcount;
-
-		bio_bbcount = min(me->me_end_daddr - daddr,
-				folio_size(folio) >> SECTOR_SHIFT);
-		error = bdev_rw_virt(btp->bt_bdev, daddr, folio_address(folio),
-				bio_bbcount << SECTOR_SHIFT,
-				REQ_OP_READ);
+		if (IS_ENABLED(CONFIG_XFS_RT) &&
+		    me->me_dev == XFS_DEV_RT &&
+		    xfs_has_rtcsum(mp)) {
+			error = xfs_submit_verify_bio_csum(mp, me, btp, folio,
+					&daddr);
+		} else {
+			error = xfs_submit_verify_bio(mp, me, btp, folio,
+					&daddr);
+		}
 		if (error) {
-			xfs_verify_media_error(mp, me, btp, daddr, bio_bbcount,
-					error);
-			error = 0;
+			if (error == 1)
+				error = 0;
 			break;
 		}
-		daddr += bio_bbcount;
 		if (daddr >= me->me_end_daddr)
 			break;
 
-- 
2.53.0

