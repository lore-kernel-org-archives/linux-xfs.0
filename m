Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E34C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 19:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhKWT5D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 14:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:37692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233942AbhKWT5C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 14:57:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AF4D60F5D;
        Tue, 23 Nov 2021 19:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637697234;
        bh=62Ugz1P5js8oflaBQkYsN1abUoxz4Oo9G2y+KHYPLPw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dpHeYyxnjCPfMpkF1qcbamsgaBtosJ5joVbEGkt+o1a2pbk84DurpFxRl8b138YyH
         t2zUycHetol9x12tVfTIHu9IBwxzm5zjLaE8HLqm75ObRvIL2iBCwh072gakznhFNp
         SggzHuw+RLbJz5LOrGnewzmBAy0gxrGG48jpENQ7e0aC10LVhBC4FcsEaxPa2da6MU
         xHXtPdWyo0Rz2HzN0IyAlS7VZQzgPMeLExBkw7aLj9I5QRvdpkxlX21W4bCWTDIjRi
         ujvU9UHN/ipdHLyjTTHQ4+rAAHwRSEB4oioYRyenpL4pWa84btHdtiqzBkh1eksJB6
         grOci1XHrPMlA==
Subject: [PATCH 1/2] libfrog: fix crc32c self test code on cross builds
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Helmut Grohne <helmut@subdivi.de>,
        Bastian Germann <bage@debian.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 23 Nov 2021 11:53:53 -0800
Message-ID: <163769723396.871940.2874954467689580625.stgit@magnolia>
In-Reply-To: <163769722838.871940.2491721496902879716.stgit@magnolia>
References: <163769722838.871940.2491721496902879716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Helmut Grohne reported that the crc32c self test program fails to cross
build on 5.14.0 if the build host doesn't have liburcu installed.  We
don't need userspace RCU functionality to test crc32 on the build host,
so twiddle the header files to include only the two header files that we
actually need.

Note: Build-time testing of crc32c is useful for upstream developers so
that we can check that we haven't broken the checksum code, but we
really ought to be testing this in mkfs and repair on the user's system
so that they don't end up with garbage filesystems.  A future patch will
introduce that.

Reported-by: Helmut Grohne <helmut@subdivi.de>
Cc: Bastian Germann <bage@debian.org>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/crc32.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 526ce950..6a273b71 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -29,10 +29,15 @@
  * match the hardware acceleration available on Intel CPUs.
  */
 
+/*
+ * Do not include platform_defs.h here; this will break cross builds if the
+ * build host does not have liburcu-dev installed.
+ */
+#include <stdio.h>
+#include <sys/types.h>
 #include <inttypes.h>
 #include <asm/types.h>
 #include <sys/time.h>
-#include "platform_defs.h"
 /* For endian conversion routines */
 #include "xfs_arch.h"
 #include "crc32defs.h"

