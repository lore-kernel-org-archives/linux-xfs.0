Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275863;
	b=pl8qnWtQg69hK9Wn0qCS6IVdoY/23We3AGTkkpZyihQqo7ysCGYXrmccfnbC8lTDE2Cv
	 Wd3X5ArWroAeeIlMr1WsG6a8hoWHmBmIM+QVxkJABLAUElKGsA5DoLPk7buBp6FVjOc4g
	 w1m43NLZkY5OupJPt1tF78QFoavgmEKFm1sTwzRuq2waS9FnEfl5VQpyix0IK5Z+dOGse
	 kpSCmUTruRrUb3aOTcPwdcaqxGpjzjguiNW/OakeuyLLfbMR5rNL/419LRio3LwB/sWG+
	 m9pjaPGi1FXlxA1J1C+TQkyV3VZPG9C5ws+N5dyMf0XlswrtzI2x5sJAgfWPqCA1/pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=aaGaAdcWANAypPo+PYKxMIbVVdnYi5iWOewOQhiUkDU=;
	b=VVeP+US+fLQKJnWN9K8ViHcohgDT1UyXQEHcYkRjAPW/WKK7yW+lSrsGxfIDtJkJ2kVT
	 Lhpoz0VxzOAIsEXLq9TiB5hGcw+HCJIuhqPXjJQ3XjmUHyS9ufVzuEvdYm4ovWJlmw5vn
	 hJBp7Y9Pp8FukzSi6+Z85E2+8WuLE5ElJamcx0kF1LfShedMtBigSqrA2s6w8CEUDuaiU
	 WWaE9luJL3lfe48Atz/+R4HDqQyGFDLEoU0XsQLyaRFNCghLrx+WekP+y2zqB/pDp6cJh
	 LsYNhWPxPv4cJI3nCgenszSj5e5s1MrD7Lw7rRCODspc+W8WlqjeFrJnWbW32lzpovw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LoEwZDuh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54698606A31D
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LoEwZDuh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6672D1F031E2;
	Thu, 29 Oct 2026 12:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275863;
	bh=aaGaAdcWANAypPo+PYKxMIbVVdnYi5iWOewOQhiUkDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoEwZDuhLbTNkGPR0xuTlA75W3k9nXj64ZYeYzZjtWYZa3lAnew0Q/Bn6GYQGEdQY
	 nHcph0dIjo1j1oiSsgHUQOhrgIidZUYyLLTFaP9zLUXtyGRPCGL1mMTOfgg+OLc6Nn
	 rM2TmBrM3UxB4CUcdMSjH4dBEyp+EKWluw/Uy8uaOrc9t6IxEtaZ96jxJaSsY6E94r
	 3IXtlpWipSpX2wuDCj8e9VUJodZk4EKKXA4+QjmrPlPkaIgwirRdR2z8+mniFt97mT
	 XtMIc6iGLUbkVTjQTKuaR1RKMzzF8lBSpOnzFLG7oqYCXtrAdUmXfJ8DfsPQDC26uK
	 aPrakLkvxtyDA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 23/28] xfs: remove duplicate INO1_WRITTEN check
Date: Thu, 29 Oct 2026 13:06:20 +0100
Message-ID: <20261029120631.803074-24-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiangshan Yi <yijiangshan@kylinos.cn>

Source kernel commit: ce2b91bebc7bc0495fe3ad5ee47e4977fbb77fc5

Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
issue with INO1_WRITTEN") duplicated commit b2d5a81dae38 ("xfs: fix
exchange-range reflink flag clearing issue with INO1_WRITTEN"), so
xmi_can_exchange_reflink_flags() ended up with two identical
XFS_EXCHMAPS_INO1_WRITTEN checks.  The second one is dead code,
since the first one already returned false.  Remove it.

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 5380927a4abe..114463c101d6 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -958,16 +958,6 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
-	/*
-	 * The INO1_WRITTEN optimization can skip exchanging hole and
-	 * unwritten mappings, which means we cannot guarantee that all
-	 * shared extents actually moved to the other file.  Clearing the
-	 * reflink flag of an inode that still holds shared extents breaks
-	 * the CoW write path, so refuse to exchange the flags in that case.
-	 */
-	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
-		return false;
-
 	/*
 	 * The INO1_WRITTEN optimization can skip exchanging hole and
 	 * unwritten mappings, which means we cannot guarantee that all
-- 
2.54.0

