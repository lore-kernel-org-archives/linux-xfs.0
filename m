Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 482FE7FC0
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 23:14:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 27BA48F8035
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 21:14:34 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	13P7H7PeEoZmqJFC for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 21:14:32 -0700 (PDT)
Date: Fri, 15 Mar 2013 15:05:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/18] xfstests: Clear out old benchmarking materials
Message-ID: <20130315040531.GH21651@dastard>
References: <20130314130611.4A3C153DEAF1@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130314130611.4A3C153DEAF1@polaris-admin.engr.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Philip White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 06:06:11AM -0700, Philip White wrote:
> From: Phil White <pwhite@sgi.com>
> 
> 
> This is a rebasing & resubmit of a dchinner patch.  His comments on the
> original:
> -----------------
> The benchmark framework inside xfstests is basically unused,
> bitrotted and not very useful. If we need benchmarks, lets use a
> real benchmark framework, not xfstests. Kill it to remove
> dependencies on common and common.rc.
> -----------------
> 
> The current benchmark framework has bitrotted, but it is not without value
> in my view.  It should be removed and updated.  In the interest of future
> useability, I have kept the dependencies on common and common.rc.

This makes no sense - you've removed everything but the bench
script, which can't do anything without all the bits you just
removed. But you still want to keep a useless script and it's
dependencies around "just because".

Let go of bench. Re-implement it from scratch rather than try to
shoehorn it into the stub of the old, bitrotted code. IOWs, any new
benchmarking infrastructure needs to abstravct and document each
dependency it adds to the common code - that way we don't end up
with keeping unnecessary dependencies around or trying to shoehorn
new code into abstractions that don't make sense.

FWIW, this comes back to what I said about having a patch series
description - I didn't realise at first that you hadn't completely
removed all of the bench infrastructure because there was no
overview of what you'd done. Hence it's only now that I'm looking
at the patches in detail have I noticed this subtle change you made
to my original patch set....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
