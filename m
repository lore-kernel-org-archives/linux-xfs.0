Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3D1957F55
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 11:00:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 338DB8F812E
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 09:00:10 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id j3ClwCb6tscvAEft (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Feb 2014 08:59:58 -0800 (PST)
Date: Sat, 15 Feb 2014 16:59:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215165951.GB18016@ZenIV.linux.org.uk>
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
To: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, Feb 15, 2014 at 03:58:38PM +0000, Al Viro wrote:

> BTW, I really wonder how does that stuff interact with PTRACE_SETSIGINFO.
> What happens if tracer does PTRACE_GETSIGINFO, changes ->si_signo to
> something blocked, shoves it back with PTRACE_SETSIGINFO and does
> PTRACE_CONT with that new signal number?  Would we get two sigqueue instances
> with the same ->si_tid, one of them matching the timer->sigq and another
> - not?

I wonder if it would be simpler to use the pointer *only* for si_code < 0
case.  It still gives us ksiginfo_t much smaller than siginfo_t, avoids
all the mess with timers and AFAICS results in less intrusive patch.
IOW, the split between "we know what that sucker is" and "completely
opaque shit the userland has given us".

I'll try to put together something along those lines and see how well does
that work...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
