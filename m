Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CAE12BF05
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998965; cv=none; b=mH3ftAoAVRX//6WMihIaFpzAFLXYyv6bJrfVP2Svs4So740kz9ssI/3soG6hD9/q7xpl1ficGBm2ZXyDbHEls16H+aijOjR+DOsVXIg/gbjl9f7QPFsdl6eO2kmR+IM1FZritE1E+++pLzGG1LvCnf6nMq/uArekTWEoHwkKCPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998965; c=relaxed/simple;
	bh=PB8ilCHKP8GzzZuAIVKf4rn7luzGnu1YgWgU6lDuW3I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9yem9j7AIPM3KGu22nzxMd2JOm0miIElkHropcoPtH29FJa4psuJS/SeJdRYXCG8AW0JRsRGtrMB0E/cX6LCFUMyqjPcirNSX4PhVqqp6gg28zggDBob+M7QJiHgDtYPT6EDW+I+h97GG2Laj/l5DuZYnzLm3DC693KB1gyVKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+RRrUln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+RRrUln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3250C43399
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998965;
	bh=PB8ilCHKP8GzzZuAIVKf4rn7luzGnu1YgWgU6lDuW3I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=j+RRrUlnlGknWyk2AQYD3MLqxlGCPA76uBCCF3BaWqjxxmPtIV3gBe6gdF6pqr3/9
	 KYApi1lcBh9AssYcy3vNYLA+jHDK2NJxFe9IFbyspppbqbLqLDk29etxiRoYDRlh3i
	 XbyK9u0Y8+0sZTrPV9qHZVoong73pelqCkc78+j2TBAWi8Bz87l+2mtpV8qGSzBv1T
	 v1http1HrcxaXFgVrIUQuvRl+JgDjn8ueCQIyFgq7+qQyM64aKYkqr6UV43ecCHB6q
	 j5x0YJaMF8WwIr9LCo5MASlXXjrJGXDIF812oNtsMtF7LS9/6L6tTGw9lw4OApvvpI
	 4c+ir/iIeXxcg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 10/35] xfs: create a helper to convert rtextents to rtblocks
Date: Thu, 15 Feb 2024 13:08:22 +0100
Message-ID: <20240215120907.1542854-11-cem@kernel.org>
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

Source kernel commit: fa5a387230861116c2434c20d29fc4b3fd077d24

Create a helper to convert a realtime extent to a realtime block.  Later
on we'll change the helper to use bit shifts when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 5e2afb7fe..099ea8902 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -6,6 +6,22 @@
 #ifndef __XFS_RTBITMAP_H__
 #define	__XFS_RTBITMAP_H__
 
+static inline xfs_rtblock_t
+xfs_rtx_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return rtx * mp->m_sb.sb_rextsize;
+}
+
+static inline xfs_extlen_t
+xfs_rtxlen_to_extlen(
+	struct xfs_mount	*mp,
+	xfs_rtxlen_t		rtxlen)
+{
+	return rtxlen * mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
-- 
2.43.0

