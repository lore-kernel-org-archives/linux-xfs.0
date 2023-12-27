Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1A9384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6doru12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BACC433C7;
	Mon,  1 Jan 2024 00:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068003;
	bh=p0vGtWhVJZff0g9xgdIh5QhgojaJrW0pv0Kx+SDkSE0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k6doru12fDlB47i4YSyaLXdP+HuR7HVXjIi+JrB6cVciw86URCgdKmxc3wMQCObVW
	 H+T5j7R4rCVLPmDMarpnTNzcA1KUMMvolVdKMG+WvbfA9QKm/keT9/+aqA4pfkH9na
	 olXm+vBv/6aleVHlwHPZLbEq18aNu+sQth0WWlNikqMUraMS1htc2RV9lJTuFWMLwX
	 NYEHzUtUOMotedwe8zbgZcGYemgi8cpElmDJXGyGR3MK77DCjs4h1j7omc/OoGhWDS
	 yQVRvdvnI3EfIBVJMDQxsg5RR4rl18tYVrnsSWEWDzjqpSMAUMAsGX16sat9D5cT4b
	 qitkvEvc//2Uw==
Date: Sun, 31 Dec 2023 16:13:23 +9900
Subject: [PATCH 11/47] xfs: allow inodes with zero extents but nonzero nblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015460.1815505.10885100965257102076.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_inode_buf.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 9755ae33813..e7bf8ff7046 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -598,9 +598,6 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
-	if (nextents + naextents == 0 && nblocks != 0)
-		return __this_address;
-
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
@@ -704,6 +701,19 @@ xfs_dinode_verify(
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
 

