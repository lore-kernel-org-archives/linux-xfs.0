Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 16:21:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m280L8DQ016909
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 16:21:10 -0800
Date: Sat, 8 Mar 2008 11:21:24 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] prototype file data inode inlining
Message-ID: <20080308002124.GN155407@sgi.com>
References: <20080307093411.4B1912DC9B2@mail.valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307093411.4B1912DC9B2@mail.valinux.co.jp>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: IWAMOTO Toshihiro <iwamoto@valinux.co.jp>
Cc: xfs@oss.sgi.com

On Fri, Mar 07, 2008 at 06:34:09PM +0900, IWAMOTO Toshihiro wrote:
> Hi,
> 
> I've done a prototype implementation of file data inlining in inodes a
> while ago.  It was originally meant to solve a performance problem
> with a large number of small files at some customer site.
> Although I measured some performance gains, a different workaround has
> been adopted due to the patch quality problem.
> 
> As I'm not asking for inclusion, the patch hasn't been ported to the
> current kernel version.  This patch might be useful if someone has a
> similar performance problem and would like to see if file inlining
> helps or not.

Interesting. I'm not going to comment on the code, just the overall
design and implementation.

Problems:

	- data loss on crash is unacceptable

	- this is an on-disk format change - it needs to be
	  implemented either as a mkfs option with a specific
	  superblock feature bit, or as a mount option with a
	  version 3 inode and a superblock feature bit to indicate
	  inodes with data in them have been created.

	- local -> extent conversion occurs at copy-in time, not writeback
	  time, so using the normal read/write paths through ->get_blocks()
	  will fail here in xfs_bmapi():

   4793         if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
   4794 >>>>>>>>        ASSERT(wr && tp);
   4795                 if ((error = xfs_bmap_local_to_extents(tp, ip,
   4796                                 firstblock, total, &logflags, whichfork)))
   4797                         goto error0;
   4798         }

	  because on a normal read or write (delayed allocation) we
	  are not doing allocation and hence do not have an open
	  transaction the first time we come through here. Just
	  avoiding this conversion and returning zero maps if we are
	  not writing will not help in the delayed allocation case.
	

I note that you hacked around this by special casing the inline
format ->get_blocks() callout to copy the data into the page and
marking it mapped and uptodate. I think this is the wrong approach
and is not the right layer at which to make this distinction - the special
casing needs to be done at higher layers, not in the block mapping
function.

I think for inline data, we'd do best to special case this as high
up the read/write paths as possible. e.g. for read() type operations
intercept in xfs_read() and just do what we need to do there for
populating the single page cache page. For write, we should let it
go through the normal delayed allocation mechanisms, only converting
to local format during ->writepage() if there's a single block
extent and it fits in the data fork. This also handles the truncate
case nicely.

For mmap operations, we need to handle the inline case separately
to the normal ->readpage case, similar to the xfs_read() case.
->readpages should never occur on an inline data inode.

> Some random notes and the patch itself follows.
> 
> Inlined file data are written from xfs_page_state_convert().
> The xfs_trans related operations in that function is to get inode
> written on disk and isn't for crash consistency.

Which is the exact opposite of what they are supposed to be used for.
Given that the next thing that happens after data write in the writeback path
is ->write_inode(), forcing the inode into the log for pure data changes
is unnecessary. We just need to format the data into the inode during
data writeback.

> Small files are made inlined when created.  Non inlined files don't
> get inlined when they are truncated.

As I inferred above, I think this is the wrong approach. Start the
inodes in extent format just like they currently are, and only
convert in writeback. This means no changes to the write path or
delayed allocation handling. That is, only the disk format should
care if the data is inline or not; everything in memory still treats
data as block based extents. i.e. the only time we do anything w.r.t
local data format is reading the inode off disk and writing it back
to disk.

The only issue here is that extent->local conversion requires a
free transaction, not an allocation transaction, but that should
not be difficult to handle as we can log the inode complete with
inline data in the free transaction to make that conversion atomic.

> xfs_bmap_local_to_extents() has been modified to work with file data,
> but logging isn't implemented.  A machine crash can cause data
> corruption.

There are two ways to do inline->extent safely from a crash recovery
perspective. 

Method 1: Use an Intent/Done transaction pair

The way this needs to be done is via a pair of transactions. The
first allocation transaction remains the same, but needs a different
type - an "allocation intent" rather than an "allocation"
transaction.  On data I/O completion, we then need an " allocation
complete" transaction that signals that the data is on disk and the
allocation intent is now permanent.

That means we can change state in memory and log it to disk before
the data write is done, but it won't get replayed on crash unless
the allocation completion transaction is also in the log after the
data is safely on disk.  Hence we don't overwrite data in the inode
during recovery if there is no copy of it elsewhere.

This needs modifications to the recovery code to understand the
new transaction types correctly.

Method 2: Log the data

We can log any object that is held in a xfs_buf_t. During
conversion, we could simply build an xfs_buf_t that points to the
page that holds the data and log that.  The complexity here is that
the buffer needs to point to the inodes address space, not the
address space of the buftarg where all the metadata resides.  The
xfs_buf_t in this case should only exist for the life of the data
I/O; once the data I/O is complete we can tear it down and go back
to treating the page normally.

> O_SYNC may behave incorrectly.

->write_inode(SYNC) should handle it just fine.

> Use of attribute forks isn't considered and likely has issues.

If you don't change the way the attribute fork handling works, it
should be just fine.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
