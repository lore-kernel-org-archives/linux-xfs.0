Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22991BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fxmf6+2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95F8C433C7;
	Sun, 31 Dec 2023 21:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058527;
	bh=3IMVhDjQxHaXunVlRzF+LUUs4ebxuUV6PdkfQpaz2Gc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fxmf6+2HkOhQSdg3CfpaCPyoQJ+wQjXI23rV+Y3k/jKfCrILOOoS5i7pI+JZMs4Vd
	 2zPtx2StKzDAX39PN4iZ0yw7E1TQIMgMgJW/YNHwd4I92wAF+h4R4V33LNG9+b4d7a
	 DXNfaGfWXowf8Wf4vJAQP39SR6lCh2THyLxwEaXFYIjhk5or69G2dDB2HPGrcAOVIe
	 hVLJhEN7xzheIU5732IBt+rpsMIIJoxbvv2WXsl0XnPoXEZEYD7G0QBMJWhurG1V+I
	 Qu77iHgqecdwzoq7iFaU+8bHaf90m8alQcWV/GhozltqpQQkKRY9qYmDw5ardOYDqQ
	 70KBKYXBzGm2A==
Date: Sun, 31 Dec 2023 13:35:26 -0800
Subject: [PATCH 14/39] xfs: allow inodes with zero extents but nonzero nblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850127.1764998.1732124242804706299.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Metadata inodes that store btrees will have zero extents and a nonzero
nblocks.  Adjust the inode verifier so that this combination is not
flagged.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5ed779cbe6f9f..dae2efec1d5d0 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -601,9 +601,6 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
-	if (nextents + naextents == 0 && nblocks != 0)
-		return __this_address;
-
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
@@ -707,6 +704,19 @@ xfs_dinode_verify(
 			return fa;
 	}
 
+	/* metadata inodes containing btrees always have zero extent count */
+	if (flags2 & XFS_DIFLAG2_METADIR) {
+		switch (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK)) {
+		case XFS_DINODE_FMT_RMAP:
+			break;
+		default:
+			if (nextents + naextents == 0 && nblocks != 0)
+				return __this_address;
+			break;
+		}
+	} else if (nextents + naextents == 0 && nblocks != 0)
+		return __this_address;
+
 	return NULL;
 }
 

