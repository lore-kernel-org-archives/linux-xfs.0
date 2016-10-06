Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:49616 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753941AbcJFSMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Oct 2016 14:12:53 -0400
Date: Thu, 6 Oct 2016 14:12:47 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1015996112.893189.1475777567610.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA+55aFz28kQUAYoSFzvEpq5MkYHNcKx2KWP-kpruuyWe7AEY2Q@mail.gmail.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com> <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com> <20161005200522.GE19539@ZenIV.linux.org.uk> <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com> <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com> <1149670394.870034.1475770286233.JavaMail.zimbra@redhat.com> <CA+55aFz28kQUAYoSFzvEpq5MkYHNcKx2KWP-kpruuyWe7AEY2Q@mail.gmail.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, tj <tj@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>



----- Original Message -----
> From: "Linus Torvalds" <torvalds@linux-foundation.org>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Al Viro" <viro@zeniv.linux.org.uk>, "tj" <tj@kernel.org>, "Dave Chinner" <david@fromorbit.com>, "linux-xfs"
> <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>, "linux-fsdevel"
> <linux-fsdevel@vger.kernel.org>
> Sent: Thursday, October 6, 2016 1:00:08 PM
> Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> 
> On Thu, Oct 6, 2016 at 9:11 AM, CAI Qian <caiqian@redhat.com> wrote:
> >
> >>
> >> Wait. There is also a lockep happened before the xfs internal error as
> >> well.
> > Some other lockdep this time,
> 
> This one looks just bogus.
> 
> > [ 4872.569797]  Possible unsafe locking scenario:
> > [ 4872.569797]
> > [ 4872.576401]        CPU0
> > [ 4872.579127]        ----
> > [ 4872.581854]   lock(&xfs_nondir_ilock_class);
> > [ 4872.586637]   <Interrupt>
> > [ 4872.589558]     lock(&xfs_nondir_ilock_class);
> 
> I'm not seeing that .lock taken in interrupt context.
> 
> I'm wondering how many of your reports are confused by earlier errors
> that  happened.
Hmm, there was no previous error/lockdep/warnings on the console prior to
this AFAICT. It was a fresh trinity run after reboot.

The previous run triggered seq_read/__sb_start_write lockdep and
then xfs XFS_WANT_CORRUPTED_RETURN internal error was highlighted
in another reply was also started from a fresh reboot.

After all of those individual runs it will reliably triggered the
cgroup hang from any systemctl command or "make install" of kernel etc.
   CAI Qian
