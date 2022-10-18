Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86773C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 02:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiJRCqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Oct 2022 22:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiJRCqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2022 22:46:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C29FB874
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 19:46:09 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mrysk2S9QzHv43;
        Tue, 18 Oct 2022 10:46:02 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 10:45:55 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 10:45:55 +0800
Message-ID: <663ca1f7-01f4-14f4-242c-2e4b9038f7e2@huawei.com>
Date:   Tue, 18 Oct 2022 10:45:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] mkfs: acquire flock before modifying the device
 superblock
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
References: <b359751c-2397-bcd1-9065-583afb2f93ef@huawei.com>
 <Y0mCauklwsDwImi8@magnolia>
From:   Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <Y0mCauklwsDwImi8@magnolia>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2022/10/14 23:38, Darrick J. Wong 写道:
> On Fri, Oct 14, 2022 at 04:41:35PM +0800, Wu Guanghao wrote:
>> We noticed that systemd has an issue about symlink unreliable caused by
>> formatting filesystem and systemd operating on same device.
>> Issue Link: https://github.com/systemd/systemd/issues/23746
>>
>> According to systemd doc, a BSD flock needs to be acquired before
>> formatting the device.
>> Related Link: https://systemd.io/BLOCK_DEVICE_LOCKING/
> 
> TLDR: udevd wants fs utilities to use advisory file locking to
> coordinate (re)writes to block devices to avoid collisions between mkfs
> and all the udev magic.
> 
> Critically, udev calls flock(LOCK_SH | LOCK_NB) to trylock the device in
> shared mode to avoid blocking on fs utilities; if the trylock fails,
> they'll move on and try again later.  The old O_EXCL-on-blockdevs trick
> will not work for that usecase (I guess) because it's not a shared
> reader lock.  It's also not the file locking API.
> 
>> So we acquire flock after opening the device but before
>> writing superblock.
> 
> xfs_db and xfs_repair can write to the filesystem too; shouldn't this
> locking apply to them as well?
> 
xfs_db is an interactive operation.If a lock is added, the lock may be held
for too long. xfs_repair only repairs the data inside the file system ,so it's
unlikely to conflict with systemd. So these two commands aren't locked.

>> Signed-off-by: wuguanghao <wuguanghao3@huawei.com>
>> ---
>>  mkfs/xfs_mkfs.c | 26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 9dd0e79c..b83cb043 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -13,6 +13,7 @@
>>  #include "libfrog/crc32cselftest.h"
>>  #include "proto.h"
>>  #include <ini.h>
>> +#include <sys/file.h>
>>
>>  #define TERABYTES(count, blog) ((uint64_t)(count) << (40 - (blog)))
>>  #define GIGABYTES(count, blog) ((uint64_t)(count) << (30 - (blog)))
>> @@ -2758,6 +2759,30 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
>>
>>  }
>>
>> +static void
>> +lock_device(dev_t dev, int flag, char *name)
>> +{
>> +       int fd = libxfs_device_to_fd(dev);
>> +       int readonly = flag & LIBXFS_ISREADONLY;
>> +
>> +       if (!readonly && fd > 0)
>> +               if (flock(fd, LOCK_EX) != 0) {
>> +                       fprintf(stderr, "%s: failed to get lock.\n", name);
>> +                       exit(1);
>> +               }
> 
> So yes, this belongs in libxfs_device_open.
> 
> If we're opening the bdevs in readonly mode, shouldn't we take LOCK_SH
> to prevent mkfs from colliding with (say) xfs_metadump?
> 
> Bonus question: Shouldn't the /kernel/ also effectively be taking
> LOCK_SH when it opens the bdevs to mount the filesystem?

Systemd normally uses "watch" to monitor disks, only in special cases
will the monitoring be released. During the time from the release of
monitoring to the re-opening of monitoring, the flock is used to
ensure that the disk won't be written to by others.
So if the disk isn't modified or the modified content won't trigger
the udev rule, then it should be OK not to lock.

There is still a problem with this solution, systemd only lock the main
block device, not the partition device. So if we're operating on a
partitioned device, the lock won't work. Currently we are still
communicating with systemd.

> --D
> 
>> +}
>> +
>> +static void
>> +lock_devices(struct libxfs_xinit *xi)
>> +{
>> +       if (!xi->disfile)
>> +               lock_device(xi->ddev, xi->dcreat, xi->dname);
>> +       if (xi->logdev && !xi->lisfile)
>> +               lock_device(xi->logdev, xi->lcreat, xi->logname);
>> +       if (xi->rtdev && !xi->risfile)
>> +               lock_device(xi->rtdev, xi->rcreat, xi->rtname);
>> +}
>> +
>>  static void
>>  open_devices(
>>         struct mkfs_params      *cfg,
>> @@ -4208,6 +4233,7 @@ main(
>>          * Open and validate the device configurations
>>          */
>>         open_devices(&cfg, &xi);
>> +       lock_devices(&xi);
>>         validate_overwrite(dfile, force_overwrite);
>>         validate_datadev(&cfg, &cli);
>>         validate_logdev(&cfg, &cli, &logfile);
>> --
>> 2.27.0
> .
> 
