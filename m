Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R1SWi1011480 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 19:28:33 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iHuMt2nGzPasTzPt for <xfs@oss.sgi.com>;
	Sun, 26 Feb 2012 17:28:31 -0800 (PST)
Date: Mon, 27 Feb 2012 12:28:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xlog_space_left: head behind tail
Message-ID: <20120227012829.GS3592@dastard>
References: <20120223104853.GA24638@quack.suse.cz>
	<20120223105418.GB24638@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120223105418.GB24638@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Feb 23, 2012 at 11:54:18AM +0100, Jan Kara wrote:
> On Thu 23-02-12 11:48:53, Jan Kara wrote:
> >   Hello,
> > 
> >   when I run:
> > while true; do ~/tests/xfstests-dev/ltp/fsstress -d /mnt -n 10000 -p 4; done
> > 
> > and in parallel
> > 
> > while true; do ./fsfreeze /mnt; sync; ./fsfreeze -u /mnt; sleep 3; done
> > 
> > where fsfreeze is a small utility freezing and unfreezing filesystem.

Ah, the world has been reinvented again:

$ xfs_io -x -c "help freeze" -c "help thaw"
freeze -- freeze filesystem of current file
thaw -- unfreeze filesystem of current file

> > I get
> > warnings like:
>   BTW, the first message is:
> [ 1626.278347] XFS (vdb1): xlog_space_left: head behind tail
> [ 1626.278349]   tail_cycle = 7, tail_bytes = 12907008
> [ 1626.278351]   GH   cycle = 7, GH   bytes = 12907000

So out by 8 bytes.

This is indicative of a transaction reservation accounting error or
a race condition in updating the grant heads during transaction
reservation/completion.

> > [ 2029.103193] XFS (vdb1): xlog_space_left: head behind tail
> > [ 2029.103195]   tail_cycle = 10, tail_bytes = 6036480
> > [ 2029.103197]   GH   cycle = 10, GH   bytes = 6035728

and 400s later is it out by 752 bytes

> > [ 2029.103218] XFS (vdb1): xlog_space_left: head behind tail
> > [ 2029.103219]   tail_cycle = 10, tail_bytes = 6036480
> > [ 2029.103220]   GH   cycle = 10, GH   bytes = 6035728
> > [ 2033.269796] XFS (vdb1): xlog_space_left: head behind tail
> > [ 2033.269800]   tail_cycle = 10, tail_bytes = 6400512
> > [ 2033.269803]   GH   cycle = 10, GH   bytes = 6399752

And 4s later (a single freeze) it is out by 760 bytes.

Ok, so that looks like a 8 byte accounting leak rather than a race
that is occurring. Given that it has been roughly 400s since the
first report, and you're running a freeze roughly every 4s, that's
100 freezes, and that's roughly 800 bytes which is in the ballpark
for 8 bytes a freeze being leaked.

I'll look into it further.

> Is it a real problem or just annoyance?

Real problem, but something rather unlikely to be tripped over in
the real world....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
