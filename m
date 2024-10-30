Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1629D82899;
	Wed, 30 Oct 2024 04:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730264189; cv=none; b=eScySO8RvYQpstTye74KM61aRiDnTv1nPp8MUPNy3c/RI6sGXNn1snD/+9miKv8KVuHbtySW4SgAiEpD7hOOaoZLBvPYrBN7ImkeTSLI51XHBc81PTbdEVIinSMXUq6Wq9NiPVF51Jn/JHw5JVnugENRp/AtvZEFqOWp/NulmOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730264189; c=relaxed/simple;
	bh=cNJqd8Gq9dL3pl8c/7s75ZXuAo5G6dnq2OXzKit73e4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Asq6OEv6fv/QRiwcGYfc1JvZlpAOtxyrC55ZEwAr1COQgmCsWVVQVc96O1Yco4+Zqd+9PgmECTGJTCdkYiZJPGXTLjC/6psQbORvHNXz5UY3CoklgSkKVBdyo+ODO61xy5aR3yzWu8CmeO4hQ2ZTn6Mfzm56ZLY46n454Vaikpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P8ZZ4u7x; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P8ZZ4u7x"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e2d1858cdfso4452577a91.1;
        Tue, 29 Oct 2024 21:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730264185; x=1730868985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/3WJHo98bQyOK7leaV/ie37wgoCMdI8fncgr0igqgGk=;
        b=P8ZZ4u7x14XNdF14Sgjl5IycLld/XjIHqw8Pt8ZxdCL0y7aEqX0w73IllXxcP7x57Y
         ac8DOPqYawlTtPtKaUicSwEHqlFh88LXJ2mbhkiUCzb2VS2oiYI9T6rxbWfV1k1xtWQI
         JQZqG8zd0XNGH9t11Fcqnl0BvgByMM3jyhqI45e/2kv+QZytEbTS8EfGbk0zALXiuJ6R
         VmOyDWbwgNobofswfUqbJKvc3FnIuxMWIZn34ee8uS9SIMZutEOFKSFScS5bvCqccYvx
         9aAtz7aEHP2jwfLRl3V0FO+dyn3XPOUTotyUYMbr2EeZ42lks5r3vEDMceAIRLp780Lz
         IpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730264185; x=1730868985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3WJHo98bQyOK7leaV/ie37wgoCMdI8fncgr0igqgGk=;
        b=NiuMBIVqioWAJ49s+u0Psm/8HJyIW4Twqx7vIGkVl3f0BP2+vEeqcEa3ZU8oTvJUQd
         JmxVQTUfzRGefEOxVAb9iwEmr5811dIx6oabie0sL19EzRF8ENlZKs8+E5Op0RjFf3Yn
         uxHZVhgtopzL8TvkYLoSGHa3Lke3WkSyLaTU9asQDST1NEcK7JAMOyRGSX7MOGYQpOJE
         5uaq4sb336GnPjo+qXEvHssJsWFL6yLvsmW8fsafFZV/g/A/pYk4o2NTBfWO1S7Pepqu
         fnTL820OHiCoAZodtDlbutH70UOyRQ5eyOBPX1ODAcJq7YMHBb9UGq4iV+bNZJ2PbKKk
         jjLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxIKCmuWpQzRDqn+EC8eFXzvNLYRuCqZr/IH9b2WWKc34ldr+8vbV+8XnFDEzC+xXo7mj62VQrVO7A@vger.kernel.org, AJvYcCXL3ozt7NoXdzMqzCR3RnogchyhsGjdS/tyIRSaa+riczdSkYbvBUDiCvkUDHMglcyLm/KAAtjTE9hCTlM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdGSpb8DKuNMqPV5U5SB05G5OKJFjgrIseL4VAtTj2bcZGdJGQ
	eerW8ZrSrjK1RwQGFuCJdAVhxW9V6YPVMYQrKQT13MZdqyaNFFZz
X-Google-Smtp-Source: AGHT+IH/Ox+EL92Eo+EnWlruc+lsJlrafTmbrepl9MCFSVVpK9W9JEiJ5LDD8lEUh+7dHEpokEI1JA==
X-Received: by 2002:a17:90a:1b8e:b0:2e1:e19f:609b with SMTP id 98e67ed59e1d1-2e8f1088115mr16221063a91.24.1730264185412;
        Tue, 29 Oct 2024 21:56:25 -0700 (PDT)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf441a4sm74657285ad.18.2024.10.29.21.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 21:56:24 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: dchinner@redhat.com,
	cem@kernel.org
Cc: chandanbabu@kernel.org,
	djwong@kernel.org,
	zhangjiachen.jaycee@bytedance.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v2] xfs: fix the entry condition of exact EOF block allocation optimization
Date: Wed, 30 Oct 2024 12:56:17 +0800
Message-ID: <20241030045617.2920173-1-alexjlzheng@tencent.com>
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

