Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK9FAZ4133641 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 03:15:10 -0600
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id CNEuIJt8NYAhqvBV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:17:19 -0800 (PST)
Received: by mail-pb0-f53.google.com with SMTP id jt11so4740098pbb.26
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:17:19 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/4][RFC] xfs: remove duplicated check from xfs_file_fallocate
Date: Tue, 20 Nov 2012 17:29:43 +0800
Message-Id: <1353403785-3489-3-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

Remove a sanity check from xfs_file_fallocate because vfs has already checked
it.

Reported-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/xfs/xfs_file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa473fa..7b50d12 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -815,9 +815,6 @@ xfs_file_fallocate(
 	int		cmd = XFS_IOC_RESVSP;
 	int		attr_flags = XFS_ATTR_NOLOCK;
 
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
-
 	bf.l_whence = 0;
 	bf.l_start = offset;
 	bf.l_len = len;
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
