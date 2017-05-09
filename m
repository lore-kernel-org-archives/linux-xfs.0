Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40345 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752541AbdEIMWZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 08:22:25 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 0/8 v7] No wait AIO
Date: Tue,  9 May 2017 07:22:11 -0500
Message-Id: <20170509122219.31756-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com

Formerly known as non-blocking AIO.

This series adds nonblocking feature to asynchronous I/O writes.
io_submit() can be delayed because of a number of reason:
 - Block allocation for files
 - Data writebacks for direct I/O
 - Sleeping because of waiting to acquire i_rwsem
 - Congested block device

The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
any of these conditions are met. This way userspace can push most
of the write()s to the kernel to the best of its ability to complete
and if it returns -EAGAIN, can defer it to another thread.

In order to enable this, IOCB_RW_FLAG_NOWAIT is introduced in
uapi/linux/aio_abi.h. If set for aio_rw_flags, it translates to
IOCB_NOWAIT for struct iocb, REQ_NOWAIT for bio.bi_opf and IOMAP_NOWAIT for
iomap. aio_rw_flags is a new flag replacing aio_reserved1. We could
not use aio_flags because it is not currently checked for invalidity
in the kernel.

This feature is provided for direct I/O of asynchronous I/O only. I have
tested it against xfs, ext4, and btrfs while I intend to add more filesystems.
The nowait feature is for request based devices. In the future, I intend to
add support to stacked devices such as md.

Applications will have to check supportability
by sending a async direct write and any other error besides -EAGAIN
would mean it is not supported.

Changes since v1:
 + changed name from _NONBLOCKING to *_NOWAIT
 + filemap_range_has_page call moved to closer to (just before) calling filemap_write_and_wait_range().
 + BIO_NOWAIT limited to get_request()
 + XFS fixes 
	- included reflink 
	- use of xfs_ilock_nowait() instead of a XFS_IOLOCK_NONBLOCKING flag
	- Translate the flag through IOMAP_NOWAIT (iomap) to check for
	  block allocation for the file.
 + ext4 coding style

Changes since v2:
 + Using aio_reserved1 as aio_rw_flags instead of aio_flags
 + blk-mq support
 + xfs uptodate with kernel and reflink changes

 Changes since v3:
  + Added FS_NOWAIT, which is set if the filesystem supports NOWAIT feature.
  + Checks in generic_make_request() to make sure BIO_NOWAIT comes in
    for async direct writes only.
  + Added QUEUE_FLAG_NOWAIT, which is set if the device supports BIO_NOWAIT.
    This is added (rather not set) to block devices such as dm/md currently.

 Changes since v4:
  + Ported AIO code to use RWF_* flags. Check for RWF_* flags in
    generic_file_write_iter().
  + Changed IOCB_RW_FLAGS_NOWAIT to RWF_NOWAIT.

 Changes since v5:
  + BIO_NOWAIT to REQ_NOWAIT
  + Common helper for RWF flags.

 Changes since v6:
  + REQ_NOWAIT will be ignored for request based devices since they
    cannot block. So, removed QUEUE_FLAG_NOWAIT since it is not
    required in the current implementation. It will be resurrected
    when we program for stacked devices.
  + changed kiocb_rw_flags() to kiocb_set_rw_flags() in order to accomodate
    for errors. Moved checks in the function.

-- 
Goldwyn


