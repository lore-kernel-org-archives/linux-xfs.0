Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48177 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755309AbcKWCML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 21:12:11 -0500
Subject: [PATCH ] xfs: always succeed when deduping zero bytes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 22 Nov 2016 18:12:07 -0800
Message-ID: <147986712771.27265.15625188791039802671.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

It turns out that btrfs and xfs had differing interpretations of what
to do when the dedupe length is zero.  Change xfs to follow btrfs'
semantics so that the userland interface is consistent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a279b4e..9989f3e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1345,8 +1345,14 @@ xfs_reflink_remap_range(
 		goto out_unlock;
 	}
 
-	if (len == 0)
+	/* Zero length dedupe exits immediately; reflink goes to EOF. */
+	if (len == 0) {
+		if (is_dedupe) {
+			ret = 0;
+			goto out_unlock;
+		}
 		len = isize - pos_in;
+	}
 
 	/* Ensure offsets don't wrap and the input is inside i_size */
 	if (pos_in + len < pos_in || pos_out + len < pos_out ||

