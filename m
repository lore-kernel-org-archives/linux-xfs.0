Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DFReIt031164 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 10:27:41 -0500
Date: Tue, 13 Mar 2012 10:27:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/8 v2] xfs: use common code for quota statistics
Message-ID: <20120313152748.GG7762@sgi.com>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
	<20120221014809.GA18227@infradead.org>
	<20120312175519.GE7762@sgi.com>
	<20120313084241.GA359@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313084241.GA359@infradead.org>
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

On Tue, Mar 13, 2012 at 04:42:42AM -0400, Christoph Hellwig wrote:
> On Mon, Mar 12, 2012 at 12:55:19PM -0500, Ben Myers wrote:
> > > +static int xqm_proc_show(struct seq_file *m, void *v)
> > > +{
> > > +	/* maximum; incore; ratio free to inuse; freelist */
> > > +	seq_printf(m, "%d\t%d\t%d\t%u\n",
> > > +			0,
> > > +			counter_val(XFSSTAT_END_XQMSTAT),
> > 
> > This patch looks great.  It might break some PCP scripts, I'm not sure.
> 
> Why would it break them?  The existing stats are still kept around, and
> new additions to the main stats file are expected to happen once in a
> while.

I'm not sure that it would.  You've added a line to the common stats
procfile, and the pmda might expect the xpc line immediately after ibt2.

I've made a note to take a look.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
