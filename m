Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10F1C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 22:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C51661130
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 22:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhHTW7x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 18:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbhHTW7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Aug 2021 18:59:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEBEC061575
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 15:59:14 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f3so6822688plg.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 15:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4J9u3EAGcrYRrFr9a28F3qghmkpi2i6oIZ8UbGMRg5Q=;
        b=anEFs1UiP9dfKz4P/uHPE9kEqv7MkVMmOpvTAzqV08rYDche7b0ksSUnfNPfaCpgzP
         e9o7hblx+hLz5Nl60I6+hAR3wChILzkxma984XnglnGUVjrxySBf9RHwcnCyvmHR0E3D
         /PO4zKOIZ00vbiCJCST1mcmqExfELWV35I4c28sImt4NeEjmuyoqAo4veMcamynIXSly
         N374deXmUfZlN3MdOJk8WH+CtiC6uTHGByFsY0+nzx9U5qO6R2wXluoewcgzM1QD9Uqk
         vDn3TqmthLxUy2TNMDmX+v1WaZ3As1fJ46enIH2XqW2Cm8fX2W+a1rUf0UBQqimRAjvl
         /C9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4J9u3EAGcrYRrFr9a28F3qghmkpi2i6oIZ8UbGMRg5Q=;
        b=DYIe+kFs920OmR0sce688oX8mVZMg1LfPVN3pR4ALdOL0oBwybX42CapqdnzFP9jfy
         I6ZC+1elr+sU05p30MK857+3J9ZvwfQRJHnBRCM+FvUJm9lcNlw4DDxU6f3bgRsAwsB8
         DgEEQ6HXZS1ymQzegitKca6F35FhsBjOWWeucNYhRG2sVHvQVVOuJnceMGbC1opoi0yX
         bF4MmFaOlfJu+1HneJv5iN5BZa4K2qCy4Zz1DoPBn83djQLKLzFJ51BDLIGtKSVq7pMI
         YEOHs1sd3OaJpPuwLDZsM7pOkb8YKLmudQGa3dSj+Ee21IlSoEhzstGj55C6wAfmoXUR
         V4Ag==
X-Gm-Message-State: AOAM531VErk7/97g9OUNPZ5riNPQvKmLHPic85ipEZ0/zeUGdVDaU2aU
        O4tDMY/Y4nePE1dw7/pPXcBOX4zhk4dzxk+x4xz1kA==
X-Google-Smtp-Source: ABdhPJzmm+ahkZHadNRsrgbZ7uYrM7d7oiVybo+IGZSGhl9C+B3H/3syn4zyd/DiLhslnXQ3Gq0ivqGhKs2WDDhbCAQ=
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr7031600pjk.13.1629500353664;
 Fri, 20 Aug 2021 15:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com> <20210730100158.3117319-7-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-7-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 20 Aug 2021 15:59:02 -0700
Message-ID: <CAPcyv4h8eUKYDz+KLzXeMTEKc03k=8juXtYjYj+XSVQ5ww=KyQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 6/9] xfs: Implement ->notify_failure() for XFS
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> This function is used to handle errors which may cause data lost in
> filesystem.  Such as memory failure in fsdax mode.
>
> If the rmap feature of XFS enabled, we can query it to find files and
> metadata which are associated with the corrupt data.  For now all we do
> is kill processes with that file mapped into their address spaces, but
> future patches could actually do something about corrupt metadata.
>
> After that, the memory failure needs to notify the processes who are
> using those files.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/dax/super.c |  12 ++++
>  fs/xfs/xfs_fsops.c  |   5 ++
>  fs/xfs/xfs_mount.h  |   1 +
>  fs/xfs/xfs_super.c  | 135 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h |  13 +++++
>  5 files changed, 166 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 00c32dfa5665..63f7b63d078d 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -65,6 +65,18 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>         return dax_get_by_host(bdev->bd_disk->disk_name);
>  }
>  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> +
> +void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       dax_set_holder(dax_dev, holder, ops);
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_set_holder);

Small style issue, I'd prefer a pair of functions:

fs_dax_register_holder(struct dax_device *dax_dev, void *holder, const
struct dax_holder_operations *ops)
fs_dax_unregister_holder(struct dax_device *dax_dev)

...rather than open coding unregister as a special set that passes
NULL arguments.

> +void *fs_dax_get_holder(struct dax_device *dax_dev)
> +{
> +       return dax_get_holder(dax_dev);

Does dax_get_holder() have a lockdep_assert to check that the caller
has at least a read_lock? Please add kernel-doc for this api to
indicate the locking context expectations.

The rest of this looks plausibly ok to me, but it would be up to xfs
folks to comment on the details. I'm not entirely comfortable with
these handlers assuming DAX, i.e. they should also one day be useful
for page cache memory failure notifications, but that support can come
later.
