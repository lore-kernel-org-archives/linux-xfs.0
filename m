Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404E91FCC47
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191448; cv=none; b=b9qoyDWUPCqUwZEMzYNCqagRMnBMZG82QwSAEaDew38bLtoN7zb7WjeyOFaZvMkJxBQZmXcqdYaMru+sCFmqnZoqjriRjGpdtYMmk0QiS3RDZ0+87T3Ite7UrrGXDpxV8suC5NE0Xi4Xp5X0o5mgceMKcb3TDLKleNM4UgvAIYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191448; c=relaxed/simple;
	bh=7QiAUR5fanCqJUwhR92ZY9GSx4XPnomlIwlg76OPJ9M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BTlWcJQCExJdhl6O71pV1VLGXAuFW+UsIJoBDUGjRics/zvQZtdAghUYD+BjHSkwIR6tgW93XkAOqN31EkwKN8Y2mg4OmwFIC8Uyc+0SA/t/JhALh8mt7Hl4rrKi6zeIYTsMaGzTfb/Pz8X7UjUG6UPYOoBmboYdtBxF9hG3sNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrBh4qVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrBh4qVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F23C4CEC3;
	Thu, 17 Oct 2024 18:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191448;
	bh=7QiAUR5fanCqJUwhR92ZY9GSx4XPnomlIwlg76OPJ9M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lrBh4qVkDVdU5aS1DNxI8gCLNWdRgiALf/Vv2UbUXinOZeveGXGY3Hgils4tM883x
	 AByd48SnQULfuhNoleYw9/wvFdFc1xhnUn0a4mYkz/8xG1WT882+Sn2g/29TJJS5KC
	 LGfnZvA2/soJ/2TdcfqxcOXUZynVg10H39MS0ZF+WZSdg4qI8mpqZHeKsuSevZBw+y
	 LWtiUvPHd4Kh3rawfh//WFoJBmgSeZAhZNpmeWQ+5fK+3UgTVkPR3o2Gk/dIaQP5AZ
	 j86yQGKy2+gVpWUkIHnh+lnXSpRjcgnUEtIYdYbDSzwl4Z8Tp5igQDLBlu2OOK9Qk9
	 zyJnCj2FFeV2w==
Date: Thu, 17 Oct 2024 11:57:27 -0700
Subject: [PATCH 16/29] xfs: adjust xfs_bmap_add_attrfork for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069725.3451313.12554248222409654871.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
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
all.  Adjust the assertions appropriately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |    5 ++++-
 fs/xfs/libxfs/xfs_bmap.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c63da14eee0432..17875ad865f5d6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1004,7 +1004,10 @@ xfs_attr_add_fork(
 	unsigned int		blks;		/* space reservation */
 	int			error;		/* error return value */
 
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5eda036cf9bfa5..7805a36e98c491 100644
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

