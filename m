Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52EB68040
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 06:59:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16A70304051
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 04:59:34 -0800 (PST)
Received: from mail-da0-f44.google.com (mail-da0-f44.google.com
	[209.85.210.44]) by cuda.sgi.com with ESMTP id HVFy06Z3VqcTniYv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Mar 2013 04:59:32 -0800 (PST)
Received: by mail-da0-f44.google.com with SMTP id z20so2538054dae.17
	for <xfs@oss.sgi.com>; Mon, 04 Mar 2013 04:59:32 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -v3 12/23] xfs: rename random32() to prandom_u32()
Date: Mon,  4 Mar 2013 21:58:20 +0900
Message-Id: <1362401911-14074-13-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
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
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, xfs@oss.sgi.com

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: <bpm@sgi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: xfs@oss.sgi.com
---

* Change from v2
- add Acked-by: line

 fs/xfs/xfs_alloc.c  | 2 +-
 fs/xfs/xfs_error.c  | 2 +-
 fs/xfs/xfs_ialloc.c | 2 +-
 fs/xfs/xfs_log.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0ad2325..a8beb5c 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -842,7 +842,7 @@ xfs_alloc_ag_vextent_near(
 	 */
 	int		dofirst;	/* set to do first algorithm */
 
-	dofirst = random32() & 1;
+	dofirst = prandom_u32() & 1;
 #endif
 
 restart:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 6104560..07bf3b9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -66,7 +66,7 @@ xfs_error_test(int error_tag, int *fsidp, char *expression,
 	int i;
 	int64_t fsid;
 
-	if (random32() % randfactor)
+	if (prandom_u32() % randfactor)
 		return 0;
 
 	memcpy(&fsid, fsidp, sizeof(xfs_fsid_t));
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 515bf71..ba62661 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -369,7 +369,7 @@ xfs_ialloc_ag_alloc(
 	 * number from being easily guessable.
 	 */
 	error = xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno,
-			args.len, random32());
+			args.len, prandom_u32());
 
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index eec226f..b345a7c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3485,7 +3485,7 @@ xlog_ticket_alloc(
 	tic->t_curr_res		= unit_bytes;
 	tic->t_cnt		= cnt;
 	tic->t_ocnt		= cnt;
-	tic->t_tid		= random32();
+	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
 	tic->t_flags		= XLOG_TIC_INITED;
 	tic->t_trans_type	= 0;
-- 
1.8.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
