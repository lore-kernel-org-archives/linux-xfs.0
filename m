Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E51ECA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BB8121872
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389149AbfJXHwI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:52:08 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404960AbfJXHwI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:52:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AdAwDRVrFd/0e30XYNWBwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF7AoFtgk2EKI9JBoszhSABjA4JAQEBAQEBAQEBNwEBg0B7AwI?=
 =?us-ascii?q?Cg1k4EwIMAQEBBAEBAQEBBQMBhViBGgEMAYUBAgEDGgkERQgCAxAYDQImAgJ?=
 =?us-ascii?q?HEAYKCYV1sXR1fzMaijCBDigBgWSKQniBB4EQAYNQhB4BCwdAgmSCXgSNDi+?=
 =?us-ascii?q?CADeFX2FDh2uPAYIulUUMgi+LcAMQixSPeZodgXpNLgqDJ1CDNheOMGeKVoJ?=
 =?us-ascii?q?9AYJaAQE?=
X-IPAS-Result: =?us-ascii?q?A2AdAwDRVrFd/0e30XYNWBwBAQEBAQcBAREBBAQBAYF7A?=
 =?us-ascii?q?oFtgk2EKI9JBoszhSABjA4JAQEBAQEBAQEBNwEBg0B7AwICg1k4EwIMAQEBB?=
 =?us-ascii?q?AEBAQEBBQMBhViBGgEMAYUBAgEDGgkERQgCAxAYDQImAgJHEAYKCYV1sXR1f?=
 =?us-ascii?q?zMaijCBDigBgWSKQniBB4EQAYNQhB4BCwdAgmSCXgSNDi+CADeFX2FDh2uPA?=
 =?us-ascii?q?YIulUUMgi+LcAMQixSPeZodgXpNLgqDJ1CDNheOMGeKVoJ9AYJaAQE?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250044219"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:52:04 +0800
Subject: [PATCH v7 17/17] xfs: switch to use the new mount-api
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:52:04 +0800
Message-ID: <157190352448.27074.494735602866447310.stgit@fedora-28>
In-Reply-To: <157190333868.27074.13987695222060552856.stgit@fedora-28>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Define the struct fs_parameter_spec table that's used by the new mount
api for options parsing.

Create the various fs context operations methods and define the
fs_context_operations struct.

Create the fs context initialization method and update the struct
file_system_type to utilize it. The initialization function is
responsible for working storage initialization, allocation and
initialization of file system private information storage and for
setting the operations in the fs context.

With the new mount api the options parsing and the filling of the super
block are done seperately. Becuase of this it's sometimes necessary to
communicate intermediate values between the options parsing and the
fill super functions.

Define struct xfs_fc_context that holds intermediate values set from the
passed options. The fields dsunit and dswidth depend on one another so
the checks and setting of struct xfs_mount fields drom them need to be
done after options parsing. The iosizelog field could be set in the
options parsing function but the check used before setting the struct
xfs_mount field is a little more than trivial and would reduce the
readabiliy of the options parsing function so it's also added to the
struct xfs_fc_context.

I could have moved the xfs_fs_remount() function up to be with the
other mount related code to try and highlight what actually changed
when converting it to xfs_fc_reconfigure(). But the function is fairly
short and the gain in patch readability didn't appear to be worth the
extra code churn.

Finally remove unused code.

And rename xfs_fs_fill_super() to xfs_fc_fill_super() for consistency.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  530 +++++++++++++++++++++++-----------------------------
 1 file changed, 237 insertions(+), 293 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index dd019be3fa72..3046aba9b058 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -38,6 +38,8 @@
 
 #include <linux/magic.h>
 #include <linux/parser.h>
+#include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 
 static const struct super_operations xfs_super_operations;
 struct bio_set xfs_ioend_bioset;
