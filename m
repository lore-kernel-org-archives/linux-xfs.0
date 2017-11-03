Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46568 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdKCE0Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 00:26:24 -0400
Date: Thu, 2 Nov 2017 21:26:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 12/14] generic/204: use available blocks to determine the
 number of files to create
Message-ID: <20171103042619.GB1233@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957286222.18388.3253654888670864191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150957286222.18388.3253654888670864191.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the available block count to compute the number of files we think
we can create, rather than hardcoding a particular size.  This fixes
the ENOSPC failures for xfs filesystems with rmap/reflink support.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/204 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/204 b/tests/generic/204
index 4c203a2..ac417a7 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -69,7 +69,7 @@ _scratch_mount
 # work out correctly. Space usages is based 22500 files and 1024 reserved blocks
 # on a 4k block size 256 byte inode size filesystem.
 resv_blks=1024
-space=97920000
+space=$(stat -f -c '%f * %S' $SCRATCH_MNT | $BC_PROG)
 
 # decrease files for inode size.
 #	22500 * (256 + 4k) = ~97MB
