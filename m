Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2D8girW226815 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 03:42:44 -0500
Date: Tue, 13 Mar 2012 04:42:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8 v2] xfs: use common code for quota statistics
Message-ID: <20120313084241.GA359@infradead.org>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
	<20120221014809.GA18227@infradead.org>
	<20120312175519.GE7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120312175519.GE7762@sgi.com>
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

On Mon, Mar 12, 2012 at 12:55:19PM -0500, Ben Myers wrote:
> > +static int xqm_proc_show(struct seq_file *m, void *v)
> > +{
> > +	/* maximum; incore; ratio free to inuse; freelist */
> > +	seq_printf(m, "%d\t%d\t%d\t%u\n",
> > +			0,
> > +			counter_val(XFSSTAT_END_XQMSTAT),
> 
> That's xfs_qm_dquot
> 
> > +			0,
> > +			counter_val(XFSSTAT_END_XQMSTAT + 1));
> 
> and xfs_qm_dquot_unused?  A comment would make your intent clear.

In that case we'd have to comment the existing code, too.  And in that
case reoding the code to actually make sense would be a good idea as
well.

> This patch looks great.  It might break some PCP scripts, I'm not sure.

Why would it break them?  The existing stats are still kept around, and
new additions to the main stats file are expected to happen once in a
while.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
