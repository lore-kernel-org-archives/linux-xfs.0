Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56194 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbeJKDZU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:20 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/18] xfs_db: convert single-bit bitfields  to bools
Date: Wed, 10 Oct 2018 15:01:06 -0500
Message-Id: <1539201682-22198-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Sparse doesn't like signed single-bit bitfields, and they may as well
just be booleans.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/check.c | 4 ++--
 db/io.h    | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/check.c b/db/check.c
index e0fd986..683e176 100644
--- a/db/check.c
+++ b/db/check.c
@@ -41,8 +41,8 @@ typedef struct inodata {
 	struct inodata	*next;
 	nlink_t		link_set;
 	nlink_t		link_add;
-	char		isdir:1;
-	char		isreflink:1;
+	bool		isdir;
+	bool		isreflink;
 	char		security;
 	char		ilist;
 	xfs_ino_t	ino;
diff --git a/db/io.h b/db/io.h
index 8d5720b..7618be4 100644
--- a/db/io.h
+++ b/db/io.h
@@ -26,10 +26,10 @@ typedef struct iocur {
 	const struct typ	*typ;	/* type of "data" */
 	bbmap_t			*bbmap;	/* map daddr if fragmented */
 	struct xfs_buf		*bp;	/* underlying buffer */
-	int			ino_crc_ok:1;
-	int			ino_buf:1;
-	int			dquot_buf:1;
-	int			need_crc:1;
+	bool			ino_crc_ok;
+	bool			ino_buf;
+	bool			dquot_buf;
+	bool			need_crc;
 } iocur_t;
 
 #define DB_RING_ADD 1                   /* add to ring on set_cur */
-- 
1.8.3.1
