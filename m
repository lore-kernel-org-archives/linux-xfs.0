Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573A14A1C
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530774; cv=none; b=p1xUZwfeUUAnyQesMSYZLQG/19O1k10QR1/E56GGDkzMnp3WyxPwBpYuVrd5Vul0SReFHmAVIUQS6kEQWnUP3sPfwerB4XFU20utm1sXKcDiydlxuQtZFmng4vlq5oY+Ti2U3D1XaI4Hdyfc8RwloIdZB5HH7EH7C6WMZTCL+YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530774; c=relaxed/simple;
	bh=5PghecbICmijGbLThgrWHAJvLzQk7W23W/9cDLwsLts=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SuuQ6jOHbjDjGsc4sef7kKk/aXeyZ70VPb5H+I6tYf5+2VA+v1MlbeKBcMrRfP9hRCOxtmeflVEpuuI7Ts4UrQ+Szfw6w00tSPdn22k1ltyz3RTC2mMad+8Hl/TIVacdqvawKG7JtC2kowNg+E9DaVRpqHAdts+Vw+OiINSaLJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaMTXvSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaMTXvSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B08C4CED1;
	Sat,  7 Dec 2024 00:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530774;
	bh=5PghecbICmijGbLThgrWHAJvLzQk7W23W/9cDLwsLts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HaMTXvSIQJtJDr2h83qtM3zcq9fhA0RweGFLlpLfJ2odgRDTc2necdVtsV1jBfqu8
	 Hsq74VxVOQFfvt/9AtrxpNKxjuitzAHeLUjWstW0R1SJ+XSbIjEnU4i5VkyunIKrEZ
	 Vul/j5LzFi+gqO9/eSxpCWshg4kfWYb9Dt6FiYzDetY/IwLWSqw0jcetPoeOsFER6i
	 NrOsMRsuiJSnBFkN1H8XQ5oqUOR+gqAGdhqvs8rHx/VuHZVQX5a7ejpZqJMb/QR64Z
	 gMSJhnReIBzTg2fFBzYF5pt1bBG4vgN4TFxeI6OwoAaL+ypWgljFr+5P9+wXNRmBNZ
	 HQ7573FnTrMfQ==
Date: Fri, 06 Dec 2024 16:19:33 -0800
Subject: [PATCH 6/7] xfs_repair: try not to trash qflags on metadir
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352753324.129683.11573020537942192605.stgit@frogsfrogsfrogs>
In-Reply-To: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
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
 

