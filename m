Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54D11CD3B
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504511; cv=none; b=dKxD+QXlMZgZFR44kclCjXW95DmVP0h+Ac94P0u5s8Op6qNVGql0XL4CnO7X3J7G0KxxqxvBdeBtx8G5C32a1EzGFv5qvGiNGj3nJT6QJa9Ahjv5w0UCSgx1jYVwpsAbRqKSLjWoKX1IfLXnt5o9cPVZv9Hmv5h009L9iem7YHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504511; c=relaxed/simple;
	bh=7B7T8wI2H2Yn7aw7hNrDvVDir5I0YSe5QFcq9CpLD2Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dLM9zQkvGzRxUpnY/cQ6TT5vwFZVeT0X5FRW7bf4/1b605H4LbyLHQMr8F04fHGitq1o5f9u9iy2DQa45s0GwjleO7XHRyF87mvzSHcWr2lXaCky/AO4q8NtsUQA/sY+vDiJIkE9wu/tCzVuIvlmMlvplkeDF0Cm6fvIsBwtTwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EM48KyIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EM48KyIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A33C43390;
	Wed, 27 Mar 2024 01:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504511;
	bh=7B7T8wI2H2Yn7aw7hNrDvVDir5I0YSe5QFcq9CpLD2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EM48KyIKfgLFY6aea2gH9HZrM9oi8Pxriz1AUB8qFrwgUW6sGNHHO+gn2XfR0JxH2
	 VDGSsgf1lOvJp7DgbIFeiVBCji6+oNNui0APflYRXiUZi5An4WMIxtcatKaTKGQkCT
	 vz3d8K3qkxVoozJRqLks7nc4G4/953ufsyj4tzNqpFe86/SfEkwtx5U6FeOFCDESEP
	 YflNii/5hQmawBqaX2UBtuPJ6T1ce3pcONWRcKsfWecOlW3GIhgloKOmKLdQdgD8AJ
	 u0EXScUtwu/FNs8a7C0fRxmanULKHbRn8LAHJDdnKDLIZ/8Jz95FRD1t7O77kMZG8J
	 hRP5nVup/Ebhw==
Date: Tue, 26 Mar 2024 18:55:11 -0700
Subject: [PATCH 09/15] xfs: condense directories after a mapping exchange
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380817.3216674.17321182495283794053.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
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

The previous commit added a new file mapping exchange flag that enables
us to perform post-swap processing on file2 once we're done exchanging
extent mappings.  Now add this ability for directories.

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online directory repair feature can
create salvaged dirents in a temporary directory and exchange the data
fork mappings when ready.  If one file is in extents format and the
other is inline, we will have to promote both to extents format to
perform the exchange.  After the exchange, we can try to condense the
fixed directory down to inline format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_exchmaps.c |   43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index a4578231ed3e3..065d879a2fa9f 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -28,6 +28,8 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 
 struct kmem_cache	*xfs_exchmaps_intent_cache;
 
@@ -395,6 +397,42 @@ xfs_exchmaps_attr_to_sf(
 	return xfs_attr3_leaf_to_shortform(bp, &args, forkoff);
 }
 
+/* Convert inode2's block dir fork back to shortform, if possible.. */
+STATIC int
+xfs_exchmaps_dir_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi)
+{
+	struct xfs_da_args	args = {
+		.dp		= xmi->xmi_ip2,
+		.geo		= tp->t_mountp->m_dir_geo,
+		.whichfork	= XFS_DATA_FORK,
+		.trans		= tp,
+	};
+	struct xfs_dir2_sf_hdr	sfh;
+	struct xfs_buf		*bp;
+	bool			isblock;
+	int			size;
+	int			error;
+
+	error = xfs_dir2_isblock(&args, &isblock);
+	if (error)
+		return error;
+
+	if (!isblock)
+		return 0;
+
+	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, &bp);
+	if (error)
+		return error;
+
+	size = xfs_dir2_block_sfsize(xmi->xmi_ip2, bp->b_addr, &sfh);
+	if (size > xfs_inode_data_fork_size(xmi->xmi_ip2))
+		return 0;
+
+	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
+}
+
 /* Clear the reflink flag after an exchange. */
 static inline void
 xfs_exchmaps_clear_reflink(
@@ -418,6 +456,8 @@ xfs_exchmaps_do_postop_work(
 
 		if (xmi->xmi_flags & XFS_EXCHMAPS_ATTR_FORK)
 			error = xfs_exchmaps_attr_to_sf(tp, xmi);
+		else if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode))
+			error = xfs_exchmaps_dir_to_sf(tp, xmi);
 		xmi->xmi_flags &= ~__XFS_EXCHMAPS_INO2_SHORTFORM;
 		if (error)
 			return error;
@@ -882,6 +922,9 @@ xfs_exchmaps_init_intent(
 			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
 	}
 
+	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode))
+		xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
+
 	return xmi;
 }
 

