Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC9F4594D
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157415; cv=none; b=DHUzmXqS6q3dbrI90C+/fo5qHfBfnHu5Rh273uJmugrLIzSss8qVFM06hnk9xNg7QPyYvJEMseP1tRXLwhY3Qqqq5x1NoZBUz9nQ+BvP1ubUYgnKjiHtkmb0VHToTMoVMbyauLM7hKkNBObivrV0/nFf6qvJT1KNlVBUO8S8A+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157415; c=relaxed/simple;
	bh=HNqqVAOJDpD2rNFxmFhcf2eiAOpeqVT25dhCv9fqTz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSUJSpxemaoWHcAYhf0ZVKt/TY33FbqjTykv8N2ezuM/LeHu4uivf6CPsakSs5KL0+dUXFNc8R+L2jz8IPch1s3BTv9WFnmlr9mGQObqM3TTP3PLxzkgOPGEW2DnhvsgCTsOHiVwt703nwf5dpRLFKGc9YF2TceP3f9MQPevGuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1CztRdou; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1CztRdou"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wyhqwI8M8vuuOiJXuhEVTKQ41hEKUamNsR29jawexw0=; b=1CztRdouSIrknirmJ9e/mCLXRb
	rmmnA/xvfH6Vetske2elJmCPO98PZYyejbh/rJylXK70OdnTKYWqk5P9N+LbW5s0Da9LE1YXx/ekC
	PhMdhHjJiJd7yooM76Qwvy/15MH5f0e3ymPM6DMS0tOFy3IbnwIMTOh65l1JDw1KDO29sl2yApMw6
	gDHae35AhoU65QWcDJrPZs1ZkFyF/viMJ+q67fVYDnrJ8vYeCIQ9sYtLUWi5mY4UHk5PAr0h23eBA
	h6NF2KmFsSRmxYo3+m1m3PNtxVS29QmemwZrpf7HVVp0nRioGxhKK58GjO6hnxUhuxS0CRMKlM2xp
	fmAz4OGQ==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqv-00000000lOB-1BVi;
	Mon, 06 Jan 2025 09:56:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/15] xfs: simplify xfsaild_resubmit_item
Date: Mon,  6 Jan 2025 10:54:50 +0100
Message-ID: <20250106095613.847700-14-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Since commit acc8f8628c37 ("xfs: attach dquot buffer to dquot log item
buffer") all buf items that use bp->b_li_list are explicitly checked for
in the branch to just clears XFS_LI_FAILED.  Remove the dead arm that
calls xfs_clear_li_failed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_ail.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index f56d62dced97..0fcb1828e598 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -359,13 +359,8 @@ xfsaild_resubmit_item(
 	}
 
 	/* protected by ail_lock */
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-		if (bp->b_flags & (_XBF_INODES | _XBF_DQUOTS))
-			clear_bit(XFS_LI_FAILED, &lip->li_flags);
-		else
-			xfs_clear_li_failed(lip);
-	}
-
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		clear_bit(XFS_LI_FAILED, &lip->li_flags);
 	xfs_buf_unlock(bp);
 	return XFS_ITEM_SUCCESS;
 }
-- 
2.45.2

