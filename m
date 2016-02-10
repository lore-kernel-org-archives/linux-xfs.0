Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 54F7C7CBC
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 17:40:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4BEAAC00B
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 15:40:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kPLpo4jCnSLg2vmV for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 15:40:05 -0800 (PST)
Received: from Liberator.local (70-90-76-85-BusName-mn.hfc.comcastbusiness.net
	[70.90.76.85])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9B65863C607A
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 17:40:05 -0600 (CST)
Subject: [PATCH 2/3] xfs: sanitize remount options
References: <56BBC982.50804@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BBCA55.3000506@sandeen.net>
Date: Wed, 10 Feb 2016 17:40:05 -0600
MIME-Version: 1.0
In-Reply-To: <56BBC982.50804@redhat.com>
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
---

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 934233a..d1cd4fa 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1168,6 +1168,27 @@ xfs_quiesce_attr(
 }
 
 STATIC int
+xfs_test_remount_options(
+	struct super_block	*sb,
+	struct xfs_mount	*mp,
+	char			*options)
+{
+	int			error = 0;
+	struct xfs_mount	*tmp;
+
+	tmp = kmem_zalloc(sizeof(*tmp), KM_MAYFAIL);
+	if (!tmp)
+		return -ENOMEM;
+
+	tmp->m_super = sb;
+	error = xfs_parseargs(tmp, options);
+	xfs_free_fsname(tmp);
+	kfree(tmp);
+
+	return error;
+}
+
+STATIC int
 xfs_fs_remount(
 	struct super_block	*sb,
 	int			*flags,
@@ -1179,6 +1200,11 @@ xfs_fs_remount(
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
