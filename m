Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD8D188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992798; cv=none; b=Swj89i4KMjNNarw1tjgolDt+1c5yvZjj6DiT8A9I1hR5WLn5PodxjleB13vRgBVOi6vs7fP5agrLgLARKSTpg9x6/lDd88T9P6e1IKgzDaSKT7BPsJQZOwo2xTmGAv+2gr30+zQ7kNiCtSf5abpvxTpiZaVnvm21eELU8bjVO/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992798; c=relaxed/simple;
	bh=hGQtgBmomX1gzZ8fzZS5UVeKoRNPARCVZrZn4I92SjE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QyNLzbU/v/Hp6A9dRDMp0a5uLODWV/c9tOZRSF0LQqUH+PNC0iFEkucWOtuWx5ktOhw7LwtO3T7lFaPojMzCrItiIKqYZ6y6CI0rmJYq0ku18wnnpB0nMQ5A/M/UJtOjpqVAMtQIZWusJnKyFn6Pogvlb/wXJftH6fUjMeodUb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sxHQRAOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sxHQRAOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180F3C4CED3;
	Mon, 23 Dec 2024 22:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992798;
	bh=hGQtgBmomX1gzZ8fzZS5UVeKoRNPARCVZrZn4I92SjE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sxHQRAOatZkPW1hJ3e0Ec9H7rMaLYwDqTjzKMWDuewpOD0Vu0QvjkjDnpbJ+4xYey
	 maEwcsFdl7Qzt1roVswmkkG8k36JfIYyFd2I/4udKdkr/5zQnOvcuVmLcu/rRRf/5h
	 mkkKI69M2SVcBpYbDV6tC/jEIfJHRzy7T2gO5LS6b16P3JC8GBdczHwu80D78/QyL1
	 MNQJBLWwk2do6yH/uwHgdUxJORindo3jooZdaV+0KCFIQK3t0YTj6vI8f4SLO1EcSK
	 byM0mAYG4wLdT7EPBRC1kXpUtm/UN23lVBQEpdVr3N+LWL/ouyQTlgzasy9ztoLtf/
	 nLmE1RWC1/4dA==
Date: Mon, 23 Dec 2024 14:26:37 -0800
Subject: [PATCH 6/7] xfs_repair: try not to trash qflags on metadir
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498945060.2299261.8688192402506588666.stgit@frogsfrogsfrogs>
In-Reply-To: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
References: <173498944956.2299261.16768993427453132101.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Try to preserve the accounting and enforcement quota flags when
repairing filesystems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/agheader.c |    3 ++-
 repair/phase4.c   |   20 ++++++++++++++++++++
 repair/sb.c       |    3 +++
 3 files changed, 25 insertions(+), 1 deletion(-)


diff --git a/repair/agheader.c b/repair/agheader.c
index e6fca07c6cb4c9..89a23a869a02e4 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -642,7 +642,8 @@ verify_set_agheader(xfs_mount_t *mp, struct xfs_buf *sbuf, xfs_sb_t *sb,
 			sb->sb_fdblocks = 0;
 			sb->sb_frextents = 0;
 
-			sb->sb_qflags = 0;
+			if (!xfs_has_metadir(mp))
+				sb->sb_qflags = 0;
 		}
 
 		rval |= XR_AG_SB;
diff --git a/repair/phase4.c b/repair/phase4.c
index a4183c557a1891..728d9ed84cdc7a 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -71,6 +71,26 @@ quotino_check(
 static void
 quota_sb_check(xfs_mount_t *mp)
 {
+	if (xfs_has_metadir(mp)) {
+		/*
+		 * Metadir filesystems try to preserve the quota accounting
+		 * and enforcement flags so that users don't have to remember
+		 * to supply quota mount options.  Phase 1 discovered the
+		 * QUOTABIT flag (fs_quotas) and phase 2 discovered the quota
+		 * inodes from the metadir for us.
+		 *
+		 * If QUOTABIT wasn't set but we found quota inodes, signal
+		 * phase 5 to add the feature bit for us.  We do not ever
+		 * downgrade the filesystem.
+		 */
+		if (!fs_quotas &&
+		    (has_quota_inode(XFS_DQTYPE_USER) ||
+		     has_quota_inode(XFS_DQTYPE_GROUP) ||
+		     has_quota_inode(XFS_DQTYPE_PROJ)))
+			fs_quotas = 1;
+		return;
+	}
+
 	/*
 	 * if the sb says we have quotas and we lost both,
 	 * signal a superblock downgrade.  that will cause
diff --git a/repair/sb.c b/repair/sb.c
index d52ab2ffeaf28c..0e4827e046780b 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -233,6 +233,9 @@ find_secondary_sb(xfs_sb_t *rsb)
         if (!retval)
                 retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES, BSIZE);
 
+	if (retval && xfs_sb_version_hasmetadir(rsb))
+		do_warn(_("quota accounting and enforcement flags lost\n"));
+
 	return retval;
 }
 

