Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C2E43F4A6;
	Mon,  3 Aug 2026 20:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787775; cv=none; b=PWpymqa40cAvHMEIEDJKv0EURbuepGvs4s4yfc1ZNEScUTisfabvZee1DyPiEK0EPfhq/GK9M+0eXH17pd6jU7ZwlcAJqJH8P10pw8Ce42fQeVxRTr4KFJmsCXyOBt8PlD0kznyHikmKUgCxkCCPknipW/Ljtz8d1xQb4T5aCg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787775; c=relaxed/simple;
	bh=gHl4HQg4dFPXM12xo/VO+LNovevHv2UmpG8XKevlUCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzaTv/OIN2pdHdB5cKFlgPcy9Fa1HJM4FMEHl0oGDPf6t034J7Y88g/V12z19KagLVh/m2FXPEaX97AK7eB5VsAtXCw1zudCRaXYhFtDX64Ax6BIJQz9mNAy+cLAvMF2tQVDiAuROiFoFnF96sGvBKMfSpL2GnlaSMKISlrjw8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRv+Lhti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRv+Lhti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD82D1F000E9;
	Mon,  3 Aug 2026 20:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787773;
	bh=AufMkm+nEeCieeEcnf+ZJSfHdxMb9GSGIeKul87lEHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRv+LhtiG+1pVRFvdMV2uconPz3S4bZF/fjyim/XtOpOlb2zlNWV4nV7XLkXwUKFG
	 6YgxBzAG88dTdgKb4O4Hll83gaVJ380jNJzht/ySR9PLT25raZ2F1yFQM4croyINQK
	 QmrNrMpvoYzI3lwx4OOxCX17YjGHpXCKtmb1+uZqUrptu9e+8+63qY6Atjve4i9ZNH
	 WLia2WqUndXlB4xDwy6PeDjbEyubwP0XiARoEUhQf1SRnhNEL5LSa6TNHpdqfqPmlH
	 pOXuv2IRzQ38D0W5X/G1NGyuOZkgm/zwf4FIb4+mejYgFnP2xzJLTWNuSBYavjHdDW
	 k1hu/KZLGBTpg==
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
Subject: [PATCH v14 09/21] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Mon,  3 Aug 2026 22:07:59 +0200
Message-ID: <20260803200820.393203-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 11dc1a485ca7..55667cc762f8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1370,6 +1370,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.54.0

