Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81FD20DE1;
	Mon, 22 Jan 2024 08:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705911694; cv=none; b=W7YpburL+uh5UwbmM3unyqJ6Om010bYMCJmxjTPVCN3Se9TrjHBu7frcab8jAVBfLT2Oi97XPMPqArZq0cVsgCOrmIG3JrS2+4XVKiq2mkZtNP1Gh/IAjqohEE8aITMf248J61s1TEwFEqln2nQd9Oq8JfURcGq/TK/FE+efbCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705911694; c=relaxed/simple;
	bh=6c2rS9h822bFX5pYrJpwOImoROPwvVpU9cOT1pqy63s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ql/cy8kNJbMEmpAXjaIa4Aq2xCerZpLlzu08zcy6KwOLz8P+Ge7z1IJuwEA/mskTJxr8kch5M8R+qyWLb9NVdW3cqBXDjJV1vPu560EUopa6YWjjrWEq2Ld0yaLobN65kyUFNaUnrMLKphy0xkHOuljD+68lH6Y2Ek6xGCoLqa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrxE8lUg; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrxE8lUg"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6d9b37f4804so2266580b3a.1;
        Mon, 22 Jan 2024 00:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705911692; x=1706516492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fN1A4Kr2jbOgjXSzEOXIz8+oG0l4ImMiQE4UNEDt0Ak=;
        b=hrxE8lUgZ9l8THLt9mscCdjJLAoH8hf0HKaaHVZCI3KKWedOMPlIP2A9wlJhu5zat6
         w0UgmrxLlb8eZiZ7quvaPKy9KMiYD7/JcHSQWeKrvVLBU62bvxdf7IptdMqSbJ9uf06t
         uZz8sMXPklpzZL8ozGx52fpfCliP2dGF4sYcDEibcX51lWTbfc3Hh0gSGqp7ctUqOxwK
         IyNup1abFYoGZ7GYQRMRf737MNHKFcIaqBXiHNV7TuThk7zNoxwUqZ/I1fzQ8RWcu9Ad
         SXLfnhrWAn6l1VFjEMdj1xUdclprll9r/pcDPIek4NpWehILvNAuiqYYbTwKTwmTNWcd
         MLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705911692; x=1706516492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fN1A4Kr2jbOgjXSzEOXIz8+oG0l4ImMiQE4UNEDt0Ak=;
        b=tuPvLHdNKEuDblLHSLQGPzW7MHbGtZBEwIbud2QjAnacDZ2J9nMcZ2Xbf99bD5+F2z
         /CGwUMT5wKeBouCtFIzByMtwOwPL/1L86pLCyTsq+bEwnGacxCQF3TfC706yJ0epPbek
         xo14R00843WALf1aH2vZIamfXT+4LYs17P91L7yC0hQAvDW8b8ONpl/X4ZJLi5zPr6J9
         f5D+xzFoE/Sm9CqnwT3ifpPxLCyFLR0HQf4WheJKK3AxMpERvNpTbAZ+Eal1LUcGaVM6
         bcY12rQ4h19mCH714k6SELphr7cIG5bcwA0ScQyL5KnusN/S0afpQndps7vG7IcCqSlk
         Fh4A==
X-Gm-Message-State: AOJu0YzwJeSsLfmoHam26uFvMR2m3mRSk44NOSso0gnEMu14RuWFY5hM
	T2e5yxBVKT35sduYSdoWCFTh5jqWsNqkJF4LmON3/Ypu1GSxplxcPGzA3Dv9
X-Google-Smtp-Source: AGHT+IFz/qpWHgdxaTW6Xi8H5qilqij3OWWJPmGzuIcboPGnyQQ+WdEDA7KzRKt22Vsp0GjbgDo5iA==
X-Received: by 2002:a05:6a21:7899:b0:19a:7524:3a4f with SMTP id bf25-20020a056a21789900b0019a75243a4fmr6199113pzc.26.1705911691723;
        Mon, 22 Jan 2024 00:21:31 -0800 (PST)
Received: from dw-tp.in.ibm.com ([129.41.58.7])
        by smtp.gmail.com with ESMTPSA id n35-20020a634d63000000b005ce998b9391sm7660582pgl.67.2024.01.22.00.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 00:21:31 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: fstests@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCHv2] xfs/604: Make test as _notrun for higher blocksizes filesystem
Date: Mon, 22 Jan 2024 13:51:20 +0530
Message-ID: <89356c509e4cde7bf5fdea6b46ec45cc5b2afed9.1705910636.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we have filesystem with blocksize = 64k, then the falloc value will
be huge (falloc_size=5451.33GB) which makes fallocate fail hence causing
the test to fail. Instead make the testcase "_notrun" if the initial
fallocate itself fails.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 tests/xfs/604 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/604 b/tests/xfs/604
index bb6db797..fdc444c2 100755
--- a/tests/xfs/604
+++ b/tests/xfs/604
@@ -35,7 +35,9 @@ allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
 # Create a big file with a size such that the punches below create the exact
 # free extents we want.
 num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
-$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
+falloc_size=$((9 * dbsize + num_holes * dbsize * 2))
+$XFS_IO_PROG -c "falloc 0 $falloc_size" -f "$SCRATCH_MNT/big" ||
+       _notrun "Not enough space on device for falloc_size=$(echo "scale=2; $falloc_size / 1073741824" | $BC -q)GB and bs=$dbsize"
 
 # Fill in any small free extents in AG 0. After this, there should be only one,
 # large free extent.
-- 
2.43.0

