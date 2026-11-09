Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.189.121.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794232157;
	b=3Kl0yiTuuUgjWC+9ud2+kB9s2LD+gsUjgDxesY5j/f2yAG7id9fFYtBNfrQk+UEb94kT
	 72eahuw0oJ7kOrVgg8Zwa7U6A+oCfToaDCcTXLNKPdsrwJvEy2eThZ9AKi4lMx9DR3rak
	 SicxIVhlgzuitJMIZIQmCMStRnULM3Pjl8nbfB6KlETk7tjgXdTHd4qeNFhc1gTOLJ/C7
	 uKbX01b3fxcnL/w9AxAokhpUlQMcDEIPVIfBhyp5TFWiwA1Jwd/rQmS0/xmuC3qSYPQl1
	 Ofr+LhJ2dGCLUIddmuBoAkiVvAlk38ukflZFBbIzRBk+V21MZnbWfAcvb+2mTRWyXNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232157;
	h=DMARC-Filter:From:DKIM-Signature:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zja7nkC4VCZSngBpNouwJI6TPoHjvzzS666hsc/vKXs=;
	b=VngmkTtXKVCM6Pi8+FtgJMQl6Sbrmuu5oU98QJ9TpcwnUvMH4TU9Oc8gWspR6WNam5fB
	 ibJ/XnH4lwgCD8j8vKeMtV6Akm3EbFvkOq09ffeOE0f0aZMq85Vv+BkbQcL5wPk8xRpq0
	 rAA+VupnyGQcufUEjan2ivN6jWzO7LfGdsEocOTlHHlglLQKOpiJGclrDMmVlLmh/oP/T
	 IiBVVe1ClK4TmLR6HppCY3kiH1iaQVQ7J4YgrMdWWxc6p/RnqZGZ3ZDwPAkYWUeQHfzL2
	 v2iI2CKaLFnC/H655jqNSxXHCY1QccCWJvrYOdZmBSwXKPxT2KyGX7rtAj6LpzdLU8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=itx.no;
	spf=pass smtp.mailfrom=itx.no;
	dkim=pass header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=hj4tJ544;
	arc=none smtp.remote-ip=91.189.121.228
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADE0606A326;
	Mon,  9 Nov 2026 13:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ADE0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=hj4tJ544
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1794232147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zja7nkC4VCZSngBpNouwJI6TPoHjvzzS666hsc/vKXs=;
	b=hj4tJ544nH+cQdmt8XABvedyhguiBTHCNlsJWdldnLa4yELVj+TmS69+iFxD4tXAJcDNeh
	KdiPPKZQ7UY4mUF7qBfkaIwwmx8wVqHUmyipZjO2H6OkkyN+n3npABX2q3NDrt5N6v+L+y
	R3dgLSB8I8Pj9y5CWcWpIwH2dvdtBmg=
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	sparclinux@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	Jan Engelhardt <jengelh@inai.de>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: read rmapbt high key offsets with get_unaligned() in scrub
Date: Mon,  9 Nov 2026 14:48:53 +0100
Message-ID: <20261109134853.1659991-1-stian@itx.no>
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

An rmapbt node stores each key as a low/high pair of packed 20-byte
struct xfs_rmap_key, so every high key is only 4-byte aligned.
union xfs_btree_key is 8-byte aligned, which lets the compiler read
rm_offset through it with an 8-byte load.  On sparc64 every high key
checked by xchk_rmapbt_check_unwritten_in_keyflags() then takes an
unaligned access trap:

  Kernel unaligned access at TPC[105a54d8] xchk_rmapbt_check_unwritten_in_keyflags+0xb8/0x160 [xfs]

Use get_unaligned() for the high key.

Fixes: 38384569a2a8 ("xfs: detect unwritten bit set in rmapbt node block keys")
Reported-by: Jan Engelhardt <jengelh@inai.de>
Closes: https://github.com/sparclinux/issues/issues/115
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Stian Halseth <stian@itx.no>
---
Tested on sparc64 (T4, 7.3.3) by scrubbing the rmapbt of a loop-mounted
image: alignment faults per scrub went from about 4000 to 0.

 fs/xfs/scrub/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 68e2847c962bb..d0578800f3e41 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -174,7 +174,7 @@ xchk_rmapbt_check_unwritten_in_keyflags(
 			}
 
 			hkey = xfs_btree_high_key_addr(cur, ptr, keyblock);
-			if (hkey->rmap.rm_offset & badflag) {
+			if (get_unaligned(&hkey->rmap.rm_offset) & badflag) {
 				xchk_btree_set_preen(sc, cur, level);
 				break;
 			}
-- 
2.43.0

