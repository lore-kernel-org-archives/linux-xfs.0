Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B81C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 18:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244340AbiAXShi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 13:37:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42102 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiAXShh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 13:37:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 122A8614B3;
        Mon, 24 Jan 2022 18:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE18C340E7;
        Mon, 24 Jan 2022 18:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643049456;
        bh=Oa0i8Njr8V6kj4ggIql9WgpMHMk6R4+rHih3G59+AHc=;
        h=Date:From:To:Cc:Subject:From;
        b=nn44amhKC2Jqvtqaru/gUKp3qvppD2JiZkGr+nkOrA5iovagC/APltE5zh68qtdrP
         HuIrr34eLL9DzJGA8OdfoSGkiBq1y4bRntUklk2YJqaZdSIyxWqY5fPNTjbkWW0/B9
         Dy6jIslXK1CWG76JCrp2k/tCHLFvbJ8JmxLRAMZWAyq7f1Sh9wv+BVmU9Cg3XrddsV
         wZFg51YnmrV3TSPhQ/RTr+D+vCRe5Tgfkb0PVGK1HyIHvQDYJlNu0DMjXNrO8QJKhU
         tshQxUTXex0GSS2YRejEcFrII24W7MrLpTdiZafJ8AatSVNlP1ltBLwQf5Z//ivl8j
         9lFQ6Cz3go5FA==
Date:   Mon, 24 Jan 2022 10:37:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <lrumancik@google.com>,
        Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic/273: use _get_file_block_size
Message-ID: <20220124183735.GJ13563@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test calculates the amount of free space on a filesystem and uses
the block size to spread the work of filling the free space among a
bunch of threads.  Unfortunately, the test /should/ be using the
allocation unit size, not the fs block size, which is why this test
fails on configurations such as XFS realtime with a 28k extent size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
NOTE: This patch seems to fix the "porter not complete" problems on
5.16, but not on 5.17-rc1.  However, 5.17-rc1 is totally broken (~72%
failure rate) so I don't think I can count that as a serious QA effort.
---
 tests/generic/273 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/273 b/tests/generic/273
index b5458a77..f86dae9b 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -87,8 +87,8 @@ _do_workload()
 {
 	_pids=""
 	_pid=1
-	block_size=$(_get_block_size $SCRATCH_MNT)
-	
+	block_size=$(_get_file_block_size $SCRATCH_MNT)
+
 	_threads_set
 	_file_create $block_size
 
