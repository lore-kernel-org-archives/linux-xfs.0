Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB941Prq023654 for <xfs@oss.sgi.com>; Mon, 8 Dec 2008 22:01:25 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id CE8058F8065
	for <xfs@oss.sgi.com>; Mon,  8 Dec 2008 20:01:20 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id PAA00395 for <xfs@oss.sgi.com>;
	Tue, 9 Dec 2008 15:01:18 +1100
Message-ID: <493DEDB5.8010401@sgi.com>
Date: Tue, 09 Dec 2008 15:01:57 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Remove unused tracing code
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

None of this code appears to be used anywhere so remove it.
The only changes going to mainline are the one-liners in xfs_inode.[ch].

diff --git a/fs/xfs/linux-2.6/xfs_ksyms.c b/fs/xfs/linux-2.6/xfs_ksyms.c
index f5c7b0a..c144a91 100644
--- a/fs/xfs/linux-2.6/xfs_ksyms.c
+++ b/fs/xfs/linux-2.6/xfs_ksyms.c
@@ -88,9 +88,6 @@ EXPORT_SYMBOL(xfs_itrace_hold);
  EXPORT_SYMBOL(xfs_itrace_rele);
  #endif

-#ifdef XFS_ILOCK_TRACE
-EXPORT_SYMBOL(xfs_ilock_trace_buf);
-#endif
  #ifdef XFS_ALLOC_TRACE
  EXPORT_SYMBOL(xfs_alloc_trace_buf);
  #endif
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 872191b..50ceddb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3304,8 +3304,6 @@ corrupt_out:


  #ifdef XFS_ILOCK_TRACE
