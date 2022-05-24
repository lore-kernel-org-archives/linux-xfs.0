Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CE5C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 19:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241066AbiEXTwZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 15:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241062AbiEXTwY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 15:52:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087D856777;
        Tue, 24 May 2022 12:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA83FB81B9A;
        Tue, 24 May 2022 19:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A56C34115;
        Tue, 24 May 2022 19:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653421940;
        bh=0A6AgF17x1amHH4nUv+RSnA+OOMaf1kLhqYmkdKupAY=;
        h=Date:From:To:Cc:Subject:From;
        b=nxdHZMpAa8rMUdKTzEApgXN8hCv2G7gfQAbpNF4tOTXnyhlKVUAypL3Tb6sbxa6RK
         PiAuGUSo/UjxYUDZbPyaynCvdQuE5lkbLeGdSK8TvLnMp2WHafZQFCVg3kGyN3Fs7O
         xD5APTU/seQTM6kMtgPzcQQ5r4eq+ji93veRfOYsq9SVmXgSVlWJZE7kiL+NnOsDek
         Ww1S66B/UUtZCthL9G2obczgfxW5awbM3kczmd65SUL7bN/7zLne86QxMovy6FDvXX
         QPbAPlLr21OfuGG6JMevdK1ALwvIRm8Bh88UtcJZ/OUwQG2rf89Zeja/x1cpVaJ2uE
         AEHEVIYpw0aIQ==
Date:   Tue, 24 May 2022 12:52:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs/545: check for fallocate support before running test
Message-ID: <Yo03czi2EzyKy2/c@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test fails when alwayscow mode is enabled:

--- xfs/545.out
+++ xfs/545.out.bad
@@ -1,4 +1,5 @@
 QA output created by 545
+fallocate: Operation not supported
 Creating directory system to dump using fsstress.

Fix this by checking for fallocate support first.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/545 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/545 b/tests/xfs/545
index e3dd300a..dfe2f2dc 100755
--- a/tests/xfs/545
+++ b/tests/xfs/545
@@ -14,6 +14,7 @@ _begin_fstest auto quick dump
 . ./common/dump
 
 _supported_fs xfs
+_require_xfs_io_command "falloc"
 _require_scratch
 
 # A large stripe unit will put the root inode out quite far
