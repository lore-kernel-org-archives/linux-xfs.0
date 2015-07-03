Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 913C97FED
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:15:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F900304048
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:15:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VnDSmccJBcvsU95Z (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:15:22 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAy09-0003nz-H2
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:15:22 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/13] xfsprogs: remove filldir_t typedef
Date: Fri,  3 Jul 2015 12:12:20 +0200
Message-Id: <1435918341-10128-13-git-send-email-hch@lst.de>
In-Reply-To: <1435918341-10128-1-git-send-email-hch@lst.de>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index fc7e01a..7ded23e 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -36,8 +36,6 @@
 #include <limits.h>
 #include <stdbool.h>
 
-typedef struct filldir		filldir_t;
-
 /* long and pointer must be either 32 bit or 64 bit */
 #undef SIZEOF_LONG
 #undef SIZEOF_CHAR_P
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
