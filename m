Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B294430
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371533; cv=none; b=kdDOHPV61hqwrDCbt1Dh6TEj11QVFknPAkA1YDq8OPZpFrT8P5NrqPrdIbOLYcVB4Fh7yxMF3jH29njKDXQDHivXP2KxBvzNFCiGMImxoMKdzrFIWAmiomfJkw9zajagA8XVy4oYnmleQYRjHsQzZszFqWimrC5IzVkRoA93y3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371533; c=relaxed/simple;
	bh=4CwfnBgE7+kmh4dKaF83z3hYpRDwrOQW68CnZ+ZTw8c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m3bl8y4K2YL1VLw32e4A45EfBNig/zVICqCiauj9Cd0wKjkVk5L+jrjOavl/KUCfrhxgQ9ba1Rw/yI0Vil9S0D5+Rl4VU6mHGOWawcC7HI9DpPyv/lUHSi4eoDWbrGk0HQsNapcyW6ir9qM32ZPiwC3+wgSbf8n37VPgOqJg1mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ox9341JS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ox9341JS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7E9C32782;
	Fri, 23 Aug 2024 00:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371533;
	bh=4CwfnBgE7+kmh4dKaF83z3hYpRDwrOQW68CnZ+ZTw8c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ox9341JSqE2Bksh49a6tbs+c/gYdPka8zLcJ7okO+2Pc0QeSLvqNCw0O2gZInyKww
	 XdmIabqJRfq+4WY8lkxdyzeWT0C4xWYUJBylSpv45jkeH7iIenMi+8gJevNbMxTMuX
	 yPLN7QY2MJIsd5zrExPivkIzhbzoQkBsOOwrfkIbKAqC/n7/PSBBFYegjN1I3jJQqA
	 SzSXVpJTJeMoq/2E7lYkyWtfg1Yt8s7bhoMwjFQbq0GL0ijycgfxVOkYEhc7fFALwl
	 uJopOw/8qmtDWo0ubqGDjAA/899LB+LMBWu43KADMF5qZPQPJmV+gXcOQX8+tlL6z9
	 0wa+SkLBjmBOg==
Date: Thu, 22 Aug 2024 17:05:32 -0700
Subject: [PATCH 13/26] xfs: adjust xfs_bmap_add_attrfork for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085399.57482.13597899118907300765.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Online repair might use the xfs_bmap_add_attrfork to repair a file in
the metadata directory tree if (say) the metadata file lacks the correct
parent pointers.  In that case, it is not correct to check that the file
is dqattached -- metadata files must be not have /any/ dquot attached at
all.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    5 ++++-
 fs/xfs/libxfs/xfs_bmap.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f30bcc64100d5..4b7202e91b0ff 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -953,7 +953,10 @@ xfs_attr_add_fork(
 	unsigned int		blks;		/* space reservation */
 	int			error;		/* error return value */
 
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7df74c35d9f90..b79803784b766 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1042,7 +1042,10 @@ xfs_bmap_add_attrfork(
 	int			error;		/* error return value */
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 	ASSERT(!xfs_inode_has_attr_fork(ip));
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

