Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DLeW7i074125 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 16:40:32 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cxsiXYuSpFJdm91D for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 14:40:30 -0700 (PDT)
Date: Wed, 14 Mar 2012 08:40:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8 v2] xfs: use common code for quota statistics
Message-ID: <20120313214027.GF5091@dastard>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
	<20120221014809.GA18227@infradead.org>
	<20120312175519.GE7762@sgi.com>
	<20120313084241.GA359@infradead.org>
	<20120313152748.GG7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313152748.GG7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Mar 13, 2012 at 10:27:48AM -0500, Ben Myers wrote:
> On Tue, Mar 13, 2012 at 04:42:42AM -0400, Christoph Hellwig wrote:
> > On Mon, Mar 12, 2012 at 12:55:19PM -0500, Ben Myers wrote:
> > > > +static int xqm_proc_show(struct seq_file *m, void *v)
> > > > +{
> > > > +	/* maximum; incore; ratio free to inuse; freelist */
> > > > +	seq_printf(m, "%d\t%d\t%d\t%u\n",
> > > > +			0,
> > > > +			counter_val(XFSSTAT_END_XQMSTAT),
> > > 
> > > This patch looks great.  It might break some PCP scripts, I'm not sure.
> > 
> > Why would it break them?  The existing stats are still kept around, and
> > new additions to the main stats file are expected to happen once in a
> > while.
> 
> I'm not sure that it would.  You've added a line to the common stats
> procfile, and the pmda might expect the xpc line immediately after ibt2.

IIRC the pmda triggers off the descriptor at the start of the line.
It ignores lines that it doesn't understand the descriptor for (like
all the v2 btree stats). I should probably update the pmda fo all
those stats....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
