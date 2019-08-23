Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2578CC3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F013C233A0
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbfHWBJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:09:59 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5824
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387656AbfHWBJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:09:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AMBwAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWcChDGEII9WAQEGgRGKEY88gWcJAQEBAQEBAQEBNwEBhDoDAgKDAjg?=
 =?us-ascii?q?TAgkBAQEEAQIBAQYDAYVYgRABDAEIAQGEcQIBAyMEUhAYDQImAgJHEAYThRm?=
 =?us-ascii?q?rUHN/MxqKQIEMKAGBYookeIEHgRABM4MdhB0BCwODI4JYBIw9L4IohTJdQpV?=
 =?us-ascii?q?3CYIflFgMgiWLNgMQilCEIKNhgXlNLgqDJ4JOF44vZYRsg3ttMAGCUQEB?=
X-IPAS-Result: =?us-ascii?q?A2AMBwAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgWcChDGEI?=
 =?us-ascii?q?I9WAQEGgRGKEY88gWcJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgkBAQEEAQIBA?=
 =?us-ascii?q?QYDAYVYgRABDAEIAQGEcQIBAyMEUhAYDQImAgJHEAYThRmrUHN/MxqKQIEMK?=
 =?us-ascii?q?AGBYookeIEHgRABM4MdhB0BCwODI4JYBIw9L4IohTJdQpV3CYIflFgMgiWLN?=
 =?us-ascii?q?gMQilCEIKNhgXlNLgqDJ4JOF44vZYRsg3ttMAGCUQEB?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796957"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 09:00:38 +0800
Subject: [PATCH v2 15/15] xfs: mount-api - remove legacy mount functions
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 09:00:38 +0800
Message-ID: <156652203804.2607.11090121378501372800.stgit@fedora-28>
In-Reply-To: <156652158924.2607.14608448087216437699.stgit@fedora-28>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
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
 fs/xfs/xfs_super.c |  307 +---------------------------------------------------
 1 file changed, 6 insertions(+), 301 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fe7acd8ddd48..ef649a485269 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -52,60 +52,12 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 enum {
 	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
 	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
-	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
-	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
-	Opt_noikeep, Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2,
-	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
-	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
-	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
-};
-
-static const match_table_t tokens = {
-	{Opt_logbufs,	"logbufs=%u"},	/* number of XFS log buffers */
-	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers */
-	{Opt_logdev,	"logdev=%s"},	/* log device */
-	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
-	{Opt_biosize,	"biosize=%u"},	/* log2 of preferred buffered io size */
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
+	Opt_grpid, Opt_bsdgroups, Opt_sysvgroups, Opt_allocsize,
+	Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep, Opt_largeio,
+	Opt_attr2, Opt_filestreams, Opt_quota, Opt_usrquota, Opt_grpquota,
+	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota, Opt_uqnoenforce,
+	Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce, Opt_discard,
+	Opt_dax,
 };
 
 static const struct fs_parameter_spec xfs_param_specs[] = {
@@ -441,108 +393,6 @@ xfs_validate_params(
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
-
-	struct fs_context	fc;
-	struct xfs_fs_context	context;
-	struct xfs_fs_context	*ctx = &context;
-	int			ret;
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
-	if (!options) {
-		ret = xfs_validate_params(mp, ctx, true);
-		goto done;
-	}
-
-	memset(&fc, 0, sizeof(fc));
-	memset(&ctx, 0, sizeof(ctx));
-	fc.fs_private = ctx;
-	fc.s_fs_info = mp;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		struct fs_parameter	param;
-		char			*value;
-
-		if (!*p)
-			continue;
-
-		param.key = p;
-		param.type = fs_value_is_string;
-		param.size = 0;
-
-		value = strchr(p, '=');
-		if (value) {
-			if (value == p)
-				continue;
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
-	ret = xfs_validate_params(mp, ctx, false);
-done:
-	return ret;
-}
-
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;
@@ -1321,26 +1171,6 @@ xfs_quiesce_attr(
 	xfs_log_quiesce(mp);
 }
 
-STATIC int
-xfs_test_remount_options(
-	struct super_block	*sb,
-	char			*options)
-{
-	int			error = 0;
-	struct xfs_mount	*tmp_mp;
-
-	tmp_mp = kmem_zalloc(sizeof(*tmp_mp), KM_MAYFAIL);
-	if (!tmp_mp)
-		return -ENOMEM;
-
-	tmp_mp->m_super = sb;
-	error = xfs_parseargs(tmp_mp, options);
-	xfs_free_fsname(tmp_mp);
-	kmem_free(tmp_mp);
-
-	return error;
-}
-
 STATIC int
 xfs_remount_rw(
 	struct xfs_mount	*mp)
@@ -1444,84 +1274,6 @@ xfs_remount_ro(
 	return 0;
 }
 
-STATIC int
-xfs_fs_remount(
-	struct super_block	*sb,
-	int			*flags,
-	char			*options)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-	xfs_sb_t		*sbp = &mp->m_sb;
-	substring_t		args[MAX_OPT_ARGS];
-	char			*p;
-	int			error;
-
-	/* First, check for complete junk; i.e. invalid options */
-	error = xfs_test_remount_options(sb, options);
-	if (error)
-		return error;
-
-	sync_filesystem(sb);
-	while ((p = strsep(&options, ",")) != NULL) {
-		int token;
-
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_inode64:
-			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
-			break;
-		case Opt_inode32:
-			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
-			break;
-		default:
-			/*
-			 * Logically we would return an error here to prevent
-			 * users from believing they might have changed
-			 * mount options using remount which can't be changed.
-			 *
-			 * But unfortunately mount(8) adds all options from
-			 * mtab and fstab to the mount arguments in some cases
-			 * so we can't blindly reject options, but have to
-			 * check for each specified option if it actually
-			 * differs from the currently set option and only
-			 * reject it if that's the case.
-			 *
-			 * Until that is implemented we return success for
-			 * every remount request, and silently ignore all
-			 * options that we can't actually change.
-			 */
-#if 0
-			xfs_info(mp,
-		"mount option \"%s\" not supported for remount", p);
-			return -EINVAL;
-#else
-			break;
-#endif
-		}
-	}
-
-	/* ro -> rw */
-	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
-		error = xfs_remount_rw(mp);
-		if (error)
-			return error;
-	}
-
-	/* rw -> ro */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
-		error = xfs_remount_ro(mp);
-		if (error)
-			return error;
-	}
-
-	return 0;
-}
-
 /*
  * There have been problems in the past with options passed from mount(8).
  *
@@ -1976,43 +1728,6 @@ __xfs_fs_fill_super(
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
-		goto out;
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
-out:
-	return error;
-}
-
 STATIC int
 xfs_fill_super(
 	struct super_block	*sb,
@@ -2084,16 +1799,6 @@ xfs_fs_put_super(
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

