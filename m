Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61326C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 14:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F8A460FD8
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 14:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242883AbhHZOi2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 10:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbhHZOi2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Aug 2021 10:38:28 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B3EC061757
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 07:37:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x16so2963182pfh.2
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 07:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V2HF2Xls84jUZ7suMHbKiqQQLoSKjQ0Sp55OfKg/g+s=;
        b=Dco0Ve1HsF5HR6fQPSDcbsON7RovI6+GXbCjwy05Qf/MIvb+uEReb2jP0tUbbZNBUc
         RDLIpbZxUIgA2DcUbnEPUcoa+gAsV3xXBk0QJbhyJ6AN0mBlTsAOZgRyAYEF+kjGHOUq
         LAYslifFUXbJ5Kk6yi/lbXXokRTgOPv+Y5EQ3uNcweWCWEqgB8Z5VtwNKT+Yx9Jeg74V
         NSoDfvU5VDppT5xzPl0U17d/zETFIEcB8wplMdGZiW+W4bQDUs4XrknFSI+mRn3FrAoY
         ffP5hmJ6LWFsNAaXH9PegEQu0nH284g/XB2yoZc81qwEmGJMYlrhSyIHm3yufqyzLf7N
         vRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V2HF2Xls84jUZ7suMHbKiqQQLoSKjQ0Sp55OfKg/g+s=;
        b=GuCChTTwyO9M3EPyb3+u0cq0BB/CD9tnO25wBtVS82NXA9iucoTN82Y55NaWVpsfj7
         71zv4IejOlCb3lJjT5C+8ad5OSbeQi+dvRwOXg9K4H02qQGjqBgjOi+gzdn+U+vRXLKb
         isky4i8esdPpiNsF/DIMFOhMZB4jxcKaS2Xl3dpaSZSPGvN2VRQpv+/Enqn5nhdJXkZJ
         vxWtyPKOH4dcH9+XIs3ha0IUNA2IE4jZ7rOFiRbqfE9VA8aX7D/Qh0es8w5iLZYz4xp6
         w89LB7KiwAw/87x+3M+A1Jkrs/qh8zS3oF1T6rwsegmFnp/I1qpjpiI8mnqkRU15g+IS
         /KQQ==
X-Gm-Message-State: AOAM533C3wfDaEvRGAdg6hKebqwAunGP3+eHGbgyErjfZ4xcb91XkH0s
        0QCab7AEHLYtUo9Q4UkRKaqKkOjcasfXkvDGNLlXQA==
X-Google-Smtp-Source: ABdhPJxMKI6O3/cUhf97XeZzMtCS61IH/s/SfH2Ap1H+km08WqpkwpkZUAqzW4rOPcMFxINeVXaRQxmOOQTgAbmdNrE=
X-Received: by 2002:a65:47c6:: with SMTP id f6mr3651187pgs.450.1629988660383;
 Thu, 26 Aug 2021 07:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210826135510.6293-1-hch@lst.de> <20210826135510.6293-9-hch@lst.de>
In-Reply-To: <20210826135510.6293-9-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 26 Aug 2021 07:37:29 -0700
Message-ID: <CAPcyv4jXAxSABiZ543xDWOnx0xGAq+LqjbQdqjs+6wbFgsqYyg@mail.gmail.com>
Subject: Re: [PATCH 8/9] xfs: factor out a xfs_buftarg_is_dax helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[ add Darrick ]


On Thu, Aug 26, 2021 at 7:07 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Refactor the DAX setup code in preparation of removing
> bdev_dax_supported.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/xfs/xfs_super.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Darrick, any concerns with me taking this through the dax tree?

>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2c9e26a44546..5a89bf601d97 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -314,6 +314,14 @@ xfs_set_inode_alloc(
>         return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
>  }
>
> +static bool
> +xfs_buftarg_is_dax(
> +       struct super_block      *sb,
> +       struct xfs_buftarg      *bt)
> +{
> +       return bdev_dax_supported(bt->bt_bdev, sb->s_blocksize);
> +}
> +
>  STATIC int
>  xfs_blkdev_get(
>         xfs_mount_t             *mp,
> @@ -1549,11 +1557,10 @@ xfs_fs_fill_super(
>                 xfs_warn(mp,
>                 "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>
> -               datadev_is_dax = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
> -                       sb->s_blocksize);
> +               datadev_is_dax = xfs_buftarg_is_dax(sb, mp->m_ddev_targp);
>                 if (mp->m_rtdev_targp)
> -                       rtdev_is_dax = bdev_dax_supported(
> -                               mp->m_rtdev_targp->bt_bdev, sb->s_blocksize);
> +                       rtdev_is_dax = xfs_buftarg_is_dax(sb,
> +                                               mp->m_rtdev_targp);
>                 if (!rtdev_is_dax && !datadev_is_dax) {
>                         xfs_alert(mp,
>                         "DAX unsupported by block device. Turning off DAX.");
> --
> 2.30.2
>
>
