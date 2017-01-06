Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936776AbdAFKcn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Jan 2017 05:32:43 -0500
Date: Fri, 6 Jan 2017 18:32:39 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: [BUG v4.10-rc1] fzero returns EIO on DAX mount
Message-ID: <20170106103239.GY1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: chaitanya.kulkarni@hgst.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Hi all,

I hit a regression in my xfstests run on DAX mount with 4.10-rc1 and rc2
kernel, some fzero/fpunch/ftruncate operations start returning EIO, extN
and xfs are all affected. 4.9 kernel is doing well.

This is a simple reproducer:

	modprobe brd rd_size=$((1024*1024))
	mkfs -t ext4 -F /dev/ram0
	mount -o dax /dev/ram0 /mnt/ext4
	xfs_io -fc "pwrite 0 1024" -c "fzero 0 1024" /mnt/ext4/testfile

The last xfs_io returns:
	wrote 1024/1024 bytes at offset 0
	1 KiB, 1 ops; 0.0000 sec (17.013 KiB/sec and 17.0132 ops/sec)
	fallocate: Input/output error

And git bisect pointed the first bad commit to

e73c23ff736e1ea371dfa419d7bf8e77ee53044a
Author: Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>
Date:   Wed Nov 30 12:28:58 2016 -0800

    block: add async variant of blkdev_issue_zeroout

    Similar to __blkdev_issue_discard this variant allows submitting
    the final bio asynchronously and chaining multiple ranges
    into a single completion.

    Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jens Axboe <axboe@fb.com>

I've confirmed that "reverting" it fixed all the new test failures, by
"reverting" I mean revert it when it's the top.

A preliminary investigation shows that it's submit_bio_wait() in
blkdev_issue_zeroout() where EIO is returned.

block/blk-lib.c:blkdev_issue_zeroout
        ret = __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask,                                                                                                                         
                        &bio, discard);                                                                                                                                                        
        if (ret == 0 && bio) {                                                                                                                                                                 
                ret = submit_bio_wait(bio);                                                                                                                                                    
                bio_put(bio);                                                                                                                                                                  
        }

Thanks,
Eryu

P.S. failed xfstests cases

xfs:
generic/008 generic/029 generic/030 generic/074 generic/075 generic/086
generic/091 generic/112 generic/127 generic/135 generic/231 generic/263
generic/392 xfs/071 xfs/190 xfs/229 xfs/290

ext4:
generic/008 generic/075 generic/091 generic/112 generic/127 generic/263

ext2,ext3:
generic/091 generic/127 generic/263
