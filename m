Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F4A22B5A1
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866344; cv=none; b=kMRsZwY/fKgzni4FKmluObi74xnv6pxWyAzW0UuVh7mScNNiM1joaIzc+YXAMoS3r7ejYmMRYGtpHd9I8lt/boxIl4sBRL1m2FC0XqbELBn3A3ydY0j8R68uP3dUSxPXLNtL7F0KsapqOOA/wUyu47y+3cf4LcACCvON4iLtZUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866344; c=relaxed/simple;
	bh=H7NJOZASmaHp/yFweRqvJktvqMAvAwewCHx4hXQk/Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISanlTI6BmbDKmmyXGbs63N/TnxdPJwwzzJn7QXeQTpn5bZTnWGnTyJYOf4Mh0l/c9+HLez5OhxQQHqYR36YtP+JGM1N0Yd5U+AqhmeM4a7uvIvemGLaV7Fhsw55NZ1OhDqJs118mWUFs8dZdCnRLQys7cO6ZpNUFWaR13TGmVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0mxpgV+S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0mxpgV+S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cb365wOMtx88hhbd0L0O7xwRDA03zOJ6O/Y5qrSwiBs=; b=0mxpgV+SdnSf8uH4S8lwCK0Lz6
	r12xPvvQ2wjUHupCoVtOQ/SOiSbDDXaLzQcIJ6d3bd786OBzy81f6MqpcRSlO9fD9IyGGUHqAV+WP
	7Rb1KaG2vFPqAwIWgftragZ+8fOcPyZJTYpPXGi9tIy+bi0maqtD+cNrpZVJqFnc1FamLdmE6bqZR
	HbzI6HoZuYPIHEKTgEi1GqiWNp+0VWsdw7cibtuMAqlJgka4DSiGGxkReOnBnR+oQvuDjjYC7mbSP
	uJvYM9/XzdkDqs4bch/1fIc/52yqZS3CwCg2SgkfLJYAqIPcE/W8ErGigPd2QnHezKdPt2QH1P3SN
	V6S0xi6w==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIiM-00000007CMt-1oB5;
	Tue, 18 Feb 2025 08:12:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/45] xfs: add a rtg_blocks helper
Date: Tue, 18 Feb 2025 09:10:13 +0100
Message-ID: <20250218081153.3889537-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Shortcut dereferencing the xg_block_count field in the generic group
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c | 2 +-
 fs/xfs/libxfs/xfs_rtgroup.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index d84d32f1b48f..97aad8967149 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -270,7 +270,7 @@ xfs_rtgroup_get_geometry(
 	/* Fill out form. */
 	memset(rgeo, 0, sizeof(*rgeo));
 	rgeo->rg_number = rtg_rgno(rtg);
-	rgeo->rg_length = rtg_group(rtg)->xg_block_count;
+	rgeo->rg_length = rtg_blocks(rtg);
 	xfs_rtgroup_geom_health(rtg, rgeo);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 03f39d4e43fc..9c7e03f913cb 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -66,6 +66,11 @@ static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_group.xg_gno;
 }
 
+static inline xfs_rgblock_t rtg_blocks(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_group.xg_block_count;
+}
+
 static inline struct xfs_inode *rtg_bitmap(const struct xfs_rtgroup *rtg)
 {
 	return rtg->rtg_inodes[XFS_RTGI_BITMAP];
-- 
2.45.2

