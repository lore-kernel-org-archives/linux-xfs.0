Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EDFC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245197AbiDKW4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346702AbiDKW4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:56:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A42A185;
        Mon, 11 Apr 2022 15:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 394E9CE17B8;
        Mon, 11 Apr 2022 22:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF7CC385A4;
        Mon, 11 Apr 2022 22:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717668;
        bh=H7PQ+1qIo+gwxATV4ELYpqYdJ4udgEcBhBxS4xEOib0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u2jupRsmtkq969cQnAPfvyHS7W9slxtMe/sPu/bU059OUPrdx4RJbb7MeQ5mE+VVy
         6QAHjRT0qByWPfnhbfpjUs7uzCDBROr9GzD86/7By63KXJBgaQ8uUqx0m87YvN29y+
         i+KD7LwJIZnwgpSgXLbs5btR+KAKCk+UJoWP1pX1Go/8xno0psVdTAOheEmWi3HCip
         UyIf6G1TtEIftJxzSwRFq2wG1q6QKRH6YHryRe05u0THW+xs76ZLKKkcgsLanJ2Syz
         WU6Wkwdkr3/EjHVdAB2XZA9CowYrhJMeF8WpmiUx8e/a47jNpbmvuhbaOyTBVfOSxH
         aN5sNPcIh3bgQ==
Subject: [PATCH 2/2] xfs/507: add test to auto group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:54:28 -0700
Message-ID: <164971766805.169895.12082898167045363438.stgit@magnolia>
In-Reply-To: <164971765670.169895.10730350919455923432.stgit@magnolia>
References: <164971765670.169895.10730350919455923432.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add this regression test to the auto group now that it's been quite a
while since the fix patches went upstream.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/507 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/507 b/tests/xfs/507
index aa3d8eeb..b9c9ab29 100755
--- a/tests/xfs/507
+++ b/tests/xfs/507
@@ -4,13 +4,17 @@
 #
 # FS QA Test No. 507
 #
+# Regression test for kernel commit:
+#
+# 394aafdc15da ("xfs: widen inode delalloc block counter to 64-bits")
+#
 # Try to overflow i_delayed_blks by setting the largest cowextsize hint
 # possible, creating a sparse file with a single byte every cowextsize bytes,
 # reflinking it, and retouching every written byte to see if we can create
 # enough speculative COW reservations to overflow i_delayed_blks.
 #
 . ./common/preamble
-_begin_fstest clone
+_begin_fstest auto clone
 
 _register_cleanup "_cleanup" BUS
 

