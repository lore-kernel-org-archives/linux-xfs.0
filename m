Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082EFC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiKICFj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKICFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14D054B21
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE1AB81619
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E2FC433D6;
        Wed,  9 Nov 2022 02:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959534;
        bh=lrsCZPyYu8DA2As+BPwQ51v3DXvqLawah3g0xqHfneA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZbHi0Fu7XAVdqUYcN1xuNEZGkWi8uhLAZgDwQ92rLOXy3AHC/LdLeIvQe7OdzHtEt
         LAbU/VyhajbLBJnRJXLh5Ma5kTJr3rtiMBrHQ0aR4++XF1ONVeSQIagixDjlHAdAw0
         NG51iTo7WNki6O/uZIDsmrVICGqJVmUlIK9pknbb7ywHWiMiDpJ9Nblsyn63B+O1k5
         6ZxT+Ks2ky1ls3q+oI3aPAxkaZ54kWEA8LxBGr88Q9O2XOd9+yq83ec9CQU78UCyZa
         8fUSKpbcOiqgPTPzBz8bDphAF6wlnIUK0VwiREmZeaLZuicpGZknf7k/SzcSUyWcUx
         ngTX0aG2iS9Ag==
Subject: [PATCH 6/7] xfs_repair: don't crash on unknown inode parents in dry
 run mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:33 -0800
Message-ID: <166795953371.3761353.14768550343479712207.stgit@magnolia>
In-Reply-To: <166795950005.3761353.14062544433865007925.stgit@magnolia>
References: <166795950005.3761353.14062544433865007925.stgit@magnolia>
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
index d8b23ba528..fefb9755f5 100644
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

