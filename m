Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA24476CD4;
	Tue, 21 Jul 2026 18:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659504; cv=none; b=qlHUKxn9AL/XJUjrsLVFG8Dmot/oBSfiStkRjCi5rdlOi+WeO7OzJZL5V8kMFuvpgs+mHFuNY1PtqLqocLKp/n5uOrtN3KKL/IBRrmkKgRFiQ4hr/bakAkCybvCeuZeh66mbk6UhcHfUj05aAboywtlOZRS5BMXU8emiZ6x6mNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659504; c=relaxed/simple;
	bh=zD3fqdriNeyS4psrX9dNSbGJrsTYYoWrAlK7wvQAbGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h70OlI3mk98Sazb/VXBBLVJhij7dFZMp4XKWNT7ZzlbQyQGCWAEDVVQmhPJBQ5kgsCfMV2emfsZnQjAzYfeca3EqvSZwKGd/cYbMbJ1Pdyvo/Bt+7WIaFmaCa0aQyGxW+2KbFzU04EV/vkVWq+OYUvx2dpiLaiUSUj0WZnxqVh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J99upiPo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J99upiPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51F11F000E9;
	Tue, 21 Jul 2026 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659503;
	bh=9UsWTPXNPtGAnC/NXDW+DJPQrI7L9qVnDZTXWpl6xCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J99upiPoYemerGRRA2ossFhQjtipwYUmal6fwOqfGPX6dFVvazISVO3e7I+YHgWOb
	 cv6pt3nAwmIs1qOaU5bSo5XEkTtSYFUSzm6kFFPjhUTgC9Tvl//+yF4r/fkkCYKeY5
	 d/FKZEMC7RvaSTUAcoLnJ42kCg2pdopoBgN+6dkGVnuycsstQoIT5n6N8CxUO5Ffuj
	 EZZHD/tsyriqA07xOByBg9UnWaU1p3CmsXudQa5uVVPxOfo/1RaaoUwcbKqJISKbjB
	 b7ACjPCrD3SPNspNs9p0WSJ8HDDipHxkVfc8jPeMw1dOz0BVTyPck1ce9uqW/ogVXc
	 K+XclUKjXHkXA==
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
Subject: [PATCH v13 23/23] xfs: enable ro-compat fs-verity flag
Date: Tue, 21 Jul 2026 20:41:00 +0200
Message-ID: <20260721184346.416657-24-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add spaces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fc196d9e12dd..8be1b101b196 100644
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
2.54.0

