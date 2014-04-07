Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7AA2B7F98
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6302F8F8039
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zJvnWcVWdMQrUIrm for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 15/19] xfs: remove unused bp arg from xfs_iflush_fork()
Date: Mon,  7 Apr 2014 14:59:02 -0500
Message-Id: <1396900746-22201-16-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_inode.c      |    4 ++--
 fs/xfs/xfs_inode_fork.c |    3 +--
 fs/xfs/xfs_inode_fork.h |    3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3a137e9..be29b80 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3260,9 +3260,9 @@ xfs_iflush_int(
 		}
 	}
 
-	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK, bp);
+	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
 	if (XFS_IFORK_Q(ip))
-		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK, bp);
+		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
 	xfs_inobp_check(mp, bp);
 
 	/*
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 73514c0..b031e8d 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -798,8 +798,7 @@ xfs_iflush_fork(
 	xfs_inode_t		*ip,
 	xfs_dinode_t		*dip,
 	xfs_inode_log_item_t	*iip,
-	int			whichfork,
-	xfs_buf_t		*bp)
+	int			whichfork)
 {
 	char			*cp;
 	xfs_ifork_t		*ifp;
diff --git a/fs/xfs/xfs_inode_fork.h b/fs/xfs/xfs_inode_fork.h
index eb329a1..7d3b1ed 100644
--- a/fs/xfs/xfs_inode_fork.h
+++ b/fs/xfs/xfs_inode_fork.h
@@ -127,8 +127,7 @@ typedef struct xfs_ifork {
 
 int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
-				struct xfs_inode_log_item *, int,
-				struct xfs_buf *);
+				struct xfs_inode_log_item *, int);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *, int, int);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
