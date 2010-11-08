Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88tD9F089666 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:55:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A2F01398EEA
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	ZpobWWxFauUqT7Qu for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:39 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	45631784-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:38 +1030 (CDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWn-0001DI-2x
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:37 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVv-0004nz-A1
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/16] xfs: only run xfs_error_test if error injection is
	active
Date: Mon,  8 Nov 2010 19:55:18 +1100
Message-Id: <1289206519-18377-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Recent tests writing lots of small files showed the flusher thread
being CPU bound and taking a long time to do allocations on a debug
kernel. perf showed this as the prime reason:

             samples  pcnt function                    DSO
             _______ _____ ___________________________ _________________

           224648.00 36.8% xfs_error_test              [kernel.kallsyms]
            86045.00 14.1% xfs_btree_check_sblock      [kernel.kallsyms]
            39778.00  6.5% prandom32                   [kernel.kallsyms]
            37436.00  6.1% xfs_btree_increment         [kernel.kallsyms]
            29278.00  4.8% xfs_btree_get_rec           [kernel.kallsyms]
            27717.00  4.5% random32                    [kernel.kallsyms]

Walking btree blocks during allocation checking them requires each
block (a cache hit, so no I/O) call xfs_error_test(), which then
does a random32() call as teh first operation.  IOWs, ~50% of the
CPU is being consumed just testing whether we need to inject an
error, even though error injection is not active.

Kill this overhead when error injection is not active by adding a
global counter of active error traps and only calling into
xfs_error_test when fault injection is active.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_error.c |    3 +++
 fs/xfs/xfs_error.h |    5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index ed99902..c78cc6a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ xfs_error_trap(int e)
 int	xfs_etest[XFS_NUM_INJECT_ERROR];
 int64_t	xfs_etest_fsid[XFS_NUM_INJECT_ERROR];
 char *	xfs_etest_fsname[XFS_NUM_INJECT_ERROR];
+int	xfs_error_test_active;
 
 int
 xfs_error_test(int error_tag, int *fsidp, char *expression,
@@ -108,6 +109,7 @@ xfs_errortag_add(int error_tag, xfs_mount_t *mp)
 			len = strlen(mp->m_fsname);
 			xfs_etest_fsname[i] = kmem_alloc(len + 1, KM_SLEEP);
 			strcpy(xfs_etest_fsname[i], mp->m_fsname);
+			xfs_error_test_active++;
 			return 0;
 		}
 	}
@@ -137,6 +139,7 @@ xfs_errortag_clearall(xfs_mount_t *mp, int loud)
 			xfs_etest_fsid[i] = 0LL;
 			kmem_free(xfs_etest_fsname[i]);
 			xfs_etest_fsname[i] = NULL;
+			xfs_error_test_active--;
 		}
 	}
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index c2c1a07..f338847 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -127,13 +127,14 @@ extern void xfs_corruption_error(const char *tag, int level,
 #define	XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
 
 #ifdef DEBUG
+extern int xfs_error_test_active;
 extern int xfs_error_test(int, int *, char *, int, char *, unsigned long);
 
 #define	XFS_NUM_INJECT_ERROR				10
 #define XFS_TEST_ERROR(expr, mp, tag, rf)		\
-	((expr) || \
+	((expr) || (xfs_error_test_active && \
 	 xfs_error_test((tag), (mp)->m_fixedfsid, "expr", __LINE__, __FILE__, \
-			(rf)))
+			(rf))))
 
 extern int xfs_errortag_add(int error_tag, xfs_mount_t *mp);
 extern int xfs_errortag_clearall(xfs_mount_t *mp, int loud);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
