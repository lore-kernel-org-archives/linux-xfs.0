Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242EC296BA9;
	Tue, 17 Feb 2026 23:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370508; cv=none; b=pP9oe45Fxurc+gJQYmbY01r09Cb0IaKBH0u0uVMb6O2JpRCWGV6b/K4QyHQm6Ah9g6+tGaw4bsC3VCwFYVRMMGxi15O8WYcLnmJqRt9zhwTFjc/1PhjvesBQ9QOVX/16xLuJcBaqizNXD0yE5SJYqxHfyox/RV40xoL8wPPXTSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370508; c=relaxed/simple;
	bh=xU2KCI35YrXRPX4STuuSkp2XrYakE+gfhJ6nDK7xPhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRgVsNV+anvWOgiwZfnng7D9Zf/Swp5hLAqu3637xNJw39xQYfA05kRPF4gWkqx1slQ3bfSt5apDXH5wpvOWIFYSdrvoZ+xgxSiSZ8xNzSNbc0/Q+RvufwiL0brzl0sfvispPakAhe4p8LekoRGtUEyFSIjrho/OH2dadGCMLs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3x7SUbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3x7SUbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4B3C19421;
	Tue, 17 Feb 2026 23:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370508;
	bh=xU2KCI35YrXRPX4STuuSkp2XrYakE+gfhJ6nDK7xPhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3x7SUbPuzcTC9cr7jVXw+zrAFNBnbbRYwEyFjHrt+taOlpMb+QBoVDXQghdnA28r
	 iITxL0+np2T7EgEUHLPSYMWJYgXiIHPuh13ecQa3fIZpBXxHZrw4C26vrwADyRiY1u
	 b+UBDfdSCRZmm0iTOHd2lFSZmrvcXHXJmem1yxCwyzUGF4e/ASFhx/uAWm0kSouobt
	 j69E7gOFmk9UssWQUUblk+7RKGyCF/yia84ORc88M6LEEpauqzlqqbMsbrS42hkVT3
	 o103znTbugMwAY8B9D27uk9ka1mqGBjXF7KfJMSDJNwqcvShwliZyR/qw7r3TDxUQA
	 qmPZhIYVYECwQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 35/35] xfs: enable ro-compat fs-verity flag
Date: Wed, 18 Feb 2026 00:19:35 +0100
Message-ID: <20260217231937.1183679-36-aalbersh@kernel.org>
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
index d67b404964fc..f5e43909f054 100644
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

