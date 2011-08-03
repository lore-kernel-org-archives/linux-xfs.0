Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73KnJk2179517 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 15:49:19 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 607BCB8B06
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 13:49:17 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id EM1FoZzukeeHmz5z for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 13:49:17 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] xfs: Call filemap_flush_range() for async
	xfs_flush_pages() call
Date: Wed,  3 Aug 2011 22:49:05 +0200
Message-Id: <1312404545-15400-3-git-send-email-jack@suse.cz>
In-Reply-To: <1312404545-15400-1-git-send-email-jack@suse.cz>
References: <1312404545-15400-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

XFS does its own data writeout from several places using xfs_flush_pages().
When this writeout is racing with flusher thread writing the same inode the
performance gets bad because flusher thread submits writes as normal WRITE
commands while xfs_flush_pages() submits them as WRITE_SYNC (as it uses
filemap_fdatawrite_range()) and CFQ does not merge such requests. So we end up
with relatively small requests from the flusher thread and sync interleaved.
Short excerpt from blktrace:
254,16   2    16949   103.786278461 25233  Q   W 54479888 + 424 [flush-254:16]
254,16   4    20662   103.786386751 25232  Q  WS 54492920 + 1024 [dd]
254,16   4    20665   103.786444241 25232  Q  WS 54493944 + 104 [dd]
254,16   2    16952   103.786533451 25233  Q   W 54494048 + 288 [flush-254:16]
254,16   4    20668   103.787295241 25232  Q  WS 54494336 + 1024 [dd]
254,16   4    20671   103.787332801 25232  Q  WS 54495360 + 216 [dd]
254,16   2    16955   103.789062500 25233  Q   W 54495576 + 1024 [flush-254:16]
(actually, I was observing even smaller requests on a different HW which isn't
available to me now).

Although we cannot fix all the cases (e.g. when fsync is called), we can use
filemap_flush_range() for the case when xfs_flush_pages() is called with
XFS_B_ASYNC flag which fixes the problem at least for some common cases like
the first round of sync writeback or flushing of data during truncate or after
file is closed.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/linux-2.6/xfs_fs_subr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index ed88ed1..6f33164 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -70,10 +70,12 @@ xfs_flush_pages(
 	int		ret2;
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	if (flags & XBF_ASYNC) {
+		return -filemap_flush_range(mapping, first,
+				last == -1 ? LLONG_MAX : last);
+	}
 	ret = -filemap_fdatawrite_range(mapping, first,
 				last == -1 ? LLONG_MAX : last);
-	if (flags & XBF_ASYNC)
-		return ret;
 	ret2 = xfs_wait_on_pages(ip, first, last);
 	if (!ret)
 		ret = ret2;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
