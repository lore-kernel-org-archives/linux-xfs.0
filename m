Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96004D50B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ny9AuRi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14761C433C8;
	Sun, 31 Dec 2023 23:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064376;
	bh=IVHY0rDTAfNlDv/lHpXZIwFh0y72r7/eE+kQykGUfLY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ny9AuRi6bifONOEaC3JkdMxWpXFpY31WUjUjyUL4f84k9LdRU3h7RJXu7PZcGOEbR
	 VTA/oS/y4ALfownOkxnXU9VTUUwTzgqAK95QdZxeQk/K8acp4jKvoY7lXC6TprDvWy
	 Ns+Nte4ew+cnHa/m3V5fD3xtSpdlILch0kmAPg4VeKWDQPGEL5AGK2ZuQGYUKn8rwj
	 2sNxz3OaQ2yzPvuo0cMvC6FzILFfPVD7F4qcNHISyWI8/UPCOl9tSqP70s3cK9rcVs
	 4HXTeaPt5KjWcKOsnyWn9qINMVsJ8srwnV0v06eMNowrMO63u7TnJOdOsdlVt7xv0D
	 8lhqOmCcSQCig==
Date: Sun, 31 Dec 2023 15:12:55 -0800
Subject: [PATCH 30/32] xfsprogs: Fix default superblock attr bits
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006500.1804688.11633053339413088287.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Recent parent pointer testing discovered that the default attr
configuration has XFS_SB_VERSION2_ATTR2BIT enabled but
XFS_SB_VERSION_ATTRBIT disabled.  This is incorrect since
XFS_SB_VERSION2_ATTR2BIT describes the format of the attr where
as XFS_SB_VERSION_ATTRBIT enables or disables attrs.  Fix this
by enableing XFS_SB_VERSION_ATTRBIT for either attr version 1 or 2

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8b0fbe97ddc..cbfb89b6795 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3424,7 +3424,7 @@ sb_set_features(
 		sbp->sb_versionnum |= XFS_SB_VERSION_DALIGNBIT;
 	if (fp->log_version == 2)
 		sbp->sb_versionnum |= XFS_SB_VERSION_LOGV2BIT;
-	if (fp->attr_version == 1)
+	if (fp->attr_version >= 1)
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	if (fp->nci)
 		sbp->sb_versionnum |= XFS_SB_VERSION_BORGBIT;

