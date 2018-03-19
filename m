Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:43614 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932595AbeCSIma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 04:42:30 -0400
Received: by mail-oi0-f67.google.com with SMTP id y27so9434817oix.10
        for <linux-xfs@vger.kernel.org>; Mon, 19 Mar 2018 01:42:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard> <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard> <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 Mar 2018 09:42:29 +0100
Message-ID: <CAJfpegvsiB_E0tNM90ppQSzRfrTBdgWu3gsUMttXtir4RQ-+fg@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 19, 2018 at 5:03 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Mar 19, 2018 at 1:02 AM, Dave Chinner <david@fromorbit.com> wrote:

>> Given that overlay has a persistent inode numbering problem, why
>> doesn't overlay just allocate and store it's own inode numbers and
>> other required persistent state in an xattr?
>
> First, this is not as simple as it sounds.
> If you have a huge number of readonly files in multiple lower layers,
> it makes no sense to scan them all on overlay mount to discover which
> inode numbers are free to use and it make no sense either to create
> a persistent mapping for every lower file accessed in that case.
> And there are other problematic factors with this sort of scheme.

Such as when all layers are read-only.   Where do we store the
persistent inode numbers in that case?

>
> Second, and this may be a revolutionary argument, I would like to
> believe that we are all working together for a "greater good".
> Sure, xfs developers strive to perfect and enhance xfs and overlayfs
> developers strive to perfect and enhance overlayfs.
> But when there is an opportunity for synergy between subsystems,
> one should consider the best solution as a whole and IMHO,
> the solution of filesystem declaring already unused ino bits
> is the best solution as a whole. xfs is not required to declare
> s_max_ino_bits for all eternity, only for this specific super block
> instance, in this specific kernel.

The "specific kernel" part requires clarification.  We do promise
backward compatibility when upgrading the kernel, and silently
increasing s_max_ino_bits on a kernel upgrade would break that
promise.  Could be backed by a feature flag.  And unlimited use could
be the default, people have learned to live with needing special
features for overlayfs.

And I do agree with Amir, that the "mine all mine" philosophy isn't
necessarily the right one.  In normal cases overlayfs would just use
one or two bits of the inumber space.  While Amir's current patch
keeps the layer index in the spare bits, it is sufficient to hold an
"fs index" that is incremented when a new superblock is encountered
during enumeration of layers.  The number of different fs instances
used for creating an overlay is unlikely to be large, so for all
practical purposes a few (4-6) bits should be enough.

Thanks,
Miklos
