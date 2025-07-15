Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64AB2DE71C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582707; cv=none; b=Ouzxe7eBitZAhdoUqyoodo9UAVtiC+pjQOKmPtkNrJJEb5R/Q0ahZjyD2ICEd2w24hrTev+TeHNJkipUotR8ab0Vk18o5jLP4Vmq9TtaM/qvVEIxYHHaEZnP6YdiI9dlsajDvrTJX0Ecfg/foXknPyP9iLyDcNjCLvf79aOYitc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582707; c=relaxed/simple;
	bh=mZJrvR6AQp9Vh6SSb69yEB/cTc2/srI1rE9XXN/60e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1u8cT4yay/H0DGo+VLypRawTIx5NUZ8ZQyLTlCrThvG9It2eA8CjbqZ5RhjGlEECvuV45y2xt3tOMfNf/ZiVswl2cVlx8RbDkbdPpiulX8XKvh57ZvZ4BsgbwbsKd5YtCF4R537uTXBzC3YrSGI6ZT8qipQnKiF0FYPnPxjiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=twjJR9HL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="twjJR9HL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XaUJXUwDWzNAEsw6y53sEcuN4ClxhoZQXLUe1I8C6cs=; b=twjJR9HLj0l5KWrmb0kpZ5Sa/7
	N/YDuPfJud+E06pmqxnr5KZXZIa142REO7ZaC0nW78ktP7TfJBZud/k7svdv+0IpOm74/NuAldxrs
	XdDw5rt3OeQAt2dV6TDgXhmcV0xq/WINIu7ySbopIr+isM1qZ43JO9eSeTfTpuuYcwWSbz810/dAB
	lfNll+vhTM1xYfBkeXI1GfcxvxqHqWaxatDUqvK0SfC59gC+b3ztwEO5mb0YRNubL/3K7lqYx/nJe
	TEV7afT2kkoVYwWW0kaxlrptFJf6MvR+r4C7TFa61BtyS8SEnxw26fdSHFcDYYYJNgy2DJ3eFjXDm
	/+Zy9BvA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubeoz-000000054pk-0YAJ;
	Tue, 15 Jul 2025 12:31:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/18] xfs: set lv_bytes in xlog_write_one_vec
Date: Tue, 15 Jul 2025 14:30:12 +0200
Message-ID: <20250715123125.1945534-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

lv_bytes is mostly just use by the CIL code, but has crept into the
low-level log writing code to decide on a full or partial iclog
write.  Ensure it is valid even for the special log writes that don't
go through the CIL by initializing it in xlog_write_one_vec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 96807140df73..2e2e1202e5bd 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -858,14 +858,15 @@ xlog_write_one_vec(
 	struct xfs_log_vec	lv = {
 		.lv_niovecs	= 1,
 		.lv_iovecp	= reg,
+		.lv_bytes	= reg->i_len,
 	};
 	LIST_HEAD		(lv_chain);
 
 	/* account for space used by record data */
-	ticket->t_curr_res -= reg->i_len;
+	ticket->t_curr_res -= lv.lv_bytes;
 
 	list_add(&lv.lv_list, &lv_chain);
-	return xlog_write(log, ctx, &lv_chain, ticket, reg->i_len);
+	return xlog_write(log, ctx, &lv_chain, ticket, lv.lv_bytes);
 }
 
 /*
-- 
2.47.2

