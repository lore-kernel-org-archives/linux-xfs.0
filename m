Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 53C9F7F53
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:25:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0113DAC003
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:25:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id h8aYfobZzVeZL81M (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 09:25:16 -0800 (PST)
Message-Id: <20140204172516.641738827@bombadil.infradead.org>
Date: Tue, 04 Feb 2014 09:24:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: always use unwritten extents for direct I/O writes
References: <20140204172402.380571745@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0002-xfs-always-use-unwritten-extents-for-direct-I-O-writ.patch
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
Cc: Sergey Meirovich <rathamahata@gmail.com>

To allow aio writes beyond i_size we need to create unwritten extents for
newly allocated blocks, similar to how we already do inside i_size.

Instead of adding another special case we now use unwritten extents
unconditionally.  This also marks the end of directly allocation data
extents in all of XFS - we now always use either delalloc or unwritten
extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 22d1cbe..3b80eba 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -128,7 +128,6 @@ xfs_iomap_write_direct(
 	xfs_fsblock_t	firstfsb;
 	xfs_extlen_t	extsz, temp;
 	int		nimaps;
-	int		bmapi_flag;
 	int		quota_flag;
 	int		rt;
 	xfs_trans_t	*tp;
@@ -200,18 +199,15 @@ xfs_iomap_write_direct(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-	bmapi_flag = 0;
-	if (offset < XFS_ISIZE(ip) || extsz)
-		bmapi_flag |= XFS_BMAPI_PREALLOC;
-
 	/*
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
 	 */
 	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
-	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flag,
-				&firstfsb, 0, imap, &nimaps, &free_list);
+	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
+				XFS_BMAPI_PREALLOC, &firstfsb, 0,
+				imap, &nimaps, &free_list);
 	if (error)
 		goto out_bmap_cancel;
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
