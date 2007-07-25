Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jul 2007 20:03:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6P33Obm022479
	for <xfs@oss.sgi.com>; Tue, 24 Jul 2007 20:03:28 -0700
Date: Wed, 25 Jul 2007 13:03:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Couple of code comments
Message-ID: <20070725030318.GD31489@sgi.com>
References: <46A6AE99.3000502@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A6AE99.3000502@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, Jul 24, 2007 at 06:59:53PM -0700, Michael Nishimoto wrote:
> Hi,
> 
> I've got a couple of code comments.  In xfs_write, there is a
> call to bhv_vop_flushinval_pages().  It appears that this function call
> is not needed because the call to generic_file_direct_write() done
> later in xfs_write does the same work.
> 
> generic_file_direct_write -> generic_file_direct_IO ->
> (filemap_write_and_wait + invalidate_inode_pages2_range)
> 
> bhv_vop_flushinval_pages -> fs_flushinval_pages ->
> (filemap_write_and_wait + truncate_inode_pages)

Similar, but seeing we call generic_file_direct_write() without the
i_mutex held and we don't use the generic direct I/O path locking or
flushes (i.e in __blockdev_direct_IO()), we've got to do this flush
somewhere with the i_mutex held....

That being said, xfs_write() is an utter mess and could do
with a major cleanup.

> The code isn't exactly the same, but it appears to do the same work.

Locking is the key difference.

> Also, within xfs_swap_extents() the code fixes up on-disk inode block
> counts, but doesn't change the block counts for the Linux inode.

Patch, please. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
