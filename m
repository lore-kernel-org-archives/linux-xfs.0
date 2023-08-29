Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE83C83F1C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239990AbjH2XED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240414AbjH2XDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:03:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64470E9;
        Tue, 29 Aug 2023 16:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01FF561862;
        Tue, 29 Aug 2023 23:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB4EC433C8;
        Tue, 29 Aug 2023 23:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350218;
        bh=uqR8LYg220cy6P85Ra2XF4z4WVGSM51gslah+eI5nDY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VFmVSbqv5BB9dup/jlY9m7opa3LSP8v9OdlXzivKzUuEfHejtkxwMOwqKxwTAuqpE
         Gu8xp3yHj+kpuAfwtiXLONkwZ9KIKECwEjIik2IPtC7pPxHz+T6q0vbDxPWzSh8LXJ
         L0QrG6jhWyvFMNZc275Qs3XxhKvZNXIzb0IVz3Skf6BgZoepgUaywpZMrxOc+/yX2u
         94Al8rdptR2eldhwpXXHNW9+dUhn8azIbdXJRbk+XQZXPb09bzfqoMBgmsCO09Xu+7
         VmlXcyaZeA7dqYoBc9iFBClG0dnlKWAh8JBQ15qDBRPI0kGieHVm+QjlRxgN58KzW8
         RqWvHuA2lN+rA==
Subject: [PATCH 1/3] common: split _get_hugepagesize into detection and actual
 query
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 29 Aug 2023 16:03:37 -0700
Message-ID: <169335021789.3517899.15257872086965624714.stgit@frogsfrogsfrogs>
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

This helper has two parts -- querying the value, and _notrun'ing the
test if huge pages aren't turned on.  Break these into the usual
_require_hugepages and _get_hugepagesize predicates so that we can adapt
xfs/559 to large folios being used for writes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   13 ++++++++-----
 tests/generic/413 |    1 +
 tests/generic/605 |    1 +
 3 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/common/rc b/common/rc
index 68d2ad041e..b5bf3c3bcb 100644
--- a/common/rc
+++ b/common/rc
@@ -108,14 +108,17 @@ _get_filesize()
     stat -c %s "$1"
 }
 
+# Does this kernel support huge pages?
+_require_hugepages()
+{
+	awk '/Hugepagesize/ {print $2}' /proc/meminfo | grep -E -q ^[0-9]+$ || \
+		_notrun "Kernel does not report huge page size"
+}
+
 # Get hugepagesize in bytes
 _get_hugepagesize()
 {
-	local hugepgsz=$(awk '/Hugepagesize/ {print $2}' /proc/meminfo)
-	# Call _notrun if $hugepgsz is not a number
-	echo "$hugepgsz" | grep -E -q ^[0-9]+$ || \
-		_notrun "Cannot get the value of Hugepagesize"
-	echo $((hugepgsz * 1024))
+	awk '/Hugepagesize/ {print $2 * 1024}' /proc/meminfo
 }
 
 _mount()
diff --git a/tests/generic/413 b/tests/generic/413
index 155f397d1d..bd1b04a624 100755
--- a/tests/generic/413
+++ b/tests/generic/413
@@ -13,6 +13,7 @@ _begin_fstest auto quick dax prealloc
 . ./common/filter
 
 _supported_fs generic
+_require_hugepages
 _require_test
 _require_scratch_dax_mountopt "dax"
 _require_test_program "feature"
diff --git a/tests/generic/605 b/tests/generic/605
index 77671f39d3..7e814d5ba1 100755
--- a/tests/generic/605
+++ b/tests/generic/605
@@ -13,6 +13,7 @@ _begin_fstest auto attr quick dax prealloc
 . ./common/filter
 
 _supported_fs generic
+_require_hugepages
 _require_scratch_dax_mountopt "dax=always"
 _require_test_program "feature"
 _require_test_program "t_mmap_dio"

