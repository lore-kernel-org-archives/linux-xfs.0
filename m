Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446A42E406
	for <linux-xfs@vger.kernel.org>; Sat, 10 May 2025 15:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746892383; cv=none; b=UVy40skcE32bHO4/aS51WZeH9hiwhI0rVhuIwVFM5poxEQF6f5/Wv53sSILtLwFN+cGrg2RDepfwYcspwr8z0DfEE5+2JqGqXxmx5GrAkqjJdXezv21G13HMEsGAUsmosyoYxHi+4uMd2YBCMQtrX3bMKfH5kr/QXkfeU0AxGf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746892383; c=relaxed/simple;
	bh=B60E0UxtZGxkzOlg9mnRMvcgNw6LUET8KOS+JsefO8w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aBhCS/uvmXJiQKG3TadWt41Vzl44PbMbZ8+qIc+OIRTpuX60hUYwLmu4vFmrNO7oVaLBjLfhKTpQbJhEMpQbeBmt5Nd2uPeW6PK96ciNPU4iCORf5oshXHBBp7HT/iDoGTpllOUoa8yoJs6H5RCJtLhMhixmtCzMLDzfgjx04EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2//s9Si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2//s9Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99805C4CEE2;
	Sat, 10 May 2025 15:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746892382;
	bh=B60E0UxtZGxkzOlg9mnRMvcgNw6LUET8KOS+JsefO8w=;
	h=Date:From:To:Cc:Subject:From;
	b=c2//s9SigawfwivSd89m7U5CblEYtIleg2dzhyDg9tQ7ZLqmZW6IDL6q/5LQpOp7m
	 0sIYGQVuv1v70FG/6CgEr+44OUlWub5l0/HXoj6UJHKgvulAJHmPPsrN4NEmtHumEZ
	 oP9jQNp38JQ0Iid1nPkUCGIoG/ezvTbDHt5dlxGaV9VdLzt39RQHwgj8vFRqDlBn6E
	 zBIu1hTd27kdrofNJO1JF8SFasJRrOX/+RTOeL8akdBEoyWySZWgz/kFc1ByF3c8i6
	 fgPaith3JeobjeCN2e1iqqaXORMDHawGWbQUR26F5hMhCQLi8PzdtCOQuZ4NCrOYhk
	 Rgs00fB4xkn1A==
Date: Sat, 10 May 2025 08:53:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-ID: <20250510155301.GC2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
syscall and parent pointers were merged in the same cycle.  None of
these have encountered any serious errors in the year that they've been
in the kernel (or the many many years they've been under development) so
let's drop the shouty warnings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_message.h |    3 ---
 fs/xfs/scrub/scrub.c |    2 --
 fs/xfs/xfs_message.c |   12 ------------
 fs/xfs/xfs_super.c   |    7 -------
 4 files changed, 24 deletions(-)

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index a92a4d09c8e9fa..bce9942f394a6f 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -92,12 +92,9 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 
 enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_PNFS,
-	XFS_EXPERIMENTAL_SCRUB,
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
 	XFS_EXPERIMENTAL_LBS,
-	XFS_EXPERIMENTAL_EXCHRANGE,
-	XFS_EXPERIMENTAL_PPTR,
 	XFS_EXPERIMENTAL_METADIR,
 	XFS_EXPERIMENTAL_ZONED,
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9908850bf76f9e..76e24032e99a53 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -680,8 +680,6 @@ xfs_scrub_metadata(
 	if (error)
 		goto out;
 
-	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_SCRUB);
-
 	sc = kzalloc(sizeof(struct xfs_scrub), XCHK_GFP_FLAGS);
 	if (!sc) {
 		error = -ENOMEM;
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 15d410d16bb27c..54fc5ada519c43 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -145,10 +145,6 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_PNFS,
 			.name		= "pNFS",
 		},
-		[XFS_EXPERIMENTAL_SCRUB] = {
-			.opstate	= XFS_OPSTATE_WARNED_SCRUB,
-			.name		= "online scrub",
-		},
 		[XFS_EXPERIMENTAL_SHRINK] = {
 			.opstate	= XFS_OPSTATE_WARNED_SHRINK,
 			.name		= "online shrink",
@@ -161,14 +157,6 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_LBS,
 			.name		= "large block size",
 		},
-		[XFS_EXPERIMENTAL_EXCHRANGE] = {
-			.opstate	= XFS_OPSTATE_WARNED_EXCHRANGE,
-			.name		= "exchange range",
-		},
-		[XFS_EXPERIMENTAL_PPTR] = {
-			.opstate	= XFS_OPSTATE_WARNED_PPTR,
-			.name		= "parent pointer",
-		},
 		[XFS_EXPERIMENTAL_METADIR] = {
 			.opstate	= XFS_OPSTATE_WARNED_METADIR,
 			.name		= "metadata directory tree",
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 696874e72eacf1..b4e830fe101b2f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1953,13 +1953,6 @@ xfs_fs_fill_super(
 		}
 	}
 
-
-	if (xfs_has_exchange_range(mp))
-		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_EXCHRANGE);
-
-	if (xfs_has_parent(mp))
-		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PPTR);
-
 	/*
 	 * If no quota mount options were provided, maybe we'll try to pick
 	 * up the quota accounting and enforcement flags from the ondisk sb.
