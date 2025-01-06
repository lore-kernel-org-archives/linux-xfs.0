Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0C84594D
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157408; cv=none; b=CasqeW3z2/actajmF3pcdQiq/at/jdGxKMwAcnNQLEw53NdMzDiPCxO1Ro4Bq1O1mKDOuiUjcJm9HArI//m3STNx62LplCBsNF5d167VTQWWwufR/0yYmT87XiEjrFkUfI7kcWd0oeyQWzzb5n4al86lX76fB8pcI6Tb/nwl578=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157408; c=relaxed/simple;
	bh=FEEHMimxb8AV8sC3khElLhJfSqHnHL60MlY0KF0BzgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7jQ4n5CsoCGELAV131tyhY1iNNggKl7A+1dnU+syuK72NscIYocfzVOUOH93ZNouwI348FUZtLfgaqfcLShiPFmNqa0OZfEDxeMH711hmD4tqYknJoMrqPjgFwWZNz+9R1cI+sl1D+oWKH7IVPMFQOITTclkSZfXiW8/+Y1qvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d6mDcVFy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d6mDcVFy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vqLno5ZLNrf8Go2XWxDI+JsaOXtCFHVsDtWDXcEBU+I=; b=d6mDcVFyXDp5i72Sn/6P2kdko3
	vlUPPvN0vyVN/7UQtz+nd4b3wBLzG3rPcg0cg4WJkCiI0r94hT9/pQWD0wEAvebxiTq8W3KYmIuDQ
	R9HPrGWQlKHBz3jIl14D+ZfJRcKpmJwUOU0H+g0AdcKVzcZiU5ZCiaMXQGAffNjLHaJlzyi9IgBNC
	FmUBsLATDBWaOMajfvhzEwf5b6VmqLt3sY8l1HIhgns2WA/F+yk4/NG4gidQm8Yzfhhv5pMMA2JJ1
	5dxxyWZYBOHyR5j6E7xAunXY7nOxxc+Iuk3HXlzJLavqAWuZU8Bt+bAkhIhWGtKdyvO+ZToRoGwIB
	HOAAA2Gw==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqo-00000000lMz-2KSj;
	Mon, 06 Jan 2025 09:56:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/15] xfs: remove the extra buffer reference in xfs_buf_submit
Date: Mon,  6 Jan 2025 10:54:48 +0100
Message-ID: <20250106095613.847700-12-hch@lst.de>
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

Nothing touches the buffer after it has been submitted now, so the need for
the extra transient reference went away as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 49df4adf0e98..352cc50aeea5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1646,13 +1646,6 @@ xfs_buf_submit(
 		return -EIO;
 	}
 
-	/*
-	 * Grab a reference so the buffer does not go away underneath us. For
-	 * async buffers, I/O completion drops the callers reference, which
-	 * could occur before submission returns.
-	 */
-	xfs_buf_hold(bp);
-
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
 
@@ -1675,20 +1668,12 @@ xfs_buf_submit(
 		goto done;
 
 	xfs_buf_submit_bio(bp);
-	goto rele;
-
+	return 0;
 done:
 	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
 		xfs_buf_ioend(bp);
 	else
 		xfs_buf_ioend_async(bp);
-rele:
-	/*
-	 * Release the hold that keeps the buffer referenced for the entire
-	 * I/O. Note that if the buffer is async, it is not safe to reference
-	 * after this release.
-	 */
-	xfs_buf_rele(bp);
 	return 0;
 }
 
-- 
2.45.2

