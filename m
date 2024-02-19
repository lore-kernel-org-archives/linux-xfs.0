Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5360200A8
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324058; cv=none; b=aYy1gi+2de+UgZidKpcl5Qs8ghELdC8E6gDR56O5kgoWECKmShhPNL6ergZL22TG4wTCyVhzXuwLsYloElUo6mCbMy5gR3G5WEy/E/lb5vaQqejKFU+CsNivY52ZkEUO0+o7Dhj5VmX/ZjYusgcVjkTEQNqV87Ok6/VSXvh676w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324058; c=relaxed/simple;
	bh=asWyTZR5sM/RtofU9C1Ep424/hv8nEGWcp+XbhedjP8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iEPpbozjP+Ye7YRnG279DoAtsCjVPHTaPcclvRt/pJRjqJRPPp1Z1R3D5a5kRGiAuQqKQNxs3u83IJ5Eie6YSZ+a/wwhTkPP5hdGwaIa2mRVlrktON6q2Q3H0z8yGgoDm8Y4Ynfn7g+GkpBl1m71Z5rM32uRqCjaWx5B4/9+roI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uMHAlgvF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uMHAlgvF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=G9kCHf8br8WAlr/5Maj7Cft4763G9D9A1HkLivVroEo=; b=uMHAlgvFkjgJFvg8rWoBpfry0I
	B/cRAS3o+MWlhEdAz7eBRD1bgWGbyVxrJtL2M1GJeGs5h7HrweyCLyAuRBVJGrlqvbkADqgAcr/cO
	qwFQFNnXTB9zPkAz+9ZKXk9VWtwGS6yBs7Cow7qllaMFDgz4yi3Z0PETha4gird3YMUMeohSWtliW
	P8dGvtwAnW54RQ09zW6zT/Z+6/DLK05M9ZZaLWdgE5cmkHz5LDK+SSwuNKvio07YB3dSJFeW2fcZJ
	NCuWhCtb95mm/DsCXI+mbC0tWpglIVRIwxOL2OidobsnTtsQjr30tXwFZi7ZmfaLAxeeETHK7+VQr
	YzbJmnuA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7m-00000009F6v-27MR;
	Mon, 19 Feb 2024 06:27:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 04/22] shmem: move the shmem_mapping assert into shmem_get_folio_gfp
Date: Mon, 19 Feb 2024 07:27:12 +0100
Message-Id: <20240219062730.3031391-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the check that the inode really is a shmemfs one from
shmem_read_folio_gfp to shmem_get_folio_gfp given that shmem_get_folio
can also be called from outside of shmem.c.  Also turn it into a
WARN_ON_ONCE and error return instead of BUG_ON to be less severe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1900916aa84d13..ad533b2f0721a7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1972,6 +1972,9 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	int error;
 	bool alloced;
 
+	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
+		return -EINVAL;
+
 	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
 		return -EFBIG;
 repeat:
@@ -4915,7 +4918,6 @@ struct folio *shmem_read_folio_gfp(struct address_space *mapping,
 	struct folio *folio;
 	int error;
 
-	BUG_ON(!shmem_mapping(mapping));
 	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
 				    gfp, NULL, NULL);
 	if (error)
-- 
2.39.2