@@ -71,55 +73,57 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_dax,
 };
 
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
+static const struct fs_parameter_spec xfs_fc_param_specs[] = {
+	fsparam_u32("logbufs",		Opt_logbufs),
+	fsparam_string("logbsize",	Opt_logbsize),
+	fsparam_string("logdev",	Opt_logdev),
+	fsparam_string("rtdev",		Opt_rtdev),
+	fsparam_flag("wsync",		Opt_wsync),
+	fsparam_flag("noalign",		Opt_noalign),
+	fsparam_flag("swalloc",		Opt_swalloc),
+	fsparam_u32("sunit",		Opt_sunit),
+	fsparam_u32("swidth",		Opt_swidth),
+	fsparam_flag("nouuid",		Opt_nouuid),
+	fsparam_flag("grpid",		Opt_grpid),
+	fsparam_flag("nogrpid",		Opt_nogrpid),
+	fsparam_flag("bsdgroups",	Opt_bsdgroups),
+	fsparam_flag("sysvgroups",	Opt_sysvgroups),
+	fsparam_string("allocsize",	Opt_allocsize),
+	fsparam_flag("norecovery",	Opt_norecovery),
+	fsparam_flag("inode64",		Opt_inode64),
+	fsparam_flag("inode32",		Opt_inode32),
+	fsparam_flag("ikeep",		Opt_ikeep),
+	fsparam_flag("noikeep",		Opt_noikeep),
+	fsparam_flag("largeio",		Opt_largeio),
+	fsparam_flag("nolargeio",	Opt_nolargeio),
+	fsparam_flag("attr2",		Opt_attr2),
+	fsparam_flag("noattr2",		Opt_noattr2),
+	fsparam_flag("filestreams",	Opt_filestreams),
+	fsparam_flag("quota",		Opt_quota),
+	fsparam_flag("noquota",		Opt_noquota),
+	fsparam_flag("usrquota",	Opt_usrquota),
+	fsparam_flag("grpquota",	Opt_grpquota),
+	fsparam_flag("prjquota",	Opt_prjquota),
+	fsparam_flag("uquota",		Opt_uquota),
+	fsparam_flag("gquota",		Opt_gquota),
+	fsparam_flag("pquota",		Opt_pquota),
+	fsparam_flag("uqnoenforce",	Opt_uqnoenforce),
+	fsparam_flag("gqnoenforce",	Opt_gqnoenforce),
+	fsparam_flag("pqnoenforce",	Opt_pqnoenforce),
+	fsparam_flag("qnoenforce",	Opt_qnoenforce),
+	fsparam_flag("discard",		Opt_discard),
+	fsparam_flag("nodiscard",	Opt_nodiscard),
+	fsparam_flag("dax",		Opt_dax),
+	{}
 };
 
