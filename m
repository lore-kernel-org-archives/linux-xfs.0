Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:42343 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932227AbcJEPyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 11:54:54 -0400
Date: Wed, 5 Oct 2016 11:54:48 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161005153014.GC26977@htj.duckdns.org>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <774397084.821469.1475260403929.JavaMail.zimbra@redhat.com> <20161003013737.GR19539@ZenIV.linux.org.uk> <1937480340.100083.1475516965286.JavaMail.zimbra@redhat.com> <1812816839.401734.1475602751170.JavaMail.zimbra@redhat.com> <20161004214219.GN4205@htj.duckdns.org> <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com> <20161005153014.GC26977@htj.duckdns.org>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: tj <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org



----- Original Message -----
> From: "tj" <tj@kernel.org>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Al Viro" <viro@ZenIV.linux.org.uk>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner"
> <david@fromorbit.com>, "linux-xfs" <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin"
> <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org
> Sent: Wednesday, October 5, 2016 11:30:14 AM
> Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> 
> Hello, CAI.
> 
> On Wed, Oct 05, 2016 at 10:09:39AM -0400, CAI Qian wrote:
> > > This one seems to be the offender.  cgroup is trying to offline a
> > > cpuset css, which takes place under cgroup_mutex.  The offlining ends
> > > up trying to drain active usages of a sysctl table which apprently is
> > > not happening.  Did something hang or crash while trying to generate
> > > sysctl content?
> >
> > Hmm, I am not sure, since the trinity was running from an non-privileged
> > user which can only read content from /proc or /sys.
> 
> So, userland, priviledged or not, can't cause this.  The ref is held
> only while the kernel code is operating to generate content or
> iterating, which shouldn't be affected by userland actions.  This is
> caused by kernel code hanging or crashing while holding a ref.
Right, the trinity calls many different random syscalls and options on those
/proc/ and /sys/ files and generate lots of different errno. It is likely
some of error-path out there causes hang or crash.
    CAI Qian
