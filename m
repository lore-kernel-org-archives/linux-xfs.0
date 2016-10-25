Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46154 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbcJYXFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:05:02 -0400
Subject: [PATCH 13/39] xfs_db: print one array element per line
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:58 -0700
Message-ID: <147743669846.11035.8419161903309169766.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Print one array element per line so that the debugger output isn't
a gigantic pile of screen snow.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/print.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/print.c b/db/print.c
index 998daf4..e31372f 100644
--- a/db/print.c
+++ b/db/print.c
@@ -197,7 +197,7 @@ print_sarray(
 	     i < count && !seenint();
 	     i++, bitoff += size) {
 		if (array)
-			dbprintf("%d:", i + base);
+			dbprintf("\n%d:", i + base);
 		for (f = flds, first = 1; f->name; f++) {
 			if (f->flags & FLD_SKIPALL)
 				continue;

