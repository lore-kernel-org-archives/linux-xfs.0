Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBFFC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 23:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8024760F56
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 23:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhJ0XJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Oct 2021 19:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhJ0XJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Oct 2021 19:09:44 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F80C061570
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 16:07:18 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v20so3072922plo.7
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 16:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3af0vrDw+XvQKylIm0LDLH9D6xoJ74LhsidYuXkOM7g=;
        b=d6phRBLSNqEavLbFGa7qsltfCwCXOIkQGNewJdYfiMwINhHDbJ+v3Tvr+m7SXCKglh
         f1Y9JyoYsY7pru2o0qaf9ZrRobsN47Jue96kM8PwOADE6VAIkbXtDJTZy+mzrce1H5ii
         TDWfFC/E9fe8cXOG72hb4HndsLJ5qovtA1WXr8x1UXXNXsg6OU7/y9sWKZsB9Ro8FzaF
         3kotXlCmovzhrPQGnkvqh1aQ4+kBEwqSKMSlKnEz5Ahj4QsLMDMTI4jX5+IsmEJsZDOu
         D4ACx/M3ONMf14xOrt8n/jVyvHMKdyB04vPcp4aB9RBAawLg1e2wm7UXNUEREJEycjA9
         pSnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3af0vrDw+XvQKylIm0LDLH9D6xoJ74LhsidYuXkOM7g=;
        b=Mh1DI1rV4wfKGZa0SL0isUYkTY1o8xg5Op9/CTdCbnpwjSt7clsGaPSzCdBp8zW3m6
         Vo6AlSF9FCsTLG63l6qQat6UiDoG4vDJ9Us59aOdrJ67GdztP71LIK0kgqOpibv/pXV5
         A9GJNAbGtchMC02vQkIMS7qscDWWNR4/aRg39ihxsKnN0IYpTN0oCKeOEcuhLdcbeBWC
         JL7wWt9IpYFr1GYbRgPqM9xTugDgpaNxcBb1Oke7rtFbW9NbgAFxN+eV10xYHSKZfBqT
         0JUbm/XrQ5QqmMeCgmYonztkRmcPyvwjjsEc8yjnpJfGh146WAHBuY+h/afVMudZ1rlf
         9jrw==
X-Gm-Message-State: AOAM533KgoKnGCm5TOOA9n6MBGICHRGD68fXH7+/VNJsckmuS4SBAYSm
        EeF8EXeOTzf3nAuObilwz6TwayX2Bwtkfi4Gjx/fhQ==
X-Google-Smtp-Source: ABdhPJxTOfk9fcqxHjqgG3f1vnNsNPlrTHxqnz6/LIE7U1wpYxfkWo7JAy9TqN/B72HDrJA9DjHrJAEIhgWs2Md2+FA=
X-Received: by 2002:a17:90b:350f:: with SMTP id ls15mr618659pjb.220.1635376038542;
 Wed, 27 Oct 2021 16:07:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-6-hch@lst.de>
In-Reply-To: <20211018044054.1779424-6-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 27 Oct 2021 16:07:07 -0700
Message-ID: <CAPcyv4iqkLQWEyqRYZPaBmA=bXyJy5DR699ch+wfBanY-MKu9g@mail.gmail.com>
Subject: Re: [PATCH 05/11] dax: move the partition alignment check into fs_dax_get_by_bdev
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

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> fs_dax_get_by_bdev is the primary interface to find a dax device for a
> block device, so move the partition alignment check there instead of
> wiring it up through ->dax_supported.

Looks good.

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c | 23 ++++++-----------------
>  1 file changed, 6 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 04fc680542e8d..482fe775324a4 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -93,6 +93,12 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>         if (!blk_queue_dax(bdev->bd_disk->queue))
>                 return NULL;
>
> +       if ((get_start_sect(bdev) * SECTOR_SIZE) % PAGE_SIZE ||
> +           (bdev_nr_sectors(bdev) * SECTOR_SIZE) % PAGE_SIZE) {
> +               pr_info("%pg: error: unaligned partition for dax\n", bdev);
> +               return NULL;
> +       }
> +
>         id = dax_read_lock();
>         dax_dev = xa_load(&dax_hosts, (unsigned long)bdev->bd_disk);
>         if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode))
> @@ -107,10 +113,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>                 struct block_device *bdev, int blocksize, sector_t start,
>                 sector_t sectors)
>  {
> -       pgoff_t pgoff, pgoff_end;
> -       sector_t last_page;
> -       int err;
> -
>         if (blocksize != PAGE_SIZE) {
>                 pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
>                 return false;
> @@ -121,19 +123,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>                 return false;
>         }
>
> -       err = bdev_dax_pgoff(bdev, start, PAGE_SIZE, &pgoff);
> -       if (err) {
> -               pr_info("%pg: error: unaligned partition for dax\n", bdev);
> -               return false;
> -       }
> -
> -       last_page = PFN_DOWN((start + sectors - 1) * 512) * PAGE_SIZE / 512;
> -       err = bdev_dax_pgoff(bdev, last_page, PAGE_SIZE, &pgoff_end);
> -       if (err) {
> -               pr_info("%pg: error: unaligned partition for dax\n", bdev);
> -               return false;
> -       }
> -
>         return true;
>  }
>  EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> --
> 2.30.2
>
