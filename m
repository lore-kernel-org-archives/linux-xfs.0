Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D39C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B43F264D9D
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhBMFsT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:48:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhBMFsS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:48:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C50364E9D;
        Sat, 13 Feb 2021 05:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613195251;
        bh=BxvOtBu3s4NGGg0KSeTA17OYiBE+m793npTh3O45m10=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FIRnHE/SqN26N0KxRLL0ietFo0U8j+WtnxNvQWYwRRyJ3XMKvzepgd5O9L+oDCGDS
         7x0GV8PprY+dDsf4gyI3KJXTwkfrk8W2k1GZLyKdRX3MjntrJqd/GAgNQZTwXU6XLs
         R5uXoawPZ2YJk/gniKdYRWtXfFUvH7ZIyjwBg+g6XR5iojvs4Jg/jX5TYqCj3pDPU4
         UIJxtozoVbHMEwXsmLwC3gJHAXCXNDefgV+7+lFcuSG6J0W0gd3moavYvzfhNqJNgr
         9btKQqctzPGhNHtICLPE6+l+9PKn3MRse+efqqfze0jscp0jawCgOnv/dQPxW4KfXJ
         kA0XF2TNK14og==
Subject: [PATCH 5/5] xfs_repair: enable bigtime upgrade via repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Fri, 12 Feb 2021 21:47:31 -0800
Message-ID: <161319525117.423010.6467565288868099323.stgit@magnolia>
In-Reply-To: <161319522350.423010.5768275226481994478.stgit@magnolia>
References: <161319522350.423010.5768275226481994478.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Upgrade existing V5 filesystems to support large timestamps up to 2486.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 man/man8/xfs_admin.8 |    6 ++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   23 +++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 42 insertions(+)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 4ba718d8..25437ff1 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -145,6 +145,12 @@ This reduces mount time by speeding up metadata space reservation calculations.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be writable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B bigtime
+Upgrade a filesystem to support larger timestamps up to the year 2486.
+The filesystem cannot be downgraded after this feature is enabled.
+Once enabled, the filesystem will not be mountable by older kernels.
+This feature was added to Linux 5.10.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index 47d90bd3..506a4e72 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -49,6 +49,7 @@ int	rt_spec;		/* Realtime dev specified as option */
 int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
+bool	add_bigtime;		/* add support for timestamps up to 2486 */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 5b6fe4d4..929b82be 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -90,6 +90,7 @@ extern int	rt_spec;		/* Realtime dev specified as option */
 extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
+extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 96074a1d..cb9adf1d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -158,6 +158,27 @@ set_inobtcount(
 	return true;
 }
 
+static bool
+set_bigtime(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		printf(
+	_("Large timestamp feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		printf(_("Filesystem already supports large timestamps.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding large timestamp support to filesystem.\n"));
+	mp->m_sb.sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+					  XFS_SB_FEAT_INCOMPAT_BIGTIME);
+	return true;
+}
+
 /* Perform the user's requested upgrades on filesystem. */
 static void
 upgrade_filesystem(
@@ -169,6 +190,8 @@ upgrade_filesystem(
 
 	if (add_inobtcount)
 		dirty |= set_inobtcount(mp);
+	if (add_bigtime)
+		dirty |= set_bigtime(mp);
 
         if (no_modify || !dirty)
                 return;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2d9dca6b..e6c29dca 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -66,12 +66,14 @@ static char *o_opts[] = {
 enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_INOBTCOUNT,
+	CONVERT_BIGTIME,
 	C_MAX_OPTS,
 };
 
 static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
+	[CONVERT_BIGTIME]	= "bigtime",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -313,6 +315,15 @@ process_args(int argc, char **argv)
 		_("-c inobtcount only supports upgrades\n"));
 					add_inobtcount = true;
 					break;
+				case CONVERT_BIGTIME:
+					if (!val)
+						do_abort(
+		_("-c bigtime requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c bigtime only supports upgrades\n"));
+					add_bigtime = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

