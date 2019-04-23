Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39424 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfDWVEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 17:04:14 -0400
Date: Tue, 23 Apr 2019 14:04:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/10] libfrog: fix memory leak in bitmap_free
Message-ID: <20190423210409.GC178290@magnolia>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155594788997.115924.16224143537288136652.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Free the bitmap struct before we null out the caller's pointer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bitmap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index aecdba0d..450ebe0a 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -104,6 +104,7 @@ bitmap_free(
 		free(ext);
 	}
 	free(bmap->bt_tree);
+	free(bmap);
 	*bmapp = NULL;
 }
 
