Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D487DDB1
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 05:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714369634; cv=none; b=fnMB7rS5VxZfyejKvoaQb0bCgmiJNQVgsoYICaKUDlljCozPFsxOPzTagLtQ7TSqz5PerGWnWLCJChA+mKPRQAeZD46AReHbhtPyaY2gOZXBiutTeaEV8Dr+DhcVuhBJ1j9x+WkBVJXpxpuHTqmY4hIAWLWqqwz2lpV3/RCvSdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714369634; c=relaxed/simple;
	bh=ANY6eBQDUNSWA+yGZpO145WImdVYktHMNJzWKs22I4k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GekO7QlL5wjZManpBAd2+pMdeb0k3kINEODNNVmRDCctfhfF7eDoOzUWe/13Q6FgF/HvH+76wRMMPi8gLlViI8bo6A1A1dT4IW9FVcAmXAiu0WC8qncdix+DrFA7RvGTYvU2SZ5IC1qegEPZc5Qb/GHhgjMhiZiQAgO9JmoBSb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yq7eDAHs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yq7eDAHs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SJvYXm32u+nWT3WytsBkuXdj6i0UsjWFcaJXvyE7BqM=; b=yq7eDAHs3hj2ncu+ItRPuqcnBL
	upMzkA/OMiBiARGwRBnjYV/LFX6pUNh/Zx7zQQtTowiwMyF1ocXQu3WPhm4bDCCs3+vHBTnDBuWx0
	Sk76sfg9CULFZOiFORejMSc+FLPyzC4GJuX6Aba5Vlg2fPo3Znw3qcgj+P6DbR3cC+TDmHzeqSDCW
	nENHB54KEDiK0Iky2BM4wbqOV0YLDWPxNj6BrHWJVTxJtDluUWJWHABhwomSYlVWnt6Oo6wjsvRU6
	JTxRF+yPiKrUMgATAhiEXcN4vcTc8pil4nBiHzplsv7THhSJAcQiOXcnsnMpEIoqStEh89SilrU2C
	nHVDfDHA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1Jr2-00000001Xz5-34kC;
	Mon, 29 Apr 2024 05:47:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org,
	osalvador@suse.de
Cc: elver@google.com,
	vbabka@suse.cz,
	andreyknvl@gmail.com,
	linux-mm@kvack.org,
	djwong@kernel.org,
	david@fromorbit.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] mm,page_owner: don't remove GFP flags in add_stack_record_to_list
Date: Mon, 29 Apr 2024 07:47:06 +0200
Message-Id: <20240429054706.1543980-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This loses flags like GFP_NOFS and GFP_NOIO that are important to avoid
deadlocks as well as GFP_NOLOCKDEP that otherwise generates lockdep false
positives.

Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Reported-by: Reported-by: syzbot+b7e8d799f0ab724876f9@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_owner.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index d17d1351ec84af..d214488846fa92 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -168,9 +168,7 @@ static void add_stack_record_to_list(struct stack_record *stack_record,
 	unsigned long flags;
 	struct stack *stack;
 
-	/* Filter gfp_mask the same way stackdepot does, for consistency */
 	gfp_mask &= ~GFP_ZONEMASK;
-	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
 	gfp_mask |= __GFP_NOWARN;
 
 	set_current_in_page_owner();
-- 
2.39.2

