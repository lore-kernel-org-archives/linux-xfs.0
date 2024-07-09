Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B98144313
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 07:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720510490; cv=none; b=uXvjd1yrGAYLWe6RW7HHREAmv5/Ol3Zp/SOFd71GsCJzJ4Fve0C1HxcEGgnJlsy6+xf1j6cCElpt4pmPffmhngyfMh041MEfDiH3YaibPNb1nA9UahWFVGi6I8H8OnYyVUVlUdW3dPd0+HLpmV7E8TkLqIi21xDEyzw1cNlxk/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720510490; c=relaxed/simple;
	bh=M5/7SjzssW9/q/97W1nYs6Ky2CD6dkmcDvjhd5aVQQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rRPcOrIEpqvEcvYORIccSrt/zDzAZx4sniWzid6V6DhLM406FoLn4CW53JLQIX4dofBvR6NEOVdmPi2RYxNxRHsAOSgnRBFlI/wqL2Xxs42bgKKj382pemkKL8ObWukVtivI5rtHL5lWclVqJqbII330K/UuQeoeG599RkoAixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xIC+d9G+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xIC+d9G+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=dOW6faw035tSTQGy9vvWwKPS5DWX+nhWkbEKYYI4y88=; b=xIC+d9G+GOFa1TZOwmRKwwDq6B
	W9oulL17+wZ6+uWSd4DPKiT8anKJcKdQTWenP+KN0CTP5VAkOXHo9tGMg0PklNoUvSFWIdACat4ob
	IffRPdCAed1v8nHdVh6eBGUuWLqxXvRrvN69zKw0H4GjjTwLQCzjliM4NPBNWxWeNGqvSUSBrzeWv
	Ghx1Rf0zMEV4HMr7S2thXYBI/zPib3Duqna2Vqi7Rl6t6s27KVQGmhASzgiWKQipVYexZabQKDL2f
	595VnAG/+nQu81JiUeZrn+eMp2BRiG+J5h3Z+RsRVfMPzyU+RoiVTxzzZVMRovlVD8KCIIEU+9z97
	+Je1k8VA==;
Received: from 2a02-8389-2341-5b80-6f07-844f-67cc-150a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6f07:844f:67cc:150a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sR5N9-00000006FOM-1NCa;
	Tue, 09 Jul 2024 07:34:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2] libxfs: remove duplicate rtalloc declarations in libxfs.h
Date: Tue,  9 Jul 2024 09:34:31 +0200
Message-ID: <20240709073444.3023076-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

These already come from xfs_rtbitmap.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since v1:
 - now without spurious man page removal

 include/libxfs.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index fb8efb696..40e41ea77 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -220,11 +220,6 @@ libxfs_bmbt_disk_get_all(
 		irec->br_state = XFS_EXT_NORM;
 }
 
-/* XXX: this is clearly a bug - a shared header needs to export this */
-/* xfs_rtalloc.c */
-int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
-bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-
 #include "xfs_attr.h"
 #include "topology.h"
 
-- 
2.43.0

