Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3J2uZMX014953 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 21:56:35 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05478BF9B6A
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 20:00:00 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id sx5F8yCyCiCx6P6C for
	<xfs@oss.sgi.com>; Mon, 18 Apr 2011 20:00:00 -0700 (PDT)
Date: Mon, 18 Apr 2011 22:59:49 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110419025949.GA3030@thunk.org>
References: <20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Tue, Apr 19, 2011 at 09:58:15AM +0800, Yongqiang Yang wrote:
> On Mon, Apr 18, 2011 at 10:45 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> > Always passing FIEMAP_FLAG_SYNC is fine in this case. It should
> > only do anything if there is unwritten data, which is the only
> > case we are concerned with at this point.  In any case, this is a
> > simple solution for coreutils until such a time that a more
> > complex solution is added in the kernel (if ever).

I would recommend that coreutils check i_blocks and i_size and only
try using fiemap (with FIEMAP_FLAG_SYNC) if the file appears to be
sparse.  That's because FIEMAP_FLAG_SYNC will do the effectively
equivalent of an fsync() system call.  Otherwise, in the case of a
freshly untar'ed directory hierarchy which is then copied using "cp
-r", cp would end up calling fsync() for each file in the directory,
with the disastrous performance result that one might expect.

If cp only tries the fiemap optimization on files that appear to be
sparse, it should avoid this problem.

> > Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this problem.
> >
> > I don't see how this will change the problem in any meaningful way. There
> > will still need to be code that is traversing the on-disk mapping, and also
> > keeping it coherent with unwritten data in the page cache.

The advantage of SEEK_HOLE/SEEK_DATA is that we don't need to force an
fsync() of the data.

> It seems that we are being messed up by page cache and disk.
> Unwritten flag returned from FIEMAP indicates blocks on disk are not
> written, but it does not say if there is data in page cache.  So
> FIEMAP itself just tells user the map on disk.  However there is an
> exception for delayed allocation,  FIEMAP tells users the data is in
> page cache.
> 
> Maybe FIEMAP should return all known messages for unwritten extent, if
> unwritten data exists in page cache, FIEMAP should let users know that
> data is in page cache and space on disk has been preallocated, but
> data has not been flushed into disk.  Actually, delayed allocation has
> done like this. Then user-space applications can determine how to do.
> Taking cp as an example, it will copy from page cache rather ignore
> it.
>
> We need a definite definition for FIEMAP, in other words, it tells
> users map on disk or both disk and page cache.
> 
> If the former one is taken, then FIEMAP should not consider delayed
> allocation.  otherwise, FIEMAP should return all known messages for
> unwritten case like delayed allocation.

The fact that the FIEMAP interface deifnition includes an delayed
allocation bit could be a strong indication that unlike the XFS's bmap
interface, that this interface is supposed to return information
taking into account both on-disk and page cache information.  If this
is the case, then even though there might be a single on-disk
(uninitialized) extent, if there are pages in the page cache that have
not yet been written out yet, but which are described by that on-disk
extent, then instead of returning a single struct fiemap_extent for
that on-disk extent, the fiemap ioctl would need to return multiple
struct fiemap_extents, where some would have the FIEMAP_UNWRITTEN bit,
and others would not (since data has been written to the page cache,
even if it hasn't been flushed to disk yet).

But yes, if we're going to make the case that the FIEMAP interface is
only intended to reflect the on-disk information, then the DELALLOC
bit shouldn't be returned at all, and we should deprecate it.
Anything else leads us to a inconsistent interface.

> > Since FIEMAP already exists for most Linux filesystems, it probably makes
> > sense to implement SEEK_{HOLE,DATA} by calling FIEMAP to get the disk
> > mapping in the first place.

Not if it means forcing an FIEMAP_FLAG_SYNC, which implies an fsync().
If the only way to get consistent data across ext4, btrfs, xfs,
etc. is to force userspace to issue a FIEMAP_FLAG_SYNC, then we need
to have a separate interface of SEEK_HOLE/SEEK_DATA that doesn't
require flushing data to the disk first.

Maybe coreutils will need to use FIEMAP_FLAG_SYNC initially, since
it's the only way to guarantee correct behaviour for XFS.  But I would
really rather that be the long-term way we leave things!

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
