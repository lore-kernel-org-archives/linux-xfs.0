Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3EB007F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:52:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2156D8F8035
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 12:51:56 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id lmrspaJLs4IVCVG5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 12:51:55 -0800 (PST)
Date: Thu, 13 Feb 2014 20:51:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140213205146.GS18016@ZenIV.linux.org.uk>
References: <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140212214411.GQ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140212214411.GQ18016@ZenIV.linux.org.uk>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Oleg Nesterov <oleg@redhat.com>, xfs@oss.sgi.com, Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, Feb 12, 2014 at 09:44:11PM +0000, Al Viro wrote:

> I'll try to put something along those lines together, if you or Oleg don't
> do it first.

OK, having looked at that stuff...

1) things become much more compact if we finish conversion to get_signal()
first.  Callers of get_signal_to_deliver() have k_sigaction and siginfo in
pair of local variables; switching to ksignal will be neutral wrt stack
footprint (it just gathers those two in one struct) *and* we are getting
rid of passing struct siginfo * around.  With that done, we can change
struct ksignal ->info with zero impact on the code in arch/*, and conversion
makes sense on its own.  In the mainline we have it done for alpha, arm,
openrisc, sparc and x86.  I've just put together preliminary (and completely
untested) patches for arm64, m68k and um; doing the rest won't take long, but
they'll obviously need to be tested.  It's a fairly safe conversion;
I'd expect the worst bugs to be typos.

2) struct small_siginfo ought to go into linux/signal.h.  Contains signal
number, si_code (usually 0), uid, pid and (often NULL) pointer to
struct sigqueue.  Overall: 20 or 24 bytes.  In struct coredump_params we
should replace ->siginfo with pointer to struct small_siginfo.  Ditto for
task_struct ->last_siginfo.  In struct ksignal ->info becomes
struct small_siginfo.

copy_siginfo_to_user{,32}() gets switched to struct small_siginfo *, so does
do_coredump(), ptrace_signal(), ptrace_stop(), ptrace_getsiginfo(),
ptrace_setsiginfo(), collect_signal(), __dequeue_signal(), dequeue_signal(),
signalfd_dequeue() and do_sigtimedwait().

New primitive: assign_sigqueue(small_info, sigqueue).  Frees
small_info->q and assigns a new value to it.

When ptrace_setsiginfo() is given a non-plain siginfo (si_code != SI_USER,
that is), it should a allocate struct sigqueue, copy the sucker there and
give it to assign_sigqueue().  Plain ones just get uid/pid/signo copied
and NULL passed to assign_sigqueue().

code in ptrace_signal() under if (signr != info->si_signo) should
start with assign_sigqueue(info, NULL).

specific_send_sig_info() in ptrace_signal() is rather clumsy to handle; not
sure what's the best way to deal with that.  In any case, ptrace_signal()
deciding to return 0 should take care of info->q - either copy and free the
original, or actually try to reuse the sucker.  Either way, info->q should
become NULL.

get_signal_to_deliver() should do assign_sigqueue(info, NULL) before
the call of do_group_exit().

arch_ptrace_stop_needed() can be left as-is; it's a macro and none of the
instances look at the info argument at all.  The same goes for
arch_ptrace_stop().

signalfd_read() should do assign_sigqueue(&info, NULL) right after
signalfd_copyinfo().

rt_sigtimedwait(2) and its compat variant should do the same right after
copy_siginfo_to_user{,32}().

TP'ed stuff is a mess, as usual.  AFAICS, TP_STORE_SIGINFO() needs to
be split into a variant taking siginfo (on trace_signal_generate side)
and one taking small_siginfo (for trace_signal_deliver).

get_signal() should do assign_sigqueue(&ksig->info, NULL) if it returns
false and use task_work_add() to schedule info->q for freeing otherwise.


Overall, aside of the need to complete arch/* conversion, the only unfinished
part is this:
        /* If the (new) signal is now blocked, requeue it.  */
        if (sigismember(&current->blocked, signr)) {
                specific_send_sig_info(signr, info, current);
                signr = 0;
        }
in the end of ptrace_signal().  Sure, we can add a local struct siginfo
in that if, fill it if needed and pass its address or &info->q->info
to specific_send_sig_info(), but that feels kludgy...  Hell knows, I'll
look a bit more into that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
