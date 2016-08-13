Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B7217CA2
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:43:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D695AAC002
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bFL6CtogqO4WLUB5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:06 -0700 (PDT)
Received: from [107.17.164.165] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bYia0-0006L5-VH
	for xfs@oss.sgi.com; Sat, 13 Aug 2016 23:43:05 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/7] iomap: remove superflous mark_page_accessed from
	iomap_write_actor
Date: Sat, 13 Aug 2016 16:42:55 -0700
Message-Id: <1471131781-14107-2-git-send-email-hch@lst.de>
In-Reply-To: <1471131781-14107-1-git-send-email-hch@lst.de>
References: <1471131781-14107-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This catches up with commit  2457ae ("mm: non-atomically mark page
accessed during page cache allocation where possible"), which
moved the initial access marking into the pagecache allocator.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 48141b8..f39c318 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -199,7 +199,6 @@ again:
 		pagefault_enable();
 
 		flush_dcache_page(page);
-		mark_page_accessed(page);
 
 		status = iomap_write_end(inode, pos, bytes, copied, page);
 		if (unlikely(status < 0))
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
