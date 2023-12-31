Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9759F9C3
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPg0ffTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2700FC433C7;
	Sun, 31 Dec 2023 20:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054646;
	bh=+NdQMNHMGAfehYUbDHC1/UEQxYc9lWEGZ38CMKpCuZU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HPg0ffTrwHfJBhZ8dScLp98bHlyKFMs06Hl+4yvf1ldpXZJPVSaXm5d6rpbeP7+lz
	 og+Ac/H0qTAIf0x/3UZ64p1FrQfnLTYdIyxfymODZrecallmLWCdB8ea1lZUW3L1sq
	 1aeDd4t2mHkgGbzd95hSfjVqsW/orK3gFDVPxvC93Hn3YzFi3/yQt1ZH5r6C3+HaKy
	 QVsTfpzWuLL+MtMeMwNXAniax2rMU1/y/9BIFUEOOGQxOUobAP2Hdp1X7JOnqcx5wF
	 QGERGmWi/NlAe+vFv7+BPO4oMBwXXTtIuSZ5Kf2+gQZlR/Y2DM4X3zWMU5FMpZbR3q
	 A6L0kafM413SA==
Date: Sun, 31 Dec 2023 12:30:45 -0800
Subject: [PATCH 25/25] xfs: enable atomic swapext feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833542.1750288.9956078947448460353.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

Add the atomic swapext feature to the set of features that we will
permit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8b34754a5794e..7861539ab8b68 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -398,7 +398,8 @@ xfs_sb_has_incompat_feature(
  */
 #define XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT  (1U << 31)
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
-	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
+		(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS | \
+		 XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(

