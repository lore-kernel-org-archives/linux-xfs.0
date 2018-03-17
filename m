Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:39483 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbeCQIYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Mar 2018 04:24:40 -0400
MIME-Version: 1.0
In-Reply-To: <20180317080425.GH7000@dastard>
References: <CAOQ4uxg=tK7fBCVuh74jzfYs99bp3XOSEUphpC01saCdEooLBA@mail.gmail.com>
 <20180316222456.GG7000@dastard> <CAJfpegvoFwEVP6ijUW3iUpfc4_2xTiw=AfE8P6O6VDhrGiDEqw@mail.gmail.com>
 <20180317080425.GH7000@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 17 Mar 2018 10:24:39 +0200
Message-ID: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Sat, Mar 17, 2018 at 10:04 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Mar 17, 2018 at 06:40:23AM +0100, Miklos Szeredi wrote:
[...]
>> I ask, because we've thought long and hard about what to do for
>> multiplexing inum space in overlayfs, and found no other sane options.
>> Ideas welcome, of course.
>
> Why do you need to "multiplex" the inum space? perhaps you'd do
> better to start with a description of why you want to play games
> with inode numbers, rather than just posting a patch to steal bits
> from other filesytem inode number spaces....
>

I think this patch perhaps explains best what we want to do:
https://marc.info/?l=linux-unionfs&m=151007386219743&w=2

I had already given a simple example in an earlier response.

As the the "why" question, we have several requirements for
overlay inode numbers:
1. st_ino is persistent
2. st_ino/st_dev pair is unique in the system
3. st_ino is consistent with d_ino
4. st_ino doesn't change on copy up
5. st_dev is uniform across all overlay inodes

With upstream overlayfs we meet all requirements above for
the case of all underlying layers on the same fs, by using a real
underlying inode st_ino and the overlay st_dev.

With the 'xino' patch set [1], we can meet all requirements above
also for the case of underlying layers on different fs, by multiplpexing
the inum space, as long as we know about unused high ino bits.
The ovl-xino branch already has the xfs patch (not yet posted) to publish
max_ino_bits.

Cheers!
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-xino
