Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6U7NGCE002554 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 02:23:16 -0500
Received: from mail-gg0-f181.google.com (mail-gg0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	GxfFTXVlRXefFqHC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 00:23:16 -0700 (PDT)
Received: by mail-gg0-f181.google.com with SMTP id v5so5594436ggn.26
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 00:23:16 -0700 (PDT)
Date: Mon, 30 Jul 2012 15:24:24 +0800
From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 5/8]fs/ext4: Evalue bio->bi_rw after calling bio_alloc() and
	before calling bio_add_page().
Mime-Version: 1.0
Message-ID: <2012073015241559305016@gmail.com>
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
 fs/ext4/page-io.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index dcdeef1..c875502 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -304,6 +304,7 @@ static int io_submit_init(struct ext4_io_submit *io,
 	io->io_bio = bio;
 	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
 	io->io_next_block = bh->b_blocknr;
+	bio->bi_rw = io->io_op;
 	return 0;
 }
 
-- 
1.7.9.5
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
