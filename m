Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7K7sv9M225203 for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 02:54:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B658D369
	for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 00:55:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	iMCYkIoajide8hOA for <xfs@oss.sgi.com>;
	Fri, 20 Aug 2010 00:55:27 -0700 (PDT)
Date: Fri, 20 Aug 2010 17:55:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Message-ID: <20100820075524.GA31488@dastard>
References: <201008191312.49346@zmi.at> <20100819120512.GB9358@infradead.org>
	<201008191445.22568@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201008191445.22568@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, Aug 19, 2010 at 02:45:22PM +0200, Michael Monnerie wrote:
> On Donnerstag, 19. August 2010 Christoph Hellwig wrote:
> > The creation and deletion performance is a known issue, and too a
> >  large extent fixes by the new delaylog code.  We're not quite as
> >  fast as ext4 yet, but it's getting close.
> > 
> > The repair result looks a lot like the pre-3.1.0 xfsprogs repair.
>  
> Yes I know. I thought some XFS dev might contact the Author to do some 
> re-testing, as a reputation is quickly destroyed by such articles and 
> takes long to be returned. Just this week I had a friend in a FS 
> discussion saying "ins't XFS destroying/zeroing files on power 
> failure?". That information is ancient, but things like that stay in 
> peoples brain for(almost)ever.

Don't worry too much - I have the details of the test that was run
and alredy know why XFS appeared so slow: it was single threaded.
Immediately, that means XFS will be slower to create 1b files
regardless of any other detail.

Look at it this way - the initial numbers I'm seeing on my test rig
are sustained create rates of about 8,000/s with default mkfs/mount
options (i.e. no tuning, no delayed logging, 32k logbsize, etc) and
it is burning exactly one of 8 CPUs in the VM. I know I can get an
order of magnitude better performance out of XFS on this VM....

It'll take me a few days to run the numbers to be able to write a
solid reply, but I have every confidence that a "create 1b inodes"
benchmark tuned to XFS's strengths rather than one designed to avoid
ext4's weaknesses will show very, very different results.

In the meantime, there is no need to start a flamewar. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
