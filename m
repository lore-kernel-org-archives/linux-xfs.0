Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F3AF7CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 18:58:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 162BBAC002
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 16:58:02 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HvykXRGNvzluGhyz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 16:57:58 -0700 (PDT)
Date: Tue, 2 Aug 2016 16:57:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: in _attrlist_by_handle, copy the cursor back to
	userspace
Message-ID: <20160802235732.GD8593@birch.djwong.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

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

Found some extra time while I run all of today's rmap changes through QA
to push to Dave, so I fixed (I hope) the remaining problems I had and
sent out a testcase.

--D

> 
> --D
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
