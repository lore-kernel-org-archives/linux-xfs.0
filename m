Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6U7Eilo001645 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 02:14:44 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id CfL2DoA1jclL6tsh
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Jul 2012 00:14:43 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so11633236pbb.26
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 00:14:43 -0700 (PDT)
Date: Mon, 30 Jul 2012 15:15:52 +0800
From: kedacomkernel <kedacomkernel@gmail.com>
Subject: [PATCH 1/8] Evalue bio->bi_rw after calling bio_alloc() and before
	calling bio_add_page().
Mime-Version: 1.0
Message-ID: <201207301515481405853@gmail.com>
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
To: axboe <axboe@kernel.dk>, "konrad.wilk" <konrad.wilk@oracle.com>, "chris.mason" <chris.mason@fusionio.com>, viro <viro@ZenIV.linux.org.uk>, tytso <tytso@mit.edu>, "adilger.kernel" <adilger.kernel@dilger.ca>, shaggy <shaggy@kernel.org>, mfasheh <mfasheh@suse.com>, jlbec <jlbec@evilplan.org>, bpm <bpm@sgi.com>, elder <elder@kernel.org>
Cc: jfs-discussion <jfs-discussion@lists.sourceforge.net>, linux-kernel <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, ocfs2-devel <ocfs2-devel@oss.oracle.com>

Because call bio_alloc, the bi_rw is zero by default,but in bio_add_page
used the bi_rw. So evalue bi_rw.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/blk-lib.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..fac777b 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -151,6 +151,7 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		bio->bi_bdev   = bdev;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_private = &bb;
+		bio->bi_rw = WRITE;
 
 		while (nr_sects != 0) {
 			sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
-- 
1.7.9.5
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
