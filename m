Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730B12C2357
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031010; cv=none; b=e3to7MurSSkBFQTzmmT2BbqWdanmj6IfiES2ZWB6pYUwLptpeEp15Ct++K050LZF3JFdWlAnbs1rQIM9C4FOOx0TFVNfmHVvXE5rEhdDa25+jC33K+oT8+yJNZip2UJGL5iuB5mdkdlZ/uWvpihfWcCNEmAGyGUtcOkjWJ6bX+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031010; c=relaxed/simple;
	bh=dkWenSgmf847XOA8Xnm6XtJmxP8PMWaC7TraJFr47Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOFNb8ek5V3PlrNMfBYO3+Z7tnlqPIDMm2CCkTUuqQxvK/g1MvHhe894sLfRzEEhmy63H8RsoAc+qUN9Dvcg9wG9ZV7Ph22oEK7B5083VccyF1aIFLO0bPNYeaO3nLphIgWgzdz3kFSwAIJ3j8Ni5OibgxLSSDrc3okOX1fNnQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CcUZF6FK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CcUZF6FK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=U9cSTKKRUL6+yQorhtOwoMP4k6iovZGcYu0qn/1Afew=; b=CcUZF6FKrOtxgS22SSBbNno45d
	l6MCpqn3z1cHlpz28SL/Q243Ib0l0mS0SuHWkQEiAymm6515l10XdZySOYWxcM35cxvMDrzCiRmKB
	ZNm/K5c9aIYpUtEhDd9f1mj39Hi4XmGF86EKYorZOu4kiU2dET3Ki8Sj5g5yjy5fcuqaCzsWQOq9P
	vX0RNs6BYOd7KpjNrR8oN5ibR+b3DoF08L4fQ0Vzy/emONdELehDeXBUN1PyouRVYOSoTw4b1n/7x
	MYmcvv6OA5mWsxjezV6AfWwP/0xC4OTdBqnhrp6WQkxHyAi69fV3xQR+HK0yP8GOq5QQsWkzQ6Y/Q
	4S7IRq4g==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyWAp-000000080V7-0GYc;
	Tue, 16 Sep 2025 13:56:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: cleanup xlog_alloc_log a bit
Date: Tue, 16 Sep 2025 06:56:28 -0700
Message-ID: <20250916135646.218644-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250916135646.218644-1-hch@lst.de>
References: <20250916135646.218644-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Remove the separate head variable, move the ic_datap initialization
up a bit where the context is more obvious and remove the duplicate
memset right after a zeroing memory allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ff7301c39724..cfe023256158 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1367,7 +1367,6 @@ xlog_alloc_log(
 	int			num_bblks)
 {
 	struct xlog		*log;
-	xlog_rec_header_t	*head;
 	xlog_in_core_t		**iclogp;
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
 	int			i;
@@ -1461,22 +1460,21 @@ xlog_alloc_log(
 				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!iclog->ic_header)
 			goto out_free_iclog;
-		head = iclog->ic_header;
-		memset(head, 0, sizeof(xlog_rec_header_t));
-		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
-		head->h_version = cpu_to_be32(
+		iclog->ic_header->h_magicno =
+			cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
+		iclog->ic_header->h_version = cpu_to_be32(
 			xfs_has_logv2(log->l_mp) ? 2 : 1);
-		head->h_size = cpu_to_be32(log->l_iclog_size);
-		/* new fields */
-		head->h_fmt = cpu_to_be32(XLOG_FMT);
-		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
+		iclog->ic_header->h_size = cpu_to_be32(log->l_iclog_size);
+		iclog->ic_header->h_fmt = cpu_to_be32(XLOG_FMT);
+		memcpy(&iclog->ic_header->h_fs_uuid, &mp->m_sb.sb_uuid,
+			sizeof(iclog->ic_header->h_fs_uuid));
 
+		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
 		iclog->ic_size = log->l_iclog_size - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
 		INIT_LIST_HEAD(&iclog->ic_callbacks);
-		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
 
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
-- 
2.47.2

