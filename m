Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6GMYniQ041196 for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 17:34:49 -0500
Received: from hrndva-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9203336AF16
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 15:35:28 -0700 (PDT)
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com
	[71.74.56.122]) by cuda.sgi.com with ESMTP id XZqQpxvO2aEpVmiL
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 15:35:28 -0700 (PDT)
Date: Thu, 16 Jul 2009 18:35:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH, RFC] xfs: event tracing support
In-Reply-To: <4A5FA82F.6050903@sandeen.net>
Message-ID: <alpine.DEB.2.00.0907161831391.9337@gandalf.stny.rr.com>
References: <20090616214844.GA12310@infradead.org>
	<4E752C93-A674-4725-AF23-C227C0A1E659@sgi.com>
	<20090622205904.GA1855@infradead.org>
	<4A5FA82F.6050903@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ia64@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, xfs@oss.sgi.com


Added Ingo as well.

On Thu, 16 Jul 2009, Eric Sandeen wrote:

> Christoph Hellwig wrote:
> > On Mon, Jun 22, 2009 at 01:01:35PM -0500, Felix Blyakher wrote:
> >>> To use it make sure CONFIG_EVENT_TRACING is enabled and then enable  
> >>> all
> >>> xfs trace channels by:
> >>>
> >>>   echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
> >> Does event tracing work on ia64 platform?
> >> I spent some time on it over weekend, but was not able even
> >> to force "CONFIG_EVENT_TRACING=y" setting in the .config.
> >> Seems to build ok on x86_64, which does have CONFIG_TRACING
> >> in defconfig, and allows to set CONFIG_EVENT_TRACING.
> > 
> > IA64 ftrace support was added earlier this year, but it seems it can't
> > be enabled anymore since the big config option reshuffle.  Now tracing
> > support requires the architecture to define the TRACE_IRQFLAGS_SUPPORT
> > and STACKTRACE_SUPPORT symbols, which seems to be missing on ia64.
> 
> Where are we at with this one, I'd like to get this in for XFS but I
> agree w/ Felix that throwing out a "working" trace infrastructure w/
> nothing to replace it on ia64 would not be great.
> 
> Is this just config confusion, or is the functionality actually missing
> on ia64?

For PPC32, we have stacktrace support but there was lots of issues with 
the IRQFLAGS support. Namely, issues with handling traces in assembly when 
interrupts are off.

Hence, we have an exception for PPC32 with the IRQFLAGS config. Is there a 
reason that we can't have STACKTRACE_SUPPORT for ia64? Perhaps it should 
be implemented? Probably not that difficult.

Then we can add an exception for ia64 too if there's a technical reason 
that IRQFLAGS is not supported. Otherwise, IRQFLAGS should also be 
ported. That way, ia64 would benefit from lockdep as well.

-- Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
