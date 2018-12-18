Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:34741 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbeLRCmB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 21:42:01 -0500
Received: by mail-lj1-f181.google.com with SMTP id u89-v6so2151149lje.1
        for <linux-xfs@vger.kernel.org>; Mon, 17 Dec 2018 18:42:00 -0800 (PST)
MIME-Version: 1.0
References: <CAJDdQW1bUSZ+3p-4XMbtzU0y5SifQnnwmStKGhb5dkozCaExoA@mail.gmail.com>
 <20181217233343.GE10644@dastard>
In-Reply-To: <20181217233343.GE10644@dastard>
From: =?UTF-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Date: Tue, 18 Dec 2018 10:41:48 +0800
Message-ID: <CAJDdQW2U5hE2W245iodcOF408DV8W1D1-MSRtSMvY8=TT9rnCg@mail.gmail.com>
Subject: Re: XFS: 3-way deadlock with xfs_dquot, xfs_buf and xfs_inode
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

Dave Chinner <david@fromorbit.com> =E4=BA=8E2018=E5=B9=B412=E6=9C=8818=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=887:33=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Dec 15, 2018 at 01:34:33PM +0800, =E5=BC=A0=E6=9C=AC=E9=BE=99 wro=
te:
> > Hi Developpers and XFS,
> >
> > There seems to be a deadlock involving 3 threads: 1) the fsync thread
> > has acquired the project quota lock, and is trying to get the xfs_buf
> > (it's a an agf); 2) the xfs_buf is attached to a transaction, and
> > xfs_end_io is trying to get the xfs_inode ilock; 3) the write thread
> > has acquired the xfs_inode ilock, and tries to get the xfs_dquot.
> > Below are the traces.
>
> I don't see a deadlock here. What's holding the AGF lock and
> preventing progress from being made?
>

Oh, I was thinking the AGF is attached to a transaction. So between
xfs_trans_bjoin() and xfs_trans_commit(), a buf cannot be used by
others right? Then it should be released by xfs_end_io() in
xfs_trans_commit(), and the deadlock is like:

Thread          1                  2
         3
                   fsync()
                   dqlock P
                   agf lock
                   <blocks>
                                  xfs_end_io
                                  (agf locked by transaction)
                                  ilock A
                                  <blocks>
                                  unlock agf in trans commit

            write()

            ilock A

            dqlock P

            <blocks>

> i.e. we have:
>
> process         1               2               3
>         fsync()
>           ilock A
>           dqlock P
>             agf lock
>             <blocks>
>                                 xfs_end_io
>                                   ilock A
>                                   <blocks>
>                                                 write()
>                                                   ilock B
>                                                   dqlock P
>                                                   <blocks>
>
> So, basically, everyhting is waiting for the AGF lock, which
> is held by something other than these three threads. When the AGF
> lock is relesaed, the fsync() will make progress, then release
> both dqlock P and ilock A and the other two threads will make
> progress again.
>

Absolutely possible. fsync() indeed acquired ilock in
xfs_iomap_write_allocate(). Yes the key is who holds AGF in this
scenario.

But in either guess it seems the AGF is being held by a transaction,
blocked in xfs_end_io() by ilock.
> > It's 3.10.0-514.16.1.el7.x86_64 kernel, met about 10-20 times a week
> > on several hundred of servers.
>
> That's not a mainline kernel and so we can't really help diagnose
> this much further. You should really report it to your distro
> support channels so they can help you with further diagnosis and
> fixes...

Oh oh sure, thank you for pointing out. We don't have support channels
since we use CentOS...

I really appreciate your reply!
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
