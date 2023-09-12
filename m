Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86837EE3F11
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjILTr4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjILTrz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:47:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016E6115
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:47:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972FBC433C8;
        Tue, 12 Sep 2023 19:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694548071;
        bh=y16HFS1fB6oLGZ+y9a+djb9Z87qhzFtmc6MdOfvqBIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PMqPZ/gAZI/Kr8pR/WIJlMcNA63iY3u1Sjxka1PKdA3FQIrCy58xmIOsxNR3Llz1l
         dzqH0od8GR6Pl9OhgYAQBjCd21gJsfnMIA1jaZUpH1CG7DrErRMcsWsnjFMSWfJYdL
         71v9sYSiWWcVmGe+BsOiUKj3jueemX4wlKykmVywOp2Unhr64+Gy6nDonEOh5Kup+e
         Bdqfs2wxe0a5ASYVhFmzqZDF8zg2RyWdKn6et9fzqVGNWspon4/Egq6xXWmnJqsD9z
         JwfWJUok/M6WaKjvjdUjcgefGtX6DbjFKBorpBqguR+LtWwwp7ZcLU6KoUaUmqdgX9
         4O/pABTBy3BcA==
Date:   Tue, 12 Sep 2023 12:47:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 6/6] libxfs: fix atomic64_t detection on x86 32-bit
 architectures
Message-ID: <20230912194751.GB3415652@frogsfrogsfrogs>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <169454761010.3539425.13599600178844641233.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454761010.3539425.13599600178844641233.stgit@frogsfrogsfrogs>
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

Fix this by requiring that unsigned longs are at least 64 bits in size,
which /usually/ means that 64-bit atomic counters are supported.  We
can't simply execute the liburcu atomic64_t detection code during
configure instead of only relying on the linker error because that
doesn't work for cross-compiled packages.

Fixes: 7448af588a2e ("libxfs: fix atomic64_t poorly for 32-bit architectures")
Reported-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: This time with correct commit message.
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
