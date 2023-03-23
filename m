Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6616AC6FD1C
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Mar 2023 15:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCWPpe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Mar 2023 11:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjCWPpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Mar 2023 11:45:34 -0400
X-Greylist: delayed 354 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Mar 2023 08:45:32 PDT
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1170D72B1
        for <linux-xfs@vger.kernel.org>; Thu, 23 Mar 2023 08:45:32 -0700 (PDT)
Received: from [10.2.0.2] (unknown [143.244.44.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 63E8E5A10CC;
        Thu, 23 Mar 2023 10:39:16 -0500 (CDT)
Message-ID: <85a9bb82-864e-5532-9252-f8055baeb790@sandeen.net>
Date:   Thu, 23 Mar 2023 10:39:36 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Content-Language: en-US
To:     Johnatan Hallman <johnatan-ftm@protonmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <EgkSUvPep_zPazvY0jpnimG82K4wOeYfiPz0Ly_34-TMN9DZKWNNQDxGFJPyq622ZaKee6RU3aFT34Yy-i00rjdT7hWFzS6HSGRe74z1F5o=@protonmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: FS (dm-0): device supports 4096 byte sectors (not 512)
In-Reply-To: <EgkSUvPep_zPazvY0jpnimG82K4wOeYfiPz0Ly_34-TMN9DZKWNNQDxGFJPyq622ZaKee6RU3aFT34Yy-i00rjdT7hWFzS6HSGRe74z1F5o=@protonmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/23/23 5:45 AM, Johnatan Hallman wrote:
> Hello List,
> 
> I get this error when I try to mount an XFS partition.
> Fortunately there is no critical data on it as it is just a backup but I would still like to mount it if it's possible.
> 
> I have tried with various Linux distros with kernels ranging from 5.6 to 6.1 it's the same result.
> 
> xfs_info /dev/mapper/test
> meta-data=/dev/mapper/test       isize=256    agcount=32, agsize=30523559 blks
>          =                       sectsz=512   attr=2, projid32bit=0
>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>          =                       reflink=0    bigtime=0 inobtcount=0 nrext64=0
> data     =                       bsize=4096   blocks=976753869, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=0
> log      =internal log           bsize=4096   blocks=476930, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> mount -t xfs -o ro /dev/mapper/test  /mnt/
> mount: /mnt: mount(2) system call failed: Function not implemented.
>        dmesg(1) may have more information after failed mount system call.

So I assume dmesg contained the error in $SUBJECT:

FS (dm-0): device supports 4096 byte sectors (not 512)

It seems that the filesystem was created with 512-byte sectors - at that time, the device
must have supported them. Perhaps something about the devicemapper target changed from
a 512 device to a 4k device? I'm not sure what might cause that to happen, but IMHO
it should never happen... did the dm device recently get reconfigured?

As a last resort, I think you could dd the filesystem (all 3T) to a file, and use a
loopback mount to access the files.

Alternatively, I wonder if we could relax the sector size check for a read-only
mount (that does not require log replay) - I'm not sure about that though.

-Eric
