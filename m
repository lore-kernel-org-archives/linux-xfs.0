Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J3BnxO142955 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 22:11:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 011FB1E6532D
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 20:11:48 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	IFfb79ThiMXou2jj for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 20:11:48 -0700 (PDT)
Date: Mon, 18 Jul 2011 23:11:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: flush the CIL via a workqueue
Message-ID: <20110719031147.GA22114@infradead.org>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
	<1310960989-10284-4-git-send-email-david@fromorbit.com>
	<20110719020317.GC4259@infradead.org>
	<20110719030551.GK30254@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110719030551.GK30254@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 19, 2011 at 01:05:51PM +1000, Dave Chinner wrote:
> On Mon, Jul 18, 2011 at 10:03:17PM -0400, Christoph Hellwig wrote:
> > Generally looks okay, but doing a context switch in every log force
> > might bite us.  Less the general context switch overhead, but more
> > the nasty interactions with cfq, which are causing huge problems
> > for ext3/4,
> 
> Quite frankly, I don't recommend CFQ unless you need block level
> throttling or use IO prioritisation seriously. CFQ is way too smart
> for it's own good trying to do everything for everyone, and as such
> suffers from different regressions every release.  It has weird
> workload specific heuristics in it to try to address issues that
> don't solve the general class of problem, and so is always being
> patched to fix the next occurrence of the same problem.  e.g. the IO
> stalls caused by dependent IOs being issued by different threads
> that ext3/4 fsync hits all the time.

I don't like CFQ very much either.  But it's the default for both
mainline Linux and all major distros, so screwing it means a major
support burden as well as losing all kinds of benchmarks.

> I'm of the opinion that anyone with a RAID controller with a BBWC
> doesn't need the smarts in CFQ because the BBWC provides a much
> larger and smarter IO re-order window than the Linux IO schedulers
> and hence do a better job of IO scheduling than Linux can ever do.
> We shouldn't penalise the target market for XFS for having fast
> storage by catering to difficiencies of IO schedulers that are
> mostly redundant for the hardware XFS typically runs on....

What penatlity do we get for doing the cil force in line from log
force and only doing it in the background when it needs to be
written because of filling up the buffers?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
