Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782783;
	b=lNDQvcIvFJWTinF8pei0Eo1XPwgDTz2sdLkfK/2e+joO/03XKs8sdHRe6cODbpiW8b1v
	 v9ufmOD3CyrnLaATVt+VCyykdFPYFX7yq6VdNnXS/QRuS3iEWVzZWLR810FscDwSdwjmD
	 uKm2Aab9Qt/JPOHpYxnkXsNhBoRNIIiHPY6PpWHJEoaYG3T656BelpvfPDLBNLyVXLtV6
	 ldSwcvlBdsIRmDNdgtWMF0KRFBMLEz2xyWNf0vX2lMRAd0WvWj5Bdpj7NpWBRTYKJ8RLD
	 1EwEnhhfBOXs66JqmucxYJqSDNWgPnRE/4Df7xkA4p7MteYTnUL7KxXX+ger/iVQrcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782783;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=7cfCkUzPD9T3QchB6R7FTN2TL6jI1u9mcAOxdVYVoXw=;
	b=WVKEv7uVkrHVc7lqmu5E104Znr9JJrmdxecoreKB13ZgLoCEcPypONoTlIhZgWCehuny
	 cTPSKfKCl4REMdKA+zlix+kxahT976AUrrU2zKgGkfTFqicGq25vCct9XLUvXBq+CG4ji
	 mn2hdDFx+1pmJYmb0hPmxFMiJg7AoTxJiAvaYB1Wiuq17UlGJSfwca3pp6ZCREfr/IhhS
	 NlYLaLxJ1rbAYPk8tooFEaQKWcYIsoVIIAS68ijcgr8qMj5EorpDOP0ME9l1eUYKykhw0
	 xUjPI5Im5293BUmxf/hqvIM7ct/vbbCDiSKejkv2WbEHwmXtdY+8f/v93+GHyVM1qSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=m6CkH8nA;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCB8606A32F;
	Wed,  4 Nov 2026 08:59:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCCB8606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=m6CkH8nA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7cfCkUzPD9T3QchB6R7FTN2TL6jI1u9mcAOxdVYVoXw=; b=m6CkH8nA0MF033YMTdHT5cfwJF
	QBEfTrspQUOdR0M9DNBtCimv1YcHzc6o6L4ibT9rwatA5tenZOaw7YbsspropFJKGrtb6kOmGGyas
	9U0P0j/UvrjI5qWO0Aqa5zU58DPzO9HtZ6acju+4OXSHxE2Mt8FklzcHs9PdgZFVKlWuXOAYlvRMH
	Pzh17icivOQqY87AB4PyqdwY8YBxSJP/qJbVuQGavuwFdoTljdIfshVctSht6jruavHbGjyJ5zgbU
	yJKH0XbIE52ka97vaGo4S/NqkkQMn+WB7sovFGTjNDnhsRjnB3ACHMCYc6tNWugkJZAua/jj8ZO37
	ZVEVADLw==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqM-00000004oKI-02WO;
	Wed, 04 Nov 2026 08:59:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Wilfred Mallawa <wilfred.opensource@gmail.com>
Subject: [PATCH 03/25] xfs: always call xfs_update_stable_writes in xfs_ioctl_setattr_xflags
Date: Wed,  4 Nov 2026 09:57:07 +0100
Message-ID: <20261104085929.317544-4-hch@lst.de>
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

Currently xfs_update_stable_writes() is never called when the RT flag is
flipped because xfs_ioctl_setattr_xflags() updates ip->i_diflags before
comparing the rtflag variable to XFS_IS_REALTIME_INODE(ip), and thus
the stable flag can be set incorretly when flipping the realtime bit
on an existing file.

Fix this by unconditionally calling xfs_update_stable_writes for regular
files.

Fixes: d528a6c1d4b6 ("xfs: data checksums require stable writes")
Reported-by: Wilfred Mallawa <wilfred.opensource@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f81b6e52ac40..36ba609a2593 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -595,7 +595,7 @@ xfs_ioctl_setattr_xflags(
 	 * Make the stable writes flag match that of the device the inode
 	 * resides on when flipping the RT flag.
 	 */
-	if (rtflag != XFS_IS_REALTIME_INODE(ip) && S_ISREG(VFS_I(ip)->i_mode))
+	if (S_ISREG(VFS_I(ip)->i_mode))
 		xfs_update_stable_writes(ip);
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-- 
2.53.0

