Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbdDEOC6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 10:02:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 10CC580F9D
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 14:02:58 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF3F97BCD2
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 14:02:57 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: fix build dep on configure.ac
Message-ID: <630ee329-e906-2673-926f-4fea0971bd46@redhat.com>
Date: Wed, 5 Apr 2017 09:02:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Zorro reported that this sequence:

# git checkout v4.9.0; make realclean; make
# git checkout v4.10.0; make clean; make

fails:

...
Building libxfs
    [CC]     gen_crc32table
gcc: error: @BUILD_CFLAGS@: No such file or directory
gmake[3]: *** No rule to make target `crc32table.h', needed by `crc32selftest'.  Stop.

This is because 

0a71e38 build: Allow compiling xfsprogs in a cross compile environment

added the new BUILD_CFLAGS to configure.ac, and unless we re-run
autotools, that variable does not get substituted when
include/builddefs gets built.

(This can be worked around by "make realclean" and then everything
gets regenerated.)

The configure script is generated from configure.ac, so adding
a Make dependency here should resolve such issues in the future.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(I'm no build/Make guru, but I think this is sane...)


diff --git a/Makefile b/Makefile
index 6e45733..ba87327 100644
--- a/Makefile
+++ b/Makefile
@@ -101,7 +101,7 @@ endif
 # versions will copy those files anyway, and don't understand -i.
 LIBTOOLIZE_INSTALL = `$(LIBTOOLIZE_BIN) -n -i >/dev/null 2>/dev/null && echo -i`
 
-configure:
+configure: configure.ac
 	$(LIBTOOLIZE_BIN) -c $(LIBTOOLIZE_INSTALL) -f
 	cp include/install-sh .
 	aclocal -I m4

