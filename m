Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F9823C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881589; cv=none; b=kSHfnqn4MDjUUJW/QS9RZzuvRCgFg9q10uf1qHkCvPCSnG+SixMKy6j7XNd6rD4d7W8rfPYf9HwfEYl6GsqzUFkC5lZIx8uk0Be6j2R1eyoSG/EsvecVO1f5IVCnT0x4rFXUl3rGDAkDhUW9v+ZAhzRE9Fx5fwjypzZbJMkkcww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881589; c=relaxed/simple;
	bh=PxFGfrtLnpbjGVs/E6XB0jMYVmPyRpIR8Et4FEswRBY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aI5SAggF45RsPOcBM1e+IXPgX/frG+ACpRmlPzncfDzXd1QI7hSNG/K32e+Bw5K2PdblYWZSq+vuU44i4RKcGh6uN4ltZPDhkj0V8+b7fFBL0/QJWl+D82axskix3qTrl2Zcb8ZCZ9DVhSwn8ZquG93FHhClVUXe1WwC5W793Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YU8DJYKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YU8DJYKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9648DC4CEDD;
	Thu,  6 Feb 2025 22:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881588;
	bh=PxFGfrtLnpbjGVs/E6XB0jMYVmPyRpIR8Et4FEswRBY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YU8DJYKHhwzpbhsx+xZjb9kLZg/rt++nRKV/GHPj+AY57T620u20tgch3IVbXdwWS
	 hijuYfX3jjWp99rYekzjeX8xL2oqbbPP5RgqXFbm3akbstHhPLGB47NkWYhJp2qO5b
	 OPnaOsLXeDljxDM7t1wGpD/zkXWVlltChprVhomovQRMRpOJBzWvnhJ6/GBCHEoDkz
	 suyyYLnoh/zkCit+68BdYAUdbUjDTU7GWF+f/Z1u1ByI1hZYgsoZBGVookXkT2/GS5
	 tov8n4xWhhyuORDMkxXZISBirjiYA8n+xYwEeBqQilaPH17lHvGJloJWnmo9hSQcCq
	 oVmBJvHQ5cJrA==
Date: Thu, 06 Feb 2025 14:39:48 -0800
Subject: [PATCH 18/56] xfs: pretty print metadata file types in error messages
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087067.2739176.7226564621742819045.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 219ee99d3673ded7abbc13ddd4d7847e92661e2c

Create a helper function to turn a metadata file type code into a
printable string, and use this to complain about lockdep problems with
rtgroup inodes.  We'll use this more in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_metafile.c |   18 ++++++++++++++++++
 libxfs/xfs_metafile.h |    2 ++
 libxfs/xfs_rtgroup.c  |    3 ++-
 3 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 7f673d706aada8..4488e38a87345a 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -20,6 +20,24 @@
 #include "xfs_errortag.h"
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
diff --git a/libxfs/xfs_metafile.h b/libxfs/xfs_metafile.h
index 8d8f08a6071c23..95af4b52e5a75f 100644
--- a/libxfs/xfs_metafile.h
+++ b/libxfs/xfs_metafile.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_METAFILE_H__
 #define __XFS_METAFILE_H__
 
+const char *xfs_metafile_type_str(enum xfs_metafile_type metatype);
+
 /* All metadata files must have these flags set. */
 #define XFS_METAFILE_DIFLAGS	(XFS_DIFLAG_IMMUTABLE | \
 				 XFS_DIFLAG_SYNC | \
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index e422a7bc41a55e..b9da90c5062dc1 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -279,7 +279,8 @@ xfs_rtginode_ilock_print_fn(
 	const struct xfs_inode *ip =
 		container_of(m, struct xfs_inode, i_lock.dep_map);
 
-	printk(KERN_CONT " rgno=%u", ip->i_projid);
+	printk(KERN_CONT " rgno=%u metatype=%s", ip->i_projid,
+			xfs_metafile_type_str(ip->i_metatype));
 }
 
 /*

