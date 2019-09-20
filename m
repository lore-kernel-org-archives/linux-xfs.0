Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430ADC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16D942080F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437961AbfITJ47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:56:59 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:6242
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408538AbfITJ47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 05:56:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AmAADfoYRd/zmr0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgVMHAQELAQGEMoQiiByHSwEBBoERihqFH4oOFIFnCQEBAQEBAQEBATc?=
 =?us-ascii?q?BAYQ6AwICgyo0CQ4CDAEBAQQBAQEBAQUDAYVYgRABEAEEAYRyAgEDIwRSEBg?=
 =?us-ascii?q?NAiYCAkcQBhOFGasGc38zGoougQwoAYFiij54gQeBETODHYQdAQsDgyOCWAS?=
 =?us-ascii?q?McS+CNoVNX0KWR4IslSUMgiqLXQMQin6EM6R2ghBNLgqDJ1CBfheOL2aCa4h?=
 =?us-ascii?q?xfAGCUwEB?=
X-IPAS-Result: =?us-ascii?q?A2AmAADfoYRd/zmr0HYNVxwBAQEEAQEHBAEBgVMHAQELA?=
 =?us-ascii?q?QGEMoQiiByHSwEBBoERihqFH4oOFIFnCQEBAQEBAQEBATcBAYQ6AwICgyo0C?=
 =?us-ascii?q?Q4CDAEBAQQBAQEBAQUDAYVYgRABEAEEAYRyAgEDIwRSEBgNAiYCAkcQBhOFG?=
 =?us-ascii?q?asGc38zGoougQwoAYFiij54gQeBETODHYQdAQsDgyOCWASMcS+CNoVNX0KWR?=
 =?us-ascii?q?4IslSUMgiqLXQMQin6EM6R2ghBNLgqDJ1CBfheOL2aCa4hxfAGCUwEB?=
X-IronPort-AV: E=Sophos;i="5.64,528,1559491200"; 
   d="scan'208";a="253491610"
Received: from unknown (HELO [192.168.1.222]) ([118.208.171.57])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 20 Sep 2019 17:56:56 +0800
Subject: [PATCH v3 16/16] xfs: mount-api - remove legacy mount functions
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 20 Sep 2019 17:56:56 +0800
Message-ID: <156897341664.20210.14277645246214009071.stgit@fedora-28>
In-Reply-To: <156897321789.20210.339237101446767141.stgit@fedora-28>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that the new mount api is being used the old mount functions
and parsing table can be removed.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  218 ----------------------------------------------------
 1 file changed, 1 insertion(+), 217 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e0c8e9d8a2f6..9124e0c9f1eb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -61,53 +61,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
