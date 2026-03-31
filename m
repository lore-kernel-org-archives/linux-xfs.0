Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4304611C4;
	Tue, 31 Mar 2026 21:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992581; cv=none; b=rLbtekxTLKGEKp4qfwWajtTiOzPdpSswZNkOtgmMrjgnodT42O5w6y1Yt97QP09BFmF3w9tLKV1zchJ9XHc8f31EXsIe6nYYaBTk4uAjMeKy2fIZNaGA6PhGZvLkbCLUpz22kRg4dFsb2RlTWtExUFURWcMe9sBEorGChwMvIxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992581; c=relaxed/simple;
	bh=F9zqK9E4O4jjnMMTNM5mFWuFg4IWtl3pxXGeeyzEVtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0uIAJA5ALdMII8+u0/jFVh2uk2SLhP8ca1NV6NSpyMi0SxHlOifiRQkoAxywPSKPHA8Pk0Fn9Ja2kkUn5bUbVqZLjPRw7GokgAQNeP+qT8fZsx0MgC26Y/cUk1JjSavTNY/sbXrHqPr+gb9nhKBbrxgBp1R1ZM7Y2ZxESCQLzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKylLcNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKylLcNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD17DC2BC9E;
	Tue, 31 Mar 2026 21:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992581;
	bh=F9zqK9E4O4jjnMMTNM5mFWuFg4IWtl3pxXGeeyzEVtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKylLcNaSBJR/tEyygtJDJA8xJR/h85y7EHRGv4aUQZWrQRgZwiP0cttXbiArXR68
	 uWvkiLZIxPcNjCAxHUYOo7ABa6L54e39gN33cCcUMqx7fqWI8Jq1ICxJx7UY1pC+iY
	 nsqJBmFRXa1uqNFgp3NKxbdq0+MuGq+KyMhxZEwjMa+m6Yz7IS0ghxqwf/XSGX7e3z
	 2MtKNx9t8F9C0mrAjoim3qvdUAlVaUnKQatporPKgrPpQCygkqiDuHqpjmv0EC+yuL
	 Yt2IzYy0niovm58tCnaYml7/nNhyCZML4vYzZQgVnobVxg4cGD4ijhG4Pxl4Y2QB3A
	 MzUPtizzBje4Q==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v6 22/22] xfs: enable ro-compat fs-verity flag
Date: Tue, 31 Mar 2026 23:28:23 +0200
Message-ID: <20260331212827.2631020-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add spaces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4dff29659e40..0ce46c234b9c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,8 +378,9 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.51.2

