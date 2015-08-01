Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F27BA7F7D
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2015 17:58:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9ECE4AC003
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2015 15:58:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	hOTGKMO825poOTfh for <xfs@oss.sgi.com>;
	Sat, 01 Aug 2015 15:58:46 -0700 (PDT)
Date: Sun, 2 Aug 2015 08:58:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2 00/24] xfs: add reflink and dedupe support
Message-ID: <20150801225817.GS16638@dastard>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150801130131.GD101746@meili.valhalla.31bits.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150801130131.GD101746@meili.valhalla.31bits.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sat, Aug 01, 2015 at 09:01:31AM -0400, Josef 'Jeff' Sipek wrote:
> On Wed, Jul 29, 2015 at 03:32:59PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This is the second revision of an RFC for adding to XFS kernel support
> > for mapping multiple file logical blocks to the same physical block,
> > more commonly known as reflinking.  The implementation a single [block
> > range, refcount] tree to track the reference counts of extents of
> > physical blocks.  There's also support code to provide the desired
> > copy-on-write behavior and the userland interfaces to reflink, query
> > the status of, and un-reflink files.
> 
> This is cool work.  I have a random thought to share... IIRC, you keep a
> per-inode flag to avoid expensive ops on files that have no refcounted
> blocks.  ZFS keeps a bit in each block pointer to indicate that the target
> is dedup'd.  I'd have to check if xfs has a spare bit in its block pointer,
> but if it does that's one way to minimize the refcount btree overhead.

No, we don't. We'd have to steal a bit from the extent length field,
similar to the way unwritten extents were implemented.

As it is, we still need a separate tree to track the shared extent
refcounts, so making this more fine grained to optimise freeing of
extents can be looked at further down the track once we have an idea
where the bottlenecks in the shared extent system are....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
