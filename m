Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADJiiu1118760 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 13:44:45 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	teVv8whOCX4W4TCc for <xfs@oss.sgi.com>;
	Tue, 13 Nov 2012 11:46:46 -0800 (PST)
Date: Wed, 14 Nov 2012 06:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: fixes for 3.7-rc6
Message-ID: <20121113194643.GG25039@dastard>
References: <1352718586-3538-1-git-send-email-david@fromorbit.com>
	<20121113020150.GY9783@sgi.com> <20121113030507.GE25039@dastard>
	<20121113071147.GA32469@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121113071147.GA32469@infradead.org>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Tue, Nov 13, 2012 at 02:11:47AM -0500, Christoph Hellwig wrote:
> On Tue, Nov 13, 2012 at 02:05:07PM +1100, Dave Chinner wrote:
> > Just FYI, the first thing that needs to be done after the userspace
> > release is to resync the libxfs/libxlog code with the kernel code.
> > That needs to be done before any of the CRC changes can be merged,
> > so be prepared for a pretty major update that'll need review soon
> > after the release.
> > 
> > IIRC, the last kernel/user resync I did was about 15,000 lines of
> > change I don't expect this to be quite as big (the previous one
> > contained the btree consolidation changes), but I'd expect it to be
> > in the order of 2-3000 lines of change to be needed.
> 
> Do we have anyone who has signed up for that work yet?

I think it will be end up being me because I'm the one who needs it
done in the next month or so...

> One thing I'd really love to do is to make the resyncs simpler, e.g.
> make sure userspace can use the same #include statements as the kernel
> code, and make sure all files are either used entirely in userspace or
> not at all.  Things like the split of xfs_extent_busy.c are going to
> help with that, but I suspect there's more work to do.

There's a lot more work to get to that point, I think. I don't plan
on tackling that right now, though. Stuff like the way you split up
the dir2 headers is also a step in the right direction...

> > > Thanks for reposting your 3.8 queue, BTW.  Sometimes I think that frequent
> > > reposts are inconvenient, but in this case I think it will be helpful.
> > 
> > When I'm having trouble tracking of several of my own patch sets for
> > the same release, it's time for re-organisation and a repost.
> > Besides, it's a habit Christoph and I got into a while back when we
> > had lots of work going on and we needed to make sure nothing
> > slipped through the cracks..... :)
> 
> For anything more than one or two simple patches a complete repost is
> they way to spell a ping.  Once you're having dozends of patches it's
> almost guaranteed there are a few small fixes or context changes by the
> time of the ping, and the repost takes care of having an uptodate
> version.
> 
> And in case anyone wonder, yes I plan to get back to reviewing your bits
> soon.

Cool.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
