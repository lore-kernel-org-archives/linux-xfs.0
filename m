Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BIqQmn185040 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 12:52:26 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 9QP3Hv9QyxyIS1OF for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 10:52:25 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Fix missing xfs_iunlock() on error recovery path in
	xfs_readlink()
Date: Wed, 11 Jan 2012 19:52:10 +0100
Message-Id: <1326307930-21251-1-git-send-email-jack@suse.cz>
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
To: Alex Elder <elder@kernel.org>
Cc: Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>, stable@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

Commit b52a360b forgot to call xfs_iunlock() when it detected corrupted
symplink and bailed out. Fix it by jumping to 'out' instead of doing return.

CC: stable@kernel.org
CC: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_vnodeops.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index f2fea86..6156cd6 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -131,7 +131,8 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		return XFS_ERROR(EFSCORRUPTED);
+		error = XFS_ERROR(EFSCORRUPTED);
+		goto out;
 	}
 
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