+static const struct fs_parameter_description xfs_fc_parameters = {
+	.name		= "xfs",
+	.specs		= xfs_fc_param_specs,
+};
 
 static int
 suffix_kstrtoint(
@@ -156,60 +160,51 @@ suffix_kstrtoint(
 	return ret;
 }
 
-static int
-match_kstrtoint(
-	const substring_t	*s,
-	unsigned int		base,
-	int			*res)
-{
-	const char		*value;
-	int			ret;
-
-	value = match_strdup(s);
-	if (!value)
-		return -ENOMEM;
-	ret = suffix_kstrtoint(value, base, res);
-	kfree(value);
-	return ret;
-}
+struct xfs_fc_context {
+	int     dsunit;
+	int     dswidth;
+	uint8_t iosizelog;
+};
 
 static int
 xfs_fc_parse_param(
-	int			token,
-	char			*p,
-	substring_t		*args,
-	struct xfs_mount	*mp,
-	int			*dsunit,
-	int			*dswidth,
-	uint8_t			*iosizelog)
+	struct fs_context	*fc,
+	struct fs_parameter	*param)
 {
+	struct xfs_fc_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = fc->s_fs_info;
+	struct fs_parse_result	result;
 	int			iosize = 0;
+	int			opt;
+
+	opt = fs_parse(fc, &xfs_fc_parameters, param, &result);
+	if (opt < 0)
+		return opt;
 
-	switch (token) {
+	switch (opt) {
 	case Opt_logbufs:
-		if (match_int(args, &mp->m_logbufs))
-			return -EINVAL;
+		mp->m_logbufs = result.uint_32;
 		return 0;
 	case Opt_logbsize:
-		if (match_kstrtoint(args, 10, &mp->m_logbsize))
+		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
 			return -EINVAL;
 		return 0;
 	case Opt_logdev:
 		kfree(mp->m_logname);
-		mp->m_logname = match_strdup(args);
+		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
 		if (!mp->m_logname)
 			return -ENOMEM;
 		return 0;
 	case Opt_rtdev:
 		kfree(mp->m_rtname);
-		mp->m_rtname = match_strdup(args);
+		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
 		if (!mp->m_rtname)
 			return -ENOMEM;
 		return 0;
 	case Opt_allocsize:
-		if (match_kstrtoint(args, 10, &iosize))
+		if (suffix_kstrtoint(param->string, 10, &iosize))
 			return -EINVAL;
-		*iosizelog = ffs(iosize) - 1;
+		ctx->iosizelog = ffs(iosize) - 1;
 		return 0;
 	case Opt_grpid:
 	case Opt_bsdgroups:
@@ -232,13 +227,11 @@ xfs_fc_parse_param(
 		mp->m_flags |= XFS_MOUNT_SWALLOC;
 		return 0;
 	case Opt_sunit:
-		if (match_int(args, dsunit))
-			return -EINVAL;
+		ctx->dsunit = result.uint_32;
 		return 0;
 	case Opt_swidth:
-		if (match_int(args, dswidth))
-			return -EINVAL;
-		return 0;
+		ctx->dswidth = result.uint_32;
+		return 0;;
 	case Opt_inode32:
 		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 		return 0;
@@ -316,7 +309,7 @@ xfs_fc_parse_param(
 		return 0;
 #endif
 	default:
-		xfs_warn(mp, "unknown mount option [%s].", p);
+		xfs_warn(mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
 	}
 
@@ -326,9 +319,7 @@ xfs_fc_parse_param(
 static int
 xfs_fc_validate_params(
 	struct xfs_mount	*mp,
-	int			dsunit,
-	int			dswidth,
-	uint8_t			iosizelog)
+	struct xfs_fc_context	*ctx)
 {
 	/*
 	 * no recovery flag requires a read-only mount
@@ -339,7 +330,8 @@ xfs_fc_validate_params(
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
+	    (ctx->dsunit || ctx->dswidth)) {
 		xfs_warn(mp,
 	"sunit and swidth options incompatible with the noalign option");
 		return -EINVAL;
@@ -352,27 +344,27 @@ xfs_fc_validate_params(
 	}
 #endif
 
-	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
+	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
 		xfs_warn(mp, "sunit and swidth must be specified together");
 		return -EINVAL;
 	}
 
-	if (dsunit && (dswidth % dsunit != 0)) {
+	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
 		xfs_warn(mp,
 	"stripe width (%d) must be a multiple of the stripe unit (%d)",
-			dswidth, dsunit);
+			ctx->dswidth, ctx->dsunit);
 		return -EINVAL;
 	}
 
-	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
+	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
 		/*
 		 * At this point the superblock has not been read
 		 * in, therefore we do not know the block size.
 		 * Before the mount call ends we will convert
 		 * these to FSBs.
 		 */
-		mp->m_dalign = dsunit;
-		mp->m_swidth = dswidth;
+		mp->m_dalign = ctx->dsunit;
+		mp->m_swidth = ctx->dswidth;
 	}
 
 	if (mp->m_logbufs != -1 &&
@@ -394,18 +386,18 @@ xfs_fc_validate_params(
 		return -EINVAL;
 	}
 
-	if (iosizelog) {
-		if (iosizelog > XFS_MAX_IO_LOG ||
-		    iosizelog < XFS_MIN_IO_LOG) {
+	if (ctx->iosizelog) {
+		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
+		    ctx->iosizelog < XFS_MIN_IO_LOG) {
 			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-				iosizelog, XFS_MIN_IO_LOG,
+				ctx->iosizelog, XFS_MIN_IO_LOG,
 				XFS_MAX_IO_LOG);
 			return -EINVAL;
 		}
 
 		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_readio_log = iosizelog;
-		mp->m_writeio_log = iosizelog;
+		mp->m_readio_log = ctx->iosizelog;
+		mp->m_writeio_log = ctx->iosizelog;
 	}
 
 	return 0;
@@ -552,92 +544,19 @@ xfs_remount_ro(
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
 static int
-xfs_parseargs(
-	struct xfs_mount	*mp,
-	char			*options)
-{
-	const struct super_block *sb = mp->m_super;
-	char			*p;
-	substring_t		args[MAX_OPT_ARGS];
-	int			dsunit = 0;
-	int			dswidth = 0;
-	uint8_t			iosizelog = 0;
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
-		return 0;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int		token;
-		int		ret;
-
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		ret = xfs_fc_parse_param(token, p, args, mp, &dsunit, &dswidth,
-					 &iosizelog);
-		if (ret)
-			return ret;
-	}
-
-	return xfs_fc_validate_params(mp, dsunit, dswidth, iosizelog);
-}
-
-static int
-xfs_fs_fill_super(
+xfs_fc_fill_super(
 	struct super_block	*sb,
-	void			*data,
-	int			silent)
+	struct fs_context       *fc)
 {
+	struct xfs_fc_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = sb->s_fs_info;
 	struct inode		*root;
-	struct xfs_mount	*mp = NULL;
 	int			flags = 0, error = -ENOMEM;
 
-	/*
-	 * allocate mp and do all low-level struct initializations before we
-	 * attach it to the super
-	 */
-	mp = xfs_mount_alloc();
-	if (!mp)
-		goto out;
 	mp->m_super = sb;
-	sb->s_fs_info = mp;
 
-	error = xfs_parseargs(mp, (char *)data);
+	error = xfs_fc_validate_params(mp, ctx);
 	if (error)
 		goto out_free_names;
 
@@ -661,7 +580,7 @@ xfs_fs_fill_super(
 		msleep(xfs_globals.mount_delay * 1000);
 	}
 
-	if (silent)
+	if (fc->sb_flags & SB_SILENT)
 		flags |= XFS_MFSI_QUIET;
 
 	error = xfs_open_devices(mp);
@@ -806,7 +725,6 @@ xfs_fs_fill_super(
  out_free_names:
 	sb->s_fs_info = NULL;
 	xfs_mount_free(mp);
- out:
 	return error;
 
  out_unmount:
@@ -815,6 +733,147 @@ xfs_fs_fill_super(
 	goto out_free_sb;
 }
 
+static int
+xfs_fc_get_tree(
+	struct fs_context	*fc)
+{
+	return get_tree_bdev(fc, xfs_fc_fill_super);
+}
+
+/*
+ * Logically we would return an error here to prevent users from believing
+ * they might have changed mount options using remount which can't be changed.
+ *
+ * But unfortunately mount(8) adds all options from mtab and fstab to the mount
+ * arguments in some cases so we can't blindly reject options, but have to
+ * check for each specified option if it actually differs from the currently
+ * set option and only reject it if that's the case.
+ *
+ * Until that is implemented we return success for every remount request, and
+ * silently ignore all options that we can't actually change.
+ */
+static int
+xfs_fc_reconfigure(
+	struct fs_context *fc)
+{
+	struct xfs_fc_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
+	struct xfs_mount        *new_mp = fc->s_fs_info;
+	xfs_sb_t		*sbp = &mp->m_sb;
+	int			flags = fc->sb_flags;
+	int			error;
+
+	error = xfs_fc_validate_params(new_mp, ctx);
+	if (error)
+		return error;
+
+	/* inode32 -> inode64 */
+	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
+	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
+		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
+	}
+
+	/* inode64 -> inode32 */
+	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
+	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
+		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
+	}
+
+	/* ro -> rw */
+	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
+		error = xfs_remount_rw(mp);
+		if (error)
+			return error;
+	}
+
+	/* rw -> ro */
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
+		error = xfs_remount_ro(mp);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+static void xfs_fc_free(struct fs_context *fc)
+{
+	struct xfs_fc_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = fc->s_fs_info;
+
+	/*
+	 * mp and ctx are stored in the fs_context when it is
+	 * initialized. mp is transferred to the superblock on
+	 * a successful mount, but if an error occurs before the
+	 * transfer we have to free it here.
+	 */
+	if (mp)
+		xfs_mount_free(mp);
+	kfree(ctx);
+}
+
+static const struct fs_context_operations xfs_context_ops = {
+	.parse_param = xfs_fc_parse_param,
+	.get_tree    = xfs_fc_get_tree,
+	.reconfigure = xfs_fc_reconfigure,
+	.free        = xfs_fc_free,
+};
+
+static int xfs_fc_init_context(struct fs_context *fc)
+{
+	struct xfs_fc_context	*ctx;
+	struct xfs_mount	*mp;
+
+	ctx = kzalloc(sizeof(struct xfs_fc_context), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	mp = xfs_mount_alloc();
+	if (!mp) {
+		kfree(ctx);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Set some default flags that could be cleared by the mount option
+	 * parsing.
+	 */
+	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+
+	/*
+	 * These can be overridden by the mount option parsing.
+	 */
+	mp->m_logbufs = -1;
+	mp->m_logbsize = -1;
+
+	/*
+	 * Copy binary VFS mount flags we are interested in.
+	 */
+	if (fc->sb_flags & SB_RDONLY)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	if (fc->sb_flags & SB_DIRSYNC)
+		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+	if (fc->sb_flags & SB_SYNCHRONOUS)
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+
+	fc->fs_private = ctx;
+	fc->s_fs_info = mp;
+	fc->ops = &xfs_context_ops;
+
+	return 0;
+}
+
+static struct file_system_type xfs_fs_type = {
+	.owner			= THIS_MODULE,
+	.name			= "xfs",
+	.init_fs_context	= xfs_fc_init_context,
+	.parameters		= &xfs_fc_parameters,
+	.kill_sb		= kill_block_super,
+	.fs_flags		= FS_REQUIRES_DEV,
+};
+
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;
@@ -1585,103 +1644,6 @@ xfs_quiesce_attr(
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
-	xfs_mount_free(tmp_mp);
-
-	return error;
-}
-
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
  * Second stage of a freeze. The data is already frozen so we only
  * need to take care of the metadata. Once that's done sync the superblock
@@ -1867,16 +1829,6 @@ xfs_fs_put_super(
 	xfs_mount_free(mp);
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
@@ -1906,19 +1858,11 @@ static const struct super_operations xfs_super_operations = {
 	.freeze_fs		= xfs_fs_freeze,
 	.unfreeze_fs		= xfs_fs_unfreeze,
 	.statfs			= xfs_fs_statfs,
-	.remount_fs		= xfs_fs_remount,
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
-static struct file_system_type xfs_fs_type = {
-	.owner			= THIS_MODULE,
-	.name			= "xfs",
-	.mount			= xfs_fs_mount,
-	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
-};
 MODULE_ALIAS_FS("xfs");
 
 STATIC int __init

