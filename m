Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A354C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5315564D9D
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhBMFsH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:48:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhBMFsG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:48:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31E164E68;
        Sat, 13 Feb 2021 05:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613195235;
        bh=UA8/ii9uQrgYeWSnepEVu0MxU4ibDoot2yHuZ3RMjpg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FwUId7uYtgAgdWgrIZZ6K5JYMkxwQc0Zp34jAOa2MvY1uAqOwqrVy4X1xNo2Mac7j
         HYX0qKQIfpZ0CcG+mthuB/EZxmdgjKQAuzHkJtrb/5BWPdwTFmTT23mmRIiLFfGskG
         YDM9WjCPViqVwNfSS/4/XcVKJr7ISambIFr9F9+R/3n3EJJfbuxZ+xZW1ENryJLJIR
         SBRdhtx7YqF56p6y/mV/9gkkEB3+3LRLpdixWOyFo7LzY9JOXRtqs/PdLw5qKJYHrd
         X547PDnMim2RdM3zRisEBOf/53IogaLuSNayWFXCaTMgKhCCLUKsWXR7xqJG2uCMJZ
         8FaGYw79uaTLw==
Subject: [PATCH 2/5] xfs_repair: allow upgrades to v5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Fri, 12 Feb 2021 21:47:14 -0800
Message-ID: <161319523460.423010.11387475504369174814.stgit@magnolia>
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

Add some helper functions so that we can allow users to upgrade V5
filesystems in a sane manner.  This just lands the boilerplate; the
actual feature validation and whatnot will land in the next patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase2.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/repair/phase2.c b/repair/phase2.c
index 952ac4a5..f654edcc 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -131,6 +131,40 @@ zero_log(
 		libxfs_max_lsn = log->l_last_sync_lsn;
 }
 
+/* Perform the user's requested upgrades on filesystem. */
+static void
+upgrade_filesystem(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	bool			dirty = false;
+	int			error;
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
@@ -235,4 +269,10 @@ phase2(
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

