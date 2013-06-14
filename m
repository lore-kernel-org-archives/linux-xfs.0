Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 768A77CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 21:41:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E0788F8037
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 19:41:58 -0700 (PDT)
Received: from labridge.com (perches-mx.perches.com [206.117.179.246]) by
	cuda.sgi.com with ESMTP id ciCpKQnGsDsPOlgG (version=SSLv3
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 19:41:57 -0700 (PDT)
From: Joe Perches <joe@perches.com>
Subject: [Trivial PATCH 25/33] xfs: Convert use of typedef ctl_table to struct
	ctl_table
Date: Thu, 13 Jun 2013 19:37:50 -0700
Message-Id: <1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
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
To: Jiri Kosina <trivial@kernel.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/xfs_sysctl.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 2801b5c..1743b9f 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -25,11 +25,11 @@ static struct ctl_table_header *xfs_table_header;
 #ifdef CONFIG_PROC_FS
 STATIC int
 xfs_stats_clear_proc_handler(
-	ctl_table	*ctl,
-	int		write,
-	void		__user *buffer,
-	size_t		*lenp,
-	loff_t		*ppos)
+	struct ctl_table	*ctl,
+	int			write,
+	void			__user *buffer,
+	size_t			*lenp,
+	loff_t			*ppos)
 {
 	int		c, ret, *valp = ctl->data;
 	__uint32_t	vn_active;
@@ -55,11 +55,11 @@ xfs_stats_clear_proc_handler(
 
 STATIC int
 xfs_panic_mask_proc_handler(
-	ctl_table	*ctl,
-	int		write,
-	void		__user *buffer,
-	size_t		*lenp,
-	loff_t		*ppos)
+	struct ctl_table	*ctl,
+	int			write,
+	void			__user *buffer,
+	size_t			*lenp,
+	loff_t			*ppos)
 {
 	int		ret, *valp = ctl->data;
 
@@ -74,7 +74,7 @@ xfs_panic_mask_proc_handler(
 }
 #endif /* CONFIG_PROC_FS */
 
-static ctl_table xfs_table[] = {
+static struct ctl_table xfs_table[] = {
 	{
 		.procname	= "irix_sgid_inherit",
 		.data		= &xfs_params.sgid_inherit.val,
@@ -227,7 +227,7 @@ static ctl_table xfs_table[] = {
 	{}
 };
 
-static ctl_table xfs_dir_table[] = {
+static struct ctl_table xfs_dir_table[] = {
 	{
 		.procname	= "xfs",
 		.mode		= 0555,
@@ -236,7 +236,7 @@ static ctl_table xfs_dir_table[] = {
 	{}
 };
 
-static ctl_table xfs_root_table[] = {
+static struct ctl_table xfs_root_table[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
