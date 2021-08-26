Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76814C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 14:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BF3C61053
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 14:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbhHZOnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 10:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242829AbhHZOnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Aug 2021 10:43:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A8FC061757
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 07:42:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u15so1922383plg.13
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 07:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ABTfU8gxdjv5n74FbYsyCDi8X7MNpO1jIxZ8zrk/JGc=;
        b=RnM+EalWmI3PqG7GROErhErzyPvDbZCl0KTyuEsZ8rvwaXbCmLGYFo0yra0yZXKsar
         gK732TMBNazrj5DR9ByMd3UdZOzjU1wCyhqFo++Dz5dnNmiau+yIflCs68+Qtk0bLvmD
         WU1qzs7I1dCdU4qAnLydv3o+dt60dwm1PpLP6xm8EaBkpVmN7pzNVF0vda5VBS3dKner
         IhF1jpU2gcPXjHxcJXA2tfQz0eUeS8yYMY+eKVIyig67TB1zvew32ziVngCOkemv3QEj
         yppNGbWtyBRoXelyhp6VliZ0pKhRgYBRfs19XpiXUpK4P59cmR42IxfV7c+kphMG8VWg
         3BCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ABTfU8gxdjv5n74FbYsyCDi8X7MNpO1jIxZ8zrk/JGc=;
        b=h+TB+lkUnljJNSoP6t+XvP1GjiNRIlAWpwBDXI68LnC4SVcgPziHHYDFl+r7OugT7u
         M26MZopiCIt7Yo5UKtkx+EcxtjqrtN37ex1vZ0+hgkzq2wMvwyZKnm38UpOYLD8JRdoV
         4WcQKxKSqKtgMmPhGxpBf2wmTZG0+Z2KO8wNa2chUGH1x1VsTeaK0MWaoyH2+bJpMG3N
         fadfZzuL+p4lyNyXGRDSiTyKLpNXx43nsj0mdIcB20/Z/+dI5TL/ltfUdN6HUTqYRS0A
         KY2bnnZiLBTFtueAxcmyfMyK41sudL5ptzUw9MTjsnqhXWwCpzlRNpwaHojsMRd9EoUR
         zgOg==
X-Gm-Message-State: AOAM5312muqzllkb71bg6Ka5lpjHm2dFgI7fJVTplPnro/JnF3jwIlcp
        HEKUE/v6OluiwRfNRgnxQ3ODX39iholpAXlzxBQZDw==
X-Google-Smtp-Source: ABdhPJzO1UFjPYxjHHDbPPyTeWuvMW2jYmROew+jJbFtaVcDFYVCU8mx/aezSMbrIMNKUs0Szwc4PU9+n1E6cYIivVo=
X-Received: by 2002:a17:902:ba90:b0:135:6709:705 with SMTP id
 k16-20020a170902ba9000b0013567090705mr3869473pls.79.1629988941096; Thu, 26
 Aug 2021 07:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210826135510.6293-1-hch@lst.de> <20210826135510.6293-4-hch@lst.de>
In-Reply-To: <20210826135510.6293-4-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 26 Aug 2021 07:42:10 -0700
Message-ID: <CAPcyv4ieXdjgxE+PkcUjuL7vdcnQfXhb_1aG2YeLtX9BZWVQfQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] dm: use fs_dax_get_by_bdev instead of dax_get_by_host
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 6:59 AM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no point in trying to finding the dax device if the DAX flag is
> not set on the queue as none of the users of the device mapper exported
> block devices could make use of the DAX capability.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/dm.c | 2 +-

Mike, any objections to me taking this through a dax branch?

>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2c5f9e585211..465714341300 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -650,7 +650,7 @@ static int open_table_device(struct table_device *td, dev_t dev,
>         }
>
>         td->dm_dev.bdev = bdev;
> -       td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
> +       td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev);
>         return 0;
>  }
>
> --
> 2.30.2
>
