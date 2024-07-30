Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE1865C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299168; cv=none; b=eFd4esO84pC9A1dgLRsB4AJ69GDXfF7zM2Qa/Q1TjNRV2IYFeVQOwnaKicVGhDj0dPIyZU/5dnB2+6k2WqPbpwXcahxu/toTNIEjtaCthwesY+io9b7PIKizctWoTMjml/+l0kJNvtnsZRFijoxo2D8JDecO3JNSohWamlbdsPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299168; c=relaxed/simple;
	bh=Tlc9hpiZGlN3+Yk6s2ofVOqmZ5A/XZeTGiR3XUrtnVA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fsyoHGeDJUJ9WI4Ken7+VNEuarRwMVwPVE2ayugrZ1q1pD7aPar+8FS8MvscG8zGqb+uCCLHt/MrahdOxPoGh23q9KOSv3KfrAd6PVKVgWP/nuqp/UFDHtAFAOx0OXvBNddWvk1rYHWZoo84MvALul5+C555pvQGY3IWKhjmmLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBSf8GL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBSf8GL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA9BC32786;
	Tue, 30 Jul 2024 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299167;
	bh=Tlc9hpiZGlN3+Yk6s2ofVOqmZ5A/XZeTGiR3XUrtnVA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mBSf8GL4c+cAoK/Ui2mGu+yZcK8VdIxIsPaJ2CioReaIKkmnF51Rwm+2nhd8ZxCYW
	 FdhMjY5AWq+Ku9NIKmfBH7ewvaekT0BaQU4znWmBeTHxtkGP80I8SD7xEeum49/Ft5
	 sije+XllF8DFC8OO0ugdqs1DuXCpYEog2H3E/nRCT7D5zpB38kS8oWrUUHmwTMa1O+
	 Ka7JpUHzFFrXRpLnJOUGxdrQ1mAQiE/eA91Qz8XJV/sQ6KFd77ADczQfE6/fWwq/J2
	 FMaNKqJLXdnTu4XdrPRjcamx4xsaMtQWFYiRXh5aH59bhIqoWIq92gg86e131XGLi7
	 ahVXw5OVQXPSw==
Date: Mon, 29 Jul 2024 17:26:07 -0700
Subject: [PATCH 009/115] xfs: condense directories after a mapping exchange
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842568.1338752.15946879769627221761.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: da165fbde23b84591b6ccdf6749277d2d767b770

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
 libxfs/xfs_exchmaps.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index afe2c2d22..6e758cac1 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -25,6 +25,8 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 
 struct kmem_cache	*xfs_exchmaps_intent_cache;
 
@@ -392,6 +394,42 @@ xfs_exchmaps_attr_to_sf(
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
@@ -415,6 +453,8 @@ xfs_exchmaps_do_postop_work(
 
 		if (xmi->xmi_flags & XFS_EXCHMAPS_ATTR_FORK)
 			error = xfs_exchmaps_attr_to_sf(tp, xmi);
+		else if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode))
+			error = xfs_exchmaps_dir_to_sf(tp, xmi);
 		xmi->xmi_flags &= ~__XFS_EXCHMAPS_INO2_SHORTFORM;
 		if (error)
 			return error;
@@ -879,6 +919,9 @@ xfs_exchmaps_init_intent(
 			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
 	}
 
+	if (S_ISDIR(VFS_I(xmi->xmi_ip2)->i_mode))
+		xmi->xmi_flags |= __XFS_EXCHMAPS_INO2_SHORTFORM;
+
 	return xmi;
 }
 

