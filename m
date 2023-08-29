Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA27C83F18
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbjH2XEE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240656AbjH2XDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:03:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E62E9;
        Tue, 29 Aug 2023 16:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A4ED611BD;
        Tue, 29 Aug 2023 23:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC0C433C8;
        Tue, 29 Aug 2023 23:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350229;
        bh=VSiVaoQlcSEkq1iN9dd+YSoJfRX29w7hF3iGCShgk7E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sloXyKE7Vutb2trDLDL9RhZ24IhLJoLP9dwl/InfNXopUGkUSpXTQeCw2u5ksWTbC
         MgQxs6tGbPbsrxS0w9vM0FRqP3bjdmGcaWiDfzgv4u7nA7MKzxBaHFdIy2G8kgDfw/
         FkAA0xBdmktKSN2gtq2afFOE/aQ22cRp0tB+0IONFtJR4CV79/jkBb/HXKkinexYB3
         CWyOP134wbKmTD4FejtcsIELhS/Asrvu4o43znDhwWVKsNtFfyW9YIOUmurHwilh81
         wz2w+0O/7VIpEexVfYVPO6+hBxgoxb/4FbygJO/AzX+c3LDIffmb9nLrn1/QAnzZ0G
         Jf09ok+julkvQ==
Subject: [PATCH 3/3] xfs/559: adapt to kernels that use large folios for
 writes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 29 Aug 2023 16:03:49 -0700
Message-ID: <169335022920.3517899.399149462227894457.stgit@frogsfrogsfrogs>
In-Reply-To: <169335021210.3517899.17576674846994173943.stgit@frogsfrogsfrogs>
References: <169335021210.3517899.17576674846994173943.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The write invalidation code in iomap can only be triggered for writes
that span multiple folios.  If the kernel reports a huge page size,
scale up the write size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/559 |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/559 b/tests/xfs/559
index cffe5045a5..64fc16ebfd 100755
--- a/tests/xfs/559
+++ b/tests/xfs/559
@@ -42,11 +42,38 @@ $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
 _require_pagecache_access $SCRATCH_MNT
 
 blocks=10
-blksz=$(_get_page_size)
+
+# If this kernel advertises huge page support, it's possible that it could be
+# using large folios for the page cache writes.  It is necessary to write
+# multiple folios (large or regular) to triggering the write invalidation,
+# so we'll scale the test write size accordingly.
+blksz=$(_get_hugepagesize)
+base_pagesize=$(_get_page_size)
+test -z "$blksz" && blksz=${base_pagesize}
 filesz=$((blocks * blksz))
 dirty_offset=$(( filesz - 1 ))
 write_len=$(( ( (blocks - 1) * blksz) + 1 ))
 
+# The write invalidation that we're testing below can only occur as part of
+# a single large write.  The kernel limits writes to one base page less than
+# 2GiB to prevent lengthy IOs and integer overflows.  If the block size is so
+# huge (e.g. 512M huge pages on arm64) that we'd exceed that, reduce the number
+# of blocks to get us under the limit.
+max_writesize=$((2147483647 - base_pagesize))
+if ((write_len > max_writesize)); then
+	blocks=$(( ( (max_writesize - 1) / blksz) + 1))
+	# We need at least three blocks in the file to test invalidation
+	# between writes to multiple folios.  If we drop below that,
+	# reconfigure ourselves with base pages and hope for the best.
+	if ((blocks < 3)); then
+		blksz=$base_pagesize
+		blocks=10
+	fi
+	filesz=$((blocks * blksz))
+	dirty_offset=$(( filesz - 1 ))
+	write_len=$(( ( (blocks - 1) * blksz) + 1 ))
+fi
+
 # Create a large file with a large unwritten range.
 $XFS_IO_PROG -f -c "falloc 0 $filesz" $SCRATCH_MNT/file >> $seqres.full
 

