Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45706 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfEOUtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 16:49:08 -0400
Received: by mail-oi1-f193.google.com with SMTP id w144so810056oie.12
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 13:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190514145422.16923-1-pagupta@redhat.com> <20190514145422.16923-5-pagupta@redhat.com>
In-Reply-To: <20190514145422.16923-5-pagupta@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 May 2019 13:48:57 -0700
Message-ID: <CAPcyv4jp+9eBQMX+KXhT1oZRkxLeCp9r9g9hFUCRw=OcuQ9wmQ@mail.gmail.com>
Subject: Re: [PATCH v9 4/7] dm: enable synchronous dax
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, KVM list <kvm@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Matthew Wilcox <willy@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Christoph Hellwig <hch@infradead.org>, Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Igor Mammedov <imammedo@redhat.com>, jmoyer <jmoyer@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Rik van Riel <riel@surriel.com>, Stefan Hajnoczi <stefanha@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Hildenbrand <david@redhat.com>, david <david@fromorbit.com>, cohuck@redhat.com, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Adam Borowski <kilobyte@angband.pl>, yuval shaia <yuval.shaia@oracle.com>, jstaron@google.com, Pankaj Gupta <pagupta@redhat.com>, device-mapper development <dm-devel@redhat.com>

[ add Mike and dm-devel ]

Mike, any concerns with the below addition to the device-mapper-dax
implementation?

On Tue, May 14, 2019 at 7:58 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>  This patch sets dax device 'DAXDEV_SYNC' flag if all the target
>  devices of device mapper support synchrononous DAX. If device
>  mapper consists of both synchronous and asynchronous dax devices,
>  we don't set 'DAXDEV_SYNC' flag.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  drivers/md/dm-table.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index cde3b49b2a91..1cce626ff576 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -886,10 +886,17 @@ static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
>         return bdev_dax_supported(dev->bdev, PAGE_SIZE);
>  }
>
> +static int device_synchronous(struct dm_target *ti, struct dm_dev *dev,
> +                              sector_t start, sector_t len, void *data)
> +{
> +       return dax_synchronous(dev->dax_dev);
> +}
> +
>  static bool dm_table_supports_dax(struct dm_table *t)
>  {
>         struct dm_target *ti;
>         unsigned i;
> +       bool dax_sync = true;
>
>         /* Ensure that all targets support DAX. */
>         for (i = 0; i < dm_table_get_num_targets(t); i++) {
> @@ -901,7 +908,14 @@ static bool dm_table_supports_dax(struct dm_table *t)
>                 if (!ti->type->iterate_devices ||
>                     !ti->type->iterate_devices(ti, device_supports_dax, NULL))
>                         return false;
> +
> +               /* Check devices support synchronous DAX */
> +               if (dax_sync &&
> +                   !ti->type->iterate_devices(ti, device_synchronous, NULL))
> +                       dax_sync = false;
>         }
> +       if (dax_sync)
> +               set_dax_synchronous(t->md->dax_dev);
>
>         return true;
>  }
> --
> 2.20.1
>
