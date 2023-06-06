Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669CEC7EE43
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbjFFW3S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239869AbjFFW3Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A52171D;
        Tue,  6 Jun 2023 15:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FBA96381A;
        Tue,  6 Jun 2023 22:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AECC433D2;
        Tue,  6 Jun 2023 22:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686090554;
        bh=J54//45oxDA0G5I1o9ZC6LxEaaIFi1xBRoJ4ZcAlF9U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jrpvABJff7j5PAYTOPcLkR1dneiFQEOoiz5Vht1SWNhuu+IuQtfDIxtfKFkRhNY1Z
         3AoPc8fjXEPbPYKwf3v6hVOdI3a6KbhoJMh3fa1KSpC2AU3mEwYEKvTEWN6TFeqwsw
         +KFbB2u6YijqGZz3YyID2EAYHA7nF/BlhvIvA9Cue/MR8zlFLkKP0JBLFJaTByUZo8
         3vIezK2lEhKkzSolYjOJP6Su4O5zYg33VcCRYWS0VqAR2Pohej1goZNupuW+EMHZuM
         f9OKvkMLeHI95YaNSAasGd1kKX8y6OykbfOXa3vxPMGllhL1Q0v+llEBJSUW5PiJ3r
         OnCAAMfw8B1rQ==
Subject: [PATCH 2/3] xfs/155: discard stderr when checking for NEEDSREPAIR
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jun 2023 15:29:14 -0700
Message-ID: <168609055400.2590724.12890017891103418739.stgit@frogsfrogsfrogs>
In-Reply-To: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
References: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test deliberate crashes xfs_repair midway through writing metadata
to check that NEEDSREPAIR is always triggered by filesystem writes.
However, the subsequent scan for the NEEDSREPAIR feature bit prints
verifier errors to stderr.

On a filesystem with metadata directories, this leads to the test
failing with this recorded in the golden output:

+Metadata CRC error detected at 0x55c0a2dd0d38, xfs_dir3_block block 0xc0/0x1000
+dir block owner 0x82 doesnt match block 0xbb8cd37e44eb3623

This isn't specific to metadata directories -- any repair crash could
leave a metadata structure in a weird state such that starting xfs_db
will spray verifier errors.  For _check_scratch_xfs_features here, we
don't care if the filesystem is corrupt; we /only/ care that the
superblock feature bit is set.  Route all that noise to devnull.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/155 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/155 b/tests/xfs/155
index c4ee8e20ef..25cc84069c 100755
--- a/tests/xfs/155
+++ b/tests/xfs/155
@@ -55,7 +55,7 @@ for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
 	# but repair -n says the fs is clean, then it's possible that the
 	# injected error caused it to abort immediately after the write that
 	# cleared NEEDSREPAIR.
-	if ! _check_scratch_xfs_features NEEDSREPAIR > /dev/null &&
+	if ! _check_scratch_xfs_features NEEDSREPAIR &> /dev/null &&
 	   ! _scratch_xfs_repair -n &>> $seqres.full; then
 		echo "NEEDSREPAIR should be set on corrupt fs"
 	fi
@@ -63,7 +63,7 @@ done
 
 # If NEEDSREPAIR is still set on the filesystem, ensure that a full run
 # cleans everything up.
-if _check_scratch_xfs_features NEEDSREPAIR > /dev/null; then
+if _check_scratch_xfs_features NEEDSREPAIR &> /dev/null; then
 	echo "Clearing NEEDSREPAIR" >> $seqres.full
 	_scratch_xfs_repair 2>> $seqres.full
 	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \

