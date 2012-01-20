Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KKYxP7125560 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 14:34:59 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 7YHrkwL1TDh13kA2 for <xfs@oss.sgi.com>;
	Fri, 20 Jan 2012 12:34:57 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/8] xfs: Move ilock before transaction start in
	xfs_setattr_size()
Date: Fri, 20 Jan 2012 21:34:42 +0100
Message-Id: <1327091686-23177-5-git-send-email-jack@suse.cz>
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
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
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org

In xfs we first take ilock and start transaction afterwards. We should obey
this order in all places because otherwise we can create the following deadlock
with filesystem freezing: One process holds ilock and blocks on s_frozen ==
SB_FREEZE_TRANS in xfs_trans_alloc(), another process has a transaction started
(thus blocking freezing) and blocks on ilock. So we have to take ilock earlier
in xfs_setattr_size().

CC: Ben Myers <bpm@sgi.com>
CC: Alex Elder <elder@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_iops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 23ce927..3579bc8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -850,6 +850,9 @@ xfs_setattr_size(
 	if (error)
 		goto out_unlock;
 
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	lock_flags |= XFS_ILOCK_EXCL;
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
 	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
 				 XFS_TRANS_PERM_LOG_RES,
@@ -860,9 +863,6 @@ xfs_setattr_size(
 	truncate_setsize(inode, iattr->ia_size);
 
 	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
-	lock_flags |= XFS_ILOCK_EXCL;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
