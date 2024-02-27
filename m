Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2D3168C6
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000593; cv=none; b=FLo30Dev8w5aDksocPeEoJCiQQqRQdCyyt3NRlj4GOHoGk7X/deRDEPYGx/g4Nk5sVzmcSnxZNklanBDMYOuodVjrXggDL2pqywtRAdQGrpUmTFSG3HsYnKZ9y5SN0P5CLiM/ApEk4SU0wE1h33LW/OvD/OlxSXil2afV+4qQoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000593; c=relaxed/simple;
	bh=ADyQESidubPz499NMalrApC1yRWDJLyqXQqWmXRfbWU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LsU237NIXcJlKVRg7iThhh3g38Y8vh8ITkV/wnL1WY3E6W4rp7+xLbIV5gdfymGjD8kuSpwQXL16C/U2bZjhPiuDqLsDKbwNSreT0UlN6L75I7zS2MGqyRTyyofQ2wLDmvcGiNjOi0AWbSzO+wQyyFHbHyHFRpgLBqApRA3KSGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wx7x4T8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wx7x4T8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D34BC433F1;
	Tue, 27 Feb 2024 02:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000593;
	bh=ADyQESidubPz499NMalrApC1yRWDJLyqXQqWmXRfbWU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Wx7x4T8+ZJpIQomV48Pc/2qxSTAU3wgKpe88CSNqeHofTwy1UZV7l2Z5hknTUiTOA
	 p6aCmDR8ObLYlE1yVyfzMplnsJnXmkDMomL7JSkeGZmSs219wdBnX0Fh36BJMVLDun
	 IJISW/XE1n/cqIFf8M38XPRetwZXxI5i7x2HsmZ2scrHt1GGxjRDhUJLeVBBjyVKtf
	 vyVvq6SCyl4QtkozIsqgxKBqI7H67BKPCRik/XcCFvk28UU2Qj270EKI57t7giZcUr
	 +XZ7L8AD7XFfAMU1SbBwKSZPEvRyyH/nXGSOJAn2pWcPhVTA9un+BSXtgDgvX+qlZH
	 wc6cH/K1sBz5w==
Date: Mon, 26 Feb 2024 18:23:12 -0800
Subject: [PATCH 09/14] xfs: condense directories after a mapping exchange
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011790.938268.507293694895114250.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_exchmaps.c |   43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index a2af9ecfe4b01..875f34f4537e0 100644
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
@@ -868,6 +908,9 @@ xfs_exchmaps_init_intent(
 			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
 	}
 
+	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode))
+		xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
+
 	return xmi;
 }
 

