Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44DMTOH077231 for <xfs@oss.sgi.com>; Wed, 4 May 2011 08:22:29 -0500
Date: Wed, 4 May 2011 23:25:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110504132552.GG9114@dastard>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110504005736.GA2958@cucamonga.audible.transient.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110504005736.GA2958@cucamonga.audible.transient.net>
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
To: linux-kernel@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>, Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>

On Wed, May 04, 2011 at 12:57:36AM +0000, Jamie Heilman wrote:
> Dave Chinner wrote:
> > OK, so the common elements here appears to be root filesystems
> > with small log sizes, which means they are tail pushing all the
> > time metadata operations are in progress. Definitely seems like a
> > race in the AIL workqueue trigger mechanism. I'll see if I can
> > reproduce this and cook up a patch to fix it.
> 
> Is there value in continuing to post sysrq-w, sysrq-l, xfs_info, and
> other assorted feedback wrt this issue?  I've had it happen twice now
> myself in the past week or so, though I have no reliable reproduction
> technique.  Just wondering if more data points will help isolate the
> cause, and if so, how to be prepared to get them.

Not really. I think I know where the problem lies, but I currently
lack a reproducer. There's also been another regression I've only
just got to the bottom of, so I haven't really had a chance to focus
properly on this one yet. Log space hangs like this have
historically been difficult to reproduce reliably....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
