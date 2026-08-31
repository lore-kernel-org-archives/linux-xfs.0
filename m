Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EBB34DCE3
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 06:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158556; cv=none; b=h1UOw0NLRQQ73iBIXW7ure50R9GQRTAGG5DZaIwr1BGf6DioCRglS9Bg97zM2W0h7BUiyjDbm1KYPlU8U53C4iG8SSwhy990Fr+pT66qGTTqC+/2FmBav/Ko8b7Hl9hPIoscweAmBfVlPqAEXjkZir15jn2yZQVmFb5LIvgcyug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158556; c=relaxed/simple;
	bh=7Lwu+vZgODjThc/lRVHwyciLhfB/35OZPcfLZXbw7Bs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=lXO+doKO/m+I5F5RBdWXfaHT5g5uzCyau5QpHz4MXTZahRbTBGmWdKYAQY0NbkDphBCuzl0VjY+G4sob0ONel9NGwm97UNmuv0o7UajtILnHJmhHv5+MYPwdLFYN42Uh3Z9Il59EGM3Syxh3IABBqU0ib5xW5HGkjiuZK2tigYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GyWngy73; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GyWngy73"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260831064231epoutp04fad8f0f3d32948f237b66f6307cbdb51~Q0LqFdM6J0347503475epoutp04O
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 06:42:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260831064231epoutp04fad8f0f3d32948f237b66f6307cbdb51~Q0LqFdM6J0347503475epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788158551;
	bh=H5QoZtIsNnmkJWPZPIv/gw9A0s1NjRLTNOYltA3/Lms=;
	h=From:To:Cc:Subject:Date:References:From;
	b=GyWngy73u474DaxT69xiY9yerxCk7Xh3eXAKBSCEbiDmSQuP/vjw2Sk1DSu4XdzO8
	 QtG8EC9xcYwD9+xTFVT6qc3Mdw937WQRVn657s7uKHnCpF7tQlpDEnKdLD9y9c13fB
	 QPD6zBLsAefLqK+olA9dbU1lYvghjb+t907bSX4Q=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260831064230epcas5p33d3c4ca8556dc1b3d33d9e0de3de1226~Q0LpfidCN1196211962epcas5p3d;
	Mon, 31 Aug 2026 06:42:30 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hYKDQ103Sz3hhTC; Mon, 31 Aug
	2026 06:42:30 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260831064229epcas5p3825244c86e28b11019cdd2ce90c16eff~Q0LoSm4or0237702377epcas5p3s;
	Mon, 31 Aug 2026 06:42:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260831064228epsmtip25d0d3bee972e02e15d62fea36870fa15~Q0LnmbTi_1545615456epsmtip2e;
	Mon, 31 Aug 2026 06:42:28 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH] xfs: release alleged child inode on metapath unlink error
Date: Mon, 31 Aug 2026 12:11:57 +0530
Message-Id: <20260831064157.758165-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260831064229epcas5p3825244c86e28b11019cdd2ce90c16eff
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260831064229epcas5p3825244c86e28b11019cdd2ce90c16eff
References: <CGME20260831064229epcas5p3825244c86e28b11019cdd2ce90c16eff@epcas5p3.samsung.com>

If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
succeeds, release the inode reference before returning.

Fixes: 0d2c636e489c ("xfs: repair metadata directory file path connectivity")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/scrub/metapath.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index ff1ff762b300..79fd69d2de68 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -550,6 +550,8 @@ xrep_metapath_try_unlink(
 	}
 	if (error) {
 		xchk_trans_cancel(sc);
+		if (ip)
+			xchk_irele(sc, ip);
 		return error;
 	}
 
-- 
2.25.1

