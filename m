Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91EFE7F3F
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2014 04:56:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60FC5304043
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2014 02:56:05 -0800 (PST)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	Alym2EjyejubQD4D (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 01 Mar 2014 02:56:03 -0800 (PST)
Received: by mail-wi0-f172.google.com with SMTP id r20so1666800wiv.17
	for <xfs@oss.sgi.com>; Sat, 01 Mar 2014 02:56:02 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: correctly flush data on defrag when compression is
	enabled
Date: Sat,  1 Mar 2014 10:55:54 +0000
Message-Id: <1393671354-7140-1-git-send-email-fdmanana@gmail.com>
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
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

When the defrag flag BTRFS_DEFRAG_RANGE_START_IO is set and compression
enabled, we weren't flushing completely, as writing compressed extents
is a 2 steps process, one to compress the data and another one to write
the compressed data to disk.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d4c1795..f914b5d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1382,8 +1382,12 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 	}
 
-	if ((range->flags & BTRFS_DEFRAG_RANGE_START_IO))
+	if ((range->flags & BTRFS_DEFRAG_RANGE_START_IO)) {
 		filemap_flush(inode->i_mapping);
+		if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+			     &BTRFS_I(inode)->runtime_flags))
+			filemap_flush(inode->i_mapping);
+	}
 
 	if ((range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
 		/* the filemap_flush will queue IO into the worker threads, but
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
