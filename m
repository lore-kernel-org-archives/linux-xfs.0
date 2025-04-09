Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427052AEE1
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185455; cv=none; b=MUk+k3ulgJDYBh5Sc/onhMEJGXSP9bBMEpBVotkazWO7XdpEwU97jE+YVDUCYr+WBLAZsvxT+N2yXFBUohLG1cRaJMFDgQQsb4AsYChO5YgX1xJ9nWvAI1ZgyHMCbNHUXFL8dKfYSRSkD7auTQWJKGWxNIlsk05uIbAFB9Yer3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185455; c=relaxed/simple;
	bh=mHe7+omtdxlpUXHWn9WtW0JuorViH9sGGtNxeWmEapQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBux3Jz8oD2lS1t/RAYsi0DvJUqSRGaaU5f+e08Ue/lekc6Cbb7fl8N9F+e8/K/Z0C8MlKLHQ3zeqNYElNj212eTwzDxUcSojR8uIPSt1gmFI3dYgmsQN8PyiH+gG40KOybrNcAqv6MNmNrardUUiqGaCikTlHwF0QKnb+sOvm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e4mOxvwT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e4mOxvwT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sq3ujub7ZRr+xZFGhYsSE6kA+oNJPpGrlrfZBiknOEA=; b=e4mOxvwTSuPiKhOoxTuqoCudDn
	f1c/HZ3zjl5+Rt6sW1HIolV7vyMVoYQMmTPWrcEbOERTJREfqrrjhScBnzcodECMCL3aWgao5bJ+a
	HEHbykrvFvS+Gl3zN8rUloqdx5VN8XcWNiTVQC0haIeFIRSsBSa7FJNp0Wb1MhSwDHgwIaeE+ZhwC
	3T1e5fNYPq10PVSYDJPY3WtU1pYigAoIAVuWyiaL/+Uj4XYXKnOlRP08NhhIVyk4iyaVCngmQC6yp
	hIIzuygFtQ9q83UmFkg82T9vW9hwyTu98kpDee5S8299yCB2JSDShGHBam0TYNfnqAOljBdDRCODT
	y80hf79w==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJQ-00000006UY6-0wiB;
	Wed, 09 Apr 2025 07:57:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 23/45] xfs: enable the zoned RT device feature
Date: Wed,  9 Apr 2025 09:55:26 +0200
Message-ID: <20250409075557.3535745-24-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: be458049ffe32b5885c5c35b12997fd40c2986c4

Enable the zoned RT device directory feature.  With this feature, RT
groups are written sequentially and always emptied before rewriting
the blocks.  This perfectly maps to zoned devices, but can also be
used on conventional block devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f67380a25805..cee7e26f23bd 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -408,7 +408,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
-		 XFS_SB_FEAT_INCOMPAT_METADIR)
+		 XFS_SB_FEAT_INCOMPAT_METADIR | \
+		 XFS_SB_FEAT_INCOMPAT_ZONED)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.47.2

