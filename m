Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BE61AC45A;
	Tue, 24 Sep 2024 18:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203143; cv=none; b=NQVWomNW34H3uyIWrOEdvv9o+WdtERcP1aQ/8PHpGtW7gBsXQGO/Sv11pgbrOUgt6XNcMLtW9JVQMqZLS0jiSiA/H8LXP2W87uk2c880J0ejX2nyGrgoSsK3mIlWfUukHrsn4TVHHkMtyHR4DDNNZ43ojmyCSQDaEhlSKWljLu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203143; c=relaxed/simple;
	bh=itnYuLbEbb5RX7almTbQe35WhKRcAs4sDhG3S42WrpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlIE8sq7YweyTuzrqP83x0pSvYN8VgIsxqvBNwORDRjKkhCPS5Sbly1vT8Mn4/L7oOXAzibnLB3OiioGYNGfK+peQCfhyd9o3Q9J4Mz2KUVmPvZ2wb1AljZyZMQC94HBWcdaPNrDtClgzwLCqJ8rv4XILEzndYPo3hmSKoqRCl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STQbNhuh; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STQbNhuh"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2db928dbd53so4569754a91.2;
        Tue, 24 Sep 2024 11:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203142; x=1727807942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=omUh0GNRrQniy5dGCLOuTd2ASeKAQ32meQjaH4FZVtQ=;
        b=STQbNhuhWM2uPbeK5IqdgjTceZfREZ9/+Nh2pc7hXMWsS3AClnXaFBETeafRijjdHd
         wxpnDYZisr9Amjpdb97j5BVFgAp9vUvdq6FJACYrJOQd1Jx/AlGPIQUaQaR3/UNU1rDd
         UZqXcjlSaIcRXoQnDYiHnvELuyP96sOnbbmdvKCq1OJKOw9z4VgHY5l7r+t87bmm/hJr
         okkxL3p1D8kIqYr5kZvpAPboMksw3Q+sSfjzJkqRaLcxWyBGrPVn0+WCyxcjqknVhaQz
         TVL4l+UgaPdX1knh1qgSaaA/dn/v6v51KLgXgU/zgKCEABBZ9C+tYIKmJGGqPQe1uuYj
         Sq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203142; x=1727807942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=omUh0GNRrQniy5dGCLOuTd2ASeKAQ32meQjaH4FZVtQ=;
        b=CwvVqp2FULhHPsz95yx64OeEBVS8O87YYad4A1AW5x0dmQmZ8ZcYjIUAbFFxx9uaxL
         ZAQ/iwchBHRfkmxDh9WVE3qcG7hxAF5IwSXiT3SMOp7kYbegqlcWr6HGf0vzXwF1igki
         /s9ACMXvi48PS/BzmU46lR3R5UdlKTCr8Whjc4NMx12GSqYuNcX1t060JaAJ9mR2QGZ3
         kFPzqd4Eh/lYXEh/8ZBb7nkRiLycwm4ja9pU8rhv/liYIsL1K8U5iRD0GKeFIT4w4DkV
         KQuPre6zHahoWDyaV/7EITbOvn8A6ON2nGTqjSNBoKG1qmcoXDD4r1z40q1qqEZpbQD3
         X1Sw==
X-Gm-Message-State: AOJu0Yx1VgA9Z0BZBzti6BmQtX0YmLdm/qQeIG+kh9+rMKHEzRbx6VZ7
	7Tl88G2KBlYJNhSX2GRBfLBPgR+qBS9psz4jo7AbhFDRlItGJKdj1ujvUKJ1
X-Google-Smtp-Source: AGHT+IEzwDLqtzlbPDo0gZlPVFDqnW+RDWBCsz3TVjBQ1r4DcsmZ2ocsDJd0UokBE9gHwfiWcgRcJw==
X-Received: by 2002:a17:90a:ea97:b0:2d8:83ce:d4c0 with SMTP id 98e67ed59e1d1-2e06ae5fc6dmr127869a91.13.1727203141624;
        Tue, 24 Sep 2024 11:39:01 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:01 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Wengang Wang <wen.gang.wang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 03/26] xfs: fix extent busy updating
Date: Tue, 24 Sep 2024 11:38:28 -0700
Message-ID: <20240924183851.1901667-4-leah.rumancik@gmail.com>
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

From: Wengang Wang <wen.gang.wang@oracle.com>

[ Upstream commit 601a27ea09a317d0fe2895df7d875381fb393041 ]

In xfs_extent_busy_update_extent() case 6 and 7, whenever bno is modified on
extent busy, the relavent length has to be modified accordingly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_extent_busy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ad22a003f959..f3d328e4a440 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -236,6 +236,7 @@ xfs_extent_busy_update_extent(
 		 *
 		 */
 		busyp->bno = fend;
+		busyp->length = bend - fend;
 	} else if (bbno < fbno) {
 		/*
 		 * Case 8:
-- 
2.46.0.792.g87dc391469-goog

