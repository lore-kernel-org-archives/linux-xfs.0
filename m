Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbeGaFUD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 01:20:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C86730E6857
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:41:55 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6920818344
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:41:55 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] misc: remove COPYING from doc/ Makefile
Message-ID: <e4d64c9b-5a1a-54b5-8b69-463738c95307@redhat.com>
Date: Mon, 30 Jul 2018 22:41:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

COPYING is gone now, so make doc-install breaks.

Fixes: 959ef98 ("xfsprogs: convert to SPDX license tags")

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/doc/Makefile b/doc/Makefile
index 8b870dc..83dfa38 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -5,7 +5,7 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-LSRCFILES = INSTALL CHANGES COPYING CREDITS sparse.txt
+LSRCFILES = INSTALL CHANGES CREDITS sparse.txt
 LDIRT = *.gz
 
 default: CHANGES.gz
@@ -21,8 +21,6 @@ install: default
 	$(INSTALL) -m 644 CHANGES.gz CREDITS $(PKG_DOC_DIR)
 ifeq ($(PKG_DISTRIBUTION), debian)
 	$(INSTALL) -S CHANGES.gz $(PKG_DOC_DIR)/changelog.gz
-else
-	$(INSTALL) -m 644 COPYING $(PKG_DOC_DIR)
 endif
 
 install-dev:

