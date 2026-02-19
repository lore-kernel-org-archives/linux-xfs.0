Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E0F2E2DF2
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480937; cv=none; b=qLpTPxDHgtW13xwLHbeKnLCCRStXuMWI88EfJl1a02ErHiBthjNWq+P9N8ktnaLIIw4bl0/z5YSiXnwoGNEwOhr/J94GPHauznLBiij8O4Y8IqgUIZNDBkhGc/5ww7U02+muNwL0pUdYx7ogCMLgfAu8tri54ogcN+7bEZRMWxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480937; c=relaxed/simple;
	bh=SMvtciVLSZpPuM5Nl+j/tWMcYO62aO5iS2TWBehi0YI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CJceXxoAtjHV4YONYI8qgjDDovBPQFVWvzjfqd4Z9Zu8HANqn56I5fXNH+AkDgfaP3oHc0KhRcr3nwgFQbZWB5rX4O8GebuBbbV9bzqEJRBQWIgIBc4Oasz+B577Yw1UACVkjGv9L6IT7PenDoms4z+XN/5Sb+BXxbxDkA1lx4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uNUCulMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uNUCulMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B39C4CEF7;
	Thu, 19 Feb 2026 06:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480937;
	bh=SMvtciVLSZpPuM5Nl+j/tWMcYO62aO5iS2TWBehi0YI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uNUCulMdbS1ijTfEKaTEUbaIOTJcSa/Tt0SOCEHqY4R5vZuKlPE5MuHHl7fPFqJo6
	 vaJsEDdh96+sOZ3S52h/C5AyNc6CRYEdv7f+dzYnPdkXNn9B07eNWP1QlxxHRGSbdf
	 KiCT1PQlkNXu3bFatqrejsaokwCZsF21XOzzHMSaNHMSf0vrZrJ7D58S1nHn62XLMg
	 xIxwrnXW1ajj1sVpQ9JT/J5jfG91zdPSmY8QMwVmQU5Auz4coaFFebwXONEiRPY2as
	 r/e6RWVZbyL28YARAizWHO8jl+h+fyQPKDU+gVVG3War5NQSq28igbno+AqnnsnvKg
	 VvvAuJZqfl/CQ==
Date: Wed, 18 Feb 2026 22:02:17 -0800
Subject: [PATCH 6/6] xfs: don't report half-built inodes to fserror
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: samsun1006219@gmail.com, linux-xfs@vger.kernel.org
Message-ID: <177145925538.401799.9155847221857034016.stgit@frogsfrogsfrogs>
In-Reply-To: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Sam Sun apparently found a syzbot way to fuzz a filesystem such that
xfs_iget_cache_miss would free the inode before the fserror code could
catch up.  Frustratingly he doesn't use the syzbot dashboard so there's
no C reproducer and not even a full error report, so I'm guessing that:

Inodes that are being constructed or torn down inside XFS are not
visible to the VFS.  They should never be reported to fserror.
Also, any inode that has been freshly allocated in _cache_miss should be
marked INEW immediately because, well, it's an incompletely constructed
inode that isn't yet visible to the VFS.

Reported-by: Sam Sun <samsun1006219@gmail.com>
Fixes: 5eb4cb18e445d0 ("xfs: convey metadata health events to the health monitor")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_health.c |    8 ++++++--
 fs/xfs/xfs_icache.c |    9 ++++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 6475159eb9302c..239b843e83d42a 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -316,8 +316,12 @@ xfs_rgno_mark_sick(
 
 static inline void xfs_inode_report_fserror(struct xfs_inode *ip)
 {
-	/* Report metadata inodes as general filesystem corruption */
-	if (xfs_is_internal_inode(ip)) {
+	/*
+	 * Do not report inodes being constructed or freed, or metadata inodes,
+	 * to fsnotify.
+	 */
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIM) ||
+	    xfs_is_internal_inode(ip)) {
 		fserror_report_metadata(ip->i_mount->m_super, -EFSCORRUPTED,
 				GFP_NOFS);
 		return;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dbaab4ae709f9c..f13e55b75d66c4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -636,6 +636,14 @@ xfs_iget_cache_miss(
 	if (!ip)
 		return -ENOMEM;
 
+	/*
+	 * Set XFS_INEW as early as possible so that the health code won't pass
+	 * the inode to the fserror code if the ondisk inode cannot be loaded.
+	 * We're going to free the xfs_inode immediately if that happens, which
+	 * would lead to UAF problems.
+	 */
+	xfs_iflags_set(ip, XFS_INEW);
+
 	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, flags);
 	if (error)
 		goto out_destroy;
@@ -713,7 +721,6 @@ xfs_iget_cache_miss(
 	ip->i_udquot = NULL;
 	ip->i_gdquot = NULL;
 	ip->i_pdquot = NULL;
-	xfs_iflags_set(ip, XFS_INEW);
 
 	/* insert the new inode */
 	spin_lock(&pag->pag_ici_lock);

