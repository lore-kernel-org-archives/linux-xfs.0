Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 22:24:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S5NQDW010498
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 22:23:38 -0700
Date: Fri, 28 Jul 2006 15:22:44 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: block bogus bulkstat messages, last stage
Message-ID: <20060728152244.H2196410@wobbly.melbourne.sgi.com>
References: <20060726101537.H2118045@wobbly.melbourne.sgi.com> <44C99C86.2000208@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44C99C86.2000208@sgi.com>; from tes@sgi.com on Fri, Jul 28, 2006 at 03:11:34PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 28, 2006 at 03:11:34PM +1000, Timothy Shimmin wrote:
> 1. xfs_ialloc.c
> +		xfs_stack_trace();
> What's the stack trace for?
> It is just to give more info after one of the 3 error msgs
> beforehand? Happens in DEBUG. Okay.

Yep, basically just to help figure out how the warning got triggered.
If it gets triggered now, it always indicates a real problem... while
before it was only possibly a problem.

> Seems fine.

Thanks for the review.

cheers.

-- 
Nathan
