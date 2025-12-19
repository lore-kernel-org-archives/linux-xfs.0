Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FCB23ABA1
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766135823; cv=none; b=Ybd57JLIIlzs99IvO2LsmH/EFAJ1c1ucl0pOvwdDWcaR+SscTQAbg9Y3fllZ73Xaa8jIgwE0tFTQsv1ZSnl27MUI4eB+erC/a7KkC3s1tGbQ72W3nVQtMqs/ab8mafe1nZrx+l3oMIYRb65w8exG1j8DrHshap4ZSfk945WLeVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766135823; c=relaxed/simple;
	bh=+hv4twYuy3JjmcpR8sNktuCkRnKr4VZXDDU9GtPFxWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxLFUrbMQxI5QZlK6nsAbjOlwSKS1fWUt/cpaIgNNE6mtJoR9/A4xEp75aq8VrWzKTwxhdkbZ7onLLI3b8FxmH6S1x8fXlOroyYU2VMKwCGLz82OQh6GXwQWHFLgihwHwRvPFTeFYowjdhLFkaZcqDunYtjEpKbH0KTiGtPxM5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slWltDXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slWltDXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2DDC116B1;
	Fri, 19 Dec 2025 09:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766135823;
	bh=+hv4twYuy3JjmcpR8sNktuCkRnKr4VZXDDU9GtPFxWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slWltDXT9vJ8moBVPOhbbH54eUew8OjzINcmo8uW+i23AF7kRth2pfespsbSkgeSG
	 X20Js2PKbHF/72f6PZm6KLwPsRFAtzEqmRJN7HaxfxwyuFS6HmDH3Yj8GDKKcZ6p6l
	 V3dARRPNBG824cM29/AXjKFonmvFofdJasxm12sS/9D7J62XftJSRHiwpmcFomsXSq
	 GhnddgISyAEK6uP6CgGYaFt43Hs+Vl1DkBNVhr5oYu1n7I4PqJ9offn2pAvCV2jJ72
	 kRcRyxtMl6yEfRtMCOlX7Yxqbqff2BEn+leUQbPJ39blJGE/wG17wvmvJf3BO2GVqe
	 r3k7KvQA2TA3g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 3/3] repair: use cached report zone
Date: Fri, 19 Dec 2025 18:12:32 +0900
Message-ID: <20251219091232.529097-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219091232.529097-1-dlemoal@kernel.org>
References: <20251219091232.529097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use BLKREPORTZONEV2 ioctl with the BLK_ZONE_REP_CACHED flag set to
speed up zone reports. If this fails, fallback to the legacy
BLKREPORTZONE ioctl() which is slower as it uses the device to get the
zone report.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/zoned.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/repair/zoned.c b/repair/zoned.c
index 206b0158f95f..84018a104208 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -82,8 +82,13 @@ check_zones(
 		memset(rep, 0, rep_size);
 		rep->sector = sector;
 		rep->nr_zones = ZONES_PER_IOCTL;
+		rep->flags = BLK_ZONE_REP_CACHED;
 
-		ret = ioctl(fd, BLKREPORTZONE, rep);
+		ret = ioctl(fd, BLKREPORTZONEV2, rep);
+		if (ret == -ENOTTY) {
+			rep->flags = 0;
+			ret = ioctl(fd, BLKREPORTZONE, rep);
+		}
 		if (ret) {
 			do_error(_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
 			goto out_free;
-- 
2.52.0

