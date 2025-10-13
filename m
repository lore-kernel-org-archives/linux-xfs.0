Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6BE35948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323774; cv=none; b=HGC65uNpWBUiaOhnHpKJ4dqEDbTg2EBj7XQeRiFv8DWNoEUVtHQhawoMpo1tdvAt3l/KvQV1pVFVbj4ajejR04atcEE9rQjgZBMv7S9QeRFlnXXNNpRtoCI8s0YJyACFONRotFYDt1pnABq8e3RKMVsoYvkyL79+tZl5U2GpyZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323774; c=relaxed/simple;
	bh=oO46cffkJRPJ9NbAbaDm3Y1dRuThB+Fq4AFSQLx6RMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLe90s68cjM79DoqmzWjV8yIcHeYOExqtO4yjs9BQI4RbhraJqZht4WRqOHIJWfvEFBbArmxcgjoq9HVud0OCmv7uf2TNuC6rAfBOyo+kwqL0KQDSx5OUP5dUueCwS+WkE/PtJNiHpB9ifDTuQ+EkwkLmf3xn9isiZ1W6J+52zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UgoCfSlo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UgoCfSlo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L0cj5F6dIBAJjERafeFH9kEGGylABg6/e1OuqYatLiY=; b=UgoCfSloeVMqNFm8T3DfOkAuC1
	x+8WzR96HlbixuDx7KFk7sWlmm+3DMUFmfIJxRfFpTTWo3Q5ExGA0vQo120y1IbWfxJWaV0+F/nj3
	TC37vplZqw2He1yqrscxGVcZFPN/9p+bkQ8tEQcEHwyrkP161aTzBFKZNMFPzLMD/Xy4f/3EzmJdJ
	od6xJz8vVk7/f5rCYhkxLsqlQSkZYhLqs8czTLPY16Cu6NkEPkU+yq9mlpyaMx7YXcob4LkyuDIgc
	tAxtdsgFS9uBH8BrBz6Z3jtImEfeLihVWciNSyiI/sMM3pJjqAyP18PWriigEvsmYVBqjg+rtewOD
	ToNtdPvg==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88cu-0000000C7gN-2L7j;
	Mon, 13 Oct 2025 02:49:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/17] xfs: xfs_qm_dqattach_one is never called with a non-NULL *IO_idqpp
Date: Mon, 13 Oct 2025 11:48:09 +0900
Message-ID: <20251013024851.4110053-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024851.4110053-1-hch@lst.de>
References: <20251013024851.4110053-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The caller already checks that, so replace the handling of this case with
an assert that it does not happen.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c    | 13 +------------
 fs/xfs/xfs_trace.h |  1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9bd7068b9e5a..80c99ef91edb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -297,19 +297,8 @@ xfs_qm_dqattach_one(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	ASSERT(!*IO_idqpp);
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
-	error = 0;
-
-	/*
-	 * See if we already have it in the inode itself. IO_idqpp is &i_udquot
-	 * or &i_gdquot. This made the code look weird, but made the logic a lot
-	 * simpler.
-	 */
-	dqp = *IO_idqpp;
-	if (dqp) {
-		trace_xfs_dqattach_found(dqp);
-		return 0;
-	}
 
 	/*
 	 * Find the dquot from somewhere. This bumps the reference count of
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fccc032b3c6c..90582ff7c2cf 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1399,7 +1399,6 @@ DEFINE_DQUOT_EVENT(xfs_dqadjust);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_busy);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_done);
-DEFINE_DQUOT_EVENT(xfs_dqattach_found);
 DEFINE_DQUOT_EVENT(xfs_dqattach_get);
 DEFINE_DQUOT_EVENT(xfs_dqalloc);
 DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
-- 
2.47.3

