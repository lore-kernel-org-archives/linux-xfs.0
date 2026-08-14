Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D136B456DF2;
	Fri, 14 Aug 2026 09:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699662; cv=none; b=hNrpZIm9t91+CJRn0F+KFLzCfIgkQxDdDSjjuYeQvGYUFYph7OJsHtTGYfuDPWxO6X5LkbFPVQsyqwjsUTOSdKwcNYF/52S0ddt8tyFMBX0oQZi0LMW7V1xElejl75JZ0v3QpKvZK7+YeC9iE1lEw+CCQbQCbOIQg08E+gMpv9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699662; c=relaxed/simple;
	bh=zD3fqdriNeyS4psrX9dNSbGJrsTYYoWrAlK7wvQAbGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdW+wHHczvKaq7JXBxKjgnWdNB07Ni71l8m7MDWju73FqRW5M2X6/iCRt+ykI2OmWFDiuNqrzQ7TSWBTcI+16onzCf/slgmN/IrSESeR7AdKaHfN9D9F1TNkohukKQfMql1QW9BleYudt4c6766KZTph60jvR6Jw9NP30nsStFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/uL6pgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/uL6pgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A141F000E9;
	Fri, 14 Aug 2026 09:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699661;
	bh=9UsWTPXNPtGAnC/NXDW+DJPQrI7L9qVnDZTXWpl6xCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/uL6pgjiq6TXELTFDrbimjovrxUvVcZ5/8mhkSmBYcFyChHw641ZrI5YEjevUQL6
	 AhSv1PaTTnOB9op/Iw7UmkPzoNl36HtH5tnganmGOYSi6wiMI5s0QKCgutYNwFbd65
	 lxcMyksIdSAVVv3V64TI4u4Th21NAg7Jk7C/XuAJCD1uKYHVTlgRoh3ItnOZrXjIbK
	 F2irNdPjzZM1niEfmNUcJXzhx3gVGMERi3b4yhZGs5hXJkJr3SKK5iMtBGy+tNmOs4
	 9MyRUQd/GD82SuPU2INJpuIA1e35KZjW7Zxk4YxtqOEbVQp4QNOuBVN2saVIU1uTxy
	 L7ie5UiZb0QCQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 25/25] xfs: enable ro-compat fs-verity flag
Date: Fri, 14 Aug 2026 11:24:42 +0200
Message-ID: <20260814092448.1818082-26-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
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

