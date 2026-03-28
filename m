Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF70F3A5E91;
	Sat, 28 Mar 2026 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774719271; cv=none; b=rKQlvga3yQKtEJgcp33Fc/0IVeisGyWCqfXNX4pCP/+fq+QsjGkjHwSBfMgmqdihWCy5xsseut/+u4McAypShvvSm0oQzkkbCY86iaf1LL8mi3vNUfMZD/GKZ2XAm+cBr1nWoTTrcLS8jMd+XgIOU6q2ZeM5UB1BJFjOCExNX3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774719271; c=relaxed/simple;
	bh=9jEU+8YraxiDlRLkJUxMNE/JapOFMmndlP4uCduP6K8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKqRRRJLah9xLPbQ/crC7vvYzAYR01C4fqFCGfm8M9CGObsPLo0q2m9muSwMVkoHon2xTyM5inYRHeyXJzL8lcctGgRzUeJLx6PXKbe+n5PI4mg4kfsLwLvEUf+O+96U/ayzMPp8ZHnHjQUliSKy00dffhPno+ybPmeCrflOwNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=gDuIGrJP; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="gDuIGrJP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1774719269; x=1806255269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xRQC/BJfNJptyxAez1KRMoDYHgoICUPaBIbcbZvc/gI=;
  b=gDuIGrJPCe4kDVLrLFQr427A2Fsk9OIBiaAjLfXCGPIH5F15/8UMqN6j
   GsYD0ENruTsDXkOiRua9khR2sRQJJh1j18d0cEE3VbMHk6P49cgmMEYGU
   giDZWNJKPvsd6AjMxOBhWxLbU1doVU+Lg2kVVJeRiU/hSvOVpPjrLr5tz
   H2EWsjITtAPuFPISMuDX1/DjFuAY2Di7deHfmo8F5MKY3F8IlYlQ5MSSG
   AF+vxcit2oZCyCGe3TTtFcspY5aj3DuLqR5Bd1XbWLVVPaYWz9gWcglHv
   ErOBtjUnZPAXsMQNkJc3gwGK/PaSF2vVdxD3qhsb5b2rv8W0GC/M3kJDu
   w==;
X-CSE-ConnectionGUID: WkBHO77/Rd2eV8cLJ2gDGw==
X-CSE-MsgGUID: 9Vr6wpU1QAiRSksC0QBrEw==
X-IronPort-AV: E=Sophos;i="6.23,146,1770595200"; 
   d="scan'208";a="15915420"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 17:34:27 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:31055]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.137:2525] with esmtp (Farcaster)
 id 482f7662-c221-4cae-bfc6-85d6e2082c6c; Sat, 28 Mar 2026 17:34:27 +0000 (UTC)
X-Farcaster-Flow-ID: 482f7662-c221-4cae-bfc6-85d6e2082c6c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 28 Mar 2026 17:34:26 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.39) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 28 Mar 2026 17:34:25 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong"
	<djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH 2/2] xfs: fix integer overflow in busy extent sort comparator
Date: Sat, 28 Mar 2026 17:34:10 +0000
Message-ID: <20260328173407.43057-6-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260328173407.43057-4-ytohnuki@amazon.com>
References: <20260328173407.43057-4-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

xfs_extent_busy_ag_cmp() subtracts two uint32_t values (group
numbers and block numbers) and returns the result as s32. When
the difference exceeds INT_MAX, the result overflows and the sort
order is corrupted.

Use cmp_int() instead, as was done in commit 362c49098086 ("xfs:
fix integer overflow in bmap intent sort comparator").

Fixes: 4a137e09151e ("xfs: keep a reference to the pag for busy extents")
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_extent_busy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 3efdca3d675b..41cf0605ec22 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -690,9 +690,9 @@ xfs_extent_busy_ag_cmp(
 		container_of(l2, struct xfs_extent_busy, list);
 	s32 diff;
 
-	diff = b1->group->xg_gno - b2->group->xg_gno;
+	diff = cmp_int(b1->group->xg_gno, b2->group->xg_gno);
 	if (!diff)
-		diff = b1->bno - b2->bno;
+		diff = cmp_int(b1->bno, b2->bno);
 	return diff;
 }
 
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



