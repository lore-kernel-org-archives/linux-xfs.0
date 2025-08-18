Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E313B26B75B
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 05:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493924; cv=none; b=iUW/JjQkJF4CGXJH7C1XcLAi4nCRWvq5e4oPgYElMzygdY2Ep3REPgm7NGHoPQDLsfJBLXqIEoYtAehPjQc28FJOc+lKaTYeTZ5Xo3sr09SXXtmicFOKDliItb7xz1YSvu1lBdkK8N7dcNqhwlqIy8iLjF5NlKcNT2lw5w5IrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493924; c=relaxed/simple;
	bh=hB1rJR+sI/TAo4uoCJc4ZG05Bd8OdvyaRvv5kvGGBUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhWL61IMHl8xdEYdDOCR7Y5tTWtTUDepvZFkthRG57Tgz4SnujzVVPI1pjLrPqVbLzviQmZVDM9glmzKzSM0yIrOl5z9zld6ix82RdXDdkrbVnzKE6zzgrcDUorVqEOrhre+R9ap6vXg173VxW3D3WCYEUqxhjwg6YPej8pA1jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V8l6OwSc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V8l6OwSc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yo25JLYWRlQMb9afUnXWRG91upyB8emkfT7XdnKIqko=; b=V8l6OwScIjXooNI5qg0/cmEv0B
	HRY2mMQP2DM59eWNcEpa/wYwQmvzGOtDeAR9LvR3qV0Jk/9G2i1e1taUthwW5/N1v0EwFnPYEJQdm
	51rBJOWUgAsJkmdyEGH0hmFyItnDdqBRjbEKv3W9sYSFFvlQU5wNt8ri5CPjbD5EFp+S7YVQeKfyr
	eU4INdgqBquyBdGHPMWYQ2ZU7/b355RyZ1z0Ab/nu1pBWOMYEgfi16k/saPFm+Q5zs3zXhiTTGKD4
	ANIk+pX6MIeSHNNsUCte551nBuWWvyp0Gq4ckdXRjyXuvItO94+uG28lwwKCZb17Y3joYFDnHiF+E
	zwXDEiow==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unsA5-00000006WmW-48qu;
	Mon, 18 Aug 2025 05:12:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: use bt_nr_blocks in xfs_dax_translate_range
Date: Mon, 18 Aug 2025 07:11:24 +0200
Message-ID: <20250818051155.1486253-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250818051155.1486253-1-hch@lst.de>
References: <20250818051155.1486253-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Only ranges inside the file system can be translated, and the file system
can be smaller than the containing device.

Fixes: f4ed93037966 ("xfs: don't shut down the filesystem for media failures beyond end of log")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_notify_failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index fbeddcac4792..3726caa38375 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -165,7 +165,7 @@ xfs_dax_translate_range(
 	uint64_t		*bblen)
 {
 	u64			dev_start = btp->bt_dax_part_off;
-	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
+	u64			dev_len = BBTOB(btp->bt_nr_blocks);
 	u64			dev_end = dev_start + dev_len - 1;
 
 	/* Notify failure on the whole device. */
-- 
2.47.2

