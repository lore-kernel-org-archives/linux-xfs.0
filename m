Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NHH4Cu217197 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 12:17:04 -0500
Received: from josefsipek.net (josefsipek.net [64.9.206.49]) by cuda.sgi.com
	with ESMTP id GkkkXSzbGOVECNdU for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 10:17:03 -0700 (PDT)
Date: Mon, 23 Apr 2012 13:16:58 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120423171658.GA21260@poseidon.cudanet.local>
References: <20120418151139.GC4652@poseidon.cudanet.local>
	<20120418234821.GR6734@dastard>
	<20120419154601.GB8230@poseidon.cudanet.local>
	<20120419225603.GA9541@dastard>
	<20120420135820.GB9189@poseidon.cudanet.local>
	<20120421002932.GG9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120421002932.GG9541@dastard>
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
Cc: xfs@oss.sgi.com

On Sat, Apr 21, 2012 at 10:29:32AM +1000, Dave Chinner wrote:
> On Fri, Apr 20, 2012 at 09:58:20AM -0400, Josef 'Jeff' Sipek wrote:
...
> > Right.  Here's the output from a few minutes ago (I removed the empty lines
> > and redundant column headings):
> 
> Thanks, that makes it easy to read ;)

Yeah, I don't know who's brilliant idea it was to output the headings every
time.

> Now comes the "more data needed" bit. I still need the sysrq-w
> output,

D'oh!  Totally forgot to put that up somewhere.

http://31bits.net/download/xfs_log.gz

Sadly, it looks like the kernel's ring buffer wrapped while dumping the ~180
stacks.

> but also given the length of the incident, some other data
> is definitely needed:
> 
> 	- a 30s event trace - it'll compress pretty well
> 	  (trace-cmd record -e xfs* sleep 30; trace-cmd report > output.txt)

Hrm... Time to figure out how to get ftrace going on Gentoo.  I don't see an
obvious package to install to get trace-cmd.

> 	- vmstat 1 output for the same period
> 	- output of /proc/meminfo at the same time
> 	- the same iostat output for comparison.

Jeff.

-- 
I'm somewhere between geek and normal.
		- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
