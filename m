Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980F7C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiL3WzA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiL3Wy7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:54:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270E91AA17;
        Fri, 30 Dec 2022 14:54:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8DC061AC4;
        Fri, 30 Dec 2022 22:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2174BC433D2;
        Fri, 30 Dec 2022 22:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440898;
        bh=nKnqdkRnRBI8Qh+Yd6TUhrIjepqFiqtDJUSDh2W3KBc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N2xTgL3rvFTtToiGdgnJ/UsVKGKogkz9dgFmOOmkatwwKCMMFL9RtmiIhkBPkC+Vi
         tfJpa6LQdPE09tCMa1vP2FwN5sDY6y2+G0hOALR7GLTW0igYHdy/UrjPWzoegO7Ai/
         WR3iMnSzuEMxoVo9FU4cYxzZSn581WCwb8GZUFa3BB0f3FZhI9olpBFLAIFIBc4+Is
         o1fZ9W/mh5490a/1bQ6qtSGYqndgxJvdFENa1dPjDF7ey3Cww+FnPfbu2pP9WpuY4C
         Pu56ZcNMHqjNRzXJ3yAF2IRsV51qM+a+wTKs1GcCFhpKdI5nl8cqAIVkBrQkafRoAw
         n1ZPuLmRNBMpQ==
Subject: [PATCH 03/16] xfs/422: rework feature detection so we only
 test-format scratch once
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837339.694541.16731359558761133108.stgit@magnolia>
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

Rework the feature detection in the one online fsck stress test so that
we only format the scratch device twice per test run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/422 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/422 b/tests/xfs/422
index 0bf08572f3..b3353d2202 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -25,11 +25,12 @@ _register_cleanup "_cleanup" BUS
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_scratch_rmapbt
+_require_scratch
 _require_xfs_stress_online_repair
 
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
 _scratch_xfs_stress_online_repair
 
 # success, all done

