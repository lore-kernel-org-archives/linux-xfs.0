Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0EC917F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 16:11:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F20538F8035
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 14:11:39 -0800 (PST)
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [ 3.5.y.z extended stable ] Patch "xfs: Fix possible use-after-free
	with AIO" has been added to staging queue
Date: Thu, 31 Jan 2013 20:11:34 -0200
Message-Id: <1359670294-17925-1-git-send-email-herton.krzesinski@canonical.com>
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
To: Jan Kara <jack@suse.cz>
Cc: Ben Myers <bpm@sgi.com>, Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>, kernel-team@lists.ubuntu.com, xfs@oss.sgi.com

This is a note to let you know that I have just added a patch titled

    xfs: Fix possible use-after-free with AIO

to the linux-3.5.y-queue branch of the 3.5.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.5.y-queue

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.5.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Herton

------

>From 4bf193f525ba48ec92bd710b6f2298c24f6c83a6 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 23 Jan 2013 13:56:18 +0100
Subject: [PATCH] xfs: Fix possible use-after-free with AIO

commit 4b05d09c18d9aa62d2e7fb4b057f54e5a38963f5 upstream.

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: xfs@oss.sgi.com
CC: Ben Myers <bpm@sgi.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/xfs/xfs_aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8dad722..6868548 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -86,11 +86,11 @@ xfs_destroy_ioend(
 	}

 	if (ioend->io_iocb) {
+		inode_dio_done(ioend->io_inode);
 		if (ioend->io_isasync) {
 			aio_complete(ioend->io_iocb, ioend->io_error ?
 					ioend->io_error : ioend->io_result, 0);
 		}
-		inode_dio_done(ioend->io_inode);
 	}

 	mempool_free(ioend, xfs_ioend_pool);
--
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
