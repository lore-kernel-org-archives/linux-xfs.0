Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040F2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbiLaDCE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiLaDCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:02:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71E415816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:01:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F8A9B81E84
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FC4C433EF;
        Sat, 31 Dec 2022 03:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455717;
        bh=OhtwXhKzjsofPRdJgW3eu4tl/CKoNg05ZAtaGWyW4BQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tqrMRY6ani36AyIU/K3pRPBaAxUHwD0B0Iu8+HOrWFJXFt2gGfsNSy+S1PfanDR3s
         Usv8oWnyw31vvhAKZkUyc1q/lHtLkm5AfkQuZb5fBPFok8nxBhkOg+4dmAolbHNUX7
         /TFQri8P21HohcJZYzyXwsPOsBV7njm3JddIIPGUQ18hRhOEcfPw0vTlUjBVFus8D3
         AjrNucmfp+m9UuIhqqX05fTiJfXuzLyROwsnCKZhLfMnpU4jQnuB38V1TD7pkYKMwQ
         qEId2XKd97p+TXhMHPgsY+6Kdruij8odVOSrX/FD6hBSbRf8Axzi2SJFjb35lPCZlK
         8uM5aXL6P4svA==
Subject: [PATCH 30/41] xfs_repair: allow CoW staging extents in the realtime
 rmap records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:11 -0800
Message-ID: <167243881167.734096.1646293887437450697.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't flag the rt rmap btree as having errors if there are CoW staging
extent records in it and the filesystem supports.  As far as reporting
leftover staging extents, we'll report them when we scan the rt refcount
btree, in a future patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 0ff8afccedc..c9209ebc3d7 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1414,9 +1414,20 @@ _("invalid length %llu in record %u of %s\n"),
 			continue;
 		}
 
-		/* We only store file data and superblocks in the rtrmap. */
-		if (XFS_RMAP_NON_INODE_OWNER(owner) &&
-		    owner != XFS_RMAP_OWN_FS) {
+		/*
+		 * We only store file data, COW data, and superblocks in the
+		 * rtrmap.
+		 */
+		if (owner == XFS_RMAP_OWN_COW) {
+			if (!xfs_has_reflink(mp)) {
+				do_warn(
+_("invalid CoW staging extent in record %u of %s\n"),
+						i, name);
+				suspect++;
+				continue;
+			}
+		} else if (XFS_RMAP_NON_INODE_OWNER(owner) &&
+			   owner != XFS_RMAP_OWN_FS) {
 			do_warn(
 _("invalid owner %lld in record %u of %s\n"),
 				(long long int)owner, i, name);

