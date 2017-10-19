Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO11.lge.com ([156.147.23.51]:33882 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbdJSHDb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:03:31 -0400
From: Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v2 3/4] genhd.h: Remove trailing white space
Date: Thu, 19 Oct 2017 16:03:26 +0900
Message-Id: <1508396607-25362-4-git-send-email-byungchul.park@lge.com>
In-Reply-To: <1508396607-25362-1-git-send-email-byungchul.park@lge.com>
References: <1508392531-11284-1-git-send-email-byungchul.park@lge.com>
 <1508396607-25362-1-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: peterz@infradead.org, mingo@kernel.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com

Trailing white space is not accepted in kernel coding style. Remove
them.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 include/linux/genhd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ea652bf..6d85a75 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -3,7 +3,7 @@
 
 /*
  * 	genhd.h Copyright (C) 1992 Drew Eckhardt
- *	Generic hard disk header file by  
+ *	Generic hard disk header file by
  * 		Drew Eckhardt
  *
  *		<drew@colorado.edu>
@@ -471,7 +471,7 @@ struct bsd_disklabel {
 	__s16	d_type;			/* drive type */
 	__s16	d_subtype;		/* controller/d_type specific */
 	char	d_typename[16];		/* type name, e.g. "eagle" */
-	char	d_packname[16];			/* pack identifier */ 
+	char	d_packname[16];			/* pack identifier */
 	__u32	d_secsize;		/* # of bytes per sector */
 	__u32	d_nsectors;		/* # of data sectors per track */
 	__u32	d_ntracks;		/* # of tracks per cylinder */
-- 
1.9.1

