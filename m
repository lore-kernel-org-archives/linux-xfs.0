Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8611BDDB
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 03:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724470878; cv=none; b=JvMU3brCryr9gSrc63B72z5fVZfQL71vVnb3P1QEIwRu6o+gdJXPXuKpWEWnWuKnsrHmK0ggq7hxvIrATrqKR8OsWlGOiv07qZHEkuBWsY1TgcPgjIGeOXSniEig7dSTfqiI5TufW9w6z0RkZuoxGPZQAlBAW1WiyCSnUFWo/Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724470878; c=relaxed/simple;
	bh=hiPirQU743fqMaamvNwkvWll+ePXTl4rcbXYGUuRk84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o96q5cizRlI7rRS2IYmt3KTAACdzg5d/R3JT0kBNFLpSC7X9yKNxgRmf/qzGiu3vwjuFekKeH9nqhlLh1zqytNBGTHK2Al1J+KKW8aIDn6kYivVvbbx/BEb6XKkbU/+s07S8EIsvceok3nq32wQW+T117MpLjn0USkycmof0OVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ms5RO1fI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ms5RO1fI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WV91XfuPalAR6sncgRRkCFH/g4wVSAS8w3cADrhfJm4=; b=ms5RO1fIKh1ShlsfRG7TLLgCo9
	K3IEwxwmyDVpxICEuvV0n5fM52klSaxclAzzYU/iYJxM5RAZeM//gXkJQE7OYr9YfyJQ5PgrYhLTv
	/LDUyw6dQAiqIgfHRKZ0eSMnfsvSuCsJO11ZJ/qRjhWkvl7E0ERhasiur30JkjcpQs7JtMt1h6UCW
	am3Uo7YlWWP+IAKziXv9dOHh/DD+aNaDfq4yypALdW/3vkd/j9ehtuh/Eb2zJpv8bXwPUTOuJuRiV
	uu1R0Jo/Na90hrPZm20IyYye/5ijklWEYw9PnXrIPuCYjh+ZxnVsIcBfn44+RHHyfUxB8ICSGd2jG
	kaTvrukQ==;
Received: from 2a02-8389-2341-5b80-7457-864c-9b77-b751.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7457:864c:9b77:b751] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shheO-00000001MSG-2W0u;
	Sat, 24 Aug 2024 03:41:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
Date: Sat, 24 Aug 2024 05:40:12 +0200
Message-ID: <20240824034100.1163020-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824034100.1163020-1-hch@lst.de>
References: <20240824034100.1163020-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
variant fails to drop into the lowmode last resort allocator, and
thus can sometimes fail allocations for which the caller has a
transaction block reservation.

Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 73c5af9f0affed..f890d8dc25e47d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3493,7 +3493,13 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 */
 	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	return xfs_alloc_vextent_first_ag(args, ap->blkno);
+	/*
+	 * Call xfs_bmap_btalloc_low_space here as it first does a "normal" AG
+	 * iteration and then drops args->total to args->minlen, which might be
+	 * required to find an allocation for the transaction reservation when
+	 * the file system is very full.
+	 */
+	return xfs_bmap_btalloc_low_space(ap, args);
 }
 #else
 
-- 
2.43.0

