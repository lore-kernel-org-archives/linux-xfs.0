Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF31A7F58
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 18:09:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A842A304039
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 16:09:11 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id F9eKdaGFZCzsG7AC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 16:09:10 -0800 (PST)
Date: Fri, 14 Feb 2014 00:09:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214000902.GA3078@ZenIV.linux.org.uk>
References: <20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140212214411.GQ18016@ZenIV.linux.org.uk>
	<20140213205146.GS18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140213205146.GS18016@ZenIV.linux.org.uk>
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

On Thu, Feb 13, 2014 at 08:51:46PM +0000, Al Viro wrote:
> On Wed, Feb 12, 2014 at 09:44:11PM +0000, Al Viro wrote:
> 
> > I'll try to put something along those lines together, if you or Oleg don't
> > do it first.
> 
> OK, having looked at that stuff...
> 
> 1) things become much more compact if we finish conversion to get_signal()
> first.  Callers of get_signal_to_deliver() have k_sigaction and siginfo in
> pair of local variables; switching to ksignal will be neutral wrt stack
> footprint (it just gathers those two in one struct) *and* we are getting
> rid of passing struct siginfo * around.  With that done, we can change
> struct ksignal ->info with zero impact on the code in arch/*, and conversion
> makes sense on its own.  In the mainline we have it done for alpha, arm,
> openrisc, sparc and x86.  I've just put together preliminary (and completely
> untested) patches for arm64, m68k and um; doing the rest won't take long, but
> they'll obviously need to be tested.  It's a fairly safe conversion;
> I'd expect the worst bugs to be typos.

OK, there's a couple of tricks that allow to reorder that.  First of all,
temporary config symbol (ARCH_USES_KSIGNAL) selecting that stuff; if it's
not selected, we just have #define small_siginfo siginfo and
#define assign_sigqueue(info, q) WARN_ON((q) != NULL)
and that's it - most of the changes in core kernel consist of s/siginfo/small_&/
and non-trivial ones are under ifdef CONFIG_ARCH_USES_KSIGNAL for the time
being.  Small ifdefs, at that...

Once all architectures get converted, we'll just kill that config symbol and
make ifdefs unconditional.

Another is that we don't need to bother with task_work_add() at all; on
converted architectures we have signal_setup_done(..., ksig, ...) called after
each successful get_signal() (the first argument of signal_setup_done() is
"has sigframe setup failed" flag; we get there regardless of success or
failure of setup_...frame()).  So we can just have that sucker do
assign_sigqueue(&ksig->info, NULL) and be done with that - all this delayed
freeing is explicit now (and we don't get locking overhead, etc. of
task_work_add()).

If what I've got survives the local beating, I'll put it into signal.git,
throw the arch conversions I could test in there and ask on linux-arch for
help with the missing ones.  With any luck we'll get the full set by the
next merge window, at which point we'll be able to kill ifdefs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
