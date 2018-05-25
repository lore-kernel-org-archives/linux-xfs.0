Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755055AbeEYDTr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 23:19:47 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v3 4/4] debian/rules: use the new sysconfdir configuration setting
Date: Thu, 24 May 2018 20:19:43 -0700
Message-Id: <20180525031943.29440-5-mcgrof@kernel.org>
In-Reply-To: <20180525031943.29440-1-mcgrof@kernel.org>
References: <20180525031943.29440-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Configuration file support requires setting --sysconfdir=/etc/ if your
distribution expects mkfs.xfs.d directory to be in /etc.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 debian/rules | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/debian/rules b/debian/rules
index cb4fa22c1584..599d7998052e 100755
--- a/debian/rules
+++ b/debian/rules
@@ -20,9 +20,9 @@ stdenv = @GZIP=-q; export GZIP;
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
-	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
+	  LOCAL_CONFIGURE_OPTIONS="--enable-readline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto --sysconfdir=/etc/" ;
 diopts  = $(options) \
-	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
+	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto --sysconfdir=/etc/" ;
 checkdir = test -f debian/rules
 
 build: build-arch build-indep
-- 
2.16.3

