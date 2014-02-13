Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 81C937F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 12:37:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 656D2304053
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 10:37:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Jt8AEmV3GHgrE9YG for
	<xfs@oss.sgi.com>; Thu, 13 Feb 2014 10:37:36 -0800 (PST)
Date: Thu, 13 Feb 2014 19:37:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140213183736.GA16937@redhat.com>
References: <20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140213174020.GA14455@redhat.com>
	<CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
	<20140213181013.GA15596@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140213181013.GA15596@redhat.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>

On 02/13, Oleg Nesterov wrote:
>
> On 02/13, Linus Torvalds wrote:
> >
> > On Thu, Feb 13, 2014 at 9:40 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > And we should be careful with SIGQUEUE_PREALLOC, at least
> > > collect_signal() should not do list_del_init()... Plus we need to
> > > handle the SEND_SIG_FORCED-like case.
> >
> > I don't think the users need to care. They'd just call
> > "sigqueue_free()" not knowing about our preallocations etc.
>
> Yes, but we need to be careful to avoid the races with
> release_posix_timer().

Plus we need to delay do_schedule_next_timer() as well. But this
is probably good because we can avoid unlock/lock(siglock) in
dequeue_signal().

Oleg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
