Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB9ACCA47E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiF1UtM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiF1UtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590B32FFC4
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06353B82013
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87E2C341C8;
        Tue, 28 Jun 2022 20:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449345;
        bh=zHgt8M39DaBHfbVsCo9H4gFPg6hQaSk5pclu/PWwmeQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lSRE9OwEaR70ZfW9H71S8gQ6G47KFpNEuL/jswlvuGR+mrVMEuVMBUYzJDc1RrJSj
         /GdaU1Xxott6F2FTEYByjXgD51InvIs1ivxb/KY5EBNkiLpCY5PjMoBm3c09j7CcBZ
         QZ6X5OnN2iJasMu0zXaCmfHiznaw+7WOm4bTZlcP6jq3NRWYowr3irBSmqIz6U23Uv
         6XMNCNQurnPG/QXaTk7I4jxDqlgYFPtfNzwyvNllbwBMMgYxBJanAwTuK4YmF5N07Y
         UZ49+zXo9GA6RFBaDMVOhq3snFXJfO8QltntphhjWR9Msh6G2toSIp7qyio2aKuUDB
         9PhXewjIUMYNA==
Subject: [PATCH 7/8] xfs_repair: ignore empty xattr leaf blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:05 -0700
Message-ID: <165644934532.1089724.4998920056841721528.stgit@magnolia>
In-Reply-To: <165644930619.1089724.12201433387040577983.stgit@magnolia>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
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

