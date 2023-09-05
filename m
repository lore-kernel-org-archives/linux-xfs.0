Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E252CA0FF3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 16:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350947AbjIEQZS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353947AbjIEIqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 04:46:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A51AA
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 01:46:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A5CFC1F750
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 08:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693903589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=waPUQWKSuhsPFbuH5eDakT0PFzx97UIAw85h/6xFV0Y=;
        b=DczJR/BcG0Wk6lla1XjKNisvJ10QfU45Jhg9dXZwYkpJCczqCg6c9hKSChh/2a3jvsbmDc
        syNJx+sBwD4WVoKkfX+3On5QSw170yDhYwIqGWit9URocRRzX0cJTfeLfRzF67il89ADzO
        5IXAEpuBsfeU2S/xLuiD4U++ReyZ7Mg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 965D713499
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 08:46:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G3nbI+Xq9mTdGAAAMHmgww
        (envelope-from <ailiop@suse.com>)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2023 08:46:29 +0000
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs: fix atomic64_t detection on x86 32-bit architectures
Date:   Tue,  5 Sep 2023 10:46:23 +0200
Message-ID: <20230905084623.24865-1-ailiop@suse.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 m4/package_urcu.m4 | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
index ef116e0cda76..f26494a69718 100644
--- a/m4/package_urcu.m4
+++ b/m4/package_urcu.m4
@@ -26,11 +26,15 @@ rcu_init();
 #
 # Make sure that calling uatomic_inc on a 64-bit integer doesn't cause a link
 # error on _uatomic_link_error, which is how liburcu signals that it doesn't
-# support atomic operations on 64-bit data types.
+# support atomic operations on 64-bit data types for its generic
+# implementation (which relies on compiler builtins). For certain archs
+# where liburcu carries its own implementation (such as x86_32), it
+# signals lack of support during runtime by emitting an illegal
+# instruction, so we also need to execute here to detect that.
 #
 AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
   [ AC_MSG_CHECKING([for atomic64_t support in liburcu])
-    AC_LINK_IFELSE(
+    AC_RUN_IFELSE(
     [	AC_LANG_PROGRAM([[
 #define _GNU_SOURCE
 #include <urcu.h>
-- 
2.42.0

