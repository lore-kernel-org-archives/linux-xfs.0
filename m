Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25FD2417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882450; cv=none; b=p5OHn5cOs2k9lIEuvEtg7Mk+4yfdPyf7k7B2vdVjKu/MTJtbg8ML8tiG0ct7twMXcvqOxnHwEr0DtWH5pbppYWllGcUTeg1xEC5YW3Ex+EQqdtkB3W+qa4rq8gRYsC8VOgdFC6QMOrVlN/t3MS3GlVlNo5Mz2RaNojOAELBaS4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882450; c=relaxed/simple;
	bh=yboaoym6MpI/cFBHoEiy6fOWf/01Ih3dTw0GLQGj25c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MPdaEbkBiwy4lsBUZDgX+9j5w2vSSNHj/miHcS1ruCuCDv7YKTp0QLTCpOE4F38XgiG7+aReVDVMoTwBxPz/Tqr2DaSlAEkC3tJI1r/LoAjD+7TAx8hWQfqR1soCAqmLXyz720PGMIJgPJ6ThgQo3hHus9KPhmPXXmy7Tabwakk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LByeJ71l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LByeJ71l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A486C4CEDD;
	Thu,  6 Feb 2025 22:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882450;
	bh=yboaoym6MpI/cFBHoEiy6fOWf/01Ih3dTw0GLQGj25c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LByeJ71lwZlVG4on97cAyIeoDMXBbwU+T+a3Uv1byb/zmlmSLFCABXgpcYr6TLY3v
	 HUUsk9OWDnX04UsXN0AbAmzujf6/41mJghODqWkfXauPP+JRGst+Ey5KzN/d41TEIN
	 ZcWFcIw4DUxz3MdWlsVYrPmbRZP6rqIIZcZcohvW/9OD+XklNJod9l0FofNhBWbY9l
	 dn/PAIbSOckzLMOlM1BUaFMLGISohbOP37PMCogj7fTqBGXS2wET9ivTXqRizvCBMP
	 Im7PunXWNtzTSQWrbXmcwLGOcex2cfCBSyjMZPUTz96R1UnaNodRpir8LQBWDqdr4T
	 bLZrkMWfqYqPQ==
Date: Thu, 06 Feb 2025 14:54:10 -0800
Subject: [PATCH 17/27] xfs_repair: refactor realtime inode check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088356.2741033.18413230775534572246.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Refactor the realtime bitmap and summary checks into a helper function.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c |   87 +++++++++++++++++++++++++------------------------------
 1 file changed, 39 insertions(+), 48 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 3f78eb064919be..628f02714abc05 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1798,6 +1798,39 @@ check_dinode_mode_format(
 	return 0;	/* invalid modes are checked elsewhere */
 }
 
+static int
+process_check_rt_inode(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dinoc,
+	xfs_ino_t		lino,
+	int			*type,
+	int			*dirty,
+	int			expected_type,
+	const char		*tag)
+{
+	xfs_extnum_t		dnextents = xfs_dfork_data_extents(dinoc);
+
+	if (*type != expected_type) {
+		do_warn(
+_("%s inode %" PRIu64 " has bad type 0x%x, "),
+			tag, lino, dinode_fmt(dinoc));
+		if (!no_modify)  {
+			do_warn(_("resetting to regular file\n"));
+			change_dinode_fmt(dinoc, S_IFREG);
+			*dirty = 1;
+		} else  {
+			do_warn(_("would reset to regular file\n"));
+		}
+	}
+	if (mp->m_sb.sb_rblocks == 0 && dnextents != 0)  {
+		do_warn(
+_("bad # of extents (%" PRIu64 ") for %s inode %" PRIu64 "\n"),
+			dnextents, tag, lino);
+		return 1;
+	}
+	return 0;
+}
+
 /*
  * If inode is a superblock inode, does type check to make sure is it valid.
  * Returns 0 if it's valid, non-zero if it needs to be cleared.
@@ -1811,8 +1844,6 @@ process_check_metadata_inodes(
 	int			*type,
 	int			*dirty)
 {
-	xfs_extnum_t		dnextents;
-
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
@@ -1854,52 +1885,12 @@ process_check_metadata_inodes(
 		}
 		return 0;
 	}
-
-	dnextents = xfs_dfork_data_extents(dinoc);
-	if (lino == mp->m_sb.sb_rsumino ||
-	    is_rtsummary_inode(lino)) {
-		if (*type != XR_INO_RTSUM) {
-			do_warn(
-_("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
-				lino, dinode_fmt(dinoc));
-			if (!no_modify)  {
-				do_warn(_("resetting to regular file\n"));
-				change_dinode_fmt(dinoc, S_IFREG);
-				*dirty = 1;
-			} else  {
-				do_warn(_("would reset to regular file\n"));
-			}
-		}
-		if (mp->m_sb.sb_rblocks == 0 && dnextents != 0)  {
-			do_warn(
-_("bad # of extents (%" PRIu64 ") for realtime summary inode %" PRIu64 "\n"),
-				dnextents, lino);
-			return 1;
-		}
-		return 0;
-	}
-	if (lino == mp->m_sb.sb_rbmino ||
-	    is_rtbitmap_inode(lino)) {
-		if (*type != XR_INO_RTBITMAP) {
-			do_warn(
-_("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
-				lino, dinode_fmt(dinoc));
-			if (!no_modify)  {
-				do_warn(_("resetting to regular file\n"));
-				change_dinode_fmt(dinoc, S_IFREG);
-				*dirty = 1;
-			} else  {
-				do_warn(_("would reset to regular file\n"));
-			}
-		}
-		if (mp->m_sb.sb_rblocks == 0 && dnextents != 0)  {
-			do_warn(
-_("bad # of extents (%" PRIu64 ") for realtime bitmap inode %" PRIu64 "\n"),
-				dnextents, lino);
-			return 1;
-		}
-		return 0;
-	}
+	if (lino == mp->m_sb.sb_rsumino || is_rtsummary_inode(lino))
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTSUM, _("realtime summary"));
+	if (lino == mp->m_sb.sb_rbmino || is_rtbitmap_inode(lino))
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTBITMAP, _("realtime bitmap"));
 	return 0;
 }
 

