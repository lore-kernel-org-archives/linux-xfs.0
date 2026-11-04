Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782791;
	b=Fzo4SAPTzwQl4VZy0TWBOHkbwMvmR0vp72JfhM0PaDC6dr2jx9Oy35rcJ2RorvzIOnCo
	 WGVJRwpot1OmksbaNiyOcCm+tuevtDDh852Hvan2KPS66TxRdy/tWGGd8d4orSvsvRJY0
	 DALUdb4TloCPNPtz3d7GKf16B0X4m+lQOt5Vl1hlGRIDNfU0awuRw+bno5G4usNRDBKVq
	 GACrsrK5XCsQaRWyx29srRgzu7h6Gjns6isZhA/OcITh/F+cbFBl1TG67/Gr6cI8LMzvI
	 Ta57AMOnxkOPxUI3NJ4UfPzSOPk4oIe/gPZ7H5Ma/gkPLZOEtvZIy7JeA2+Ydynu+mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782791;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=Awu0kSLJpMV0DIL20WQPGIQke1Y88DDrpKpp+VwloBU=;
	b=STRNI5eoohlArJKKpG5W/C0E2z0xFzpzO6Lg7meGbsUTovJZW0h1SqZVDLt4NhKtS/RO
	 gvjNuQaowrAUZJ5Egde3OzDUZ8gZQQJFDSggy7JSBI4acpUlYzuw710h2TCrZJQDW+iyQ
	 dTCZV3rRYeLamlbB5BERRRIIKC+0qPSg5ZTeRi9HRdvVJqW9AJu8KAi/Tw6Hdopy6/P4n
	 BCEVA3jjpcl2TdMdWYm6jteRMFsZzOH8rzQ6GcaEFMhJaCyjZ1GXyfqBrgsggN+s7hp4x
	 Q36eqMSCgWRM3fBDBRF2NjJ4ZL84kqvDEGOh0FwRpQMTq95u4Vx3S3GfGO9tH4FXcKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=L6vzNPqV;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A96E606A32C;
	Wed,  4 Nov 2026 08:59:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A96E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=L6vzNPqV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Awu0kSLJpMV0DIL20WQPGIQke1Y88DDrpKpp+VwloBU=; b=L6vzNPqVDQ2nh4lNaNDxi6TiMT
	1t15a6Lk145F6kauvZShkL3DmcIZery4wnWhBOkiWNQof+3j+N/ectcNFcLluIQJ7Wovq/gj84qJG
	aeGAUydUxMPxDqvx518brEqbkTV6qwfyorRsyT8Bj25rFiP+PgszHU2If/NRTC7p2AiziTkku1BBE
	VHRkIJVi92DNG/U2/bvV3hpXI3F3vS9WCwcJYMZzOc55nzzqE9YEOKG/+DsosEzxmcKAKdA6gRGBZ
	KRxA0XnP4JZqDMCBm2jp7EfYRg1obWa+EgweE2p8x/GmuZgVcp1J1wk9EYRv1HQ0XRYhNcliWUur+
	BCUL/xyA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqU-00000004oM9-1HLQ;
	Wed, 04 Nov 2026 08:59:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 06/25] xfs: add xfs_daddr_to_rgno and xfs_daddr_to_rgbno helpers
Date: Wed,  4 Nov 2026 09:57:10 +0100
Message-ID: <20261104085929.317544-7-hch@lst.de>
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

Translate from a disk address to the realtime group and group-relative
block numbers.  This will be needed by the data checksumming code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index fca2eb74908c..f26e324f0de3 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -390,4 +390,24 @@ xfs_rtgroup_raw_size(
 	return g->blocks;
 }
 
+static inline xfs_rgnumber_t
+xfs_daddr_to_rgno(struct xfs_mount *mp, xfs_daddr_t d)
+{
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		rbno = XFS_BB_TO_FSBT(mp, d) - g->start_fsb;
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return div_u64(rbno, xfs_rtgroup_raw_size(mp));
+}
+
+static inline xfs_rgblock_t
+xfs_daddr_to_rgbno(struct xfs_mount *mp, xfs_daddr_t d)
+{
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		rbno = XFS_BB_TO_FSBT(mp, d) - g->start_fsb;
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return do_div(rbno, xfs_rtgroup_raw_size(mp));
+}
+
 #endif /* __LIBXFS_RTGROUP_H */
-- 
2.53.0

