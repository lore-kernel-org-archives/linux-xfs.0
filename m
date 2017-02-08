Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43455
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932349AbdBHM2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2017 07:28:15 -0500
Date: Wed, 8 Feb 2017 10:28:07 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 00/14] use atomic_dec_not_zero()
Message-ID: <20170208102807.5cf7a14d@vento.lan>
In-Reply-To: <20170130183920.12476-1-fabf@skynet.be>
References: <20170130183920.12476-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Fabian Frederick <fabf@skynet.be>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, openipmi-developer@lists.sourceforge.net, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net, Akinobu Mita <akinobu.mita@gmail.com>

Em Mon, 30 Jan 2017 19:39:20 +0100
Fabian Frederick <fabf@skynet.be> escreveu:

> complementary definition to atomic_inc_not_zero() featured in
> lib/fault-inject.c. This small patchset moves it to
> include/linux/atomic.h using it instead of
> atomic_add_unless(value, -1, 0)
> 
> s390 patches were not compile-tested.
> 
> Fabian Frederick (14):
>   locking/atomic: import atomic_dec_not_zero()
>   drm/exynos: use atomic_dec_not_zero()
>   drm/omap: use atomic_dec_not_zero()

>   m5mols: use atomic_dec_not_zero()
>   omap3isp: use atomic_dec_not_zero()

For the media changes:

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

>   s390/qeth: use atomic_dec_not_zero()
>   PM / RUNTIME: use atomic_dec_not_zero()
>   ipmi: use atomic_dec_not_zero()
>   kdb: use atomic_dec_not_zero()
>   PM / Hibernate: use atomic_dec_not_zero()
>   PM: use atomic_dec_not_zero()
>   s390/topology: use atomic_dec_not_zero()
>   ext4: use atomic_dec_not_zero()
>   xfs: use atomic_dec_not_zero()
> 
>  arch/s390/kernel/topology.c               | 2 +-
>  drivers/base/power/runtime.c              | 4 ++--
>  drivers/char/ipmi/ipmi_msghandler.c       | 2 +-
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c  | 2 +-
>  drivers/gpu/drm/omapdrm/omap_dmm_tiler.c  | 2 +-
>  drivers/media/i2c/m5mols/m5mols_core.c    | 2 +-
>  drivers/media/platform/omap3isp/ispstat.c | 2 +-
>  drivers/s390/net/qeth_core_main.c         | 2 +-
>  fs/ext4/ext4.h                            | 2 +-
>  fs/xfs/xfs_buf.c                          | 2 +-
>  include/linux/atomic.h                    | 2 ++
>  kernel/debug/kdb/kdb_main.c               | 2 +-
>  kernel/power/hibernate.c                  | 4 ++--
>  kernel/power/user.c                       | 2 +-
>  lib/fault-inject.c                        | 2 --
>  15 files changed, 17 insertions(+), 17 deletions(-)
> 



Thanks,
Mauro
