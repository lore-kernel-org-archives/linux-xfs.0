Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86FTlkP088442 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 10:29:47 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8FB01E84386
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 08:29:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wgT6Pf8moNpTDl6J for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2011 08:29:46 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] xfs: fix possible overflow in xfs_ioc_trim()
Date: Tue,  6 Sep 2011 17:29:37 +0200
Message-Id: <1315322977-22736-1-git-send-email-lczerner@redhat.com>
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
v2: Use sb_dblocks instead of XFS_MAX_DBLOCKS to get max block count

 fs/xfs/xfs_discard.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 244e797..b45e3c9 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -146,6 +146,7 @@ xfs_ioc_trim(
 	unsigned int		granularity = q->limits.discard_granularity;
 	struct fstrim_range	range;
 	xfs_fsblock_t		start, len, minlen;
+	xfs_fsblock_t		max_blks = mp->m_sb.sb_dblocks;
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
