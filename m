Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A982229E114;
	Tue, 17 Feb 2026 23:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370497; cv=none; b=EfEyUHqgbPYw5hvODfjV0qboLMt6P2gZ1zVQginezjOIDX2BujNEKc9xdrDlK8X6penGSHSYdm4x4BCBiF+xo3cMjgBnihTsUOKqUn/41SpF5samVv3hL3w5Z1bsbCVbYsUwMlchtbuf/hrZY1Wka3smB9JDxwUYnxcdC0WBwRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370497; c=relaxed/simple;
	bh=50PIa5MapmMfG+Ge7Wh+x5lfHB8SdzgL+jTJkHqyWGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSB3JJIrvtOqHkyOXIW2p5MDyezLy3J0N3mSEUjk/gT0AZ+Xz3wH1mLPxY2zJIrgYMIQ3+QCtOqmKaWWyUZNQeyDSd9Qz+nTR+FpLJZDx06ylwPGOhHqfvhiN7Soo7muHTiNzwwzMOGxn3c5/5JbwkB6+MC4OiBd5hO8wW8DJwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHQWDKkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHQWDKkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714EEC4CEF7;
	Tue, 17 Feb 2026 23:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370497;
	bh=50PIa5MapmMfG+Ge7Wh+x5lfHB8SdzgL+jTJkHqyWGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHQWDKkTD7xwEfxOZRUhxxPfQqmJzNRdmT7gdKqyLJ1bSrKOATqWZRnNGDpGrOfZJ
	 DmbSRWHgc17B47JLyYiXY840Pq7sSvA+BnPv8WAmIF6xmQb5Ky/QWLXg3iEUpFzZsG
	 NIUi+0+nUNQHPhWiumuy3gTVjMUDGw87xp+TMU3Frfe4VQX+1xqY1M96GmDYSy4x2I
	 +z/PVyb+P7DPFzPTUUkM8DuBSVExsp3dFnE98OxSKdficHTpvM2PLs7LUOoTfhHHWN
	 6NHaWkQ4mYZegU8LNzTwPQQKd7rqMqpoIjerT9EKtAizAPY9IIjvOMUXdFmC1WtB1y
	 XqHSfY/4EIR6g==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v3 30/35] xfs: advertise fs-verity being available on filesystem
Date: Wed, 18 Feb 2026 00:19:30 +0100
Message-ID: <20260217231937.1183679-31-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e9c92bc0e64b..abe5d8e3eed7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 744bd8480ba6..fe400bffa528 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1587,6 +1587,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.51.2

