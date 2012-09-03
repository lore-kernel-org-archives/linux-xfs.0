Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q833Zgsf128463 for <xfs@oss.sgi.com>; Sun, 2 Sep 2012 22:35:42 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BJcsmJOm2Refgv9d for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 20:36:37 -0700 (PDT)
Date: Mon, 3 Sep 2012 13:36:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/13] xfs: sync work is now only periodic log work
Message-ID: <20120903033626.GO15292@dastard>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-6-git-send-email-david@fromorbit.com>
	<20120901232343.GA31634@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120901232343.GA31634@infradead.org>
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

On Sat, Sep 01, 2012 at 07:23:43PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 30, 2012 at 10:00:09PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The only thing the periodic sync work does now is flush the AIL and
> > idle the log. These are really functions of the log code, so move
> > the work to xfs_log.c and rename it appropriately.
> > 
> > The only wart that this leaves behind is the xfssyncd_centisecs
> > sysctl, otherwise the xfssyncd is dead. Clean up any comments that
> > related to xfssyncd to reflect it's passing.
> 
> FYI: A while ago I looked into folding the work here into xfsaild.
> While soing the periodic ail push there aka just waking up with a
> timeout which we did more often anyway at that point was easy, getting
> the log force / dummy log never really worked out.
> 
> I think at least the former probably should be dropped here as well.

Perhaps. We've always had a periodic log force as a get out gaol
free card for issues with pinned objects, so I'm not really inclined
to remove it/change that behaviour in this series.

IOWs, while I do agree that the log covering and AIL pushing code
should be more tightly integrated so that we can get the filesystem
to an idle state much faster than we do now, I don't think this
patchset is the place to start doing bits of that work.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
