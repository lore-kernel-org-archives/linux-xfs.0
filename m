Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FD0BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vO5uHOud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC39AC433C7;
	Sun, 31 Dec 2023 20:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055506;
	bh=LeVUhAQxkqF+AXnzn2hoj1qGvr/jij/wSJ+93UUfzfU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vO5uHOudMSpxgXHFv2bi0Mawxk9OimBKwI9/KV7SLyyfDy1ENc2vxzVKs0wdC8gUb
	 cEOKmqjMSzYMJjGuQyD3+RblIlEFp5D1G1Jg5AANoXDuUrc0on5f3g63Tbjtk+pxYh
	 vjZ3gn9uaFi3xILEnfy+fgZ/KgH/sApA+9JpKiM+uKO4l69C8mCK3vlvRJTloXH3D1
	 Wddxl4Rrm15OKjdGWwp8HQPe2emLamp72UUIhYZaNWKIzkn/Re4IW9+5gcoYr3ZO1X
	 C748kDwpdLxm8Bae0fKkwI2ivmdjV8HmsuPzeAEAqgOOh6yie8QSghleMmhRH0lab6
	 iGi7EVvPgvJiw==
Date: Sun, 31 Dec 2023 12:45:06 -0800
Subject: [PATCH 01/14] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr
 log intent item recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840420.1756514.7241148659196496235.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
References: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
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
index d7ebb54a03870..c023962141556 100644
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
 
@@ -542,8 +545,6 @@ xfs_attri_recover_work(
 			 XFS_DA_OP_LOGGED;
 	args->owner = args->dp->i_ino;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:

