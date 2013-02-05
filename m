Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E6857F52
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 16:11:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0AE69304053
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 14:11:42 -0800 (PST)
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 65/93] xfs: Fix possible use-after-free with AIO
Date: Tue,  5 Feb 2013 20:06:54 -0200
Message-Id: <1360102042-10732-66-git-send-email-herton.krzesinski@canonical.com>
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Cc: Ben Myers <bpm@sgi.com>, Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

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
