Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04276C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 01:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiGMBJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 21:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiGMBJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 21:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36660C9130
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 18:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C583E618C9
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 01:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E205C3411E;
        Wed, 13 Jul 2022 01:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657674583;
        bh=zHgt8M39DaBHfbVsCo9H4gFPg6hQaSk5pclu/PWwmeQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JrVfEAVyMJ+jyUNK3O3B3NNtAA40GsClMYKmv4pgXri9R6y2R4sUwAs3edNQbE1dq
         qBdVvq9VRHRI68y+mcDP8al2l4ZB4n5UzTPBVNmA1UCXo7MUMxFNeo0JgMp203OnJL
         JFf+82zZy8+JINApoBRnSl0v1cgnGZj0AOz7tx1eReFHGXM+EqSmIP1ugNMbgNyIr/
         An+ow7rQyl5PFWldlQ9gpzSvvipAGyDevz87hJxUlejaCSLq8gonS4tLg/GTHMmBHN
         GTmjQSOpg7feDrhOEEBhsZ5kpoq4Vfh5oIguHFhWv7OXpS+3bJHyKQT8Ab+hn3NYIg
         9yyDp/IlQmbyA==
Subject: [PATCH 1/4] xfs_repair: ignore empty xattr leaf blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 Jul 2022 18:09:42 -0700
Message-ID: <165767458269.891854.14449036597530410382.stgit@magnolia>
In-Reply-To: <165767457703.891854.2108521135190969641.stgit@magnolia>
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As detailed in the previous commit, empty xattr leaf blocks can be the
benign byproduct of the system going down during the multi-step process
of adding a large xattr to a file that has no xattrs.  If we find one at
attr fork offset 0, we should clear it, but this isn't a corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/attr_repair.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 2055d96e..c3a6d502 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -579,6 +579,26 @@ process_leaf_attr_block(
 	firstb = mp->m_sb.sb_blocksize;
 	stop = xfs_attr3_leaf_hdr_size(leaf);
 
+	/*
+	 * Empty leaf blocks at offset zero can occur as a race between
+	 * setxattr and the system going down, so we only take action if we're
+	 * running in modify mode.  See xfs_attr3_leaf_verify for details of
+	 * how we've screwed this up many times.
+	 */
+	if (!leafhdr.count && da_bno == 0) {
+		if (no_modify) {
+			do_log(
+	_("would clear empty leaf attr block 0, inode %" PRIu64 "\n"),
+					ino);
+			return 0;
+		}
+
+		do_warn(
+	_("will clear empty leaf attr block 0, inode %" PRIu64 "\n"),
+				ino);
+		return 1;
+	}
+
 	/* does the count look sorta valid? */
 	if (!leafhdr.count ||
 	    leafhdr.count * sizeof(xfs_attr_leaf_entry_t) + stop >

