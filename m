Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E52C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 14:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1588A2083B
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 14:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X5rMuygv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbgGaODb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 10:03:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727851AbgGaODb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jul 2020 10:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596204208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cps8/F9QZ13raGQ0LNt7ieXiXD83betUld/eJQwHa/g=;
        b=X5rMuygv6oMQ8R7lw9oAuY7MjxI4cxbvFp3xqQSKtByneMhIH1ZV0PW/+ghy8Acd/guXL9
        sopoU1siGkEfnxdbBAfYLpZ3I8JlUBXMpgrvsK9JhQZoNpsBHZlE7QCrt3lKfIlDg4DCwl
        ahjG8xji2/xiIqis5k3d6D7EGK2jRPw=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-CyEUSJdMMpmUkeAaWMaRlA-1; Fri, 31 Jul 2020 10:03:27 -0400
X-MC-Unique: CyEUSJdMMpmUkeAaWMaRlA-1
Received: by mail-oo1-f71.google.com with SMTP id j13so16232408ooe.22
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2020 07:03:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cps8/F9QZ13raGQ0LNt7ieXiXD83betUld/eJQwHa/g=;
        b=Dg5dc/BwktBYKWpVq6/lZfneBp7vOvNbhxYw9/35IgDIyQqqEkoOe4JhzWgkAXXzTh
         azN3T9NaxCuMiJoF8mpUIsJYyErJuLNOoEQBvdr+/FH0mi/t1ABVuX5RMpmGZQQQOBg1
         BLa7uXk8GDanXWUICfm57gkAJruDX+zdTK3PPhtdX+i/cbEL4ymOFiZZmwSzTEXxo1qW
         wSMJdCIahc8hY7zqM981dbCaRBa8hGNJOP/JIstJ6X3prPq7f9wB5KVw5Q3NXfL+Cz04
         k83k3XO0AlN0/0GUEEx7vWeJ28/Y+bbQ6BWRNzPax6k5TtX5Z8nCY06B59TxRhgnMaIg
         EchQ==
X-Gm-Message-State: AOAM531RACKUccVvyO7CooGUmYpR3KuF3GJizw+YvMGNGuug1zUXiCnI
        VyocfDz1YC4t47SqoajpBYn1a4slLacFqkIKnRAwqkmQ1K4ywD3UaP7woGk15IC38wlJ4JL4IUQ
        ZcamReFe4FOUgIcnRzc2rQTrZG9fT7eYnu0Y/
X-Received: by 2002:aca:5cc5:: with SMTP id q188mr2875444oib.10.1596204205914;
        Fri, 31 Jul 2020 07:03:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2o1MCathljqcbxdIfvbrQ4AoMpjkC6t7vNA2UlmPa6Y8MaoCbcKN4WLZ9gni27APqI9VwD7WX0IkKlBrdOtU=
X-Received: by 2002:aca:5cc5:: with SMTP id q188mr2875387oib.10.1596204205391;
 Fri, 31 Jul 2020 07:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200721183157.202276-1-hch@lst.de> <20200721183157.202276-4-hch@lst.de>
