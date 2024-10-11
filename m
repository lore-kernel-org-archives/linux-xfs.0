Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1127F8BE5
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607672; cv=none; b=sQmy7KRf0j9Tinbir+f9DZdwq0+M5dkBY2mnpcYSmeX5u3h7e7M+ea6O8nJXfJ2NRy5y0pPiZ0JTuqtWWxv0qbEcqQqNvlAPIp0Dnq9kr/q3wLlLxolZI11fp0vviYjOFH0mTjxKi1F7NR6wPvMghl9rqlnL+vtwVo0C6f8e80Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607672; c=relaxed/simple;
	bh=Q+e7GTjjoED0ayIBn7HPL2GBoKyUHUbgSnKI6S/6+W8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HR/FtuuIGKZfiXgb1r8AOGJpLc8ycse1L4fla9gPzShyY1Wb0KgeYMWETV+55l95gKRUxHVFX/vFdlpAfXwi+GEzaKgOgKAOdqKQCodzeI5v5/iNZXkzW5CUnmsF5z60lJGUCj9rWU4xrr2LYshd5eTv3iJDtgBddtZWCNymwe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C9iVy78h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9iVy78h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94A3C4CEC5;
	Fri, 11 Oct 2024 00:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607671;
	bh=Q+e7GTjjoED0ayIBn7HPL2GBoKyUHUbgSnKI6S/6+W8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C9iVy78h1MvCugAKWb3J9cTzUEkCfZs5HNqq6OgOFazBlHFAxx6sPI4JzADXh0S5X
	 soYjJD1kWn//SQ9udzdmb3YuqtV3j2E6kP17djpM31roc0DjV5TaKj3GX6GcSY6fAP
	 2XEr64XkiiWkc+88dfjkWD6pbJ3SynulDThl9AX3OxZf/ZPZY021Y23XI5C/5U0tCR
	 68hwbtXf47Gys74UBbQuRzTX5jkYCunVRb0hGGMWN8fLfisbDsyKCPlY6ZuBXCt9OB
	 7x4hlUUP57bvUSK9GFMil2oLQp0OmiaTlBWDIi6sFaopEGFuDzFr5assdaJFMrM8qq
	 PCg6c+e/lbIAQ==
Date: Thu, 10 Oct 2024 17:47:51 -0700
Subject: [PATCH 14/16] xfs: add group based bno conversion helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641508.4176300.6000252513142489143.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add convenience helpers to convert block numbers based on the generic
group.  This will allow writing code that doesn't care if it is used
on AGs or the upcoming realtime groups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_group.h |    7 +++++++
 2 files changed, 42 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 8f0ddf0d7131a1..07b96de47e2b56 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -12,6 +12,7 @@
 #include "xfs_trace.h"
 #include "xfs_extent_busy.h"
 #include "xfs_group.h"
+#include "xfs_ag.h"
 
 /*
  * Groups can have passive and active references.
@@ -214,3 +215,37 @@ xfs_group_insert(
 #endif
 	return error;
 }
+
+xfs_fsblock_t
+xfs_gbno_to_fsb(
+	struct xfs_group	*xg,
+	xfs_agblock_t		gbno)
+{
+	return xfs_agbno_to_fsb(to_perag(xg), gbno);
+}
+
+xfs_daddr_t
+xfs_gbno_to_daddr(
+	struct xfs_group	*xg,
+	xfs_agblock_t		gbno)
+{
+	return xfs_agbno_to_daddr(to_perag(xg), gbno);
+}
+
+uint32_t
+xfs_fsb_to_gno(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	enum xfs_group_type	type)
+{
+	return XFS_FSB_TO_AGNO(mp, fsbno);
+}
+
+struct xfs_group *
+xfs_group_get_by_fsb(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	enum xfs_group_type	type)
+{
+	return xfs_group_get(mp, xfs_fsb_to_gno(mp, fsbno, type), type);
+}
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 2f685b04e1d0c9..93a6302e738246 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -72,4 +72,11 @@ int xfs_group_insert(struct xfs_mount *mp, struct xfs_group *xg,
 #define xfs_group_marked(_mp, _type, _mark) \
 	xa_marked(&(_mp)->m_groups[(_type)].xa, (_mark))
 
+xfs_fsblock_t xfs_gbno_to_fsb(struct xfs_group *xg, xfs_agblock_t gbno);
+xfs_daddr_t xfs_gbno_to_daddr(struct xfs_group *xg, xfs_agblock_t gbno);
+uint32_t xfs_fsb_to_gno(struct xfs_mount *mp, xfs_fsblock_t fsbno,
+		enum xfs_group_type type);
+struct xfs_group *xfs_group_get_by_fsb(struct xfs_mount *mp,
+		xfs_fsblock_t fsbno, enum xfs_group_type type);
+
 #endif /* __LIBXFS_GROUP_H */

