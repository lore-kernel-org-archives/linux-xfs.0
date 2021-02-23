Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9137BC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F8F764E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhBWDCV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhBWDCE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:02:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77B4F64E57;
        Tue, 23 Feb 2021 03:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049308;
        bh=+lV2hryLDyVw4bc0VOaihukklk7oaOv65zkAQzK+TpA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sf8xJDc/b8pLp4tD24qpqyHnXgIL0not8QOrHbA8n/2lzzbPULiQSgzj0K9b1YZLU
         CTCFY+cz2ZXg3qTK5fRI81y56f1B/t4NOdt5nntGbWnoSUoorOqLeVUP5LxzSjhusM
         H5lLeBt61hNq42zLsKZsUFUb1R87OmMYHvjO29uhrwihnwqKnYppspy4Z75Z+GESIj
         PmB2BsKQl5v2G2qSSEP8f6a1nRv0bAoAPEJ5hBC5fxxsHLraMJbKGLQF8Q8HODg+tF
         2xPgfIlQEeBHT24n0B7ellEA7LCp5eXzwMkBfD9SbgLdeUi2y37rHCTwZvIFavagcV
         jcMK9MB+Uugzg==
Subject: [PATCH 4/5] xfs_repair: enable inobtcount upgrade via repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:48 -0800
Message-ID: <161404930804.425731.4363462062346246125.stgit@magnolia>
In-Reply-To: <161404928523.425731.7157248967184496592.stgit@magnolia>
References: <161404928523.425731.7157248967184496592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use xfs_repair to add the inode btree counter feature to a filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 man/man8/xfs_admin.8 |   11 ++++++++++-
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   30 ++++++++++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 53 insertions(+), 1 deletion(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index ae661648..4ba718d8 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -136,7 +136,16 @@ without the
 .BR -n )
 must be followed to clean the filesystem.
 .IP
-There are no feature options currently.
+Supported features are as follows:
+.RS 0.7i
+.TP 0.4i
+.B inobtcount
+Keep a count the number of blocks in each inode btree in the AGI.
+This reduces mount time by speeding up metadata space reservation calculations.
+The filesystem cannot be downgraded after this feature is enabled.
+Once enabled, the filesystem will not be writable by older kernels.
+This feature was added to Linux 5.10.
+.RE
 .TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to
diff --git a/repair/globals.c b/repair/globals.c
index 537d068b..47d90bd3 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -48,6 +48,7 @@ char	*rt_name;		/* Name of realtime device */
 int	rt_spec;		/* Realtime dev specified as option */
 int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
+bool	add_inobtcount;		/* add inode btree counts to AGI */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index a9287320..5b6fe4d4 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -89,6 +89,7 @@ extern char	*rt_name;		/* Name of realtime device */
 extern int	rt_spec;		/* Realtime dev specified as option */
 extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
+extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index f654edcc..96074a1d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -131,6 +131,33 @@ zero_log(
 		libxfs_max_lsn = log->l_last_sync_lsn;
 }
 
+static bool
+set_inobtcount(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		printf(
+	_("Inode btree count feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		printf(
+	_("Inode btree count feature requires free inode btree.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		printf(_("Filesystem already has inode btree counts.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding inode btree counts to filesystem.\n"));
+	mp->m_sb.sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 /* Perform the user's requested upgrades on filesystem. */
 static void
 upgrade_filesystem(
@@ -140,6 +167,9 @@ upgrade_filesystem(
 	bool			dirty = false;
 	int			error;
 
+	if (add_inobtcount)
+		dirty |= set_inobtcount(mp);
+
         if (no_modify || !dirty)
                 return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 64d7607f..8a9caf15 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -65,11 +65,13 @@ static char *o_opts[] = {
  */
 enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
+	CONVERT_INOBTCOUNT,
 	C_MAX_OPTS,
 };
 
 static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
+	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -302,6 +304,15 @@ process_args(int argc, char **argv)
 					lazy_count = (int)strtol(val, NULL, 0);
 					convert_lazy_count = 1;
 					break;
+				case CONVERT_INOBTCOUNT:
+					if (!val)
+						do_abort(
+		_("-c inobtcount requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c inobtcount only supports upgrades\n"));
+					add_inobtcount = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

