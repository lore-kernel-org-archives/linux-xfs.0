Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B55531A813
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544673; cv=none; b=Ox1wbiAhQsUMOAUQ6GOnFC/1xnYgTV3Mi3nu1UYwnmehf9nbAlpRZCRuNw/QRBs1tcCAftIr0JP/khM7DOEqQGltNWnQld2I6klW3++l6fKdgZa7RIUZo0KgqtjBPTJzOsTqM8GHm+z1KlIkca5d8dd0qfdrrDzHm6sysfAfdbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544673; c=relaxed/simple;
	bh=hTQ4zzJr29psIpKpgVNr1TeChz+JD8mkHSccM3ld/ME=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uf/lQlyN3y8DKL7XVjaopwEDsaZi765qTCWRE+N+4RC4kcwmvT8QluRz7SUCHk0UoRtapsWg7uO0c9TabN6PDi/EVXwwIICPwFpYcZ0cu665Bw3uNOQfZ6OtQh0fa9btSy/kRKskoL6qBYRNptSkVeA3XfyqEWYuQQXWGDAj7yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAHQKbGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAHQKbGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280D4C4CEF7;
	Thu, 19 Feb 2026 23:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544673;
	bh=hTQ4zzJr29psIpKpgVNr1TeChz+JD8mkHSccM3ld/ME=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TAHQKbGi0r/K3AR2U0fyAa24KkYA6PIiDU3757KUHXja0s/mrBVgrK76xms1AmyQY
	 TbZFwMq8b/Btg+ezIB/qNtaQqkwQGTV3URcFtkcj0mdSgbxEnkjtSAtja2QnDNpG2P
	 OWWgfNv/XO8UhCT+t+JJPtK3NY+0+kqgDRM/DeIu9x3yRTnJGDfrbK8dMoPR2XD21S
	 3asgbJ1Vd9gHSiz8wcMuK1Bj/7Lt1d9Opge7uQaKkMgNK1bft7JeDwS1H4j5C26wHH
	 BtiSXhD1Dkeu+Wl7rjRHrCQEAoMBpHWrHHc/C0epBZvOe/Xm2mJUdy9iirte4sOxCe
	 YfE0NBRhR+Q6w==
Date: Thu, 19 Feb 2026 15:44:32 -0800
Subject: [PATCH 04/12] xfs: use a lockref for the xfs_dquot reference count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154456802.1285810.4287423505253578455.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 0c5e80bd579f7bec3704bad6c1f72b13b0d73b53

The xfs_dquot structure currently uses the anti-pattern of using the
in-object lock that protects the content to also serialize reference
count updates for the structure, leading to a cumbersome free path.
This is partially papered over by the fact that we never free the dquot
directly but always through the LRU.  Switch to use a lockref instead and
move the reference counter manipulations out of q_qlock.

To make this work, xfs_qm_flush_one and xfs_qm_flush_one are converted to
acquire a dquot reference while flushing to integrate with the lockref
"get if not dead" scheme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_quota_defs.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index 763d941a8420c5..551d7ae46c5c21 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -29,11 +29,9 @@ typedef uint8_t		xfs_dqtype_t;
  * flags for q_flags field in the dquot.
  */
 #define XFS_DQFLAG_DIRTY	(1u << 0)	/* dquot is dirty */
-#define XFS_DQFLAG_FREEING	(1u << 1)	/* dquot is being torn down */
 
 #define XFS_DQFLAG_STRINGS \
-	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
-	{ XFS_DQFLAG_FREEING,	"FREEING" }
+	{ XFS_DQFLAG_DIRTY,	"DIRTY" }
 
 /*
  * We have the possibility of all three quota types being active at once, and

