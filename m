Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3F457F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 06:51:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CC86AC007
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 04:51:27 -0800 (PST)
Received: from cdptpa-oedge-vip.email.rr.com
	(cdptpa-outbound-snat.email.rr.com [107.14.166.226]) by
	cuda.sgi.com with ESMTP id OPrPRWexZDNJXfei for
	<xfs@oss.sgi.com>; Wed, 12 Feb 2014 04:51:24 -0800 (PST)
Date: Wed, 12 Feb 2014 07:50:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212075059.0e3d41ab@gandalf.local.home>
In-Reply-To: <20140212083513.GF13997@dastard>
References: <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<20140212055027.GA28502@redhat.com>
	<20140212061038.GC13997@dastard> <20140212063150.GD13997@dastard>
	<CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
	<20140212083513.GF13997@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>

On Wed, 12 Feb 2014 19:35:13 +1100
Dave Chinner <david@fromorbit.com> wrote:


> And it's leaf functions that the CONFIG_STACK_TRACER doesn't catch
> on x86-64 (at least, according to the documentation).
> CONFIG_DEBUG_STACK_USAGE output is showing up to 800 bytes more
> stack usage than the tracer. As such, I also think that
> CONFIG_DEBUG_STACK_USAGE output is a more reliable iindication of
> stack usage because it is canary based and so captures the very
> worst case usage of the process's stack...

Yeah, with the new fentry (adding the mcount call before setting up the
stack frame), the function tracer can not catch leaf functions, as it
is called before the leaf function's frame is set up.

Hmm, I wonder if I should add a config to disable fentry and go back to
the old mcount that gets called after setting up the stack frame. This
will lead to better stack tracing, but you lose out on all the benefits
of fentry.

-- Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
