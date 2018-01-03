Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57786 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbeACSkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 13:40:18 -0500
Subject: [PATCH 1/5] libhandle: zap fdhash in fshandle_destroy
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Jan 2018 10:40:11 -0800
Message-ID: <151500481167.7713.14079138301635732058.stgit@magnolia>
In-Reply-To: <151500479880.7713.6538509149156363572.stgit@magnolia>
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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

