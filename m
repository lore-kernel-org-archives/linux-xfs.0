Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6FA339A1
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928246; cv=none; b=DKhYLXwGIv+Ws3SwRB+y8ehH9WQ97IXvGX6LLGDcpEx/heSLNa6ca34Wu2gNLSe+LWnXKB0tHCphdOdnoGDeSSd90bCMrdU0PfzlDQK2xjGpSVzwzXNjt6NQqbfeEsASbj0Shqs5KKd6ySE5BH8E6eL2E+mPslbfktfG7okMDqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928246; c=relaxed/simple;
	bh=xydwm07Me73I1YhH3FKOGP2l2kC/x2dpMO9jHZjygac=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n38OuNwMleU4BbCwyc1pmTfmje+oDwQsim6z3BLK272Saatu2/ZlRl5ULgmQSNyUtpheCPQYj3WWNHGHuyQ5NlVEssGut4geopD0lNi8nOHfevXBNLw+A53vIea1tbrIevp+yznQ4lCEeQq26abiet0NHQma/VZwiCmV8e4iQbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rdlz3cKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rdlz3cKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B663DC116B1;
	Wed, 24 Apr 2024 03:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928245;
	bh=xydwm07Me73I1YhH3FKOGP2l2kC/x2dpMO9jHZjygac=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rdlz3cKnzRtY4igVgo5h2DNNU3OzwaOYGuNZK5BQVDztVU6NKQtY/pagURqB6dViO
	 2KX9VIiuYFJYy+OF1qUxsOgdr6pg4AijWiVneksDgs3QWqpl4I/yDuOrtdyc/4CfX2
	 nFRSCr+8o1B9QrldvYOLsuD1HqSgBxCxVqGhwIetvuUMOW1f6p5VSK0TvVXEpJj+8p
	 cKaaL98CAWmd/hwQ48L8OLGA/RA3otZf+QvrLpAlNheBGKHDv0MOyAFGBozCAsivgi
	 9kMOQzTKopMhiQIz8BOd0faQW27efzvC0vlRhazo7qeC+8TLV5IjUYcUHDqUbYbVDY
	 s8c9qTYFHuFCg==
Date: Tue, 23 Apr 2024 20:10:45 -0700
Subject: [PATCH 07/14] xfs: restructure xfs_attr_complete_op a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782691.1904599.8730318255511116177.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

Eliminate the local variable from this function so that we can
streamline things a bit later when we add the PPTR_REPLACE op code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 54edc690ac1e..ba59dab6c56d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -432,14 +432,13 @@ xfs_attr_complete_op(
 	enum xfs_delattr_state	replace_state)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
-	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
+
+	if (!(args->op_flags & XFS_DA_OP_REPLACE))
+		replace_state = XFS_DAS_DONE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-	if (do_replace)
-		return replace_state;
-
-	return XFS_DAS_DONE;
+	return replace_state;
 }
 
 static int

