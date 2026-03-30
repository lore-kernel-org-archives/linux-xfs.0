Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877A21EE7C6
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849561; cv=none; b=bCz5/10eFjS4bnleD7f7TPnOYcuWjOWBFepyiS9prxYxNYaLvKBFxP8aNPYQcuX9LeEETpvfbA0ocd3xYYd19uJOntfmtfdf6AKLAC+9PTYy5D6SbEoeLFv3ytyaOSy6TbsbIC11YXcnlrAn5XAk61Xgg6zIbY0rRnhlD0fkMck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849561; c=relaxed/simple;
	bh=cOAGl9c0Z1K8DTZo1GvmMI0J9z9gjtYz9YI9PY78u6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kavM0y1fYSsrxA3eViLXXZKDi1EZWq0JY//t6XTW7Q8c0CYJTa1B1RpKLUuXhwMHWRvfC9vtVGa67BlPZ72F+mXxRsw5g2KKGKHJ8kFdmeezcwViMhXGQrb6/mmrx3c/8B7bULm3pBbp2b0jc7zrcQSqmV40hr7JHQ7lrWZF4wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JavlDobl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JavlDobl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=P5RiYqgPYLRw+giwt7ue0qgIqieahBSER0o+tkCWZZw=; b=JavlDoblzcFDSo/cwF7kWNBZOC
	2rORQLyqwXtxG61bw5EhYZIccMq+WH6Sq5wiNnABcqiCxJ/0jlOOyBgNeYCgMAjUL0N5LnOs0THqZ
	RTAHm+jyzp8u29h0lfCOhjKP7uzEPCAC+A3y6f6agUTmc7iT3+j7Ytyu/MCc0LZ7KFg3Z0wMihX7G
	hWGmydFQcPbiFwvH4mIPygErWLsRgpY+oWrA9Djwl5QarL+XfZ1t2H8kMSA5g7fNRYgNk9YhxMXN9
	1b2OS1BJDP+ga8Kk1AA4YXon9CjHIMBwL8zPNcPT7MCOrgebcJxCk1Z+mqeVKtj1IYcrsA7NTnEYM
	5WDiGuAg==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75Rn-0000000AeWY-2nu8;
	Mon, 30 Mar 2026 05:46:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: add a separate tracepoint for stealing an open zone for GC
Date: Mon, 30 Mar 2026 07:44:12 +0200
Message-ID: <20260330054533.3856339-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330054533.3856339-1-hch@lst.de>
References: <20260330054533.3856339-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The case where we have to reuse an already open zone warrants a different
trace point vs the normal opening of a GC zone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trace.h   | 1 +
 fs/xfs/xfs_zone_gc.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 433f84252119..c1aa15973e74 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -394,6 +394,7 @@ DEFINE_ZONE_EVENT(xfs_zone_full);
 DEFINE_ZONE_EVENT(xfs_zone_opened);
 DEFINE_ZONE_EVENT(xfs_zone_reset);
 DEFINE_ZONE_EVENT(xfs_zone_gc_target_opened);
+DEFINE_ZONE_EVENT(xfs_zone_gc_target_stolen);
 
 TRACE_EVENT(xfs_zone_free_blocks,
 	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index f076f66c5d57..273c496c2f1c 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -543,7 +543,7 @@ xfs_zone_gc_steal_open(
 		return -EIO;
 	}
 
-	trace_xfs_zone_gc_target_opened(found->oz_rtg);
+	trace_xfs_zone_gc_target_stolen(found->oz_rtg);
 	found->oz_is_gc = true;
 	list_del_init(&found->oz_entry);
 	zi->zi_nr_open_zones--;
-- 
2.47.3

