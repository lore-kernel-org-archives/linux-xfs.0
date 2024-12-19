Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C5A198A08
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636954; cv=none; b=R0Wyl+9kWN+N+rNXRcNibZb+uKZHwdQP29poj/j0B1ORs6eJlyVN/+/ti7v0Umi6GQ7t9Ud9YOWYmEoduWOhw1GsZEEZV/nypjsJGqmOJk0iJdE7X3xs6aog5KxuBymbcRyhsTdm4txvoM2HqizuTMHxQklG8S1Z/mLMdf97eCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636954; c=relaxed/simple;
	bh=VR4nj5DPed6O3Zz5wMbrlcYFHjKtHVAl/uMNbPPva2c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=obvHQqR1eUh3nKk9EBYxI5EOhQNQRLUIcfQr5S7BaD92OZiuYJcnTUHbIaX/wFegV0xmLnyfVBV7tQjhqIobWu1RsquCqls9DTyl/lZij2eIkWpNdwIZk41blZy05znZtbAdFQYm7MT7lBS27QAJffQivtFIydIZVs76zB4Dd+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyScOMio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyScOMio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D23C4CECE;
	Thu, 19 Dec 2024 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636954;
	bh=VR4nj5DPed6O3Zz5wMbrlcYFHjKtHVAl/uMNbPPva2c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nyScOMioozKitUGMzUljWPdwrU9kPfcyhPa4h6+6MdJHDXISetGf0cvKYXRRc8lCc
	 G33E0FR5+vaLy9J6vw22d5kxc4pp7+sl/9O1g2+cOh/AIvg86D7hxqouJQdSZ99O+V
	 AT3fGirOoZl6/YO3nESU758O5jT+iVhIK23CpyMc8LlhK8qj59EfQuiACoqxKB0ZlG
	 bBAqIBNSDTaBoniJAI6qCIdZhFEblQ3tNWCnuztT6tktjtOZEa/9dLzkul4ITUB1VY
	 WgO4+WqpCeorHqGs0x+LaLpEpwV73ArlQT6K/FIc7iphFBURdQ+W849s2UsZnCMtQg
	 g7IyVATGwu4uw==
Date: Thu, 19 Dec 2024 11:35:54 -0800
Subject: [PATCH 11/43] xfs: add metadata reservations for realtime refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581166.1572761.8295913118582631382.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   38 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    4 ++++
 fs/xfs/xfs_rtalloc.c                 |    6 +++++
 3 files changed, 48 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index ebbeab112d1412..ff72ed09e75f08 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -419,3 +419,41 @@ xfs_rtrefcountbt_compute_maxlevels(
 	/* Add one level to handle the inode root level. */
 	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
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
+	return xfs_rtrefcountbt_max_size(mp, mp->m_sb.sb_rgextents);
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index b713b33818800c..3cd44590c9304c 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -67,4 +67,8 @@ unsigned int xfs_rtrefcountbt_maxlevels_ondisk(void);
 int __init xfs_rtrefcountbt_init_cur_cache(void);
 void xfs_rtrefcountbt_destroy_cur_cache(void);
 
+xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
+unsigned long long xfs_rtrefcountbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a69967f9d88ead..294aa0739be311 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -31,6 +31,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -1547,6 +1548,11 @@ xfs_rt_resv_init(
 		err2 = xfs_metafile_resv_init(rtg_rmap(rtg), ask);
 		if (err2 && !error)
 			error = err2;
+
+		ask = xfs_rtrefcountbt_calc_reserves(mp);
+		err2 = xfs_metafile_resv_init(rtg_refcount(rtg), ask);
+		if (err2 && !error)
+			error = err2;
 	}
 
 	return error;

