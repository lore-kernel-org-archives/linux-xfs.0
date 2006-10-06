Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 23:37:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k966bUaG024696
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 23:37:32 -0700
Date: Fri, 6 Oct 2006 16:36:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: xfs_copy fix
Message-ID: <20061006063643.GD11034@melbourne.sgi.com>
References: <5635EC4CFB723E7E36B51235@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5635EC4CFB723E7E36B51235@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, Oct 06, 2006 at 04:18:10PM +1000, Timothy Shimmin wrote:
> Request for review.
> 
> xfs_copy was seg faulting for me on my x86_64 box.
> This fixes up the variable arg handling for multiple
> vfprintf calls by putting va_start and va_end calls
> around them (never done this before:).

I take it that it was crashing because the LOG flag and one
of ERR or OUT was set so it was trying to do 2 varargs
traversals with only one init?

Looks sane to me.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
