Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK9FG7T133671 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 03:15:16 -0600
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id uvvRfld56XuJhYGE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:17:25 -0800 (PST)
Received: by mail-pb0-f53.google.com with SMTP id jt11so4740098pbb.26
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:17:25 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 4/4][RFC] ocfs2: remove duplicated check from ocfs2_fallocate
Date: Tue, 20 Nov 2012 17:29:45 +0800
Message-Id: <1353403785-3489-5-git-send-email-wenqing.lz@taobao.com>
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

Remove a sanity check from ocfs2_fallocate because vfs has already checked it.

Reported-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ocfs2/file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 5a4ee77..2446efa 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2001,8 +2001,6 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
 	int change_size = 1;
 	int cmd = OCFS2_IOC_RESVSP64;
 
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
 	if (!ocfs2_writes_unwritten_extents(osb))
 		return -EOPNOTSUPP;
 
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
