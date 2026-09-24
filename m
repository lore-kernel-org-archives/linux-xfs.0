Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FBE44F575;
	Thu, 24 Sep 2026 10:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244157; cv=none; b=BhYnjUfyord+dUZ+h4au2QaWOCduxbo4EN9/DPmuJ68uQgxKiIRUXV7C+l9La2DjTsu8hCVferg0I9y727hLIcC2i8h1tFfGViRH6TxsktlbTjnWEGHL+KA7Avc9aV6CUf3JVh1t3apttR1MP01k+N0ex2P1eUtLPPTVfEYR9/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244157; c=relaxed/simple;
	bh=7dp0H3p7BtIGv0+YPaLegj6gGoh9NtykyV7VheNgEf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9ifHh/ABvXdLlQKTblUZ73Fde+rEYcUSxc+1X/962hhGDEDYy62EvRi6DyyqC9O5RSp65/XZdooha/K3hKVu5xGc/9iw6DhLmyXM3IkeEPpcQk/U7BFnEs53RDemZjKlTdYYVxLo6HXa+3gh//aklMmg0OicKVCwrjpr5e9naU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ay1Ht5n1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ay1Ht5n1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=b/0jQpPfLwJsyoUDYNIxrsMo+eENPa/LDfDppWLcgRA=; b=Ay1Ht5n1vgqHcHoPflMLnaC70F
	+SJhkrEusHNKskSxgn4IbmVjoxV/q66Uw+HcBnqvyOoGsA5wIglBwAhImRgmRtqPIKM7pJ8Y3PJae
	mAiMmZmKOxCFKUQ2C8R0qAG2O7VCgpdHkSjaaFuW34s9FzxgAZsAKBwo3HHKEYvSgejzVmpcvGJgG
	an29Uikmbag7SBh2uAxv7CamPIAhQRr/p/mOgTyIv8t6Nz2ipI9LVYROEyZFfjZfs6d1cm6dtNg4P
	J7bh4k8inAKzOXa4Whz54mM9KhRdlfLO4ZNs79ckKnjEQ9AIhXP9sU2c6vQUbmEe/6OD1WdT/Rw9Q
	AKarN2gA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gHV-0000000Aeih-3QSe;
	Thu, 24 Sep 2026 10:02:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 21/21] xfs: enable RT data checksums
Date: Thu, 24 Sep 2026 11:59:53 +0200
Message-ID: <20260924100032.2733101-22-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All mandatory pieces are in place now, allow mounting.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1be3d21910a7..8b269fd3ed9f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -384,7 +384,8 @@ xfs_sb_has_compat_feature(
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
 		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_RTCSUM)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.53.0

