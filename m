Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE59F7F52
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 01:37:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B586AC001
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 23:37:27 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 5XHcEfzVKive4CI4 for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 23:37:26 -0700 (PDT)
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 4/4] userns: eofblocks: convert project id from user to kernel
	space
Date: Wed, 4 Sep 2013 14:38:37 +0800
Message-Id: <1378276717-9663-5-git-send-email-gaofeng@cn.fujitsu.com>
In-Reply-To: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
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
Cc: bfoster@redhat.com, dwight.engen@oracle.com, ebiederm@xmission.com, Gao feng <gaofeng@cn.fujitsu.com>

Convert project id from user to kernel space in
xfs_fs_eofblocks_from_user.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 fs/xfs/xfs_icache.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 8a89f7d..aeedfc8 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -80,7 +80,6 @@ xfs_fs_eofblocks_from_user(
 		return EINVAL;
 
 	dst->eof_flags = src->eof_flags;
-	dst->eof_prid = src->eof_prid;
 	dst->eof_min_file_size = src->eof_min_file_size;
 
 	dst->eof_uid = INVALID_UID;
@@ -96,6 +95,14 @@ xfs_fs_eofblocks_from_user(
 		if (!gid_valid(dst->eof_gid))
 			return EINVAL;
 	}
+
+	dst->eof_prid = src->eof_prid;
+	if (src->eof_flags & XFS_EOF_FLAGS_PRID) {
+		if (xfs_convert_to_kernel_projid(src->eof_prid,
+						 &dst->eof_prid) < 0)
+			return EINVAL;
+	}
+
 	return 0;
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
