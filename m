Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D14BBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNroajkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F756C433C7;
	Sun, 31 Dec 2023 20:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053192;
	bh=lNnTYgBelLLQL4AT/Spdj94URJFnvdBfVRXFl2OOXCw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mNroajkORhewH8B+YlssF4c43ZGmUnxVBfSwGkfv2yZA6OW8kMSK7/Q8WB/yA42/U
	 TfP63i6oyQjX/sG5bQgjUUNIcVwE5K4A/m5P3T9bCNVtSY9cDu4jLcCvkaSoz0YxVf
	 NgSbIWK8i8nJFVRMSpjdVoBI39c1VeO+AgVUDo6y44y9ELB4TBDDYYUWU0s4MRQOei
	 yw2j3YNncjoFwlk4CBxss+7oPQoWJVaTAS3HI7gPijQfXcfoUCsyazn6DvzZxBFvU9
	 Eviuro9PGVLYsQ6cNVmvR6vGKF+spBerxvtBQVZ7c9EaDdF2viHrCTg/zVIt2SD3XW
	 57xFsCAHrW+aw==
Date: Sun, 31 Dec 2023 12:06:31 -0800
Subject: [PATCH 1/4] xfs: create a static name for the dot entry too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404826988.1747851.15202607805712467013.stgit@frogsfrogsfrogs>
In-Reply-To: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_dir2.c |    6 ++++++
 fs/xfs/libxfs/xfs_dir2.h |    1 +
 2 files changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index f5462fd582d50..422e8fc488325 100644
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

