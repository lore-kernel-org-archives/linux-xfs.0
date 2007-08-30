Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 07:03:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7UE2u4p028503
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 07:02:58 -0700
Date: Fri, 31 Aug 2007 00:02:53 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
Message-ID: <20070830140253.GR61154114@sgi.com>
References: <46D6279F.40601@sgi.com> <46D6480F.4040307@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D6480F.4040307@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 30, 2007 at 02:31:11PM +1000, Timothy Shimmin wrote:
> Lachlan McIlroy wrote:
> >Log replay of clustered inodes currently ignores the flushiter
> >field in the inode that is used to determine if the on-disk inode
> >is more up to date than the copy in the log.  As a result during
> >log replay the newer inode is being overwritten with an older
> >version and file size updates are being lost.
> >
> >I haven't handled the case of the flushiter counter overflowing
> >but that shouldn't be a problem in this case.  The log buffer
> >contains newly created inodes so their flushiter values will be 0
> >and the on-disk inodes should not be much greater.
> >
> >Lachlan
> >
> 
> Still would want to understand why blf_flags doesn't have
> XFS_BLI_INODE_ALLOC_BUF set and so we could test that
> - I didn't understand Dave's (dgc) response about that earlier.

I never commented on why or why not that flag isn't set in the log
item. FWICT, it's not set because it is purely an in-memory flag.
State that gets logged gets put in bli_format.blf_flags (e.g.
XFS_BLI_FORMAT) whereas XFS_BLI_INODE_ALLOC_BUF is only ever
placed in bli_flags....

The function of that flag is to prevent the logged inode buffer from being
moved forward in the AIL so that it is always replayed at the time of
allocation so that subsequent transactions that modify the inodes and inode
buffers have a correctly allocated inode buffer to apply changes to during
recovery. And if the tail of the log moves past the allocation transaction,
it is guaranteed that the inodes can be read from disk so that recovery
has a correctly allocated inode buffer to apply changes to....

That being said, the flag could probably be propagated into the blf_flags
for (only) the allocation transaction if it makes discovery of this type
of buffer during recovery more reliable....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
