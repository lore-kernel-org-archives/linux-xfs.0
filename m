Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751088AbdEWEEz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 00:04:55 -0400
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013242.GW4519@birch.djwong.org> <20170518083405.GQ17542@dastard>
 <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org> <20170522020112.GV17542@dastard>
 <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
 <CAJCQCtT5riGri5d3cin9BipUso9mfQ-PBqoPzMZEEYm8RezJdA@mail.gmail.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <4167af4e-edf2-9d08-94fa-5ec3fb38f32d@redhat.com>
Date: Mon, 22 May 2017 23:04:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT5riGri5d3cin9BipUso9mfQ-PBqoPzMZEEYm8RezJdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 5/22/17 10:56 PM, Chris Murphy wrote:
> On Mon, May 22, 2017 at 2:46 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
>> Second, I have only been able to reproduce this problem with grubby +
>> XFS.
> 
> OK so this is just on Fedora/RH systems, which is the example case I
> have. The kernel RPM is running a script called new-kernel-pkg which
> is part of grubby. It's found here:
> 
> https://github.com/rhinstaller/grubby/blob/master/new-kernel-pkg
> 
> # make sure changes make it to the disk.
> # if /boot is a mountpoint, force the meta data on disk
> # to by-pass writeback delay.
> # PPC64LE-only to deal with Petitboot issues
> if [ "$ARCH" = "ppc64le" ]; then
>     sync && mountpoint -q /boot && fsfreeze -f /boot && fsfreeze -u /boot
> fi
> 
> 
> So why only Petitboot on ppc64 is considered to need this?

because petitboot essentially a full kernel & userspace, and it is
(may be?) a different endianness than the os and the filesystem it's booting...
so normally it actually /could/ replay the log, but it can't due to the
different endianness.  So, freeze / unfreeze to quiesce, and then
petitboot does mount -o norecovery to ignore the unmount record we leave
lying around on a frozen fs.

Hacks upon hacks.

-Eric

> Also I put zipl in the bootloader category that doesn't need to be totally
> reinstalled, which is incorrect it's more like lilo. I guess I was thinking of
> yaboot. In any case the main point remains that the common
> bootloaders being used these days depend only on modification of a
> bootloader configuration file via the file system that file is located
> on.
> 
> 

