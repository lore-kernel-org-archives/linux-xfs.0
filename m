Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35755 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752290AbdCEO40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Mar 2017 09:56:26 -0500
Received: by mail-wr0-f173.google.com with SMTP id g10so100947897wrg.2
        for <linux-xfs@vger.kernel.org>; Sun, 05 Mar 2017 06:56:25 -0800 (PST)
Subject: Re: [PATCH 0/8 v2] Non-blocking AIO
References: <20170228233610.25456-1-rgoldwyn@suse.de>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <347d19cb-dbb8-1d4f-dfb5-d1dd820dd65d@scylladb.com>
Date: Sun, 5 Mar 2017 16:56:21 +0200
MIME-Version: 1.0
In-Reply-To: <20170228233610.25456-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org



On 03/01/2017 01:36 AM, Goldwyn Rodrigues wrote:
> This series adds nonblocking feature to asynchronous I/O writes.
> io_submit() can be delayed because of a number of reason:
>   - Block allocation for files
>   - Data writebacks for direct I/O
>   - Sleeping because of waiting to acquire i_rwsem
>   - Congested block device

We've been hit by a few of these so this change is very welcome.

>
> The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
> any of these conditions are met. This way userspace can push most
> of the write()s to the kernel to the best of its ability to complete
> and if it returns -EAGAIN, can defer it to another thread.
>

Is it not possible to push the iocb to a workqueue?  This will allow 
existing userspace to work with the new functionality, unchanged. Any 
userspace implementation would have to do the same thing, so it's not 
like we're saving anything by pushing it there.

> In order to enable this, IOCB_FLAG_NOWAIT is introduced in
> uapi/linux/aio_abi.h which translates to IOCB_NOWAIT for struct iocb,
> BIO_NOWAIT for bio and IOMAP_NOWAIT for iomap.
>
> This feature is provided for direct I/O of asynchronous I/O only. I have
> tested it against xfs, ext4, and btrfs.
>
> Changes since v1:
>   + Forwardported from 4.9.10
>   + changed name from _NONBLOCKING to *_NOWAIT
>   + filemap_range_has_page call moved to closer to (just before) calling filemap_write_and_wait_range().
>   + BIO_NOWAIT limited to get_request()
>   + XFS fixes
> 	- included reflink
> 	- use of xfs_ilock_nowait() instead of a XFS_IOLOCK_NONBLOCKING flag
> 	- Translate the flag through IOMAP_NOWAIT (iomap) to check for
> 	  block allocation for the file.
>   + ext4 coding style

