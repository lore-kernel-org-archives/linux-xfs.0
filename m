Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1672127AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572018; cv=none; b=pJa3qAWCD2r9CM55XRHApIaTHG+K3SujPbwzxXSra62zuzp3klfODBjJ59vHoCTFleuD19dDM6soYT2RSoFNnmD5Xziy4dzVTcfGA6xVJ/27tUr/mKxMrgdotT8sl+hzaQylWc9COnSWusZqsDbkBn3W551j50ERw2YdW9TlYys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572018; c=relaxed/simple;
	bh=bDYkzr3JcCNvMolJpf7m3Xa2IPHXoGw56GykjEHstQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfUbBpRRuNzT9iCu8MXnVFDlb9H9c+69DNEl7qvIpPnm+RnorRjfFvQ/ZFdb/rkV8W5SkhJX3NDJoaRrNgfyu2pAOfMsjG11IvSfI/iwD2kL98HT0FUMroZKkC3J2pgyD471xwjNpJxP6xxacSrEfjRewTByWW17uqTzao85KzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDPcpA3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDPcpA3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7B11F00A3A;
	Mon, 24 Aug 2026 11:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787572017;
	bh=gw7RFpad3US+ljSIla99ZV+s2NtI/EO+HqX7kfE5rnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDPcpA3tgnp5/gxhYNjA0tr1uQ2+q+yCH447ZahhdGO54iulwELl5hQuYTmjVXv7v
	 RvY7zU1txeGGd3YpsBH3X+c6TzEwfKOs7FEgCEuqqCz8h6GyVu/OXNmMUg2Sh58ehG
	 pgFDEWqxZIUpF2ihlXELs/yeMTBPUmQO3TUyVjaFLeVz6jzQFZq+BwtOYqlk4oMawr
	 CNrCZXpfJO/E3ne4jieNB/V185IjIS+C1TRLcXeCVllugXwPYpUXh835JaQ2O3WWDU
	 LL2sUcXXnrNECtcyGAG1aHKEUNYwuRCvLvDpVC7prSsr/f0vS9tbl7btRhwAqhJEcI
	 s1apPC34zAupA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH 18/21] xfs: fix null pointer dereference in tracepoint
Date: Mon, 24 Aug 2026 12:40:16 +0200
Message-ID: <20260824104022.420566-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Source kernel commit: 9202ee546b0cd71004eed7598546efe4660097da

If dfp is not NULL we exit early here, when dfp is NULL it's allocated
in xfs_defer_alloc() but not assigned. The tracepoint tries to
dereference members of dfp struct.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Fixes: 3f3cec031099c3 ("xfs: force small EFIs for reaping btree extents")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 3e36865fd127..eae2397fbff8 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -871,7 +871,7 @@ xfs_defer_add_barrier(
 	if (dfp)
 		return;
 
-	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
+	dfp = xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
-- 
2.55.0

