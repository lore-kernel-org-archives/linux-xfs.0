Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CCFD299
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610640; cv=none; b=E4w7gC+ouut9TIqYU0UFTf5y6Hfy/hJq0LyIGdvdjEIqmuKC5bqTjyoLbHM1Bkvds+1+COU1EA2UJFbIaL2PqjEHQCvQ+px/0cx1f1AndjJg3Aa/++Lln2A+53PEukckSQi/Gu1owjvjd6l68QOkDMwcuA4sVbIMXHk82oWeoaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610640; c=relaxed/simple;
	bh=k3AsO8lLX5sSj+GJjQNGODh7f8zwnXfFudgDUtjZKD4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FIFRIp4g4kFjtvJ8uLDLh0vC8smYTjECweEEoyauwu64/xrM+FYmeT1hwvVOdI+qBl2BK8pWry9mG/vhnDcphplxZUcRkbyVKUb3pIcHaccqc4AhOtzlssZ8WTvM4tkUQQU8CDScixi59C5YBEneZveRcmoxSE0EDTQB4yx+WUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaK6Trhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaK6Trhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5AFC4CEC5;
	Fri, 11 Oct 2024 01:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610640;
	bh=k3AsO8lLX5sSj+GJjQNGODh7f8zwnXfFudgDUtjZKD4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GaK6TrhhX13d9Z3B38KIyU0KuXuMAGZ7rl60N/BtotG56vnvzXyQBPygADzxOw02E
	 3QikbFt+laY3vYy8nIR/e9/cIlfJ9+Ok5xxhMKG5VVJkNu/tWRXeg5E4DQ+g8Dda8x
	 SINn6Kc3yGipXaJGg+cT4Gkx2+HIIYy4JWVx2X9BrTR779geUlO+mIlL8qbXTAnobF
	 1/9yUZCpPKNfwvFl3LvMy5Fjmo/oTic/FWDrzE+QQnP6QgxfmK/Tp+b7pX6qbuH/60
	 ZFrz2Ynub/qvgIF8IDfTGA+LyVNAG68cUTTak8vRfO/HgHkETQIqv7/e0Pk7Qlb5bv
	 DEHZ0dn6EWrzw==
Date: Thu, 10 Oct 2024 18:37:19 -0700
Subject: [PATCH 6/7] xfs_repair: try not to trash qflags on metadir
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656465.4186076.3456163232710767618.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
References: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
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

Try to preserve the accounting and enforcement quota flags when
repairing filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |    3 ++-
 repair/phase4.c   |   20 ++++++++++++++++++++
 repair/sb.c       |    3 +++
 3 files changed, 25 insertions(+), 1 deletion(-)


diff --git a/repair/agheader.c b/repair/agheader.c
index 5735bb720d94ec..a9780f8f9aeee0 100644
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
index 05fd886f37ba6a..384916a317f2d4 100644
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
 

