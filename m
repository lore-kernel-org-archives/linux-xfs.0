Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 05:14:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l78CE3bm021823
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 05:14:07 -0700
Date: Wed, 8 Aug 2007 22:13:59 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS thread inflation in 2.6.23rc
Message-ID: <20070808121359.GP52011508@sgi.com>
References: <200708081240.21548.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708081240.21548.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: xfs@oss.sgi.com

On Wed, Aug 08, 2007 at 12:40:21PM +0200, Andi Kleen wrote:
> 
> In 2.6.23rc I have a new kernel thread running from XFS:
> 
> 30137 ?        S<     0:00 [xfs_mru_cache]
> 
> Is that one really needed? Can it be started only on demand when that MRU
> feature is used? 

It uses a single threaded workqueue for reaping objects and the thread comes
along with that. Creating the workqueue on demand would require creating a
kernel thread inside a transaction and that's not some thing we want to do.
It can't really be put into an existing thread/workqueue because of
deadlock problems which is why it has it's own workqueue....

Besides, what's the point of having nice constructs like dedicated
workqueues if people complain when they get used to solve problems?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
