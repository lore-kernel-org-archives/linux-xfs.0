Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD59183CDB
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560531; cv=none; b=MJCxWtleEhDJyM4RFO7wzRB1YSeHrJ0W3a7WHekRTE35u8GXr4ZBGiEok0JAqYAs7iGZALv0mxtuN7duVvchmovoF6MEzMyDvsyBIluKLdpEYWhrAd8pza2VFq2QXWYw/4GciO6guzfDSJfbeZNlHql0FrNrzPhai7TX7pB11xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560531; c=relaxed/simple;
	bh=tvVjVyX4Co3HHAUVk7G8k6na1MHpoiE1Fsg97Fi+MMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJzmnOTj4zIyi7IHbwkYjF+853zCBdfoV05x8kN4Ee0+v8wlItOP1sowIZI9ApbaNzZ5GgsnPo10hai6rkfk+7b6JpnVIHMkaH3VwwgpEXjrc2NANNGqEhJKkAAbhu9lubAHYb4tDhpzLnaypO6stusuvR/3olBn/FVfFOt5rqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJqdmftA; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJqdmftA"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2054e22ce3fso11514255ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560529; x=1726165329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxjIPvBEzZwS3nqnnAjs8rwzUoANMhBnXbOCMyUPgQ4=;
        b=eJqdmftAXLga2LYtToDCCaopsEKa7bh2xaIgeX/ocuvwJCmrdynJczBqdGhtI4Nlmr
         WQvRiHU2jFwj9SyicVFVJDIwlEMVz9fBzNUTB4S/ULJ2vBvCjFiOtFHfqUIGuVUyiFfO
         9YTwLghufovyDCrcjzdDfHsDkchbmh9a49XGrULeLlkMblo0ungZ/CtQ/NaCrxqOia95
         WJI4TCov5NhYN1Hp/claOUjht1EjBxFwn/LCuOmU3RHHrBGtDwBzFZYtNWKvdixoVKXF
         wbpC6CKPfIYLF1cDkDXgR9FFNGt2l4endCbR962UdtLT96G/BSukIY1NJRGr/G8pThek
         5sOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560529; x=1726165329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxjIPvBEzZwS3nqnnAjs8rwzUoANMhBnXbOCMyUPgQ4=;
        b=g8BL0ReyQbmkvsPrjrSWC7gpd854S6AqRtUic/uzqGIZ+Ao/U9UeXt9L6eKFfxlswq
         avBT3NcE95TrhPgtHQ5TTRnnlCdlKFxxAJ2zcL+ecdodtudS5q1mMV3IMV9WMdwDH4jg
         OfKJVczuGWqHyPONRXo9bkdn4LKqaeFpeYIhrtFMNyoypgHEYAruHxtlWzASdxZh4YqD
         7izZcAezRRlckYCorT/i/UA42J7ZxZAfOYl2TPGly9fEWe18hq54aKIJMJ2aQ1Dt6Ley
         BFPuYCEUNWITaguDl6ocY6avvAAXJhxos100KA9ve0iZ7VNG05MsDyOmSfWXku3OlXrE
         Sm7A==
X-Gm-Message-State: AOJu0Yz1wRhTY13ZULH6Pzi3psO03CSzuKabmz+XuyMraMpQrGgZ1wXo
	nU8mUWNtP70UIKYpc4DXe+biJ1VhNpQg03/9YhJZ7TZsoHZ46g4stscQiInw
X-Google-Smtp-Source: AGHT+IFn0FJMh5Q9o13moSx2rPZQ+o1giCnVncqRWCspIIddgw7+vh36EjLeU7bzeDBwxEfbnilfHA==
X-Received: by 2002:a17:902:d487:b0:205:6d54:1ce6 with SMTP id d9443c01a7336-20699b36edcmr108563135ad.57.1725560529066;
        Thu, 05 Sep 2024 11:22:09 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:08 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 17/26] xfs: fix the calculation for "end" and "length"
Date: Thu,  5 Sep 2024 11:21:34 -0700
Message-ID: <20240905182144.2691920-18-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

[ Upstream commit 5cf32f63b0f4c520460c1a5dd915dc4f09085f29 ]

The value of "end" should be "start + length - 1".

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_notify_failure.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index c4078d0ec108..4a9bbd3fe120 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -114,7 +114,8 @@ xfs_dax_notify_ddev_failure(
 	int			error = 0;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, daddr);
 	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
-	xfs_fsblock_t		end_fsbno = XFS_DADDR_TO_FSB(mp, daddr + bblen);
+	xfs_fsblock_t		end_fsbno = XFS_DADDR_TO_FSB(mp,
+							     daddr + bblen - 1);
 	xfs_agnumber_t		end_agno = XFS_FSB_TO_AGNO(mp, end_fsbno);
 
 	error = xfs_trans_alloc_empty(mp, &tp);
@@ -210,7 +211,7 @@ xfs_dax_notify_failure(
 	ddev_end = ddev_start + bdev_nr_bytes(mp->m_ddev_targp->bt_bdev) - 1;
 
 	/* Ignore the range out of filesystem area */
-	if (offset + len < ddev_start)
+	if (offset + len - 1 < ddev_start)
 		return -ENXIO;
 	if (offset > ddev_end)
 		return -ENXIO;
@@ -222,8 +223,8 @@ xfs_dax_notify_failure(
 		len -= ddev_start - offset;
 		offset = 0;
 	}
-	if (offset + len > ddev_end)
-		len -= ddev_end - offset;
+	if (offset + len - 1 > ddev_end)
+		len = ddev_end - offset + 1;
 
 	return xfs_dax_notify_ddev_failure(mp, BTOBB(offset), BTOBB(len),
 			mf_flags);
-- 
2.46.0.598.g6f2099f65c-goog

