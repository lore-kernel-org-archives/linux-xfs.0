Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A563C23CB
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 22:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716415633; cv=none; b=naEfAL49dFIj35qcEP1mEqSghNX7kaEx0KnCZtPsuOnqaNW6izP/cOnsdjsQ2x0l3w07qdZI3+1JzI12U69C1PXqrj0Tr2CtqgIV9hDewBlXVLptEzxPQ9tfya3W3R64kdPiWW34i1R0X4aww0IpTMq1B0VwGz5UP+mVpBnDcVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716415633; c=relaxed/simple;
	bh=cpuYBKetD4bm4gM5AO4ekLzs65pk2y0cR6VPmqe+Wvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=brdJlYFDxOJhxYRdMaUAT/+F1KNdebraH6D3jZ0ovZTrRxsmGK/pWU99OWCdJBysl32UBPCy8P7Z92YS1k6fZrkJHVGtC4HHa+Tdx+q5lWC8k6FGlQl44MmGfI43RFtSnGkU/GREk/MPgE87tqwHvmz0D3EEeYz/GaWugsTMJHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=bGIBeVJp; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="bGIBeVJp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PQ6FBP7eH9B5lM1VEXqAucj+VRtXhU+QkgMegxRClFw=; b=bGIBeVJpm0NqAGdEvwOu9e3nif
	6WlLv7v2Yjm4nDFYXKz0QU4L0aPficXpUO2t9QOdCK4nsVcAiUMos3kfTUUiagLCL8CarB22+/3Yr
	GRu69ShmYcS2dvDZpsWMOctPnakGmCVtPvWlhJ7zglKH+1729sxtXE7NarwS836MUStEsZMBc43+R
	DQxSdYYHbdYEkHIHTP23t/Lo1QTGBWtijqnpkxBzmSYp+Ie6YAe5Fc/wy1/wyI3li+e6Bu6yDP8CC
	a9+VocUlVOl3yZtvTQytvfjwgm4uvYYs8chyjR3FeRZ6Z+dm1z+K6SJN9/pAahSP70aBtWFSXZGQx
	0+HS5LOw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1s9u6y-00EBp9-0t; Wed, 22 May 2024 22:07:04 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH] xfs_io: make MADV_SOFT_OFFLINE conditional
Date: Thu, 23 May 2024 00:06:56 +0200
Message-ID: <20240522220656.8460-1-bage@debian.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

mips64el does not have the symbol MADV_SOFT_OFFLINE, so wrap it in an
ifdef.

Signed-off-by: Bastian Germann <bage@debian.org>
---
 io/madvise.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io/madvise.c b/io/madvise.c
index ede23395..1d664f8d 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -101,9 +101,11 @@ madvise_f(
 		case 'M':	/* disable merging */
 			advise = MADV_UNMERGEABLE;
 			break;
+#ifdef MADV_SOFT_OFFLINE
 		case 'o':	/* offline */
 			advise = MADV_SOFT_OFFLINE;
 			break;
+#endif
 		case 'p':	/* punch hole */
 			advise = MADV_REMOVE;
 			break;
-- 
2.45.0

