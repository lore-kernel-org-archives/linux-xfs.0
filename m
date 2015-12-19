Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5FEF7F50
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43F26AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:01 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HZQe4ePLPuRd7Cyh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:55:59 -0800 (PST)
Subject: [PATCH 7/9] vfs: wire up compat ioctl for CLONE/CLONE_RANGE
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:55:52 -0800
Message-ID: <20151219085552.12478.82706.stgit@birch.djwong.org>
In-Reply-To: <20151219085505.12478.71157.stgit@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/compat_ioctl.c |    4 ++++
 fs/read_write.c   |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index dcf2653..70d4b10 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1580,6 +1580,10 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
 		goto out_fput;
 #endif
 
+	case FICLONE:
+	case FICLONERANGE:
+		goto do_ioctl;
+
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
diff --git a/fs/read_write.c b/fs/read_write.c
index 6395c733..0713e28 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1489,7 +1489,7 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
-		return -EOPNOTSUPP;
+		return -EINVAL;
 
 	if (!(file_in->f_mode & FMODE_READ) ||
 	    !(file_out->f_mode & FMODE_WRITE) ||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
