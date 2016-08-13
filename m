Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7A0C7CA0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:43:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E0ED30404E
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id jRZu3bVD0JSDCfGq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:07 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] iomap: fiemap should honor the FIEMAP_FLAG_SYNC flag
Date: Sat, 13 Aug 2016 16:42:57 -0700
Message-Id: <1471131781-14107-4-git-send-email-hch@lst.de>
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
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

The flag is checked as supported, but then we do an unconditional
sync of the file, regardless of whether the flag is set or not. Make
the sync conditional on having the FIEMAP_FLAG_SYNC flag set.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 74712e2..56c19e6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -467,9 +467,11 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	if (ret)
 		return ret;
 
-	ret = filemap_write_and_wait(inode->i_mapping);
-	if (ret)
-		return ret;
+	if (fi->fi_flags & FIEMAP_FLAG_SYNC) {
+		ret = filemap_write_and_wait(inode->i_mapping);
+		if (ret)
+			return ret;
+	}
 
 	while (len > 0) {
 		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
