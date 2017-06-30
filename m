Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38136 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdF3RI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 13:08:59 -0400
Date: Fri, 30 Jun 2017 10:08:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: fix fsmap.h inclusion
Message-ID: <20170630170855.GO5874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

If we /do/ have HAVE_GETFSMAP defined, we need to include linux/fsmap.h.

Found-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/linux.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux.h b/include/linux.h
index 92f291d..6ce344c 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -222,7 +222,9 @@ struct fsxattr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
-#ifndef HAVE_GETFSMAP
+#ifdef HAVE_GETFSMAP
+# include <linux/fsmap.h>
+#else
 /*
  *	Structure for FS_IOC_GETFSMAP.
  *
