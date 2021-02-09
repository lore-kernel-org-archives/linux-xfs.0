Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5423EC433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE8E64EB4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhBIERl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:17:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhBIEOM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:14:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B422864EC7;
        Tue,  9 Feb 2021 04:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843868;
        bh=/e2iKxYC4P1lueIUO6R71gz6ZY9iZ2vTmnUWwD6VAHs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o5bexsX7kVHHtIBJ8uybJv0Kk5FJUJRNyRqxQNGhCXLH9A6pduyUlOHMHHty7mpaE
         hhOHYplTFNVyt4y4F5HQau36SEDsNfKYweuHeLkQC7x2yAbqRBxO/ivctJ7Yg2p9yo
         XOmd8DRxy/nmSbJZ0UO/YKNtq6jF4x+3pgfImJ1m2YGhpH16RXWSDJi/UUA3c5pEb4
         HfQCO9To53W491X+mIQ6JOKc7DGHkHAEobGkDlqR4YA4fiwDKLiJPwG2o0iKVZuRoh
         cRduwfeBxwUlbHcVzh7FHROusMlcMQ+N9emSHdhEWsh1Jp6hNlZVHA8JyMLRLLTLbi
         hM5DlaHEQ+xow==
Subject: [PATCH 1/2] xfs_repair: enable inobtcount upgrade via repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:11:08 -0800
Message-ID: <161284386826.3058138.11503745885795466104.stgit@magnolia>
In-Reply-To: <161284386265.3058138.14199712814454514885.stgit@magnolia>
References: <161284386265.3058138.14199712814454514885.stgit@magnolia>
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
---
 man/man8/xfs_admin.8 |   11 ++++++++++-
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase1.c      |   29 +++++++++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 52 insertions(+), 1 deletion(-)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 3f3aeea8..da05171d 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -126,7 +126,16 @@ without the
 .BR -n )
 must be followed to clean the filesystem.
 .IP
-There are currently no feature options.
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
index b0e23864..89063b10 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -51,6 +51,7 @@ int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
 
 bool	add_needsrepair;	/* forcibly set needsrepair while repairing */
+bool	add_inobtcount;		/* add inode btree counts to AGI */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 9fa73b2c..a0051794 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -93,6 +93,7 @@ extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
 
 extern bool	add_needsrepair;
+extern bool	add_inobtcount;
 
 /* misc status variables */
 
diff --git a/repair/phase1.c b/repair/phase1.c
index 57f72cd0..96661c6b 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -50,6 +50,33 @@ set_needsrepair(
 	sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 }
 
+static void
+set_inobtcount(
+	struct xfs_sb	*sb)
+{
+	if (!xfs_sb_version_hascrc(sb)) {
+		printf(
+	_("Inode btree count feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (!xfs_sb_version_hasfinobt(sb)) {
+		printf(
+	_("Inode btree count feature requires free inode btree.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasinobtcounts(sb)) {
+		printf(_("Filesystem already has inode btree counts.\n"));
+		return;
+	}
+
+	printf(_("Adding inode btree counts to filesystem.\n"));
+	primary_sb_modified = 1;
+	sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+	sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+}
+
 /*
  * this has got to be big enough to hold 4 sectors
  */
@@ -148,6 +175,8 @@ _("Cannot disable lazy-counters on V5 fs\n"));
 
 	if (add_needsrepair)
 		set_needsrepair(sb);
+	if (add_inobtcount)
+		set_inobtcount(sb);
 
 	/* shared_vn should be zero */
 	if (sb->sb_shared_vn) {
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ae7106a6..0ff2e2bc 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -68,12 +68,14 @@ static char *o_opts[] = {
 enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_NEEDSREPAIR,
+	CONVERT_INOBTCOUNT,
 	C_MAX_OPTS,
 };
 
 static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_NEEDSREPAIR]	= "needsrepair",
+	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -316,6 +318,15 @@ process_args(int argc, char **argv)
 					if (strtol(val, NULL, 0) == 1)
 						add_needsrepair = true;
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

