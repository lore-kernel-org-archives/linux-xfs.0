Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64901 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbeKATuV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Nov 2018 15:50:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1AAA73B46C
        for <linux-xfs@vger.kernel.org>; Thu,  1 Nov 2018 10:47:57 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] xfsdump: don't fail installation if /sbin is symlink of /usr/sbin
Date: Thu,  1 Nov 2018 11:47:32 +0100
Message-Id: <20181101104732.19322-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Some distributions, like Fedora, have /bin and /sbin as symlinks
pointing to /usr/* and this patch adds compatibility for these cases.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 dump/Makefile    | 4 +++-
 restore/Makefile | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/dump/Makefile b/dump/Makefile
index 97879fa..66f00d3 100644
--- a/dump/Makefile
+++ b/dump/Makefile
@@ -100,7 +100,9 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
+	# skip symlink when /sbin is alread symlinked to /usr/sbin, like on Fedora
+	test $(PKG_ROOT_SBIN_DIR) -ef $(PKG_SBIN_DIR) || \
+		$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
 .dep: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
diff --git a/restore/Makefile b/restore/Makefile
index c6f3f25..20c870a 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -110,7 +110,9 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
-	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
+	# skip symlink when /sbin is alread symlinked to /usr/sbin, like on Fedora
+	test $(PKG_ROOT_SBIN_DIR) -ef $(PKG_SBIN_DIR) || \
+		$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
 install-dev:
 
 .dep: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
-- 
2.19.1
