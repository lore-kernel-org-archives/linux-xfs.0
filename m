Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AAAHr1039059 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 04:10:20 -0600
Date: Wed, 10 Feb 2010 05:11:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100210101130.GA7993@infradead.org>
References: <20100210003220.6021.74943.stgit@case>
	<20100210003337.6021.10942.stgit@case>
	<20100210090750.GB21875@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100210090750.GB21875@infradead.org>
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
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 10, 2010 at 04:07:50AM -0500, Christoph Hellwig wrote:
> > +			/*
> > +			 * AFAICS the child is always modified after the parent
> > +			 * in nfsd so should always have a larger lsn.
> > +			 */
> > +			if (c_xip->i_itemp->ili_last_lsn > force_lsn) {
> > +				force_lsn = c_xip->i_itemp->ili_last_lsn;
> > +			} else {
> > +				force_lsn = 0; /* whole thing */
> > +			}
> 
> I wouldn't rely on that and always take the larger one.

Or we could use that fact for making the prototype saner:

 - the commit_metadata only takes a single inode to force out
 - we make sure to always call in on the child first.  For any
   log based filesystem that will force the parent update, too.
 - we then call it on the parent, which will be a no-op and thus
   fast for a log based filesystem, but still provide a fallback
   if that is not the case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
