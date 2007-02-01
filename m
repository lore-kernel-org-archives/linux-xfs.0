Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Jan 2007 22:54:08 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l116s1qw021257
	for <xfs@oss.sgi.com>; Wed, 31 Jan 2007 22:54:03 -0800
Message-ID: <45C18E22.5010102@sgi.com>
Date: Thu, 01 Feb 2007 17:52:18 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: freezing sometimes leaves the log dirty
References: <20070130220326.GM33919298@melbourne.sgi.com>
In-Reply-To: <20070130220326.GM33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Hi Dave,

It looks good to me.

Donald

David Chinner wrote:
> When we freeze the filesystem on a system that is under
> heavy load, the fleeze can complete it's flushes while there
> are still transactions active. Hence the freeze completes
> with a dirty log and dirty metadata buffers still in memory.
> 
> The Linux freeze path is a tangled mess - I had to go back
> to the irix code to work out exactly what we should be doing
> to work out why the linux code was failing because of
> the convoluted paths the linux code takes through the
> generic layers.
> 
> In short, when we freeze the writes, we should not be
> quiescing the filesystem at this point. All we should
> be doing is a blocking data sync because we haven't shut down
> the transaction subsystem yet. We also need to wait
> for all direct I/O writes to complete as well.
> 
> Once the data sync is complete, we can return to the generic
> code for it to freeze new transactions. Then we can wait for
> all active transactions to complete before we quiesce the
> filesystem which flushes out all the dirty metadata buffers.
> 
> At this point we have a clean filesystem and an empty log
> so we can safely write the unmount record followed by a
> dummy record to dirty the log to ensure unlinked list
> processing on remount if we crash or shut down the machine
> while the filesystem is frozen.
> 
> Comments?
> 
> Cheers,
> 
> Dave.
