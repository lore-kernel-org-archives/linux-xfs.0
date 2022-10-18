Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C3FC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 21:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJRVJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 17:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiJRVJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 17:09:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405C9C1495
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 14:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD36CB81F68
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 21:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90785C433C1;
        Tue, 18 Oct 2022 21:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666127346;
        bh=vvx62hhvevvfdCjCmr2btK0W4EqzcpxZx5MFOEOV9z8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L0pRi36uPEA310quJ2fM9+xWD0lxeQIfZT67KnjcrgnUiJKU/yL+ofxA1VtN8uYDl
         G6moNIUcr0U54kwzh7BkxXpXXbj96F474NQLRexlmPotNjJyaMEjRvQWoORhyW4mf+
         ZSVz94nhfj6A+lt7Oa4peVtUAkqI0N6kiy+pzRjOEuvfWPmEZs184H29A6Gy2weyUK
         aARWxZvMA4HuQkBwA4C30jF0/wEC0hgLAAOeOJMD0+FwgWADyRop/7dBdQtcZQrMfL
         LQrgU6B+z1D1iHtg/yxDNyp8T/sOkWjJKvFi4uJYISisbWfIgzOsqu7jjFB9OoaXaZ
         W5vqBCJJhhtgA==
Date:   Tue, 18 Oct 2022 14:09:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] mkfs: acquire flock before modifying the device
 superblock
Message-ID: <Y08V8lCfrKFRFYTH@magnolia>
References: <b359751c-2397-bcd1-9065-583afb2f93ef@huawei.com>
 <Y0mCauklwsDwImi8@magnolia>
 <663ca1f7-01f4-14f4-242c-2e4b9038f7e2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <663ca1f7-01f4-14f4-242c-2e4b9038f7e2@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2022 at 10:45:54AM +0800, Wu Guanghao wrote:
> 
> 
> 在 2022/10/14 23:38, Darrick J. Wong 写道:
> > On Fri, Oct 14, 2022 at 04:41:35PM +0800, Wu Guanghao wrote:
> >> We noticed that systemd has an issue about symlink unreliable caused by
> >> formatting filesystem and systemd operating on same device.
> >> Issue Link: https://github.com/systemd/systemd/issues/23746
> >>
> >> According to systemd doc, a BSD flock needs to be acquired before
> >> formatting the device.
> >> Related Link: https://systemd.io/BLOCK_DEVICE_LOCKING/
> > 
> > TLDR: udevd wants fs utilities to use advisory file locking to
> > coordinate (re)writes to block devices to avoid collisions between mkfs
> > and all the udev magic.
> > 
> > Critically, udev calls flock(LOCK_SH | LOCK_NB) to trylock the device in
> > shared mode to avoid blocking on fs utilities; if the trylock fails,
> > they'll move on and try again later.  The old O_EXCL-on-blockdevs trick
> > will not work for that usecase (I guess) because it's not a shared
> > reader lock.  It's also not the file locking API.
> > 
> >> So we acquire flock after opening the device but before
> >> writing superblock.
> > 
> > xfs_db and xfs_repair can write to the filesystem too; shouldn't this
> > locking apply to them as well?
> > 
> xfs_db is an interactive operation.If a lock is added, the lock may be held
> for too long.

xfs_db can also write to the filesystem; see -x mode.

But first -- let's zoom out here.  You're adding flock() calls to
xfsprogs to coordinate two userspace programs udev and mkfs.xfs.  Why
wouldn't you add the same flock()ing to the rest of the xfs utilities so
that they also don't step on each other?

xfs_mdrestore can also write an XFS image to a block device, so what
makes it special?

> xfs_repair only repairs the data inside the file system ,so it's
> unlikely to conflict with systemd. So these two commands aren't locked.

"Unlikely" isn't good enough -- xfsprogs don't control the udev rules,
which means that a program invoked by a udev rule could read just about
anywhere in the block device.  Hence we need to prevent udev from
getting confused about /any/ block that xfs_repair might write.

(You /do/ know that xfs_db and xfs_repair can rewrite the primary
superblock, right?)

> >> Signed-off-by: wuguanghao <wuguanghao3@huawei.com>
> >> ---
> >>  mkfs/xfs_mkfs.c | 26 ++++++++++++++++++++++++++
> >>  1 file changed, 26 insertions(+)
> >>
> >> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >> index 9dd0e79c..b83cb043 100644
> >> --- a/mkfs/xfs_mkfs.c
> >> +++ b/mkfs/xfs_mkfs.c
> >> @@ -13,6 +13,7 @@
> >>  #include "libfrog/crc32cselftest.h"
> >>  #include "proto.h"
> >>  #include <ini.h>
> >> +#include <sys/file.h>
> >>
> >>  #define TERABYTES(count, blog) ((uint64_t)(count) << (40 - (blog)))
> >>  #define GIGABYTES(count, blog) ((uint64_t)(count) << (30 - (blog)))
> >> @@ -2758,6 +2759,30 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
> >>
> >>  }
> >>
> >> +static void
> >> +lock_device(dev_t dev, int flag, char *name)
> >> +{
> >> +       int fd = libxfs_device_to_fd(dev);
> >> +       int readonly = flag & LIBXFS_ISREADONLY;
> >> +
> >> +       if (!readonly && fd > 0)
> >> +               if (flock(fd, LOCK_EX) != 0) {
> >> +                       fprintf(stderr, "%s: failed to get lock.\n", name);
> >> +                       exit(1);
> >> +               }
> > 
> > So yes, this belongs in libxfs_device_open.
> > 
> > If we're opening the bdevs in readonly mode, shouldn't we take LOCK_SH
> > to prevent mkfs from colliding with (say) xfs_metadump?
> > 
> > Bonus question: Shouldn't the /kernel/ also effectively be taking
> > LOCK_SH when it opens the bdevs to mount the filesystem?
> 
> Systemd normally uses "watch" to monitor disks, only in special cases
> will the monitoring be released. During the time from the release of
> monitoring to the re-opening of monitoring, the flock is used to
> ensure that the disk won't be written to by others.
> So if the disk isn't modified or the modified content won't trigger
> the udev rule, then it should be OK not to lock.

xfs utilities can't know what kinds of writes will or will not trigger
udev rules, since the sysadmin can install arbitrary udev rules.

> There is still a problem with this solution, systemd only lock the main
> block device, not the partition device. So if we're operating on a
> partitioned device, the lock won't work. Currently we are still
> communicating with systemd.

Er... well, I guess it's good to know that xfs isn't /completely/ behind
the curve here.

--D

> > --D
> > 
> >> +}
> >> +
> >> +static void
> >> +lock_devices(struct libxfs_xinit *xi)
> >> +{
> >> +       if (!xi->disfile)
> >> +               lock_device(xi->ddev, xi->dcreat, xi->dname);
> >> +       if (xi->logdev && !xi->lisfile)
> >> +               lock_device(xi->logdev, xi->lcreat, xi->logname);
> >> +       if (xi->rtdev && !xi->risfile)
> >> +               lock_device(xi->rtdev, xi->rcreat, xi->rtname);
> >> +}
> >> +
> >>  static void
> >>  open_devices(
> >>         struct mkfs_params      *cfg,
> >> @@ -4208,6 +4233,7 @@ main(
> >>          * Open and validate the device configurations
> >>          */
> >>         open_devices(&cfg, &xi);
> >> +       lock_devices(&xi);
> >>         validate_overwrite(dfile, force_overwrite);
> >>         validate_datadev(&cfg, &cli);
> >>         validate_logdev(&cfg, &cli, &logfile);
> >> --
> >> 2.27.0
> > .
> > 
