Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2A6x09032757 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 04:06:59 -0600
From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 27/27] BKL: Remove BKL from xfs
Date: Mon,  2 Nov 2009 11:05:07 +0100
Message-Id: <1257156307-24175-28-git-send-email-jblunck@suse.de>
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
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
To: linux-fsdevel@vger.kernel.org
Cc: Niv Sardi <xaiki@sgi.com>, Matthew Wilcox <matthew@wil.cx>, Felix Blyakher <felixb@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>, Jan Blunck <jblunck@suse.de>, Christoph Hellwig <hch@lst.de>

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/xfs/linux-2.6/xfs_super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 7426166..18a4b8e 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1412,8 +1412,6 @@ xfs_fs_fill_super(
 	int			flags = 0, error = ENOMEM;
 	char			*mtpt = NULL;
 
-	lock_kernel();
-
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
 		goto out;
@@ -1508,7 +1506,6 @@ xfs_fs_fill_super(
 	kfree(mtpt);
 
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
-	unlock_kernel();
 	return 0;
 
  out_filestream_unmount:
@@ -1525,7 +1522,6 @@ xfs_fs_fill_super(
 	kfree(mtpt);
 	kfree(mp);
  out:
-	unlock_kernel();
 	return -error;
 
  fail_vnrele:
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
