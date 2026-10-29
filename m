Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290241;
	b=mS4PpKJfC6YLmXAcFz2htZEH5bo9RYuXkQtouN2zpsqXHdLUFPP7vGOAHOg95tVYiCz0
	 tLZHI2cacA8V247AXFmMLcabLaMrkjNms0saaLC+sfw10CD18WKsVDxh5CPKXiTksOhfC
	 iRLFR43c4i+OVEt9ynNMfTQsfSFA4D9vU8c6XWCgPfRWFnX4zuKA06WIMiAJpIUU1r9mf
	 XTpkFgX68bmEg4tOmVnSY9Wfr8UHMg03cTGIZMyScejp+2h0F1Zcjtmf7L1xapYxnMeIJ
	 C/RDQPNi30+gpCZvmExRkVzC90D+HkpN10gly4kIygTHJ3Dh/NTQr6do+SMiusGvt/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=sKmHnUARw5TDn8gbaRklrLHNyiWOz1HX1b95BzcilwY=;
	b=rf+vnnCRFQosBl3B2j2mJj6VS9SWpVVXUd7jLvBUVeJ7kvi4MPFWVCG+AHqYwGVepVkq
	 P92+DnHOLURPyBeXYCurNVCMHm9ACE8lWgoC9oOjpE6SM61bQ9/NW3hGMYXQ9r75nj515
	 6dLoggvHADQZVkb5GQ2qBl6LdXhmhwJUJh/K8G+J+i6Z+0Sa5yr0WVPpTZ+5LG5nEvma1
	 RajeEBCxSELnbi+vXYk9JO6NMmlwz/wGgDGjn0BctLe1dSdaAF7HhyONbFKd3dqB36uVX
	 OuoS8ZPXIkvV/DvPdNEdMg6R8I234MsWyYwm4EeInFKzcSD6zaiaGrXuwN8C16hB2zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l/CXEaqw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63098606A327
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l/CXEaqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A871F01824;
	Thu, 29 Oct 2026 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290241;
	bh=sKmHnUARw5TDn8gbaRklrLHNyiWOz1HX1b95BzcilwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/CXEaqwKAiPO8HoifRDuuQi6lnaExEUTikM6/pMQKGZw29fHazUx/ClYm/1Dg/PR
	 ylWdg9QyFCtaU0dL4rIKtY604dS2+yZyecYN/N8flV4ExWhV9jFnjDnQp+iO7EMCiY
	 jKcj2hD/pjKG7JHnxKvXWebRDqzHPTSiscm3BXN53MnSIumOXtSTMjf9Q/NQiohOOL
	 3dL/f+bdkHjNN1DoHyMxjMN9ROUQqpJZl5/63YttNATe7/pRRcHxYfDiOHF+8veBeI
	 XEdo+2r9Z8dF1AcaNiGevvyRbnXxfxzMNuq0x4bqn3Fpx3Gb69UpVbtv8Qbq1gp6lP
	 RpHZWkIRckYeg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de
Subject: [PATCH 1/2] xfs: fix two warnings in xfs_alloc.c
Date: Thu, 29 Oct 2026 17:10:22 +0100
Message-ID: <20261029161027.1213438-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029161027.1213438-1-aalbersh@kernel.org>
References: <20261029161027.1213438-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There's still two warnings in xfs_alloc due to unused alloc_flags var.

xfs_alloc.c: In function ‘xfs_alloc_ag_vextent_near’:
xfs_alloc.c:1676:33: error: parameter ‘alloc_flags’ set but not used [-Werror=unused-but-set-parameter=]
 1676 |         uint32_t                alloc_flags)
      |         ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
xfs_alloc.c: In function ‘xfs_alloc_ag_vextent_size’:
xfs_alloc.c:1792:33: error: parameter ‘alloc_flags’ set but not used [-Werror=unused-but-set-parameter=]
 1792 |         uint32_t                alloc_flags)
      |         ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/stubs/xfs_extent_busy.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libxfs/stubs/xfs_extent_busy.h b/libxfs/stubs/xfs_extent_busy.h
index e7d1bcdb2fab..2ef307f0f901 100644
--- a/libxfs/stubs/xfs_extent_busy.h
+++ b/libxfs/stubs/xfs_extent_busy.h
@@ -15,6 +15,9 @@
 	*(busy_gen) = __foo;					\
 	false;							\
 })
-#define xfs_extent_busy_flush(tp,pag,busy_gen,alloc_flags)	((int)(0))
+#define xfs_extent_busy_flush(tp,pag,busy_gen,alloc_flags)	({	\
+	(void)alloc_flags;						\
+	(int)(0);							\
+})
 
 #endif /* __XFS_EXTENT_BUSY_H__ */
-- 
2.54.0

