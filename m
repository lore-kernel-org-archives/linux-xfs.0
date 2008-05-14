Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 22:23:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4E5MbI7012447
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 22:22:39 -0700
Message-ID: <482A77A9.5040806@sgi.com>
Date: Wed, 14 May 2008 15:24:57 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] make inode reclaim wait for log I/O to complete
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

An xfs inode can be destroyed before log I/O involving that inode
is complete.  We need to wait for the inode to be unpinned before
tearing it down.

Lachlan

--- fs/xfs/xfs_inode.c_1.501	2008-05-12 14:45:17.000000000 +1000
+++ fs/xfs/xfs_inode.c	2008-05-12 12:23:48.000000000 +1000
@@ -2787,7 +2787,7 @@ __xfs_iunpin_wait(
 		wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 0));
 }
 
-static inline void
+inline void
 xfs_iunpin_wait(
 	xfs_inode_t	*ip)
 {
--- fs/xfs/xfs_inode.h_1.245	2008-05-12 14:45:20.000000000 +1000
+++ fs/xfs/xfs_inode.h	2008-05-12 12:31:37.000000000 +1000
@@ -481,6 +481,7 @@ void		xfs_ifunlock(xfs_inode_t *);
 void		xfs_ireclaim(xfs_inode_t *);
 int		xfs_finish_reclaim(xfs_inode_t *, int, int);
 int		xfs_finish_reclaim_all(struct xfs_mount *, int);
+void		xfs_iunpin_wait(xfs_inode_t *);
 
 /*
  * xfs_inode.c prototypes.
--- fs/xfs/xfs_vnodeops.c_1.757	2008-05-12 12:02:45.000000000 +1000
+++ fs/xfs/xfs_vnodeops.c	2008-05-12 12:28:15.000000000 +1000
@@ -3324,6 +3324,7 @@ xfs_finish_reclaim(
 			 * because we're gonna reclaim the inode anyway.
 			 */
 			if (error) {
+				xfs_iunpin_wait(ip);
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 				goto reclaim;
 			}
@@ -3336,6 +3337,7 @@ xfs_finish_reclaim(
 	}
 
 	xfs_ifunlock(ip);
+	xfs_iunpin_wait(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
  reclaim:
