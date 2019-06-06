Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:45647 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfFFTub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 15:50:31 -0400
Received: by mail-yb1-f194.google.com with SMTP id v1so1367817ybi.12
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2019 12:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <CABeZSNmcmL3_VvDVvbcneDd3f2jCiu7Pn8YQ7y7mJH8BizaWXw@mail.gmail.com>
 <680c16d9-cb95-f2b1-b65b-c956b1e5c1ed@sandeen.net> <CABeZSNnw=UN9+muYXD-JYV3cECZPUfzxW1y8HE4ks=PCEdFqEQ@mail.gmail.com>
 <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
In-Reply-To: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
From: Sheena Artrip <sheena.artrip@gmail.com>
Date: Thu, 6 Jun 2019 12:50:18 -0700
Message-ID: <CABeZSN=5GZix+NzeQbfFTbGvmMv619YeOM-+z92W-3R=v1oebQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] xfs_restore: detect rtinherit on destination
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, sheenobu@fb.com

On Thu, Jun 6, 2019 at 11:39 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 6/6/19 1:12 PM, Sheena Artrip wrote:
> > On Thu, Jun 6, 2019 at 7:11 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> >>
> >> On 6/5/19 4:16 PM, Sheena Artrip wrote:
> >>> When running xfs_restore with a non-rtdev dump,
> >>> it will ignore any rtinherit flags on the destination
> >>> and send I/O to the metadata region.
> >>>
> >>> Instead, detect rtinherit on the destination XFS fileystem root inode
> >>> and use that to override the incoming inode flags.
> >>>
> >>> Original version of this patch missed some branches so multiple
> >>> invocations of xfsrestore onto the same fs caused
> >>> the rtinherit bit to get re-removed. There could be some
> >>> additional edge cases in non-realtime to realtime workflows so
> >>> the outstanding question would be: is it worth supporting?
> >>
> >> Hm, interesting.
> >>
> >> So this is a mechanism to allow dump/restore to migrate everything
> >> to the realtime subvol?  I can't decide if I like this - normally I'd
> >> think of an xfsdump/xfsrestore session as more or less replicating the
> >> filesystem that was dumped, and not something that will fundamentally
> >> change what was dumped.
> >>
> >> OTOH, we can restore onto any dir we want, and I could see the argument
> >> that we should respect things like the rtinherit flag if that's what
> >> the destination dir says.
> >
> > Yes. What is strange is that an xfsrestore onto a rtdev system will
> > silently "fill"
>
> from a filesystem that previously did not have rt files, I guess?
>

Exactly, yes.

> > the metadata partition until the available inode count goes to zero and we get
> > an ENOSPC. Not yet sure if the file data goes straight to the metadata partition
> > or if it's simply accounting for it in the metadata partition.
> >
> > I'm guessing xfsrestore should either fail-fast or allow this via
> > rtinherit detection. I don't mind putting it behind a flag either.
>
> Hm, can you more completely describe the usecase/testcase that leads to
> the problem?  I just want to make sure I have the whole picture.
>

The use case is data migration from system A to system B. Traditionally, they've
all been non-realtime to non-realtime so xfsdump/xfsrestore worked OK.
Trying the
same process for non-realtime to realtime brought up these surprising issues.

>
> >> One thing about the patch - the mechanism you've copied to get the root
> >> inode number via bulkstat turns out to be broken ... it's possible
> >> to have a non-root inode with the lowest number on the fs, unfortunately.
> >
> > I think i saw that on the list but this code is also a near-identical
> > copy of what is in xfsdump/content.c.
>
> yeah that's my mistake to fix now ;)
>
> >> But, wouldn't you want to test the rtinherit flag on the target dir anyway,
> >> not necessarily the root dir?
> >
> > Makes sense. How would I get the rtinherit flag on the target dir? Is there
> > a xfs-specific stat function that will give us a xfs_bstat_t for the
> > dstdir inode
> > I've opened or is it already part of stat64_t?
>
> it's available via the FS_IOC_FSGETXATTR ioctl:
>
> # xfs_io -c "chattr +t" mnt/rtdir
> # strace -e ioctl xfs_io -c lsattr mnt/rtdir
> ioctl(3, _IOC(_IOC_READ, 0x58, 0x7c, 0x70), 0x7ffd4cab44c0) = 0
> ioctl(3, FS_IOC_FSGETXATTR, 0x7ffd4cab45a0) = 0
> -------t-------- mnt/rtdir

Thanks!
