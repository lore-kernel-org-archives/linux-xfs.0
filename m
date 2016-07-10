Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3DE967CB5
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 18:27:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B001AC001
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 16:27:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	e7ZDcuSWX1xGDCbu for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2016 16:27:46 -0700 (PDT)
Date: Mon, 11 Jul 2016 09:27:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] about the freelist allocator in XFS
Message-ID: <20160710232744.GC1922@dastard>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
	<CAGeO4WMeat_NoXTkTSKky_YO95BXsSdwvR4rbiEmrxB1h1zVvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGeO4WMeat_NoXTkTSKky_YO95BXsSdwvR4rbiEmrxB1h1zVvQ@mail.gmail.com>
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
To: Kaho Ng <ngkaho1234@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 11, 2016 at 12:57:59AM +0800, Kaho Ng wrote:
> well, a piece of comment about the corner case i mentioned is found in
> xfsprogs/repair/phase5.c, but i still have no idea how that is
> prevented by the xfs kernel module.
> 
> /*
>  * We need to leave some free records in the tree for the corner case of
>  * setting up the AGFL. This may require allocation of blocks, and as
>  * such can require insertion of new records into the tree (e.g. moving
>  * a record in the by-count tree when a long extent is shortened). If we
>  * pack the records into the leaves with no slack space, this requires a
>  * leaf split to occur and a block to be allocated from the free list.
>  * If we don't have any blocks on the free list (because we are setting
>  * it up!), then we fail, and the filesystem will fail with the same
>  * failure at runtime. Hence leave a couple of records slack space in
>  * each block to allow immediate modification of the tree without
>  * requiring splits to be done.
>  *
>  * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
>  */

Once mkfs fills the AGFL with the minimum number of blocks to ensure
allocations always succeed, the kernel guarantees that minimum
number of blocks will always be available on the AGFL and hence
allocation and freeing of blocks will always succeed, regardless of
whether btree splits are needed or not.

i.e. ENOSPC is not reported at "filesystem has zero freespace" but
at "freespace btrees are empty and each AGFL is at minimum free
blocks". See XFS_ALLOC_SET_ASIDE() and XFS_ALLOC_AG_MAX_USABLE().

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
