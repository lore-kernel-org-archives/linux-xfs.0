Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f180.google.com ([209.85.166.180]:39556 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbeJKP0C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 11:26:02 -0400
Received: by mail-it1-f180.google.com with SMTP id w200-v6so11883767itc.4
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 00:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <CABXGCsPMXLbPJdAFq79Fmby3y89s=o7F-tf_+zSo_RsJXjaRaA@mail.gmail.com>
 <20181011060027.GP6311@dastard> <CABXGCsNzZKE6-7LB9_KQi=YuhWcd=GRZPG-FeicZiz8bEwb23g@mail.gmail.com>
 <20181011071536.GQ6311@dastard>
In-Reply-To: <20181011071536.GQ6311@dastard>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Thu, 11 Oct 2018 12:59:43 +0500
Message-ID: <CABXGCsO7jedQpPhQcRRqytdvX3YpycMLA-sjjjkRPvozvDtj3A@mail.gmail.com>
Subject: Re: xfs_bmap stuck at ~/.steam/steam.pipe file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, 11 Oct 2018 at 12:15, Dave Chinner <david@fromorbit.com> wrote:
> > # cat /proc/21024/stack
> > [<0>] pipe_wait+0x6c/0xb0
> > [<0>] wait_for_partner+0x19/0x50
> > [<0>] fifo_open+0x266/0x2c0
> > [<0>] do_dentry_open+0x132/0x340
> > [<0>] path_openat+0x334/0x1610
> > [<0>] do_filp_open+0x93/0x100
> > [<0>] do_sys_open+0x186/0x210
> > [<0>] do_syscall_64+0x5b/0x160
> > [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [<0>] 0xffffffffffffffff
>
> Hmmm. That's waiting for pipe to connect, not waiting for
> an XFS file to open.
>
> *ding*
>
> You ran xfs_bmap on a *named pipe*, not a regular file. Yeah,
> xfs_bmap is waiting for the other end of the pipe to be
> connected to something, which never happens. Only regular files and
> directories have extents, so running xfs_bmap on a pipe is not a
> useful thing to do.
>
> Ok, so there's an element of user error here, but xfs_io doesn't
> check that it's getting anything other than regular files,
> directories or block devices so I'm guessing we'll have to add a
> check to error this case out before opening the pipe.

Thank you very much, Dave.
I may be first tester of this patch.
P.S. It looks like email "g@dastard" wrote with error in previous message.

--
Best Regards,
Mike Gavrilov.
