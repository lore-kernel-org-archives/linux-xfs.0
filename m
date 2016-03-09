Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D2DF7CA0
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 17:41:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5344B8F8039
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 15:41:02 -0800 (PST)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id 78jRlqQCRaVItBQT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Mar 2016 15:40:58 -0800 (PST)
Date: Thu, 10 Mar 2016 10:40:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the xfs tree with the ext4 tree
Message-ID: <20160310104056.78033e72@canb.auug.org.au>
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
To: David Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the xfs tree got a conflict in:

  fs/ext4/inode.c

between commit:

  109811c20fb8 ("ext4: simplify io_end handling for AIO DIO")

from the ext4 tree and commit:

  74c66bcb7eda ("ext4: Fix data exposure after failed AIO DIO")

from the xfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

-- 
Cheers,
Stephen Rothwell

diff --cc fs/ext4/inode.c
index 719accce152a,2b98171a9432..000000000000
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@@ -3285,10 -3161,10 +3285,10 @@@ out
  }
  #endif
  
- static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
+ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
  			    ssize_t size, void *private)
  {
 -        ext4_io_end_t *io_end = iocb->private;
 +        ext4_io_end_t *io_end = private;
  
  	/* if not async direct IO just return */
  	if (!io_end)
@@@ -3296,8 -3172,18 +3296,16 @@@
  
  	ext_debug("ext4_end_io_dio(): io_end 0x%p "
  		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
 - 		  iocb->private, io_end->inode->i_ino, iocb, offset,
 -		  size);
 +		  io_end, io_end->inode->i_ino, iocb, offset, size);
  
 -	iocb->private = NULL;
+ 	/*
+ 	 * Error during AIO DIO. We cannot convert unwritten extents as the
+ 	 * data was not written. Just clear the unwritten flag and drop io_end.
+ 	 */
+ 	if (size <= 0) {
+ 		ext4_clear_io_unwritten_flag(io_end);
+ 		size = 0;
+ 	}
  	io_end->offset = offset;
  	io_end->size = size;
  	ext4_put_io_end(io_end);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
