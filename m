Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3401F29DF8
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 12:45:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CDD48F8133
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 10:45:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id alGtvqYCUGQiiruE for
	<xfs@oss.sgi.com>; Sat, 15 Feb 2014 10:45:33 -0800 (PST)
Date: Sat, 15 Feb 2014 19:45:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215184531.GA27314@redhat.com>
References: <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140213174020.GA14455@redhat.com>
	<CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
	<20140215052531.GX18016@ZenIV.linux.org.uk>
	<20140215142700.GA15540@redhat.com>
	<20140215152251.GY18016@ZenIV.linux.org.uk>
	<20140215153631.GZ18016@ZenIV.linux.org.uk>
	<20140215155838.GA18016@ZenIV.linux.org.uk>
	<20140215174345.GA24799@redhat.com>
	<20140215180520.GC18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140215180520.GC18016@ZenIV.linux.org.uk>
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
> On Sat, Feb 15, 2014 at 06:43:45PM +0100, Oleg Nesterov wrote:
> > > So basically we want a different condition for "can we just go ahead and
> > > free that sucker", right?  Instead of "it's on the list, shan't free it"
> > > it ought to be something like "it's on the list or it is referenced by
> > > ksiginfo".  Locking will be interesting, though... ;-/
> >
> > I guess yes... send_sigqueue() checks list_empty() too, probably nobody else.
>
> The trouble being, we might end up with
> 	Q picked by collect_signal and and stuff into ksiginfo
> 	Q resubmitted by timer code

In this case the timer code should simply inc ->si_overrun and do nothing.

IOW, list_empty() should be turned into is_queued(), and is_queued()
should be true until dismiss_siginfo() which should also do
do_schedule_next_timer(). I think.

Oleg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
