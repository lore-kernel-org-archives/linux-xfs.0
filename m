Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377741ACE10;
	Tue, 24 Sep 2024 18:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203162; cv=none; b=jYFY5EweVMUIH5BO9puP1ioKbojHGbA+0yQ+rNIbwr9rvKsfXwhNI/+aiTfH1N+7Ib6PMpvSUWVg7UXAUX+gZRfzzq1s1FE8wu+yXT/O3TzbbpL9icBVEIdee9CgRMB4hWEeoeD1/e6RXX3oR6vy5A985NJv5pU6qb3Wt9xWvpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203162; c=relaxed/simple;
	bh=BqhpH8jm1bo0e8mrsvc10FfNERVGh7QMOiC/BpJ3VxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSCdlR/XG8tKkv9668aXsBGPnGuecZlcHCg3q7lsIYxydKFcrqip+YP8yOy14xADAyAJdeUOS44bxHDlKqZ9ZHOKtiV+Zlp1m67VIzl0Mx3YnZDoaHR7/o2wcr9u680V6T1GFEnpjDb/D2VXqdXZ/doApfjr6AmIG0yfgBwmTwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gpX4M3pn; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gpX4M3pn"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2d89dbb60bdso4115754a91.1;
        Tue, 24 Sep 2024 11:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203160; x=1727807960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnPsE9L919nUKOYw2LureM0PQ/hRlQrq9CZOkfmsz9U=;
        b=gpX4M3pn1XjESSpAB1RzrCh3eoSdHA6ckgGq0zDKuMqcx2OQdJiCfhxRivck9RkL8X
         vj7biJupnikI7G4/tbpLVkb6JMnpnAsK4KuCy7FfbYCKS7SmUaEBV7gHMPlZNXKC514A
         QsajZrPWw0qp3cL1bPNy51k7EeKg/QrT2M3TMflIHsC3RBx84o8F1Q56LpZ7hI0eD1n6
         jFrtOpOqneir9Mu/PeFkcvgHrE+AISRmrGux+iqeUNkH1IPmM73AhqV0LBX5SQGPFtxI
         MCxrH0BpdbeOyLR8W7e5ySabZeeF8cReJraQTL6GFiyRcI8WrZs5uXsMzjgrGDHfSRZk
         /Emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203160; x=1727807960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bnPsE9L919nUKOYw2LureM0PQ/hRlQrq9CZOkfmsz9U=;
        b=Ly1QRCojdSJM/+XwUTvCIqMOA81Ov6sXOErSZ6y36srfpG4sEb70+HQkJMhOFnPnqO
         F82DdMJIdNK74YR4fS44C8wv97i39+dn4oA23wGori8IlJ5bP49rM2VmWqiDilzs4S9K
         +tdDsQlvKTx65sR5O9jVcOCH1i3fbWWW872j5b8yafPLr4oLxWVjatxYsmACsLapFKbD
         tFvuz3u5QbAaSzz7U9xq5oaT7j6hIFylQZLWRJ+qWkRGgVgHR9fZXjZ0EZRRCdrtVGeV
         VDPK73VhRPlKQ80XoTiVZMlfEDPOPBveqfehWt2ZowfjJiAYF53EvKR9wJlM5uNNc1C7
         twJQ==
X-Gm-Message-State: AOJu0YzDb52Zf+KyXbqu0TwaKUMv+TA+61Nop+1fYkf7MRMc+fO6TZ+m
	9rnknhsOF4ImjvV3XjePoiIiGA18EvLNfc1w680u0zcCWWeGY2xyvh6YhDcW
X-Google-Smtp-Source: AGHT+IEVLSzgZ2uSJoF9TZc0xpP0R/K89j7MGUD5pGweC5fVKWgKV9Z1v/JWJjC7E0+Zkz2ov4Ymhw==
X-Received: by 2002:a17:90a:e183:b0:2d8:b205:2345 with SMTP id 98e67ed59e1d1-2e06ae7a941mr119347a91.23.1727203160250;
        Tue, 24 Sep 2024 11:39:20 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:19 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 17/26] xfs: fix the calculation for "end" and "length"
Date: Tue, 24 Sep 2024 11:38:42 -0700
Message-ID: <20240924183851.1901667-18-leah.rumancik@gmail.com>
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

[ Upstream commit 5cf32f63b0f4c520460c1a5dd915dc4f09085f29 ]

The value of "end" should be "start + length - 1".

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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
2.46.0.792.g87dc391469-goog

