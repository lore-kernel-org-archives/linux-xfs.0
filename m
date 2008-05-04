Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 May 2008 16:50:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m44NoDM9026273
	for <xfs@oss.sgi.com>; Sun, 4 May 2008 16:50:15 -0700
Date: Mon, 5 May 2008 09:50:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: question about xfs_alloc_fix_freelist()
Message-ID: <20080504235048.GC155679365@sgi.com>
References: <038C959C13632143B902BE360CA5B58E3C552E@mx1.ddns.agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <038C959C13632143B902BE360CA5B58E3C552E@mx1.ddns.agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: xfs@oss.sgi.com

On Fri, May 02, 2008 at 02:01:47PM -0700, Michael Nishimoto wrote:
> 
> The following code can be found near the end of xfs_alloc_fix_freelist:
> 
>                 if (targs.agbno == NULLAGBLOCK) {
>                         if (flags & XFS_ALLOC_FLAG_FREEING)
>                                 break;
>                         xfs_trans_brelse(tp, agflbp);
>                         args->agbp = NULL;
>                         return 0;
>                 }
> 
> Don't we need to release agbp too by calling xfs_trans_brelse(tp, agbp)?

I don't think so. AFAICT, The agbp (agf block) is linked into the
transaction and by this point we may have modified the AGF (think
multiple iterations of the loop to fill the free list). Given that
it may be modified, we shouldn't release it here but instead allow
the transaction commit/abort to do that for us at the appropriate
time.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
