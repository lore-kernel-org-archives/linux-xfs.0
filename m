Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F5E1D0DE6
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416576; cv=none; b=jgbLfipulst1GXPp0bJxvZVpfm8MEHR9MYnaR8zEnsyh2jlmvex5GIKhPcsGYMkrkxUmtLaiW5RBkrvT4mooy4t+GNhTcoEX3Rq+LNYCrAjAJ+FR4HMO134cFgdTyxYQGFOKJ0L65ASRjrMGyasr7lQq0R5nqjW+/XSNlKfiW1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416576; c=relaxed/simple;
	bh=9fpdVgVmxelGa+5Taqc1vU3DXk1nGqO28B8J1NmTmU0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XsvmBl+GU/YoYdGTJ6YOrBmEaqp6Vpt6SIVqSxyK8QUxuCSh6ER1h0gdMk9Ko1s/3R2MS6DCh6HAHZbejcnJJgPdSGjRAN/oBj+bSjvnOpjlRXCox/tAMVffOn4rcZSRSvw7i6jWXdJ3qi0em3GpnTOvwzwdnvlWiT+VF+2jElw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g42Z3rQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g42Z3rQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99043C4CEC3;
	Thu, 31 Oct 2024 23:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416575;
	bh=9fpdVgVmxelGa+5Taqc1vU3DXk1nGqO28B8J1NmTmU0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g42Z3rQnkpydWHkDJcIoPi2LSGTYogJtHXqQK2Zo7XW6cuqystXCG31cM+tOhXCcr
	 cQcU9H3dHFQ5VvXlG02cW+0f2Wth6nWm0NZdjfPiINyFZlbeYvhsTOQrSgnGUKthql
	 Me+dA0N/HmZLJ2WZVwAa13R/eDBXz9X2JASA87gtYEDogikLIG4y2PrIyumgYS3RSq
	 mV+K+4P/BumccRzTHHNksn3YI/ZOeljXCdkKHw+IFf0u/O091/4ssqTVZ9MYJaQze8
	 fNPMUesi0DX/gEWjxUh4NRrxunZtH31v5oXPEPvXSrFhXHEi9WLxBvwPK+5r678NDk
	 qRiBp5B0hCdOA==
Date: Thu, 31 Oct 2024 16:16:15 -0700
Subject: [PATCH 29/41] xfs: enable block size larger than page size support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566360.962545.12986251378292080145.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
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

