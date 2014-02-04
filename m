Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 640A17F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:25:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01C4DAC003
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:25:18 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6Hi8otPwcU9eSTip (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 09:25:17 -0800 (PST)
Message-Id: <20140204172516.456901390@bombadil.infradead.org>
Date: Tue, 04 Feb 2014 09:24:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] direct-io: add flag to allow aio writes beyond i_size
References: <20140204172402.380571745@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0001-direct-io-add-flag-to-allow-aio-writes-beyond-i_size.patch
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
Cc: Sergey Meirovich <rathamahata@gmail.com>

Some filesystems can handle direct I/O writes beyond i_size safely,
so allow them to opt into receiving them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/direct-io.c     |   18 ++++++++++++------
 include/linux/fs.h |    3 +++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0e04142..11882e8 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1194,13 +1194,19 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	}
 
 	/*
-	 * For file extending writes updating i_size before data
-	 * writeouts complete can expose uninitialized blocks. So
-	 * even for AIO, we need to wait for i/o to complete before
-	 * returning in this case.
+	 * For file extending writes updating i_size before data writeouts
+	 * complete can expose uninitialized blocks in dumb filesystems.
+	 * In that case we need to wait for I/O completion even if asked
+	 * for an asynchronous write.
 	 */
-	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
-		(end > i_size_read(inode)));
+	if (is_sync_kiocb(iocb))
+		dio->is_async = false;
+	else if (!(dio->flags & DIO_ASYNC_EXTEND) &&
+            (rw & WRITE) && end > i_size_read(inode))
+		dio->is_async = false;
+	else
+		dio->is_async = true;
+
 	dio->inode = inode;
 	dio->rw = rw;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..f8416fd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2526,6 +2526,9 @@ enum {
 
 	/* filesystem does not support filling holes */
 	DIO_SKIP_HOLES	= 0x02,
+
+	/* filesystem can handle aio writes beyond i_size */
+	DIO_ASYNC_EXTEND = 0x04,
 };
 
 void dio_end_io(struct bio *bio, int error);
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
