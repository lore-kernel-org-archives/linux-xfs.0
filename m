Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jul 2007 17:52:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6D0pubm021834
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 17:51:58 -0700
Date: Fri, 13 Jul 2007 10:51:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: Make sure xfs_repair uses sector aligned I/O
Message-ID: <20070713005123.GH31489@sgi.com>
References: <op.tvdn7xhl3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tvdn7xhl3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, Jul 13, 2007 at 10:41:47AM +1000, Barry Naujok wrote:
> Two places it didn't:
>  - reading the initial primary superblock
>  - checking the log
> 
> The log checking fix was basically porting the kernel
> xlog_bread/xlog_get_bp/xlog_align from the kernel and
> setting up the log_t structure properly in Phase 2.
> 
> The initial primary superblock read is now done
> using the maximum supported sector size as once the
> block is read and translated to another location,
> it's discarded.

Seems OK from a quick look of the code. Were you able to
confirm that these are the only places we do non-sector sized
I/O?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
