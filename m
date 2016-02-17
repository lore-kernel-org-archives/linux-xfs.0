Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 530527CA2
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 22:29:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 207BC304043
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 20:29:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id X9RUy0sm5UKdCkrx for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 20:29:23 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D84C463C3D46
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 22:29:22 -0600 (CST)
Subject: [PATCH 2/3 V2] xfs: sanitize remount options
References: <56BBC982.50804@redhat.com> <56BBCA55.3000506@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C3F721.8080705@sandeen.net>
Date: Tue, 16 Feb 2016 22:29:21 -0600
MIME-Version: 1.0
In-Reply-To: <56BBCA55.3000506@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Perform basic sanitization of remount options by
passing the option string and a dummy mount structure
through xfs_parseargs and returning the result.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2: make *sb const in xfs_parseargs, with comment about why
    rename tmp->tmp_mp

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9b2e268..fe4c14e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -169,13 +169,17 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
  *
  * Note that this function leaks the various device name allocations on
  * failure.  The caller takes care of them.
+ *
+ * *sb is const because this is also used to test options on the remount
+ * path, and we don't want this to have any side effects at remount time.
+ * Today this function does not change *sb, but just to future-proof...
  */
 STATIC int
 xfs_parseargs(
 	struct xfs_mount	*mp,
 	char			*options)
 {
-	struct super_block	*sb = mp->m_super;
+	const struct super_block *sb = mp->m_super;
 	char			*p;
 	substring_t		args[MAX_OPT_ARGS];
 	int			dsunit = 0;
@@ -1167,6 +1171,27 @@ xfs_quiesce_attr(
 }
 
 STATIC int
+xfs_test_remount_options(
+	struct super_block	*sb,
+	struct xfs_mount	*mp,
+	char			*options)
+{
+	int			error = 0;
+	struct xfs_mount	*tmp_mp;
+
+	tmp_mp = kmem_zalloc(sizeof(*tmp_mp), KM_MAYFAIL);
+	if (!tmp_mp)
+		return -ENOMEM;
+
+	tmp_mp->m_super = sb;
+	error = xfs_parseargs(tmp_mp, options);
+	xfs_free_fsname(tmp_mp);
+	kfree(tmp_mp);
+
+	return error;
+}
+
+STATIC int
 xfs_fs_remount(
 	struct super_block	*sb,
 	int			*flags,
@@ -1178,6 +1203,11 @@ xfs_fs_remount(
 	char			*p;
 	int			error;
 
+	/* First, check for complete junk; i.e. invalid options */
+	error = xfs_test_remount_options(sb, mp, options);
+	if (error)
+		return error;
+
 	sync_filesystem(sb);
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
