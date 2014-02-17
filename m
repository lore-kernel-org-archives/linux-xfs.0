Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 131DE7F85
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 11:46:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF6388F8035
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 09:46:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CvbQzu8y8N03B6TP for
	<xfs@oss.sgi.com>; Mon, 17 Feb 2014 09:46:53 -0800 (PST)
Date: Mon, 17 Feb 2014 18:46:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140217174648.GA6176@redhat.com>
References: <20140215052531.GX18016@ZenIV.linux.org.uk>
	<20140215142700.GA15540@redhat.com>
	<20140215152251.GY18016@ZenIV.linux.org.uk>
	<20140215153631.GZ18016@ZenIV.linux.org.uk>
	<20140215155838.GA18016@ZenIV.linux.org.uk>
	<20140215174345.GA24799@redhat.com>
	<20140215180520.GC18016@ZenIV.linux.org.uk>
	<20140215184531.GA27314@redhat.com>
	<20140217165735.GA29173@redhat.com>
	<20140217174059.GD18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140217174059.GD18016@ZenIV.linux.org.uk>
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

On 02/17, Al Viro wrote:
>
> On Mon, Feb 17, 2014 at 05:57:35PM +0100, Oleg Nesterov wrote:
>
> > Looks like, this is all is really nasty. Actually, I think siginfo on
> > stack is not that bad if we are going to do handle_signal() or restart,
> > perhaps we can do the extra kmalloc/memcpy/kfree for do_coredump().
> > Something like below.
>
> Yecchhhh...  You've just broken every architecture other than x86,

Of course, this is only to explain what I meant.

> and to
> fix them you'll need to massage every get_signal()/get_signal_to_deliver()
> user out there,

Yes.

> pulling the logics *out* of kernel/signal.c and into arch/*.

Not really, I think. Of course this change should be cleanuped. And it
should not require to change all architectures at once.

> This is just plain wrong.

I agree, this change is also ugly.

Oleg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
