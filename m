Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB2BC10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66802218DE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfJCK0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:26:00 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:43031
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729159AbfJCKZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:25:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BlAADHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVYEAQELAYFugkuEIo8qAwaBEYEjiHeRLAkBAQEBAQEBAQE3AQGEOwM?=
 =?us-ascii?q?CAoJoNwYOAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa4?=
 =?us-ascii?q?MdX8zGoongQwoAYFkikF4gQeBETOCKnOHUYJYBI0Bgi83hVhhQ5ZUgi2VMwy?=
 =?us-ascii?q?CLYtmAxCLDC2ECqUzgXtNLgqDJ1CCK44bZ45HKoIqAQE?=
X-IPAS-Result: =?us-ascii?q?A2BlAADHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgVYEAQELA?=
 =?us-ascii?q?YFugkuEIo8qAwaBEYEjiHeRLAkBAQEBAQEBAQE3AQGEOwMCAoJoNwYOAgwBA?=
 =?us-ascii?q?QEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa4MdX8zGoongQwoA?=
 =?us-ascii?q?YFkikF4gQeBETOCKnOHUYJYBI0Bgi83hVhhQ5ZUgi2VMwyCLYtmAxCLDC2EC?=
 =?us-ascii?q?qUzgXtNLgqDJ1CCK44bZ45HKoIqAQE?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652775"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:25:56 +0800
Subject: [PATCH v4 07/17] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:25:56 +0800
Message-ID: <157009835659.13858.5644566577857394261.stgit@fedora-28>
In-Reply-To: <157009817203.13858.7783767645177567968.stgit@fedora-28>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make xfs_parse_param() take arguments of the fs context operation
.parse_param() in preparation for switching to use the file system
mount context for mount.

The function fc_parse() only uses the file system context (fc here)
when calling log macros warnf() and invalf() which in turn check
only the fc->log field to determine if the message should be saved
to a context buffer (for later retrival by userspace) or logged
using printk().

In xfs_parse_param() immediately returning an error if fs_parse()
returns one will lead to an inconsistent log entry for unknown
parameters.

But there's also a need to support saving error messages to the
mount context when the fsxxx() system calls are used for passing
options and performing the mount which needs to be done without
possibly losing log entries. This isn't the way that the VFS mount
api log macros work now so follow up patches will be needed later
and they will need to be discussed to work out how this should
acheived for xfs.

Also the temporary function match_kstrtoint() is now unused, remove it.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  128 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 72 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b04aebab69ab..7fd3975d5523 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -191,57 +191,51 @@ suffix_kstrtoint(const char *s, unsigned int base, int *res)
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
-		if (match_kstrtoint(args, 10, &iosize))
+		if (suffix_kstrtoint(param->string, 10, &iosize))
 			return -EINVAL;
-		*iosizelog = ffs(iosize) - 1;
+		ctx->iosizelog = ffs(iosize) - 1;
 		break;
 	case Opt_grpid:
 	case Opt_bsdgroups:
@@ -264,12 +258,10 @@ xfs_parse_param(
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
@@ -348,7 +340,7 @@ xfs_parse_param(
 		break;
 #endif
 	default:
-		xfs_warn(mp, "unknown mount option [%s].", p);
+		xfs_warn(mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
 	}
 
@@ -373,10 +365,16 @@ xfs_parseargs(
 {
 	const struct super_block *sb = mp->m_super;
 	char			*p;
-	substring_t		args[MAX_OPT_ARGS];
-	int			dsunit = 0;
-	int			dswidth = 0;
-	uint8_t			iosizelog = 0;
+	struct fs_context	fc;
+	struct xfs_fs_context	context;
+	struct xfs_fs_context	*ctx;
+	int			ret;
+
+	memset(&fc, 0, sizeof(fc));
+	memset(&context, 0, sizeof(context));
+	fc.fs_private = &context;
+	ctx = &context;
+	fc.s_fs_info = mp;
 
 	/*
 	 * set up the mount name first so all the errors will refer to the
@@ -413,16 +411,33 @@ xfs_parseargs(
 		goto done;
 
 	while ((p = strsep(&options, ",")) != NULL) {
-		int		token;
-		int		ret;
+		struct fs_parameter	param;
+		char			*value;
 
 		if (!*p)
 			continue;
 
-		token = match_token(p, tokens, args);
-		ret = xfs_parse_param(token, p, args, mp,
-				      &dsunit, &dswidth, &iosizelog);
-		if (ret)
+		param.key = p;
+		param.type = fs_value_is_string;
+		param.string = NULL;
+		param.size = 0;
+
+		value = strchr(p, '=');
+		if (value) {
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
 
@@ -435,7 +450,8 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
+	    (ctx->dsunit || ctx->dswidth)) {
 		xfs_warn(mp,
 	"sunit and swidth options incompatible with the noalign option");
 		return -EINVAL;
@@ -448,28 +464,28 @@ xfs_parseargs(
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
@@ -491,18 +507,18 @@ xfs_parseargs(
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

