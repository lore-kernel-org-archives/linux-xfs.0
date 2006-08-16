Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 23:59:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7G6whDW004638
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 23:58:54 -0700
Date: Wed, 16 Aug 2006 16:57:56 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: fsblock zero - don't panic
Message-ID: <20060816165756.C2770659@wobbly.melbourne.sgi.com>
References: <20060810155851.C2591606@wobbly.melbourne.sgi.com> <20060811032626.GF50254148@melbourne.sgi.com> <20060816142800.D2762042@wobbly.melbourne.sgi.com> <20060816064725.GK51703024@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060816064725.GK51703024@melbourne.sgi.com>; from dgc@sgi.com on Wed, Aug 16, 2006 at 04:47:25PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 16, 2006 at 04:47:25PM +1000, David Chinner wrote:
> On Wed, Aug 16, 2006 at 02:28:01PM +1000, Nathan Scott wrote:
> ...
> 		xfs_cmn_err_fsblock_zero(ip, ret_imap);
> 
> would replace the above mess....

Will do.

> > -	if (!(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {
> 
> And this one checks ret_imap for block zero, not imap[0].
> 
> One of these original checks was buggy - which one should we be checking,
> ret_imap that is being passed into the function or imap that is what was
> returned  by the XFS_BMAPI call?

The latter I think - I'll look more closely tomorrow, and fix that up.

cheers.

-- 
Nathan
