Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Aug 2006 20:28:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7B3RjDW001718
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 20:27:57 -0700
Date: Fri, 11 Aug 2006 13:26:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: fsblock zero - don't panic
Message-ID: <20060811032626.GF50254148@melbourne.sgi.com>
References: <20060810155851.C2591606@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060810155851.C2591606@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 10, 2006 at 03:58:51PM +1000, Nathan Scott wrote:
> As part of attempting to understand what happened in a corruption
> problem awhile back, and generally be a bit more defensive of our
> precious primary superblock, some code was added to XFS to detect
> (and panic) on any inode extents that start at block zero.
> 
> This has happened once or twice now, and when it does, we panic the
> kernel.  This is not at all nice, as it means we take out the whole
> system due to ondisk corruption.  This patch makes that code issue
> a warning now, and fail whatever operation was in progress.

Looks OK.

FWIW:

> -	if ( !(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {
.....
> +	if (unlikely(
> +	    !(io->io_flags & XFS_IOCORE_RT) && !ret_imap->br_startblock)) {

If you are hinting this branch to be unlikely, then we should also
check the start block first before checking the io_flags.  We only
need to check the io_flags if we are actually accessing block zero.
i.e.

+	if (unlikely(
+	    !ret_imap->br_startblock && !(io->io_flags & XFS_IOCORE_RT))) {

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
