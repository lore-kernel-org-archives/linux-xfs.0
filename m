Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDD01EC4EC
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907508; cv=none; b=tv9wtuB9v/wUS6h22qzJ/JfM35dh1kr+kzWwdyPPo9GSC1zCOs5iCk77Y6TYUlk/duF+6c9Tu3O+W6DWIh1tC/lbNbSVpbrgvAZz3hJeOSi+YEbzxBlAXyCSxDM8+gEm5jDMJ/KSk5oCiqQHU4XeIuQnZkfQc3LXMxVi4cUR7mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907508; c=relaxed/simple;
	bh=wfS2xPd12pfUglfEhqYK9hrkoHxD/6vL1UMqQjSxvk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH8azAkb/e0ReREBS5xfO2VecpvDMHrUeEfOXVh9djLjGw0DJiCdvpzb52/x1i65gUksk/Vtw7o/sept5QUejjRYNmaBZWUj9xt/DHOPYxPoHjRoo5JEVY6dt8Y90qoZI0Wrfd/lYcLcYYZV2C53LhCSDbNizuPD0jtnqy6QDo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TLCkrq22; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TLCkrq22"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Q7s2IyN3/q5fQIJCeav7rviBTJdVcVnxcbqoW1DHmNM=; b=TLCkrq22Wa4snm9jjS+h8XxSc5
	R+JZDCLSHtU1sySgEdKcJebsg4HrehszhCng4wWNUF4ooU+D0Zi6Kw6ug7yHrwOVirBbRDl4QXFXF
	m3hzJumE7VReP3hewEUoavrx4eVHQ6iEXUUtFQCUDQ8QGToAP+CVPZnab9hvgNd0H1sf42IZ7tfsH
	nr9jWTDgMoctc/s9+JG9bD7E+lnJDBYk6zuP6sgAoMa/0jYgw9cMSMOFhtPTfElZS+MMaA2sALsRX
	McQrjDP6Py6kK/B2fNPole9jiZNvkTEKaWayQxRLcdUZLsOU8JmBwEC2x+rghOjaMuUJXXsRSy9r+
	FKRdqjIQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIY6-0000000EJUn-3U49;
	Wed, 11 Dec 2024 08:58:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 38/43] xfs: enable the zoned RT device feature
Date: Wed, 11 Dec 2024 09:55:03 +0100
Message-ID: <20241211085636.1380516-39-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Enable the zoned RT device directory feature.  With this feature, RT
groups are written sequentially and always emptied before rewriting
the blocks.  This perfectly maps to zoned devices, but can also be
used on conventional block devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 12979496f30a..fc56de8fe696 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
2.45.2

