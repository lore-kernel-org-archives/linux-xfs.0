Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE92C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 03:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6399D6108B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 03:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbhHTDB5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237806AbhHTDB4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 23:01:56 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00F7C061756
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 20:01:19 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o10so5215004plg.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 20:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+qoHaIYFFF4+QiXB7j7KUJJJiqOIA/zGN5Tjr436H8=;
        b=kuG8T90/qXgx0IHMQpBfZ+mBvJWi6GWu2OW94VNop4bdF/v0Ajv0stPWwAdY39B7n5
         0aB+dCe80t5j46UCI0ZvrGeJn0mFR9VX8hnhHUJdfbFaCMx8Ho5EDzzMsYlp/3xPaxLp
         j/WFNlI2US+mpDGvS1ZH0lQnqTZSvh7wVwgww7oJS4uXDcSBDIsNWJnDKsF6br0hov4a
         220s+hY2spVwQdy7e4PmmtHuKjhrUBgOXmxZteVxKw0AfKz7XUvv7eyiZialc1aa32ND
         VO3oxca5GGNZpDrFx8Dt2JhAsxvFZSw6J2ewu9KXmYD+BVvuonFZp0Df7/aF1vGZI2u+
         JfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+qoHaIYFFF4+QiXB7j7KUJJJiqOIA/zGN5Tjr436H8=;
        b=JTBiUlibSjae5chpKJs8j5lwPH2zVi3gaIqoovQ4TWLW47nWoMVkos2r1AWOsvdVek
         s8KvKBWETIP1oK5VIdiCz6mPEypD2xgi8hkti07vXF2y8hlR4URgtYR9qD2gVB0liFF9
         ACk3eizqIH5BxAZgNFoMXYKLKrSML9eE5vRAnX3sI4vNBLHvVfWh+P7zh6Tt2xjfIBSL
         6AM2iaNGwHnNhM7ESiIpyM5zF22NZDDRIEr7UMOUD4adfp6Wrj3zKIrrvesivOBlk1YG
         BEK6SozqBLiS/xuOb/CSDUbFpKt6ymFha+akrxEGkrofZ/JTbtQD9G/pzC+xo3991kzs
         oo0Q==
X-Gm-Message-State: AOAM532CmT9NfCc+aYJoYgOKrUfRhvTQjKGieEhV6LVoJYWk5vUwBxlI
        v5axhTjA9e4gZ8xR1oZ2g9Z4fs7QtzarmEpoFUP1Zg==
X-Google-Smtp-Source: ABdhPJz+jFXZsqQZ/gZaDxbc92zc/Y1j4Ft80o1VnMYNl6dPXIcaIjMkAG6+B7QQk+6/6e1OSlMA19PSKXwEaEfrwuU=
X-Received: by 2002:a17:902:9b95:b0:130:6a7b:4570 with SMTP id
 y21-20020a1709029b9500b001306a7b4570mr2784453plp.27.1629428479249; Thu, 19
 Aug 2021 20:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-8-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210816060359.1442450-8-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 19 Aug 2021 20:01:08 -0700
Message-ID: <CAPcyv4jbi=p=SjFYZcHnEAu+KY821pW_k_yA5u6hya4jEfrTUg@mail.gmail.com>
Subject: Re: [PATCH v7 7/8] fsdax: Introduce dax_iomap_ops for end of reflink
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        david <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 15, 2021 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> After writing data, reflink requires end operations to remap those new
> allocated extents.  The current ->iomap_end() ignores the error code
> returned from ->actor(), so we introduce this dax_iomap_ops and change
> the dax_iomap_*() interfaces to do this job.
>
> - the dax_iomap_ops contains the original struct iomap_ops and fsdax
>     specific ->actor_end(), which is for the end operations of reflink
> - also introduce dax specific zero_range, truncate_page
> - create new dax_iomap_ops for ext2 and ext4
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/dax.c               | 68 +++++++++++++++++++++++++++++++++++++-----
>  fs/ext2/ext2.h         |  3 ++
>  fs/ext2/file.c         |  6 ++--
>  fs/ext2/inode.c        | 11 +++++--
>  fs/ext4/ext4.h         |  3 ++
>  fs/ext4/file.c         |  6 ++--
>  fs/ext4/inode.c        | 13 ++++++--
>  fs/iomap/buffered-io.c |  3 +-
>  fs/xfs/xfs_bmap_util.c |  3 +-
>  fs/xfs/xfs_file.c      |  8 ++---
>  fs/xfs/xfs_iomap.c     | 36 +++++++++++++++++++++-
>  fs/xfs/xfs_iomap.h     | 33 ++++++++++++++++++++
>  fs/xfs/xfs_iops.c      |  7 ++---
>  fs/xfs/xfs_reflink.c   |  3 +-
>  include/linux/dax.h    | 21 ++++++++++---
>  include/linux/iomap.h  |  1 +
>  16 files changed, 189 insertions(+), 36 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 74dd918cff1f..0e0536765a7e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1348,11 +1348,30 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>         return done ? done : ret;
>  }
>
> +static inline int
> +__dax_iomap_iter(struct iomap_iter *iter, const struct dax_iomap_ops *ops)
> +{
> +       int ret;
> +
> +       /*
> +        * Call dax_iomap_ops->actor_end() before iomap_ops->iomap_end() in
> +        * each iteration.
> +        */
> +       if (iter->iomap.length && ops->actor_end) {
> +               ret = ops->actor_end(iter->inode, iter->pos, iter->len,
> +                                    iter->processed);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return iomap_iter(iter, &ops->iomap_ops);

This reorganization looks needlessly noisy. Why not require the
iomap_end operation to perform the actor_end work. I.e. why can't
xfs_dax_write_iomap_actor_end() just be the passed in iomap_end? I am
not seeing where the ->iomap_end() result is ignored?
