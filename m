Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F50C3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD11D233A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbfHWBI5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:08:57 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5544
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729205AbfHWBI5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:08:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeEM4Qgj1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgk?=
 =?us-ascii?q?BAQEEAQIBAQYDAYVYhhkCAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMaikCBDCi?=
 =?us-ascii?q?BY4okeIEHgREzgx2HT4JYBIw9gleFMl1ClXcJgh+UWAyCJYs2AxCKUC2Dc6N?=
 =?us-ascii?q?hgXlNLgqDJ4J6jhpligQqgigBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgWeEM4Qgj?=
 =?us-ascii?q?1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgkBAQEEAQIBAQYDA?=
 =?us-ascii?q?YVYhhkCAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMaikCBDCiBY4okeIEHgREzg?=
 =?us-ascii?q?x2HT4JYBIw9gleFMl1ClXcJgh+UWAyCJYs2AxCKUC2Dc6NhgXlNLgqDJ4J6j?=
 =?us-ascii?q?hpligQqgigBAQ?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796699"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 08:59:43 +0800
Subject: [PATCH v2 05/15] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 08:59:43 +0800
Message-ID: <156652198391.2607.14772471190581142304.stgit@fedora-28>
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

Make xfs_parse_param() take arguments of the fs context operation
.parse_param() in preperation for switching to use the file system
mount context for mount.

The function fc_parse() only uses the file system context (fc here)
when calling log macros warnf() and invalf() which in turn check
only the fc->log field to determine if the message should be saved
to a context buffer (for later retrival by userspace) or logged
using printk().

Also the temporary function match_kstrtoint() is now unused, remove it.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  187 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 108 insertions(+), 79 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3ae29938dd89..754d2ccfd960 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -184,64 +184,62 @@ suffix_kstrtoint(const char *s, unsigned int base, int *res)
 	return ret;
 }
 
