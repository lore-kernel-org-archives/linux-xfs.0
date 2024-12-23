Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B43A7462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995850; cv=none; b=PTLipXa7LTAfOhscAfGm5Xo5g+W3+cE78xglE1N11jBAWI/WDmTvMZWH2WicLf7pJihmorST/z/epKuFuXADh3F6EuPO7iEt5mscEW1AB4vW2xlcZtGpcI/TU/fTuZ+/jDCIsp1+IaX/JoXDIpPH66uOmkcuu2cljx+jv2oVIDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995850; c=relaxed/simple;
	bh=t1AGHJKB1kRXWHia/SoBVirBkJLyb3vM5h0vziFp4V4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rct4CeFY4qazg8m/ZSvOPor5Rdhx3APpfAqX0v6ih2Fh8XQgOQ5dCiXsexJsdUFK8ZGE86pWYqWPqAtisUQjna87HY83ig8N3PakrK/wyj4sbE0eKx62quXA4mtq7FV+zhYV+kq8oyEwYr7yqEouMllTDeXwC53znznxKv75Ihw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vAzEdPZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vAzEdPZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6491C4CED3;
	Mon, 23 Dec 2024 23:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995849;
	bh=t1AGHJKB1kRXWHia/SoBVirBkJLyb3vM5h0vziFp4V4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vAzEdPZE8D957nVg//UTBcKtdSX7IO+6GA7MacPJ8sDrxd1xUsELZ8N8uA1iOCreA
	 OF/OTRmtGFtK/Jhz/OuG7maTCVuO2iDOLNtamQMJJVwHcaQnwNK/gp4a0pmIOBhSNd
	 KobRIlM/LgEmaFiChx4AWegc45hf0vsf88FjrCb9LDpAtc8mmaHBDd0Gd5yJ6hACEU
	 no7HjNy7LlHuE/GCDpMD8KpOVrvYi2F4ggHPsZBKbgow0AoUgYNmKprc6NAFU7eZUL
	 7yvO2WxHDi9a8JZdxJ8nAW0BbvJCK3vrVd+I6QC5CDdNQIhUuP3EAnWyTVj6BQqRVK
	 M9Yi1PZMVNWjA==
Date: Mon, 23 Dec 2024 15:17:29 -0800
Subject: [PATCH 43/43] xfs: enable realtime reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420674.2381378.11267606138410990178.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c |   25 +++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    2 ++
 fs/xfs/xfs_rtalloc.c |    7 +++++--
 fs/xfs/xfs_super.c   |    6 ++++--
 4 files changed, 36 insertions(+), 4 deletions(-)


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
index ecd5a9f444d862..7c3f996cd39e81 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1754,9 +1754,11 @@ xfs_fs_fill_super(
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

