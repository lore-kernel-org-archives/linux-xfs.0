Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BC017BA1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052215; cv=none; b=QU2LcTo6VQ6iGtcb6n7suRZW7iI13LoWawH7iie2W2ZvxE882tkdwC9XQ5W+7SjcBaJLlOCm+A5J3lSfI2z0to5XJlqBqkr7GhkAPnFHAlM1+TZ/Sfj947ru7fyOil3nZwbgfdjRy9x4QcvYJR0TmQyJkVvxpKGKnIPnOD06rw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052215; c=relaxed/simple;
	bh=lcd94iGFG/RIGBiHplSu0ztAyKSUF0xlBN8YAaGQ/ws=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZffmNRsOnhocdubuPL5xwYtlksboUqlWKvrrUjeCih4mbfxXIVkcuhW19b9t5j8OxCBZwubBdlUN/so/FVmeGfj2CY3+SCNmRMymtKPu88RUGUVJeso5+jVSPTAIRVrt+SKJ7Wri/swSzldIIKePU/JpCJX+kcDm+wbI6Gsz58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4Kf/puN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4Kf/puN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6131DC4CECE;
	Fri, 13 Dec 2024 01:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052215;
	bh=lcd94iGFG/RIGBiHplSu0ztAyKSUF0xlBN8YAaGQ/ws=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i4Kf/puNdGY6ZILBKN9fmSuxJ+tTzw34m/b9leAvoy678qhRJnuaDjeBJWKk2Nt7n
	 BbDHzV7wOcMdqp6W7EQ9BOYegWy00eNVGC3K1wK/jBhl9iecdm9zrR9utbmoesL1E5
	 zOfpBFo68Nf8qud5DWXYCwsJ9v1AObslGl8ceC7kiKi4we5d6cqWFHhhxsobH6k8Kz
	 PxmcHlMfa6hXJB6vvzzAoa1gugD0KitN97GhACiz/ky3754qSdxokvbMg4sWjFEHoa
	 zF0FlXdvUlUkPSZ/xkM9U/gfzRGV5XjpOIaD+tmJshF+xQ4KlHp9wa1T6pK9RtoJ2N
	 03dLsAGBDj8+w==
Date: Thu, 12 Dec 2024 17:10:14 -0800
Subject: [PATCH 37/37] xfs: enable realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123951.1181370.218717289433436256.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
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

