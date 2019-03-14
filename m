Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49704 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbfCNVEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:04:11 -0400
Subject: [PATCH 04/36] debian: drop dangling libhandle.a symlinks in
 xfslibs-dev
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:04:07 -0700
Message-ID: <155259744781.31886.15637750109545213350.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't ship static libhandle libraries anymore, so make sure we drop
the symlink.

Fixes: ec1cf08dbeb2d ("Several updates to use more modern Debian packaging")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/rules |    1 +
 1 file changed, 1 insertion(+)


diff --git a/debian/rules b/debian/rules
index 4c50654c..80dff4bb 100755
--- a/debian/rules
+++ b/debian/rules
@@ -80,6 +80,7 @@ binary-arch: checkroot built
 	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
 	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
 	rm -f debian/xfslibs-dev/lib/libhandle.la
+	rm -f debian/xfslibs-dev/lib/libhandle.a
 	rm -fr debian/xfslibs-dev/usr/lib
 	dh_installdocs
 	dh_installchangelogs
