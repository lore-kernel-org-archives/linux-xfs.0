Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC5DFVm072929 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 23:13:15 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDE3B156DE03
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 21:13:12 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 9e7srfs5lhq9wqyS for
	<xfs@oss.sgi.com>; Sun, 11 Dec 2011 21:13:12 -0800 (PST)
Date: Mon, 12 Dec 2011 06:13:11 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS causing stack overflow
Message-ID: <20111212051311.GJ24062@one.firstfloor.org>
References: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
	<20111209115513.GA19994@infradead.org>
	<20111209221956.GE14273__25752.826271537$1323469420$gmane$org@dastard>
	<m262hop5kc.fsf@firstfloor.org> <20111210221345.GG14273@dastard>
	<20111211000036.GH24062@one.firstfloor.org>
	<20111211230511.GH14273@dastard>
	<20111212023130.GI24062@one.firstfloor.org>
	<20111212043657.GO14273@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212043657.GO14273@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, "Ryan C. England" <ryan.england@corvidtec.com>, Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

> It's ~180 bytes, so it's not really that small.

Quite small compared to what real code uses. And also fixed
size.

> 
> > is on the new stack. ISTs are not used for interrupts, only for 
> > some special exceptions.
> 
> IST = ???

That's a hardware mechanism on x86-64 to switch stacks
(Interrupt Stack Table or somesuch) 

With ISTs it would have been possible to move the the pt_regs too,
but the software mechanism is somewhat simpler.

> at the top of the stack frame? Is the stack unwinder walking back
> across the interrupt stack to the previous task stack?

Yes, the unwinder knows about all the extra stacks (interrupt
and exception stacks) and crosses them as needed.

BTW I suppose it wouldn't be all that hard to add more stacks and
switch to them too, similar to what the 32bit do_IRQ does. 
Perhaps XFS could just allocate its own stack per thread
(or maybe only if it detects some specific configuration that
is known to need much stack) 
It would need to be per thread if you could sleep inside them.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
