Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DBEC7EE21
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 20:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjEBUIz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 16:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjEBUIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 16:08:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4C11996;
        Tue,  2 May 2023 13:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0588862875;
        Tue,  2 May 2023 20:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6253FC433EF;
        Tue,  2 May 2023 20:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683058126;
        bh=oVRXWiLdEf14cDzoRaG1mJlFz3704oMb3yF8lHI6iMI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aBZVZeRcUOKDn3l1WkwqITFWS7gJiZJN28YV7bFDfF7K1pPJggcXdhzdLnyrVsJ3U
         bs7nWAd2ovgLInKKzIfH6n5eDQg7lI7Hw9S3FnMZhU/ethNlQAAdlR9RDaJPD1UuUy
         z8Y9DAr45lcYEZFEI7dUhmeqwZa2iDHo1/CskW0k7/IdjA+YUKcSzX2NIk8ndnto56
         1+ovvqUhQJfHFkWE0p6yryNMGmyNmd1r5WMHdTPk7glgLBWqM+lc+EIftO8DgiMA/J
         rJyaKhaoy13KaN0ST1bYl8V8CiV5o4LLTE8CwI9gxkilKfs6RoSOLaoAIqq2sQd5dM
         kOAI44q8I6Cjg==
Subject: [PATCH 7/7] generic/{094,225}: drop the file allocation unit
 requirements
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 May 2023 13:08:45 -0700
Message-ID: <168305812593.331137.15186959270369278061.stgit@frogsfrogsfrogs>
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

Drop these two test precondition requirements now that we've fixed
fiemap-tester to handle unwritten preallocations that are mapped to
unwritten parts of files and/or mapped beyond EOF.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/094 |    5 -----
 tests/generic/225 |    5 -----
 2 files changed, 10 deletions(-)


diff --git a/tests/generic/094 b/tests/generic/094
index 5c12b7310a..0d9ce8b6ee 100755
--- a/tests/generic/094
+++ b/tests/generic/094
@@ -26,11 +26,6 @@ fiemapfile=$SCRATCH_MNT/$seq.fiemap
 
 _require_test_program "fiemap-tester"
 
-# FIEMAP test doesn't like finding unwritten blocks after it punches out
-# a partial rt extent.
-test "$FSTYP" = "xfs" && \
-	_require_file_block_size_equals_fs_block_size $SCRATCH_MNT
-
 seed=`date +%s`
 
 echo "using seed $seed" >> $seqres.full
diff --git a/tests/generic/225 b/tests/generic/225
index d96382996e..a996889ecf 100755
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -26,11 +26,6 @@ fiemaplog=$SCRATCH_MNT/$seq.log
 
 _require_test_program "fiemap-tester"
 
-# FIEMAP test doesn't like finding unwritten blocks after it punches out
-# a partial rt extent.
-test "$FSTYP" = "xfs" && \
-	_require_file_block_size_equals_fs_block_size $SCRATCH_MNT
-
 seed=`date +%s`
 
 echo "using seed $seed" >> $fiemaplog

