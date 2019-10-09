Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582B5ECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B76D21721
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 11:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfJILbI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 07:31:08 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33473
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbfJILbI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:31:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BRAABxxJ1d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFqBAEBCwGEOYQjjygBAQEDBoERih2FH4wPCQEBAQEBAQEBATc?=
 =?us-ascii?q?BAYQ7AwICgnI3Bg4CDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxA?=
 =?us-ascii?q?GE4UZr291fzMaiiyBDCgBgWSKQXiBB4FEgx2EKYMpglgEjQWCLzeGPEOWWYI?=
 =?us-ascii?q?slTQMgi6LZwMQiwwthAqlPIF7TS4KgydQkEZnjkEBK4InAQE?=
X-IPAS-Result: =?us-ascii?q?A2BRAABxxJ1d/0e30XYNWRwBAQEBAQcBAREBBAQBAYFqB?=
 =?us-ascii?q?AEBCwGEOYQjjygBAQEDBoERih2FH4wPCQEBAQEBAQEBATcBAYQ7AwICgnI3B?=
 =?us-ascii?q?g4CDAEBAQQBAQEBAQUDAYVYhhoCAQMjBFIQGA0CJgICRxAGE4UZr291fzMai?=
 =?us-ascii?q?iyBDCgBgWSKQXiBB4FEgx2EKYMpglgEjQWCLzeGPEOWWYIslTQMgi6LZwMQi?=
 =?us-ascii?q?wwthAqlPIF7TS4KgydQkEZnjkEBK4InAQE?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216229049"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:30:52 +0800
Subject: [PATCH v5 08/17] xfs: mount-api - move xfs_parseargs() validation
 to a helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:30:52 +0800
Message-ID: <157062065250.32346.13350789812067183237.stgit@fedora-28>
In-Reply-To: <157062043952.32346.977737248061083292.stgit@fedora-28>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the validation code of xfs_parseargs() into a helper for later
use within the mount context methods.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |  147 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 94 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7fd3975d5523..7008355df065 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -347,6 +347,98 @@ xfs_parse_param(
 	return 0;
 }
 
+STATIC int
+xfs_validate_params(
+	struct xfs_mount        *mp,
+	struct xfs_fs_context   *ctx,
+	bool			nooptions)
+{
+	if (nooptions)
+		goto noopts;
+
+	/*
+	 * no recovery flag requires a read-only mount
+	 */
+	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		xfs_warn(mp, "no-recovery mounts must be read-only.");
+		return -EINVAL;
+	}
+
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
+	    (ctx->dsunit || ctx->dswidth)) {
+		xfs_warn(mp,
+	"sunit and swidth options incompatible with the noalign option");
+		return -EINVAL;
+	}
+
+#ifndef CONFIG_XFS_QUOTA
+	if (XFS_IS_QUOTA_RUNNING(mp)) {
+		xfs_warn(mp, "quota support not available in this kernel.");
+		return -EINVAL;
+	}
+#endif
+
+	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
+		xfs_warn(mp, "sunit and swidth must be specified together");
+		return -EINVAL;
+	}
+
+	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
+		xfs_warn(mp,
+	"stripe width (%d) must be a multiple of the stripe unit (%d)",
+			ctx->dswidth, ctx->dsunit);
+		return -EINVAL;
+	}
+
+noopts:
+	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
+		/*
+		 * At this point the superblock has not been read
+		 * in, therefore we do not know the block size.
+		 * Before the mount call ends we will convert
+		 * these to FSBs.
+		 */
+		mp->m_dalign = ctx->dsunit;
+		mp->m_swidth = ctx->dswidth;
+	}
+
+	if (mp->m_logbufs != -1 &&
+	    mp->m_logbufs != 0 &&
+	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
+	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
+		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
+			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
+		return -EINVAL;
+	}
+	if (mp->m_logbsize != -1 &&
+	    mp->m_logbsize !=  0 &&
+	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
+	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
+	     !is_power_of_2(mp->m_logbsize))) {
+		xfs_warn(mp,
+			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
+			mp->m_logbsize);
+		return -EINVAL;
+	}
+
+	if (ctx->iosizelog) {
+		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
+		    ctx->iosizelog < XFS_MIN_IO_LOG) {
+			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
+				ctx->iosizelog, XFS_MIN_IO_LOG,
+				XFS_MAX_IO_LOG);
+			return -EINVAL;
+		}
+
+		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
+		mp->m_readio_log = ctx->iosizelog;
+		mp->m_writeio_log = ctx->iosizelog;
+	}
+
+	return 0;
+}
+
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock has _not_ yet been read in.
@@ -441,15 +533,6 @@ xfs_parseargs(
 			return ret;
 	}
 
-	/*
-	 * no recovery flag requires a read-only mount
-	 */
-	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
-	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		xfs_warn(mp, "no-recovery mounts must be read-only.");
-		return -EINVAL;
-	}
-
 	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
 	    (ctx->dsunit || ctx->dswidth)) {
 		xfs_warn(mp,
@@ -477,51 +560,9 @@ xfs_parseargs(
 	}
 
 done:
-	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
-		/*
-		 * At this point the superblock has not been read
-		 * in, therefore we do not know the block size.
-		 * Before the mount call ends we will convert
-		 * these to FSBs.
-		 */
-		mp->m_dalign = ctx->dsunit;
-		mp->m_swidth = ctx->dswidth;
-	}
+	ret = xfs_validate_params(mp, &context, false);
 
-	if (mp->m_logbufs != -1 &&
-	    mp->m_logbufs != 0 &&
-	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
-	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
-		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
-			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
-		return -EINVAL;
-	}
-	if (mp->m_logbsize != -1 &&
-	    mp->m_logbsize !=  0 &&
-	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
-	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
-	     !is_power_of_2(mp->m_logbsize))) {
-		xfs_warn(mp,
-			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
-			mp->m_logbsize);
-		return -EINVAL;
-	}
-
-	if (ctx->iosizelog) {
-		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
-		    ctx->iosizelog < XFS_MIN_IO_LOG) {
-			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-				ctx->iosizelog, XFS_MIN_IO_LOG,
-				XFS_MAX_IO_LOG);
-			return -EINVAL;
-		}
-
-		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_readio_log = ctx->iosizelog;
-		mp->m_writeio_log = ctx->iosizelog;
-	}
-
-	return 0;
+	return ret;
 }
 
 struct proc_xfs_info {

