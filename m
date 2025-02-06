Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9B12376E2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882200; cv=none; b=krzq8WZWcuMqJoGqDlsuXaHQK7tYCMhwlM/rkG/AfJKSBfKgp8TpM9sJvUhce9HnarUgnFq+en3b9gA9BmmAf4UJSFxetxSnbkKhHn5LhVbxUncEkuog0p64BSLmPYJ9BDaDEz1yfeJGXrk++q42cpeb8xY9SYcFWzJAHzwB8qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882200; c=relaxed/simple;
	bh=0yhEhrlfhJt8YJVoEgqqE0sxH32+NoajAYVJLGx0JUY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQaYg6VYCDe9AFDX34qFxyFLq+pdBbOa0TtdlNM8AZ4lorh8uN3RwTgFmDi3Ab5blw5vb+PdDWrKdOrswxHSWssTZrEXKcym3BwZFNFZKlAcNMKQFbmHvSq6UDdOsIxsGIfmeQLUq3rv5RjzZqEb3D813m04rJ5bLs5r1og5WxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qMJZw3Nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qMJZw3Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C84C4CEDD;
	Thu,  6 Feb 2025 22:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882200;
	bh=0yhEhrlfhJt8YJVoEgqqE0sxH32+NoajAYVJLGx0JUY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qMJZw3Nz2Y5SlOM8kbUxasN2bBNrUdNyigW+PAIiqGVII1lAxEmP06XAe7WvdVy2v
	 j8JSUb6rVp+uSr3AHnMJcBwfoFa3Rq9CEkA02i6YvcA8n+rxQx2SWKSVSSGhlb/b70
	 T+Cy+pelq47qj7oBK8DfgLpG+tnEfgfddi1iycGXFCIejBJdPyOt7/JS9ETrKpwa61
	 6/yhx0DNRBwPntrtSDK245UeS+Vnocfs3keHlXei3siNVoPN1eI+i6u7eFRhpju7F1
	 /S5M6dViacM7OYRE4ygjyUyITt9/YYU5XlyRl8fmgctMz+04rnUbcWIqUHciSHKlIT
	 pTFs/KRcKHOrA==
Date: Thu, 06 Feb 2025 14:49:59 -0800
Subject: [PATCH 01/27] libxfs: compute the rt rmap btree maxlevels during
 initialization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088111.2741033.980299615772826570.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Compute max rt rmap btree height information when we set up libxfs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/init.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 16291466ac86d3..02a4cfdf38b198 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -21,6 +21,7 @@
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_metafile.h"
 #include "libfrog/platform.h"
 #include "libfrog/util.h"
 #include "libxfs/xfile.h"
@@ -598,6 +599,14 @@ xfs_agbtree_compute_maxlevels(
 	mp->m_agbtree_maxlevels = max(levels, mp->m_refc_maxlevels);
 }
 
+/* Compute maximum possible height for realtime btree types for this fs. */
+static inline void
+xfs_rtbtree_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
+}
+
 /* Compute maximum possible height of all btrees. */
 void
 libxfs_compute_all_maxlevels(
@@ -611,10 +620,11 @@ libxfs_compute_all_maxlevels(
 	igeo->attr_fork_offset = xfs_bmap_compute_attr_offset(mp);
 	xfs_ialloc_setup_geometry(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
-
+	xfs_rtbtree_compute_maxlevels(mp);
 }
 
 /* Mount the metadata files under the metadata directory tree. */

