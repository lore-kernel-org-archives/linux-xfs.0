Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6U7MmGh002424 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 02:22:48 -0500
Received: from mail-gg0-f181.google.com (mail-gg0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	scY4y20AYvGBscE9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 00:22:47 -0700 (PDT)
Received: by ggnv5 with SMTP id v5so5594436ggn.26
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 00:22:46 -0700 (PDT)
Date: Mon, 30 Jul 2012 15:23:55 +0800
From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 2/8] drivers/block/xen-blkback:Evalue bio->bi_rw after calling
	bio_alloc() and before calling bio_add_page().
Mime-Version: 1.0
Message-ID: <2012073015233873461213@gmail.com>
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
Cc: jfs-discussion <jfs-discussion@lists.sourceforge.net>, linux-kernel <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

Because call bio_alloc, the bi_rw is zero by default,but in
bio_add_page used the bi_rw. So evalue bi_rw.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 drivers/block/xen-blkback/blkback.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 73f196c..02ca290 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -701,6 +701,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 			bio->bi_private = pending_req;
 			bio->bi_end_io  = end_block_io_op;
 			bio->bi_sector  = preq.sector_number;
+			bio->bi_rw	= operation;
 		}
 
 		preq.sector_number += seg[i].nsec;
-- 
1.7.9.5
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