-ktrace_t	*xfs_ilock_trace_buf;
-
  void
  xfs_ilock_trace(xfs_inode_t *ip, int lock, unsigned int lockflags, inst_t *ra)
  {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ae5800e..9e6d916 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -223,7 +223,6 @@ struct xfs_dquot;

  #if defined(XFS_ILOCK_TRACE)
  #define XFS_ILOCK_KTRACE_SIZE	32
-extern ktrace_t *xfs_ilock_trace_buf;
  extern void xfs_ilock_trace(struct xfs_inode *, int, unsigned int, inst_t *);
  #else
  #define	xfs_ilock_trace(i,n,f,ra)
diff --git a/fs/xfs/xfsidbg.c b/fs/xfs/xfsidbg.c
index fe0a674..30aa344 100644
--- a/fs/xfs/xfsidbg.c
+++ b/fs/xfs/xfsidbg.c
@@ -99,7 +99,6 @@ static void	xfsidbg_xbxstrace(xfs_inode_t *);
  #endif
  #ifdef XFS_ILOCK_TRACE
  static void	xfsidbg_xilock_trace(xfs_inode_t *);
-static void	xfsidbg_xailock_trace(int);
  #endif
  #ifdef XFS_DIR2_TRACE
  static void	xfsidbg_xdir2atrace(int);
@@ -649,26 +648,6 @@ static int	kdbm_xfs_xilock_trace(
  	xfsidbg_xilock_trace((xfs_inode_t *) addr);
  	return 0;
  }
-
-static int	kdbm_xfs_xailock_trace(
-	int	argc,
-	const char **argv)
-{
-	unsigned long addr;
-	int nextarg = 1;
-	long offset = 0;
-	int diag;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-	if (diag)
-		return diag;
-
-	xfsidbg_xailock_trace((int) addr);
-	return 0;
-}
  #endif

  #ifdef XFS_LOG_TRACE
@@ -2410,8 +2389,6 @@ static struct xif xfsidbg_funcs[] = {
  #ifdef XFS_ILOCK_TRACE
    {  "xilocktrc",kdbm_xfs_xilock_trace,	"<xfs_inode_t>",
  				"Dump XFS ilock trace" },
-  {  "xailcktrc",kdbm_xfs_xailock_trace,"<count>",
-				"Dump XFS global ilock trace" },
  #endif
    {  "xinodes",	kdbm_xfs_xinodes,	"<xfs_mount_t>",
  				"Dump XFS inodes per mount"},
@@ -5031,63 +5008,6 @@ xfsidbg_xbxstrace(xfs_inode_t *ip)
   * Print out the ilock trace buffer attached to the given inode.
   */
  static void
-xfsidbg_xilock_trace_entry(ktrace_entry_t *ktep)
-{
-	static char	*xiflags[] = {
-		"IOLOCK_EXCL",
-		"IOLOCK_SHAR",
-		"ILOCK_EXCL",
-		"ILOCK_SHAR",
-		"IUNLK_NONOT",
-		NULL
-	};
-
-	if ((__psint_t)ktep->val[0] &&
-	     (__psint_t)ktep->val[7] == 0) {
-		 printflags((__psint_t)ktep->val[2], xiflags,"Flags ");
-		if ((__psint_t)ktep->val[1] == 1)
-			 qprintf("LOCK\n");
-		else if ((__psint_t)ktep->val[1] == 2)
-			 qprintf("LOCK SHARED\n");
-		else if ((__psint_t)ktep->val[1] == 3)
-			 qprintf("UNLOCK\n");
-		qprintf("ip 0x%p %llx %ld\n",
-			ktep->val[0],
-			(unsigned long long)((xfs_inode_t*)ktep->val[0])->i_ino,
-			(long)ktep->val[6]);
-		qprintf("raddr 0x%p\n", ktep->val[3]);
-		qprintf("  Pid %ld, cpu %ld\n",
-			 (long)ktep->val[5],
-			 (long)ktep->val[4]);
-		qprintf("-----------------------\n");
-
-	} else if ((__psint_t)ktep->val[7] == 1) {
-		if ((__psint_t)ktep->val[1] == 1)
-			qprintf("FlushLOCK ");
-		else if ((__psint_t)ktep->val[1] == 2)
-			qprintf("FlushTRYLOCK %ld ",
-				(long)ktep->val[2]);
-		else if ((__psint_t)ktep->val[1] == 3)
-			qprintf("FlushUNLOCK ");
-		else if ((__psint_t)ktep->val[1] == 4)
-			qprintf("FlushInode 0x%p",
-				ktep->val[2]);
-		else if ((__psint_t)ktep->val[1] == 5)
-			qprintf("FlushInodeInt ");
-		else     qprintf("FlushUNKNOWN ");
-		qprintf("ip 0x%p ino %llx @ %ld\n",
-			ktep->val[0],
-			(unsigned long long)((xfs_inode_t*)ktep->val[0])->i_ino,
-			(long)ktep->val[6]);
-		qprintf("raddr 0x%p\n", ktep->val[3]);
-		qprintf("  Pid %ld, cpu %ld\n",
-			(long)ktep->val[5],
-			(long)ktep->val[4]);
-		qprintf("-----------------------\n");
-	}
-}
-
-static void
  xfsidbg_xilock_trace(xfs_inode_t *ip)
  {
  	static char *xiflags[] = {
@@ -5149,49 +5069,6 @@ xfsidbg_xilock_trace(xfs_inode_t *ip)
  		 ktep = ktrace_next(ip->i_lock_trace, &kts);
  	}
  }
-
-/*
- * Print out the last "count" entries in the inode lock trace buffer.
- * The "a" is for "all" entries.
- */
-static void
-xfsidbg_xailock_trace(int count)
-{
-	ktrace_entry_t  *ktep;
-	ktrace_snap_t   kts;
-	int	     nentries;
-	int	     skip_entries;
-
-	if (xfs_ilock_trace_buf == NULL) {
-		qprintf("The xfs inode lock trace buffer is not initialized\n");		return;
-	}
-	nentries = ktrace_nentries(xfs_ilock_trace_buf);
-	if (count == -1) {
-		count = nentries;
-	}
-	if ((count <= 0) || (count > nentries)) {
-		qprintf("Invalid count.  There are %d entries.\n", nentries);
-		return;
-	}
-
-	ktep = ktrace_first(xfs_ilock_trace_buf, &kts);
-	if (count != nentries) {
-		/*
-		 * Skip the total minus the number to look at minus one
-		 * for the entry returned by ktrace_first().
-		 */
-		skip_entries = nentries - count - 1;
-		ktep = ktrace_skip(xfs_ilock_trace_buf, skip_entries, &kts);
-		if (ktep == NULL) {
-			qprintf("Skipped them all\n");
-			return;
-		}
-	}
-	while (ktep != NULL) {
-		xfsidbg_xilock_trace_entry(ktep);
-		ktep = ktrace_next(xfs_ilock_trace_buf, &kts);
-	}
-}
  #endif

  #ifdef XFS_FILESTREAMS_TRACE

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
