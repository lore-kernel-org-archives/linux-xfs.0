Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48542 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752034AbdLFRyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 12:54:07 -0500
Date: Wed, 6 Dec 2017 09:54:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libhandle: zap fdhash_head in fshandle_destroy
Message-ID: <20171206175401.GK19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Set fdhash_head to zero once we've destroyed the handle list to avoid
dangling pointer problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libhandle/handle.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/libhandle/handle.c b/libhandle/handle.c
index e6971dd..878d14d 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -73,6 +73,7 @@ fshandle_destroy(void)
 		free(h);
 		h = nexth;
 	}
+	fdhash_head = NULL;
 }
 
 int