In-Reply-To: <20200721183157.202276-4-hch@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Fri, 31 Jul 2020 16:03:13 +0200
Message-ID: <CAHc6FU4KpmW71xA1iX3rPp0evEPoYN3gjcSHt4de+K3R1ZKgEQ@mail.gmail.com>
Subject: Re: [Cluster-devel] [PATCH 3/3] iomap: fall back to buffered writes
 for invalidation failures
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dave Chinner <david@fromorbit.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 21, 2020 at 8:55 PM Christoph Hellwig <hch@lst.de> wrote:
> Failing to invalid the page cache means data in incoherent, which is
> a very bad state for the system.  Always fall back to buffered I/O
> through the page cache if we can't invalidate mappings.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ext4/file.c       |  2 ++
>  fs/gfs2/file.c       |  3 ++-
>  fs/iomap/direct-io.c | 16 +++++++++++-----
>  fs/iomap/trace.h     |  1 +
>  fs/xfs/xfs_file.c    |  4 ++--
>  fs/zonefs/super.c    |  7 +++++--
>  6 files changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2a01e31a032c4c..129cc1dd6b7952 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -544,6 +544,8 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>                 iomap_ops = &ext4_iomap_overwrite_ops;
>         ret = iomap_dio_rw(iocb, from, iomap_ops, &ext4_dio_write_ops,
>                            is_sync_kiocb(iocb) || unaligned_io || extend);
> +       if (ret == -ENOTBLK)
> +               ret = 0;
>
>         if (extend)
>                 ret = ext4_handle_inode_extension(inode, offset, ret, count);
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index bebde537ac8cf2..b085a3bea4f0fd 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -835,7 +835,8 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
>
>         ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL,
>                            is_sync_kiocb(iocb));
> -
> +       if (ret == -ENOTBLK)
> +               ret = 0;
>  out:
>         gfs2_glock_dq(&gh);
>  out_uninit:
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 190967e87b69e4..c1aafb2ab99072 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -10,6 +10,7 @@
>  #include <linux/backing-dev.h>
>  #include <linux/uio.h>
>  #include <linux/task_io_accounting_ops.h>
> +#include "trace.h"
>
>  #include "../internal.h"
>
> @@ -401,6 +402,9 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>   * can be mapped into multiple disjoint IOs and only a subset of the IOs issued
>   * may be pure data writes. In that case, we still need to do a full data sync
>   * completion.
> + *
> + * Returns -ENOTBLK In case of a page invalidation invalidation failure for
> + * writes.  The callers needs to fall back to buffered I/O in this case.
>   */
>  ssize_t
>  iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> @@ -478,13 +482,15 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>         if (iov_iter_rw(iter) == WRITE) {
>                 /*
>                  * Try to invalidate cache pages for the range we are writing.
> -                * If this invalidation fails, tough, the write will still work,
> -                * but racing two incompatible write paths is a pretty crazy
> -                * thing to do, so we don't support it 100%.
> +                * If this invalidation fails, let the caller fall back to
> +                * buffered I/O.
>                  */
>                 if (invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
> -                               end >> PAGE_SHIFT))
> -                       dio_warn_stale_pagecache(iocb->ki_filp);
> +                               end >> PAGE_SHIFT)) {
> +                       trace_iomap_dio_invalidate_fail(inode, pos, count);
> +                       ret = -ENOTBLK;
> +                       goto out_free_dio;
> +               }
>
>                 if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
>                         ret = sb_init_dio_done_wq(inode->i_sb);
> diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
> index 5693a39d52fb63..fdc7ae388476f5 100644
> --- a/fs/iomap/trace.h
> +++ b/fs/iomap/trace.h
> @@ -74,6 +74,7 @@ DEFINE_EVENT(iomap_range_class, name, \
>  DEFINE_RANGE_EVENT(iomap_writepage);
>  DEFINE_RANGE_EVENT(iomap_releasepage);
>  DEFINE_RANGE_EVENT(iomap_invalidatepage);
> +DEFINE_RANGE_EVENT(iomap_dio_invalidate_fail);
>
>  #define IOMAP_TYPE_STRINGS \
>         { IOMAP_HOLE,           "HOLE" }, \
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a6ef90457abf97..1b4517fc55f1b9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -553,8 +553,8 @@ xfs_file_dio_aio_write(
>         xfs_iunlock(ip, iolock);
>
>         /*
> -        * No fallback to buffered IO on errors for XFS, direct IO will either
> -        * complete fully or fail.
> +        * No fallback to buffered IO after short writes for XFS, direct I/O
> +        * will either complete fully or return an error.
>          */
>         ASSERT(ret < 0 || ret == count);
>         return ret;
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 07bc42d62673ce..d0a04528a7e18e 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -786,8 +786,11 @@ static ssize_t zonefs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         if (iocb->ki_pos >= ZONEFS_I(inode)->i_max_size)
>                 return -EFBIG;
>
> -       if (iocb->ki_flags & IOCB_DIRECT)
> -               return zonefs_file_dio_write(iocb, from);
> +       if (iocb->ki_flags & IOCB_DIRECT) {
> +               ssize_t ret = zonefs_file_dio_write(iocb, from);
> +               if (ret != -ENOTBLK)
> +                       return ret;
> +       }
>
>         return zonefs_file_buffered_write(iocb, from);
>  }
> --
> 2.27.0
>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com> # for gfs2

Thanks,
Andreas

