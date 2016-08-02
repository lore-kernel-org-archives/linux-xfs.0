Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DBE07CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 16:41:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0EBB1AC001
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 14:41:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	o3o2AABdwmqvzi7y for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 14:41:04 -0700 (PDT)
Date: Wed, 3 Aug 2016 07:41:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: in _attrlist_by_handle, copy the cursor back to
	userspace
Message-ID: <20160802214101.GM16044@dastard>
References: <20160802035651.GB8593@birch.djwong.org>
	<20160802122517.GD31492@infradead.org>
	<20160802154035.GI8590@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802154035.GI8590@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Aug 02, 2016 at 08:40:35AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 02, 2016 at 05:25:17AM -0700, Christoph Hellwig wrote:
> > On Mon, Aug 01, 2016 at 08:56:51PM -0700, Darrick J. Wong wrote:
> > > When we're iterating inode xattrs by handle, we have to copy the
> > > cursor back to userspace so that a subsequent invocation actually
> > > retrieves subsequent contents.
> > 
> > Testcase?
> 
> Found it while continuing development of xfs_scrub.  I'll send along the
> xfstest patch when I've finished polishing it.  (It was harder than usual since
> xfs_io doesn't /use/ the attr-by-handle interface... nothing does.)

It was (and probably still is) used by SGI's HSM. I thought there
was some coverage of the interface in the dmapi part of the xfstests
suite, but perhaps it's only tested by SGI's internal hsm test
suite...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
