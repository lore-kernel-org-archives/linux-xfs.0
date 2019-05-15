Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46602 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfEOVHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 17:07:36 -0400
Received: by mail-ot1-f67.google.com with SMTP id j49so1354290otc.13
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 14:07:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190514145422.16923-1-pagupta@redhat.com> <20190514145422.16923-2-pagupta@redhat.com>
In-Reply-To: <20190514145422.16923-2-pagupta@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 May 2019 14:07:23 -0700
Message-ID: <CAPcyv4gEr_zPJEQp3k89v2UXfHp9PQwnJXY+W99HwXfxpvua_w@mail.gmail.com>
Subject: Re: [PATCH v9 1/7] libnvdimm: nd_region flush callback support
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, KVM list <kvm@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Matthew Wilcox <willy@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Christoph Hellwig <hch@infradead.org>, Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Igor Mammedov <imammedo@redhat.com>, jmoyer <jmoyer@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Rik van Riel <riel@surriel.com>, Stefan Hajnoczi <stefanha@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Hildenbrand <david@redhat.com>, david <david@fromorbit.com>, cohuck@redhat.com, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Adam Borowski <kilobyte@angband.pl>, yuval shaia <yuval.shaia@oracle.com>, jstaron@google.com

On Tue, May 14, 2019 at 7:55 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
> This patch adds functionality to perform flush from guest
> to host over VIRTIO. We are registering a callback based
> on 'nd_region' type. virtio_pmem driver requires this special
> flush function. For rest of the region types we are registering
> existing flush function. Report error returned by host fsync
> failure to userspace.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  drivers/acpi/nfit/core.c     |  4 ++--
>  drivers/nvdimm/claim.c       |  6 ++++--
>  drivers/nvdimm/nd.h          |  1 +
>  drivers/nvdimm/pmem.c        | 13 ++++++++-----
>  drivers/nvdimm/region_devs.c | 26 ++++++++++++++++++++++++--
>  include/linux/libnvdimm.h    |  8 +++++++-
>  6 files changed, 46 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 5a389a4f4f65..08dde76cf459 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2434,7 +2434,7 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk=
, unsigned int bw,
>                 offset =3D to_interleave_offset(offset, mmio);
>
>         writeq(cmd, mmio->addr.base + offset);
> -       nvdimm_flush(nfit_blk->nd_region);
> +       nvdimm_flush(nfit_blk->nd_region, NULL);
>
>         if (nfit_blk->dimm_flags & NFIT_BLK_DCR_LATCH)
>                 readq(mmio->addr.base + offset);
> @@ -2483,7 +2483,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk =
*nfit_blk,
>         }
>
>         if (rw)
> -               nvdimm_flush(nfit_blk->nd_region);
> +               nvdimm_flush(nfit_blk->nd_region, NULL);
>
>         rc =3D read_blk_stat(nfit_blk, lane) ? -EIO : 0;
>         return rc;
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index fb667bf469c7..13510bae1e6f 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -263,7 +263,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *=
ndns,
>         struct nd_namespace_io *nsio =3D to_nd_namespace_io(&ndns->dev);
>         unsigned int sz_align =3D ALIGN(size + (offset & (512 - 1)), 512)=
;
>         sector_t sector =3D offset >> 9;
> -       int rc =3D 0;
> +       int rc =3D 0, ret =3D 0;
>
>         if (unlikely(!size))
>                 return 0;
> @@ -301,7 +301,9 @@ static int nsio_rw_bytes(struct nd_namespace_common *=
ndns,
>         }
>
>         memcpy_flushcache(nsio->addr + offset, buf, size);
> -       nvdimm_flush(to_nd_region(ndns->dev.parent));
> +       ret =3D nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
> +       if (ret)
> +               rc =3D ret;
>
>         return rc;
>  }
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index a5ac3b240293..0c74d2428bd7 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -159,6 +159,7 @@ struct nd_region {
>         struct badblocks bb;
>         struct nd_interleave_set *nd_set;
>         struct nd_percpu_lane __percpu *lane;
> +       int (*flush)(struct nd_region *nd_region, struct bio *bio);

So this triggers:

In file included from drivers/nvdimm/e820.c:7:
./include/linux/libnvdimm.h:140:51: warning: =E2=80=98struct bio=E2=80=99 d=
eclared
inside parameter list will not be visible outside of this definition
or declaration
  int (*flush)(struct nd_region *nd_region, struct bio *bio);
                                                   ^~~
I was already feeling uneasy about trying to squeeze this into v5.2,
but this warning and the continued drip of comments leads me to
conclude that this driver would do well to wait one more development
cycle. Lets close out the final fixups and let this driver soak in
-next. Then for the v5.3 cycle I'll redouble my efforts towards the
goal of closing patch acceptance at the -rc6 / -rc7 development
milestone.
