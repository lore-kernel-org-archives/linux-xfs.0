Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782828;
	b=rxQa9QAncHUy74g6CGOTzP5rwlcWWJpwWZd3J6btv78yvILupS8Lj1Rs7qmhowPBx2oo
	 Jgh+vCfkcihKElyFsxNSf/F7/BlHkLnMyRoyIjnCrL+OZvm6LkgWcAVu4saZqQhXua4cx
	 IXWtLGeslbJ/ZgCdWNpiX3Ffmgt+bMw0s559/0fEMARsrVyAFN7H1lKFHzZ9Hk7uHA8ca
	 gJxz/KBnKABCYvUnqCbT9mmAoK5G+3DobeRHL3hHeh39K6g0VKG/mrx2JqETRRjZf2/Ge
	 c6+R1ersrXck02iLTKT29QqUazEGtYvFAaRRB5gklluxifiHJ2XKKv/d79YiX9oNjbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782828;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=c1tB8Ns2hhy9qaCmWqZiPRPyGTBVliQlqVWOHE27XC0=;
	b=RJW/6AyDcYKPsAjaJ5+wE5oclRVDTJFgyyKDvV2SiRUPWMYkwwMGMuySoWw/+4FnVOgq
	 hmbFJ8tHvnhgO4QQUowpvEGmy2l+JO2/E59dPJ42+O9eWN/nT69p9Jg89CozdE2TNLaqv
	 sUEdlZwjApVteJGcXole9ibjwFFRXhABh4VcyA9ZYnlnENLedpmDVtE/1WvOKdWOdTvQe
	 z/1wnj48Q4dUPlOCuM0WhFc3in83J6K6vJmsezxYWKgneC0ffAUOB6oL//bpS1Z9hZ4nY
	 Zc5VPqYQGzCL9qbPRdvXDcH7e6IxR8QTBROBvXSrThzt1UsANsSXnZGquzT4wufZJ+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="jnbTe/ob";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5915B606D806;
	Wed,  4 Nov 2026 09:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5915B606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=jnbTe/ob
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c1tB8Ns2hhy9qaCmWqZiPRPyGTBVliQlqVWOHE27XC0=; b=jnbTe/obL0hT9aLzxAW0MJeNPy
	psviwiB7qIKP3p9R0TkehP4w6jEJrtAxodEt3ZRfnTio0U9OFheWPGxgvLsr8I2pceIoi2+d4gL3L
	wIeozOMFPw8iFkfjHVjEcCdTESSupc7/J+oNQ92iwpDT94sozJAbPzmSjexHEC5R3lHGrdfPL5vmd
	+2D1ry6tW/Emx7wwHSeSu0vVF8LuPjz7Rx51brq99hvwmtt96sU9uuWu0plYnu5aB7ymbcYn/SxXa
	ssVsIkAn0xF5oyFZ25zSftvtCLg+4i/J918BGaIFruKyXuYwuuRTUvcpBSql/3njdYAhyBzmnXrNm
	wM+f7RQQ==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWr5-00000004oWa-1WV3;
	Wed, 04 Nov 2026 09:00:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 19/25] xfs: simplify range tracking in xfs_verify_media
Date: Wed,  4 Nov 2026 09:57:23 +0100
Message-ID: <20261104085929.317544-20-hch@lst.de>
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

Remove the bbcount variable tracking the remainining basic blocks in
the current verification request, and instead always recalculated it
from the daddr and the end, reducing the number of moving pieces.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_verify_media.c | 42 +++++++++++----------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 516763219d3f..382c46cdfb6a 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -267,12 +267,11 @@ xfs_verify_media(
 	struct xfs_mount	*mp,
 	struct xfs_verify_media	*me)
 {
+	xfs_daddr_t		daddr = me->me_start_daddr;
 	struct xfs_buftarg	*btp = NULL;
 	struct folio		*folio;
 	xfs_daddr_t		dev_start = 0;
 	xfs_daddr_t		dev_end = 0;
-	xfs_daddr_t		daddr;
-	uint64_t		bbcount;
 	int			error = 0;
 
 	me->me_ioerror = 0;
@@ -305,11 +304,11 @@ xfs_verify_media(
 	 */
 	if (me->me_end_daddr > dev_end)
 		me->me_end_daddr = dev_end;
-	if (me->me_start_daddr < dev_start)
-		me->me_start_daddr = dev_start;
+	if (daddr < dev_start)
+		daddr = dev_start;
 
 	/* start and end have to be aligned to the lba size */
-	if (!IS_ALIGNED(BBTOB(me->me_start_daddr | me->me_end_daddr),
+	if (!IS_ALIGNED(BBTOB(daddr | me->me_end_daddr),
 			btp->bt_logical_sectorsize))
 		return -EINVAL;
 
@@ -317,36 +316,22 @@ xfs_verify_media(
 	 * end_daddr is the exclusive end of the range, so if start_daddr
 	 * reaches there (or beyond), there's no work to be done.
 	 */
-	if (me->me_start_daddr >= me->me_end_daddr)
+	if (daddr >= me->me_end_daddr)
 		return 0;
 
-	/*
-	 * There are three ranges involved here:
-	 *
-	 *  - [me->me_start_daddr, me->me_end_daddr) is the range that the
-	 *    user wants to verify.  end_daddr can be beyond the end of the
-	 *    disk; we'll constrain it to the end if necessary.
-	 *
-	 *  - [daddr, me->me_end_daddr) is the range that we have not yet
-	 *    verified.  We update daddr after each successful read.
-	 *    me->me_start_daddr is set to daddr before returning.
-	 *
-	 *  - [daddr, daddr + bio_bbcount) is the range that we're currently
-	 *    verifying.
-	 */
-	daddr = me->me_start_daddr;
-	bbcount = me->me_end_daddr - me->me_start_daddr;
-
-	folio = xfs_verify_alloc_folio(xfs_verify_iosize(me, btp, bbcount));
+	folio = xfs_verify_alloc_folio(xfs_verify_iosize(me, btp,
+			me->me_end_daddr - daddr));
 	if (!folio)
 		return -ENOMEM;
 
-	trace_xfs_verify_media(mp, me, btp->bt_dev, daddr, bbcount, folio);
+	trace_xfs_verify_media(mp, me, btp->bt_dev, daddr,
+			me->me_end_daddr - daddr, folio);
 
 	for (;;) {
 		unsigned int	bio_bbcount;
 
-		bio_bbcount = min(bbcount, folio_size(folio) >> SECTOR_SHIFT);
+		bio_bbcount = min(me->me_end_daddr - daddr,
+				folio_size(folio) >> SECTOR_SHIFT);
 		error = bdev_rw_virt(btp->bt_bdev, daddr, folio_address(folio),
 				bio_bbcount << SECTOR_SHIFT,
 				REQ_OP_READ);
@@ -356,11 +341,8 @@ xfs_verify_media(
 			error = 0;
 			break;
 		}
-
 		daddr += bio_bbcount;
-		bbcount -= bio_bbcount;
-
-		if (bbcount == 0)
+		if (daddr >= me->me_end_daddr)
 			break;
 
 		if (me->me_rest_us) {
-- 
2.53.0

