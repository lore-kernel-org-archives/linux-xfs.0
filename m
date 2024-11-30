Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC16148838;
	Sat, 30 Nov 2024 11:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732965100; cv=none; b=LSUpjQYN3x7+FRndfCMRKTqADsIH4qOf1fgvEfeQr5Q7XmUi/ntUxQ/JxbKWLcd3VjUBidTB9av+GiS/2B6Uv1bKum9eNtLqfILKmKc33pBEq3uRydU3YvMLItgVwuvm7/QoA3MXK/nNrlAkNYjx9N7DgYa/X68yjLN46EDOEHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732965100; c=relaxed/simple;
	bh=cNJqd8Gq9dL3pl8c/7s75ZXuAo5G6dnq2OXzKit73e4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ujOAqaLNINcKbdtr9BX8XVvxQgueSPYT0sL7fm+/Rght8PW90XSHgBXNJ8xGZXKNzOhikP52YhZIZkyql7xiLoZX64ldcydJyLpRYsSxhWaO97lLxqZzLG/nHGbjSbA6/8z2eDyYadhIzpTvZiGd3AOqZhAAI2CJTa6lS4Edha4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V8H807dZ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V8H807dZ"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-215666ea06aso1359805ad.0;
        Sat, 30 Nov 2024 03:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732965098; x=1733569898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/3WJHo98bQyOK7leaV/ie37wgoCMdI8fncgr0igqgGk=;
        b=V8H807dZtDkIkAcv4rTTvirEjjcyrjUgMKeYCQp4Qm25FVu8sWxsUlDjHczE9V7zLj
         DiQCaqiEfGpX29rbc8EWBIDs37XwLZO/ERgVjJzs581uXgLpyCUUimqEdQo73IU522Ir
         /Dhm8l1MwCiUs9Mi/Y5YN3oAxaaL163sQGx2wK8n8bpF2thMBRIOlcmOu45mbja0ggFq
         rE3rixWmMOmxnbQD5z5W0jDCRFVBJyebRbxllRxAT7DuN6pFHoXwQdaUhibltzD0hdbX
         pjPJOdl3/aDGQyh4pL49hk/+oMp4SkPSzvzckzqlonU2RWBV+J4c2P7tonEAONBmkJT0
         DGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732965098; x=1733569898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3WJHo98bQyOK7leaV/ie37wgoCMdI8fncgr0igqgGk=;
        b=ixalhKi1ptUzYTpviNl/KFDJNyR5NRgqc1V3By5PbOHNLmS94WrMRYuvo0bWTNsIna
         82CB7EE+ABIzp/f1apX9rH4B83DLmP9kfjYVcIdrQ2soNOq1ynJCCISiCWngTJHgjzXx
         iQPxxDf6FXx3f96rN0fXiluyZ8m5TwFHdr6n5C/VOKQdxvk3ydwJrk69iO0JR4io+qZO
         7bZi/n9GkGReZSWpWf3DjL417qx4mmR+Q1s+9pu/wLQa/jKNOMzhW5huRx2K+rrd9ms6
         l4o+ZNwNisRCPF3l4C94oEV5t0TDxZ5IJmeAEJsWUbd4A8KDhjvw4Yw/bOLXqhu/9F7M
         tkOA==
X-Forwarded-Encrypted: i=1; AJvYcCUwHHkm4M3sK2cOfVUGiHtxK0DKVLY5MtKOhFjzg3VIbhYnhyZyadJFnmKUya+i/Rpzu7tPreR/hsuguvY=@vger.kernel.org, AJvYcCVIWjw3Z4KWJmj+F7hzootkqnHjVwuy8HhzeJWUUfk5dEd9jciT2bWhD1sEE2c/7nxzpXHjSC4JKgD6@vger.kernel.org
X-Gm-Message-State: AOJu0YziAia0wsQOxVQVTjudz1I3r7R0xHN1SMI9P7wUsNwrs9kxGGqs
	J1SvNQl0Kc7S8BYHJOwWLZaSCyn+VQQotCGGk8YaUDy7CxFah4rv
X-Gm-Gg: ASbGnctPFDi2CPu033V8GrTShKfTEd5i2V9x1STa68Hpom3axC/Xo/kpCj3HYuh32m/
	1HNeeVMtZrR3VPc3zD9NNFTvps/wONjTh4SRJiv65QBMC8pc84gLU0GKBr1PltLKfDPO3njtNoB
	Ugi70EsBFd764Lzpp8MbF7S5LA3kI8d0YJhYAkkN3WaGxJBZmbwfvEAZBCn+PxtpZEIvy0fttsD
	tfSplJ8J+ncKS2XKAKMdE+4PLIF1WJ0d98r5D42v8oq52SUNGMuqbXlS8Ul5qt/tg==
X-Google-Smtp-Source: AGHT+IFG3TAqd0hXyjaej3sCKqgNlBw5otCPv++0tEbCvdJJFuJeQJR+Qjaxoe5NXx5K2IP95eMrbA==
X-Received: by 2002:a17:902:f104:b0:215:531f:8e39 with SMTP id d9443c01a7336-215531f9156mr39974525ad.11.1732965097879;
        Sat, 30 Nov 2024 03:11:37 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72541762d59sm4967818b3a.31.2024.11.30.03.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Nov 2024 03:11:37 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: hch@infradead.org,
	dchinner@redhat.com,
	chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [RESEND PATCH v2] xfs: fix the entry condition of exact EOF block allocation optimization
Date: Sat, 30 Nov 2024 19:11:32 +0800
Message-ID: <20241130111132.1359138-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we call create(), lseek() and write() sequentially, offset != 0
cannot be used as a judgment condition for whether the file already
has extents.

Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
it is not necessary to use exact EOF block allocation.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
Changelog:
- V2: Fix the entry condition
- V1: https://lore.kernel.org/linux-xfs/ZyFJm7xg7Msd6eVr@dread.disaster.area/T/#t
---
 fs/xfs/libxfs/xfs_bmap.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 36dd08d13293..c1e5372b6b2e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3531,12 +3531,14 @@ xfs_bmap_btalloc_at_eof(
 	int			error;
 
 	/*
-	 * If there are already extents in the file, try an exact EOF block
-	 * allocation to extend the file as a contiguous extent. If that fails,
-	 * or it's the first allocation in a file, just try for a stripe aligned
-	 * allocation.
+	 * If there are already extents in the file, and xfs_bmap_adjacent() has
+	 * given a better blkno, try an exact EOF block allocation to extend the
+	 * file as a contiguous extent. If that fails, or it's the first
+	 * allocation in a file, just try for a stripe aligned allocation.
 	 */
-	if (ap->offset) {
+	if (ap->prev.br_startoff != NULLFILEOFF &&
+	     !isnullstartblock(ap->prev.br_startblock) &&
+	     xfs_bmap_adjacent_valid(ap, ap->blkno, ap->prev.br_startblock)) {
 		xfs_extlen_t	nextminlen = 0;
 
 		/*
-- 
2.41.1

