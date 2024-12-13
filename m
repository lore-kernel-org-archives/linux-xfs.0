Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5944710F7
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052888; cv=none; b=I1bRsxSMzkho3PEtZVx5iTGFvlhCQF5pmxial6iFIZSUUOR3ZMZNn/IS2x/8s6oJFmHOHbYeS1Ilk1GoC795CAowKDxEDR2ooLgMdyxexlwY/3ro5D4NeVC4UXQXG3pIMRNOkIymslTtcx3Us/Fqismd9NP959rox5Ou3GxCaGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052888; c=relaxed/simple;
	bh=KOmz2M9ASDxHONAvm3XgiWQKkM+6/7dKPDn3geX+9MA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ch7eHYaU/2/5iyRiH4EPCVE5+ZYuG0+qUH9Q58qs0MiSwHF4zeVP+iM3cQmzFeDFW3tjU/5lpITfQUH1WwKKtE65yuY2TqTI4MhAexhAJAODFmN9CKk2dAXZiug6HJXTYpK5vJe8QWhFD8iZcEtW0r4MbvLZuu6s9VUCSky3Wd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdpQal7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdpQal7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3854AC4CECE;
	Fri, 13 Dec 2024 01:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052888;
	bh=KOmz2M9ASDxHONAvm3XgiWQKkM+6/7dKPDn3geX+9MA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kdpQal7BTl1T1hWedXb4vorkhJOSunohmOlFuyQ9KTGjTcMtB4IiP5S6FbMh2yWLP
	 ZseQY+Tv00IJpqsbm+aco9Cwq0AoIUb58YtajMorEoO7tJpEh5POCxI7FfPi63sGaw
	 HG7Yr9zYKivT6+KV00gab5hi+9wN8x+hUGSiVjl6lhV2dL7kF1mCcC1CkWj5xQvf6z
	 oY7PTx9ofhRBapqDyzDI9iRQTxEK5DDTmjpI2w/kAeLTfS/YqjgzywFQGDhI1sYP/k
	 4tFu+l0AtSBG0QAlnQLYLIGsoZcn5fICoH5bA4Jz+PdC0bOLg0n/aUmUidxRgRlB5w
	 N8o74Rcou9hSA==
Date: Thu, 12 Dec 2024 17:21:27 -0800
Subject: [PATCH 43/43] xfs: enable realtime reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125304.1182620.11655711195171869232.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enable reflink for realtime devices, as long as the realtime allocation
unit is a single fsblock.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   25 +++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    2 ++
 fs/xfs/xfs_rtalloc.c |    7 +++++--
 fs/xfs/xfs_super.c   |   15 ++++++++++++---
 4 files changed, 44 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d9b33e22c17669..59f7fc16eb8093 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1822,3 +1822,28 @@ xfs_reflink_unshare(
 	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/*
+ * Can we use reflink with this realtime extent size?  Note that we don't check
+ * for rblocks > 0 here because this can be called as part of attaching a new
+ * rt section.
+ */
+bool
+xfs_reflink_supports_rextsize(
+	struct xfs_mount	*mp,
+	unsigned int		rextsize)
+{
+	/* reflink on the realtime device requires rtgroups */
+	if (!xfs_has_rtgroups(mp))
+	       return false;
+
+	/*
+	 * Reflink doesn't support rt extent size larger than a single fsblock
+	 * because we would have to perform CoW-around for unaligned write
+	 * requests to guarantee that we always remap entire rt extents.
+	 */
+	if (rextsize != 1)
+		return false;
+
+	return true;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 3bfd7ab9e1148a..cc4e92278279b6 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -62,4 +62,6 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
 extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
 		xfs_extlen_t cowextsize, unsigned int remap_flags);
 
+bool xfs_reflink_supports_rextsize(struct xfs_mount *mp, unsigned int rextsize);
+
 #endif /* __XFS_REFLINK_H */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7135a6717a9e11..d8e6d073d64dc9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,6 +32,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_reflink.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -1292,8 +1293,10 @@ xfs_growfs_rt(
 			goto out_unlock;
 		if (xfs_has_quota(mp))
 			goto out_unlock;
-	}
-	if (xfs_has_reflink(mp))
+		if (xfs_has_reflink(mp))
+			goto out_unlock;
+	} else if (xfs_has_reflink(mp) &&
+		   !xfs_reflink_supports_rextsize(mp, in->extsize))
 		goto out_unlock;
 
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ecd5a9f444d862..0fa7b7cc75c146 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1754,14 +1754,23 @@ xfs_fs_fill_super(
 		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_METADIR);
 
 	if (xfs_has_reflink(mp)) {
-		if (mp->m_sb.sb_rblocks) {
+		if (xfs_has_realtime(mp) &&
+		    !xfs_reflink_supports_rextsize(mp, mp->m_sb.sb_rextsize)) {
 			xfs_alert(mp,
-	"reflink not compatible with realtime device!");
+	"reflink not compatible with realtime extent size %u!",
+					mp->m_sb.sb_rextsize);
 			error = -EINVAL;
 			goto out_filestream_unmount;
 		}
 
-		if (xfs_globals.always_cow) {
+		/*
+		 * always-cow mode is not supported on filesystems with rt
+		 * extent sizes larger than a single block because we'd have
+		 * to perform write-around for unaligned writes because remap
+		 * requests must be aligned to an rt extent.
+		 */
+		if (xfs_globals.always_cow &&
+		    (!xfs_has_realtime(mp) || mp->m_sb.sb_rextsize == 1)) {
 			xfs_info(mp, "using DEBUG-only always_cow mode.");
 			mp->m_always_cow = true;
 		}

