Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD572C46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiLaDPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:15:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8410E59;
        Fri, 30 Dec 2022 19:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61003B81E60;
        Sat, 31 Dec 2022 03:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071C4C433D2;
        Sat, 31 Dec 2022 03:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456526;
        bh=xTDvJic8WQgW07M1nEUgrHYZnIa7Tf3uGM2UZ+KowIA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DwWs2+FACvU9Bqwod/TqpkCcO6Nh6HYBPiyVqGo1qrRt/1T37PjDKIMzNlirE2tSl
         wyibS5kZGB4Kh9YbeFY4RrPUH7qhVBzogD+oYOpyv+CXbS5UD/5Dy1QIa+lrK0ucfr
         VQy6AAccr9W3D9DtbzRRkfvE/vIDoqez7BrD6cAQZCtjc/fBzeRiHBmCfv1idkYn+1
         +t0ZnAcH022CbrUY1ZUCHKi5bC2LlMK/oLJ6+RYSCUyKUxO4Axo7NGi/0lp+aRZ3s/
         TU78nkD8TZmV6NsaRwIOmvJd/wP+1fGcRjYUGrledJVZ94h9DhuhN2j29aop1sicBU
         zWORdAfEZmTWA==
Subject: [PATCH 11/13] populate: adjust rtrmap calculations for rtgroups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:45 -0800
Message-ID: <167243884538.739669.9670755376084255895.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've sharded the realtime volume and created per-group rmap
btrees, we need to adjust downward the size of rtrmapbt records since
the block counts are now 32-bit instead of 64-bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index c0bbbc3f3b..7d57cd1287 100644
--- a/common/populate
+++ b/common/populate
@@ -379,7 +379,7 @@ _scratch_xfs_populate() {
 	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
-		nr="$((blksz * 2 / 32))"
+		nr="$((blksz * 2 / 24))"
 		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTRMAPBT"
 		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RTRMAPBT"
 	fi

