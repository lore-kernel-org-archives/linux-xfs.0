Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5930F7F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 21:44:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A719304062
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 19:44:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ATCDd7EazPYeJSO7 for <xfs@oss.sgi.com>;
	Tue, 05 Jan 2016 19:44:17 -0800 (PST)
Date: Wed, 6 Jan 2016 14:44:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFCv4 00/76] xfs: add reverse-mapping, reflink, and dedupe
	support
Message-ID: <20160106034415.GH21461@dastard>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151220140254.GA3618@laptop.bfoster>
	<20160104235951.GE28330@birch.djwong.org>
	<20160105124226.GA38749@bfoster.bfoster>
	<20160106020440.GL28330@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160106020440.GL28330@birch.djwong.org>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Jan 05, 2016 at 06:04:40PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 05, 2016 at 07:42:26AM -0500, Brian Foster wrote:
> > On Mon, Jan 04, 2016 at 03:59:51PM -0800, Darrick J. Wong wrote:
> > > I've temporarily fixed this by adding code that figures out how many blocks we
> > > need if the reference count btree has to have a unique record for every block
> > > in the AG and holding that many blocks until either they're allocated to the
> > > refcount btree or freed at umount time.  Right now it's a temporary fix (if the
> > > FS crashes, the reserved blocks are lost) but it wouldn't be difficult for the
> > > FS to make a permanent reservation that's recorded on disk somehow.  But that's
> > > involves writing things to disk + making xfsprogs understand the reservation;
> > > let's see what people say about the reserved pool idea at all.
> > > 
> > > Does that make sense? :)
> > > 
> > 
> > Yep, it sounds sort of like the reserve pool mechanism used to protect
> > against ENOSPC when freeing blocks. Curious... why are the reserved
> > blocks lost on fs crash? Wouldn't they be reserved again on the
> > subsequent mount?
> 
> They will, but the pre-crash reservation isn't (yet) written down anywhere on
> disk.

Does it need to be? The global reserve pool is not "written down"
anywhere. When we mount, we pull the reserve from the global free
space accounting. Hence we given ENOSPC when we've used "total fs
blocks - reserve pool blocks" in memory, and so if we crash we've
still got at least that many free blocks on disk. hence on mount we
re-reserve those blocks in memory and everything is back to the way
it was prior to the crash.

I suspect the per-ag code is a bit different, but it should be able
to work the same way. i.e. when we initialise the per-ag structure,
we pull the reserve from the free block count in the AG, as well as
from the global free space count. Then we will get correct global
ENOSPC detection, as well as leave enough space free in each AG as
we scan and skip them during allocation...

As long as the per-ag reservation is restored during mount before we
do EFI recovery processing (i.e. between the two log recovery
phases), it should restore the reserve pool to the same size as it
was before a crash occurred....

Unless, of course, I'm missing something newly introduced by the
reflink code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
