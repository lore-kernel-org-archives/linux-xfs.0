Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC4b6aP071328 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 22:37:07 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CA022B4366
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 20:37:05 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4BG6GDiG4EsWZBDD for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 20:37:05 -0800 (PST)
Date: Mon, 12 Dec 2011 15:36:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS causing stack overflow
Message-ID: <20111212043657.GO14273@dastard>
References: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
	<20111209115513.GA19994@infradead.org>
	<20111209221956.GE14273__25752.826271537$1323469420$gmane$org@dastard>
	<m262hop5kc.fsf@firstfloor.org> <20111210221345.GG14273@dastard>
	<20111211000036.GH24062@one.firstfloor.org>
	<20111211230511.GH14273@dastard>
	<20111212023130.GI24062@one.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212023130.GI24062@one.firstfloor.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, "Ryan C. England" <ryan.england@corvidtec.com>, xfs@oss.sgi.com

On Mon, Dec 12, 2011 at 03:31:30AM +0100, Andi Kleen wrote:
> > But that happens before do_IRQ is called, so what is the do_IRQ call
> > chain doing on this stack given that we've already supposed to have
> > switched to the interrupt stack before do_IRQ is called?
> 
> Not sure I understand the question.
> 
> The pt_regs are on the original stack (but they are quite small), all the rest 

It's ~180 bytes, so it's not really that small.

> is on the new stack. ISTs are not used for interrupts, only for 
> some special exceptions.

IST = ???

> do_IRQ doesn't switch any stacks on 64bit.

No, but it appears that it's caller does:

/* 0(%rsp): ~(interrupt number) */
        .macro interrupt func
        /* reserve pt_regs for scratch regs and rbp */
        subq $ORIG_RAX-RBP, %rsp
        CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
        SAVE_ARGS_IRQ
        call \func
        .endm

and the SAVE_ARGS_IRQ macro switches to the per cpu interrupt stack.
The only caller does this:

common_interrupt:
        XCPT_FRAME
        addq $-0x80,(%rsp)              /* Adjust vector to [-256,-1] range */
        interrupt do_IRQ

So, why do we get this:

Dec  6 20:27:55 localhost kernel: <IRQ>  [<ffffffff81067097>] ?  warn_slowpath_common+0x87/0xc0
Dec  6 20:27:55 localhost kernel: [<ffffffff8106f6da>] ?  __do_softirq+0x11a/0x1d0
Dec  6 20:27:55 localhost kernel: [<ffffffff81067186>] ?  warn_slowpath_fmt+0x46/0x50
Dec  6 20:27:55 localhost kernel: [<ffffffff8100c2cc>] ?  call_softirq+0x1c/0x30
Dec  6 20:27:55 localhost kernel: [<ffffffff8100dfcf>] ?  handle_irq+0x8f/0xa0
Dec  6 20:27:55 localhost kernel: [<ffffffff814e310c>] ? do_IRQ+0x6c/0xf0
Dec  6 20:27:55 localhost kernel: [<ffffffff8100bad3>] ?  ret_from_intr+0x0/0x11
Dec  6 20:27:55 localhost kernel: <EOI>  [<ffffffff8115b80f>] ?  kmem_cache_free+0xbf/0x2b0

at the top of the stack frame? Is the stack unwinder walking back
across the interrupt stack to the previous task stack?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
