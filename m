Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Aug 2006 21:03:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7N43EDW026902
	for <linux-xfs@oss.sgi.com>; Tue, 22 Aug 2006 21:03:25 -0700
Date: Wed, 23 Aug 2006 14:02:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Infinite loop in xfssyncd on full file system
Message-ID: <20060823040218.GC807872@melbourne.sgi.com>
References: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: linux-xfs@oss.sgi.com, lnx1138@us.ibm.com

On Tue, Aug 22, 2006 at 04:01:10PM -0400, Stephane Doyon wrote:
> I'm seeing what appears to be an infinite loop in xfssyncd. It is 
> triggered when writing to a file system that is full or nearly full. I 
> have pinpointed the change that introduced this problem: it's
> 
>     "TAKE 947395 - Fixing potential deadlock in space allocation and
>     freeing due to ENOSPC"
> 
> git commit d210a28cd851082cec9b282443f8cc0e6fc09830.

Thanks for tracking that down - I've been trying to isolate a test case
for another report of this looping in xfssyncd.

[Luciano - this is the same problem we've been trying to track down.]

> I hope you XFS experts see what might be wrong with that bug fix. It's 
> ironic but for me, this (apparent) infinite loop seems much easier to hit 
> than the out-of-order locking problem that the commit in question was 
> supposed to fix. Let me know if I can get you any more info.

Now we know what patch introduces the problem, we know where to look.
Stay tuned...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
