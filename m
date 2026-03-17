Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC322D592E;
	Tue, 17 Mar 2026 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773755055; cv=none; b=ePKDzP90xQNkfcnFK5QqwjqkTqovSpSB+IRxFldDP67qHkz5cFPae4owkKy6Sz4Z/3qd0EYvhENaFnQVrGR3TN9J0BP5orwwrrY/0rE3qCx9csGn1woyE/NJ69Qa+x0LRGN3Rqc9nittEzhANS73h129LerDN52BJVAvAcISxp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773755055; c=relaxed/simple;
	bh=H5iAoUkv9rrKDqZp/Z4J9ELBVPR6LNcMR/XbORkB2uY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I6Hbo8DgKqOC+8kPKUMub8DcJ4iKywu5j2fRtFOPOEc0fnB2yz/HotpEoXAHq/8rSEIVB3NtNgFJ/gYvQX63swvVsCsLLwEcLOHUxDsgQFqU7f91JfhH4t5BiIrtVgDSHsaBf7yR6R6y+WGNFgS8CijyufWWCByoRAL4FSHWOyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hzD3Xy6Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hzD3Xy6Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=qdlZJQWinV/T/tEukgP9BgoZ1KsPHk6ar7zBuEJioC4=; b=hzD3Xy6QZD6klvvLARweBOZcAr
	JcldeaRxgQlvlScZbcIaGs5RIPFtN0SJXEvN7m5SJBqDXCWyaNtBPNg8IMA5kVX6xNWcJ4AR7K9kO
	9DgEl0xclY4VmMRnAQirUPH4NMNlMyOFuDMRt4Pu3+LcltxN/SKRp0Hl5lOSo/aWhxMP93pWnVHsM
	1XvlITEAkpb08EMoMWi37R6tuaE6RwWhjpjf/34CC3eRS68RAbsfeF5ivhbCSYAxX/uwVS9pJoF+S
	ANjUAv20kVFjm8TL88pOlN0AT1e4ZPeEjD6aRPQY1mfQwRcF40PY9A45P7PD0S3fTeyt7uhIjACUb
	x0Uo8K/Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2UiS-00000006TEe-1eEm;
	Tue, 17 Mar 2026 13:44:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: brauner@kernel.org,
	viro@zeniv.linux.org.uk
Cc: jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] fs: clear I_DIRTY_TIME in sync_lazytime
Date: Tue, 17 Mar 2026 14:44:04 +0100
Message-ID: <20260317134409.1691317-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For file systems implementing ->sync_lazytime, I_DIRTY_TIME fails to get
cleared in sync_lazytime, and might cause additional calls to
sync_lazytime during inode deactivation.  Use the same pattern as in
__mark_inode_dirty to clear the flag under the inode lock.

Fixes: 5cf06ea56ee6 ("fs: add a ->sync_lazytime method")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7c75ed7e8979..d8dac1931595 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1711,6 +1711,19 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
 	}
 }
 
+static bool __sync_lazytime(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	if (!(inode_state_read(inode) & I_DIRTY_TIME)) {
+		spin_unlock(&inode->i_lock);
+		return false;
+	}
+	inode_state_clear(inode, I_DIRTY_TIME);
+	spin_unlock(&inode->i_lock);
+	inode->i_op->sync_lazytime(inode);
+	return true;
+}
+
 bool sync_lazytime(struct inode *inode)
 {
 	if (!(inode_state_read_once(inode) & I_DIRTY_TIME))
@@ -1718,9 +1731,8 @@ bool sync_lazytime(struct inode *inode)
 
 	trace_writeback_lazytime(inode);
 	if (inode->i_op->sync_lazytime)
-		inode->i_op->sync_lazytime(inode);
-	else
-		mark_inode_dirty_sync(inode);
+		return __sync_lazytime(inode);
+	mark_inode_dirty_sync(inode);
 	return true;
 }
 
-- 
2.47.3

