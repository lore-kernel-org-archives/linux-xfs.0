Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUMPXmT235476 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 16:25:33 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zgUzGahL8PXwthuV for <xfs@oss.sgi.com>;
	Fri, 30 Nov 2012 14:27:51 -0800 (PST)
Date: Sat, 1 Dec 2012 09:27:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fsck scratch device if it got used
Message-ID: <20121130222750.GC12955@dastard>
References: <50B7B0AB.6040406@redhat.com> <20121130160616.GD5667@infradead.org>
	<50B8DA0E.4000605@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B8DA0E.4000605@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Nov 30, 2012 at 10:08:46AM -0600, Eric Sandeen wrote:
> On 11/30/12 10:06 AM, Christoph Hellwig wrote:
> > On Thu, Nov 29, 2012 at 12:59:55PM -0600, Eric Sandeen wrote:
> >> This will cause the $SCRATCH_DEV to be fscked if it was used in
> >> the prior test.  Without this I don't think it gets done unless
> >> specifically requested by the test.
> > 
> > This one looks good.
> 
> Hm now that I think of it perhaps I should remove the explicit
> _check_scratch-es if they happen at the end of the run, just to
> try to speed things up.

*nod*

> >> Also recreate lost+found/ in one test so that e2fsck doesn't
> >> complain.
> > 
> > This one I can't make any sense of.  Care to send it separately
> > with a good explanation?
> > 
> 
> Ok, sure.
> 
> Basically, test does an rm -rf of the scrach mnt, but e2fsck
> thinks that a missing lost+found/ is cause for complaint and a
> failure exit code, which then stops the tests :(

Shouldn't e2fsck be fixed? i.e. if you have a corrupted filesystem
and it's missing lost+found, how are you expected to create it? by
mounting your corrupted filesystem and modifying it and potentially
making the corruption worse?

> (hum, now that I think about it, maybe a broken scratch device
> shouldn't stop the test series, but should just log a test
> failure?  What do you think?)

Stop it - we should be leaving a corpse that we can dissect to find
out what went wrong. For a corrupted scratch filesystem, running
another test will eat the slowly rotting corpse and leave nothing
useful behind for diagnosing the failure...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
