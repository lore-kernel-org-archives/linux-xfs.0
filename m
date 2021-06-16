Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982A8C48BDF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 00:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A1C61241
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 00:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhFPAsh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 20:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhFPAsh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jun 2021 20:48:37 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2DEC061760
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jun 2021 17:46:31 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e1so229887plh.8
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jun 2021 17:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1UGOQAS/gnlRXyh5KGqeT8Vh25LI5tpduRj0+a7sMPk=;
        b=vo8kqB3upoOfLkcjr7BktRu/G8ZVEhvIzJRE4kky8AJ4PfRn8k2gzYYoapgpQuUbxb
         eW8RGrn7MgbOV4zezM2DvxEUGloaOcI+ZwM7w+hGK1ODQGZY61Whd9RnPKTR0JjPdOAy
         gZlhjQRZo7WgJTr5eaAqs0zFWg4doaen5CBF+OQ/OSQS1JEdId+qBnmjbsRXh8Bcc94F
         UwUUw+zf7f3sRdQ6CmITUZn9WRx5c/WThXOvJbtfrGxqQQj9KFvUmE3zt4KqLqj3Vi9e
         8vOqYXgaBsZ+ftPDLJY3C8RjB2YsfygyA0wu/S313rMtXG+DAjfSWIE7PNAJaUVVbjMq
         fihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1UGOQAS/gnlRXyh5KGqeT8Vh25LI5tpduRj0+a7sMPk=;
        b=UUWW5M71S6OEAnCJ8WfpZrW8THmOeA/kDNM8v2x3tWgWOHewa6dBpzme2yajFYu/YI
         iha39EIvsuQ+4sMtb89xfdBM+IEJ0UYqanfrKyEzanGjbCDBd0cTz+o97KluFmra5dUk
         I5zxdiQqLdeVTxm7wwau/Y51fFL9DKWfPkJA20M8D/rhqlChPFwm14QmoNIwrelr0QLc
         fO1XGnsOSr05ADLVanW034i4TpRqDlnULO8F8RKpgS8CpfhddvTNyRYlBoZ6pFVVdDL5
         JMEf5Jno33x4JXdPZyEuwA6f2tLHuMTjIMIGeysA8i+y/HAbc8zfc0uWLXItVe8vUrwC
         nGgA==
X-Gm-Message-State: AOAM533+yewTmnMbVgS4gqAU77hGQH1nwE1l3ks3BRQTWP+wd+hK6SWR
        WwBaj7SEwnOsriUfLyewVld/wkI5Luhb9/pLBnLc7w==
X-Google-Smtp-Source: ABdhPJxnjJTq18+nazpJrwCbf8hmuZEuQ5kMFby00dnTlWpwUJ3rx4rFxrMADpX4C943d5rXD+aKPVKy1eqHRare17k=
X-Received: by 2002:a17:90a:ea8c:: with SMTP id h12mr7535174pjz.149.1623804390579;
 Tue, 15 Jun 2021 17:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com> <20210604011844.1756145-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-3-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 15 Jun 2021 17:46:19 -0700
Message-ID: <CAPcyv4jA8FW6PMxaETETQxjnpn9aE2Nevq-R96BJr8QzixYRsQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] dax: Introduce holder for dax_device
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        david <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> To easily track filesystem from a pmem device, we introduce a holder for
> dax_device structure, and also its operation.  This holder is used to
> remember who is using this dax_device:
>  - When it is the backend of a filesystem, the holder will be the
>    superblock of this filesystem.
>  - When this pmem device is one of the targets in a mapped device, the
>    holder will be this mapped device.  In this case, the mapped device
>    has its own dax_device and it will follow the first rule.  So that we
>    can finally track to the filesystem we needed.
>
> The holder and holder_ops will be set when filesystem is being mounted,
> or an target device is being activated.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 10 ++++++++++
>  2 files changed, 48 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 5fa6ae9dbc8b..d118e2a7dc70 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -222,8 +222,10 @@ struct dax_device {
>         struct cdev cdev;
>         const char *host;
>         void *private;

@private is likely too generic of a name now, it would be better to
call this @parent.

> +       void *holder;

This should probably be called holder_data, and this structure could
use some kernel-doc to clarify what the fields mean.

>         unsigned long flags;
>         const struct dax_operations *ops;
> +       const struct dax_holder_operations *holder_ops;
>  };
>
>  static ssize_t write_cache_show(struct device *dev,
> @@ -373,6 +375,24 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  }
>  EXPORT_SYMBOL_GPL(dax_zero_page_range);
>
> +int dax_corrupted_range(struct dax_device *dax_dev, struct block_device *bdev,
> +               loff_t offset, size_t size, void *data)

Why is @bdev an argument to this routine?  The primary motivation for
a 'struct dax_device' is to break the association with 'struct
block_device'. The filesystem may know that the logical addresses
associated with a given dax_dev alias with the logical addresses of a
given bdev, but that knowledge need not leak into the API.

> +{
> +       int rc = -ENXIO;
> +       if (!dax_dev)
> +               return rc;
> +
> +       if (dax_dev->holder) {
> +               rc = dax_dev->holder_ops->corrupted_range(dax_dev, bdev, offset,
> +                                                         size, data);

A bikeshed comment, but I do not like the name corrupted_range(),
because "corrupted" implies a permanent state. The source of this
notification is memory_failure() and that does not convey "permanent"
vs "transient" it just reports "failure". So, to keep the naming
consistent with the pgmap notification callback lets call this one
"notify_failure".

> +               if (rc == -ENODEV)
> +                       rc = -ENXIO;
> +       } else
> +               rc = -EOPNOTSUPP;
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(dax_corrupted_range);

dax_holder_notify_failure() makes it clearer that this is
communicating a failure up the holder stack.

> +
>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>  void arch_wb_cache_pmem(void *addr, size_t size);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> @@ -624,6 +644,24 @@ void put_dax(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(put_dax);
>
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       if (!dax_dev)
> +               return;
> +       dax_dev->holder = holder;
> +       dax_dev->holder_ops = ops;

I think there needs to be some synchronization here, perhaps a global
dax_dev_rwsem that is taken for read in the notification path and
write when adding a holder to the chain.

I also wonder if this should be an event that triggers a dax_dev stack
to re-report any failure notifications. For example the pmem driver
may have recorded a list of bad blocks at the beginning of time.
Likely the filesystem or other holder would like to get that
pre-existing list of failures at first registration. Have you given
thought about how the filesystem is told about pre-existing badblocks?

> +}
> +EXPORT_SYMBOL_GPL(dax_set_holder);
> +
> +void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       if (!dax_dev)
> +               return NULL;
> +       return dax_dev->holder;
> +}
> +EXPORT_SYMBOL_GPL(dax_get_holder);

Where is this used?
