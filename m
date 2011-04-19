Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3J4AmPA017560 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 23:10:48 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 054E83F5A4E
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 21:14:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	x07fXjzM4DcJtWXP for <xfs@oss.sgi.com>;
	Mon, 18 Apr 2011 21:14:12 -0700 (PDT)
Date: Tue, 19 Apr 2011 14:14:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110419041408.GC23985@dastard>
References: <4DA7836A.5040604@draigBrady.com> <20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419025949.GA3030@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110419025949.GA3030@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Mon, Apr 18, 2011 at 10:59:49PM -0400, Ted Ts'o wrote:
> On Tue, Apr 19, 2011 at 09:58:15AM +0800, Yongqiang Yang wrote:
> > On Mon, Apr 18, 2011 at 10:45 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> > > Always passing FIEMAP_FLAG_SYNC is fine in this case. It should
> > > only do anything if there is unwritten data, which is the only
> > > case we are concerned with at this point.  In any case, this is a
> > > simple solution for coreutils until such a time that a more
> > > complex solution is added in the kernel (if ever).
> 
> I would recommend that coreutils check i_blocks and i_size and only
> try using fiemap (with FIEMAP_FLAG_SYNC) if the file appears to be
> sparse.  That's because FIEMAP_FLAG_SYNC will do the effectively
> equivalent of an fsync() system call.  Otherwise, in the case of a
> freshly untar'ed directory hierarchy which is then copied using "cp
> -r", cp would end up calling fsync() for each file in the directory,
> with the disastrous performance result that one might expect.
> 
> If cp only tries the fiemap optimization on files that appear to be
> sparse, it should avoid this problem.
> 
> > > Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this problem.
> > >
> > > I don't see how this will change the problem in any meaningful way. There
> > > will still need to be code that is traversing the on-disk mapping, and also
> > > keeping it coherent with unwritten data in the page cache.
> 
> The advantage of SEEK_HOLE/SEEK_DATA is that we don't need to force an
> fsync() of the data.
> 
> > It seems that we are being messed up by page cache and disk.
> > Unwritten flag returned from FIEMAP indicates blocks on disk are not
> > written, but it does not say if there is data in page cache.  So
> > FIEMAP itself just tells user the map on disk.  However there is an
> > exception for delayed allocation,  FIEMAP tells users the data is in
> > page cache.
> > 
> > Maybe FIEMAP should return all known messages for unwritten extent, if
> > unwritten data exists in page cache, FIEMAP should let users know that
> > data is in page cache and space on disk has been preallocated, but
> > data has not been flushed into disk.  Actually, delayed allocation has
> > done like this. Then user-space applications can determine how to do.
> > Taking cp as an example, it will copy from page cache rather ignore
> > it.
> >
> > We need a definite definition for FIEMAP, in other words, it tells
> > users map on disk or both disk and page cache.
> > 
> > If the former one is taken, then FIEMAP should not consider delayed
> > allocation.  otherwise, FIEMAP should return all known messages for
> > unwritten case like delayed allocation.
> 
> The fact that the FIEMAP interface deifnition includes an delayed
> allocation bit could be a strong indication that unlike the XFS's bmap
> interface, that this interface is supposed to return information
> taking into account both on-disk and page cache information.

As I said in a previous email, XFS uses delalloc as a first class
extent and reporting them does not require looking at the page
cache. Therefore whatever historical behaviour xfs_bmap used is
irrelevant - supporting delalloc extents was a 2 or 3 line change
and in no way was intended to report anything other than the current
extents. Even at that time, "dirty page cache ranges" != delalloc
extents, and this appears to be the way ext4 has _implemented_
reporting of delalloc extents. 

Indeed, I was the one that suggested it be supported because it is
useful to know the delalloc state _for debugging purposes_.  Now you
are trying to redefine what a delalloc extent is to match the ext4
implementation, and then extend that same reasoning to change what
an unwritten extent means to match how _you think_ the ext4
implementation works(*).

And besides, if I use your same logical progression you've
applied to FIEMAP via the ext4 delalloc extent implementation, using
the XFS delalloc extent implementation in no way implies page cache
coherency for FIEMAP. :)

FIEMAP is for reporting extent state. What that means is filesystem
specific, and requires knowledge of the filesystem to use
effectively. If you want to report coherent state for working out
what ranges to copy, implement SEEK_HOLE/SEEK_DATA (which would use
much of the FIEMAP infrastructure). Redefining the FIEMAP API will
not solve the problem of different filesystems behaving in a manner
that is not useful for coreutils....

> Maybe coreutils will need to use FIEMAP_FLAG_SYNC initially, since
> it's the only way to guarantee correct behaviour for XFS.  But I would
> really rather that be the long-term way we leave things!

(*) It's not XFS specific - ext4 behaves exactly the same way (as
eric kindly pointed out). IOWs, it's likely that all filesystems
need the SYNC flag for one reason or another and that indicates to
me that FIEMAP is simply not the right interface for coreutils to be
using for their intended purpose.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
