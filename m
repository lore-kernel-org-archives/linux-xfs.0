Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEFCC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 15:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJNPiY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 11:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJNPiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 11:38:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC0317D846
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 08:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 772C6B82363
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 15:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFAEC433C1;
        Fri, 14 Oct 2022 15:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665761899;
        bh=4PaDsDnmxK0v8CDj5TYLwT50iJdhG5Z61dOF65PpwUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cr4lOZdy0HtBSOFrxd4EAJxpEloMbJpeyk86rCZoUHNO6YH7e7RtFSb4a2tV5ngaa
         i3+rBZvgBYMCNwalQTS57P9EW4o5Yr1qd1TmjPnLN7ELuVxr6OpaV1mS9idWe92yvl
         SLje1Y//36dm+ChYVbjaSN7/s5ZYjOKDHo6ta8W1y/RkzqLRAOtL/UZr+UZHfc53sg
         YOQA3dufaerfpsUlub5XqegAoVaocEJ4tbXsD0iI5+I/ebSoVp29k0MSwxj0vWSpXU
         6hzgBE7+z87ENKoYDVoGpMh7Fn+3MDGozMqdfCl7jlzg6VVIZl3uQc3FJpIeuiQxcd
         fuXM5YYcvEL+Q==
Date:   Fri, 14 Oct 2022 08:38:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] mkfs: acquire flock before modifying the device
 superblock
Message-ID: <Y0mCauklwsDwImi8@magnolia>
References: <b359751c-2397-bcd1-9065-583afb2f93ef@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b359751c-2397-bcd1-9065-583afb2f93ef@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 04:41:35PM +0800, Wu Guanghao wrote:
> We noticed that systemd has an issue about symlink unreliable caused by
> formatting filesystem and systemd operating on same device.
> Issue Link: https://github.com/systemd/systemd/issues/23746
> 
> According to systemd doc, a BSD flock needs to be acquired before
> formatting the device.
> Related Link: https://systemd.io/BLOCK_DEVICE_LOCKING/

TLDR: udevd wants fs utilities to use advisory file locking to
coordinate (re)writes to block devices to avoid collisions between mkfs
and all the udev magic.

Critically, udev calls flock(LOCK_SH | LOCK_NB) to trylock the device in
shared mode to avoid blocking on fs utilities; if the trylock fails,
they'll move on and try again later.  The old O_EXCL-on-blockdevs trick
will not work for that usecase (I guess) because it's not a shared
reader lock.  It's also not the file locking API.

> So we acquire flock after opening the device but before
> writing superblock.

xfs_db and xfs_repair can write to the filesystem too; shouldn't this
locking apply to them as well?

> Signed-off-by: wuguanghao <wuguanghao3@huawei.com>
> ---
>  mkfs/xfs_mkfs.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9dd0e79c..b83cb043 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -13,6 +13,7 @@
>  #include "libfrog/crc32cselftest.h"
>  #include "proto.h"
>  #include <ini.h>
> +#include <sys/file.h>
> 
>  #define TERABYTES(count, blog) ((uint64_t)(count) << (40 - (blog)))
>  #define GIGABYTES(count, blog) ((uint64_t)(count) << (30 - (blog)))
> @@ -2758,6 +2759,30 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
> 
>  }
> 
> +static void
> +lock_device(dev_t dev, int flag, char *name)
> +{
> +       int fd = libxfs_device_to_fd(dev);
> +       int readonly = flag & LIBXFS_ISREADONLY;
> +
> +       if (!readonly && fd > 0)
> +               if (flock(fd, LOCK_EX) != 0) {
> +                       fprintf(stderr, "%s: failed to get lock.\n", name);
> +                       exit(1);
> +               }

So yes, this belongs in libxfs_device_open.

If we're opening the bdevs in readonly mode, shouldn't we take LOCK_SH
to prevent mkfs from colliding with (say) xfs_metadump?

Bonus question: Shouldn't the /kernel/ also effectively be taking
LOCK_SH when it opens the bdevs to mount the filesystem?

--D

> +}
> +
> +static void
> +lock_devices(struct libxfs_xinit *xi)
> +{
> +       if (!xi->disfile)
> +               lock_device(xi->ddev, xi->dcreat, xi->dname);
> +       if (xi->logdev && !xi->lisfile)
> +               lock_device(xi->logdev, xi->lcreat, xi->logname);
> +       if (xi->rtdev && !xi->risfile)
> +               lock_device(xi->rtdev, xi->rcreat, xi->rtname);
> +}
> +
>  static void
>  open_devices(
>         struct mkfs_params      *cfg,
> @@ -4208,6 +4233,7 @@ main(
>          * Open and validate the device configurations
>          */
>         open_devices(&cfg, &xi);
> +       lock_devices(&xi);
>         validate_overwrite(dfile, force_overwrite);
>         validate_datadev(&cfg, &cli);
>         validate_logdev(&cfg, &cli, &logfile);
> --
> 2.27.0
