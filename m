Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D11C19048A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990828; cv=none; b=dm/xT+RT9WNeM3Ck6yw2Vuwlzaq7ayMsoLJKD6IYNElbMTQXyjfS2rzUsSowkp8KFDQr7EHh1y4aoGamFt7YImEtxPuwBTZaShwJYmNeGPmUB/cWCnEA8BMZbz+bagIknuQMnuZ4Zsymp59O4UQntaTHq+Y9NgxBNzZ3mqHCamQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990828; c=relaxed/simple;
	bh=2PrKCYZ4oW7FWPRrXs0ud2cF1JDf4Np78gjxr8b1cyY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwaMf/vfkSgt310Ml5xAvo128ztdpz5iePRbNMmpYIxB7B1B6YW1mN4N5GWx+7tDDgKj6GQTHN1o5KcJDtDbOZz/GT3fxVuaZtpwYdrva18li24UrWskHkRdxcnuGKkfovAYwkUKW9kidI3ZErhjBLkJRv2O+FtDrtLdwiJEJvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bk926N69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bk926N69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6097C4CED3;
	Mon, 23 Dec 2024 21:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990828;
	bh=2PrKCYZ4oW7FWPRrXs0ud2cF1JDf4Np78gjxr8b1cyY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bk926N6927kg29gjpskTNnsFKUeLDLSItx48JA76f4x3cgQdz54tbTIk0IeHKZhwH
	 phRARo0y+y0aINVq7V6lP4pjY6sjXnWmSJp8yUcVwbbwKiWfkq7NxmbVkDZiVpTzYD
	 4Ro6d/C7gbjRGbnOrkXed60mS31oRL8XXbyq1caGeFuvGn8HukFdFkcjNzDyP8WbQX
	 dfiZU0nu1prf71kCpe09iBHRuKJJDThafbyVC0zYeyo6pz1Psth2ARW4r7XaoDAZkE
	 ptjAgW7Ras7vE5Y4TS0YLmj4fj2uMex8lPTFgUfuo6SCX+/fisytK7yBrC/+l/hFwC
	 i+TpUtqUeOnGg==
Date: Mon, 23 Dec 2024 13:53:47 -0800
Subject: [PATCH 28/41] xfs_repair: check metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941398.2294268.14575894511791481918.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check whether or not the metadata inode flag is set appropriately.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index e217e037f8862d..5dd7edfa36aed0 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2331,6 +2331,26 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
 	}
 }
 
+static inline bool
+should_have_metadir_iflag(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	if (ino == mp->m_sb.sb_metadirino)
+		return true;
+	if (ino == mp->m_sb.sb_rbmino)
+		return true;
+	if (ino == mp->m_sb.sb_rsumino)
+		return true;
+	if (ino == mp->m_sb.sb_uquotino)
+		return true;
+	if (ino == mp->m_sb.sb_gquotino)
+		return true;
+	if (ino == mp->m_sb.sb_pquotino)
+		return true;
+	return false;
+}
+
 /*
  * returns 0 if the inode is ok, 1 if the inode is corrupt
  * check_dups can be set to 1 *only* when called by the
@@ -2680,6 +2700,27 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			}
 		}
 
+		if (flags2 & XFS_DIFLAG2_METADATA) {
+			xfs_failaddr_t	fa;
+
+			fa = libxfs_dinode_verify_metadir(mp, dino, di_mode,
+					be16_to_cpu(dino->di_flags), flags2);
+			if (fa) {
+				if (!uncertain)
+					do_warn(
+	_("inode %" PRIu64 " is incorrectly marked as metadata\n"),
+						lino);
+				goto clear_bad_out;
+			}
+		} else if (xfs_has_metadir(mp) &&
+			   should_have_metadir_iflag(mp, lino)) {
+			if (!uncertain)
+				do_warn(
+	_("inode %" PRIu64 " should be marked as metadata\n"),
+					lino);
+			goto clear_bad_out;
+		}
+
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
 		    !xfs_has_reflink(mp)) {
 			if (!uncertain) {

