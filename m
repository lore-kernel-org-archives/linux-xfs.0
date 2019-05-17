Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36695 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727218AbfEQG7r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 02:59:47 -0400
Date: Fri, 17 May 2019 16:59:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about commit b450672fb66b ("iomap: sub-block dio needs
 to zeroout beyond EOF")
Message-ID: <20190517065943.GC29573@dread.disaster.area>
References: <8b1ba3a1-7ecc-6e1f-c944-26a51baa9747@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b1ba3a1-7ecc-6e1f-c944-26a51baa9747@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, May 17, 2019 at 10:41:44AM +0800, Hou Tao wrote:
> Hi,
> 
> I don't understand why the commit b450672fb66b ("iomap: sub-block dio needs to zeroout beyond EOF") is needed here:
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 72f3864a2e6b..77c214194edf 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1677,7 +1677,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>                 dio->submit.cookie = submit_bio(bio);
>         } while (nr_pages);
> 
> -       if (need_zeroout) {
> +       /*
> +        * We need to zeroout the tail of a sub-block write if the extent type
> +        * requires zeroing or the write extends beyond EOF. If we don't zero
> +        * the block tail in the latter case, we can expose stale data via mmap
> +        * reads of the EOF block.
> +        */
> +       if (need_zeroout ||
> +           ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
>                 /* zero out from the end of the write to the end of the block */
>                 pad = pos & (fs_block_size - 1);
>                 if (pad)
> 
> If need_zeroout is false, it means the block neither is a unwritten block nor
> a newly-mapped block, but that also means the block must had been a unwritten block
> or a newly-mapped block before this write, so the block must have been zeroed, correct ?

No. One the contrary, it's a direct IO write to beyond the end of
the file which means the block has not been zeroed at all. If it is
an unwritten extent, it most definitely does not contain zeroes
(unwritten extents are a flag in the extent metadata, not zeroed
disk space) and so it doesn't matter it is written or unwritten we
must zero it before we update the file size.

Why? Because if we then mmap the page that spans EOF, whatever is on
disk beyond EOF is exposed to the user process. Hence if we don't
zero the tail of the block beyond EOF during DIO writes then we can
leak stale information to unprivileged users....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
