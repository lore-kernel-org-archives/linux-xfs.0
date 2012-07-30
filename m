Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6U7DJdt001459 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 02:13:19 -0500
Received: from mail-gg0-f181.google.com (mail-gg0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	2L9ys5Ezb6ukqwUL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 00:13:18 -0700 (PDT)
Received: by ggnv5 with SMTP id v5so5587834ggn.26
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 00:13:18 -0700 (PDT)
Date: Mon, 30 Jul 2012 15:14:28 +0800
From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
Mime-Version: 1.0
Message-ID: <201207301514247032532@gmail.com>
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

When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
it will use bi_rw.
Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
>> if ((bvm->bi_rw & 1) == WRITE)
>> return biovec->bv_len; /* always allow writes to be mergeable */


Jianpeng Ma (8):
  Evalue bio->bi_rw after calling bio_alloc() and before calling
    bio_add_page().
  Evalue bio->bi_rw after calling bio_alloc() and before calling    
    bio_add_page().
  Evalue bio->bi_rw after calling bio_alloc() and before calling    
    bio_add_page().
  Evalue bio->bi_rw after calling bio_alloc() and before calling    
    bio_add_page().
  Evalue bio->bi_rw after calling bio_alloc() and before calling    
    bio_add_page().
  Evalue bio->bi_rw after calling bio_alloc() and before calling    
    bio_add_page().
  Evalue bio->bi_rw after calling bio_alloc() and before calling    
    bio_add_page().
  Evalue bio->bi_rw after calling bio_alloc() and before calling    
    bio_add_page().

 block/blk-lib.c                     |    1 +
 drivers/block/xen-blkback/blkback.c |    1 +
 fs/btrfs/check-integrity.c          |    1 +
 fs/direct-io.c                      |    1 +
 fs/ext4/page-io.c                   |    1 +
 fs/jfs/jfs_metapage.c               |    1 +
 fs/ocfs2/cluster/heartbeat.c        |    8 +++++---
 fs/xfs/xfs_aops.c                   |    2 ++
 fs/xfs/xfs_buf.c                    |    1 +
 9 files changed, 14 insertions(+), 3 deletions(-)

-- 
1.7.9.5
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
