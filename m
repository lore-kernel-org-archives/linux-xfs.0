Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11922192B69
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995178; cv=none; b=AJlBNvkUHm97xK40E+h30H3BUKiNATIBfjWdghdehbZQvvGLQyO+N/M/mk7s0gEgpzjcTn/TbXED83as4g2r0hF+kC8KsRCYFPSj2vYt/QTtKH+Xr3RFQSf/RExzjS/5kWn4G3BEevx680X13k5jZKWRe5PnV5a3tH1CKzo8W3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995178; c=relaxed/simple;
	bh=pg7hqZudTj/KIhLNf8yV7lZOkpomabMfrGjrivY4yKQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fay0KPeGWFPlGfdtm7eVlfUcH6mEBxWgHpb5VzHWGHuQPJ/T+8rK33a5k2Q7QqYj6TJnrzNb8nxReXAnK+AcuUGtQ3yPFRP2hlNQKKF5xN30DM82i+peRc40Es6945hDLuOKJZr1Yj//DegFWA4+hqu5eoG40ABOZXlXpoHVM3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJsXrdDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJsXrdDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC165C4CED3;
	Mon, 23 Dec 2024 23:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995177;
	bh=pg7hqZudTj/KIhLNf8yV7lZOkpomabMfrGjrivY4yKQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rJsXrdDdb4u2Dw1WaF0PAsJG55gFkdobbkEX9WgsGYZ458FavfheZuMfzf1ipojYd
	 BGaa3lmy7TpaZd0EGsmNAhUSSqoDNVc8L1F7b7KQwKWV7sAlPj7FkfWk8/XxS37sjO
	 dTdStWOKiWfDQuICKXnf4Pp1bW6FjwUIr/WVcr0t8MQnri5eSfS2lxMm4ojSD56Y9d
	 ydSKVCLwkbjTILdjO9A/BWF1ouSvWg8Dtvr2V4Qd0V2ifqWIer9HY5R5c47yOnp+NQ
	 N2qpTPH9j0CeiWTDGIbQfIScUXQB+lp4CQW0qzrNTJ8TzcYtx6Hw3k1zvs3PH4m1wh
	 z4+S14uKkAqAQ==
Date: Mon, 23 Dec 2024 15:06:17 -0800
Subject: [PATCH 37/37] xfs: enable realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419356.2380130.5768861561545634710.stgit@frogsfrogsfrogs>
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

Permit mounting filesystems with realtime rmap btrees.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   12 ++++++++----
 fs/xfs/xfs_super.c   |    6 ------
 2 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3c1bce5a4855f2..a69967f9d88ead 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1282,11 +1282,15 @@ xfs_growfs_rt(
 	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
 		goto out_unlock;
 
-	/* Unsupported realtime features. */
+	/* Check for features supported only on rtgroups filesystems. */
 	error = -EOPNOTSUPP;
-	if (xfs_has_quota(mp) && !xfs_has_rtgroups(mp))
-		goto out_unlock;
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (!xfs_has_rtgroups(mp)) {
+		if (xfs_has_rmapbt(mp))
+			goto out_unlock;
+		if (xfs_has_quota(mp))
+			goto out_unlock;
+	}
+	if (xfs_has_reflink(mp))
 		goto out_unlock;
 
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 394fdf3bb53531..ecd5a9f444d862 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1767,12 +1767,6 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_has_rmapbt(mp) && mp->m_sb.sb_rblocks) {
-		xfs_alert(mp,
-	"reverse mapping btree not compatible with realtime device!");
-		error = -EINVAL;
-		goto out_filestream_unmount;
-	}
 
 	if (xfs_has_exchange_range(mp))
 		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_EXCHRANGE);

