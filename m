Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D01EE3F0C
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbjILTkP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjILTkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:40:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F51115
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:40:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D3BC433C8;
        Tue, 12 Sep 2023 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694547610;
        bh=yBbGmGmOparUOeZ6YHikey7Xiiocuz/mtO5mvn2rNMo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ggb6o4z0btohys9p2p+zF1DZDsSbWoKqylMHDih/HAISocoIODrG3pLFXDj/JlYZg
         pfF8LXo9yNS53JzGwbyhGxvTeKIiZHtLob2dUC0VVSDpho2iGDtCVE4WV/qLtnflwn
         s+QM8fQ9odrEviZyRXtW2NuXvC0wNO21eH1La/qJDjKv45GtW9Z2kOYnRIvBG3mRz8
         da+1PgaNKLX/FiQrYAJfEtf60rScW+Dq0UTRcuzrztCXauqOtKr9qewM3ePJAcxEBM
         kCrXp5poy34XR5V4cA3+r8UtDyrk1GpQa2z/X4TFz527t7qLltY7HntsSYDj73oDSx
         UU/U1XcSu7uHQ==
Subject: [PATCH 6/6] libxfs: fix atomic64_t detection on x86 32-bit
 architectures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Date:   Tue, 12 Sep 2023 12:40:10 -0700
Message-ID: <169454761010.3539425.13599600178844641233.stgit@frogsfrogsfrogs>
In-Reply-To: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfsprogs during compilation tries to detect if liburcu supports atomic
64-bit ops on the platform it is being compiled on, and if not it falls
back to using pthread mutex locks.

The detection logic for that fallback relies on _uatomic_link_error()
which is a link-time trick used by liburcu that will cause compilation
errors on archs that lack the required support. That only works for the
generic liburcu code though, and it is not implemented for the
x86-specific code.

In practice this means that when xfsprogs is compiled on 32-bit x86
archs will successfully link to liburcu for atomic ops, but liburcu does
not support atomic64_t on those archs. It indicates this during runtime
by generating an illegal instruction that aborts execution, and thus
causes various xfsprogs utils to be segfaulting.

Fix this by executing the liburcu atomic64_t detection code during
configure instead of only relying on the linker error, so that
compilation will properly fall back to pthread mutexes on those archs.

Fixes: 7448af588a2e ("libxfs: fix atomic64_t poorly for 32-bit architectures")
Reported-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 m4/package_urcu.m4 |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
index ef116e0cda7..4bb2b886f06 100644
--- a/m4/package_urcu.m4
+++ b/m4/package_urcu.m4
@@ -26,7 +26,11 @@ rcu_init();
 #
 # Make sure that calling uatomic_inc on a 64-bit integer doesn't cause a link
 # error on _uatomic_link_error, which is how liburcu signals that it doesn't
-# support atomic operations on 64-bit data types.
+# support atomic operations on 64-bit data types for its generic
+# implementation (which relies on compiler builtins). For certain archs
+# where liburcu carries its own implementation (such as x86_32), it
+# signals lack of support during runtime by emitting an illegal
+# instruction, so we also need to check CAA_BITS_PER_LONG to detect that.
 #
 AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
   [ AC_MSG_CHECKING([for atomic64_t support in liburcu])
@@ -34,8 +38,11 @@ AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
     [	AC_LANG_PROGRAM([[
 #define _GNU_SOURCE
 #include <urcu.h>
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 	]], [[
 long long f = 3;
+
+BUILD_BUG_ON(CAA_BITS_PER_LONG < 64);
 uatomic_inc(&f);
 	]])
     ], have_liburcu_atomic64=yes

