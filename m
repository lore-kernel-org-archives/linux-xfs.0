Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9KE6lJ2108771 for <xfs@oss.sgi.com>; Sat, 20 Oct 2012 09:06:47 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MLTDbTDic23mSb8o for
	<xfs@oss.sgi.com>; Sat, 20 Oct 2012 07:08:27 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9KE8Q2I000610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 20 Oct 2012 10:08:27 -0400
Received: from andromeda.usersys.redhat.com ([10.3.113.16])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q9KE8PwQ014660
	for <xfs@oss.sgi.com>; Sat, 20 Oct 2012 10:08:26 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Update inode alloc comments
Date: Sat, 20 Oct 2012 11:08:19 -0300
Message-Id: <1350742099-8397-1-git-send-email-cmaiolino@redhat.com>
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

I found some out of date comments while studying the inode allocation code, so I
believe it's worth to have these comments updated.

It basically rewrites the comment regarding to "call_again" variable, which is
not used anymore, but instead, callers of xfs_ialloc() decides if it needs to be
called again relying only if ialloc_context is NULL or not.

Also did some small changes in another comment that I thought to be pertinent
to the current behaviour of these functions and some alignment on both comments.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_ialloc.c |  6 +++---
 fs/xfs/xfs_inode.c  | 18 +++++++++---------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 445bf1a..f1a6046 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -876,9 +876,9 @@ error0:
  * This function is designed to be called twice if it has to do an allocation
  * to make more free inodes.  On the first call, *IO_agbp should be set to NULL.
  * If an inode is available without having to performn an allocation, an inode
- * number is returned.  In this case, *IO_agbp would be NULL.  If an allocation
- * needes to be done, xfs_dialloc would return the current AGI buffer in
- * *IO_agbp.  The caller should then commit the current transaction, allocate a
+ * number is returned.  In this case, *IO_agbp is set to NULL.  If an allocation
+ * needes to be done, xfs_dialloc returns the current AGI buffer in *IO_agbp.
+ * The caller should then commit the current transaction, allocate a
  * new transaction, and call xfs_dialloc() again, passing in the previous value
  * of *IO_agbp.  IO_agbp should be held across the transactions. Since the AGI
  * buffer is locked across the two calls, the second call is guaranteed to have
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2778258..07ddaf2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -853,16 +853,16 @@ xfs_iread_extents(
  * set according to the contents of the given cred structure.
  *
  * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
- * has a free inode available, call xfs_iget()
- * to obtain the in-core version of the allocated inode.  Finally,
- * fill in the inode and log its initial contents.  In this case,
- * ialloc_context would be set to NULL and call_again set to false.
+ * has a free inode available, call xfs_iget() to obtain the in-core
+ * version of the allocated inode.  Finally, fill in the inode and
+ * log its initial contents.  In this case, ialloc_context would be
+ * set to NULL.
  *
- * If xfs_dialloc() does not have an available inode,
- * it will replenish its supply by doing an allocation. Since we can
- * only do one allocation within a transaction without deadlocks, we
- * must commit the current transaction before returning the inode itself.
- * In this case, therefore, we will set call_again to true and return.
+ * If xfs_dialloc() does not have an available inode, it will replenish
+ * its supply by doing an allocation. Since we can only do one
+ * allocation within a transaction without deadlocks, we must commit
+ * the current transaction before returning the inode itself.
+ * In this case, therefore, we will set ialloc_context and return.
  * The caller should then commit the current transaction, start a new
  * transaction, and call xfs_ialloc() again to actually get the inode.
  *
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
