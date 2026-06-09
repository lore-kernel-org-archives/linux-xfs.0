Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C613E5EE1
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780991826; cv=none; b=nfTVBJfaOUHxKvX1MvSfK8KN4xwcQACZqmH9PrS14hgFxTdj8CQehmOi/NQdky/9cli0DPkIJ6wBNbaruE3MtWmF1EhbedoNZruT06lQNqnZGDdMGP/dgmszPm2IlNwpa60Vcaxtyi3dJNI8dzZ8UfF6XvD8i8GOqfudybhDR8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780991826; c=relaxed/simple;
	bh=uK3Y+E7Fip4ayuueFDj1SL/OT9Wlmm/1X+1fOQb8hn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojFtNLwhh3gKvgGDtjYbImpl5BKjYex2+65NAYYyJgr09Op4Mg6+vwowzPPsSKrT+D7IDvLxpaW/7SNc3MkAOthCK+dvSeRkx4aYxz7W1UIhWMkaHISpWmWXOTqpV/+cEdOcb6nOxf+C2rw8HheWnSvlsdmhnaEUytsT8OnooL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2y1SiM8H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2y1SiM8H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YEL54FLEs9PbyWWVJ3C3gdgBwDJUkAyxd+J1Y/Ecpv8=; b=2y1SiM8HNZlfnvK0Hfw/Uo5W6o
	RXRr6CqC6/Pc7xDuRRMxI5AdIi0T92YjNxj4C6Q8IQUoTVmEmLNCpceTp2N2QftinKRpWlACduBYh
	tOl9AIj+u8PQj22juT+lZePqBClfbFdX+mfkQXtrCQIgONh+T2YsiN0m2LVyKQ64dN4N/+CrLHSAI
	mPJUIyz6NAnKOf0KO9zuZClyLfsDflQTkCpSam6xotxEczUbMY0NeIcSKG3DuY9fWKV4ftWRlO3Xi
	3psTj5e8c3nB23g17mUcsUXLpXLlKL/OWTRSpF+usLUetvJjJQecc736hedFp9fXCWOJj8JIc1OK7
	ZoXGVN2A==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrKb-0000000510B-0Ve7;
	Tue, 09 Jun 2026 07:57:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: account newly added RTGs as free zones in growfs
Date: Tue,  9 Jun 2026 09:56:42 +0200
Message-ID: <20260609075655.1698743-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609075655.1698743-1-hch@lst.de>
References: <20260609075655.1698743-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When growing a zoned RT section, the newly added RTGs also need to be
tagged as free in the radix tree and add to the nr_free_zones counters.
Call xfs_add_free_zone to do that, otherwise using up the newly added
space will wait for free zones forever.

Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 153f3c378f9f..fd07c1a18615 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -933,6 +933,7 @@ xfs_growfs_rt_zoned(
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_rtrefcountbt_compute_maxlevels(mp);
+	xfs_add_free_zone(rtg);
 	xfs_zoned_add_available(mp, freed_rtx);
 out_free:
 	kfree(nmp);
-- 
2.53.0

