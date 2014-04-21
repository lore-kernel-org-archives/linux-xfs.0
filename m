Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44E337F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 18:44:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F06DF8F8068
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:44:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ySB31F3UwMTIoKqX for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 16:43:58 -0700 (PDT)
Date: Tue, 22 Apr 2014 09:43:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
Message-ID: <20140421234317.GF18672@dastard>
References: <534EC073.8090006@sandeen.net> <534EC282.7010905@sandeen.net>
	<20140416175117.GA23643@infradead.org>
	<534EC42D.1080704@sandeen.net> <534ED5E4.60903@sandeen.net>
	<20140416220807.GN15995@dastard>
	<20140416194444.50176f0f@gandalf.local.home>
	<20140417003956.GS15995@dastard>
	<20140421065746.GA20384@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140421065746.GA20384@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Steven Rostedt <rostedt@goodmis.org>, xfs-oss <xfs@oss.sgi.com>

On Sun, Apr 20, 2014 at 11:57:46PM -0700, Christoph Hellwig wrote:
> On Thu, Apr 17, 2014 at 10:39:56AM +1000, Dave Chinner wrote:
> > so, basically a script that does:
> > 
> > #!/bin/bash
> > 
> > TRACEDIR=/sys/kernel/debug/tracing
> > 
> > grep -i 't xfs_' /proc/kallsyms | awk '{print $3}' ; while read F; do
> > 	echo "r:ret_$F $F \$retval" >> $TRACEDIR/kprobe_events
> > done
> > 
> > for E in $TRACEDIR/events/kprobes/ret_xfs_*/enable; do
> > 	echo 1 > $E
> > done;
> > 
> > echo 'arg1 > 0xffffffffffffff00' > $TRACEDIR/events/kprobes/filter
> > 
> > for T in $TRACEDIR/events/kprobes/ret_xfs_*/trigger; do
> > 	echo 'traceoff if arg1 > 0xffffffffffffff00' > $T
> > done
> 
> This looks incredibly useful!  Can we throw this into Documentation/ as
> a helper script (and make the xfs a command line parameter so it's
> genericly useful)?

So does that mean you have no more objections to removing
XFS_ERROR()?

The thing is, that's a quick hack that spews errors all over the
place, especially if you run it twice. It needs a counterpart to
turn off the tracing, clean up the triggers, etc....

FWIW, what I'd really like is a trace event trigger that triggers
a BUG(), so that we can use it to drop into kernel debuggers or get
kdump to generate a core that can be analysed offline...

> One think that would be nice is to specify a module instead of relying
> on a clean namespace, but to replace the XFS functionality the one above
> is more than enough.

My current hack is invoked like this:

$ grep -i 't xfs_' /proc/kallsyms | retval_filter.sh

Makes it completely independent of how you supply the symbols to the
function. Hence my coments about how it'd be really cool to have
this built into in trace-cmd, because the mechanism is independent
of how you specify the function list...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
