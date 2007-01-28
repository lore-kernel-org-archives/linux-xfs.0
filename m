Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Jan 2007 14:23:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0SMNkqw020598
	for <xfs@oss.sgi.com>; Sun, 28 Jan 2007 14:23:48 -0800
Date: Mon, 29 Jan 2007 09:22:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Fix sub-page zeroing for buffered writes into unwritten extents
Message-ID: <20070128222249.GL33919298@melbourne.sgi.com>
References: <20070123224704.GH33919298@melbourne.sgi.com> <45B78CD4.1060400@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B78CD4.1060400@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Wed, Jan 24, 2007 at 04:44:04PM +0000, Lachlan McIlroy wrote:
> Dave,
> 
> I'm trying to understand what the sequence of events is here.
> 
> If we write to an unwritten extent then will __xfs_get_blocks()
> be called with create=1 and flags=BMAPI_WRITE?

Yup.

> And calling
> bhv_vop_bmap() with flags set to BMAPI_WRITE will cause xfs_iomap()
> to set iomap_flags to IOMAP_NEW?

Only if we allocate an extent in xfs_iomap:

In xfs_iomap:

    258 phase2:
    259         switch (flags & (BMAPI_WRITE|BMAPI_ALLOCATE|BMAPI_UNWRITTEN)) {
    260         case BMAPI_WRITE:
    261                 /* If we found an extent, return it */
    262                 if (nimaps &&
    263                     (imap.br_startblock != HOLESTARTBLOCK) &&
    264                     (imap.br_startblock != DELAYSTARTBLOCK)) {
    265                         xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, io,
    266                                         offset, count, iomapp, &imap, flags);
    267                         break;
    268                 }


We found an extent - an unwritten extent - which means we have a map
and the startblock is a real number (i.e. not a hole or delalloc region).
Hence we break here and never set the IOMAP_NEW flag which is correct
because we didn't just do an allocation.

> The combination of create=1 and
> iomap_flags=IOMAP_NEW in __xfs_get_blocks() should result in calling
> set_buffer_new(), right?

Yes, it would, but unwritten extents are not new extents.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
