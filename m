Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 02:34:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2B9Xiaw015696
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 02:33:48 -0700
Date: Tue, 11 Mar 2008 20:34:06 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
Message-ID: <20080311093406.GN155407@sgi.com>
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com> <20080213214551.GR155407@sgi.com> <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com> <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com> <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com> <20080310000809.GU155407@sgi.com> <1a4a774c0803100302y17530814wee7522aa0dfd7668@mail.gmail.com> <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com> <20080310222135.GZ155407@sgi.com> <1a4a774c0803110108u3f01813fs7f9540f886be055@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a4a774c0803110108u3f01813fs7f9540f886be055@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian =?iso-8859-1?Q?R=F8snes?= <christian.rosnes@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 11, 2008 at 09:08:31AM +0100, Christian Røsnes wrote:
> On Mon, Mar 10, 2008 at 11:21 PM, David Chinner <dgc@sgi.com> wrote:
> >  You've got a filesystem with stripe alignment set. In xfs_ialloc_ag_alloc()
> >  we attempt inode allocation by the following rules:
> >
> >         1. a) If we haven't previously allocated inodes, fall through to 2.
> >            b) If we have previously allocated inode, attempt to allocate next
> >               to the last inode chunk.
> >
> >         2. If we do not have an extent now:
> >                 a) if we have stripe alignment, try with alignment
> >                 b) if we don't have stripe alignment try cluster alignment
> >
> >         3. If we do not have an extent now:
> >                 a) if we have stripe alignment, try with cluster alignment
> >                 b) no stripe alignment, turn off alignment.
> >
> >         4. If we do not have an extent now: FAIL.
> >
> >  Note the case missing from the stripe alignment fallback path - it does not
> >  try without alignment at all. That means if all those extents large enough
> >  that we found above are not correctly aligned, then we will still fail
> >  to allocate an inode chunk. if all the AGs are like this, then we'll
> >  fail to allocate at all and fall out of xfs_dialloc() through the last
> >  fragment I quoted above.
> >
> >  As to the shutdown that this triggers - the attempt to allocate dirties
> >  the AGFL and the AGF by moving free blocks into the free list for btree
> >  splits and cancelling a dirty transaction results in a shutdown.
> >
> >  Now, to test this theory. ;) Luckily, it's easy to test. mount the
> >  filesystem with the mount option "noalign" and rerun the mkdir test.
> >  If it is an alignment problem, then setting noalign will prevent
> >  this ENOSPC and shutdown as the filesystem will be able to allocate
> >  more inodes.
> >
> >  Can you test this for me, Christian?
> 
> Thanks. Unfortunately noalign didn't solve my problem:

Ok, reading the code a bit further, I've mixed up m_sinoalign,
m_sinoalignmt and the noalign mount option. The noalign mount option
turns off m_sinoalign, but it does not turn off inode cluster
alignment, hence we can't fall back to an unaligned allocation.

So the above theory still holds, just the test case was broken.

Unfortunately, further investigation indicates that inodes are
always allocated aligned; I expect that I could count the number of
linux XFS filesystems not using inode allocation alignment because
mkfs.xfs has set this as the default since it was added in mid-1996.

The problem with unaligned inode allocation is the lookup case
(xfs_dilocate()) in that it requires btree lookups to convert the
inode number to a block number as you don't know where in the chunk
the inode exists just by looking at the inode number. With aligned
allocations, the block number can be derived directly from the inode
number because we know how the inode chunks are aligned.

IOWs, if we allow an unaligned inode chunk allocation to occur, we
have to strip the "aligned inode allocation" feature bit from the
filesystem and the related state and use the slow, btree based
lookup path forever more. That involves I/O instead of a simple
mask operation....

Hence I'm inclined to leave the allocation alignment as it stands
and work out how to prevent the shutdown (a difficult issue in
itself).

> I'll try to add some printk statements to the codepaths you mentioned,
> and see where it leads.

Definitely worth confirming this is where the error is coming from.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
