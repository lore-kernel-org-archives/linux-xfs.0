Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 15:55:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4UMtOWt020004
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 15:55:26 -0700
Date: Thu, 31 May 2007 08:55:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Reducing memory requirements for high extent xfs files
Message-ID: <20070530225516.GB85884050@sgi.com>
References: <200705301649.l4UGnckA027406@oss.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705301649.l4UGnckA027406@oss.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@stanfordalumni.org>
Cc: xfs@oss.sgi.com

On Wed, May 30, 2007 at 09:49:38AM -0700, Michael Nishimoto wrote:
> Hello,
> 
> Has anyone done any work or had thoughts on changes required
> to reduce the total memory footprint of high extent xfs files?

We changed the way we do memory allocation to avoid needing
large contiguous chunks of memory a bit over a year ago;
that solved the main OOM problem we were getting reported
with highly fragmented files.

> Obviously, it is important to reduce fragmentation as files
> are generated and to regularly defrag files, but both of these 
> alternatives are not complete solutions.
>
> To reduce memory consumption, xfs could bring in extents
> from disk as needed (or just before needed) and could free 
> up mappings when certain extent ranges have not been recently
> accessed.  A solution should become more aggressive about 
> reclaiming extent mapping memory as free memory becomes limited.

Yes, it could, but that's a pretty major overhaul of the extent
interface which currently assumes everywhere that the entire
extent tree is in core.

Can you describe the problem you are seeing that leads you to
ask this question? What's the problem you need to solve?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
