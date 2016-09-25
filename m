Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0E337CA0
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 05:10:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 640508F8040
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 03:10:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fv6GhxcDljjeCZ83 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 25 Sep 2016 03:10:09 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] libxcmd: fix counting of xfs entries in fs_table_insert
Date: Sun, 25 Sep 2016 18:09:22 +0800
Message-Id: <1474798162-25960-1-git-send-email-eguan@redhat.com>
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
To: linux-xfs@vger.kernel.org
Cc: billodo@redhat.com, Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Commit bb80e3d6cd04 ("libxcmd: populate fs table with xfs entries
first, foreign entries last") adds a new counter "xfs_fs_count" and
increases the counter when inserting an XFS entry.

But it missed a counter when fs_count is zero (inserting the first
path) and the entry has no FS_FOREIGN bit set, i.e. the first XFS
entry doesn't increase xfs_fs_count.

This results in args_command() mess and infinite loop in xfs/244
when testing v4 XFS (xfs/244 notrun on v5 XFS, but this bug still
reproduces on v5 XFS). e.g.

  mkfs -t xfs -f /dev/sda5
  mount -o pquota /dev/sda5 /mnt/xfs
  mkdir /mnt/xfs/project
  touch /mnt/xfs/project/testfile
  xfs_quota -x -c "project -s -p /mnt/xfs/project/testfile 1" /dev/sda5

Fix it by increasing xfs_fs_count when flags has no FS_FOREIGN bit.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 libxcmd/paths.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 3455217..97f47cf 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -147,7 +147,6 @@ fs_table_insert(
 		memmove(&fs_table[xfs_fs_count + 1], &fs_table[xfs_fs_count],
 			sizeof(fs_path_t)*(fs_count - xfs_fs_count));
 		fs_path = &fs_table[xfs_fs_count];
-		xfs_fs_count++;
 	}
 	fs_path->fs_dir = dir;
 	fs_path->fs_prid = prid;
@@ -159,6 +158,8 @@ fs_table_insert(
 	fs_path->fs_logdev = logdev;
 	fs_path->fs_rtdev = rtdev;
 	fs_count++;
+	if (!(flags & FS_FOREIGN))
+		xfs_fs_count++;
 
 	return 0;
 
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
