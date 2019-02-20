Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfBTRUR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Feb 2019 12:20:17 -0500
Date: Wed, 20 Feb 2019 09:20:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] t_attr_corruption: fix xattr.h include problems
Message-ID: <20190220172005.GJ6477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: David Sterba <dsterba@suse.cz>, Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Apparently newer versions of libattr (which haven't yet been picked up
by Debian or Ubuntu) don't ship xattr.h anymore, because we're supposed
to use the libc version in sys/xattr.h.  So do that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/t_attr_corruption.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/t_attr_corruption.c b/src/t_attr_corruption.c
index 1fa5e41f..f26611f9 100644
--- a/src/t_attr_corruption.c
+++ b/src/t_attr_corruption.c
@@ -27,7 +27,7 @@
 #include <string.h>
 #include <stdint.h>
 #include <unistd.h>
-#include <attr/xattr.h>
+#include <sys/xattr.h>
 
 void die(const char *msg)
 {
