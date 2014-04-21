Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F6057F4E
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 01:57:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D6A6AC001
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2014 23:57:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id oB0x3LEmKnWZntB8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 20 Apr 2014 23:57:53 -0700 (PDT)
Date: Sun, 20 Apr 2014 23:57:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
Message-ID: <20140421065746.GA20384@infradead.org>
References: <534EC073.8090006@sandeen.net> <534EC282.7010905@sandeen.net>
	<20140416175117.GA23643@infradead.org>
	<534EC42D.1080704@sandeen.net> <534ED5E4.60903@sandeen.net>
	<20140416220807.GN15995@dastard>
	<20140416194444.50176f0f@gandalf.local.home>
	<20140417003956.GS15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140417003956.GS15995@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Steven Rostedt <rostedt@goodmis.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 17, 2014 at 10:39:56AM +1000, Dave Chinner wrote:
> so, basically a script that does:
> 
> #!/bin/bash
> 
> TRACEDIR=/sys/kernel/debug/tracing
> 
> grep -i 't xfs_' /proc/kallsyms | awk '{print $3}' ; while read F; do
> 	echo "r:ret_$F $F \$retval" >> $TRACEDIR/kprobe_events
> done
> 
> for E in $TRACEDIR/events/kprobes/ret_xfs_*/enable; do
> 	echo 1 > $E
> done;
> 
> echo 'arg1 > 0xffffffffffffff00' > $TRACEDIR/events/kprobes/filter
> 
> for T in $TRACEDIR/events/kprobes/ret_xfs_*/trigger; do
> 	echo 'traceoff if arg1 > 0xffffffffffffff00' > $T
> done

This looks incredibly useful!  Can we throw this into Documentation/ as
a helper script (and make the xfs a command line parameter so it's
genericly useful)?

One think that would be nice is to specify a module instead of relying
on a clean namespace, but to replace the XFS functionality the one above
is more than enough.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
