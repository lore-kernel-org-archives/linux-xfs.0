Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FA7364E82;
	Mon,  9 Mar 2026 19:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084327; cv=none; b=pgS0/TveOCAt0zC3vaKtKodd7oorFqkjLcM+Ou/Hzhtpm3iZqGY8WkSqi+ChLUtJTprPmE+YGgimc8xBiD8NwyKT6suCORiI+IEA6Ios+1ZrAvyimuAFcDBQ8CweRNeZUCMNSxpQ+AKqTVoPhCzuZ8iF6VLMkMiS9O0v0sutRfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084327; c=relaxed/simple;
	bh=xU2KCI35YrXRPX4STuuSkp2XrYakE+gfhJ6nDK7xPhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOoGhG/apVV/+iDofAt6cMFwmVtS+ObGLRkKj9xbEE2oTVyQux8CJTZLV2UG6Ab3WEfOGDV3DscQFBFiXmbeSfRnVmtXJL1r36P0NePGOBPzffVL1x/PFgYOzbUeq8onqEAJMV/2jGHL3OrcAF2uTvXab1Zl7LPOTVO+7c/TScA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HcvFft2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HcvFft2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F10C2BC87;
	Mon,  9 Mar 2026 19:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084326;
	bh=xU2KCI35YrXRPX4STuuSkp2XrYakE+gfhJ6nDK7xPhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcvFft2JdogA4EBQdg+1vhE3HB97YjBZocD6LL0EBVIG2qRBPsLUbgE77iNsf6xFL
	 cwNhWItmdap9hVh28rr0tVrXKeHkoVMxpU8paaDxb5QUnIbsAMewpxRz0oC8QRo0Ic
	 zQzowARQNiv1hx8bFz85T2IrS0NWWq3zH8hQpsTVWuwasaGRkXUZcoD577nDjDSfjn
	 wW1UlEW+BC4KOwiiymOPWscTPcaMivzr9HB5H/HdMyQUS8RfLB6c03ZhErHLnOkkqH
	 w+EOoURk9rnLyrds9EPXpv4Qu9VjHCHJlx/ejV6IOaZFk+QPvApZn6kU+2y8tEB5nk
	 10iJW17e+R5tQ==
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
Subject: [PATCH v4 25/25] xfs: enable ro-compat fs-verity flag
Date: Mon,  9 Mar 2026 20:23:40 +0100
Message-ID: <20260309192355.176980-26-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
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

