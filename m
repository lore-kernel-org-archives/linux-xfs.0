Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o123WfEm151097 for <xfs@oss.sgi.com>; Mon, 1 Feb 2010 21:32:51 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABF1A1C97ADE
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2010 19:33:20 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	mH24HTzrbIMnKiVN for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2010 19:33:20 -0800 (PST)
Received: by ewy27 with SMTP id 27so955584ewy.18
	for <xfs@oss.sgi.com>; Mon, 01 Feb 2010 19:33:19 -0800 (PST)
From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: [patch 0/7] per-bdi flushing model improvements. reiser4
Date: Tue, 2 Feb 2010 02:55:46 +0100
MIME-Version: 1.0
Message-Id: <201002020255.46920.edward.shishkin@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello.

Andrew Morton wrote:
> reiser4 is currently disabled in -mm (via reiser4-disable.patch)
> because recent changes to fs/fs/writeback.c wrecked the build.  I fixed
> it about ten times as the underlying code was churning, then gave up.  It
> would be nice if you take a look at that sometime please.
>
>

I have taken a look at fs/fs-writeback.c and found that per-superblock
flushing interface is eliminated. However migrating to per-bdi flushing
model doesn't necessarily means that such interface doesn't exist or is
not needed anymore. Flushing in accordance with the scheme "data-inode-
data-inode-..." would be very suboptimal for reiser4. Also xfs people
were unhappy with such flushing model:
http://article.gmane.org/gmane.linux.file-systems/30153

Moreover, current stuff doesn't look fine. Why do we pin/unpin
superblock for every inode? It would be more reasonable to pin it for the
whole group of inodes and call a flushing handler for them. The patch 4
introduces such handler writeback_sb_inodes (which resembles dropped
sync_sb_inodes, the difference is that the newer version doesn't flush
necessarily all inodes of the superblock). Please, consider pushing this
patch to mainline.

The patch 5 adds a super operation .writeback_inodes (former .sync_inodes)
which allows a file system to make optimizations. It can happen that
reiser4 will flush a bit more inodes then generic implementation suggests.
"a bit more" doesn't mean "all dirty inodes of the superblock" (see a
comment about atoms in the header of patch 6).

Finally, some file systems have its own means for periodical writeout
of dirty data. Since b_io contains inodes of many superblocks we need
to evict our inodes back to dirty list when flushing is going on with
for_kupdate flag installed. The new library function
writeback_skip_sb_inodes() provides such possibility.

Please, apply.

Thanks,
Edward.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
