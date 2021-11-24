Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58200C43217
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 02:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhKXC7u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 21:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236615AbhKXC7t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 21:59:49 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E75C061746
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 18:56:40 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so3293566pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 18:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K6aLDxpU5yyseOlKo6rNtA4cugi0ipNPCjlDJmHcgIw=;
        b=ZodTRA+l0cWcfcrO3HjZ5G1YiDvMh60G3gnO10/HB5K3wACoMILqWpq5tyghP5PaAd
         /HwKbMOp519uQpkZTsiaKbJxiO4I4LMxvhZKQ98u2R62HbNgGSXOiBZGNXqPhLpDseTa
         7vzzMoZl4/zH+br0ANjvCl5c9fXM78IWjkNvHtHR5BTyrgEmRWUa/QYkAkFWIBqAi3vh
         b+zNb07awMu9xLTaQ0QBdRnjc+S/g9oqwKglYR/Xxt8j7ck6Lkr6xNcD5O/IUvzABpY5
         Eu59hL+MFPuc5JaG7/+/vAaPPJWsBP2y6puOgx7hXkD43mLwWUFY6ZCNi+QL3gXyrcQM
         vLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K6aLDxpU5yyseOlKo6rNtA4cugi0ipNPCjlDJmHcgIw=;
        b=yR+HEQlN8dC8jDgc3TUcTidpZ57120W3wdcGjKZsHjXHALH7bKg7lrFID1LYPjjlZd
         xOEVEBYk308bKKU9vmhIq1uxTpCD9CgsCiN4q+0SQHR7XXSHJU1XW6rP9Z3YgDYDXB5R
         9i4yhtc/W9XVz+r5kUCkmk98rcexIShN9wBjm/3R0n+qGC5GooXV1qpQ/AsFyUwU3erB
         df31KchXQON6ZZO8/s8RB/JBemY8PVcSDBhP6KQgD29d29SN5mHwnLDRKvpbH4hH55KQ
         lIff+338TMjsI6dEz1P3R/S60ZdND86CqY73iGNQQFhg9F+1UzypKas3OVtJVsoOEZ1I
         Ny6g==
X-Gm-Message-State: AOAM5307RYPVA5CI229t0FcSAF4egM0c4ywN18xsf+QlTWMS2zRG0qPN
        vWImcvTTBxZISIlnpSNc+1x1/9b8yA2NQXgOT+A8Tw==
X-Google-Smtp-Source: ABdhPJzo6eTnlpQwuRFEtmMj42wpPoH8sJWzIsynA2XekOCtzKT4A4dij0QV0bz7WFLT+916AMzKYpVsKpziQJRycmQ=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr3567015pjb.93.1637722600133;
 Tue, 23 Nov 2021 18:56:40 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-26-hch@lst.de>
In-Reply-To: <20211109083309.584081-26-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 23 Nov 2021 18:56:29 -0800
Message-ID: <CAPcyv4jtWzd3c_S1_4fYA1SXTJZfBzP_1xk_OwYkeNp0UhxwSg@mail.gmail.com>
Subject: Re: [PATCH 25/29] dax: return the partition offset from fs_dax_get_by_bdev
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Prepare from removing the block_device from the DAX I/O path by returning

s/from removing/for the removal of/

> the partition offset from fs_dax_get_by_bdev so that the file systems
> have it at hand for use during I/O.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c | 9 ++++++---
>  drivers/md/dm.c     | 4 ++--
>  fs/erofs/internal.h | 2 ++
>  fs/erofs/super.c    | 4 ++--
>  fs/ext2/ext2.h      | 1 +
>  fs/ext2/super.c     | 2 +-
>  fs/ext4/ext4.h      | 1 +
>  fs/ext4/super.c     | 2 +-
>  fs/xfs/xfs_buf.c    | 2 +-
>  fs/xfs/xfs_buf.h    | 1 +
>  include/linux/dax.h | 6 ++++--
>  11 files changed, 22 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index c0910687fbcb2..cc32dcf71c116 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -70,17 +70,20 @@ EXPORT_SYMBOL_GPL(dax_remove_host);
>  /**
>   * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
>   * @bdev: block device to find a dax_device for
> + * @start_off: returns the byte offset into the dax_device that @bdev starts
>   */
> -struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
> +struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev, u64 *start_off)
>  {
>         struct dax_device *dax_dev;
> +       u64 part_size;
>         int id;
>
>         if (!blk_queue_dax(bdev->bd_disk->queue))
>                 return NULL;
>
> -       if ((get_start_sect(bdev) * SECTOR_SIZE) % PAGE_SIZE ||
> -           (bdev_nr_sectors(bdev) * SECTOR_SIZE) % PAGE_SIZE) {
> +       *start_off = get_start_sect(bdev) * SECTOR_SIZE;
> +       part_size = bdev_nr_sectors(bdev) * SECTOR_SIZE;
> +       if (*start_off % PAGE_SIZE || part_size % PAGE_SIZE) {
>                 pr_info("%pg: error: unaligned partition for dax\n", bdev);
>                 return NULL;
>         }
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 282008afc465f..5ea6115d19bdc 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -637,7 +637,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
>                              struct mapped_device *md)
>  {
>         struct block_device *bdev;
> -
> +       u64 part_off;
>         int r;
>
>         BUG_ON(td->dm_dev.bdev);
> @@ -653,7 +653,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
>         }
>
>         td->dm_dev.bdev = bdev;
> -       td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev);
> +       td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev, &part_off);

Perhaps allow NULL as an argument for callers that do not care about
the start offset?


Otherwise, looks good / clever.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
