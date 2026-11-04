Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782794;
	b=nycl7ZAHZiIzzhMySiIpTTRf1Q5hXPValJZodRYvtbSsYFfjQnohMHW48kbdQjqTwVkk
	 b7dfsmne5VY/bbGBezSyzFhf/MqDZ6DKFjqpJD4SM21eAW1NuUMIbrVNGqRayB4z7z/bn
	 QH764q+/05f2V6HI6I9IAM2q98UBf521fYCRfRXByTLCQpqmSECpBidwVyNc9ZEemRm1d
	 oj99zrCFTvq4iVr4Hgfj3NeTR6T9kcYUEfhCxbgTtF6fOGFHhx4KGI21Ilx6WUe5CsbU1
	 43Do0Rtia1LWEj9u+Z49XCuVM20m7x57VMKdQ261PMItMcQEcQ/dV6AjfXrZJC3pqpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782794;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=22+Own81b2yNqJSvmaIw0EiNNloyI80mFKRW54u6+Tc=;
	b=B6Y9AEOJxNiNqWuXz4AsVriYGpJXZrHuHE+1OqmggDLCWtQTu60OxBfL/PAMCCUEwEn4
	 7EcFd0OhbnC9sazro1nKbtM3BA8SdF2f7b3tQAqR8nd3+hvJLhyoCowJN+NAnAwi1edgY
	 weztfDc+bZ3sYCxGcuQKpd1jA0Xb5XrTjbe+l9rsRdVVXKCiM+hoCID2ooMrHLBW/XtQE
	 iq7+6RYxTwMA4l3xbki3gEU41VRjR0P4lkrIGw25NuT9CL+lKPbRtrWcvJog/DQH947D5
	 jWEjTyYoHjGQzYpuRyrVwE8eljwixSCYYT3jCMRAhCISudXJ2ILlOPJXSIfrhc1Nk2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=tM8WwBsW;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B56606A33C;
	Wed,  4 Nov 2026 08:59:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9B56606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=tM8WwBsW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=22+Own81b2yNqJSvmaIw0EiNNloyI80mFKRW54u6+Tc=; b=tM8WwBsWrhulnuOO9dWkhbffNd
	2v6DIsDLXqapICX9BGlFw2f7b376z70BZZiTI2IvtySDZP+Jx2uo8P6nN5qMSl6pXQ4wSwN/We8zs
	JWSDztRa1NBHCvjwnz8eGm1W9E7NtEBd/n8iPVePMWc7Bxfb2FtLO+OW0DLVMPeFHoROC884TP6Eu
	C8+lCcawBNofA9sLzbXmvxbtSkd78tDxA7s0xl3xQFOzLMVPIMYd335uU0/35vgQf2L096IjFhKb5
	lpUj7T+WtD11puJzsbrEY8GaAQ0GVW0mgva8go+JXjBDPtlAQNyMja53UrGU8CbiD/EcPwxTTgjLC
	x1ytjZyA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqX-00000004oNC-064P;
	Wed, 04 Nov 2026 08:59:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 07/25] xfs: prepare xfs_rtfile_initialize_blocks for larger than FSB blocks
Date: Wed,  4 Nov 2026 09:57:11 +0100
Message-ID: <20261104085929.317544-8-hch@lst.de>
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

The upcoming RT data checksum feature will use larger than FSB blocks.
Prepare xfs_rtfile_initialize_blocks to pass the number of FSBs per
RT blocks, and to pass bmapi_flags to ask for contiguous allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 47 ++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_rtbitmap.h |  3 ++-
 fs/xfs/xfs_rtalloc.c         |  4 +--
 3 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 7fbfca2a5edd..c83d7f961f40 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1345,6 +1345,7 @@ xfs_rtfile_alloc_blocks(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		offset_fsb,
 	xfs_filblks_t		count_fsb,
+	uint32_t		bmapi_flags,
 	struct xfs_bmbt_irec	*map)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1366,7 +1367,7 @@ xfs_rtfile_alloc_blocks(
 		goto out_trans_cancel;
 
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-			XFS_BMAPI_METADATA, 0, map, &nmap);
+			XFS_BMAPI_METADATA | bmapi_flags, 0, map, &nmap);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1404,34 +1405,46 @@ xfs_rtfile_initialize_block(
 	struct xfs_rtgroup	*rtg,
 	enum xfs_rtg_inodes	type,
 	xfs_fsblock_t		fsbno,
-	void			*data)
+	xfs_filblks_t		nblks,
+	void			**data)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_inode	*ip = rtg->rtg_inodes[type];
+	size_t			len = XFS_FSB_TO_B(mp, nblks);
+	size_t			copylen = len;
+	struct xfs_trans_res	tres = M_RES(mp)->tr_growrtzero;
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
-	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
 	int			error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
