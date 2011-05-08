Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4857ZMA013295 for <xfs@oss.sgi.com>; Sun, 8 May 2011 00:07:35 -0500
Received: from audible.transient.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 995F7C691E9
	for <xfs@oss.sgi.com>; Sat,  7 May 2011 22:11:14 -0700 (PDT)
Received: from audible.transient.net (audible.transient.net [216.254.12.79])
	by cuda.sgi.com with SMTP id ae9ZcYZ9OOUydboy for
	<xfs@oss.sgi.com>; Sat, 07 May 2011 22:11:14 -0700 (PDT)
Date: Sun, 8 May 2011 05:11:13 +0000
From: Jamie Heilman <jamie@audible.transient.net>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110508051113.GH2934@cucamonga.audible.transient.net>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110504005736.GA2958@cucamonga.audible.transient.net>
	<20110505002126.GA26797@dastard> <20110505022613.GA26837@dastard>
	<20110505122117.GB26837@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110505122117.GB26837@dastard>
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
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>, Alex Elder <aelder@sgi.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

Dave Chinner wrote:
> On Thu, May 05, 2011 at 12:26:13PM +1000, Dave Chinner wrote:
> > On Thu, May 05, 2011 at 10:21:26AM +1000, Dave Chinner wrote:
> > > On Wed, May 04, 2011 at 12:57:36AM +0000, Jamie Heilman wrote:
> > > > Dave Chinner wrote:
> > > > > OK, so the common elements here appears to be root filesystems
> > > > > with small log sizes, which means they are tail pushing all the
> > > > > time metadata operations are in progress. Definitely seems like a
> > > > > race in the AIL workqueue trigger mechanism. I'll see if I can
> > > > > reproduce this and cook up a patch to fix it.
> > > > 
> > > > Is there value in continuing to post sysrq-w, sysrq-l, xfs_info, and
> > > > other assorted feedback wrt this issue?  I've had it happen twice now
> > > > myself in the past week or so, though I have no reliable reproduction
> > > > technique.  Just wondering if more data points will help isolate the
> > > > cause, and if so, how to be prepared to get them.
> > > > 
> > > > For whatever its worth, my last lockup was while running
> > > > 2.6.39-rc5-00127-g1be6a1f with a preempt config without cgroups.
> > > 
> > > Can you all try the patch below? I've managed to trigger a couple of
> > > xlog_wait() lockups in some controlled load tests. The lockups don't
> > > appear to occur with the following patch to he race condition in
> > > the AIL workqueue trigger.
> > 
> > They are still there, just harder to hit.
> > 
> > FWIW, I've also discovered that "echo 2 > /proc/sys/vm/drop_caches"
> > gets the system moving again because that changes the push target.
> > 
> > I've found two more bugs, and now my test case is now reliably
> > reproducably a 5-10s pause at ~1M created 1byte files and then
> > hanging at about 1.25M files. So there's yet another problem lurking
> > that I need to get to the bottom of.
> 
> Which, of course, was the real regression. The patch below has
> survived a couple of hours of testing, which fixes all 4 of the
> problems I found. Please test.

Well, 61 hours in now, and no lockups.  I've written ~204GiB to my xfs
volumes in that time, much of which was audacity temp files which are
1037kB each, so not as metadata intensive as your test case, but it's
more or less what I'd been doing in the past when the lockups
happened.  Looks pretty promising at this point.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
