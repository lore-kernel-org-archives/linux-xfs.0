Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B725938F82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989859; cv=none; b=u2WdF/F1iz/VNGKFn2lmFv3ZIKm+0B4OwklzEdA657lSYfbx6JxJIfMMmd9L6OCT2qsz6ZBuCDAbtY3mvGUpYq3rkzhdb1hnbIt9JNBwjhinWd2Er8D6tD3HOgJvLSAj8LZ3cE90TSws8RTmR9m4kTVnis/958CWvEYu3hBcQbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989859; c=relaxed/simple;
	bh=O/Wz0WcC1u9YKeBp9fabWtKqEKGs0X5Ew6LDvOiWfUM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gicfV3KT3vuUEhrGOI4oVJqmPyOdDUMe5EbQw2jTqIlUKJV+kcquVDZYXT0cxIgjPqVvSDu0dKTwhzEqiZnjgfWC/xG7tTHGy3r1IXQpU0RvnO2NCvfeZsKuHz+GdDa/9vD/1NNPZEm99r4XoJhQZPBwU0fbv2VVI06kiObOM0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t/6GXJHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/6GXJHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5B4C4CED3;
	Mon, 23 Dec 2024 21:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989859;
	bh=O/Wz0WcC1u9YKeBp9fabWtKqEKGs0X5Ew6LDvOiWfUM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t/6GXJHYCe/OLskVHkhCNvrq/jta5cgsqQYuYkrw3axYMa/nBwVlYoZRR+lVRQnjg
	 EIbFh8kP/oFMwgy4K/4w8ngAb/DAwew/hh3NMHu7I0m52JsFdDxHR0DrjpGKxDzH8c
	 EyIXqcAs0cutLsam+eNEUiQ4BX+0bnT5w70veMiX+R04nsYjqxjIKukIJnH+5HKmxL
	 JwwMfVdxb18JPM7YTCaP0DJC7+ojBfV1/tZBMkCVZ6NGExWjV2u8rxqDgwv/3h0f9e
	 5PhBk8dRjtn0akhk4s7tJH+Cug5SNkAAkIr7kQTf9YtCAJ8A+tX9nDVZf1FCZhgKbX
	 sLmx54q+dHzGg==
Date: Mon, 23 Dec 2024 13:37:38 -0800
Subject: [PATCH 02/36] xfs: sb_spino_align is not verified
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: dchinner@redhat.com, cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498939977.2293042.9811398235690323418.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 59e43f5479cce106d71c0b91a297c7ad1913176c

It's just read in from the superblock and used without doing any
validity checks at all on the value.

Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_sb.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 0603e5087f2e46..0d98b8a344209e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -395,6 +395,20 @@ xfs_validate_sb_common(
 					 sbp->sb_inoalignmt, align);
 				return -EINVAL;
 			}
+
+			if (!sbp->sb_spino_align ||
+			    sbp->sb_spino_align > sbp->sb_inoalignmt ||
+			    (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0) {
+				xfs_warn(mp,
+				"Sparse inode alignment (%u) is invalid.",
+					sbp->sb_spino_align);
+				return -EINVAL;
+			}
+		} else if (sbp->sb_spino_align) {
+			xfs_warn(mp,
+				"Sparse inode alignment (%u) should be zero.",
+				sbp->sb_spino_align);
+			return -EINVAL;
 		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {

