Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637E822071
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052387; cv=none; b=t3NsxdGLYjJjdEKPILlls7TW3p4L0elc1rjK0OCcLuPF6bzIgFpI+jJJGSFDil0i8W3UON2b+lmNzhN8wDSEkEeC+2WhMoTZO9mcSd1h+nmW6KYKOar/GQDsxAppxOA4wBOiB6in2DD3in+MedIBjJ0EGNmz8OfeUE4yIsARZXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052387; c=relaxed/simple;
	bh=i6JDGDnwz5DIgSTNh4EVz70qUKAvBfQMb+4TH5xYvE0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swf1+Mio9lSLr33AH30tVfzY6CWpaRzW2XHU/gzq/kpAkSKzzDcI7nYg+uJbHdX+QtiHir/MY2XEm6rz4tFhhrP7TMNaHy0PcRwYADZhFYxpBuYyXcEmNZzrxi2qmK5kM97jq+6bFis3nSzu+5TnutnV0lSxtYSyS9weMlMjijk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ED9jMNsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ED9jMNsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EA2C4CECE;
	Fri, 13 Dec 2024 01:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052387;
	bh=i6JDGDnwz5DIgSTNh4EVz70qUKAvBfQMb+4TH5xYvE0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ED9jMNsc8RGi1wiNNqdKPAxhdFOyfXILLLTth3k7+UmQn46yFzEPdYcF+jdtoCxQ+
	 UZ6hjZwoNGcKTmEkrMOtIfoREvdOlDtIKkklBHc49TKV/ydogjnm283UjGqUTem8by
	 LJNN3Fy3gwL53oUWFW6MnKrsRZ7kVCUAbpZT+JYpY8SqNc2JCYwnG63jDZ3K8wqO+6
	 d1VKIcCxQ0ANOUpukfuJdwJFbO5Mo8YzXIudmfZ437WQrCPEPKJUVrxzAU2yJK9mNW
	 H+45fu2AnQTqs2jYcE/v1//65FbxO3brEn3Ykubi16r/KSSanYooDGVvSD+cFLST9C
	 Ha47QBXjkfcvw==
Date: Thu, 12 Dec 2024 17:13:06 -0800
Subject: [PATCH 11/43] xfs: add metadata reservations for realtime refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124756.1182620.5073398272904938121.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

