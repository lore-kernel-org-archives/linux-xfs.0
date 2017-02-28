Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751478AbdB1XlT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 18:41:19 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 0/8 v2] Non-blocking AIO
Date: Tue, 28 Feb 2017 17:36:02 -0600
Message-Id: <20170228233610.25456-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

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

In order to enable this, IOCB_FLAG_NOWAIT is introduced in
uapi/linux/aio_abi.h which translates to IOCB_NOWAIT for struct iocb,
BIO_NOWAIT for bio and IOMAP_NOWAIT for iomap.

This feature is provided for direct I/O of asynchronous I/O only. I have
tested it against xfs, ext4, and btrfs.

Changes since v1:
 + Forwardported from 4.9.10
 + changed name from _NONBLOCKING to *_NOWAIT
 + filemap_range_has_page call moved to closer to (just before) calling filemap_write_and_wait_range().
 + BIO_NOWAIT limited to get_request()
 + XFS fixes 
	- included reflink 
	- use of xfs_ilock_nowait() instead of a XFS_IOLOCK_NONBLOCKING flag
	- Translate the flag through IOMAP_NOWAIT (iomap) to check for
	  block allocation for the file.
 + ext4 coding style
-- 
Goldwyn


