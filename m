Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6411C11CA0;
	Tue, 24 Sep 2024 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203167; cv=none; b=qsU1ZojDx/4/eKCjVsQF9xpAHxJkvVw4087hORCfDBvvUbk81YPbM5FYN5RLBt923fkhIuzrkII4wVygT7pG3Yteuo0vsoBy+KHylMG3HJIPhSTwksCbgHXBlZj6u4TT3I7vrrFgk4EezAAKCQD0eML5vfAzoBjY7AASD7mWdvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203167; c=relaxed/simple;
	bh=mJ+0+PF9dIrRrbKqrqCbHxEPbAmviyK6H/hUlOm3LgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT7JAS1cfsFt2h0M/hie7yPVS2S8qNXoiplGrJyZB2IGEnxcCeEHzQo477LFK7ykGbD7mVeGZZMhSsuUNVwL+ANnHgteuSmXYvgLAZXumnqazkP3CRs+cQPSQKzL3Mq0KoFiJVlwT0rwf0FkO3GMSyq3EOvPR+YOMmylsI00Zbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3Bnwuv1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3Bnwuv1"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20570b42f24so65399385ad.1;
        Tue, 24 Sep 2024 11:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203165; x=1727807965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdJjExmLoyiJTe5TvB/BM44OCYja0VM81kfpCdWY7bY=;
        b=U3Bnwuv1CAL/wYySBCfyrp++J48QcZR/jB2yMTuuPwWobZyRtslSUIp8D60yBDaDDz
         PA/zT/tk6oT1L1gFNgE0mK6n5BarLUxjt6abXyKMt6SdXXjyuo3hPBIdi0rNNh5xiFVO
         Yr7ozYYLPq9kpsLwllG5woyDuHB1wU00zblCYJUwhmPoI0t7tD1h9KLqHewXirNNOgZr
         J30KnPgGO6cGaCOnnSEd+JYUXK9jSCaukwkOTpv9Oxa9AUqTtFeuxnrxcD07q89RKpV7
         xhXUGo3SF75sM+HyCtrkLf+q55ad61sp0xC6DcZJ1TF9GmMPjybFdqDpf8hRnKbCeJr0
         S/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203165; x=1727807965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wdJjExmLoyiJTe5TvB/BM44OCYja0VM81kfpCdWY7bY=;
        b=H/mpxp5squI0lNIgX6mqqXeB2ku8TpNawXeZ4H9pyNLRKVjcw0zGMnAX5cYz16YMS0
         WO0wJNE75853ExV9+99oxf+7pZt9ZzyoAJM3EOqchGJbK590rQ6haBkemsnzcnMSiva1
         X2ru4v+DIyDI17W1w3IGuBT78LgLwslwPSVJnl4AW8ziCyTKGHuswyGBooLwzJa7mkPt
         0c+liEiXByAlHL/UsXPjqo1PET0sJ10KxvCkvg+uTYZHVoic2YjP4e0w5OZbcmyucGa9
         EXbiGX1qCUvQCG1TqdRyDrRIlpQeunvVFGFvuD+20SXS0tlVsjpojraA/Pt2DquFdWh0
         Ll4Q==
X-Gm-Message-State: AOJu0YxidSP+luvHqy2qHKg1ZkjGDLdfJqBEt6s/yvq+U+uQ7u6fk2UU
	5WN/V2cMxP4zrZBzpYIu0PrFoQFDZY4rBLjo9bVvx6UVVA+mRWhLFyC2JMGd
X-Google-Smtp-Source: AGHT+IHvDv2xraWu2YbEC/nqfi4bMStC7yHqZN7MNDK5mfrVob3V+BTgdPd7HueOSWhjBdrkLP2mEw==
X-Received: by 2002:a17:90a:d490:b0:2d8:abdf:2ca9 with SMTP id 98e67ed59e1d1-2e06ae2cbfemr113729a91.3.1727203165553;
        Tue, 24 Sep 2024 11:39:25 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:25 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 21/26] xfs: correct calculation for agend and blockcount
Date: Tue, 24 Sep 2024 11:38:46 -0700
Message-ID: <20240924183851.1901667-22-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

[ Upstream commit 3c90c01e49342b166e5c90ec2c85b220be15a20e ]

The agend should be "start + length - 1", then, blockcount should be
"end + 1 - start".  Correct 2 calculation mistakes.

Also, rename "agend" to "range_agend" because it's not the end of the AG
per se; it's the end of the dead region within an AG's agblock space.

Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_notify_failure.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 4a9bbd3fe120..a7daa522e00f 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -126,8 +126,8 @@ xfs_dax_notify_ddev_failure(
 		struct xfs_rmap_irec	ri_low = { };
 		struct xfs_rmap_irec	ri_high;
 		struct xfs_agf		*agf;
-		xfs_agblock_t		agend;
 		struct xfs_perag	*pag;
+		xfs_agblock_t		range_agend;
 
 		pag = xfs_perag_get(mp, agno);
 		error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
@@ -148,10 +148,10 @@ xfs_dax_notify_ddev_failure(
 			ri_high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsbno);
 
 		agf = agf_bp->b_addr;
-		agend = min(be32_to_cpu(agf->agf_length),
+		range_agend = min(be32_to_cpu(agf->agf_length) - 1,
 				ri_high.rm_startblock);
 		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = agend - ri_low.rm_startblock;
+		notify.blockcount = range_agend + 1 - ri_low.rm_startblock;
 
 		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
 				xfs_dax_failure_fn, &notify);
-- 
2.46.0.792.g87dc391469-goog

