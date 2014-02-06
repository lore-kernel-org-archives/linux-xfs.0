Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7DD47F54
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 07:59:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8EC9C30407A
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 05:59:25 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id osY60BjayrbVGyNz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 05:59:23 -0800 (PST)
From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH v2 2/3] src/cloner: use btrfs/ioctl.h header if present
Date: Thu,  6 Feb 2014 14:59:13 +0100
Message-Id: <1391695154-2039-3-git-send-email-ddiss@suse.de>
In-Reply-To: <1391695154-2039-1-git-send-email-ddiss@suse.de>
References: <1391695154-2039-1-git-send-email-ddiss@suse.de>
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
Cc: David Disseldorp <ddiss@suse.de>, dsterba@suse.cz, linux-btrfs@vger.kernel.org

Check for the btrfsprogs-devel ioctl.h header at configure time. Use it
in src/cloner if present, otherwise fall back to using the copied clone
ioctl definitions.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 configure.ac | 1 +
 src/cloner.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/configure.ac b/configure.ac
index bd48fd9..6fba3ad 100644
--- a/configure.ac
+++ b/configure.ac
@@ -30,6 +30,7 @@ AC_HEADER_STDC
     AC_CHECK_HEADERS([	sys/fs/xfs_fsops.h	\
 			sys/fs/xfs_itable.h	\
 			xfs/platform_defs.h	\
+			btrfs/ioctl.h		\
     ])
 
 AC_PACKAGE_NEED_UUIDCOMPARE
diff --git a/src/cloner.c b/src/cloner.c
index dfce837..ccc2354 100644
--- a/src/cloner.c
+++ b/src/cloner.c
@@ -30,6 +30,9 @@
 #include <stdio.h>
 #include <string.h>
 #include <errno.h>
+#ifdef HAVE_BTRFS_IOCTL_H
+#include <btrfs/ioctl.h>
+#else
 
 struct btrfs_ioctl_clone_range_args {
 	int64_t src_fd;
@@ -42,6 +45,7 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_CLONE       _IOW(BTRFS_IOCTL_MAGIC, 9, int)
 #define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
 				   struct btrfs_ioctl_clone_range_args)
+#endif
 
 static void
 usage(char *name, const char *msg)
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
