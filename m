Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:56756 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933000AbdKAVzo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <20171101213230.GR5858@dastard>
References: <CAM_iQpU9A+KpSdXceUuz-cUX+f91bttKwJCOE91LnTZmKofk_Q@mail.gmail.com>
 <20171031003358.GD5858@dastard> <CAM_iQpUD5ffaKS7TQ5n9A67TWqrVm8AVKf6ERz3pSFu7rL2rbg@mail.gmail.com>
 <20171101030536.GN5858@dastard> <CAM_iQpVOmNj6aDNr-Z5owAxS0o0+1j7P3=qzzUWci0f2wVnvaw@mail.gmail.com>
 <20171101050701.GP5858@dastard> <20171101213230.GR5858@dastard>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 1 Nov 2017 14:55:23 -0700
Message-ID: <CAM_iQpWi7=4C1M-a3TROU-EE88FYRSbgDabQUS+nzzMZk9CEHQ@mail.gmail.com>
Subject: Re: xfs: list corruption in xfs_setup_inode()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>

On Wed, Nov 1, 2017 at 2:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Nov 01, 2017 at 04:07:01PM +1100, Dave Chinner wrote:
>> On Tue, Oct 31, 2017 at 09:43:03PM -0700, Cong Wang wrote:
>> > On Tue, Oct 31, 2017 at 8:05 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > > On Tue, Oct 31, 2017 at 06:51:08PM -0700, Cong Wang wrote:
>> > >> >> Please let me know if I can provide any other information.
>> > >> >
>> > >> > How do you reproduce the problem?
>> > >>
>> > >> The warning is reported via ABRT email, we don't know what was
>> > >> happening at the time of crash.
>> > >
>> > > Which makes it even harder to track down. Perhaps you should
>> > > configure the box to crashdump on such a failure and then we
>> > > can do some post-failure forensic analysis...
>> >
>> > Yeah.
>> >
>> > We are trying to make kdump working, but even if kdump works
>> > we still can't turn on panic_on_warn since this is production
>> > machine.
>>
>> Hmmm. Ok, maybe you could leave a trace of the xfs_iget* trace
>> points running and check the log tail for unusual events around the
>> time of the next crash. e.g. xfs_iget_reclaim_fail events. That
>> might point us to a potential interaction we can look at more
>> closely. I'd also suggest slab poisoning as well, as that will
>> catch other lifecycle problems that could be causing list
>> corruptions such as use-after-free.

Not sure if I can use trace, because this stack trace was triggered
by systemd-tmpfile during boot (before login).

>
> FWIW, I note that you are reporting another memory
> corruption/use-after-free related crash in the pipe_inode_info
> structure on these same machines.  I'd suggest that you start with
> the premise that this list corruption has the same root cause...

That's impossible. First of all, the machine triggered xfs warning
is different from the machines triggered free_pipe_info() crashes.
Secondly, this one is on 4.9 kernel while the other one is on 4.1.

Thanks.
