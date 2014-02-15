Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7837529DF8
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 11:44:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 775DC8F8131
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 09:44:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 81qWAFSUVFbGiv6J for
	<xfs@oss.sgi.com>; Sat, 15 Feb 2014 09:43:54 -0800 (PST)
Date: Sat, 15 Feb 2014 18:43:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215174345.GA24799@redhat.com>
References: <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140213174020.GA14455@redhat.com>
	<CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
	<20140215052531.GX18016@ZenIV.linux.org.uk>
	<20140215142700.GA15540@redhat.com>
	<20140215152251.GY18016@ZenIV.linux.org.uk>
	<20140215153631.GZ18016@ZenIV.linux.org.uk>
	<20140215155838.GA18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140215155838.GA18016@ZenIV.linux.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>

On 02/15, Al Viro wrote:
>
> > Ouch...  I think I see what you mean.  Let me see if I got it right:
> > timer->sigq is *not* freed by collect_signal(); it's done by
> > release_posix_timer() instead, under siglock.  Frankly, this
> >         /*
> >          * If it is queued it will be freed when dequeued,
> >          * like the "regular" sigqueue.
> >          */
> >         if (!list_empty(&q->list))
> >                 q = NULL;
> > in sigqueue_free() smells like it's asking for races.  Sigh...

This is protected by ->siglock, should be safe...

> So basically we want a different condition for "can we just go ahead and
> free that sucker", right?  Instead of "it's on the list, shan't free it"
> it ought to be something like "it's on the list or it is referenced by
> ksiginfo".  Locking will be interesting, though... ;-/

I guess yes... send_sigqueue() checks list_empty() too, probably nobody else.


> BTW, I really wonder how does that stuff interact with PTRACE_SETSIGINFO.
> What happens if tracer does PTRACE_GETSIGINFO, changes ->si_signo to
> something blocked, shoves it back with PTRACE_SETSIGINFO and does
> PTRACE_CONT with that new signal number?  Would we get two sigqueue instances
> with the same ->si_tid, one of them matching the timer->sigq and another
> - not?

Or the task sends a SI_TIMER info to itself via sys_rt_sigqueueinfo().

Afaics, nothing really bad can happen, I mean the kernel should not
crash or something like this. do_schedule_next_timer() can be fooled,
but at least lock_timer() can only succeed if this process actually
has a timer with the same timer_id. This sigqueue != timer->sigq, but
I think this doesn't matter, posix_timer_event() will use timer->sigq
anyway.

Oleg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
