Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0FA4E2F25;
	Fri, 18 Sep 2026 11:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730222; cv=none; b=f75aukyIR/HVsDnqk1JuNKJFHmsZhi8FJvLLsnplNv9zQmc5Rqmkcrpt9a3nbyNHAmlbN1d/33EnTS6W1GD8tHD96SOsoUo5UZiHlKNMrMdTXzhwps/WcEPfdamD+ld0s3Q3/4pJCTJYNPO66iJ6gHRr1KatNYT+TDAibaWdf78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730222; c=relaxed/simple;
	bh=zD3fqdriNeyS4psrX9dNSbGJrsTYYoWrAlK7wvQAbGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9o7MPyxrjKNK49qXjtKoizFpGwjga8YUxYg4qS+tNQTNUQvVMCaAVo9PzbHQhHZ+4mTAWVpQBtNMPmxGcMrSptwZVaccvWO5h+MNcofxR3crlW59NKmvE/frlhVh7v3p1Ybrc9racUV09UIrzjxAUTsxmsSSAOMaL8CNH2RKZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4T9NN3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4T9NN3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB721F000FF;
	Fri, 18 Sep 2026 11:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730221;
	bh=9UsWTPXNPtGAnC/NXDW+DJPQrI7L9qVnDZTXWpl6xCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4T9NN3YH/4FKDo94R2U/pin0AdDpGATmRWuv7lSOGc05j8BRdKeL8OGV2gqRXpFE
	 p9Ao9ffPCjLl700QiADiL3Oe5WbG2gi+0eqT8tERRgrp2WbGk4HnCBW0OiTd/3d2VB
	 4vSROvpPGcPHjqVnEZWJZHRZ1mEdlCzVl9Qc1OhY7yG6D51yTm0NucN9No9u4lZwLv
	 LxteDxWq6SEEGRExAu6YLP4c6GN/dtPHXqB3NtvjEfvQjJO72gP5mYJ2/9PJrt3k2y
	 MmOCnqXVL1xBjcSxHlW1qfubofkjc/dkPRzS7UUuuXJeoE0kYa//OJA+kedAr7UEj1
	 cCRnYzCq8xfcQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v16 21/21] xfs: enable ro-compat fs-verity flag
Date: Fri, 18 Sep 2026 13:15:33 +0200
Message-ID: <20260918111539.1003439-22-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
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

