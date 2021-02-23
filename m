Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD8DC433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ADB864DF3
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBWDCW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhBWDCR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:02:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DA1864DF3;
        Tue, 23 Feb 2021 03:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049297;
        bh=yeiuzjpAXFgdL80GF15iQpaXcjaySaU80aUI0GCOf3k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WTPgeaqEtIjq2P2lohSNjNka2Paxy0STys1XYVI6rZU7ZDUeimqyLRRbbGE6p1ZmT
         eOwVxPYrdfmjdoKnsCY6wekjW86ofJvwFnSFKZtCESMOu+LDyMsf0jXqXRSnmPzLTG
         yQymemVhIOCLg93Fmf4VTmKU9KxJ8dmvDM82uWIpKuowY+JaFYKdgVX7s23eLT0qP+
         ihyhwhm1x7x6yeCcT8pbrk0oMSwROzhoahigc3y6TN5TWS/YtNQSSKFr2z8U5A2Ibb
         lkU/n4KDuDIDj053K6lYaCCMyB5ByR11ZYuwYzKRmPcfWMPwbx8uLTrfrkxzav+95p
         Xe7xGis2cJkuA==
Subject: [PATCH 2/5] xfs_repair: allow upgrades to v5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@lst.de, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:36 -0800
Message-ID: <161404929660.425731.17886982949516193444.stgit@magnolia>
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

Add some helper functions so that we can allow users to upgrade V5
filesystems in a sane manner.  This just lands the boilerplate; the
actual feature validation and whatnot will land in the next patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

