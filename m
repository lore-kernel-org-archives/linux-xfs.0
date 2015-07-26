Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5011E29DFC
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 07:21:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 301768F8033
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 05:21:08 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id T0ENcSnmQBUnsdbT (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 05:21:07 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] xfsprogs: define NBBY if not defined by the system header
	files
Date: Sun, 26 Jul 2015 08:20:50 -0400
Message-Id: <1437913255-7524-2-git-send-email-tytso@mit.edu>
In-Reply-To: <1437913255-7524-1-git-send-email-tytso@mit.edu>
References: <1437913255-7524-1-git-send-email-tytso@mit.edu>
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
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org

Android's bionic libc doesn't define NBBY; this isn't a standard
define, and since all modern/sane platforms have 8 bits per byte, use
this as a default.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 include/platform_defs.h.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index ac260bc..3e059af 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -178,4 +178,8 @@ typedef unsigned short umode_t;
 #define max(a,b)	(((a)>(b))?(a):(b))
 #endif
 
+#ifndef NBBY
+#define NBBY 8
+#endif
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
-- 
2.3.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
