Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0Tj8d141435 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:29:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A66A71C5C791
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:30:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Myp9tkLe0hOBVmkE for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:30:44 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11645680-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:00:43 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX1zM-0003DM-Ex
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX1zL-0003W3-Qv
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfs: convert dirnameops to unsigned char names
Date: Tue, 19 Jan 2010 11:30:21 +1100
Message-Id: <1263861026-13448-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861026-13448-1-git-send-email-david@fromorbit.com>
References: <1263861026-13448-1-git-send-email-david@fromorbit.com>
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

To be consistent across the codebase, convert the dirnameops to pass
the directory names by unsigned char strings.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_da_btree.c |    4 ++--
 fs/xfs/xfs_da_btree.h |    5 +++--
 fs/xfs/xfs_dir2.c     |    4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index c0c8869..0ca556b 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1534,8 +1534,8 @@ xfs_da_hashname(const __uint8_t *name, int namelen)
 enum xfs_dacmp
 xfs_da_compname(
 	struct xfs_da_args *args,
-	const char 	*name,
-	int 		len)
+	const unsigned char *name,
+	int		len)
 {
 	return (args->namelen == len && memcmp(args->name, name, len) == 0) ?
 					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 30cd08f..fe9f5a8 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -209,7 +209,8 @@ typedef struct xfs_da_state {
  */
 struct xfs_nameops {
 	xfs_dahash_t	(*hashname)(struct xfs_name *);
-	enum xfs_dacmp	(*compname)(struct xfs_da_args *, const char *, int);
+	enum xfs_dacmp	(*compname)(struct xfs_da_args *,
+					const unsigned char *, int);
 };
 
 
@@ -260,7 +261,7 @@ int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 
 uint xfs_da_hashname(const __uint8_t *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
-				const char *name, int len);
+				const unsigned char *name, int len);
 
 
 xfs_da_state_t *xfs_da_state_alloc(void);
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 93634a7..c21c527 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -66,8 +66,8 @@ xfs_ascii_ci_hashname(
 STATIC enum xfs_dacmp
 xfs_ascii_ci_compname(
 	struct xfs_da_args *args,
-	const char	*name,
-	int 		len)
+	const unsigned char *name,
+	int		len)
 {
 	enum xfs_dacmp	result;
 	int		i;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
