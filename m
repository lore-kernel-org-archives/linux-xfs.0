Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43C52773F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 01:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638912; cv=none; b=JaskfPgaY2M2LeYLTnjVmn1/9YpFh0b++0zrimlJkOTXRYr0EPuAERzQv3/vli6MZ/YJIEVnz0Kp3rE7mIK9Yc4rDXifIys4xdxGkP8NMDUddm6K9W/nlUqO9YYhXLssU22VyxhQlayIB8ehNErXwNl1WA1EaiPsHrFaErFVaYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638912; c=relaxed/simple;
	bh=JSFr4qRIUIyCn4+I5jSFX/W+MPsvk4/tKHZHrqEit8E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nLXT9ZHXYw58TUz1/urGLVbTuH5LZ/bqhiTzZ8MsJ6RuAuP+uGCcdagmAEDhep3Bea0BlqTrKju68omLLR3a5W75Dxqs3pk2zT/cIkLlJDwf1j2KoA0NCzhNGT0AvYnXSv7HS9FzhiToFH7C3UUDPqdQPguHweB2qbsHZ1JOmmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqZTxBNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqZTxBNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31935C4CEF1;
	Tue,  2 Dec 2025 01:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764638912;
	bh=JSFr4qRIUIyCn4+I5jSFX/W+MPsvk4/tKHZHrqEit8E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sqZTxBNeCT7W9MrisHyhdefzaL88rfaCafk9/vnGQ+zkWxBnGIxosrGPfqXVS+eff
	 ROsxLg+I2AZ2sJfoX+rPOujUoYLnV3pFE16Fxao1BVTD6NonX5G2IR4dPYIg0+n1be
	 9adjqer3g5C/BwMLHD4dBnROxIyJRAasJZTkViMOZ109wwxwBnkmj1Q1+syg18CTsb
	 13WXLpa+ZBPfag5dahj7/gDVqCoortiVT2ge3mozMVOF/ZENvrXNd53NhRGhF11Xkr
	 3HRejVc4E+vIv4RaNE1sgueXy00ClelHBNxg7pQL1ON40ghZwuOtOu2beXaXFOVX+o
	 QH8fdPc3LjpXw==
Date: Mon, 01 Dec 2025 17:28:31 -0800
Subject: [PATCH 2/2] mkfs: add 2025 LTS config file
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176463876416.839908.4764468097179419750.stgit@frogsfrogsfrogs>
In-Reply-To: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
References: <176463876373.839908.10273510618759502417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new configuration file with the defaults as of 6.18 LTS.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/Makefile      |    3 ++-
 mkfs/lts_6.18.conf |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.18.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 04905bd5101ccb..fb1473324cde7c 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -18,7 +18,8 @@ CFGFILES = \
 	lts_5.15.conf \
 	lts_6.1.conf \
 	lts_6.6.conf \
-	lts_6.12.conf
+	lts_6.12.conf \
+	lts_6.18.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_6.18.conf b/mkfs/lts_6.18.conf
new file mode 100644
index 00000000000000..2dbec51e586fa1
--- /dev/null
+++ b/mkfs/lts_6.18.conf
@@ -0,0 +1,19 @@
+# V5 features that were the mkfs defaults when the upstream Linux 6.18 LTS
+# kernel was released at the end of 2025.
+
+[metadata]
+bigtime=1
+crc=1
+finobt=1
+inobtcount=1
+metadir=0
+reflink=1
+rmapbt=1
+
+[inode]
+sparse=1
+nrext64=1
+exchange=1
+
+[naming]
+parent=1

