Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p85EXb7b018374 for <xfs@oss.sgi.com>; Mon, 5 Sep 2011 09:33:37 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA45C13C41CB
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2011 07:37:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id I2OBGfsAtGRGgxT5 for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2011 07:37:30 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs: fix possible overflow in xfs_ioc_trim()
Date: Mon,  5 Sep 2011 16:33:25 +0200
Message-Id: <1315233205-27093-1-git-send-email-lczerner@redhat.com>
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
To: xfs@oss.sgi.com
Cc: hch@infradead.org, Lukas Czerner <lczerner@redhat.com>

In xfs_ioc_trim it is possible that start+len might overflow. Fix it by
decrementing the len so that start+len equals to the file system size in
the worst case.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/xfs/xfs_discard.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 244e797..0fab107 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -146,6 +146,7 @@ xfs_ioc_trim(
 	unsigned int		granularity = q->limits.discard_granularity;
 	struct fstrim_range	range;
 	xfs_fsblock_t		start, len, minlen;
+	xfs_fsblock_t		max_blks =  XFS_MAX_DBLOCKS(&(mp->m_sb));
 	xfs_agnumber_t		start_agno, end_agno, agno;
 	__uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
@@ -171,7 +172,8 @@ xfs_ioc_trim(
 	start_agno = XFS_FSB_TO_AGNO(mp, start);
 	if (start_agno >= mp->m_sb.sb_agcount)
 		return -XFS_ERROR(EINVAL);
-
+	if (len > max_blks)
+		len = max_blks - start;
 	end_agno = XFS_FSB_TO_AGNO(mp, start + len);
 	if (end_agno >= mp->m_sb.sb_agcount)
 		end_agno = mp->m_sb.sb_agcount - 1;
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
