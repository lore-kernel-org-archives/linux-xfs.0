Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795768821;
	b=JMpCYnPr9S3BmhcZmhMu1M93M3xNK29D/TtpnmQz+KjE8+bbPacWCmkOgwWPnrDdTPBo
	 vguAa51UB//aLCmt8oiv1v0Cj2k7Ics2FKVnwOaIRh2E2WENcLrHT3EGkRXXEYR5nd1Qg
	 SnzCd1MTBPsGooJJ7+W4/CVTIZCRCVYrCUXi77SokUp+h5eBn3Rg1W+3oY6lqx/zkEWVX
	 3a3THT2CE7L2sMG2HCBaPlmcQlgNHaM7Yobu8O1PbchZa0OST90FUIHU9Ti0BbpTAlpCq
	 ZCcGm5+/jAV8sq0CBsvdiJ/A0bAcYbi7Lf0ise0mrIFp/NQEgoahM8AORgDeIqUy8Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795768821;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=RaXn0nW5iYEOBqaP2byxUSX/NlNAuk/kYgFWwG+1N3Q=;
	b=wCsQp0kHbWgWvx/TvQA3jTMLv5nOgiAAX5Jsv6gScmGT5sP4dS6bTMsaQmbRujmRmBbb
	 x78ItxZ5wD0fFkSOePC+991EdFsvpZsZ3ONUGofRh3sHzLO08JSpStGloPJHh7Asuq8TE
	 vPVt117gR3D5RCuRy+oQde4FavAHxmo9+ar3dHAVsNFbBZlBmLpGUiNHHrLgnn+bbw6JI
	 fKdprgu8c1v4txQcBYcb1MGHtQYIEH+q6ZKgNc90fRfjm8jr28Q2e00AwMXxPgEo7sTSo
	 D2q1DqaJMtj4pXjN16IaVFHR3iL7KDuF1AHB4IP/154aLP+CG8gLGPQYYEPe8QMoERA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="wq4sQCs/";
	arc=none smtp.remote-ip=74.125.227.128
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B090606A321
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 08:40:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B090606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wq4sQCs/
Received: by mail-pj2-f0.google.com with SMTP id 98e67ed59e1d1-3b094d5f1b4so1396162a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 00:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795768821; x=1796373621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RaXn0nW5iYEOBqaP2byxUSX/NlNAuk/kYgFWwG+1N3Q=;
        b=wq4sQCs/NiZDAY+AnQCLyK+EYZjXho0TEAgueQ0YEg65yI8SNAzG7bv1aj8HcwLTRy
         wZQddn+xO6cPgdbzlKeBOO7X5ND16aHIUx4q0+Llc4IOADLOxesC9Q+Wk6YB74uQ0Mgz
         Kr+ZiRLcQe/8Bk1OKY/72j/HyczldS5X7zLjAtnP5Cg7Xdl4Z5XFBBshOLtLJmzGatZ9
         m4DlUYjrI3mgLdihMsLoCOAYR/3HRoTzqQpAFyeUwf17vt48OZN6xNwSSVgmOzUu1TFM
         BINHWDA6YsRYJMzXiJEhffDwdDBbaeBlWpbu82r6i5ShzZ4rP8Xj6JP2Yuu/3fDL5Nw8
         E8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795768821; x=1796373621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RaXn0nW5iYEOBqaP2byxUSX/NlNAuk/kYgFWwG+1N3Q=;
        b=OFDPk+t7RojN7NXSdZgtSU8ldi3ZyUz9NIohhsxQggdROPUN5J0kYsiNpn/oIiFC5N
         eAmLQZPlbC28X1ojU2j/yeYsHh/iDvGfYPiZpEt64a6U9L66CF1GJGBU46VmvEpC2HEZ
         ginkcZIvuUgZNZ5MsclLBvL+Y/c8ygM7KoQcfE1S3lwYS9Iaun6euC/R1fIszTqsIjx+
         JNimhD015IkKK0yiKmvFaTqGpz8yjNYstQCHymBJSezfa5NzsqLD81XUHxso4QLHkpUM
         C7AQlzHMztbW+orUjyg1CGfYO7VlG/qzoMBBLrk9P1KKVa3M3hfe66JypGbuvemLYcJ9
         IO4w==
X-Gm-Message-State: APuU4Z9qdg8Txd+yEXQsDgMr/LIVGAj+w9j2afJBHqKNDXAlUyPBrfsW
	pGteO8dIDuW3ZeZdgQDaBIiHrIcTm/FItvilD6TtPAgbZlammRlHFRYDB3N0nj4U+FySAXu76OM
	=
X-Gm-Gg: AZFdTZcDZIlp7PUaBfQ+vFOEpk9XDLCuvJxI3g1LniUGKRa7uEnsiwjOf95A9ahgbpq
	YNmRurj6EjUs+hzLMTBVni0gR27bfUk6a0vU216oQyuKEg1c3cjKYMRdyZiEXN4lKANMV68EbM/
	o3xHW5ulluhkGMlcD6c/oNfkvG8MjlkzPQfYCViwqrcsgipHYwupVZsX5tbNbWTksBXqJUIok3b
	HF+JRZ5Ewq47/xcW12zCXtc2wqSgQM96yxNJ7If/2Sr1twmO81y7R095Uh2Ts9TJY8a21zXagvi
	ev0cKp9EFnuBaVUOE1wZRxHsi9c/Z/3kqO3sDSLTYsSxJo2DUZ2MzO8HOh5Mmh2wxD0KS4/t6Zu
	4wfVWYQwViFSAfg1Z+MZD3kIouBgZtHRioXxMbX1MjjIYzloD6ZSxiBLPH8sikfC3Q5o5pIzaVh
	Zs3R89y3HT11emThD8qqZ1zkEmSz3JtIojSGINQKMXnvdVaHHi8tOASLjichKVkEOcoIEBWjkFU
	zBwBnuNYaU/3WVdC/MaMwfdvfYk9RwaNPK+RvcId4i//1LAYsgsQoSfXrAaDm6UPQ1al3yPhLtN
	0BXzCRLhAcgvhVawCgSHhDC/+kQgPrYw+Kso0PPtM5XIDJog40jxnWX1ip5J055DaQckFNha17k
	bkkoqj7tXO1M=
X-Received: by 2002:a17:90b:3d92:b0:3ac:7842:bd50 with SMTP id 98e67ed59e1d1-3b41c8dd1a2mr22960427a91.15.1795768820844;
        Fri, 27 Nov 2026 00:40:20 -0800 (PST)
Received: from localhost ([39.144.138.111])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d135e9sm39724097a91.4.2026.11.27.00.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 00:40:20 -0800 (PST)
From: jianyungao89@gmail.com
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	sandeen@redhat.com,
	bfoster@redhat.com,
	ast@kernel.org,
	ishiyama@hpc.is.uec.ac.jp,
	linux-kernel@vger.kernel.org,
	Jianyun Gao <jianyungao89@gmail.com>
Subject: [PATCH] xfs: remove redundant ASSERT in __xfs_bunmapi
Date: Fri, 27 Nov 2026 16:40:16 +0800
Message-Id: <20261127084016.18418-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Jianyun Gao <jianyungao89@gmail.com>

In __xfs_bunmapi(), the code checks if the fork is in btree format and
then immediately asserts the same condition:

    if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
        ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
        cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);

The ASSERT was originally meaningful when the if-condition tested a
different property (the XFS_IFBROOT flag), serving as a cross-check
that IFBROOT implies BTREE format.  commit ac1e067211d14 ("xfs: remove
XFS_IFBROOT") replaced the flag check with a direct format comparison,
making the ASSERT tautological.  Remove it.

Fixes: ac1e067211d14 ("xfs: remove XFS_IFBROOT")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dcd5faf3428e..f2627ec2dd24 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5166,7 +5166,6 @@ __xfs_bunmapi(
 
 	logflags = 0;
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
-		ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	} else
 		cur = NULL;
-- 
2.34.1

