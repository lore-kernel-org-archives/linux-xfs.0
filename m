Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1CB7C7F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 16:36:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD0F5AC001
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 14:36:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4DyvEtBPCu5GkFlF for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 14:36:21 -0800 (PST)
Date: Wed, 3 Dec 2014 09:34:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: active inodes stat is broken
Message-ID: <20141202223452.GF18131@dastard>
References: <1417473270-17467-1-git-send-email-david@fromorbit.com>
	<547DC411.3090202@sgi.com> <20141202210204.GA18131@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202210204.GA18131@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com


From: Dave Chinner <dchinner@redhat.com>

vn_active only ever gets decremented, so it has a very large
negative number.  Make it track the inode count we currently have
allocated properly so we can easily track the size of the inode
cache via tools like PCP.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
Version 2:
- move stat increment to inode allocation code rather than cache
  miss code so that inc/dec are evenly balanced no matter who calls
  them.

 fs/xfs/xfs_icache.c | 2 ++
 fs/xfs/xfs_super.c  | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 92ca910..9771b7e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -63,6 +63,7 @@ xfs_inode_alloc(
 		return NULL;
 	}
 
+	XFS_STATS_INC(vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(!xfs_isiflocked(ip));
@@ -128,6 +129,7 @@ xfs_inode_free(
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!xfs_isiflocked(ip));
+	XFS_STATS_DEC(vn_active);
 
 	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
 }
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fee11c8..6b95851 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1005,7 +1005,6 @@ xfs_fs_evict_inode(
 	clear_inode(inode);
 	XFS_STATS_INC(vn_rele);
 	XFS_STATS_INC(vn_remove);
-	XFS_STATS_DEC(vn_active);
 
 	xfs_inactive(ip);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
