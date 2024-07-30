Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE68BE8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302785; cv=none; b=jpzxhv/mIFUjxK386rVsbzI0/QbOUBEOrpDx+Fd67Q29drow2S4aBtvWu+L7v+xKYLE006CRRc/a52lOY4o7uy3vqZUd5smiEE26+Fl2m4VzeOT38bRBspmE9ImEIRivSYI7X99dvWHv0Q6CnkxHpm0alvhRDAf/5T/R3S8dHhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302785; c=relaxed/simple;
	bh=bytfYXM9QwgTSE6ZeGvnFYko9RGfE+VoP1CvxWz3J7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p0kf7uryyIX922T7wUOiCr4Z0ZSywnPD1qiQl/2vzUviqkkBq+qeMM0TL6EkqAcjKpzwrEDCKtIUDZ1QKdU+bMUUYY13HcTtRUG5BND+dxaDffQCv+GCt4oDRj8ZhOTxwLx2t3No4NlmG4OPoeOMys0XI8OlJdiXAo5Vmn805NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AR5Y9w2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AR5Y9w2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856F5C32786;
	Tue, 30 Jul 2024 01:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302785;
	bh=bytfYXM9QwgTSE6ZeGvnFYko9RGfE+VoP1CvxWz3J7Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AR5Y9w2OjVasvxY0OAkxlQQU7O6TKiIexWCSC5R/sDPxtz3JZ1mQDMDw2oEGDRHPT
	 LEy8IcsOVrUuJA2nHHuls3r2Eipy/KqRVXrEh/yh4X3+NYTI2y0S9LkaG01ZWMpTA8
	 5ezTLNlno1QXiznIa6AswFTyLUrjm5ymWDWhISGwwTJuGCg6504kyecJBd5o/L2Wuc
	 kLPhiqL7f8XPMtDfYpmcs6/GgRt4oSd8SUs25MAvlyimWxrUGoZCnN/3VzAytfEVRj
	 fbTL/pnx5/GLY8x5w4SLNO4I8sFgscsQYKGD7ROX3Q9liQFgqPeGUuPBayff0RuUfq
	 NjfEMzGrtHsjQ==
Date: Mon, 29 Jul 2024 18:26:25 -0700
Subject: [PATCH 03/12] xfs_repair: junk parent pointer attributes when
 filesystem doesn't support them
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851527.1352527.17607890696167184163.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
References: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
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

Drop a parent pointer xattr if the filesystem doesn't support parent
pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/attr_repair.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 2e97fd977..50159b9a5 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -327,6 +327,13 @@ process_shortform_attr(
 					NULL, currententry->namelen,
 					currententry->valuelen);
 
+		if ((currententry->flags & XFS_ATTR_PARENT) &&
+		    !xfs_has_parent(mp)) {
+			do_warn(
+ _("parent pointer found on filesystem that doesn't support parent pointers\n"));
+			junkit |= 1;
+		}
+
 		remainingspace = remainingspace -
 					xfs_attr_sf_entsize(currententry);
 
@@ -527,6 +534,15 @@ process_leaf_attr_local(
 			return -1;
 		}
 	}
+
+	if ((entry->flags & XFS_ATTR_PARENT) && !xfs_has_parent(mp)) {
+		do_warn(
+ _("parent pointer found in attribute entry %d in attr block %u, inode %"
+   PRIu64 " on filesystem that doesn't support parent pointers\n"),
+				i, da_bno, ino);
+		return -1;
+	}
+
 	return xfs_attr_leaf_entsize_local(local->namelen,
 						be16_to_cpu(local->valuelen));
 }
@@ -562,6 +578,20 @@ process_leaf_attr_remote(
 		return -1;
 	}
 
+	if (entry->flags & XFS_ATTR_PARENT) {
+		if (!xfs_has_parent(mp))
+			do_warn(
+ _("parent pointer found in attribute entry %d in attr block %u, inode %"
+   PRIu64 " on filesystem that doesn't support parent pointers\n"),
+					i, da_bno, ino);
+		else
+			do_warn(
+ _("parent pointer found in attribute entry %d in attr block %u, inode %"
+   PRIu64 " with bogus remote value\n"),
+					i, da_bno, ino);
+		return -1;
+	}
+
 	value = malloc(be32_to_cpu(remotep->valuelen));
 	if (value == NULL) {
 		do_warn(

