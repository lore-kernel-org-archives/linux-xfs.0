Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CE43E9F97;
	Thu, 19 Mar 2026 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939826; cv=none; b=G60JJv3ws4/AFY2dBgScl7OGrZ7c2XQSnDwwtf/qXfyWYlZalUjnlzJS1qgYOeSD1KL4y5H9dNSz3TYkue2MAZv6nO7UQs3mCzUlcyh2LofTqoVysKxD7/1OM+4IgkJ6cER5+fXWa6/2a92yNXMx0nHQYZj4LQhBzgf4diI7/kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939826; c=relaxed/simple;
	bh=F9zqK9E4O4jjnMMTNM5mFWuFg4IWtl3pxXGeeyzEVtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu45eBXDi4hEN7vBDur1VIx+GIoBUTIC6n8LBvnMvDRWnxZ3wwC8T+Xd0JEv3yMDNhWuaAi3cpYiRrH7W/1y48UY7reJp0jMqLk575OyvqRKWkcJhvtpAkAnR3s2B/NwwuLvFOzDPhkrGjtdzO6+zq/YIyAEUSPlRCfL2CQgUks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pchmygOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pchmygOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CFCC19425;
	Thu, 19 Mar 2026 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939825;
	bh=F9zqK9E4O4jjnMMTNM5mFWuFg4IWtl3pxXGeeyzEVtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pchmygOtjwmWmYK5E3bMAoRbtv69lNzGeeVtDvXHjzOycrRkERxLQqc5CS5bXnsyE
	 R8BSPes3kUPbaHvLWvmrQXOCvhpRg2xEyIUn1L/1PbO+dzMpf73v5LTGGMCq4OATmw
	 jxYzjJrZ/+O8Z3xAP7Q65UsZq1YGZT7VM8ZS/vjRvLvD2quwhKXIdECaZS4i5bLP+8
	 iI0RgLvS6W/t0OeoDm7539LJyGWTEPfgRVIZGS05dTNCpZWfg3upHiesYJJzs5QpXJ
	 rjb1mggiIuIYm5SjCa4dxSkdBpPSwmPCuqUjTYHQXOmyHN9+vknQ/BpiMPSBVUDZc8
	 ZtZkSE7lhQCBg==
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
Subject: [PATCH v5 25/25] xfs: enable ro-compat fs-verity flag
Date: Thu, 19 Mar 2026 18:02:12 +0100
Message-ID: <20260319170231.1455553-26-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
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

