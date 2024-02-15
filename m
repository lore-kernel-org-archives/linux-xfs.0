Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E9612BEB2
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998971; cv=none; b=pyLecXgzz1v5xWyOsbQHC2O5mve7WLmtfm06jvlhpi7bIc/fRaB/9l6Dl8wWh5oC5TlqKcQRWrPwDXekCBq7RPb+YWxh9Kle2Fbazc7+01J/qK1R6Lc4KF1OitSHyB4vNNSEWG2EkISDgh2GmASbDzB3heVR7IziFlbKXzeZWdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998971; c=relaxed/simple;
	bh=aF5dRwNQ/BF1IpXi4abHzlZmZWbHmY0a6+YWF1iZbDM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVqY6N3NJokit93oatEspilSZNOdmQXRbZsADNkEPzanDkROxNLU/MOrMDDDzEOpAPksMxJ8nS5UEiclkAPVcJt7yoRnurk+i/iy/g3qi0LbTfQCFwEDV9Pkx+u6+q+Jp6UVPhyQgMTnSZnvHzmukSXAuSNOfyfwf3y4VGdO9p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4no1EHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4no1EHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AA6C43390
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998970;
	bh=aF5dRwNQ/BF1IpXi4abHzlZmZWbHmY0a6+YWF1iZbDM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=S4no1EHwGrTugoaOg4CbzfPD2Lm88xYSxXD9nd7mw/72TzmBThL4Qt5FMeOJSRymH
	 b4RmVoE5SXWuhvPasIcJWZdIQ1EW4oNxAEtbFvDlZbNrwKZpmyMbBLsDiED4clJtKO
	 lMmTv7Er9FQd1dls3fxGWq0+6ABRE6bjkSxBubOcSgEHhq4FNsvgNPia1eTiOkgZK6
	 /oSrylnt9eoxvmnBA0AaSHSSZcJ2kag0K6DU9IkgJ68i1gTS+5vKjfVeqbFqifebWG
	 3IDFcW0sAMdtnR/aj/9Q8hRwYJyFzFyiYTpt+dJ8dJckDchmEjAl2l6qiF/5d7MIvx
	 IQevcUA2b/8/A==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 15/35] xfs: create rt extent rounding helpers for realtime extent blocks
Date: Thu, 15 Feb 2024 13:08:27 +0100
Message-ID: <20240215120907.1542854-16-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 5f57f7309d9ab9d24d50c5707472b1ed8af4eabc

Create a pair of functions to round rtblock numbers up or down to the
nearest rt extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index ff901bf3d..ecf5645dd 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -84,6 +84,24 @@ xfs_rtb_to_rtxup(
 	return rtbno;
 }
 
+/* Round this rtblock up to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_rtb_roundup_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
+}
+
+/* Round this rtblock down to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_rtb_rounddown_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
-- 
2.43.0

