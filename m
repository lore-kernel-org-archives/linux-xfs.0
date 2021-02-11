Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5299C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85F4E64E44
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhBKXAe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:00:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhBKXAa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:00:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B73264E3E;
        Thu, 11 Feb 2021 22:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084387;
        bh=JIjujzwOwioXYa0QvpDSb1avGGS4+UIpCW9MhPrIK+U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aU66UZHDzeLZEQ+6E8qA/cL89EinJhCh3oZbCVtlNmZ2nVdbSn+KgJ2dfhTstoU3i
         DX3OKiaSFRChCtq7EKF5N4SNGu/cjp4D20Dwj/7sgK7lG097JG5d0cm6QjePlRtgVl
         5Mkmxe34WAE5hBkoBMgYDwQ/niCVQpFNOssTvy2SChASHdTImaAL/rug5sDUyCvBA+
         sQHO+6RYLxHakOSH8HoagcZEKMgLqB4hhggcIq7FjGGkr7aa9HXZ2ioOFQLjvZEtSN
         EqywluIPavrpCr2V6gyDWcceUfIgiDTdayX0qdPWqEz9+QJxjE02w/2/MvuQLj7zbu
         cmxfksvV1uxGA==
Subject: [PATCH 08/11] xfs_repair: allow setting the needsrepair flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:46 -0800
Message-ID: <161308438691.3850286.3501696811159590596.stgit@magnolia>
In-Reply-To: <161308434132.3850286.13801623440532587184.stgit@magnolia>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
program start and (presumably) clear it by the end of the run.  This
code isn't terribly useful to users; it's mainly here so that fstests
can exercise the functionality.  We don't document this flag in the
manual pages at all because repair clears needsrepair at exit, which
means the knobs only exist for fstests to exercise the functionality.

Note that we can't do any of these upgrades until we've at least done a
preliminary scan of the primary super and the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/globals.c    |    2 ++
 repair/globals.h    |    2 ++
 repair/phase2.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c |    9 +++++++
 4 files changed, 76 insertions(+)


diff --git a/repair/globals.c b/repair/globals.c
index 110d98b6..699a96ee 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -49,6 +49,8 @@ int	rt_spec;		/* Realtime dev specified as option */
 int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
 
+bool	add_needsrepair;	/* forcibly set needsrepair while repairing */
+
 /* misc status variables */
 
 int	primary_sb_modified;
diff --git a/repair/globals.h b/repair/globals.h
index 1d397b35..043b3e8e 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -90,6 +90,8 @@ extern int	rt_spec;		/* Realtime dev specified as option */
 extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
 
+extern bool	add_needsrepair;
+
 /* misc status variables */
 
 extern int		primary_sb_modified;
diff --git a/repair/phase2.c b/repair/phase2.c
index 952ac4a5..9a8d42e1 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -131,6 +131,63 @@ zero_log(
 		libxfs_max_lsn = log->l_last_sync_lsn;
 }
 
+static bool
+set_needsrepair(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		printf(
+	_("needsrepair flag only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
+		printf(_("Filesystem already marked as needing repair.\n"));
+		exit(0);
+	}
+
+	printf(_("Marking filesystem in need of repair.\n"));
+	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
+/* Perform the user's requested upgrades on filesystem. */
+static void
+upgrade_filesystem(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	bool			dirty = false;
+	int			error;
+
+	if (add_needsrepair)
+		dirty |= set_needsrepair(mp);
+
+        if (no_modify || !dirty)
+                return;
+
+        bp = libxfs_getsb(mp);
+        if (!bp || bp->b_error) {
+                do_error(
+	_("couldn't get superblock for feature upgrade, err=%d\n"),
+                                bp ? bp->b_error : ENOMEM);
+        } else {
+                libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+
+                /*
+		 * Write the primary super to disk immediately so that
+		 * needsrepair will be set if repair doesn't complete.
+		 */
+                error = -libxfs_bwrite(bp);
+                if (error)
+                        do_error(
+	_("filesystem feature upgrade failed, err=%d\n"),
+                                        error);
+        }
+        if (bp)
+                libxfs_buf_relse(bp);
+}
+
 /*
  * ok, at this point, the fs is mounted but the root inode may be
  * trashed and the ag headers haven't been checked.  So we have
@@ -235,4 +292,10 @@ phase2(
 				do_warn(_("would correct\n"));
 		}
 	}
+
+	/*
+	 * Upgrade the filesystem now that we've done a preliminary check of
+	 * the superblocks, the AGs, the log, and the metadata inodes.
+	 */
+	upgrade_filesystem(mp);
 }
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 90d1a95a..a613505f 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -65,11 +65,13 @@ static char *o_opts[] = {
  */
 enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
+	CONVERT_NEEDSREPAIR,
 	C_MAX_OPTS,
 };
 
 static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
+	[CONVERT_NEEDSREPAIR]	= "needsrepair",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -302,6 +304,13 @@ process_args(int argc, char **argv)
 					lazy_count = (int)strtol(val, NULL, 0);
 					convert_lazy_count = 1;
 					break;
+				case CONVERT_NEEDSREPAIR:
+					if (!val)
+						do_abort(
+		_("-c needsrepair requires a parameter\n"));
+					if (strtol(val, NULL, 0) == 1)
+						add_needsrepair = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

