Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4E78F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928684; cv=none; b=ouRTNYxst5/nO46vBW5W9XCA84ED+gVEVE32WBoSPInuDaMO8HcvijUGuwthdBbpIVb+9ml9Rml9Trq4mMw83X+Tgnrk6SBm+hG+EmEeF6UKxMvzz1QoKyWpbtMJT2Ft/eTOaeduiJYCkyzRZsb4YjBMd6vXvt2+6hTEEsHg9kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928684; c=relaxed/simple;
	bh=UAKHi9kCXfQKzU6nFIqFn6/MOXdXoQCzGIU1xInZULA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G1eGF5jGr+gY3n2748hAW/T+UkCYsXYc4jrUa9wMxePOCrm8x1rCH5nF/EDs9zeA13Ctb5atSp0uiTCN28eiFSAByhv2AO9FYf+eyEaZz7CiU/gxAWs5wVMr3FO9nP80zydgnq8z+bEDzz5gwHyxE5Uz/vgJslEF7JtEc/mBaWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUXHSPBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUXHSPBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835F8C116B1;
	Wed, 24 Apr 2024 03:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928684;
	bh=UAKHi9kCXfQKzU6nFIqFn6/MOXdXoQCzGIU1xInZULA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pUXHSPByq1C9BfVrFY7Zu9aE/RqSB42zo8ToLCVrqM6/O79WekoW4Z3LbMKhbqdP7
	 FazM3ISmxSQFmM7gAFFE/uCIhQimxXdhmvUAPH5W331qEEauYFlrSLB8wCAt1MJ5cI
	 D3w2JGUMrTKKzFvzmVGbefZouhZj36FIVTvLpi7l9kDeATvKNSR1HYFcYIZie0NdHO
	 XpicCT3mZ8nK0B/IN5zJ7KF8wNj2f5faEegq7erOlv2diCTtUZ4vaoGZkND9j/XTk+
	 lElj7dDCQuNIK9sUMm34kFJruP0DPWJK/c7btjnLhmfCB2SG5uqswtDUQebyUVXV82
	 dFPrM8p2l7tMQ==
Date: Tue, 23 Apr 2024 20:18:04 -0700
Subject: [PATCH 21/30] xfs: don't return XFS_ATTR_PARENT attributes via
 listxattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783623.1905110.10390052109762926133.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers are internal filesystem metadata.  They're not intended
to be directly visible to userspace, so filter them out of
xfs_xattr_put_listent so that they don't appear in listxattr.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Inspired-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: change this to XFS_ATTR_PRIVATE_NSP_MASK per fsverity patchset]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h |    3 +++
 fs/xfs/xfs_xattr.c            |    4 ++++
 2 files changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 1395ad1937c5..ebde6eb1da65 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -726,6 +726,9 @@ struct xfs_attr3_leafblock {
 					 XFS_ATTR_SECURE | \
 					 XFS_ATTR_PARENT)
 
+/* Private attr namespaces not exposed to userspace */
+#define XFS_ATTR_PRIVATE_NSP_MASK	(XFS_ATTR_PARENT)
+
 #define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
 				 XFS_ATTR_LOCAL | \
 				 XFS_ATTR_INCOMPLETE)
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ba56a9e73144..1e82d11d980f 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -229,6 +229,10 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	/* Don't expose private xattr namespaces. */
+	if (flags & XFS_ATTR_PRIVATE_NSP_MASK)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&

