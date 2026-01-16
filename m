Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6365035BDDB
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 10:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768558375; cv=none; b=YEYst415jr8n3HhIlV6TmQUNcd89n12tylpD+2vS5csry6/oSniKysC15YOR6l1xORs+3e1mTo5e9CYKQN11q9n/udLwTTTciztKDCkmz6Ze5dipEBqpIoVBKzb8wuP6vB9mbwEfnR1HX81mNToRkvMcdqEE9fpPfi9I03Cpl44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768558375; c=relaxed/simple;
	bh=O/4XGSC86fwFWb7KBotL0ki6du2GPd2ACgaYfPtgkkM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nCO05gZL9s8L/i8Y/oBXfthcjoEA86RpY80KIL5gxSpfkMowTUMi1Gq274JqHiEnWu9HuW2PoUq+NU/en0K0KK0qQtk2AYQ8Z6ZX9nSqMkytS3cK1lyY8QkhPt4ZSaPBNmir2GRak66MlZL5DoGc7Wh8qTG6wSZpj5NabEDf0eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=r9GKOMiU; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="r9GKOMiU"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260116101244epoutp04eb073584aea7e6f7d74527609ecd6c7d~LLnZg3QDt1319413194epoutp04Y
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 10:12:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260116101244epoutp04eb073584aea7e6f7d74527609ecd6c7d~LLnZg3QDt1319413194epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558364;
	bh=io11MxPXJQPqxLL7iBBOqNZeozDs1uZ30NCX7CyvzRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9GKOMiUp4gMUSjo7I+MJWiU0PhbHZnnLMKxCxJhCqoR/3U1cti+BkpWZy/3J9SWN
	 7+PvkOulg75I3vTEXzE/h/nue9r9zLCTZ38LL1hlC53ixcqhzGmyi8MnBGv5SC7RBS
	 VtUnaMHRDH4Co1HU/U8C5ko703Vxc3Z3ofr+U1/w=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260116101243epcas5p47d3397b5b858e03c77f31f6d97ac320b~LLnYhgzZO1433714337epcas5p4H;
	Fri, 16 Jan 2026 10:12:43 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dswdk4KvQz6B9m7; Fri, 16 Jan
	2026 10:12:42 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260116101241epcas5p330f9c335a096aaaefda4b7d3c38d6038~LLnWulmW_3171431714epcas5p3C;
	Fri, 16 Jan 2026 10:12:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101236epsmtip2df6f615c786d09af2b4885187f14ddda~LLnSEDhFj0634506345epsmtip29;
	Fri, 16 Jan 2026 10:12:36 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 1/6] iomap: add write ops hook to attach metadata to
 folios
Date: Fri, 16 Jan 2026 15:38:13 +0530
Message-Id: <20260116100818.7576-2-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101241epcas5p330f9c335a096aaaefda4b7d3c38d6038
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101241epcas5p330f9c335a096aaaefda4b7d3c38d6038
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101241epcas5p330f9c335a096aaaefda4b7d3c38d6038@epcas5p3.samsung.com>

Add an optional iomap_attach_folio callback to struct iomap_write_ops.
Filesystems may use this hook to tag folios during write-begin without
changing iomap core behavior.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/iomap/buffered-io.c | 3 +++
 include/linux/iomap.h  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8b847a1e27f1..701f2e9cd010 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -699,6 +699,9 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 	size_t from = offset_in_folio(folio, pos), to = from + len;
 	size_t poff, plen;
 
+	if (write_ops && write_ops->tag_folio)
+		write_ops->tag_folio(&iter->iomap, folio, pos, len);
+
 	/*
 	 * If the write or zeroing completely overlaps the current folio, then
 	 * entire folio will be dirtied so there is no need for
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 73dceabc21c8..14ef88f8ee84 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -176,6 +176,9 @@ struct iomap_write_ops {
 	 */
 	int (*read_folio_range)(const struct iomap_iter *iter,
 			struct folio *folio, loff_t pos, size_t len);
+
+	void (*tag_folio)(const struct iomap *iomap,
+			struct folio *folio,  loff_t pos, size_t len);
 };
 
 /*
-- 
2.25.1

