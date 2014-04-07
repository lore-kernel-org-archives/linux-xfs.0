Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30AB27F9E
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B376EAC018
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nONW2juHsNzMjA2m for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 14/19] xfs: remove unused pag ptr arg from iterator execute
	functions
Date: Mon,  7 Apr 2014 14:59:01 -0500
Message-Id: <1396900746-22201-15-git-send-email-sandeen@redhat.com>
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
 fs/xfs/xfs_icache.c      |   12 ++++--------
 fs/xfs/xfs_icache.h      |    6 ++----
 fs/xfs/xfs_qm_syscalls.c |    1 -
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 98d3524..c48df5f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -507,8 +507,7 @@ STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, int flags,
+	int			(*execute)(struct xfs_inode *ip, int flags,
 					   void *args),
 	int			flags,
 	void			*args,
@@ -582,7 +581,7 @@ restart:
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = execute(batch[i], pag, flags, args);
+			error = execute(batch[i], flags, args);
 			IRELE(batch[i]);
 			if (error == EAGAIN) {
 				skipped++;
@@ -636,8 +635,7 @@ xfs_eofblocks_worker(
 int
 xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, int flags,
+	int			(*execute)(struct xfs_inode *ip, int flags,
 					   void *args),
 	int			flags,
 	void			*args)
@@ -664,8 +662,7 @@ xfs_inode_ag_iterator(
 int
 xfs_inode_ag_iterator_tag(
 	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, int flags,
+	int			(*execute)(struct xfs_inode *ip, int flags,
 					   void *args),
 	int			flags,
 	void			*args,
@@ -1209,7 +1206,6 @@ xfs_inode_match_id(
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
 	int			flags,
 	void			*args)
 {
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 9ed68bb..9cf017b 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -60,12 +60,10 @@ int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
 void xfs_eofblocks_worker(struct work_struct *);
 
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag,
-		int flags, void *args),
+	int (*execute)(struct xfs_inode *ip, int flags, void *args),
 	int flags, void *args);
 int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag,
-		int flags, void *args),
+	int (*execute)(struct xfs_inode *ip, int flags, void *args),
 	int flags, void *args, int tag);
 
 static inline int
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3daf5ea..72cbe65 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -959,7 +959,6 @@ xfs_qm_export_flags(
 STATIC int
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
 	int			flags,
 	void			*args)
 {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
