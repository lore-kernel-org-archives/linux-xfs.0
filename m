Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:46243 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfEaRWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 May 2019 13:22:19 -0400
MIME-Version: 1.0
References: <20190527172655.9287-1-amir73il@gmail.com> <20190528202659.GA12412@mit.edu>
 <CAOQ4uxgo5jmwQbLAKQre9=7pLQw=CwMgDaWPaJxi-5NGnPEVPQ@mail.gmail.com>
 <CAOQ4uxgj94WR82iHE4PDGSD0UDxG5sCtr+Sv+t1sOHHmnXFYzQ@mail.gmail.com> <20190531164136.GA3066@mit.edu>
In-Reply-To: <20190531164136.GA3066@mit.edu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 31 May 2019 20:22:06 +0300
Message-ID: <CAOQ4uxjp5psDBLXBu+26xRLpV50txqksVFe6ZhUo0io8kgoH4A@mail.gmail.com>
Subject: Re: [RFC][PATCH] link.2: AT_ATOMIC_DATA and AT_ATOMIC_METADATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Chris Mason <clm@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>

On Fri, May 31, 2019 at 7:41 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Fri, May 31, 2019 at 06:21:45PM +0300, Amir Goldstein wrote:
> > What do you think of:
> >
> > "AT_ATOMIC_DATA (since Linux 5.x)
> > A filesystem which accepts this flag will guarantee that if the linked file
> > name exists after a system crash, then all of the data written to the file
> > and all of the file's metadata at the time of the linkat(2) call will be
> > visible.
>
> ".... will be visible after the the file system is remounted".  (Never
> hurts to be explicit.)
>
> > The way to achieve this guarantee on old kernels is to call fsync (2)
> > before linking the file, but doing so will also results in flushing of
> > volatile disk caches.
> >
> > A filesystem which accepts this flag does NOT
> > guarantee that any of the file hardlinks will exist after a system crash,
> > nor that the last observed value of st_nlink (see stat (2)) will persist."
> >
>
> This is I think more precise:
>
>     This guarantee can be achieved by calling fsync(2) before linking
>     the file, but there may be more performant ways to provide these
>     semantics.  In particular, note that the use of the AT_ATOMIC_DATA
>     flag does *not* guarantee that the new link created by linkat(2)
>     will be persisted after a crash.

OK. Just to be clear, mentioning hardlinks and st_link is not needed
in your opinion?

>
> We should also document that a file system which does not implement
> this flag MUST return EINVAL if it is passed this flag to linkat(2).
>

OK. I think this part can be documented as possible reason for EINVAL
As in renameat(2) man page:
       EINVAL The filesystem does not support one of the flags in flags.

Thanks,
Amir.
