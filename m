Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A23E5227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832301; cv=none; b=XwnT2fyanIo4DDwnGTDZedLmS5KUIF+zEtyQiAkRLsFkKi6+kq+krZLXq3N5We64jFN5dZeJvtlq1nafrVip0ignHqA2k1oqltNFOMPk5IROrA/F8Vvgna3UPjCig6bpZBO4rKwO49yY7KRaCDFuSLLtoxkqA6MT4QDivC2VNWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832301; c=relaxed/simple;
	bh=MBgDJFBTRXeXFjkU+2qWwpU3pVMPnq1izmatXi98YmA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KBrGAlEzW55WoAluzvnnBZCzJI3C9bO0guyH1tytjYUYUa2/6eUjPAnTwnGOraor/0Q6atS6Obool3EOza+6VBINYxqV9oyKlocFfB8vo3nlGn9Eq1Wv9eAfQzc5KqYuUHsEBkBSOjbje+bSJhASqlADiRc92TrG7K1VnlnQBt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZ9feDWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZ9feDWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2ADC4CEC6;
	Wed,  2 Oct 2024 01:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832300;
	bh=MBgDJFBTRXeXFjkU+2qWwpU3pVMPnq1izmatXi98YmA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dZ9feDWuUnhZ3FeM0mTtFhYuuV9hPk/HSnkJx/Ojx1Kpp2u1EfDTzXZa4lfcubffz
	 g8goT8QLtY5WV2V218enSzAhG+k9ZrWOqP5mq1HQqzyi8Sr21x36T+ew78q9t9biqe
	 QC0jwd7QlvKmJVYjcEU48yiDWBAwqVd7AU7RHSml6WpDfpFoiUhlvxPJSb1EpmkMzh
	 qwUM7de3IatHi+Rbcj9KnecdBY4TAUspAHei0YCntADeF9T+vxX2p3L4QN8WVkH+Kl
	 t9wEfEzdp/hfH1th/2bhHVoQ1HdHAYqr/mZHv7WxlooAzAfo5MfSg3L9+0qnr/zJRB
	 TPoytsTH7qAOA==
Date: Tue, 01 Oct 2024 18:25:00 -0700
Subject: [PATCH 2/4] xfs_db/mkfs/xfs_repair: port to use
 XFS_ICREATE_UNLINKABLE
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103061.4038482.13766864255481933120.stgit@frogsfrogsfrogs>
In-Reply-To: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
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

Source kernel commit: b11b11e3b7a72606cfef527255a9467537bcaaa5

INIT_XATTRS is overloaded here -- it's set during the creat process when
we think that we're immediately going to set some ACL xattrs to save
time.  However, it's also used by the parent pointers code to enable the
attr fork in preparation to receive ppptr xattrs.  This results in
xfs_has_parent() branches scattered around the codebase to turn on
INIT_XATTRS.

Linkable files are created far more commonly than unlinkable temporary
files or directory tree roots, so we should centralize this logic in
xfs_inode_init.  For the three callers that don't want parent pointers
(online repiar tempfiles, unlinkable tempfiles, rootdir creation) we
provide an UNLINKABLE flag to skip attr fork initialization.

Port these three utilities to use XFS_ICREATE_UNLINKABLE the same as we
did for the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/iunlink.c    |    2 +-
 mkfs/proto.c    |    5 +++--
 repair/phase6.c |    3 ---
 3 files changed, 4 insertions(+), 6 deletions(-)


diff --git a/db/iunlink.c b/db/iunlink.c
index fcc824d9a..2ca9096f1 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -315,7 +315,7 @@ create_unlinked(
 	struct xfs_icreate_args	args = {
 		.idmap		= libxfs_nop_idmap,
 		.mode		= S_IFREG | 0600,
-		.flags		= XFS_ICREATE_TMPFILE,
+		.flags		= XFS_ICREATE_TMPFILE | XFS_ICREATE_UNLINKABLE,
 	};
 	struct xfs_inode	*ip;
 	struct xfs_trans	*tp;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 96cb9f854..251e3a9ee 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -432,8 +432,9 @@ creatproto(
 	xfs_ino_t		ino;
 	int			error;
 
-	if (dp && xfs_has_parent(dp->i_mount))
-		args.flags |= XFS_ICREATE_INIT_XATTRS;
+	/* Root directories cannot be linked to a parent. */
+	if (!dp)
+		args.flags |= XFS_ICREATE_UNLINKABLE;
 
 	/*
 	 * Call the space management code to pick the on-disk inode to be
diff --git a/repair/phase6.c b/repair/phase6.c
index 52e42d4c0..85f122ec7 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -909,9 +909,6 @@ mk_orphanage(
 	struct xfs_name		xname;
 	struct xfs_parent_args	*ppargs = NULL;
 
-	if (xfs_has_parent(mp))
-		args.flags |= XFS_ICREATE_INIT_XATTRS;
-
 	i = -libxfs_parent_start(mp, &ppargs);
 	if (i)
 		do_error(_("%d - couldn't allocate parent pointer for %s\n"),

