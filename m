Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19881 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751983AbdDJWrz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 18:47:55 -0400
Subject: [PATCH 1/4] xfs_db: don't print arrays off the end of a buffer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 10 Apr 2017 15:47:47 -0700
Message-ID: <149186446737.32572.10101366339282682603.stgit@birch.djwong.org>
In-Reply-To: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
References: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Before printing an array, clamp the array count against the size of the
buffer so that we don't print random heap contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/print.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/db/print.c b/db/print.c
index e31372f..0caad8f 100644
--- a/db/print.c
+++ b/db/print.c
@@ -144,6 +144,17 @@ print_flist_1(
 			if (fl->flags & FL_OKHIGH)
 				count = min(count, fl->high - low + 1);
 			if (fa->prfunc) {
+				int	fsz;
+				int	bitlen;
+
+				/* Don't read an array off the end of the buffer */
+				fsz = fsize(f, iocur_top->data, parentoff, 0);
+				bitlen = iocur_top->len * NBBY;
+				if ((f->flags & FLD_ARRAY) &&
+				    fl->offset + (count * fsz) > bitlen) {
+					count = (bitlen - fl->offset) / fsz;
+				}
+
 				neednl = fa->prfunc(iocur_top->data, fl->offset,
 					count, fa->fmtstr,
 					fsize(f, iocur_top->data, parentoff, 0),