-};
-
-static const match_table_t tokens = {
-	{Opt_logbufs,	"logbufs=%u"},	/* number of XFS log buffers */
-	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers */
-	{Opt_logdev,	"logdev=%s"},	/* log device */
-	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
-	{Opt_wsync,	"wsync"},	/* safe-mode nfs compatible mount */
-	{Opt_noalign,	"noalign"},	/* turn off stripe alignment */
-	{Opt_swalloc,	"swalloc"},	/* turn on stripe width allocation */
-	{Opt_sunit,	"sunit=%u"},	/* data volume stripe unit */
-	{Opt_swidth,	"swidth=%u"},	/* data volume stripe width */
-	{Opt_nouuid,	"nouuid"},	/* ignore filesystem UUID */
-	{Opt_grpid,	"grpid"},	/* group-ID from parent directory */
-	{Opt_nogrpid,	"nogrpid"},	/* group-ID from current process */
-	{Opt_bsdgroups,	"bsdgroups"},	/* group-ID from parent directory */
-	{Opt_sysvgroups,"sysvgroups"},	/* group-ID from current process */
-	{Opt_allocsize,	"allocsize=%s"},/* preferred allocation size */
-	{Opt_norecovery,"norecovery"},	/* don't run XFS recovery */
-	{Opt_inode64,	"inode64"},	/* inodes can be allocated anywhere */
-	{Opt_inode32,   "inode32"},	/* inode allocation limited to
-					 * XFS_MAXINUMBER_32 */
-	{Opt_ikeep,	"ikeep"},	/* do not free empty inode clusters */
-	{Opt_noikeep,	"noikeep"},	/* free empty inode clusters */
-	{Opt_largeio,	"largeio"},	/* report large I/O sizes in stat() */
-	{Opt_nolargeio,	"nolargeio"},	/* do not report large I/O sizes
-					 * in stat(). */
-	{Opt_attr2,	"attr2"},	/* do use attr2 attribute format */
-	{Opt_noattr2,	"noattr2"},	/* do not use attr2 attribute format */
-	{Opt_filestreams,"filestreams"},/* use filestreams allocator */
-	{Opt_quota,	"quota"},	/* disk quotas (user) */
-	{Opt_noquota,	"noquota"},	/* no quotas */
-	{Opt_usrquota,	"usrquota"},	/* user quota enabled */
-	{Opt_grpquota,	"grpquota"},	/* group quota enabled */
-	{Opt_prjquota,	"prjquota"},	/* project quota enabled */
-	{Opt_uquota,	"uquota"},	/* user quota (IRIX variant) */
-	{Opt_gquota,	"gquota"},	/* group quota (IRIX variant) */
-	{Opt_pquota,	"pquota"},	/* project quota (IRIX variant) */
-	{Opt_uqnoenforce,"uqnoenforce"},/* user quota limit enforcement */
-	{Opt_gqnoenforce,"gqnoenforce"},/* group quota limit enforcement */
-	{Opt_pqnoenforce,"pqnoenforce"},/* project quota limit enforcement */
-	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
-	{Opt_discard,	"discard"},	/* Discard unused blocks */
-	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
-	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
-	{Opt_err,	NULL},
+	Opt_discard, Opt_nodiscard, Opt_dax,
 };
 
 static const struct fs_parameter_spec xfs_param_specs[] = {
@@ -447,130 +401,6 @@ xfs_validate_params(
 	return 0;
 }
 
-/*
- * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock has _not_ yet been read in.
- *
- * Note that this function leaks the various device name allocations on
- * failure.  The caller takes care of them.
- *
- * *sb is const because this is also used to test options on the remount
- * path, and we don't want this to have any side effects at remount time.
- * Today this function does not change *sb, but just to future-proof...
- */
-STATIC int
-xfs_parseargs(
-	struct xfs_mount	*mp,
-	char			*options)
-{
-	const struct super_block *sb = mp->m_super;
-	char			*p;
-	struct fs_context	fc;
-	struct xfs_fs_context	context;
-
-	memset(&fc, 0, sizeof(fc));
-	memset(&context, 0, sizeof(context));
-	fc.fs_private = &context;
-	fc.s_fs_info = mp;
-
-	/*
-	 * set up the mount name first so all the errors will refer to the
-	 * correct device.
-	 */
-	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
-	if (!mp->m_fsname)
-		return -ENOMEM;
-	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
-
-	/*
-	 * Copy binary VFS mount flags we are interested in.
-	 */
-	if (sb_rdonly(sb))
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-	if (sb->s_flags & SB_DIRSYNC)
-		mp->m_flags |= XFS_MOUNT_DIRSYNC;
-	if (sb->s_flags & SB_SYNCHRONOUS)
-		mp->m_flags |= XFS_MOUNT_WSYNC;
-
-	/*
-	 * Set some default flags that could be cleared by the mount option
-	 * parsing.
-	 */
-	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-
-	/*
-	 * These can be overridden by the mount option parsing.
-	 */
-	mp->m_logbufs = -1;
-	mp->m_logbsize = -1;
-
-	if (!options)
-		goto done;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		struct fs_parameter	param;
-		char			*value;
-		int			ret;
-
-		if (!*p)
-			continue;
-
-		param.key = p;
-		param.type = fs_value_is_string;
-		param.string = NULL;
-		param.size = 0;
-
-		value = strchr(p, '=');
-		if (value) {
-			*value++ = 0;
-			param.size = strlen(value);
-			if (param.size > 0) {
-				param.string = kmemdup_nul(value,
-							   param.size,
-							   GFP_KERNEL);
-				if (!param.string)
-					return -ENOMEM;
-			}
-		}
-
-		ret = xfs_parse_param(&fc, &param);
-		kfree(param.string);
-		if (ret < 0)
-			goto done;
-	}
-
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
-	    (ctx->dsunit || ctx->dswidth)) {
-		xfs_warn(mp,
-	"sunit and swidth options incompatible with the noalign option");
-		return -EINVAL;
-	}
-
-#ifndef CONFIG_XFS_QUOTA
-	if (XFS_IS_QUOTA_RUNNING(mp)) {
-		xfs_warn(mp, "quota support not available in this kernel.");
-		return -EINVAL;
-	}
-#endif
-
-	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
-		xfs_warn(mp, "sunit and swidth must be specified together");
-		return -EINVAL;
-	}
-
-	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
-		xfs_warn(mp,
-	"stripe width (%d) must be a multiple of the stripe unit (%d)",
-			ctx->dswidth, ctx->dsunit);
-		return -EINVAL;
-	}
-
-done:
-	ret = xfs_validate_params(mp, &context, false);
-
-	return ret;
-}
-
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;
@@ -1905,42 +1735,6 @@ __xfs_fs_fill_super(
 	goto out_free_sb;
 }
 
-STATIC int
-xfs_fs_fill_super(
-	struct super_block	*sb,
-	void			*data,
-	int			silent)
-{
-	struct xfs_mount	*mp = NULL;
-	int			error = -ENOMEM;
-
-	/*
-	 * allocate mp and do all low-level struct initializations before we
-	 * attach it to the super
-	 */
-	mp = xfs_mount_alloc();
-	if (!mp)
-		return -ENOMEM;
-	mp->m_super = sb;
-	sb->s_fs_info = mp;
-
-	error = xfs_parseargs(mp, (char *)data);
-	if (error)
-		goto out_free_fsname;
-
-	error = __xfs_fs_fill_super(mp, silent);
-	if (error)
-		goto out_free_fsname;
-
-	return 0;
-
- out_free_fsname:
-	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
-	kfree(mp);
-	return error;
-}
-
 STATIC int
 xfs_fill_super(
 	struct super_block	*sb,
@@ -2011,16 +1805,6 @@ xfs_fs_put_super(
 	kfree(mp);
 }
 
-STATIC struct dentry *
-xfs_fs_mount(
-	struct file_system_type	*fs_type,
-	int			flags,
-	const char		*dev_name,
-	void			*data)
-{
-	return mount_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super);
-}
-
 static long
 xfs_fs_nr_cached_objects(
 	struct super_block	*sb,

