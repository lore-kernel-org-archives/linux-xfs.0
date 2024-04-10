Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDB310E5
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710771; cv=none; b=RUGshXlYs5mCvSoqV3cOhKljXJr9d0/VQpg77RxTmV5LMChHj21rjYyxgPyS387VyL88kmhsg8inFDUA4Zk5wOiA3/emRpEDfnwJDVg76xkCi9ShCRwp7Cz/afkHjfvqF/SkIBgaHzG/ntp/pjnOD7QuISvadtww96KHo1SMskE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710771; c=relaxed/simple;
	bh=MlDxcx6B+kdPtyHNHKCenukc1g0DrPF78rAVldA1PNg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TeLitKOf6Hc7Io0f6OmJldvO4adSWrNf5RFLNW+wVZcMmPzZYAQ15GqrJ0myAksXY+aoGv3taQlpXZT3EDPibO+buRslXCfpb+tXw+JDiu1snjs1+QgTvyLnttxGidW9Qfmf08enNFeOYUvzl95QFBS+VeULj+5eaxcoVHuJtdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4wibwz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4wibwz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F15CC433A6;
	Wed, 10 Apr 2024 00:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710771;
	bh=MlDxcx6B+kdPtyHNHKCenukc1g0DrPF78rAVldA1PNg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i4wibwz7GkOxzvcsY+vV7jMtrSDILAmNQxJX+t/LXSiegR7xN3TPW65vJuyrxMxEw
	 +xFrRaIRS1IEqiUqhKbdXFsmCfzFK+9VoedHg8uS6J8EoSPlY+Y7uuCdP6ZfEveKyG
	 oQOlnE8Z2CVsuQmCbzeFC4qFbBOjEw/OzSZc6xfFbkH96+9O0eTbhWy5rPZ6kwxa2s
	 d8OWdzsMVIFdRBckIm56VDW7nHiG4uLSBtQUx/B8Ld0LwLyfMd0TvqEY3A3OgUKzCe
	 NJzgvNT7h3r+DOmdyzXPUE3cXKStDtrI9fgkFA3xeSWiWXpIXVzxowhMQwAiu/e7Rg
	 kbMe+cdRDpc2Q==
Date: Tue, 09 Apr 2024 17:59:30 -0700
Subject: [PATCH 23/32] xfs: Filter XFS_ATTR_PARENT for getfattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969941.3631889.11060276222007768999.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Inspired-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: change this to XFS_ATTR_PRIVATE_NSP_MASK per fsverity patchset]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |    3 +++
 fs/xfs/xfs_xattr.c            |   10 ++++++++++
 2 files changed, 13 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 1395ad1937c53..ebde6eb1da65d 100644
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
index 85e886ee20e03..00b591f6c5ca1 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -20,6 +20,12 @@
 
 #include <linux/posix_acl_xattr.h>
 
+/*
+ * This file defines functions to work with externally visible extended
+ * attributes, such as those in user, system, or security namespaces.  They
+ * should not be used for internally used attributes.  Consider xfs_attr.c.
+ */
+
 /*
  * Get permission to use log-assisted atomic exchange of file extents.
  * Callers must not be running any transactions or hold any ILOCKs.
@@ -215,6 +221,10 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	/* Don't expose private xattr namespaces. */
+	if (flags & XFS_ATTR_PRIVATE_NSP_MASK)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&

