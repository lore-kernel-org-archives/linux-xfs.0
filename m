Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 870AC7FF0
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 04:06:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 269E2AC008
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:06:04 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mktwaNY01FWBsen7 for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 02:05:59 -0700 (PDT)
Date: Tue, 6 May 2014 19:05:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140506090537.GI5421@dastard>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
	<20140506084328.GA30444@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506084328.GA30444@infradead.org>
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

On Tue, May 06, 2014 at 01:43:28AM -0700, Christoph Hellwig wrote:
> Getting rid of the need for xfs_mount.h in xfs_ialloc.h xfs_da_format.h
> should be simple:
> 
>  - inline xfs_make_iptr into the only caller
>  - move xfs_icluster_size_fsb to xfs_ialloc.c and just provide a
>    prototype for it.

Yeah, those are easy.

>  - the various conversion routines for the directory blocks really
>    shouldn't be in xfs_da_format.h anyway as they don't define the
>    format.  Just have some other header that requires a version of
>    xfs_mount included first.

Still has the same problem - the library code is dependent on an
externally defined struct xfs_mount. What needs to happen is the
directory code needs to define the structure that carries all the
precalculated geometry, and the struct mount use that structure to
store them. Then the directory code can use it's own structure
as the function argument, and the dependence on struct xfs_mount
goes away completely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
