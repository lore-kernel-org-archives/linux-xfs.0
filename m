Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32970C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jun 2022 22:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiFZWGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 18:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiFZWF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 18:05:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10F92DC6
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 15:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C3EDB80DFB
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 22:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25477C34114;
        Sun, 26 Jun 2022 22:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656281156;
        bh=Lh6ppA6e/Y9V9E/qssJFfgoD/oIRcThmU9kTDK30ZzQ=;
        h=Date:From:To:Subject:From;
        b=CNIXdMOZUzA9Pw70lI41xYTtST6wNL+sh4I6GccmDSKX9ZD2y7B/AdC+bMpIKlZaw
         A5L73ilWqwlVN6Tm6Pvu2OSt0/t4cJ+cHhEz1OdPXjb8BWbukXNIFyIuwJySeuyZ6C
         YEUw63hPMhRkezR7L/qFA9j5Skvtr605kTwKEi1JbXfo15DPTmsSe++kVpoyQffQNH
         HfPGdSN8BCIoM/eKH3hBC6b5FllBuaLkJc/xn8WVJflojYTeJtAOnfGTTV82zYUotu
         G+im0Kh/NIefgdCviEFMjuLR1dQnSLtEbGZGnnjyMifFb6DJfTfHkecptsmMtDi/DW
         lEyLvIK3DCOKw==
Date:   Sun, 26 Jun 2022 15:05:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Subject: [PATCH] xfs_repair: ignore empty xattr leaf blocks
Message-ID: <YrjYQ/+DYJIwf7MG@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
