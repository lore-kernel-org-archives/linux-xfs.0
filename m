Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48094 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbeJELAM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:12 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 04/15] xfs_db: single-bit bitfields are unsigned
Date: Thu,  4 Oct 2018 23:03:05 -0500
Message-Id: <1538712196-13625-5-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 db/check.c | 4 ++--
 db/io.h    | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/check.c b/db/check.c
index e85afb9..76a833a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -41,8 +41,8 @@ typedef struct inodata {
 	struct inodata	*next;
 	nlink_t		link_set;
 	nlink_t		link_add;
-	char		isdir:1;
-	char		isreflink:1;
+	unsigned char	isdir:1;
+	unsigned char	isreflink:1;
 	char		security;
 	char		ilist;
 	xfs_ino_t	ino;
diff --git a/db/io.h b/db/io.h
index 8d5720b..9fd2651 100644
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
+	unsigned int		ino_crc_ok:1;
+	unsigned int		ino_buf:1;
+	unsigned int		dquot_buf:1;
+	unsigned int		need_crc:1;
 } iocur_t;
 
 #define DB_RING_ADD 1                   /* add to ring on set_cur */
-- 
1.8.3.1
