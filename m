Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1A2C25B6B
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Oct 2023 03:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjJZDMG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 23:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjJZDMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 23:12:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7203BA3;
        Wed, 25 Oct 2023 20:12:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6890C433C8;
        Thu, 26 Oct 2023 03:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698289922;
        bh=DMKEiucjBrbAkBtbJr3/1/zCnWag9V9rQQLaak8nDKs=;
        h=Date:From:To:Cc:Subject:From;
        b=duZG+ZZJ/P+hmb5+Na0JO1MTlASYuUPgckDthEvOhQu+72WFGbQqN+S4KVeD90s2n
         ua9xY3X5Ettopeyl7rr7th1FZ0MSLuWj5tftTMfmwv8Iem4vCpIy0X3Dq5Y0k1EPzi
         NM25Nb1EP0x+mcUruy5MmGtgxt3OKPQQOwTPJMfuepsGxTWnDH9KOeV5/aCh05u59J
         UKqAew9v59Te8JcGj1SIL5Cauqi7O5G6m6elfQ7n0BMYN1IMZqb1Ak8Q/AvlHhM7dt
         2svECyO1WysDHnwMqw61HIUFB7uDtt8FrwTA1A/Hgv7QDm6SI7ZY8F+INnx1CQF0SO
         1XqqmXjxkIdMg==
Date:   Wed, 25 Oct 2023 20:12:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH 1/2] generic/251: don't snapshot $here during a test
Message-ID: <20231026031202.GM11391@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Zorro complained that the next patch caused him a regression:

generic/251 249s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/251.out.bad)
    --- tests/generic/251.out   2022-04-29 23:07:23.263498297 +0800
    +++ /root/git/xfstests/results//generic/251.out.bad 2023-10-22 14:17:07.248059405 +0800
    @@ -1,2 +1,5 @@
     QA output created by 251
     Running the test: done.
    +5838a5839
    +> aa60581221897d3d7dd60458e1cca2fa  ./results/generic/251.full
    +!!!Checksums has changed - Filesystem possibly corrupted!!!\n
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/251.out /root/git/xfstests/results//generic/251.out.bad'  to see the entire diff)
Ran: generic/251
Failures: generic/251
Failed 1 of 1 tests

The next patch writes some debugging information into $seqres.full,
which is a file underneat $RESULT_BASE.  If the test operator does not
set RESULT_BASE, it will be set to a subdir of $here by default.  Since
this test also snapshots the contents of $here before starting its loop,
any logging to $seqres.full on such a system will cause the post-copy
checksum to fail due to a mismatch.

Fix all this by copying $here to $SCRATCH_DEV and checksumming the copy
before the FITRIM stress test begins to avoid problems with $seqres.full.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/251 |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/generic/251 b/tests/generic/251
index 8ee74980cc..3b807df5fa 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -130,7 +130,13 @@ function run_process() {
 }
 
 nproc=20
-content=$here
+
+# Copy $here to the scratch fs and make coipes of the replica.  The fstests
+# output (and hence $seqres.full) could be in $here, so we need to snapshot
+# $here before computing file checksums.
+content=$SCRATCH_MNT/orig
+mkdir -p $content
+cp -axT $here/ $content/
 
 mkdir -p $tmp
 
