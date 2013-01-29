Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9085D7F4E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 17:28:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAFD6AC006
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:28:18 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id URXJ3LTZR4dmzlqT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2013 15:28:17 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] xfs: Fix possible use-after-free with AIO
Date: Wed, 30 Jan 2013 00:27:59 +0100
Message-Id: <1359502081-20240-3-git-send-email-jack@suse.cz>
In-Reply-To: <1359502081-20240-1-git-send-email-jack@suse.cz>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: xfs@oss.sgi.com
CC: Ben Myers <bpm@sgi.com>
CC: stable@vger.kernel.org
Reviewed-by: Ben Myers <bpm@sgi.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4111a40..5f707e5 100644
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
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
