Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 12:30:51 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7QJUhws006794
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 12:30:44 -0700
Date: Tue, 26 Aug 2008 15:32:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: xfs_repair fixes for bad directories
Message-ID: <20080826193205.GA31105@infradead.org>
References: <op.udlsirmx3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.udlsirmx3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jul 01, 2008 at 06:00:17PM +1000, Barry Naujok wrote:
> Two issues have been encounted with xfs_repair and badly corrupted
> directories.
>
> 1. A huge size (inode di_size) can cause malloc which will fail.
>    Patch dir_size_check.patch checks for a valid directory size
>    and if it's bad, junks the directory. The di_size for a dir
>    only counts the data blocks being used, not all the other
>    associated metadata. This is limited to 32GB by the
>    XFS_DIR2_LEAF_OFFSET value in XFS. Anything greater than this
>    must be invalid.

As menioned before this one is trivial nad makes sens.

> 2. An update a while ago to xfs_repair attempts to fix invalid
>    ".." entries for subdirectories where there is a valid parent
>    with the appropriate entry. It was a partial fix that never
>    did the full job, especially if the subdirectory was short-
>    form or it has already been processed.
>
>    Patch fix_dir_rebuild_without_dotdot_entry.patch creates a
>    post-processing queue after the main scan to update any
>    directories with an invalid ".." entry.

Where is the existing attemp?  I can't find code doing anything like
that removed in the patch.  But the actual patch looks good, while
I had this mess with the tons of different boolean flags in repair
converting these to a more descriptive bitmask should be a different
patch.

> Both these patches sit on top of the dinode.patch that has been
> posted out for review previously.

But you didn't get a review for it, did you?  Looked over it briefly
and it looks good to m.  Again the new code is much much mor readable.
