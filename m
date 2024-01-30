Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A34A33981
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591119; cv=none; b=IdSAiF9g5Z9nJE1rY/n/Rnnmb8gMGHgKR9rvgiVhzZl9M0mAOSFrssRuCqV5o4NbxlK43Z/3C4e6xl78KuU7AB7mQtbl5olUrhfKtOLsoxgtXSWNgunVF+Oi1V+wrKvH61C2zC6/Rnrmr5s8CoHog6tYQmzYaYv8f+BP3ALvlmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591119; c=relaxed/simple;
	bh=I1AyFFBKIm9D3L84snz3ILRKi8y0d78FWDQX89ShBxM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LnpMXENfRpPiJO8Jt3wGDUsadmUaWcopNmBI1Bt4Q04ecsmIswIuMhXdu60tVuenJmuEiPPMdkT1PpuzFoMQJwaFGjUa7SBhKJvoQwnmV3RXfBsSUeNIXpe6FPwfnOSD2MAIE1sJu0Sh0bq0B2Q1fqtb+9hFyC5d8cOtNAmx8Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YScZC1NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YScZC1NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C10CC43390;
	Tue, 30 Jan 2024 05:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591119;
	bh=I1AyFFBKIm9D3L84snz3ILRKi8y0d78FWDQX89ShBxM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YScZC1NAPYoGVBcvBPfQL+YJtT75DdCUXGiQhVZMXxTUQ4fc9U5KvNmFElxbpbamV
	 zv1EKHivnLEdVFx/7M7++nNqN77GeJXLZGeNSL2N94LW7rEeM14t69FFbWx4naEalY
	 IvWld8u+J9EQXTrkYmysFMBj3fAPqO24mwnFEVySb/DNNB4Tc44AwvSStcBVf4pHex
	 T96TIGuTn7Y8kL+g5bEqRU9hLXBiLuMKmdyqna3kKkJhJP410n0Qy6O6Tlby4lm1Ul
	 w26zV0vRG+YVbSrjDalL9dyanVFu6rVvN5VVkMcF+Eq0QdIsxnIg8LNfHX4prX8tes
	 sLOPaS6xUamzA==
Date: Mon, 29 Jan 2024 21:05:18 -0800
Subject: [PATCH 1/4] xfs: create a static name for the dot entry too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062317.3353217.6098480781462462813.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
References: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
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

Create an xfs_name_dot object so that upcoming scrub code can compare
against that.  Offline repair already has such an object, so we're
really just hoisting it to the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.c |    6 ++++++
 fs/xfs/libxfs/xfs_dir2.h |    1 +
 2 files changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index a766732815145..86b751d9504df 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -25,6 +25,12 @@ const struct xfs_name xfs_name_dotdot = {
 	.type	= XFS_DIR3_FT_DIR,
 };
 
+const struct xfs_name xfs_name_dot = {
+	.name	= (const unsigned char *)".",
+	.len	= 1,
+	.type	= XFS_DIR3_FT_DIR,
+};
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 19af22a16c415..7d7cd8d808e4d 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -22,6 +22,7 @@ struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
 extern const struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dot;
 
 /*
  * Convert inode mode to directory entry filetype