-STATIC int
-match_kstrtoint(const substring_t *s, unsigned int base, int *res)
-{
-	const char	*value;
-	int ret;
-
-	value = match_strdup(s);
-	if (!value)
-		return -ENOMEM;
-	ret = suffix_kstrtoint(value, base, res);
-	kfree(value);
-	return ret;
-}
+struct xfs_fs_context {
+	int	dsunit;
+	int	dswidth;
+	uint8_t	iosizelog;
+};
 
 STATIC int
 xfs_parse_param(
-	int 			token,
-	char			*p,
-	substring_t		*args,
-	struct xfs_mount	*mp,
-	int			*dsunit,
-	int			*dswidth,
-	uint8_t			*iosizelog)
+	struct fs_context	*fc,
+	struct fs_parameter	*param)
 {
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = fc->s_fs_info;
+	struct fs_parse_result	result;
 	int			iosize = 0;
+	int			opt;
 
-	switch (token) {
+	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
+	if (opt < 0)
+		return opt;
+
+	switch (opt) {
 	case Opt_logbufs:
-		if (match_int(args, &mp->m_logbufs))
-			return -EINVAL;
+		mp->m_logbufs = result.uint_32;
 		break;
 	case Opt_logbsize:
-		if (match_kstrtoint(args, 10, &mp->m_logbsize))
+		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
 			return -EINVAL;
 		break;
 	case Opt_logdev:
 		kfree(mp->m_logname);
-		mp->m_logname = match_strdup(args);
+		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
 		if (!mp->m_logname)
 			return -ENOMEM;
 		break;
 	case Opt_rtdev:
 		kfree(mp->m_rtname);
-		mp->m_rtname = match_strdup(args);
+		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
 		if (!mp->m_rtname)
 			return -ENOMEM;
 		break;
 	case Opt_allocsize:
 	case Opt_biosize:
-		if (match_kstrtoint(args, 10, &iosize))
+		if (suffix_kstrtoint(param->string, 10, &iosize))
 			return -EINVAL;
-		*iosizelog = ffs(iosize) - 1;
+		ctx->iosizelog = ffs(iosize) - 1;
 		break;
 	case Opt_grpid:
+		if (result.negated)
+			mp->m_flags &= ~XFS_MOUNT_GRPID;
+		else
+			mp->m_flags |= XFS_MOUNT_GRPID;
+		break;
 	case Opt_bsdgroups:
 		mp->m_flags |= XFS_MOUNT_GRPID;
 		break;
-	case Opt_nogrpid:
 	case Opt_sysvgroups:
 		mp->m_flags &= ~XFS_MOUNT_GRPID;
 		break;
@@ -258,12 +256,10 @@ xfs_parse_param(
 		mp->m_flags |= XFS_MOUNT_SWALLOC;
 		break;
 	case Opt_sunit:
-		if (match_int(args, dsunit))
-			return -EINVAL;
+		ctx->dsunit = result.uint_32;
 		break;
 	case Opt_swidth:
-		if (match_int(args, dswidth))
-			return -EINVAL;
+		ctx->dswidth = result.uint_32;
 		break;
 	case Opt_inode32:
 		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
@@ -275,33 +271,38 @@ xfs_parse_param(
 		mp->m_flags |= XFS_MOUNT_NOUUID;
 		break;
 	case Opt_ikeep:
-		mp->m_flags |= XFS_MOUNT_IKEEP;
-		break;
-	case Opt_noikeep:
-		mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		if (result.negated)
+			mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		else
+			mp->m_flags |= XFS_MOUNT_IKEEP;
 		break;
 	case Opt_largeio:
-		mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
-		break;
-	case Opt_nolargeio:
-		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+		if (result.negated)
+			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+		else
+			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
 		break;
 	case Opt_attr2:
-		mp->m_flags |= XFS_MOUNT_ATTR2;
-		break;
-	case Opt_noattr2:
-		mp->m_flags &= ~XFS_MOUNT_ATTR2;
-		mp->m_flags |= XFS_MOUNT_NOATTR2;
+		if (!result.negated) {
+			mp->m_flags |= XFS_MOUNT_ATTR2;
+		} else {
+			mp->m_flags &= ~XFS_MOUNT_ATTR2;
+			mp->m_flags |= XFS_MOUNT_NOATTR2;
+		}
 		break;
 	case Opt_filestreams:
 		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 		break;
-	case Opt_noquota:
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
-		break;
 	case Opt_quota:
+		if (!result.negated) {
+			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+					 XFS_UQUOTA_ENFD);
+		} else {
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
+		}
+		break;
 	case Opt_uquota:
 	case Opt_usrquota:
 		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
@@ -331,10 +332,10 @@ xfs_parse_param(
 		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
 		break;
 	case Opt_discard:
-		mp->m_flags |= XFS_MOUNT_DISCARD;
-		break;
-	case Opt_nodiscard:
-		mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		if (result.negated)
+			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		else
+			mp->m_flags |= XFS_MOUNT_DISCARD;
 		break;
 #ifdef CONFIG_FS_DAX
 	case Opt_dax:
@@ -342,7 +343,7 @@ xfs_parse_param(
 		break;
 #endif
 	default:
-		xfs_warn(mp, "unknown mount option [%s].", p);
+		xfs_warn(mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
 	}
 
@@ -367,10 +368,10 @@ xfs_parseargs(
 {
 	const struct super_block *sb = mp->m_super;
 	char			*p;
-	substring_t		args[MAX_OPT_ARGS];
-	int			dsunit = 0;
-	int			dswidth = 0;
-	uint8_t			iosizelog = 0;
+
+	struct fs_context	fc;
+	struct xfs_fs_context	context;
+	struct xfs_fs_context	*ctx = &context;
 
 	/*
 	 * set up the mount name first so all the errors will refer to the
@@ -406,17 +407,41 @@ xfs_parseargs(
 	if (!options)
 		goto done;
 
+	memset(&fc, 0, sizeof(fc));
+	memset(&ctx, 0, sizeof(ctx));
+	fc.fs_private = ctx;
+	fc.s_fs_info = mp;
+
 	while ((p = strsep(&options, ",")) != NULL) {
-		int		token;
-		int		ret;
+		struct fs_parameter	param;
+		char			*value;
+		int			ret;
 
 		if (!*p)
 			continue;
 
-		token = match_token(p, tokens, args);
-		ret = xfs_parse_param(token, p, args, mp,
-				      &dsunit, &dswidth, &iosizelog);
-		if (ret)
+		param.key = p;
+		param.type = fs_value_is_string;
+		param.size = 0;
+
+		value = strchr(p, '=');
+		if (value) {
+			if (value == p)
+				continue;
+			*value++ = 0;
+			param.size = strlen(value);
+			if (param.size > 0) {
+				param.string = kmemdup_nul(value,
+							   param.size,
+							   GFP_KERNEL);
+				if (!param.string)
+					return -ENOMEM;
+			}
+		}
+
+		ret = xfs_parse_param(&fc, &param);
+		kfree(param.string);
+		if (ret < 0)
 			return ret;
 	}
 
@@ -429,7 +454,7 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (ctx->dsunit || ctx->dswidth)) {
 		xfs_warn(mp,
 	"sunit and swidth options incompatible with the noalign option");
 		return -EINVAL;
@@ -442,28 +467,28 @@ xfs_parseargs(
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
 
 done:
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
@@ -485,18 +510,18 @@ xfs_parseargs(
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
@@ -1914,6 +1939,10 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
+static const struct fs_context_operations xfs_context_ops = {
+	.parse_param = xfs_parse_param,
+};
+
 static struct file_system_type xfs_fs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "xfs",

