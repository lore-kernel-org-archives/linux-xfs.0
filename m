Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A54117CA1
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:43:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 784FC8F8064
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Yt6LdAtu7UpJAPMD (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:09 -0700 (PDT)
Received: from [107.17.164.165] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bYia3-0006LN-U7
	for xfs@oss.sgi.com; Sat, 13 Aug 2016 23:43:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/7] iomap: mark ->iomap_end as optional
Date: Sat, 13 Aug 2016 16:42:59 -0700
Message-Id: <1471131781-14107-6-git-send-email-hch@lst.de>
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

No need to implement it for read-only mappings.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d9d1f50..0342254 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -84,8 +84,11 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 	 * Now the data has been copied, commit the range we've copied.  This
 	 * should not fail unless the filesystem has had a fatal error.
 	 */
-	ret = ops->iomap_end(inode, pos, length, written > 0 ? written : 0,
-			flags, &iomap);
+	if (ops->iomap_end) {
+		ret = ops->iomap_end(inode, pos, length,
+				     written > 0 ? written : 0,
+				     flags, &iomap);
+	}
 
 	return written ? written : ret;
 }
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
