Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DLwc0C074744 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 16:58:38 -0500
Date: Tue, 13 Mar 2012 16:58:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/5] xfs: remove the per-filesystem list of dquots
Message-ID: <20120313215845.GM8545@sgi.com>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085308.997632929@bombadil.infradead.org>
	<20120313200354.GI7762@sgi.com> <20120313215409.GI5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313215409.GI5091@dastard>
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

On Wed, Mar 14, 2012 at 08:54:09AM +1100, Dave Chinner wrote:
> On Tue, Mar 13, 2012 at 03:03:54PM -0500, Ben Myers wrote:
> > On Tue, Mar 13, 2012 at 04:52:36AM -0400, Christoph Hellwig wrote:
> > > +		struct xfs_dquot *batch[XFS_DQ_LOOKUP_BATCH];
> > 
> > Eesh.. that probably doesn't need to go onto the stack.  I know we are
> > doing it elsewhere too, and that we also sometimes complain about other
> > peoples' stack usage.  Don't necessarily have to clean it up now,
> > though.  ;)
> 
> Actually, if we do the walk from the shrinker we can't reliably
> allocate it, so it has to go on the stack.

D'oh, I missed that idea completely in my review.  :/ 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
