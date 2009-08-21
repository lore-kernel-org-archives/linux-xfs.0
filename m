Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7LHNPGa183863 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 12:23:35 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 678FE3EB8BD
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 10:24:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id h7Za8RNfcZgSiZ6z for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2009 10:24:10 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 13/17] xfs: Convert sync_page_range() to simple
	fdatawrite_range()
Date: Fri, 21 Aug 2009 19:24:03 +0200
Message-Id: <1250875447-15622-14-git-send-email-jack@suse.cz>
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
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
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, hch@lst.de, xfs@oss.sgi.com

Christoph Hellwig says that it is enough for XFS to call
filemap_fdatawrite_range() instead of sync_page_range() because we do all the
waiting when forcing the log.

CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
CC: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/linux-2.6/xfs_lrw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 7078974..a68053c 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -817,7 +817,7 @@ write_retry:
 		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error2 = sync_page_range(inode, mapping, pos, ret);
+		error2 = filemap_fdatawrite_range(mapping, pos, pos + ret - 1);
 		if (!error)
 			error = error2;
 		if (need_i_mutex)
-- 
1.6.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
