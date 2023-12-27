Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEF6389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmItx1kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9B8C433C8;
	Mon,  1 Jan 2024 00:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068910;
	bh=upXalR/3RngFBs3SRWbsC0Ohk29dz1l18NFekUUS88E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GmItx1kkw06ZoYKb54x8NMrm1j71MyuPwKnPMWI5nhGo6ML6XH/d6Q3dW9QIq4wYo
	 JWumeha7HUl4nm5fTOpU67iPL4dXoCzWnCslmo6JjIztPEw0M9nfIknaz7cwuhYj6U
	 OcIhediESzS3LDJPZxfI/SY6Wc49CPtSFFrfGoiIxZeiz/iA2mX/mzfu0nk0z0Bnmv
	 ilnqzHp+icacPiIP2kR/nmzwLA8ItjVtdLKOVxKDWdNgkGCMom4kH2HTXGgZOsmbpJ
	 inXi4kOzmnUI9Tvb7J0Wj59hii15Pcx43ZxUwhw1iCWnleVMjAgjLYXtG3iMb0BfiS
	 Po2d8jP3CqiCQ==
Date: Sun, 31 Dec 2023 16:28:29 +9900
Subject: [PATCH 09/42] xfs: add metadata reservations for realtime refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017246.1817107.14702418934840570079.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Reserve some free blocks so that we will always have enough free blocks
in the data volume to handle expansion of the realtime refcount btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtrefcount_btree.c |   39 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |    4 ++++
 2 files changed, 43 insertions(+)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 425a56578c6..99eac508cda 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -489,3 +489,42 @@ xfs_rtrefcountbt_create_path(
 	*pathp = path;
 	return 0;
 }
+
+/* Calculate the rtrefcount btree size for some records. */
+unsigned long long
+xfs_rtrefcountbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_rtrefc_mnr, len);
+}
+
+/*
+ * Calculate the maximum refcount btree size.
+ */
+static unsigned long long
+xfs_rtrefcountbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtblocks)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rtrefc_mxr[0] == 0)
+		return 0;
+
+	return xfs_rtrefcountbt_calc_size(mp, rtblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ * We need enough space to hold one record for every rt extent in the rtgroup.
+ */
+xfs_filblks_t
+xfs_rtrefcountbt_calc_reserves(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	return xfs_rtrefcountbt_max_size(mp,
+			xfs_rtb_to_rtx(mp, mp->m_sb.sb_rgblocks));
+}
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index ff49e95d1a4..045f7b1f728 100644
--- a/libxfs/xfs_rtrefcount_btree.h
+++ b/libxfs/xfs_rtrefcount_btree.h
@@ -72,4 +72,8 @@ void xfs_rtrefcountbt_destroy_cur_cache(void);
 int xfs_rtrefcountbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_imeta_path **pathp);
 
+xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
+unsigned long long xfs_rtrefcountbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */

