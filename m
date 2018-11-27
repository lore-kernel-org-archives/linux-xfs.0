Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725752AbeK1Gka (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:40:30 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2EE433DDBE
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 19:41:33 +0000 (UTC)
Received: from Liberator-5.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ECE155D75C
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 19:41:32 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: don't install xfs_scrub man pages if config'd off
Message-ID: <0ba2607c-9954-94fc-fcf0-c6fe8579a2c8@redhat.com>
Date: Tue, 27 Nov 2018 13:41:31 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Don't install man pages for xfs_scrub if it's turned off
in the config.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/Makefile b/man/man8/Makefile
index 36620da..e6a5572 100644
--- a/man/man8/Makefile
+++ b/man/man8/Makefile
@@ -7,7 +7,11 @@ include $(TOPDIR)/include/builddefs
 
 MAN_SECTION	= 8
 
-MAN_PAGES	= $(shell echo *.$(MAN_SECTION))
+ifneq ("$(ENABLE_SCRUB)","yes")
+  MAN_PAGES = $(filter-out xfs_scrub%,$(shell echo *.$(MAN_SECTION)))
+else
+  MAN_PAGES = $(shell echo *.$(MAN_SECTION))
+endif
 MAN_DEST	= $(PKG_MAN_DIR)/man$(MAN_SECTION)
 LSRCFILES	= $(MAN_PAGES)
 
