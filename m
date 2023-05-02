Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BC2C77B78
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 20:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjEBUI3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 16:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjEBUI2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 16:08:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A547A210C;
        Tue,  2 May 2023 13:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 317BE62878;
        Tue,  2 May 2023 20:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C11C4339B;
        Tue,  2 May 2023 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683058103;
        bh=6+md2K/UJnbMGna7CHfnm9w7lC5HIsKO+Q8dM96V6w8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Om8NNCL9ZsIUlr+hUWxVUrNSFhkNAmZU8Mk6odGweovgfLxlMYfiIcFOZwWN82Xzd
         zeUoDixrQfOp0+N8kyq/sAeBXr5wIniNCALg/xgvZGUcCqatdy1xeJXLXYDBTZb5/0
         xoZFeCYker1P7iSWzDqBIfFd2MamIWcOvr7EPwYnT1IR9wXaRVoVeKw5RfZHjs71II
         PkYkGtL25oNyJddHfRDeuddrwDrmJwIkB8iia7RFj8RTUSDcepmJ1D2pYhk7ThOpp7
         1pbcGawXs7bSEZ+RbtJvwmy7P4YK7PulJZWtbhC/OWmtKCIxt39846epAG0VZ53VWj
         /pgfG3ipIBd8w==
Subject: [PATCH 3/7] generic/724,xfs/791: adjust test preconditions for
 post-EOF stripe zeroing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 May 2023 13:08:23 -0700
Message-ID: <168305810303.331137.12116775179614442990.stgit@frogsfrogsfrogs>
In-Reply-To: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
References: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I recently introduced a new fstests config with explicitly specified
stripe geometry of 128k stripe units and a stripe width of 4.  This
broke both of these tests because I hadn't counted on a few things:

1) The write to $SCRATCH_MNT/b at 768k would a 128k delalloc extent
2) This delalloc extent would extend beyond EOF
3) Increasing the file size from 832k to 1m would cause iomap to zero
   the pagecache for the parts of the delalloc extent beyond EOF
4) The newly dirtied posteof delalloc areas would get written to disk
   with a real space allocation

Under these circumstances, FIEXCHRANGE with SKIP_FILE1_HOLES sees a
written extent containing zeroes in file B between 832k and 1m.  File
A has a written extent containing 'X' in the same range, so it exchanges
the two.  When RAID geometry is disabled, the area between 832k and 1m
is usually a hole, so FIEXCHRANGE does nothing.  This causes the md5sum
of the two files to be different, and the test fails.

Fix the test by truncating B to 1m before writing anything to it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/724 |    2 +-
 tests/xfs/791     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/724 b/tests/generic/724
index 90cff8cf31..8d7dc4e12a 100755
--- a/tests/generic/724
+++ b/tests/generic/724
@@ -33,9 +33,9 @@ _require_congruent_file_oplen $SCRATCH_MNT 65536
 _pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
 
 # Create the donor file
+$XFS_IO_PROG -f -c 'truncate 1m' $SCRATCH_MNT/b
 _pwrite_byte 0x59 64k 64k $SCRATCH_MNT/b >> $seqres.full
 _pwrite_byte 0x57 768k 64k $SCRATCH_MNT/b >> $seqres.full
-$XFS_IO_PROG -c 'truncate 1m' $SCRATCH_MNT/b
 
 md5sum $SCRATCH_MNT/a | _filter_scratch
 md5sum $SCRATCH_MNT/b | _filter_scratch
diff --git a/tests/xfs/791 b/tests/xfs/791
index c89bc3531e..d82314ee08 100755
--- a/tests/xfs/791
+++ b/tests/xfs/791
@@ -37,9 +37,9 @@ _require_congruent_file_oplen $SCRATCH_MNT 65536
 _pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
 
 # Create the donor file
+$XFS_IO_PROG -f -c 'truncate 1m' $SCRATCH_MNT/b
 _pwrite_byte 0x59 64k 64k $SCRATCH_MNT/b >> $seqres.full
 _pwrite_byte 0x57 768k 64k $SCRATCH_MNT/b >> $seqres.full
-$XFS_IO_PROG -c 'truncate 1m' $SCRATCH_MNT/b
 sync
 
 md5sum $SCRATCH_MNT/a | _filter_scratch

