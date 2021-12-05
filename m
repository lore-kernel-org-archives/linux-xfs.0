Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA5FC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Dec 2021 17:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbhLESAc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Dec 2021 13:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbhLESAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Dec 2021 13:00:32 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA96C061714
        for <linux-xfs@vger.kernel.org>; Sun,  5 Dec 2021 09:57:04 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mtvl2-0008LG-4j; Sun, 05 Dec 2021 17:57:04 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1000974: [PATCH xfsprogs-5.14.2 URGENT] libxfs: hide the drainbamaged fallthrough macro from xfslibs
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1000974@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1000974
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Keywords: 
References: <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1000974-submit@bugs.debian.org id=B1000974.163872698831903
          (code B ref 1000974); Sun, 05 Dec 2021 17:57:03 +0000
Received: (at 1000974) by bugs.debian.org; 5 Dec 2021 17:56:28 +0000
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1]:49354)
        by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <djwong@kernel.org>)
        id 1mtvkS-0008IJ-64
        for 1000974@bugs.debian.org; Sun, 05 Dec 2021 17:56:28 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F6866111F;
        Sun,  5 Dec 2021 17:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8282C00446;
        Sun,  5 Dec 2021 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638726591;
        bh=WDJDLIk/LkLaM+Ecib9/ncGiij1a5lrVGtqKC4eIDOw=;
        h=Date:From:To:Cc:Subject:From;
        b=d/1wdzsmOcv9ztvNDkeJnmFK/Wfp01Xy33vigFeamTv7XcIRp1+j0/7lDPkErTIZN
         ChGdbPmZcgrb1zVq59BjVJjKG6j0471B9TabWiAC2DRN9wvN1065y4LzxjBljNvWGg
         fXD4930u5xvLB/jWKVQnXGENoRLETDCoF3jEBdAcAwOpKu6Khwg4uItw+2pb/owZai
         +Cjis1tNZh1YCdfkPhiufFzZMNmdAOhCei3UUk/YfnT9x0B8yUzuGDBNT9bPzK3nZf
         3GlXRkziqJpwPrsLVHE+afSBUUtScmDciWzWZa0ADCcWvEKcCgCBQZABxRaeS3wqVE
         Wrw8WGJ0acDNw==
Date:   Sun, 5 Dec 2021 09:49:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Thomas Goirand <zigo@debian.org>, 1000974@bugs.debian.org,
        Giovanni Mascellani <gio@debian.org>,
        xfslibs-dev@packages.debian.org, xfs <linux-xfs@vger.kernel.org>,
        gustavoars@kernel.org, keescook@chromium.org
Message-ID: <20211205174951.GQ8467@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Greylist: delayed 393 seconds by postgrey-1.36 at buxtehude; Sun, 05 Dec 2021 17:56:27 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20211205174951.Mgyb6I6-3Ltk7qZPwKaX6rkN4UJBW2XFCYI_I2GBZHo@z>

From: Darrick J. Wong <djwong@kernel.org>

Back in mid-2021, Kees and Gustavo rammed into the kernel a bunch of
static checker "improvements" that redefined '/* fallthrough */'
comments for switch statements as a macro that virtualizes either that
same comment, a do-while loop, or a compiler __attribute__.  This was
necessary to work around the poor decision-making of the clang, gcc, and
C language standard authors, who collectively came up with four mutually
incompatible ways to document a lack of branching in a code flow.

Having received ZERO HELP porting this to userspace, Eric and I
foolishly dumped that crap into linux.h, which was a poor decision
because we keep forgetting that linux.h is exported as a userspace
header.  This has now caused downstream regressions in Debian[1] and
will probably cause more problems in the other distros.

Move it to platform_defs.h since that's not shipped publicly and leave a
warning to anyone else who dare modify linux.h.

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1000974

Fixes: df9c7d8d ("xfs: Fix fall-through warnings for Clang")
Cc: 1000974@bugs.debian.org, gustavoars@kernel.org, keescook@chromium.org
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/linux.h            |   20 ++------------------
 include/platform_defs.h.in |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index 24650228..054117aa 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -360,24 +360,8 @@ fsmap_advance(
 #endif /* HAVE_MAP_SYNC */
 
 /*
- * Add the pseudo keyword 'fallthrough' so case statement blocks
- * must end with any of these keywords:
- *   break;
- *   fallthrough;
- *   continue;
- *   goto <label>;
- *   return [expression];
- *
- *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
+ * Reminder: anything added to this file will be compiled into downstream
+ * userspace projects!
  */
-#if defined __has_attribute
-#  if __has_attribute(__fallthrough__)
-#    define fallthrough                    __attribute__((__fallthrough__))
-#  else
-#    define fallthrough                    do {} while (0)  /* fallthrough */
-#  endif
-#else
-#    define fallthrough                    do {} while (0)  /* fallthrough */
-#endif
 
 #endif	/* __XFS_LINUX_H__ */
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 7c6b3ada..6e6f26ef 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -113,4 +113,25 @@ static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
 		sizeof(*(p)->member) + __must_be_array((p)->member),	\
 		sizeof(*(p)))
 
+/*
+ * Add the pseudo keyword 'fallthrough' so case statement blocks
+ * must end with any of these keywords:
+ *   break;
+ *   fallthrough;
+ *   continue;
+ *   goto <label>;
+ *   return [expression];
+ *
+ *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
+ */
+#if defined __has_attribute
+#  if __has_attribute(__fallthrough__)
+#    define fallthrough                    __attribute__((__fallthrough__))
+#  else
+#    define fallthrough                    do {} while (0)  /* fallthrough */
+#  endif
+#else
+#    define fallthrough                    do {} while (0)  /* fallthrough */
+#endif
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
