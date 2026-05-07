Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBFF1B78F3
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 05:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778131549; cv=none; b=YEiVA2tV6KthBgl2Cw1e5TLZaWeNmZ8EKjM8Atcbv2pY/kLC6gVXJzkeOXzBfQOwWaB8g9b8IPzFIvShky0EXramlrTC6XPVB79RQ5GR63TCXjfvjOOfOnbquCASEM3zhigWDJlb3SEmRJhhUkueAAaktW+K1BmM2MmYRKE93Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778131549; c=relaxed/simple;
	bh=qf80QcBZOA5AdFlnGYKtUqM8nBSRKlGVG4Uza5UCRgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S4luL0KSyMwOmjJi1obxsMO8zED+z16k53hEuo0vBi8amRo4zz66Tr+WiuY9K20X9ScgE5tXHXwh4tVPDaxOsbL0pvCt5YutgtWjAEYR8S23VyUwGu/uYH4rWtfNCAE7YLOqjvKqXQdaPZEEk0uxsjpmXxwGvY5MKPoQzhpfkYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kxVhojDN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kxVhojDN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=AKkqhtsxvoaGS+PNGpnYTxQQ4oNHiT+mx4cUEGwdeSE=; b=kxVhojDNGzV2NftDmhpjiZhVbG
	5LtcwsPtregE4yk+TygE06/pFLajqG7+vxO1ZkywfChW2m6O/wZLR1ZrRJJ7fzyaWNWdb9Jbz3hAv
	PT3MmgEEm3fF9I0Wq3Hp1hoTTkoJ1/LIExGdRIFy+TMjV7j4G9Ie90wvJpYyqJNQrUF49n0+Me7lQ
	AwBnlTyiiPQh+p04NCKfDciYCxRrC/orlrYvA18FDm06D7rzQ3bdmWCllGbqreKRxbQKOOSffsnh/
	HrPF9rWCv2XWmA52b5P8fbQV1MGPMHSbNjEMvvNP98A8Bdtu73ViKCjwlGAghyk2LyfAybk4yOjyV
	j7w32MGA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKrF4-00000002noI-1l6F;
	Thu, 07 May 2026 05:25:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: improve RT geometry validation
Date: Thu,  7 May 2026 07:25:35 +0200
Message-ID: <20260507052543.1305129-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Make sure the rtgcount is plausible for the given RT group size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 47322adb7690..c0354f43704f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -302,17 +302,25 @@ xfs_validate_rt_geometry(
 		return false;
 
 	if (xfs_sb_is_v5(sbp) &&
-	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
+		uint64_t		nr_rgs;
 		uint32_t		mod;
 
 		/*
-		 * Zoned RT devices must be aligned to the RT group size,
-		 * because garbage collection assumes that all zones have the
-		 * same size to avoid insane complexity if that weren't the
-		 * case.
+		 * Check that the number of rgcounts is plausible for the RG
+		 * size.
+		 */
+		nr_rgs = div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
+		if (nr_rgs != sbp->sb_rgcount + !!mod)
+			return false;
+
+		/*
+		 * Zoned RT devices must be aligned to the RT group size because
+		 * garbage collection assumes that all zones have the same size
+		 * to avoid insane complexity if that weren't the case.
 		 */
-		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
-		if (mod)
+		if ((sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) &&
+		    mod > 0)
 			return false;
 	}
 
-- 
2.53.0

