Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9AECD3420
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Sep 2023 16:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjIRQwk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjIRQwi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 12:52:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699C8B6
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 09:52:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF64C32781
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695047168;
        bh=u+wtshfkT+aa4KkhzbTPicV2Nw+QWrixRqZHaKAbnNw=;
        h=From:To:Subject:Date:From;
        b=MjTgoGYH/v/BpBppHZgcEpK/k+7xvoFNizNdeP/X1sINDQrhk47PKfLq58BdrLN/G
         jWp6RHnE3mDDjL3IYV2CYMxHvib7fvOlLHc0xivCWUCsKTCbJT5bUBhN45PGGo38wH
         riH4xkcFCr/n888gq0Qyth2blL8Z2BX4tIUhP6g1vdpaWd62B7Mjvc4Z0xZkcN3Dkr
         jItW+GK6KoT3CoO7xCDaxrQHvvnMLjCzwOe4AMHBM0vDPIffSrLR2aWtYALJj/xwie
         ynrorI4pdeSs3NsRNY/AjD2RFyiOUglxEx7PVz3UibFY8s105rlarrT+Mbs4j4Gy+S
         p3JOhqFTy6g6A==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs: Update agsize description in the man page
Date:   Mon, 18 Sep 2023 16:26:04 +0200
Message-Id: <20230918142604.390357-1-cem@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cem@kernel.org>

agsize value accept different suffixes, including filesystem blocks, so,
replace "expressed in bytes" by "expressed as a multiple of filesystem
blocks".

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man8/mkfs.xfs.8.in | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 08bb92f65..96c07fc71 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -352,12 +352,11 @@ This is an alternative to using the
 .B agcount
 suboption. The
 .I value
-is the desired size of the allocation group expressed in bytes
-(usually using the
+is the desired size of the allocation group expressed as a multiple of the
+filesystem block size (usually using the
 .BR m " or " g
 suffixes).
-This value must be a multiple of the filesystem block size, and
-must be at least 16MiB, and no more than 1TiB, and may
+It must be at least 16MiB, and no more than 1TiB, and may
 be automatically adjusted to properly align with the stripe geometry.
 The
 .B agcount
-- 
2.39.2

