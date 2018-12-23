Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:33701
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbeLWWGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 17:06:13 -0500
Date: Sun, 23 Dec 2018 23:06:07 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 00/20] drop useless LIST_HEAD
In-Reply-To: <CAKR_QVJefW1vxYb7-qiU8=0YdbFghYo15SK2eGjOC-dntRfyYA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1812232304130.2940@hadrien>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr> <CAKR_QVJefW1vxYb7-qiU8=0YdbFghYo15SK2eGjOC-dntRfyYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-janitors@vger.kernel.org, dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org, linux-wireless@vger.kernel.org



On Sun, 23 Dec 2018, Tom Psyborg wrote:

> Why do you CC this to so many lists?

Because the different files are in different subsystems.  The cover letter
goes to a list for each file, or to a person if there is no list.  The
patches go to the people and lists associated with the affected files.

julia

>
> On 23/12/2018, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > Drop LIST_HEAD where the variable it declares is never used.
> >
> > ---
> >
> >  drivers/dma/at_hdmac.c                                |    5 -----
> >  drivers/dma/dw/core.c                                 |    1 -
> >  drivers/dma/pl330.c                                   |    1 -
> >  drivers/dma/sa11x0-dma.c                              |    2 --
> >  drivers/dma/st_fdma.c                                 |    3 ---
> >  drivers/infiniband/ulp/ipoib/ipoib_ib.c               |    1 -
> >  drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    5 -----
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |    3 ---
> >  drivers/net/ethernet/mellanox/mlxsw/spectrum.c        |    1 -
> >  drivers/net/wireless/st/cw1200/queue.c                |    1 -
> >  drivers/scsi/lpfc/lpfc_nvme.c                         |    2 --
> >  drivers/scsi/lpfc/lpfc_scsi.c                         |    2 --
> >  drivers/scsi/lpfc/lpfc_sli.c                          |    1 -
> >  drivers/scsi/qla2xxx/qla_init.c                       |    1 -
> >  drivers/xen/xenbus/xenbus_dev_frontend.c              |    2 --
> >  fs/btrfs/relocation.c                                 |    1 -
> >  fs/nfs/nfs4client.c                                   |    1 -
> >  fs/nfsd/nfs4layouts.c                                 |    1 -
> >  fs/xfs/xfs_buf.c                                      |    1 -
> >  fs/xfs/xfs_fsops.c                                    |    1 -
> >  20 files changed, 36 deletions(-)
> >
>
