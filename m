Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3146206279
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528802; cv=none; b=slNjZjqSRN/LzpYAoAaIpDTjJqQ28M6oCyMbHZS5yYT+US/+pc8Lbu8toBR8l+Nxo2vZiiOiLksCWZosItr5le+favw/0sT+pKSmZvykq2Xbz0LhtvCTPCJWsl26OqOcjeQVflnnwhCeVGN5vrnLgFeqX6SYHD/Gw3cYqbMCdh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528802; c=relaxed/simple;
	bh=9KUowI7FS5Ga+yWn5Ep53DDX9DaK9yjlzS2z3xV0hTs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N1s/ygDAJIz0rAskSsJ2LNaQUmAgUa9cCT7Br4Ubnmrc8QAU7irhLNEcLzPRqBVbL5+JvOdWlQb1KkHw7Dxnb4H9PrzG8vin/39bKt0OOVVbJbUkEIn9jS29hap/43XFNrqTDtmEs0jVOkPjtdZh+rcRt1RkzJ5qAd8EjIpHPX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUNKI5dI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUNKI5dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73405C4CED1;
	Fri,  6 Dec 2024 23:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528801;
	bh=9KUowI7FS5Ga+yWn5Ep53DDX9DaK9yjlzS2z3xV0hTs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QUNKI5dIT8P/N75bw17s+GtxbDBwbzP1fBrw+q+u1N5FQR2aj3o8kRDVsxYURmb4J
	 +Bdfxd4MVVBxdZc0mHXUnDq3vi+HvcZH7ABg8bTssN21x02791oq1IhoZVbj8C0XGa
	 xbn0Do8Tsv1eU572MFgPCXdiWS72PPFwob3yMGQlpzd78lihOzoWodEYdqINUvv/Zu
	 DxZVIIcrRWfCAGZaVrjWjkfbWW6bItz0zv7OBdKEHREcsvVp5dZ6ypmjhn0wLepqWV
	 foXPeKWx3Ik2tePLuUFC9atLxDDItU2gKtXWCef+/C07VCU/mPCNbCCAfsTfZOYmpN
	 /sX99LX9GdEUg==
Date: Fri, 06 Dec 2024 15:46:41 -0800
Subject: [PATCH 27/41] xfs_repair: check metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748649.122992.6460939534773270786.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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
---
 repair/dinode.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 12a12f00672776..f21a4dd387331b 100644
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

