Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KHIFHR105723 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 12:18:15 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 788B13FC0F9
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 10:21:42 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id mFnnz2F5GmkrQ59A for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2011 10:21:42 -0700 (PDT)
Date: Wed, 20 Apr 2011 13:21:27 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110420172127.GF3030@thunk.org>
References: <20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard> <20110419140909.GD3030@thunk.org>
	<4DAD987F.5000506@sandeen.net> <20110419160114.GE3030@thunk.org>
	<20110420152131.GA7123@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110420152131.GA7123@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, P?draig Brady <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Wed, Apr 20, 2011 at 11:21:31AM -0400, Christoph Hellwig wrote:
> 
> How do you want to union the existance of an extent with a state
> on disk, with a pending modification to it that is still in-memory
> and not flushed out to disk yet?  This is looking into an uncertain
> future, as the extent map might change in various other ways before
> the transaction to conver the unwritten extents goes to disk.

So for example, suppose you have a single unwritten extent on disk,
but there are 3 regions within that extent range's that have unwritten
pages, you return 3 or 4 fiemap_extent structures, reflecting the
state if the unwritten pages were pushed out to disk at the time of
the fiemap ioctl --- but without actually doing the expensive sync
operation.  The one case where you can't do that is in the case of
delayed allocation blocks, since you won't know where on disk they
would be going, necessarily --- but hey, conveniently we have a
DELALLOC bit already defined....

> And if we do this it would need to be a new option to FIEMAP, as
> it changes the semantics from the existing one that returns the
> actual state on disk (plus the magic delalloc bit).

Well, we seem to have inconsistent semantics right now, because we
never defined the semantics clearly enough from the beginning.  So no
matter which choice we choose, including "the on-disk extent state
only, and nuke the delalloc bit", we will be changing semantics.  I'm
not sure we can get around that.

> And even if you find semantics that take pending unwrittent extent
> conversions into account and still make sense how do you plan to
> implement them?  For buffered writes into unwritten extents it could
> be done by walking the pagecache and buffers after adding a new
> flag for an already converted unwritten extent to the buffer head
> state.  But there's no easy way to do that for direct I/O.

If the file is being actively modified (for example with direct I/O),
there will be inevitably race conditions.  If only some of the pending
conversions have been taken into account, that seems like it's
reasonable result.  If a file is actively being modified by many DIO
writes, even using FIEMAP_FLAG_SYNC isn't going to help you get a
coherent view of the file, so this seems to be a previously unsolved
problem....

> > In the case of #1 and #2, we really need to implement support for
> > SEEK_HOLE/SEEK_DATA for userspace programs like cp who want to know
> > this information.
> 
> We need to do that anyway, as fiemap is a horrible interface for
> tools that just want to skip holes.

I agree that implementing SEEK_HOLE/SEEK_DATA is a good thing
regardless of which choice we end up choosing.

	      	    	      	     - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
