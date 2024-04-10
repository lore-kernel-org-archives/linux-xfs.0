Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0578D38B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710255; cv=none; b=S4UZwmmBC4olYmH4fsdNuLJn5EZCqBEVTujilbV0x2FXjJdodW+LIMCDxMHICJXKYrj2V4Lh9ZDdM9SBWe30PC949GIlr6BKStI9wE/cogRotRml2tOy8c3dN3GvjqBG2zWrXmmxq0tWBnGdSVSrToHZEtDBwXCjdFJOQUdDSzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710255; c=relaxed/simple;
	bh=/b+gwbNlFksUKgepNrtkpkS6a+ACh/tDpVtUdYge2RA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/qyPzMRRDvAVp2Tj7SiYnWwLzs98HxSRjHjMpjItXday7+XwkmkjHRbyjn0gyL8ym/QjX/SrChwJXGi+aUMdUgV3He2uGBSMkA7/wfNW3uzQR2jEo+yiKvHIWV9L6AxXEIknkrBbzWgs4W//0dtGRrGItN8y+rtK+fit8NpjFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHe/aj4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHe/aj4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8940C433C7;
	Wed, 10 Apr 2024 00:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710254;
	bh=/b+gwbNlFksUKgepNrtkpkS6a+ACh/tDpVtUdYge2RA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rHe/aj4vI5FN+Y5wQzppzfXJQvAq24Cxor/f8SGRkXmhKKtyMlczHiN4icb0rG+ZR
	 r9Q4IxiN3T5U6SSOX8yNJKYojhvzE+qU8TtTXyEoVd8/SQqB/PtAo3hbZHhcRLHQ36
	 sUuCLdYf0i+Y7uA30gkoanWpzEQSxG9spoVZXlz3S2v4s3DNmxcqqKHFc2kgfYEP8D
	 JJ8+UUuSPXN/4LQQfxWRYl/BAIswfjLhuG8ciz6b6exOZn0hgNWWDvBw4+S1hvkyvI
	 0Qx8R/iowtnhbrCE1FlFH2jvfEQYxegsh51IobF5hfe7MAGzIOpCkf8wnBWEJM7eQT
	 knoVywLA4lRsg==
Date: Tue, 09 Apr 2024 17:50:54 -0700
Subject: [PATCH 02/12] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr
 log intent item recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968886.3631545.13705299860508916040.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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

The XFS_SB_FEAT_INCOMPAT_LOG_XATTRS feature bit protects a filesystem
from old kernels that do not know how to recover extended attribute log
intent items.  Make this check mandatory instead of a debugging assert.

Fixes: fd920008784ea ("xfs: Set up infrastructure for log attribute replay")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 541455731618b..dfe7039dac989 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -469,6 +469,9 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return false;
+
 	if (attrp->__pad != 0)
 		return false;
 
@@ -570,8 +573,6 @@ xfs_attri_recover_work(
 			 XFS_DA_OP_LOGGED;
 	args->owner = args->dp->i_ino;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:

