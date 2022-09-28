Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E181C04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 04:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiI1EYG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 00:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiI1EYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 00:24:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7131F0CC4;
        Tue, 27 Sep 2022 21:24:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A5E5CE1C97;
        Wed, 28 Sep 2022 04:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E221C433D7;
        Wed, 28 Sep 2022 04:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664339037;
        bh=V4h51d+ua7GW3fU3EViOo0W9xNrgUeYysAH+Um2ll+Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qZdyYqkKslaiuUUR/n+bz2SS33dmnQLnq4tZFngLMDrNqxzmpDJ9Twe3nSnCGHagC
         EkWZXIIVLB6bPL6NHb9IrUg154CryFyLF3UIZMXpMkstewFA4I1VncOofyLRs8fc6f
         g3olZLRMrN5OipCDaD44yz13ndyuZxWJCHQXCuHlZnp+tLCjvJ4k72RVLH37vjakD4
         /+CK451cyFQviwI79eV1OvQcm9n4/063fRWVB9xyujLvyFwPGK3EAIbvW4YmtQS6nY
         ZVrTHjW3mI+OqV590aGeuiQ822nmWE9ojgUqbq8GhuJK0lEe8GqivH3OTnwtS0PKi5
         Lvc32mBO7cEPg==
Subject: [PATCH 1/3] generic/092: skip test if file allocation unit isn't
 aligned
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Sep 2022 21:23:56 -0700
Message-ID: <166433903671.2008389.15875549373880546579.stgit@magnolia>
In-Reply-To: <166433903099.2008389.13181182359220271890.stgit@magnolia>
References: <166433903099.2008389.13181182359220271890.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test exercises allocation behavior when truncating a preallocated
file down to 5M and then up to 7M.  If those two sizes aren't aligned
with the file allocation unit length, then the FIEMAP output will show
blocks beyond EOF.  That will cause trouble with the golden output, so
skip this test if that will be the case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/092 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/tests/generic/092 b/tests/generic/092
index 505e0ec84f..d7c93ca792 100755
--- a/tests/generic/092
+++ b/tests/generic/092
@@ -28,6 +28,12 @@ _require_test
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
 
+# If the truncation sizes (5M/7M) aren't aligned with the file allocation unit
+# length, then the FIEMAP output will show blocks beyond EOF.  That will cause
+# trouble with the golden output, so skip this test if that will be the case.
+_require_congruent_file_oplen $TEST_DIR $((5 * 1048576))
+_require_congruent_file_oplen $TEST_DIR $((7 * 1048576))
+
 # First test to make sure that truncating at i_size trims the preallocated bit
 # past i_size
 $XFS_IO_PROG -f -c "falloc -k 0 10M" -c "pwrite 0 5M" -c "truncate 5M"\

