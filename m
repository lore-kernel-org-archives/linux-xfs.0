Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3F728F4
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607499; cv=none; b=tGQ9D1e1mYDus+7Dk0oYokSrAM9C/aIJnKw9485oTCu6Ng/QmDtc/S/qjNCFvnkAt4/Sm3BP8p4EyxB2stMcSysH6GUHxjdeo03ImHlxfPP7qzqkHSPfxPg0q8ijYwsOxwoHCDJUtyvuY35PLwTGRsGuo7ennBH1+7ben9LLhQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607499; c=relaxed/simple;
	bh=XySU4u9Qd7Fae0oNO6eFY7LsXCrrbY+a8T51UAhxWqE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHLWtiWhL4LVPb6+ep72bjT2HHa5lFD4wDIEeEnPdwK1jyk/KNu3pc1MbC0Khgci+SF6kcXxffDgCMKnHdVeuHklbyb8jpe137a6pAnAkUmZ6g/N/m8Qb9TWw0Nq5UhaXO4LKFVnXFaND060BVPgLmx4j7fPFPme21YciJLU708=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V6gy1QAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V6gy1QAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D59C4CEC5;
	Fri, 11 Oct 2024 00:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607498;
	bh=XySU4u9Qd7Fae0oNO6eFY7LsXCrrbY+a8T51UAhxWqE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V6gy1QAz3pUF7XjYDBYsAxxEoSsfXoTONdv1VXdQl396AL6PunBmeWv02flh/NICn
	 JOb86AbjMPkCywo9lMBDgTL0tNdvYcykS4t9yTxqQ1xWmvVZx2gUNo/n1L/9jofDJg
	 /i3rIVdYcCo8lhaqUwb4L8pk0OlJBF+c1UKaWoivNtA34OttcAP2L061cjQJgs/lC0
	 zGe/nQfkfEZ8yfLqPBeci3Nk/vVca53pEzhLIkp8PKERqjFJH3toffgun/CBqIx0Pl
	 QqP/lAHBnmddQYCOJ4eR0xqGlMpF4oKCwV4P5qIl5zTGp3wtwWUocKB9rQGtT9d03J
	 61rWcu8ZhqTTg==
Date: Thu, 10 Oct 2024 17:44:58 -0700
Subject: [PATCH 03/16] xfs: add a xfs_group_next_range helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641311.4176300.3028612520250250936.stgit@frogsfrogsfrogs>
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

Add a helper to iterate over iterate over all groups, which can be used
as a simple while loop:

	struct xfs_group		*xg = NULL;

	while ((xg = xfs_group_next_range(mp, xg, 0, MAX_GROUP))) {
		...
	}

This will be wrapped by the realtime group code first, and eventually
replace the for_each_rtgroup_from and for_each_rtgroup_range helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c |   26 ++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_group.h |    3 +++
 2 files changed, 29 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 5b81221c3e9665..9b2fb5285c7eaa 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -87,6 +87,32 @@ xfs_group_grab(
 	return xg;
 }
 
+/*
+ * Iterate to the next group.  To start the iteration at @start_index, a %NULL
+ * @xg is passed, else the previous group returned from this function.  The
+ * caller should break out of the loop when this returns %NULL.  If the caller
+ * wants to break out of a loop that did not finish it needs to release the
+ * active reference to @xg using xfs_group_rele() itself.
+ */
+struct xfs_group *
+xfs_group_next_range(
+	struct xfs_mount	*mp,
+	struct xfs_group	*xg,
+	uint32_t		start_index,
+	uint32_t		end_index,
+	enum xfs_group_type	type)
+{
+	uint32_t		index = start_index;
+
+	if (xg) {
+		index = xg->xg_index + 1;
+		xfs_group_rele(xg);
+	}
+	if (index > end_index)
+		return NULL;
+	return xfs_group_grab(mp, index, type);
+}
+
 /*
  * Find the next group after @xg, or the first group if @xg is NULL.
  */
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index f211108eb6ca4d..8c4169520c6c7a 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -20,6 +20,9 @@ void xfs_group_put(struct xfs_group *xg);
 
 struct xfs_group *xfs_group_grab(struct xfs_mount *mp, uint32_t index,
 		enum xfs_group_type type);
+struct xfs_group *xfs_group_next_range(struct xfs_mount *mp,
+		struct xfs_group *xg, uint32_t start_index, uint32_t end_index,
+		enum xfs_group_type type);
 struct xfs_group *xfs_group_grab_next_mark(struct xfs_mount *mp,
 		struct xfs_group *xg, xa_mark_t mark, enum xfs_group_type type);
 void xfs_group_rele(struct xfs_group *xg);

