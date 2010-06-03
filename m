Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o53LuCIv180418 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 16:56:13 -0500
Subject: Re: [PATCH] xfs: remove lazy per-AG initialization
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100530230915.GA13732@dastard>
References: <20100528175108.GA9421@infradead.org>
	<20100530230915.GA13732@dastard>
Date: Thu, 03 Jun 2010 16:58:10 -0500
Message-ID: <1275602290.2468.110.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Mon, 2010-05-31 at 09:09 +1000, Dave Chinner wrote:
> On Fri, May 28, 2010 at 01:51:08PM -0400, Christoph Hellwig wrote:
> > Historically XFS initializes the allocator / inode allocator per-AG
> > lazily, that is the first time this information is required.  For
> > filesystems that use lazy superblock counters (which is the default now)
> > we already have to walk all AGs to initialize the superblock counters
> > on an unclean shutdown.
> 
> Which is not common, so isn't frequently triggered in the normal
> mount process. The reason for the lazy initialisation is to speed
> the mount process up when there are thousands of AGs. That is, we
> avoid thousands of serialised IOs in the mount path. Have you
> checked to see what the impact is on the clean mount execution time
> is on such a filesystem?

It's interesting that the time penalty you're talking about
doesn't go away, it just becomes less noticeable because it's
aggregated over subsequent access to the AG's.

I like the cleanup too, but I agree it would be useful to
quantify what this particular impact is.

					-Alex

> FWIW, in the case of an unclean shutdown, we are already on the slow path
> due to log recovery so adding IO to read all the headers it not such
> a big deal as they have probably been read in during replay, anyway.
> 
> > This patch generalizes that code so that we
> > always initialize the per-AG data on mount, and also during growfs so
> > that we can remove all the special case code in the fastpath which
> > couldn't assume that the per-AG data is already initialized.
> 
> I like the cleanup, but I'm not sure that potentially adding tens of
> seconds to the time to mount a really large filesystem is a good
> tradeoff...
> 
> Cheers,
> 
> Dave.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
