Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CBoRIu007295 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 05:50:28 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2FAD1512E38
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 03:51:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	R6JXQqvuzWFHweDv for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2010 03:51:21 -0800 (PST)
Date: Tue, 12 Jan 2010 22:51:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfsqa: make unmounting loop devices in 073 work again
Message-ID: <20100112115117.GC17483@discord.disaster>
References: <1263271269-18997-1-git-send-email-david@fromorbit.com>
	<1263271269-18997-3-git-send-email-david@fromorbit.com>
	<20100112100031.GA8749@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100112100031.GA8749@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2010 at 05:00:31AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 12, 2010 at 03:41:07PM +1100, Dave Chinner wrote:
> > Loop devices are now created and destroyed on demand, and
> > the existing hacks to do this no longer work. Remove them.
> 
> Just noticed that I had not been running this test at all for a long
> time as it doesn't work with external logs.
> 
> Seems like the current code indeed fails reliably for me and this
> patch fixes it.
> 
> The only problem is that the loop device autodestruct features is only
> available since Linux 2.6.25 and also needs a recent util-linux.  Is
> this old enough to simply go with the auto destruct version, or do
> we need to support either one?
> 
> What about the patch below?  This adds the -d argument to the umount
> calls for the loop images, which destroys the loop images in older
> kernels and is a no-op for modern kernels that have the loop
> auto-destruct feature:

Yes, that looks like a better way to solve the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
