Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FEDC43331
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9257E64EC3
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhBIERr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhBIEO5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:14:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D61B64EC9;
        Tue,  9 Feb 2021 04:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843874;
        bh=zMbn7XOkMktKuXzrMJ/e/WoGZx6IuhPx3/3wvAs8kSk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VDKoMWQO4vxXV2gSk8cTTNf3xdM8bfpiX0nxrArG1RqJDlIuTAqADjkF/CM2lcT3x
         gqQ6YOCZKEv9JGZgsz5svulw2yIkaOEz4g273fvUxkHApzA1jOUdXyA8WOV4B84w0W
         4XiwjzOUlhSWEihDJt3EdAHhIw0MzB56d95pa11HNbXL0/LTLVBtuzCzqasZjnXkvd
         7JmhA3rOFEeyvBLVnqRM4FsOBvFKkbIbv81Z6O9e6/b1UwRyHGK+6X7wqNBKyVtrwM
         j4UJtTkE4AbtYBvCZ9obnloAiLbkGRbMhqo+H/Wc/7kREx2AmkDHLqk6psaIhSpNhE
         FVvW1a1DtXp1g==
Subject: [PATCH 2/2] xfs_repair: enable bigtime upgrade via repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:11:14 -0800
Message-ID: <161284387398.3058138.5317754248430984165.stgit@magnolia>
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

Upgrade existing V5 filesystems to support large timestamps up to 2486.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    6 ++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase1.c      |   23 +++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 42 insertions(+)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index da05171d..13d71643 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -135,6 +135,12 @@ This reduces mount time by speeding up metadata space reservation calculations.
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
index 89063b10..28f0b6a0 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -52,6 +52,7 @@ int	lazy_count;		/* What to set if to if converting */
 
 bool	add_needsrepair;	/* forcibly set needsrepair while repairing */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
+bool	add_bigtime;		/* add support for timestamps up to 2486 */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index a0051794..be784cf6 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -94,6 +94,7 @@ extern int	lazy_count;		/* What to set if to if converting */
 
 extern bool	add_needsrepair;
 extern bool	add_inobtcount;
+extern bool	add_bigtime;
 
 /* misc status variables */
 
diff --git a/repair/phase1.c b/repair/phase1.c
index 96661c6b..89056215 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -77,6 +77,27 @@ set_inobtcount(
 	sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 }
 
+static void
+set_bigtime(
+	struct xfs_sb	*sb)
+{
+	if (!xfs_sb_version_hascrc(sb)) {
+		printf(
+	_("Large timestamp feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasbigtime(sb)) {
+		printf(_("Filesystem already supports large timestamps.\n"));
+		return;
+	}
+
+	printf(_("Adding large timestamp support to filesystem.\n"));
+	primary_sb_modified = 1;
+	sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+				     XFS_SB_FEAT_INCOMPAT_BIGTIME);
+}
+
 /*
  * this has got to be big enough to hold 4 sectors
  */
@@ -177,6 +198,8 @@ _("Cannot disable lazy-counters on V5 fs\n"));
 		set_needsrepair(sb);
 	if (add_inobtcount)
 		set_inobtcount(sb);
+	if (add_bigtime)
+		set_bigtime(sb);
 
 	/* shared_vn should be zero */
 	if (sb->sb_shared_vn) {
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 0ff2e2bc..60f97e8c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -69,6 +69,7 @@ enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_NEEDSREPAIR,
 	CONVERT_INOBTCOUNT,
+	CONVERT_BIGTIME,
 	C_MAX_OPTS,
 };
 
@@ -76,6 +77,7 @@ static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_NEEDSREPAIR]	= "needsrepair",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
+	[CONVERT_BIGTIME]	= "bigtime",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -327,6 +329,15 @@ process_args(int argc, char **argv)
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

