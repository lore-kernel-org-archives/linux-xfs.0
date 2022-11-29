Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA99C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 02:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiK2Ch0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 21:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbiK2ChK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 21:37:10 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD62421B0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 18:36:59 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VVyFTwN_1669689415;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VVyFTwN_1669689415)
          by smtp.aliyun-inc.com;
          Tue, 29 Nov 2022 10:36:57 +0800
Date:   Tue, 29 Nov 2022 10:36:55 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: invalidate block device page cache during
 unmount
Message-ID: <Y4VwR531D5nKO6cA@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <166930916399.2061853.16165124824627761814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <166930916399.2061853.16165124824627761814.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 24, 2022 at 08:59:24AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then I see fstests failures on aarch64 (64k pages) that
> trigger on the following sequence:
> 
> mkfs.xfs $dev
> mount $dev $mnt
> touch $mnt/a
> umount $mnt
> xfs_db -c 'path /a' -c 'print' $dev
> 
> 99% of the time this succeeds, but every now and then xfs_db cannot find
> /a and fails.  This turns out to be a race involving udev/blkid, the
> page cache for the block device, and the xfs_db process.
> 
> udev is triggered whenever anyone closes a block device or unmounts it.
> The default udev rules invoke blkid to read the fs super and create
> symlinks to the bdev under /dev/disk.  For this, it uses buffered reads
> through the page cache.
> 
> xfs_db also uses buffered reads to examine metadata.  There is no
> coordination between xfs_db and udev, which means that they can run
> concurrently.  Note there is no coordination between the kernel and
> blkid either.
> 
> On a system with 64k pages, the page cache can cache the superblock and
> the root inode (and hence the root dir) with the same 64k page.  If
> udev spawns blkid after the mkfs and the system is busy enough that it
> is still running when xfs_db starts up, they'll both read from the same
> page in the pagecache.
> 
> The unmount writes updated inode metadata to disk directly.  The XFS
> buffer cache does not use the bdev pagecache, nor does it invalidate the
> pagecache on umount.  If the above scenario occurs, the pagecache no
> longer reflects what's on disk, xfs_db reads the stale metadata, and
> fails to find /a.  Most of the time this succeeds because closing a bdev
> invalidates the page cache, but when processes race, everyone loses.
> 
> Fix the problem by invalidating the bdev pagecache after flushing the
> bdev, so that xfs_db will see up to date metadata.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

> ---
>  fs/xfs/xfs_buf.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index dde346450952..54c774af6e1c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1945,6 +1945,7 @@ xfs_free_buftarg(
>  	list_lru_destroy(&btp->bt_lru);
>  
>  	blkdev_issue_flush(btp->bt_bdev);
> +	invalidate_bdev(btp->bt_bdev);
>  	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
>  
>  	kmem_free(btp);
