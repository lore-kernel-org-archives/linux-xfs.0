Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5NFcHXQ035012 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 10:38:17 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DF448F8050
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 08:38:45 -0700 (PDT)
Message-Id: <EBC1B5EB-A971-4769-8E2A-9C15BB069E11@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: [PATCH] xfs: implement ->dirty_inode callout 
Date: Tue, 23 Jun 2009 10:38:43 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

I'd like to (re)propose Dave's patch from the last October to
address the problem of atime never making to the disk. Many
people complained about it.
I may have slightly adjusted the patch to fit the latest
code, and verified it addresses the issue.

The reference to the discussion on this matter on xfs mailing
list is here:

http://oss.sgi.com/archives/xfs/2008-10/msg02102.html

---

 From Dave Chinner <david@fromorbit.com>

XFS: Implement ->dirty_inode callout

Hook up ->dirty_inode so that when the VFS dirties an inode we
can mark the XFS inode as "dirty with unlogged changes". This
allows events such as touch_atime() to propagate the dirty state
right through to XFS so it gets written back to disk.

Signed-off-by: Dave Chinner <david@fromorbit.com>

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 7ec89fc..ee6863e 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -215,7 +215,6 @@ xfs_setfilesize(

         if (ip->i_d.di_size < isize) {
                 ip->i_d.di_size = isize;
-               ip->i_update_core = 1;
                 ip->i_update_size = 1;
                 xfs_mark_inode_dirty_sync(ip);
         }
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 58973bb..7a51612 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -120,19 +120,11 @@ xfs_ichgtime(
         }

         /*
-        * We update the i_update_core field _after_ changing
-        * the timestamps in order to coordinate properly with
-        * xfs_iflush() so that we don't lose timestamp updates.
-        * This keeps us from having to hold the inode lock
-        * while doing this.  We use the SYNCHRONIZE macro to
-        * ensure that the compiler does not reorder the update
-        * of i_update_core above the timestamp updates above.
+        * Update complete - now make sure everyone knows that the inode
+        * is dirty.
          */
-       if (sync_it) {
-               SYNCHRONIZE();
-               ip->i_update_core = 1;
+       if (sync_it)
                 xfs_mark_inode_dirty_sync(ip);
-       }
  }

  /*
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 36fb8a6..3cc9ef2 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -973,6 +973,28 @@ xfs_fs_inode_init_once(
  }

  /*
+ * Dirty the XFS inode when mark_inode_dirty_sync() is called so that
+ * we catch unlogged VFS level updates to the inode. Care must be taken
+ * here - the transaction code calls mark_inode_dirty_sync() to mark  
the
+ * VFS inode dirty in a transaction and clears the i_update_core field;
+ * it must clear the field after calling mark_inode_dirty_sync() to
+ * correctly indicate that the dirty state has been propagated into the
+ * inode log item.
+ *
+ * We need the barrier() to maintain correct ordering between unlogged
+ * updates and the transaction commit code that clears the  
i_update_core
+ * field. This requires all updates to be completed before marking the
+ * inode dirty.
+ */
+STATIC void
+xfs_fs_dirty_inode(
+       struct inode    *inode)
+{
+       barrier();
+       XFS_I(inode)->i_update_core = 1;
+}
+
+/*
   * Attempt to flush the inode, this will actually fail
   * if the inode is pinned, but we dirty the inode again
   * at the point when it is unpinned after a log write,
@@ -1546,6 +1568,7 @@ xfs_fs_get_sb(
  static struct super_operations xfs_super_operations = {
         .alloc_inode            = xfs_fs_alloc_inode,
         .destroy_inode          = xfs_fs_destroy_inode,
+       .dirty_inode            = xfs_fs_dirty_inode,
         .write_inode            = xfs_fs_write_inode,
         .clear_inode            = xfs_fs_clear_inode,
         .put_super              = xfs_fs_put_super,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 977c4ae..43c31c0 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -232,6 +232,15 @@ xfs_inode_item_format(
         nvecs        = 1;

         /*
+        * Make sure the linux inode is dirty. We do this before
+        * clearing i_update_core as the VFS will call back into
+        * XFS here and set i_update_core, so we need to dirty the
+        * inode first so that the ordering of i_update_core and
+        * unlogged modifications still works as described below.
+        */
+       xfs_mark_inode_dirty_sync(ip);
+
+       /*
          * Clear i_update_core if the timestamps (or any other
          * non-transactional modification) need flushing/logging
          * and we're about to log them with the rest of the core.
@@ -275,11 +284,6 @@ xfs_inode_item_format(
          */
         xfs_synchronize_atime(ip);

-       /*
-        * make sure the linux inode is dirty
-        */
-       xfs_mark_inode_dirty_sync(ip);
-
         vecp->i_addr = (xfs_caddr_t)&ip->i_d;
         vecp->i_len  = sizeof(struct xfs_icdinode);
         XLOG_VEC_SET_TYPE(vecp, XLOG_REG_TYPE_ICORE);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
