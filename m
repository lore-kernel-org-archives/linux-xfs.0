Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfGJFae (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jul 2019 01:30:34 -0400
Date: Tue, 9 Jul 2019 22:30:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low! (2)
Message-ID: <20190710053030.GB2152@sol.localdomain>
References: <00000000000089a718058556e1d8@google.com>
 <f71aaffa-ecf4-1def-fe50-91f37c677537@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f71aaffa-ecf4-1def-fe50-91f37c677537@acm.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, syzbot <syzbot+6f39a9deb697359fe520@syzkaller.appspotmail.com>, syzkaller-bugs@googlegroups.com

[Moved most people to Bcc; syzbot added way too many random people to this.]

Hi Bart,

On Sat, Mar 30, 2019 at 07:17:09PM -0700, Bart Van Assche wrote:
> On 3/30/19 2:58 PM, syzbot wrote:
> > syzbot has bisected this bug to:
> > 
> > commit 669de8bda87b92ab9a2fc663b3f5743c2ad1ae9f
> > Author: Bart Van Assche <bvanassche@acm.org>
> > Date:   Thu Feb 14 23:00:54 2019 +0000
> > 
> >      kernel/workqueue: Use dynamic lockdep keys for workqueues
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17f1bacd200000
> > start commit:   0e40da3e Merge tag 'kbuild-fixes-v5.1' of
> > git://git.kernel..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1409bacd200000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1009bacd200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=8dcdce25ea72bedf
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=6f39a9deb697359fe520
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e1bacd200000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1120fe0f200000
> > 
> > Reported-by: syzbot+6f39a9deb697359fe520@syzkaller.appspotmail.com
> > Fixes: 669de8bda87b ("kernel/workqueue: Use dynamic lockdep keys for
> > workqueues")
> > 
> > For information about bisection process see:
> > https://goo.gl/tpsmEJ#bisection
> 
> Hi Dmitry,
> 
> This bisection result doesn't make sense to me. As one can see, the message
> "BUG: MAX_STACK_TRACE_ENTRIES too low!" does not occur in the console output
> the above console output URL points at.
> 
> Bart.

This is still happening on mainline, and I think this bisection result is
probably correct.  syzbot did start hitting something different at the very end
of the bisection ("WARNING: CPU: 0 PID: 9153 at kernel/locking/lockdep.c:747")
but that seems to be just because your commit had a lot of bugs in it, which had
to be fixed by later commits.  In particular, the WARNING seems to have been
fixed by commit 28d49e282665e ("locking/lockdep: Shrink struct lock_class_key").

What seems to still be happening is that the dynamic lockdep keys which you
added make it possible for an unbounded number of entries to be added to the
fixed length stack_trace[] array in kernel/locking/lockdep.c.  Hence the "BUG:
MAX_STACK_TRACE_ENTRIES too low!".

Am I understanding it correctly?  How did you intend this to work?

- Eric
