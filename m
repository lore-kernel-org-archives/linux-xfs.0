Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38094 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfF0ANz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 20:13:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so334566wrs.5
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 17:13:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
 <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com> <CAFVd4NszdvQ0P4KPo9pRqtRRJxebhtMBqGVAZTmGAPBWe25nFg@mail.gmail.com>
In-Reply-To: <CAFVd4NszdvQ0P4KPo9pRqtRRJxebhtMBqGVAZTmGAPBWe25nFg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 26 Jun 2019 18:13:41 -0600
Message-ID: <CAJCQCtTqaTSNFcFxJgopsA9ekS0yx743TxE99n7_teSairH+oA@mail.gmail.com>
Subject: Re: XFS Repair Error
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rich Otero <rotero@editshare.com>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>, Steve Alves <steve.alves@editshare.com>

On Wed, Jun 26, 2019 at 3:30 PM Rich Otero <rotero@editshare.com> wrote:
>
> > This applies
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> kernel version: 3.12.17
> xfsprogs version: 3.1.7

All of the upstream file system lists are primarily for development of
what's in linux-next, mainline, and most recent stable kernels.
Anything much older is sort of an archaeological curiosity, but
otherwise it's really the distribution's responsibility to handle
issues if they've decided to keep on supporting something this old.

You found a curious/unexpected xfs_repair error with an ancient
version, and that's fine. But you kinda need to check it with
something a lot more recent to be relevant to this list.

> > Also, are the disk failures fixed? Is the RAID happy? I'm very
> > skeptical of writing anything, including repairs, let alone rw
> > mounting, a file system that's one a busted or questionably working
> > storage stack. The storage stack needs to be in working order first.
> > Is it?
>
> This particular server is used for development purposes and the data
> stored on it is replicated on other servers, so the integrity of the
> data is not very important. We have used XFS in our storage products
> for 15 years, mostly on RAID-5 and RAID-6 using LSI 3ware and Broadcom
> MegaRAID cards. It is not uncommon for disks to fail and be replaced
> and for the RAID to rebuild while the XFS is still in use, and we very
> rarely experience XFS problems during or after the rebuild. In this
> particular case, we suspected a malfunctioning RAID card and replaced
> it, and we are replacing some faulty disks.

Regardless of what file system and versions, a repair is going to
write changes to the file system. Writes to the file system when the
underlying storage stack state is not certainly healthy, is asking for
more damage, not a repair.

>
> > OK why -L ? Was there a previous mount attempt and if so when kernel
> > errors? Was there a previous repair attempt without -L? -L is a heavy
> > hammer that shouldn't be needed unless the log is damaged and if the
> > log is damaged or otherwise can't be replayed, you should get a kernel
> > message about that.
>
> Previously, mounting the XFS failed because the "structure must be
> cleaned." That led to the first attempt at xfs_repair without -L,
> which ended in an error complaining that the journal needed to be
> replayed. But since I couldn't mount, that was impossible, so the
> second xfs_repair attempt was with -L.

OK fair enough. Just for future reference, I suggest using a kernel
less than a year old and attempt a normal mount to see if possibly you
have run into an already fixed bug in the older kernel; and then a
newer xfsprogs using xfs_repair -n output reported to the list is at
least safe. If you run out of time waiting for a reply, I doubt many
people would fault you for moving on. But there's not that much
interesting with such old user space tools and zeroing out the log,
and with a questionable state for the underlying storage stack it's
really difficult to know what caused what problem. File systems are
already sufficiently non-deterministic in normal operation, but then
haphazard repair attempts with old tools and uncertain health state of
the storage stack make it substantially more difficult to figure out
what went wrong.


> I needed to make this server functional again quickly, and since I
> didn't care about losing the data, I simply reformatted the RAID
> (`mkfs.xfs -f`), so I won't be able to reproduce the xfs_repair error.
> In my eight years using XFS, I've never seen that error before, so I
> thought it would be interesting to report to the list and see what I
> could learn about it.

I can definitely see how it would seem to be interesting. But, sorry,
it isn't that interesting. Interesting is, you ran into a issue with
3.12, and tried again on 5.1 and ran into the same or even a different
problem.

$ git rev-list --count v3.12..v5.1 -- fs/xfs/
2603
$ git rev-list --count v3.12..v5.1 -- fs/btrfs/
4208
$ git rev-list --count v3.12..v5.1 -- fs/ext4/
1316

I don't think developers expect users to know esoteric things like the
metric f ton of development changes that happen over time. But as a
non-developer who tracks a tiny bit of what upstreams are up to, these
are very actively developed file systems, and there are tens of
thousands of changes since the 3.12 kernel. It's not just a few
hundred trivial bug fixes either. It's really a lot of work and kernel
3.12 is like 1940's case law. I rather hope they're thinking it's
impressive production file systems are using such an old kernel - and
I mean why not? A f ton of work went into making 3.12 what it is as
well, but there's only so many brain cells to remember the massive
number of changes since then. Maintaining old kernels is a speciality,
and upstream deals with much newer code. That's all.

--
Chris Murphy
