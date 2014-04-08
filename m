Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D1BF480E7
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:25:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA155304089
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:25:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ld11IcOboN44jPE9 for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:25:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/14] xfsprogs: fix memory leak in xlog_recover_add_to_trans
Date: Tue,  8 Apr 2014 18:24:54 -0500
Message-Id: <1396999504-13769-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
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

Free the memory in error path of xlog_recover_add_to_trans().
Normally this memory is freed in recovery pass2, but is leaked
in the error path.

Userspace version of kernel commits 519ccb8 & aaaae98

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxlog/xfs_log_recover.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 3f22921..d1fa535 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1131,6 +1131,7 @@ xlog_recover_add_to_trans(
 		"bad number of regions (%d) in inode log format",
 				  in_f->ilf_size);
 			ASSERT(0);
+			kmem_free(ptr);
 			return XFS_ERROR(EIO);
 		}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
