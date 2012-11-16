Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6n7Ef068087 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:49:07 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wOIkbSF4hsS7yjB2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:51:12 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6pAS5008165
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:51:11 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6pAtk006897
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:51:10 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6pAX9013252 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:51:10 -0600
Message-ID: <50A5E258.3000509@oracle.com>
Date: Fri, 16 Nov 2012 14:51:04 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfsprogs: Introduce a new subcommand agstate to xfs_fio
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Introduce a new xfs_io command: agstate.

This command is used to get/set state for a given allocation group.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 include/xfs_ag.h |   32 ++++++++++++++++++++++++++++----
 include/xfs_fs.h |    2 ++
 io/Makefile      |    2 +-
 io/init.c        |    1 +
 4 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index 5adce91..bd5f4d4 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
@@ -69,6 +69,10 @@ typedef struct xfs_agf {
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
+	/*
+	 * state
+	 */
+	__be32		agf_state;	/* persistent a.g. state */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -83,7 +87,8 @@ typedef struct xfs_agf {
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
-#define	XFS_AGF_NUM_BITS	12
+#define XFS_AGF_STATE		0x00001000
+#define	XFS_AGF_NUM_BITS	13
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \
@@ -98,7 +103,8 @@ typedef struct xfs_agf {
 	{ XFS_AGF_FLCOUNT,	"FLCOUNT" }, \
 	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
 	{ XFS_AGF_LONGEST,	"LONGEST" }, \
-	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }
+	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
+	{ XFS_AGF_STATE,	"STATE" }
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
@@ -184,8 +190,8 @@ typedef struct xfs_agfl {
 struct xfs_busy_extent {
 #ifdef __KERNEL__
 	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
-#endif
 	struct list_head list;		/* transaction busy extent list */
+#endif
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
@@ -197,7 +203,7 @@ struct xfs_busy_extent {
  * to improve the performance of allocation group selection.
  */
 #define XFS_PAGB_NUM_SLOTS	128
-
+typedef int atomic_t;		/* to make compiler happy */
 typedef struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
@@ -243,9 +249,27 @@ typedef struct xfs_perag {
 	struct rcu_head	rcu_head;
 #endif
 	int		pagb_count;	/* pagb slots in use */
+	__uint32_t	pag_state;	/* persistent a.g. state */
 } xfs_perag_t;
 
 /*
+ * Structure for ioctl per a.g. state get/set.
+ */
+typedef struct xfs_ioc_agstate {
+	xfs_agnumber_t	agno;
+	__uint32_t	state;
+} xfs_ioc_agstate_t;
+
+/*
+ * Skip an AG with below state for inodes/blocks allocation.
+ */
+#define XFS_AG_STATE_ALLOC_DENY		(1 << 0)
+extern int xfs_get_agstate(struct xfs_mount *mp,
+			   struct xfs_ioc_agstate *agstate);
+extern int xfs_set_agstate(struct xfs_mount *mp,
+			   struct xfs_ioc_agstate *agstate);
+
+/*
  * tags for inode radix tree
  */
 #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index faac5af..c749474 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -483,6 +483,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_SET_AGSTATE	     _IOW ('X', 126, struct xfs_ioc_agstate)
+#define XFS_IOC_GET_AGSTATE	     _IOR ('X', 127, struct xfs_ioc_agstate)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/io/Makefile b/io/Makefile
index 50edf91..80a2817 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -9,7 +9,7 @@ LTCOMMAND = xfs_io
 LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
-	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c mmap.c \
+	agstate.c attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c mmap.c \
 	open.c parent.c pread.c prealloc.c pwrite.c shutdown.c truncate.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
diff --git a/io/init.c b/io/init.c
index fb93082..b81ca4f 100644
--- a/io/init.c
+++ b/io/init.c
@@ -54,6 +54,7 @@ init_cvtnum(
 static void
 init_commands(void)
 {
+	agstate_init();
 	attr_init();
 	bmap_init();
 	fadvise_init();
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
