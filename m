Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A62C77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 15:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbjFFPLj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 11:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237938AbjFFPLg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 11:11:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C4FE42
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 08:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52966628F8
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 15:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38167C433D2
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686064286;
        bh=9PIugdN69Z0V9GNvDNGQL9q1UHnHj4ENfQYkE/igOPM=;
        h=From:To:Subject:Date:From;
        b=VCQ5DfzQStJlNTb7vpH9TpmDw/Ha7j3UlGxk9BpecSmfxcb1mdZX2O5oFO6hurpe/
         kr6x05/6/nRJUKXiDHFFQnrrSopU/tARX7dCYj5S+zh2VOXlg1vjkH1xGUNNNFJwnw
         akX/zb04Gj+/uR24vXqedZvSKWoqU/hC4QdcfcSSJKumShZ3ftjAgHUX5kTq1sEpyO
         4V0JpgmsGHXku8Gogk71ty8nrElRiqEekQEj4D39vCuFewHcb6m3kPBIrFhAn1kMxL
         lECoyhpN+vrB6G+ZzBzZLl/n5AhhOf38DLhpe9YEgxJVB/3hW6CEciH/CneliC0BeV
         qw18M2q2dHyww==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2] xfs: Comment out unreachable code within xchk_fscounters()
Date:   Tue,  6 Jun 2023 17:11:22 +0200
Message-Id: <20230606151122.853315-1-cem@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cem@kernel.org>

Comment the code out so kernel test robot stop complaining about it
every single test build.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/scrub/fscounters.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index e382a35e98d88..228efe0c99be8 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -153,6 +153,7 @@ xchk_setup_fscounters(
 	return xchk_trans_alloc(sc, 0);
 }
 
+#if 0
 /*
  * Part 1: Collecting filesystem summary counts.  For each AG, we add its
  * summary counts (total inodes, free inodes, free data blocks) to an incore
@@ -349,6 +350,7 @@ xchk_fscount_count_frextents(
 	return 0;
 }
 #endif /* CONFIG_XFS_RT */
+#endif
 
 /*
  * Part 2: Comparing filesystem summary counters.  All we have to do here is
@@ -422,7 +424,10 @@ xchk_fscounters(
 	struct xfs_mount	*mp = sc->mp;
 	struct xchk_fscounters	*fsc = sc->buf;
 	int64_t			icount, ifree, fdblocks, frextents;
+
+#if 0
 	int			error;
+#endif
 
 	/* Snapshot the percpu counters. */
 	icount = percpu_counter_sum(&mp->m_icount);
@@ -452,6 +457,7 @@ xchk_fscounters(
 	 */
 	return 0;
 
+#if 0
 	/*
 	 * If ifree exceeds icount by more than the minimum variance then
 	 * something's probably wrong with the counters.
@@ -489,4 +495,5 @@ xchk_fscounters(
 		xchk_set_corrupt(sc);
 
 	return 0;
+#endif
 }
-- 
2.30.2

