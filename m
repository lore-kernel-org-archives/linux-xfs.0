Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5922CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548390; cv=none; b=au6/l7BLVNRpinEh/ZuD5nlEebdXDM/Mvx0SVMlbgoOBPm3prI8bKCllcmDD0hsBfV58Zr4TBXoqsdHNEphRvkeCaFDdN2RtRUI/VNc+hudBF2mfn8a+nCC6VS+TvT8UvGIqBVUrOL4XYNic+Io9iz/uVfcFnPQYDcfRP5KafkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548390; c=relaxed/simple;
	bh=9fpdVgVmxelGa+5Taqc1vU3DXk1nGqO28B8J1NmTmU0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGIlS4vIv780OooicvTJdQ4I+eS2dGCESiVL64T3w3lQwYa6h0rfWRpB9sG8NBH6YBRMtrD/ZqOarypxFwsuXxe7IN7ZInTecwzQi4jQzDTdqsUajoT7jvPv9Ejx8IrxHfuG5/kpLtZYPGTZ/2lPOSIb1uivy08c+dJGLn1s34c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWm45S3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWm45S3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C7CC4CEC3;
	Mon, 21 Oct 2024 22:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548390;
	bh=9fpdVgVmxelGa+5Taqc1vU3DXk1nGqO28B8J1NmTmU0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XWm45S3ZEsU+feSJFh5ucI9tBSl4IblPSewvR3LoFk7JPjlgFP2yp8vQe3vhta7bt
	 BH87rRw5vxcgVstCbnfZsPiylaOBGr6RWXAtX009afs22wf7aaijqxmLIUVQan1jD3
	 NZPUI4AXWu3MBx83hZWiY72uvCTbThWaUwfX0BrRhh0ks9LB2k8GHtnElc2JXfeaQB
	 W6TUNz6ci8oAayh4UjQ4tuMeHuptdeULLeX5uI4XyACFBsk/p7EijDIAh7QZ9MoXX+
	 BLvSyLj0hDTyNviwqZ6gIujQ40VMuIGg58IZ9vTZpkEhoro7LqR6eRZokOtt0P6YJY
	 UGGkw0RN+3xhA==
Date: Mon, 21 Oct 2024 15:06:29 -0700
Subject: [PATCH 29/37] xfs: enable block size larger than page size support
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783910.34558.16123618243296622128.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Pankaj Raghav <p.raghav@samsung.com>

Source kernel commit: 7df7c204c678e24cd32d33360538670b7b90e330

Page cache now has the ability to have a minimum order when allocating
a folio which is a prerequisite to add support for block size > page
size.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20240827-xfs-fix-wformat-bs-gt-ps-v1-1-aec6717609e0@kernel.org # fix folded
Link: https://lore.kernel.org/r/20240822135018.1931258-11-kernel@pankajraghav.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 libxfs/init.c        |    5 +++++
 libxfs/libxfs_priv.h |    1 +
 libxfs/xfs_ialloc.c  |    5 +++++
 libxfs/xfs_shared.h  |    3 +++
 4 files changed, 14 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index 1e45f091dbb5bf..733ab3f1abc557 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -22,6 +22,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "libfrog/platform.h"
+#include "libfrog/util.h"
 #include "libxfs/xfile.h"
 #include "libxfs/buf_mem.h"
 
@@ -44,6 +45,8 @@ int	use_xfs_buf_lock;	/* global flag: use xfs_buf locks for MT */
 
 static int nextfakedev = -1;	/* device number to give to next fake device */
 
+unsigned int PAGE_SHIFT;
+
 /*
  * Checks whether a given device has a mounted, writable
  * filesystem, returns 1 if it does & fatal (just warns
@@ -257,6 +260,8 @@ libxfs_close_devices(
 int
 libxfs_init(struct libxfs_init *a)
 {
+	if (!PAGE_SHIFT)
+		PAGE_SHIFT = log2_roundup(PAGE_SIZE);
 	xfs_check_ondisk_structs();
 	xmbuf_libinit();
 	rcu_init();
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index fa025aeb09712b..97f5003ea53862 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -224,6 +224,7 @@ uint32_t get_random_u32(void);
 #endif
 
 #define PAGE_SIZE		getpagesize()
+extern unsigned int PAGE_SHIFT;
 
 #define inode_peek_iversion(inode)	(inode)->i_version
 #define inode_set_iversion_queried(inode, version) do { \
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 141b2d397b1fe7..43af698fa90903 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -3029,6 +3029,11 @@ xfs_ialloc_setup_geometry(
 		igeo->ialloc_align = mp->m_dalign;
 	else
 		igeo->ialloc_align = 0;
+
+	if (mp->m_sb.sb_blocksize > PAGE_SIZE)
+		igeo->min_folio_order = mp->m_sb.sb_blocklog - PAGE_SHIFT;
+	else
+		igeo->min_folio_order = 0;
 }
 
 /* Compute the location of the root directory inode that is laid out by mkfs. */
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 2f7413afbf46cd..33b84a3a83ff63 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -224,6 +224,9 @@ struct xfs_ino_geometry {
 	/* precomputed value for di_flags2 */
 	uint64_t	new_diflags2;
 
+	/* minimum folio order of a page cache allocation */
+	unsigned int	min_folio_order;
+
 };
 
 #endif /* __XFS_SHARED_H__ */

