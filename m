Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60110 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932251AbeAXXxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jan 2018 18:53:34 -0500
Subject: [PATCH 2/5] xfs/122: fix xfs header ordering problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 24 Jan 2018 15:53:29 -0800
Message-ID: <151683800942.17051.13963517513340805990.stgit@magnolia>
In-Reply-To: <151683799705.17051.9987269343206294671.stgit@magnolia>
References: <151683799705.17051.9987269343206294671.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS headers are supposed to be included in a certain order so that
inline functions actually compile correctly.  For the most part the
shell feeds us the files in an order that works, but with the addition
of the xfs_dir2_dirblock_bytes function this doesn't always work now.
Therefore, explicitly #include the headers in the required order.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 671a77b..d836670 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -79,6 +79,11 @@ cat >$cprog <<EOF
 #define _GNU_SOURCE
 #include <stdio.h>
 EOF
+# Certain headers must be included in a certain order...
+for hdr in xfs.h xfs_types.h xfs_fs.h xfs_arch.h xfs_format.h; do
+	test -e "/usr/include/xfs/$hdr" && echo "#include <xfs/$hdr>" >> $cprog
+done
+# ...but be sure to pull in any new headers that might show up.
 for hdr in /usr/include/xfs/xfs*.h; do
 	echo "#include <$(echo "$hdr" | sed -e 's|/usr/include/||g')>" >> $cprog
 done

