Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82DxcAj006909 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 08:59:48 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12BD241B8DD
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 07:00:32 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id VZ1hc3ecGvlZJZ36 for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2009 07:00:32 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 13/16] xfs: Convert sync_page_range() to simple
	filemap_write_and_wait_range()
Date: Wed,  2 Sep 2009 15:59:23 +0200
Message-Id: <1251899966-7316-14-git-send-email-jack@suse.cz>
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, hch@lst.de

Christoph Hellwig says that it is enough for XFS to call
filemap_write_and_wait_range() instead of sync_page_range() because we do
all the metadata syncing when forcing the log.

CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
CC: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/linux-2.6/xfs_lrw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 7078974..fde63a3 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -817,7 +817,8 @@ write_retry:
 		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error2 = sync_page_range(inode, mapping, pos, ret);
+		error2 = filemap_write_and_wait_range(mapping, pos,
+						      pos + ret - 1);
 		if (!error)
 			error = error2;
 		if (need_i_mutex)
-- 
1.6.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
