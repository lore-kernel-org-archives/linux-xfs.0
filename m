Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B8E1EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907445; cv=none; b=mz+kupwKxLDC5LdkRMJwPeRUJILKCrIdEoNECUL+9CRu2FgslWQ/lSOsJobqFVsG1iFkETOIkt22aG73GRs3ATPb0YQlhACMyaBBCc2/ViCJVpJOmZ1xk9HMGedJ4UO59USNwEceHedcUd2eA0bjxhIx2JzMom/TSIAFHIKnC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907445; c=relaxed/simple;
	bh=SlKrl4Ixeh134AY0PCeudr9CxW4Set4UGwjrzEhS7lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+YZyj2XlwBYbH0jcB77iG1chZEM1rGVvynpRHi5upEcmYze4mhPJP5kXCWUIY8KyorSdwn3LZ0YaTxbULqHukF4Ynm0ylk/XH7lcs9aM1QlIws7zc5L165YVDVt/k7mo7PE8/YicRTApGFi4fB1hSdxtgzTYxUJpVoHuKnpzOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X5habwWA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X5habwWA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=d9dJpwiixAamyZOVhpg0Cl8GopmDkdNM6VPzwwzGXCs=; b=X5habwWAreo9V+8KRgVbtj/L/l
	uT2965P6mZRaP4yYwqy5uU1imuKARPb56/TxjIub8/7kSqG32MyXX3iBhGX+XNDCeh46KiVAS/Nb7
	gGCAuNdGVUcSFvETXebHhwy83oeAvoH3E/3qxNlt7Huu8kLDwKjgNG12Hoo356NUQs4odw25X8spG
	jIhUR3x8lIcNO/qInz2MzoAr59h4M7qtd/y+UYij44GjMMLeaAGdYaDJUYjPVM1RVpZ+YceXlU0Vr
	7j4TvlRWjITsXdwcswd8UIMZP4xmYxzz0CGNiY///lwmBn3AeTb7JD5vBieYDefH75UP5+qfVjzJf
	Jv2mY2tQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIX5-0000000EJBG-0Fjh;
	Wed, 11 Dec 2024 08:57:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 17/43] xfs: don't allow growfs of the data device with internal RT device
Date: Wed, 11 Dec 2024 09:54:42 +0100
Message-ID: <20241211085636.1380516-18-hch@lst.de>
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

Because the RT blocks follow right after.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index bb2e31e338b8..3c04fee284e2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -307,6 +307,10 @@ xfs_growfs_data(
 	if (!mutex_trylock(&mp->m_growlock))
 		return -EWOULDBLOCK;
 
+	/* we can't grow the data section when an internal RT section exists */
+	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart)
+		return -EINVAL;
+
 	/* update imaxpct separately to the physical grow of the filesystem */
 	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
 		error = xfs_growfs_imaxpct(mp, in->imaxpct);
-- 
2.45.2

