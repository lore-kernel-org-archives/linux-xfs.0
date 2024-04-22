Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B3E153BE1
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804033; cv=none; b=o4k4QnjZSGAU8rgT5P3dCFtoWBI7kXDT+/JJVaNGvZBiph4IojG7j++7bVA9Lzu4AUyY5whHSQqYrHA2qA6jxu+uGA+tSM/jsy5biJ5ne2EiFKLNlTnP7m0fo1cjC5LH6asYv0qWMqthj6qtuW96qLQiRPJm0+eD8nV3ekGk4/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804033; c=relaxed/simple;
	bh=S0k5fynd21uvt7V2Hhzd+kFXzr16pFilgu8vtJb3/x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhW55HEyQpo7SDAZc9oXGe0RCTzB7N6ii1p/5E08Y6jpF6hG4LJOrvizLVyDAbKgB2W1WugYsSMEpSu0hhvxxvFPY9yFopferigCRs8Xj1WKJI1S8U5YCWXR6nXWrHPuAQIFMJp6M8+EA+MpeAN1vhFyy7kB/mMQxUQXaEn4MAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTbP0o8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTbP0o8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141DBC116B1;
	Mon, 22 Apr 2024 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804033;
	bh=S0k5fynd21uvt7V2Hhzd+kFXzr16pFilgu8vtJb3/x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTbP0o8AxY8Im4w4fnMIb67YBEJ5ukfj394SXcUcXG5eO6hkhCuGCl//3v9ODdei+
	 2tENIcEmXM8ulp/tSVV+z8FkDYi7VOWxjxVOin9Pvwyfp96LQGygetBoB6iDEx0QQE
	 anzTNZpMMjVYi0lhJDhCOGTx5lzjyKQeo61Qs/9YiUlCXzJyoq4yUiU9ipAnvNkAbz
	 Vc2Zfp4Sl/Yb6TAW3d6XXghe0pnkAZM1KVf3Qz4WX3ZUpQr9KA3EBqn6UHSFqUarxf
	 NFFXq5E6IwLdHKF7cNFJ3YtfxW45y79hSPWUfHBqv5h8QvEfHUAWXEpDAoh0y9BL7I
	 BFbi3kxjVSMHg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 56/67] xfs: move the xfs_attr_sf_lookup tracepoint
Date: Mon, 22 Apr 2024 18:26:18 +0200
Message-ID: <20240422163832.858420-58-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 14f2e4ab5d0310c2bb231941d9884fa5bae47fab

trace_xfs_attr_sf_lookup is currently only called by
xfs_attr_shortform_lookup, which despit it's name is a simple helper for
xfs_attr_shortform_addname, which has it's own tracing.  Move the
callsite to xfs_attr_shortform_getvalue, which is the closest thing to
a high level lookup we have for the Linux xattr API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr_leaf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a21740a87..10ed518f3 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -873,8 +873,6 @@ xfs_attr_shortform_lookup(
 	struct xfs_attr_sf_entry	*sfe;
 	int				i;
 
-	trace_xfs_attr_sf_lookup(args);
-
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
@@ -902,6 +900,9 @@ xfs_attr_shortform_getvalue(
 	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
+
+	trace_xfs_attr_sf_lookup(args);
+
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
-- 
2.44.0

