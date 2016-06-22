Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D95A57CB1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 10:27:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB82E304066
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:27:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id msMqZAuC0pC3fUFz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:27:28 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] xfs: remove s_maxbytes enforcement in xfs_file_read_iter
Date: Wed, 22 Jun 2016 17:27:11 +0200
Message-Id: <1466609236-23801-4-git-send-email-hch@lst.de>
In-Reply-To: <1466609236-23801-1-git-send-email-hch@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

All the three low-level read implementations that we might call already
take care of not overflowing the maximum supported bytes, no need to
duplicate it here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b32e6b0..09a5a78 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -249,7 +249,6 @@ xfs_file_read_iter(
 	struct xfs_mount	*mp = ip->i_mount;
 	size_t			size = iov_iter_count(to);
 	ssize_t			ret = 0;
-	xfs_fsize_t		n;
 	loff_t			pos = iocb->ki_pos;
 
 	XFS_STATS_INC(mp, xs_read_calls);
@@ -266,13 +265,6 @@ xfs_file_read_iter(
 		}
 	}
 
-	n = mp->m_super->s_maxbytes - pos;
-	if (n <= 0 || size == 0)
-		return 0;
-
-	if (n < size)
-		size = n;
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
