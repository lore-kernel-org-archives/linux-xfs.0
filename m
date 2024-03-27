Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21E954BE1
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537409; cv=none; b=OtW7xMuGtBv09/5C3Avmis1upcOeCQXk8E129FxSv0R0l8bI1d7DOHpZnPS6ukwp3b4q4/ujWsJpbQf70HA3LNVyPa11ddyEcb497oQBaUlrQskYbqiNRzoLrXHxQl4we/R6tp5VwFinHwUIM7VPgw5kmiwmDoshZflyE8qzCEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537409; c=relaxed/simple;
	bh=IBSmgxBhILiCOoeS4nrif5eZJBEK3uN7iOUpcHSOfJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rVjwSEVaiVTmvECdsFLEmxARc/QPbaxRv8NfM4ZbcfwgexJW7+j88XJbCY0f/SZo0H6+J71yTShoZpy+yAKFE83vbnK6vMOHEAD7N1BDIXbI+TBWiqUuKkGE1tv79qHAUcRm/mssPVo2E9EBSX/ezkofQUXT28SAAumm/erkxnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HqW8jhe4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HqW8jhe4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=THPNCNoXTMmUWITKS6w+NabN0QY/iVuoXCGrpFYl51k=; b=HqW8jhe4U2MFRNSI1L0R8jiCEO
	7WrXSBixEBqiJkBEquCBVQlWYbjK5a2WmuTc+ZIjSWmh8ZoFB2b5yaxHqnz/VrThrVlJiB1I7wQeC
	OrwEcLCuIu1YO3vC51+Li2x5dDHcCYaVP5nnHupviHN3yev4xXvmUPt+brnNTgEYch+vuT+JcZ3uD
	YouijKpW44dNJKA1n8sE+ufRSrAJ8O+6zXIZ1Ylx1e08YqluY86ypR4bLN25zAFsNW2PHIkcisab2
	XSyPDvtlUNji/3mJfT4q7GOlBvVZSkkjA0NtGtEOjrpPYY02gxYObzwbMdkQIgdEbcAHVQ2P/MeIg
	L/F2HZJQ==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR41-00000008WUw-3Di3;
	Wed, 27 Mar 2024 11:03:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/13] xfs: make XFS_TRANS_LOWMODE match the other XFS_TRANS_ definitions
Date: Wed, 27 Mar 2024 12:03:06 +0100
Message-Id: <20240327110318.2776850-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit bb7b1c9c5dd3 ("xfs: tag transactions that contain intent done
items") switched the XFS_TRANS_ definitions to be bit based, and using
comments above the definitions.  As XFS_TRANS_LOWMODE was last and has
a big fat comment it was missed.  Switch it to the same style.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_shared.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index dfd61fa8332e1a..f35640ad3e7fe4 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -124,7 +124,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_RES_FDBLKS		(1u << 6)
 /* Transaction contains an intent done log item */
 #define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
-
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
@@ -136,7 +135,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  * for free space from AG 0. If the correct transaction reservations have been
  * made then this algorithm will eventually find all the space it needs.
  */
-#define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
+#define XFS_TRANS_LOWMODE		(1u << 8)
 
 /*
  * Field values for xfs_trans_mod_sb.
-- 
2.39.2

