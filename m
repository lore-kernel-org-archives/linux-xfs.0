Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6293 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751927AbdFVRDv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 13:03:51 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] xfs_io: add seek consistency checks
Date: Thu, 22 Jun 2017 19:03:48 +0200
Message-Id: <1498151028-18433-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, fstests@vger.kernel.org, Jan Kara <jack@suse.cz>

When seeking for data and holes, the lseek result must be greater than
or equal to the start offset.  Furthermore, assuming that the file
doesn't change under us, when switching between SEEK_HOLE and SEEK_DATA,
the seek position must increase monotonically.  Warn and abort if this
is not the case.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 io/seek.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io/seek.c b/io/seek.c
index d06375d..871b472 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -147,7 +147,10 @@ seek_f(
 	 * decide if we want to display that type of entry.
 	 */
 	if (flag & SEEK_HFLAG) {
+		current = HOLE;
 		offset = lseek(file->fd, start, SEEK_HOLE);
+		if (offset != -1 && offset < start)
+			goto bad_result;
 		if ((start == offset) || !(flag & SEEK_DFLAG)) {
 			/*
 			 * this offset is a hole or are only displaying holes.
@@ -155,7 +158,6 @@ seek_f(
 			 * data, then we will fall through below to
 			 * initialize the data search.
 			 */
-			current = HOLE;
 			goto found_hole;
 		}
 	}
@@ -163,6 +165,8 @@ seek_f(
 	/* The offset is not a hole, or we are looking just for data */
 	current = DATA;
 	offset = lseek(file->fd, start, SEEK_DATA);
+	if (offset != -1 && offset < start)
+		goto bad_result;
 
 found_hole:
 	/*
@@ -203,8 +207,15 @@ found_hole:
 		current ^= 1;		/* alternate between data and hole */
 		start = offset;
 		offset = lseek(file->fd, start, seekinfo[current].seektype);
+		if (offset != -1 && offset <= start)
+			goto bad_result;
 	}
 	return 0;
+
+bad_result:
+	fprintf(stderr, "Invalid seek result: lseek(<fd>, %lld, SEEK_%s) = %lld\n",
+		(long long)start, seekinfo[current].name, (long long)offset);
+	return 0;
 }
 
 void
-- 
2.7.5

