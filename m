Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBBN5Hos060158 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 17:05:17 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA6571B426D6
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 15:05:15 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XH04iXf2UGSdhAZx for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 15:05:15 -0800 (PST)
Date: Mon, 12 Dec 2011 10:05:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS causing stack overflow
Message-ID: <20111211230511.GH14273@dastard>
References: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
	<20111209115513.GA19994@infradead.org>
	<20111209221956.GE14273__25752.826271537$1323469420$gmane$org@dastard>
	<m262hop5kc.fsf@firstfloor.org> <20111210221345.GG14273@dastard>
	<20111211000036.GH24062@one.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111211000036.GH24062@one.firstfloor.org>
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

On Sun, Dec 11, 2011 at 01:00:36AM +0100, Andi Kleen wrote:
> > Where does the x86-64 do the interrupt stack switch?
> 
> in entry_64.S
> 
> > 
> > I know the x86 32 bit interrupt handler switches to an irq/softirq
> > context stack, but the 64 bit one doesn't appear to. Indeed,
> > arch/x86/kernel/irq_{32,64}.c are very different, and only the 32
> > bit irq handler switches to another stack to process the
> > interrupts...
> 
> x86-64 always used interrupt stacks and has used softirq stacks
> for a long time. 32bit got to it much later (the only good 
> thing left from that 4k stack "experiment")

Oh, it's hidden in the "SAVE_ARGS_IRQ" macro. 

But that happens before do_IRQ is called, so what is the do_IRQ call
chain doing on this stack given that we've already supposed to have
switched to the interrupt stack before do_IRQ is called?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
