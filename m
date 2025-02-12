Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E6F13C9B3
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 08:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739348245; cv=none; b=DK14VALxEggih5GkeJPCi2WANaX72UnjXVsW66jbFSPbbQBS2T8Rn7PG1wjTw++Yrl5N1vjC316PsSqAsuhgyOO9mp+mUBIuLVAycMsvSuaRu+VPjQJe+egRuusTGPb2AXYCn5mE5QePSbGgKt0StdzrQFKQAgh44R0pKLiAGWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739348245; c=relaxed/simple;
	bh=9Ajt+F3BAWaHerxMDeQTh/SHVxBxatCvYCb6eBCGFn4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hILFgMzLaQw+/K65yWa4PYMRfidZtTjMUr399NkTPwQb6sLp7UzxFrQb4TC7quZ+Nim4SEtIhSkRa6rjGUaWcPuyMp59g9CPOh3luJ8lvyPj8ByPE/uRkh7zuI9fWQ/NJ1Nv+EO+Z//OPSFhsA8S/LYHMQiWwoGmO621kSbE+oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=UHUWZyCi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=zj33Cmmj; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="UHUWZyCi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="zj33Cmmj"
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 4A8FB13809C6
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 03:17:18 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Wed, 12 Feb 2025 03:17:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1739348238; x=1739434638; bh=VrKsbHMZABL83IKzrvn7H
	W1GAe3Gd8Ij46KZdpDTg0Y=; b=UHUWZyCieYvTTc4t+L2C6nKbeV2UmYyWJYLpT
	4tHzbqTuHlnYOb8+VBYxmd0UGPw0kxSo2ue4RNe3k1dC4toPkuWcD2XxaeunxqHN
	Ka9R9WjrbD8Pw7hBme+KRVD7FQOBgozjA5XobcihOlqG4jWKO0GlNyyKTR3/s27Y
	oZ3/5/qTFu9ABq7+qOaJ9JzpH14Q6pPfrF4MeSNC4DXNGVFO18K4cco0aDBGNFP9
	ncjZ2mnzlYEG9OoRVm8EK324XtqLSwZETPVsQykWUMWcZfdJwHwOG9a8HVavBc2V
	Ar0LiL9dBvqMafHaRywyyqGfUoHV/dnREna+leViIyEWcqOWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1739348238; x=1739434638; bh=VrKsbHMZABL83IKzrvn7HW1GAe3Gd8Ij46K
	ZdpDTg0Y=; b=zj33CmmjBSlvRashYEQ15Ph9RX5sk9OujdhJt+mgRmQ2Oxzpa5P
	44VP7OdN6zgEScE0oAVWWrBIpsUBKtxwtxwajskQAIPGsiZ3sYVR0KfmDluSUF08
	+vnOEBxGLJjpCo9UL1AY1rmVY3r9t66iJxgWIK68RXsW/ysmlXgtzuvQQc2NhHKW
	Jj6utmfjUUKXHAM/u64mCcgkj2aXIKfBgEi7AoRBZ6m8q19KDNr+1nwQVe+KmZGI
	QsWKTuPhOrt6OKuf97cStZ8fDMokJ1tDDcdj+M8m1BdnEciuTo9aJbbpCzIBuC1P
	z+wFGDuJ/iB0eN9ND3X36df+fQyNixXTDCw==
X-ME-Sender: <xms:DVmsZ0rCSBDOnippjd65rQeAfOfF9mTXYLFbMLGgydLrhvpzlW5rAQ>
    <xme:DVmsZ6pRt91aJi_ICRzhOi8CdOcCHodDUiIF_srwK56JTIif59ar_gUcz0zdvfjue
    bSswSzQRu3ukqkJSA>
X-ME-Received: <xmr:DVmsZ5PZhMYNOZsDf28ng3FJVGTMQTM3Uak5vsrUXs3_ltU1YOooIo5wHEkaBPckOI4HpSURwAQ3sKE0cfG0r9z3nAM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdegfeefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhephffvuf
    ffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhi
    segrlhihshhsrgdrihhsqeenucggtffrrghtthgvrhhnpeeihefhveevheelhffhgfehtd
    dtueeufeevveegffdvleefteegtedtkeefteekveenucffohhmrghinhepfhgvughorhgr
    phhrohhjvggtthdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepuddpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:DVmsZ74hcjRZxZC44OQQt-IhRWhyPFueCe17OMj2Cy5xLgghDE_cVA>
    <xmx:DVmsZz7WVPqASaqmj_spxdBj-BC-bk_o6eBlDcVH0K8xvkPPrUG88w>
    <xmx:DVmsZ7iIqZTSec5qJS2gMA_Gv8hfm1hIR8Z8fq7_D2rdP5K7PTQ4Uw>
    <xmx:DVmsZ94XQqmiWoSf17pQ0P5pGKaDkcUg7XxfjKaZQdWHF_107bmlRw>
    <xmx:DlmsZ9RmeKMG-_gvG4CBaAV322hjvNg--gdfxyIgV2Oacd96lNvABgvw>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 03:17:17 -0500 (EST)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id 95F9F4B9908F; Wed, 12 Feb 2025 09:17:15 +0100 (CET)
From: Alyssa Ross <hi@alyssa.is>
To: linux-xfs@vger.kernel.org
Subject: [PATCH xfsprogs] configure: additionally get icu-uc from pkg-config
Date: Wed, 12 Feb 2025 09:16:49 +0100
Message-ID: <20250212081649.3502717-1-hi@alyssa.is>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This fixes the following build error with icu 76, also seen by
Fedora[1]:

	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: unicrash.o: undefined reference to symbol 'uiter_setString_76'
	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: /nix/store/jbnm36wq89c7iws6xx6xvv75h0drv48x-icu4c-76.1/lib/libicuuc.so.76: error adding symbols: DSO missing from command line
	collect2: error: ld returned 1 exit status
	make[2]: *** [../include/buildrules:65: xfs_scrub] Error 1
	make[1]: *** [include/buildrules:35: scrub] Error 2

Link: https://src.fedoraproject.org/rpms/xfsprogs/c/624b0fdf7b2a31c1a34787b04e791eee47c97340 [1]
Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
 m4/package_icu.m4 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/m4/package_icu.m4 b/m4/package_icu.m4
index 3ccbe0cc..6b89c874 100644
--- a/m4/package_icu.m4
+++ b/m4/package_icu.m4
@@ -1,5 +1,5 @@
 AC_DEFUN([AC_HAVE_LIBICU],
-  [ PKG_CHECK_MODULES([libicu], [icu-i18n], [have_libicu=yes], [have_libicu=no])
+  [ PKG_CHECK_MODULES([libicu], [icu-i18n icu-uc], [have_libicu=yes], [have_libicu=no])
     AC_SUBST(have_libicu)
     AC_SUBST(libicu_CFLAGS)
     AC_SUBST(libicu_LIBS)

base-commit: 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
-- 
2.47.0

