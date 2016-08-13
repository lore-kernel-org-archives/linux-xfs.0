Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 16D0C7CA1
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:43:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF0FF304051
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QrJL6xub5Cj1q7h7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:07 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/7] iomap: prepare iomap_fiemap for attribute mappings
Date: Sat, 13 Aug 2016 16:42:58 -0700
Message-Id: <1471131781-14107-5-git-send-email-hch@lst.de>
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

By bassing through an -ENOENT, similar to the old XFS implementation of
FIEMAP_FLAG_XATTR.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 56c19e6..d9d1f50 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -476,6 +476,9 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	while (len > 0) {
 		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
 				iomap_fiemap_actor);
+		/* inode with no (attribute) mapping will give ENOENT */
+		if (ret == -ENOENT)
+			break;
 		if (ret < 0)
 			return ret;
 		if (ret == 0)
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
