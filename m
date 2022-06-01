Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8230C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 21:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiFAVRy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 17:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiFAVRx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 17:17:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12046A041
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 14:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6650CB81C38
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 21:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6397C385A5;
        Wed,  1 Jun 2022 21:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654118265;
        bh=yci3SBPe9gcRaji3n4uZr4NYMZdByeQVWkp85CbkFIU=;
        h=Date:From:To:Cc:Subject:From;
        b=oTlk8G0akyOA6COruczeHtesQCUN4JBdCilyOxrmLsriZ+JkIAMV913vKEP+aoDkj
         00P3gioPv/wJc53xtPAVEj/UzKgWh2Vp/m6tlXfb5SrwoCCPkXOEnkkKWkHXSQT5XK
         ktl5r2TDaqCG5E2G1rud9mGB4PLenqWnlkCphu6ppO4xapicg1JBv8t+Ol38jj11U+
         Y9VLlFUG4ClBM7861BC8VYqyMx9QXg/BqY5CBUMXQ2HlJW4IBfsbI/sfUJNOb4e9tc
         t1dnQ+WP4FV7Q6lEoyGCPUayjLGOxYHRcN8ofRAOiBsJzOhgekSFAdNusG8NXalcFx
         4AqUchTSINp9Q==
Date:   Wed, 1 Jun 2022 14:17:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfsprogs: more autoconf modernisation
Message-ID: <YpfXeCzZlBIq+vFI@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a few autoconf things that were added after the submission of the
autoconf modernization patch.  This was performed by running:

$ autoupdate configure.ac m4/*.m4

And manually putting the version back to 2.69.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    2 +-
 m4/package_libcdev.m4 |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index a4e14e17..02afd805 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 AC_INIT([xfsprogs],[5.18.0-rc1],[linux-xfs@vger.kernel.org])
-AC_PREREQ(2.69)
+AC_PREREQ([2.69])
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([include/libxfs.h])
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 4dff8792..70badac3 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -404,13 +404,15 @@ test = mallinfo();
 #
 AC_DEFUN([AC_HAVE_MALLINFO2],
   [ AC_MSG_CHECKING([for mallinfo2 ])
-    AC_TRY_COMPILE([
+    AC_COMPILE_IFELSE(
+    [	AC_LANG_PROGRAM([[
 #include <malloc.h>
-    ], [
-         struct mallinfo2 test;
+        ]], [[
+struct mallinfo2 test;
 
-         test.arena = 0; test.hblkhd = 0; test.uordblks = 0; test.fordblks = 0;
-         test = mallinfo2();
+test.arena = 0; test.hblkhd = 0; test.uordblks = 0; test.fordblks = 0;
+test = mallinfo2();
+        ]])
     ], have_mallinfo2=yes
        AC_MSG_RESULT(yes),
        AC_MSG_RESULT(no))
