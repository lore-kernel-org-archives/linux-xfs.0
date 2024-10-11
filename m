Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3E1D517
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607938; cv=none; b=EP67+ygwBuT5yg9O3BJTiVgkz+NqaMH63v7R5xylY3Q0x85/YjMeZz4aT7rmzaJRM884nhiNXa+ctZLow4tMh9Qm3h+8ymdwtJU3jO66v1JmufC32oGvdZXGJxyH+3NbSfWGqZM4C67G1ZL6KuVfuF2Drr1H1ntim3MO7878B6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607938; c=relaxed/simple;
	bh=H24swDyAPfB+0oJn/drOIumnYmxaDyVKqqcIpNNnwzw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgrTm2CgvvATESLUjkhklUVfmNUiQRfQ2xFtQAWF9mFMAcEvsCra1deYHNoCh89IZNewiTaT0hq9gw8rnQi57k5yRzyledk//ffW7RUmOObjZ+p4t4Wm7KpIFjXuvoJdkyc7EuL91NmS0mbcsujpNZceNExzQsxEgyj3qW1kLRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r8/N6ma6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8/N6ma6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C77C4CEC5;
	Fri, 11 Oct 2024 00:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607938;
	bh=H24swDyAPfB+0oJn/drOIumnYmxaDyVKqqcIpNNnwzw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r8/N6ma6fHL0hqfOxTfW512RrZWxbFcQ4hN42fAwtSCsmjRxJHADMyIxGEBW8Tp3r
	 cp6qLYnAIIzdGWgR+j1GnNLqSGKsDo3aQyz7m472K5z04Q5HX/LK4x4plY5lo0Xrz0
	 RnAr0q1AySgkclmvKlmNxUZDYgrqsLn70/11fzBcqS9gJSh1EwP1GJJVNFxJR0K6Vt
	 UJ/RLgiFgdXrO7yR+boDqNPlcqvoiRTsGfyBrmeGn/AsRG6dXzCrbdyvL9sazBA4E1
	 8Iqn5awXmiCcNEGvIN1XHMDUHT5OZobMXJwRDnRM6jITS5ZcBoK61DvXVnANwlPDuE
	 l2vfQd3J6Yyqw==
Date: Thu, 10 Oct 2024 17:52:18 -0700
Subject: [PATCH 15/28] xfs: adjust xfs_bmap_add_attrfork for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642275.4176876.18217759405140842581.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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
all.  Adjust the assertions appropriately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |    5 ++++-
 fs/xfs/libxfs/xfs_bmap.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f30bcc64100d56..4b7202e91b0ff0 100644
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
index bfc3155bb57d79..2cd9dc07dd1a06 100644
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

