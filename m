Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE707ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuLxU774"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6E5C433C8;
	Mon,  1 Jan 2024 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068410;
	bh=VYKmPvAbGm3z9dxjhV/JrrVda1K1PQQA+kAOUSxzmYw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FuLxU774JI7abD48fH/5Z6Dq0gPwReg8t2JYYPdqqrh9GZoA1GbKf7Lk0HDmBzItl
	 01Zn/gZe3E/TqDgzf30I4F9iju30M17Jn4hOyxs+e3rI1PNL3lLwV8uplzp0zAaWhI
	 I1wCbjcVyjnHSG8SyQjzvPhmVmjyPTAyPJX7svp+yqB0BhJPE3vYqM0x18oxe8WQmE
	 NIxi9pSJrg7t1UsS3QChOP0LztiSRprRy5uZADPYSxbtv+BWCQDXKJcFu2xVROKf2v
	 NEkdBnMXMlOAHVeMo/X1V+3eJM4zhZUy1z7LIw/aPWe6txfYohpFYAfGet+lMzikwQ
	 5Nt3zvrWDxrzg==
Date: Sun, 31 Dec 2023 16:20:09 +9900
Subject: [PATCH 37/47] xfs_repair: refactor realtime inode check
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015807.1815505.13941798952905368669.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Refactor the realtime bitmap and summary checks into a helper function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   84 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 39 insertions(+), 45 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index d88bd80783c..450f19eba4f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1736,6 +1736,39 @@ check_dinode_mode_format(
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
@@ -1749,8 +1782,6 @@ process_check_sb_inodes(
 	int			*type,
 	int			*dirty)
 {
-	xfs_extnum_t		dnextents;
-
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
@@ -1792,49 +1823,12 @@ process_check_sb_inodes(
 		}
 		return 0;
 	}
-	dnextents = xfs_dfork_data_extents(dinoc);
-	if (lino == mp->m_sb.sb_rsumino) {
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
-	if (lino == mp->m_sb.sb_rbmino) {
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
+	if (lino == mp->m_sb.sb_rsumino)
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTSUM, _("realtime summary"));
+	if (lino == mp->m_sb.sb_rbmino)
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTBITMAP, _("realtime bitmap"));
 	return 0;
 }
 

