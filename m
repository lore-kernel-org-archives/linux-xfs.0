Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:46950 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752740AbeEONwb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 09:52:31 -0400
Received: by mail-oi0-f68.google.com with SMTP id y15-v6so175366oia.13
        for <linux-xfs@vger.kernel.org>; Tue, 15 May 2018 06:52:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180515012926.GC10363@dastard>
References: <5398ddaf2b876c3563bc1c2927bfe1b9@ruhr-uni-bochum.de>
 <866a5e96-e900-d330-0efb-6413f85f86a3@sandeen.net> <20180514225751.GB10363@dastard>
 <b2fe69d6216f165b2c84ca5a377d06ab@ruhr-uni-bochum.de> <20180515012926.GC10363@dastard>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Tue, 15 May 2018 14:52:30 +0100
Message-ID: <CAMU1PDgMH_K1N71SmkwDj159wTjFM3js-hhFGr8uE_GhmLn5mA@mail.gmail.com>
Subject: Re: How to reliably measure fs usage with reflinks enabled?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Tarik Ceylan <Tarik.Ceylan@ruhr-uni-bochum.de>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On 15 May 2018 at 02:29, Dave Chinner <david@fromorbit.com> wrote:
> So the reflink code reserved ~7GB of space in the filesystem (less
> than 1%) for it's own reflink related metadata if it ever needs it.
> It hasn't used it yet but we need to make sure that it's available
> when the filesystem is near ENOSPC. Hence it's considered used space
> because users cannot store user data in that space.
>
> The change I plan to make is to reduce the user reported filesystem
> size rather than account for it as used space. IOWs, you'd see a
> filesystem size of 889G instead of 896G, but have only 8.8GB used.
> It means exactly the same thingi and will behave exactly the same
> way, it's just a different space accounting technique....

I'm one of the authors of GParted and it uses the reported file system
size [1] and compares it to the block device size to see if the file
system fills the partition or not and whether to show unallocated space
to the user and advise them to grown the file system to fill the block
device [2].  As such we prefer that the reported size of the file system
match the highest offset that the file system can write to in the block
device.  Hence space not free for storing data such as super blocks and
other reserved metadata be included in used space.

[1] For mounted file systems it uses statvfs() and unmounted XFS file
    systems it uses:
      xfs_db -c 'sb 0' -c 'print blocksize' -c 'print dblocks' /dev/sda7
    to get the fs block size and number of blocks.

[2] For full disclosure, because tools for various FSs under report
    their file system size, there is a heuristic that there must be at
    least 2% difference before unallocated space and grow file system
    recommendation is generated so under reporting the FS size by less
    than 1% wouldn't actually be an issue. for us.

Just providing an app authors point of view.

Thanks,
Mike
