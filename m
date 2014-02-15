Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A01729DF8
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 12:18:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6009D8F8087
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 10:18:48 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id a3AOM3Rs0DKMd2DL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Feb 2014 10:05:28 -0800 (PST)
Date: Sat, 15 Feb 2014 18:05:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215180520.GC18016@ZenIV.linux.org.uk>
References: <20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140213174020.GA14455@redhat.com>
	<CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
	<20140215052531.GX18016@ZenIV.linux.org.uk>
	<20140215142700.GA15540@redhat.com>
	<20140215152251.GY18016@ZenIV.linux.org.uk>
	<20140215153631.GZ18016@ZenIV.linux.org.uk>
	<20140215155838.GA18016@ZenIV.linux.org.uk>
	<20140215174345.GA24799@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140215174345.GA24799@redhat.com>
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

On Sat, Feb 15, 2014 at 06:43:45PM +0100, Oleg Nesterov wrote:
> > So basically we want a different condition for "can we just go ahead and
> > free that sucker", right?  Instead of "it's on the list, shan't free it"
> > it ought to be something like "it's on the list or it is referenced by
> > ksiginfo".  Locking will be interesting, though... ;-/
> 
> I guess yes... send_sigqueue() checks list_empty() too, probably nobody else.

The trouble being, we might end up with
	Q picked by collect_signal and and stuff into ksiginfo
	Q resubmitted by timer code
	Q picked by *another* thread into its ksiginfo
	the first thread finally done with signal
and at that point we still have a reference in the second thread's ksiginfo.
Hell knows - my first reflex in that kind of situation is to replace
that flag with refcount, so that timer code would hold a reference from
timer_create(2) to timer_delete(2), send_sigqueue() would bump it and
dismiss_siginfo() - drop the sucker.  But that means either grabbing
siglock in dismiss_siginfo() or making the counter atomic; either way
it's a cacheline ping-pong.  Atomic counter is less painful in that respect -
it would be right next to the list, so we dirty that cacheline anyway...

I'm still trying another approach (slightly bigger ksiginfo used to store
all variants with si_code >= 0), but it has messiness of its own; we'll
see how it goes...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
