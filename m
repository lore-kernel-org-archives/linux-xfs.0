Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054F1C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NC8CWzku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A26C433C7;
	Sun, 31 Dec 2023 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061811;
	bh=Tmw+RrEhWqmyAfmYca5Gbb6Byuuz8dJ/cVkGVJfGYRQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NC8CWzkuJBCbWTmyVIxdfRgphRBwWlCnt5QBTnA45t0S+raPvYoMdcUxzJWHzsa12
	 PMXoU6UqbfpcJ6+IiaBYKp8KYMb7n8jDo7ZB1qm3BxJEXC3qx8VnWIgg7EUrhmw+vg
	 xk2yv7Wxb1ox+EwiAdmN+yKzn4NTvBxIduyk6+4dI0UBJAkz2tcmx5l3/cKL5GWTaL
	 3IfP5vOd5VZz+Xicx9UMeKXzhcrnPnobPkKS1bvI2eeLfKr34EiY3SBlGoJ7WCcMmV
	 0wsgofvHcNdgRYqNlae1r+4yRQXJIFlrQMZDuTFqCrJf5fCHk8TzZonwzE30CCsvzt
	 xoZBs5o13zODA==
Date: Sun, 31 Dec 2023 14:30:10 -0800
Subject: [PATCH 12/20] xfs: enable atomic swapext feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996435.1796128.504794578530787665.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 8b34754a579..7861539ab8b 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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

