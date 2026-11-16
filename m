Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871105;
	b=l00KrTJn8Nyq01j9TzojC72zAbqMFB4eRaVf6AQ4Ssrj1eidQ/W/m9joKp7fewkSXOac
	 yKIk6RlU5nkq+EWTnK1Z4Rc2bo9GpWTTkiShTLQSnRCibCmqwQGctfCNKyiQUcCrs/m0q
	 U8/bNrJMWWQLqo2zSUj6ttWo1T20SrTZeySg4WGnMprMEowW7CPlaZiPqaY1Wy4/EcVXL
	 jceiOFpTQUrmJGt6iCJgvPDrgKL4NPXwPORkae40/Y6L/oIM9iaRw7UcyAdjKxfRTDG7z
	 cuFXRZFU+cRFVItMHhGN6OuTWI4QaGP8j4ukPnXuH2VSmpJIzju5lQY/NntgLWp9EgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6aujE/RVQlf36+Vr1S5uyET85EgkTqgwAnVotCjFeYQ=;
	b=DRfcxIjrfmDzeXBQYQIl34plnAOkXVPbyl+ITMQEct2Z/PgYj0R4zzu13onUfOx4jEbU
	 ELVV8sb8Vvp8mEpe4Tom2rS9z/5gefrXApB29LtiBviyIHEk2FYfKMcMpHOfgTEKj8sDa
	 0I5AY2KOLV1raxScXC8eZzM4Ra1aZ3LW3fGe/Rq3Dk5jg8vmBwcIpT3sAuR9Z0t3tyrZw
	 6NMcfClF4QX8O1ThozTXhP5A7pmgkPRKwUf8/3U6JRuzN+DyIvKMni40xoXPVMKXFXQG9
	 Ud7elE2SO8TLilNv/cuQslwyMmfzC3qLqkdW6ocj8vtx/QYn2w5+ZBmvPeBT+d8Hfxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QTAChdGl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD5F606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QTAChdGl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16C01F000C4;
	Mon, 16 Nov 2026 23:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871105;
	bh=6aujE/RVQlf36+Vr1S5uyET85EgkTqgwAnVotCjFeYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTAChdGlD9AuFQm/9PxSV2l5ieVPonrfW81wklTDWJwdWlcQjDUFu6jt87CcPY6a9
	 RAJKdiNUToHrrDm7ShIEpFR2JrwvglL7v/+f7SEH6IwkvvyyVI6S6EZKACitPGRV/w
	 0JyzETJGRhTChf9UG4bwrAFl0aDd/9zXsWGqwQJSAUZuU8AWv/pBoXpLok1etI175K
	 7WCMmW5Uu6tdzWKdD8w80Y2JaeG3zfvoy2E7X54IE5ZjI9mN/jaWjv+MRGPrfPqMGH
	 oQrz+DBapbpNuaKmZW4nfKMOOicrtumCD1NiHRuwpOYX4e9XUVJdRc0xONn4ZXVepD
	 5goEpRN9ETtIg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 55/59] xfs: validate buffer item regions during recovery
Date: Tue, 17 Nov 2026 10:15:12 +1100
Message-ID: <20261116231707.3625263-56-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
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

Validate each region of a buffer log item as it is decoded from the journal.
The format header must hold a dirty bitmap that fits within the region, and each
dirty range region must cover whole chunks of the buffer.

The fixed prefix of the format header is checked through min_hdr_len, so the
region check only has to bound the used part of the dirty bitmap against the
region.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 3742099de2eb..8fb419aba094 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1227,9 +1227,55 @@ xlog_recover_buf_nregions(
 	return nregions;
 }
 
+/*
+ * Region 0 is the format header. The fixed prefix is already checked by
+ * min_hdr_len, so check that the used part of the dirty bitmap does not exceed
+ * the bitmap and fits within the region. Later regions are the dirty ranges of
+ * the buffer, each covering whole chunks of it. The region length has already
+ * been bounds checked against XLOG_MAX_REGION_SIZE during assembly, so only the
+ * lower bound and chunk alignment are checked here.
+ */
+static int
+xlog_recover_buf_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	size_t				len = item->ri_buf[region_index].iov_len;
+
+	if (region_index == 0) {
+		struct xfs_buf_log_format *blf = item->ri_buf[0].iov_base;
+
+		if (blf->blf_map_size > XFS_BLF_DATAMAP_SIZE) {
+			xfs_warn(log->l_mp,
+				"BUF: bad dirty bitmap size %u recovered.",
+				blf->blf_map_size);
+			return -EFSCORRUPTED;
+		}
+		if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
+			xfs_warn(log->l_mp,
+				"BUF: bad format region length %zu recovered.",
+				len);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
+	if (len == 0 || (len % XFS_BLF_CHUNK)) {
+		xfs_warn(log->l_mp,
+			"BUF: bad region %d length %zu recovered.",
+			region_index, len);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.item_type		= XFS_LI_BUF,
+	.min_hdr_len		= offsetof(struct xfs_buf_log_format, blf_data_map),
 	.validate_nregions	= xlog_recover_buf_nregions,
+	.validate_region	= xlog_recover_buf_validate_region,
 	.reorder		= xlog_recover_buf_reorder,
 	.ra_pass2		= xlog_recover_buf_ra_pass2,
 	.commit_pass1		= xlog_recover_buf_commit_pass1,
-- 
2.55.0

