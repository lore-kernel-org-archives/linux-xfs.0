Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B1251791
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080547; cv=none; b=S7o8YisxtzFu9eL4hKXA3SfwdlwiU/2dB/TyGM+9/Ms0KpjAwT1pyeLHGcZLsFdaZjCbTWaKFLbwI97kvKzAxH6zeGa+v/4cxhC5IcqsXGxt+BbRD9i4U54SSspBjnPNONM0S6onHhsjweXEoto8sNRYNpn0JerLV1Lr/sdf96s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080547; c=relaxed/simple;
	bh=daUCiebCEPQWJFbe80BkK3BtfAQlnSwgJx+O+cMe3jk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cyzOihuPitVoPVucBkmMPkMYFII8EmZ2ZT+LMJnm1iSMsQVTZ78B8B2atQ9hjgkKORg2cdjDCCmXhZoeH1tcjPTQ+yVH8fYUlq+v+X02pq7K9YG2hPeIScd4LfGDmh+NlrW+Ko3wIWKviRD791++81XWWPp3XuUyu3GMhrNYC5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3tZ+xnr; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3tZ+xnr"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-3e8317b1262so6149265fac.3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 06:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764080544; x=1764685344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tvWOvEnU2dU5AH14rsTbKh6RrjkJwSFx3eCMO6FIfJE=;
        b=b3tZ+xnr4EOqRxaVH/63DCSgA2HaTG8qSmhLcCPwwE1RSFQD4+KMd7o/uDrtiZO8az
         oPPO3Bw4tUlntG9hr3wMADJ4o3s54rclV87UkPdntPHVUzPVsKkyMNK9gH4AD/alMXDu
         QZlZxcRpCWRoPqckstg5VslbqLTd+Sdm6lk/w1X+6z3sRVu9xGs7exZf1ZP3hgopNmiY
         rgwiYsOtkl4WigtTwBoZsK3uX90uiuXuoMjYtMdKgKDDDaQMLIuflMuoOBu42fltFZyh
         2WOWHwGKw2soKFebU5cYRwqLnRVnlviFNyLpWSQftTHty6PhGhNj1K81GoI9t8THJTOV
         g8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764080544; x=1764685344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvWOvEnU2dU5AH14rsTbKh6RrjkJwSFx3eCMO6FIfJE=;
        b=CaEvKA8GWZo352IOQekg6SnIm0yfZabR7KjA29/GWtWBCaJwzSLbJWtLlLQEbqc0N+
         5OwCe0UawT3u3+OnQmkgF0bCFR5hQ6SDTdc9O8l+bOFmwH2UTwxF+Lafof1t1vykGsUZ
         sgZ4mwinHm7Ptba/fSN0QI3lwhGt24B4dJne1R1BG3r28WvzpLaVk61/6kYOd2TBvpi8
         yS0aI0/HyRmkbIISvbUJgKIQm2f7NXbLvlg0Pqv1L3O1tsCbjm1qX/nxjYkItrEbNr2K
         QgC6AKjrA4slJQz1Lmm4MxIVECHvvg/tvAXXId78PMw8DION1zrT9Oi+X87YDY4vzyAp
         uQ1w==
X-Gm-Message-State: AOJu0YwW2Jq54MwV8xQE8Zv1fIhH6dgMqyRAniQMb8Ep3vNi1wv0MzKZ
	Pkcxocq1cvEzwBA5cLvGGBIBchUdpdllF0Algop16n9Rr/t0PBdhY1V7
X-Gm-Gg: ASbGncvseC6JGAUFVZlaVB4HROTgCIvl5iBMhTS23/ZcBkN00wUP4sALlw4UWZuJn++
	A7jLR/WtiT2g0I0F1kCHD76t6A2qATQMdCmkERLwueSDii9jzoF7PKqajOhQMC/A9wK9cJoxEeE
	xc9s6T7VRgcmF7l8UtdpRXkLAar/G1VUPvoXNFsBVgaRUlNeYVX+lmDQneIpl8+1yVY1UZMCPix
	CecitzyHBfC/G9VRy5UN/zb5r/Infx1rLxBpjPM4YJsdMr7XIELp6lqjoX7eDdDq482iaL554Xu
	lSLsyCImzbm+TcebdHAdtCCx8zdK4d0hpCGUQbV0TyhUH2i8B71cHNUMqqKf9L4feAO1wphjyrr
	p4/8wLwNJ8nLak6kTEJUgYy3V8HWtkKmdgxSbTBHUqSRqo6S+fLQSJKPZcjhHl+XJrlwDs7J7h7
	FWzHdabfWmNBZ4f9MAoAAOTn7nHf0ORnINFnw=
X-Google-Smtp-Source: AGHT+IE6Xs1Xpf6XId4xD7sEDS2X5CNlNmdI1ekbRiuXldRQB++Z2Tt04ivVsaUxjWHs3W4SNWqraw==
X-Received: by 2002:a05:6871:b11:b0:3ec:4657:83f3 with SMTP id 586e51a60fabf-3ecbe30a2a1mr7029109fac.14.1764080544552;
        Tue, 25 Nov 2025 06:22:24 -0800 (PST)
Received: from SyzRHEL1.fyre.ibm.com ([170.225.223.18])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ec9dc21d94sm7624845fac.11.2025.11.25.06.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 06:22:24 -0800 (PST)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] xfs : Fix potential null pointer dereference in xfs_exchmaps_dir_to_sf()
Date: Tue, 25 Nov 2025 06:22:05 -0800
Message-ID: <20251125142205.432890-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_dir3_block_read() can return a NULL buffer with no error, but
xfs_exchmaps_dir_to_sf() dereferences bp without checking it.
Fix this by adding a check for NULL and returning -EFSCORRUPTED if bp is
missing, since block-format directories must have a valid data block.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 fs/xfs/libxfs/xfs_exchmaps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 932ee4619e9e..e33a401d9766 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -475,6 +475,9 @@ xfs_exchmaps_dir_to_sf(
 	if (error)
 		return error;
 
+	if (!bp)
+		return -EFSCORRUPTED;
+
 	size = xfs_dir2_block_sfsize(xmi->xmi_ip2, bp->b_addr, &sfh);
 	if (size > xfs_inode_data_fork_size(xmi->xmi_ip2))
 		return 0;
-- 
2.47.3

