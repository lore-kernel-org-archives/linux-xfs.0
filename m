Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A31823770C
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596249; cv=none; b=XFgX8OwyBHCMdkVnqa+YxZNSEyMKToyWW3G8lO1BbI8+sRJVEOHVSw/jzHZWbHoqW6UhghXFdBx7094hH2byE+P+Chmrw5qislejf2jmcJ+BeSkKtPdDcPY8Xjtw//gxS3haQYD1sGIe0gkKAjyjiyj0dFGFfQbatNDb1MHii68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596249; c=relaxed/simple;
	bh=DKbmVL0+2WcORdoBnr/bPVAP7SA8SmbLWBhhITrJAYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvoXLc7iVPT8W8Kg5eXywXaRnjT8PRuTu9A/CymB1cyahjcqSu3aJCaXj+Lx9ZS1V38xIGuT3vwSRZMWgSFwAoDlRG27Hr2cVNo8FTe/fZiGqDMcSLXXyA7EM8ETPhkWGbr3eHLXWC9sHNaL5KcYH3xMmauRyX+PAdyC/JQrO6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a1QdD2Q8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a1QdD2Q8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0wz0pd+XTksdD2WU2NRAKVysbTapQV/+tfGeaasIQgE=; b=a1QdD2Q8m3ChgB/Frs/FaPzHZz
	OJQHZogvOKDTC+lOuqLKhG4EiTcR83ZVN43h+HD6ANPwQwuv/xRq849YSn/avyKqObPM2FmCExqb4
	TrayWTZF4smVvEbCIEP321I7RVpFxs8JE/LoTEqGlX/ZWDTp1LDQqU00TCbR0LFgftce+XKKsZKxy
	8/vc7KhTzT0FhDxjhT8PSIzWeQB1dLyqjLgjFBVjib9c29vTG90Mrk0flnpYJrYZOm2kVfZhm1tMx
	bXUSOFJz+V+nxHoKG+aArPImiKZB+1ZkUCfyLxVp20RqkhMF8PLnD0s63aUbBNdnQnDP4Kr6Txzzt
	6CbpK4lw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb1-000000053sp-40dp;
	Wed, 26 Feb 2025 18:57:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/44] xfs: refine the unaligned check for always COW inodes in xfs_file_dio_write
Date: Wed, 26 Feb 2025 10:56:44 -0800
Message-ID: <20250226185723.518867-13-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For always COW inodes we also must check the alignment of each individual
iovec segment, as they could end up with different I/Os due to the way
bio_iov_iter_get_pages works, and we'd then overwrite an already written
block.  The existing always_cow sysctl based code doesn't catch this
because nothing enforces that blocks aren't rewritten, but for zoned XFS
on sequential write required zones this is a hard error.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 785f6bbf1406..d88a771d4c23 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -721,7 +721,16 @@ xfs_file_dio_write(
 	/* direct I/O must be aligned to device logical sector size */
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
 		return -EINVAL;
-	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
+
+	/*
+	 * For always COW inodes we also must check the alignment of each
+	 * individual iovec segment, as they could end up with different
+	 * I/Os due to the way bio_iov_iter_get_pages works, and we'd
+	 * then overwrite an already written block.
+	 */
+	if (((iocb->ki_pos | count) & ip->i_mount->m_blockmask) ||
+	    (xfs_is_always_cow_inode(ip) &&
+	     (iov_iter_alignment(from) & ip->i_mount->m_blockmask)))
 		return xfs_file_dio_write_unaligned(ip, iocb, from);
 	return xfs_file_dio_write_aligned(ip, iocb, from);
 }
-- 
2.45.2

