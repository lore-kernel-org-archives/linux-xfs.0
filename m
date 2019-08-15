Return-Path: linux-xfs-owner@vger.kernel.org
Received: from userp2130.oracle.com ([156.151.31.86]:53108 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfHOPTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 11:19:17 -0400
Subject: [PATCH 3/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Aug 2019 08:19:12 -0700
Message-ID: <156588235283.24775.17750563527287824640.stgit@magnolia>
In-Reply-To: <156588233330.24775.15183725500886844319.stgit@magnolia>
References: <156588233330.24775.15183725500886844319.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the iomap code are moving to fs/iomap/ we have to add new entries
to the aiodio dmesg filter to reflect this.  It's still possible for
filesystems using iomap for directio to cough up WARNings when a direct
write collides with a buffered write, since in some cases we catch that
early enough to have the direct write return EIO.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/filter |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/common/filter b/common/filter
index ed082d24..26fc2132 100644
--- a/common/filter
+++ b/common/filter
@@ -555,6 +555,7 @@ _filter_aiodio_dmesg()
 	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
 	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"
 	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
+	local warn10="WARNING:.*fs/iomap/direct-io\.c:.*iomap_dio_actor.*"
 	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
 	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
 	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#" \
@@ -563,7 +564,8 @@ _filter_aiodio_dmesg()
 	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
 	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
 	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
-	    -e "s#$warn9#Intentional warnings in dio_complete#"
+	    -e "s#$warn9#Intentional warnings in dio_complete#" \
+	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"
 }
 
 # We generate assert related WARNINGs on purpose and make sure test doesn't fail
