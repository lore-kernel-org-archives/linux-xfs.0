Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94635389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amLcFEBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65271C433C8;
	Mon,  1 Jan 2024 00:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067972;
	bh=4nLCv0sZ2Z+oX6S3crmX+DOEMbzU93rcmlfNLP5gkuc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=amLcFEBTlxclZ6v+nqlVzCXIAWMme6quIdo2WEYOCtosMqQQKo9qeslQcxgLnnkrg
	 FJmHFZvvp3ULNduKEjM0soy5xDmmAVR7c1/F0ArOKhCLeaWgZhcosj3TlgJ5wlwBsL
	 0mGxN6Itd6VG1ZR2Qg0HW2peabNTj1o5Nga9rvVs93KpxdnHyASYJZQRTU2GDJ/iBY
	 Y/Oz8sVXKhtrlLOQb5vMi9/5UR1lPoV9AWbTESzTBMquJ5xrmKaCSAWmj3jG6Bm0k5
	 GnaJrtW5a0ZuUr8F46GrNykMxmCoqYKQL41za3DQjWzf94QyG2VjC/1++/tf4hZxvh
	 jYzrDP6+Z0tSA==
Date: Sun, 31 Dec 2023 16:12:51 +9900
Subject: [PATCH 09/47] xfs: add metadata reservations for realtime rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015434.1815505.11579296729459605393.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
in the data volume to handle expansion of the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtrmap_btree.c |   39 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    2 ++
 2 files changed, 41 insertions(+)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index d788ef60333..cb24c2f7351 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -607,3 +607,42 @@ xfs_rtrmapbt_create_path(
 	*pathp = path;
 	return 0;
 }
+
+/* Calculate the rtrmap btree size for some records. */
+static unsigned long long
+xfs_rtrmapbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_rtrmap_mnr, len);
+}
+
+/*
+ * Calculate the maximum rmap btree size.
+ */
+static unsigned long long
+xfs_rtrmapbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtblocks)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rtrmap_mxr[0] == 0)
+		return 0;
+
+	return xfs_rtrmapbt_calc_size(mp, rtblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+xfs_filblks_t
+xfs_rtrmapbt_calc_reserves(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	/* 1/64th (~1.5%) of the space, and enough for 1 record per block. */
+	return max_t(xfs_filblks_t, mp->m_sb.sb_rgblocks >> 6,
+			xfs_rtrmapbt_max_size(mp, mp->m_sb.sb_rgblocks));
+}
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 29b69866018..b7950e6d45d 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -84,4 +84,6 @@ void xfs_rtrmapbt_destroy_cur_cache(void);
 int xfs_rtrmapbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_imeta_path **pathp);
 
+xfs_filblks_t xfs_rtrmapbt_calc_reserves(struct xfs_mount *mp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

