Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0601FE47C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180690; cv=none; b=WQhHwPW7WWGQg96AtYUtLzLwl93gpCz3bkvNhLI0LGcMS7LboeeIOiHoDHUmGE67QJDEsqHWmo/ubY01fkIOmGMthnYY41zG/Y665cpijH6DNnIFc33RdReZMdDPu9n0TqbjQcV3X8A5AtN2XW97oHs0/ZralvU1EQanu1hiEcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180690; c=relaxed/simple;
	bh=/ATyvFLD/XFlWucEDX6ChIDY7b9JzWG3as4IWIEPsQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HqnFiGhkvd03t3zlIz9o5+sSfDoRQFN/mlwhGLQy5i9wZAlEEsHiueM2VU9eOT5LACv2o7SkztvwqiIJkavnrCAzSSslgvFyvXsRLIZn9yCuL+XW1Kasjz8gon/EpV/lq8R/anqtiDPMy4xWMDHHG5bOzjYYa1wD8ttIkfVv2K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V52+abXg; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V52+abXg"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a77c1d5c3bso10220215ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 07:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769180689; x=1769785489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gIch1sPlj6hZeIUC2yrtD0SdJzY9LM5TQroC54GkKRM=;
        b=V52+abXgyZBIQHGrajyJYqp+tmQICKuZmjc6/HYeaJIQCn0CeTJqUQaWbeQKLqhUG7
         eJhp2U/xdHoaJAlqjB5W9ILcRNlbKz/OOxQHz1xM/eNF2DX4ZSEedg7kOGkbDgMWJyhe
         4WW6ANMRoZKJpUTXzRBhwEYWiWa0CjDYMl8IclFeGR2UJD3kJFxHaDzpDgNZsK4AzI55
         Lys3icQira/nKdFhNofAPLdQK9oBsrrQOrTtquwPBczcoK3JxZv4jPm+4khUggGqFiAg
         KMm6PRnv3YmXWeg8IGO9FoGEr4JkT4JwExlKq1xAbOeV7YOHLzq2L/rCkqz4oqK+lc4F
         fEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769180689; x=1769785489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIch1sPlj6hZeIUC2yrtD0SdJzY9LM5TQroC54GkKRM=;
        b=cXPhgx5QQO76J7iC2CxglSbIaU1yzT85910EqojXt5V3Ijt6iQV9wWF37I/WeOrGob
         Jgkf7xqg4Mv07BlYGdBgqqZBSUQILsamG0wRm2EkXxPgd25SH4Vh1azSCeR1QhQ+YVLQ
         eRxlcCo31GblazMj4nkX8BbGsrlIJJnT8z9zy6GscKymO5W2AA0zQjyzxq/cHfKqzmVY
         1zvS8A3A46Xcgql0Q58edK+SIasztiSwza0TUBe4Zy+Fs4T67Yk8w+ss8yZMK8s1rX9Y
         qZmKtcDNqhNQ9R7k1Q4R2j51BL0qMZ9UxNhxQPT2lhcaFGz2YTsIbF8phfhXfydEDaE9
         ybfw==
X-Gm-Message-State: AOJu0YykhHz0kzjpvnV660X5VW4jBLg5aqdIsVBHphf8TcPDafu1BLdJ
	A1Ca+ga+jyTmMs7EScqwL5Cz4NSWmV2YvfG2pevSDFr5366nArA5EBOieg1d0Q==
X-Gm-Gg: AZuq6aJRQkhaZc4x36xBvy4V5FYIqvaZREogTO9uxQ/9XKfX9y4wMIWog0MQily/CVm
	sSfxQ2xuDFbQeVFDrcw3bDz1gH62jXTqeygSYJgkm747gc2C9TWngIgheWQdX/Il74Z1BgDtN4s
	hJSTA58pI1pdFHMAPGGm14wsyJ1aaAqrCzPJPVbwzPyZN1SyuX/a+2Lfaw/BE2431ahjCzMY/ZI
	6a6x7/SbPTsynV7dH80WO3U0rkcCWdH+ZlViM/Tb1ga1PUNLUstq07WGn+xgoYioouu96gT4S8x
	aT7MixAoFQN5KE+/vNGGPx5RX4RNFVmrztlV2oAoqkgPKeRmfR3UrL7prlygg2xz5LQBLc0VS0s
	WSeUCgt+bjLxzP83pNf0ReeumLyHLKiX1KBefoll230tcqL89rI0oxhQsmp4tP2UFjSitDVeoO1
	dXrVPeZ8HanxS3q9v398jsVLrtH5bdIcaDR+3vxfQ01oeWO4Vu2x6IpxNG
X-Received: by 2002:a17:90b:4ac1:b0:34c:9cec:dd83 with SMTP id 98e67ed59e1d1-35368f29c6fmr2704518a91.27.1769180686343;
        Fri, 23 Jan 2026 07:04:46 -0800 (PST)
Received: from localhost.localdomain ([119.207.118.73])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82318644bcasm2488146b3a.2.2026.01.23.07.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 07:04:45 -0800 (PST)
From: Shin Seong-jun <shinsj4653@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	sandeen@redhat.com,
	willy@infradead.org,
	djwong@kernel.org,
	dchinner@redhat.com,
	linux-kernel@vger.kernel.org,
	Shin Seong-jun <shinsj4653@gmail.com>
Subject: [PATCH] xfs: fix spacing style issues in xfs_alloc.c
Date: Sat, 24 Jan 2026 00:04:32 +0900
Message-ID: <20260123150432.184945-1-shinsj4653@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix checkpatch.pl errors regarding missing spaces around assignment
operators in xfs_alloc_compute_diff() and xfs_alloc_fixup_trees().

Adhere to the Linux kernel coding style by ensuring spaces are placed
around the assignment operator '='.

Signed-off-by: Shin Seong-jun <shinsj4653@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad381c73abc4..c64e6c13f70d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -376,8 +376,8 @@ xfs_alloc_compute_diff(
 	xfs_agblock_t	freeend;	/* end of freespace extent */
 	xfs_agblock_t	newbno1;	/* return block number */
 	xfs_agblock_t	newbno2;	/* other new block number */
-	xfs_extlen_t	newlen1=0;	/* length with newbno1 */
-	xfs_extlen_t	newlen2=0;	/* length with newbno2 */
+	xfs_extlen_t	newlen1 = 0;	/* length with newbno1 */
+	xfs_extlen_t	newlen2 = 0;	/* length with newbno2 */
 	xfs_agblock_t	wantend;	/* end of target extent */
 	bool		userdata = datatype & XFS_ALLOC_USERDATA;
 
@@ -577,8 +577,8 @@ xfs_alloc_fixup_trees(
 	int		i;		/* operation results */
 	xfs_agblock_t	nfbno1;		/* first new free startblock */
 	xfs_agblock_t	nfbno2;		/* second new free startblock */
-	xfs_extlen_t	nflen1=0;	/* first new free length */
-	xfs_extlen_t	nflen2=0;	/* second new free length */
+	xfs_extlen_t	nflen1 = 0;	/* first new free length */
+	xfs_extlen_t	nflen2 = 0;	/* second new free length */
 	struct xfs_mount *mp;
 	bool		fixup_longest = false;
 
-- 
2.47.3

