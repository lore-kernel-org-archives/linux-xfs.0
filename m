Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 163AA7F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 20:40:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5BECAC008
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 18:40:26 -0700 (PDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
	by cuda.sgi.com with ESMTP id 6zirCb2jYLXVrQgd (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 18:40:22 -0700 (PDT)
Message-ID: <55F0DF7A.7050404@huawei.com>
Date: Thu, 10 Sep 2015 09:40:10 +0800
From: Zhaohongjiang <zhaohongjiang@huawei.com>
MIME-Version: 1.0
Subject: [PATCH] cancel the setfilesize transation when io error happen
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
To: david@fromorbit.com, hch@infradead.org
Cc: xfs@oss.sgi.com

When I ran xfstest/073 case, the remount process was blocked to wait
transactions to be zero. I found there was a io error happened, and the
setfilesize transaction was not released properly. We should add the
changes to cancel the io error in this case.

Reproduction steps:
1. dd if=/dev/zero of=xfs1.img bs=1M count=2048
2. mkfs.xfs xfs1.img
3. losetup -f ./xfs1.img /dev/loop0
4. mount -t xfs /dev/loop0 /home/test_dir/
5. mkdir /home/test_dir/test
6. mkfs.xfs -dfile,name=image,size=2g
7. mount -t xfs -o loop image /home/test_dir/test
8. cp a file bigger than 2g to /home/test_dir/test
9. mount -t xfs -o remount,ro /home/test_dir/test

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 fs/xfs/xfs_aops.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 50ab287..fab55da 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -212,8 +212,21 @@ xfs_end_io(
 		ioend->io_error = -EIO;
 		goto done;
 	}
-	if (ioend->io_error)
+	if (ioend->io_error) {
+		/*
+		 * We should cancel the setfilesize transation when io error
+		 * happen.
+		 */
+		if (ioend->io_append_trans) {
+			current_set_flags_nested(&ioend->io_append_trans->t_pflags,
+								PF_FSTRANS);
+			rwsem_acquire_read(&VFS_I(XFS_I(ioend->io_inode))->i_sb
+				->s_writers.lock_map[SB_FREEZE_FS-1], 0, 1, _THIS_IP_);
+			xfs_trans_cancel(ioend->io_append_trans);			
+		}
+
 		goto done;
+	}

 	/*
 	 * For unwritten extents we need to issue transactions to convert a
-- 
1.8.3.1
-- 
version="9"
logging="no"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