+	/* The log should always be able to handle 64k of logged buffers */
+	ASSERT(nblks <= XFS_B_TO_FSB(mp, SZ_64K));
+
+	tres.tr_logres *= nblks;
+	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
 	if (error)
 		return error;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
-			XFS_FSB_TO_DADDR(mp, fsbno), mp->m_bsize, 0, &bp);
+			XFS_FSB_TO_DADDR(mp, fsbno), BTOBB(len), 0, &bp);
 	if (error) {
 		xfs_trans_cancel(tp);
 		return error;
 	}
 
+	if (xfs_has_rtgroups(mp))
+		copylen -= sizeof(struct xfs_rtbuf_blkinfo);
+
 	xfs_rtfile_initialize_buf(rtg, type, bp, tp);
-	if (data)
-		memcpy(xfs_rtblock_payload(bp), data, copylen);
-	else
+	if (*data) {
+		memcpy(xfs_rtblock_payload(bp), *data, copylen);
+		*data += copylen;
+	} else {
 		memset(xfs_rtblock_payload(bp), 0, copylen);
-	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
+	}
+	xfs_trans_log_buf(tp, bp, 0, len - 1);
 	return xfs_trans_commit(tp);
 }
 
@@ -1446,33 +1459,31 @@ xfs_rtfile_initialize_blocks(
 	enum xfs_rtg_inodes	type,
 	xfs_fileoff_t		offset_fsb,	/* offset to start from */
 	xfs_fileoff_t		end_fsb,	/* offset to allocate to */
+	xfs_filblks_t		bsize,
+	uint32_t		bmapi_flags,
 	void			*data)		/* data to fill the blocks */
 {
-	struct xfs_mount	*mp = rtg_mount(rtg);
-	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
-
 	while (offset_fsb < end_fsb) {
 		struct xfs_bmbt_irec	map;
 		xfs_filblks_t		i;
 		int			error;
 
 		error = xfs_rtfile_alloc_blocks(rtg->rtg_inodes[type],
-				offset_fsb, end_fsb - offset_fsb, &map);
+				offset_fsb, end_fsb - offset_fsb, bmapi_flags,
+				&map);
 		if (error)
 			return error;
 
 		/*
-		 * Now we need to clear the allocated blocks.
+		 * Now we need to clear or initialize the allocated blocks.
 		 *
 		 * Do this one block per transaction, to keep it simple.
 		 */
-		for (i = 0; i < map.br_blockcount; i++) {
+		for (i = 0; i < map.br_blockcount; i += bsize) {
 			error = xfs_rtfile_initialize_block(rtg, type,
-					map.br_startblock + i, data);
+					map.br_startblock + i, bsize, &data);
 			if (error)
 				return error;
-			if (data)
-				data += copylen;
 		}
 
 		offset_fsb = map.br_startoff + map.br_blockcount;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 750d74fbf4ed..e9e3378d15aa 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -410,7 +410,8 @@ void xfs_rtfile_initialize_buf(struct xfs_rtgroup *rtg,
 		struct xfs_trans *tp);
 int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
 		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
-		xfs_fileoff_t end_fsb, void *data);
+		xfs_fileoff_t end_fsb, xfs_filblks_t bsize,
+		uint32_t bmapi_flags, void *data);
 int xfs_rtbitmap_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
 		struct xfs_trans *tp, bool init);
 int xfs_rtsummary_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 84efe5a8fb11..78a1c066c7eb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1191,11 +1191,11 @@ xfs_growfs_rt_alloc_blocks(
 	}
 
 	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP, orbmblocks,
-			nmp->m_sb.sb_rbmblocks, NULL);
+			nmp->m_sb.sb_rbmblocks, 1, 0, NULL);
 	if (error)
 		goto out_free;
 	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY, orsumblocks,
-			nmp->m_rsumblocks, NULL);
+			nmp->m_rsumblocks, 1, 0, NULL);
 out_free:
 	kfree(nmp);
 	return error;
-- 
2.53.0

