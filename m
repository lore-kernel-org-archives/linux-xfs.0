Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018CDC43217
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiKWRJz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238880AbiKWRJa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946D62BE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E0AF61DF7
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8585BC433D6;
        Wed, 23 Nov 2022 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223368;
        bh=YLBHViVo1lCSrGBAz2g/JBFs4xFcSEqvEJAYmdnpdH4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KdFIk0BopVJto/76M//TLDI1kjXBosQxyJKTKweBenEs3hHs6PUXKFFvZbHSy6GiV
         b4nRu61SN775G9YKM+xll1DWR5wPuPJbZSYcCuVogwBkk+Q69OR7kaIyoId+UOa3al
         aMF+apbl4ueYQz/E6K2oIyHL7iyUybr2WllDw4sQusbCblbpxfuytKlxU0yHKdiqZd
         WSKeqAKmiQ1drWeQmnxfbrNu0gom9mNZgYkc2mmdHvGnmjRJpMEr4xdxbdylk8vBpM
         xgIn4Hw39oEJOl93BdmW3gnPQ0g+aPkHZEDrAWEJEq/nKZLzRbiDhVeIRUIFR+eMSp
         7Jc+kX/ymyomg==
Subject: [PATCH 6/9] xfs_repair: don't crash on unknown inode parents in dry
 run mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:09:28 -0800
Message-ID: <166922336819.1572664.6577394686238048762.stgit@magnolia>
In-Reply-To: <166922333463.1572664.2330601679911464739.stgit@magnolia>
References: <166922333463.1572664.2330601679911464739.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fuzz testing of directory block headers exposed a debug assertion vector
in xfs_repair.  In normal (aka fixit) mode, if a single-block directory
has a totally trashed block, repair will zap the entire directory.
Phase 4 ignores any dirents pointing to the zapped directory, phase 6
ignores the freed directory, and everything is good.

However, in dry run mode, we don't actually free the inode.  Phase 4
still ignores any dirents pointing to the zapped directory, but phase 6
thinks the inode is still live and tries to walk it.  xfs_repair doesn't
know of any parents for the zapped directory and so trips the assertion.

The assertion is critical for fixit mode because we need all the parent
information to ensure consistency of the directory tree.  In dry run
mode we don't care, because we only have to print inconsistencies and
return 1.  Worse yet, (our) customers file bugs when xfs_repair crashes
during a -n scan, so this will generate support calls.

Make everyone's life easier by downgrading the assertion to a warning if
we're running in dry run mode.

Found by fuzzing bhdr.hdr.bno = zeroes in xfs/471.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 1f9f8dee46c..0be2c9c9705 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1836,7 +1836,14 @@ longform_dir2_entry_check_data(
 			continue;
 		}
 		parent = get_inode_parent(irec, ino_offset);
-		ASSERT(parent != 0);
+		if (parent == 0) {
+			if (no_modify)
+				do_warn(
+ _("unknown parent for inode %" PRIu64 "\n"),
+						inum);
+			else
+				ASSERT(parent != 0);
+		}
 		junkit = 0;
 		/*
 		 * bump up the link counts in parent and child

