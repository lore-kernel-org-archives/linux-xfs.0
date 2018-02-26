Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbeBZWng (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 17:43:36 -0500
Date: Mon, 26 Feb 2018 14:43:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] debian: don't fail postinst when upgrading chroot
Message-ID: <20180226224330.GC19318@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, nathans@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

If we're upgrading a systemd-enabled chroot we'll fail because systemctl
can't connect to a running systemd (nor should it).  We don't need to
issue daemon-reload inside a chroot that doesn't have a running systemd,
so we can ignore the return value.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debian/postinst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/postinst b/debian/postinst
index 11693a6..2ad9174 100644
--- a/debian/postinst
+++ b/debian/postinst
@@ -9,7 +9,7 @@ case "${1}" in
 			update-initramfs -u
 		fi
 		if [ -x /bin/systemctl ]; then
-			/bin/systemctl daemon-reload
+			/bin/systemctl daemon-reload 2>&1 || true
 		fi
 		;;
 
