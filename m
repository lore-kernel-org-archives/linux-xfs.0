Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CED0C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiL3Wyb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3Wya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:54:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC13A1AA0F;
        Fri, 30 Dec 2022 14:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65D03B81D96;
        Fri, 30 Dec 2022 22:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0788EC433EF;
        Fri, 30 Dec 2022 22:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440867;
        bh=sFuGD3n7++hEnqnDWvFcEcTz7jlN4CvVk+nuBM9fwsg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bF0DIAHN+Rd9LrCTPxCKPg1PMeXHKOYgBnSgkqB4M98QGA6110oVbFf7hDuEOQi6x
         q2bD/dws+eTaM+zSlXOY6t3rFfJQt2EmnV9AJ783hOw9HF5+AXbtZxtOjKfO3449Fm
         K+7mothgf08AiNQiN5dwwu1RmHkQOE8n61dkI/OEA4HXx+ZpWsXXMCETY0EnqXftYK
         MU6gFeTd/lr7hutMdYjoYKUfSnMjPjqdt4g2IpY+CZX9G6qC4zefEn4BIsdAKLGxw2
         kW1SHuhEKq4lI3wjLKxiiswNePaUMGxLtreSNZ96PVCk4+eElAsqHGwhNuAnpQ6dXv
         yfu5olOUwt5+A==
Subject: [PATCH 01/16] xfs/422: create a new test group for fsstress/repair
 racers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837315.694541.14915989006044275705.stgit@magnolia>
In-Reply-To: <167243837296.694541.13203497631389630964.stgit@magnolia>
References: <167243837296.694541.13203497631389630964.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new group for tests that race fsstress with online filesystem
repair, and add this to the dangerous_online_repair group too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 doc/group-names.txt |    1 +
 tests/xfs/422       |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 6cc9af7844..ac219e05b3 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -34,6 +34,7 @@ dangerous_bothrepair	fuzzers to evaluate xfs_scrub + xfs_repair repair
 dangerous_fuzzers	fuzzers that can crash your computer
 dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
 dangerous_online_repair	fuzzers to evaluate xfs_scrub online repair
+dangerous_fsstress_repair	race fsstress and xfs_scrub online repair
 dangerous_repair	fuzzers to evaluate xfs_repair offline repair
 dangerous_scrub		fuzzers to evaluate xfs_scrub checking
 data			data loss checkers
diff --git a/tests/xfs/422 b/tests/xfs/422
index f3c63e8d6a..9ed944ed63 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -9,7 +9,7 @@
 # activity, so we can't have userspace wandering in and thawing it.
 #
 . ./common/preamble
-_begin_fstest dangerous_scrub dangerous_online_repair freeze
+_begin_fstest online_repair dangerous_fsstress_repair freeze
 
 _register_cleanup "_cleanup" BUS
 

