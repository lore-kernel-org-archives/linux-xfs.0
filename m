Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMfEkq194510 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAEFF1D2DEBD
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	B2EdxLJABHpoSGD0 for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:46 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/19] xfs: quota limit statvfs available blocks
Date: Fri, 12 Mar 2010 09:42:13 +1100
Message-Id: <1268347337-7160-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

>From 9b00f30762fe9f914eb6e03057a616ed63a4e8ca
Date: Thu, 21 Jan 2010 11:17:20 +0000
A "df" run on an NFS client of an exported XFS file system reports
the wrong information for "available" blocks.  When a block quota is
enforced, the amount reported as free is limited by the quota, but
the amount reported available is not (and should be).

Reported-by: Guk-Bong, Kwon <gbkwon@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/quota/xfs_qm_bhv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm_bhv.c b/fs/xfs/quota/xfs_qm_bhv.c
index a534663..97b410c 100644
--- a/fs/xfs/quota/xfs_qm_bhv.c
+++ b/fs/xfs/quota/xfs_qm_bhv.c
@@ -59,7 +59,7 @@ xfs_fill_statvfs_from_dquot(
 		be64_to_cpu(dp->d_blk_hardlimit);
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
-		statp->f_bfree =
+		statp->f_bfree = statp->f_bavail =
 			(statp->f_blocks > be64_to_cpu(dp->d_bcount)) ?
 			 (statp->f_blocks - be64_to_cpu(dp->d_bcount)) : 0;
 	}
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
