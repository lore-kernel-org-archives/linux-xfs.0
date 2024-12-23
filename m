Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8F57462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994756; cv=none; b=JGkX6lfiVj01OHWlIjU1Gf8jv6tBush98Xy1PdRx5SMEXiIK5U8jrY2i7TacfskSWgQWjquLh/cXLQmTMsMaZQmQ1x7HLdE5PGwZmmadKyvFwSk2VCkr9uN/iO4gn74TJ5KsMM9jD4C54119xyOn63G2IvVutQkOXYx0cyGCVRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994756; c=relaxed/simple;
	bh=an6JcxC2BfLPdTbFdsrJg2oWdHoyIg20skUGbVSfWtM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CjCSyZGtZg18AiaUu+Tt0URGWkYPyuaWAB2aFG2gAefYFppJQyvyAstRB4cxAIDVw2UWAj9KMIUunvpnYEVqWgWRziAd3Qy8LZkcjb21aSmUvyDv0Wzwrp96UnanzHbBbnbqwEY6ytkW+n1s9BeuKbLEazLS0VXUo0rze8kFExA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dae9ihGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dae9ihGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE72C4CED3;
	Mon, 23 Dec 2024 22:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994756;
	bh=an6JcxC2BfLPdTbFdsrJg2oWdHoyIg20skUGbVSfWtM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dae9ihGlPH0egRdXmFJaAh4pKfv81UzgQCiIl0Q0wg+qN7Mt0hNHc3bF/PnJpWI1G
	 oYAqx0r8Lmb+tYm8THA6u5rgu06V28cp/66Iyn7c6BwV/WDdBU0OE/jqw+gwuZPr0P
	 9jg8IxYN/aqPIW8c1j7UmSd/at6ISX/rOonEecCHfoZmXQsLNmXVbMiOJBsXh8v9SV
	 tYwVXxOEmnrVKo3I8AfJWz0m4nyK5OcQ/9HLCCTzUtqoybEutcUpxMLSBo/JhLgSgP
	 DpkPrSQ48KgVGitln5TdzVVUDmvTTSGypgt/8o2Z5yOuAhNmyMDacYfJ5k5YVpOos/
	 8i0tD4YD7CwHQ==
Date: Mon, 23 Dec 2024 14:59:15 -0800
Subject: [PATCH 10/37] xfs: pretty print metadata file types in error messages
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499418886.2380130.644456235973168473.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a helper function to turn a metadata file type code into a
printable string, and use this to complain about lockdep problems with
rtgroup inodes.  We'll use this more in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_metafile.c |   18 ++++++++++++++++++
 fs/xfs/libxfs/xfs_metafile.h |    2 ++
 fs/xfs/libxfs/xfs_rtgroup.c  |    3 ++-
 3 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index e151663cc9efd6..2f5f554a36d4c9 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -22,6 +22,24 @@
 #include "xfs_error.h"
 #include "xfs_alloc.h"
 
+static const struct {
+	enum xfs_metafile_type	mtype;
+	const char		*name;
+} xfs_metafile_type_strs[] = { XFS_METAFILE_TYPE_STR };
+
+const char *
+xfs_metafile_type_str(enum xfs_metafile_type metatype)
+{
+	unsigned int	i;
+
+	for (i = 0; i < ARRAY_SIZE(xfs_metafile_type_strs); i++) {
+		if (xfs_metafile_type_strs[i].mtype == metatype)
+			return xfs_metafile_type_strs[i].name;
+	}
+
+	return NULL;
+}
+
 /* Set up an inode to be recognized as a metadata directory inode. */
 void
 xfs_metafile_set_iflag(
diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
index 8d8f08a6071c23..95af4b52e5a75f 100644
--- a/fs/xfs/libxfs/xfs_metafile.h
+++ b/fs/xfs/libxfs/xfs_metafile.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_METAFILE_H__
 #define __XFS_METAFILE_H__
 
+const char *xfs_metafile_type_str(enum xfs_metafile_type metatype);
+
 /* All metadata files must have these flags set. */
 #define XFS_METAFILE_DIFLAGS	(XFS_DIFLAG_IMMUTABLE | \
 				 XFS_DIFLAG_SYNC | \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index a79b734e70440d..9e5fdc0dc55cef 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -282,7 +282,8 @@ xfs_rtginode_ilock_print_fn(
 	const struct xfs_inode *ip =
 		container_of(m, struct xfs_inode, i_lock.dep_map);
 
-	printk(KERN_CONT " rgno=%u", ip->i_projid);
+	printk(KERN_CONT " rgno=%u metatype=%s", ip->i_projid,
+			xfs_metafile_type_str(ip->i_metatype));
 }
 
 /*

