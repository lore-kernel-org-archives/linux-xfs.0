Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 03:51:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3BAp1YE004441
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 03:51:05 -0700
Date: Fri, 11 Apr 2008 20:51:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfslogd Page Allocation Failure
Message-ID: <20080411105133.GU103491721@sgi.com>
References: <1207908397.4745.9.camel@humanitas.fs3.ph>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207908397.4745.9.camel@humanitas.fs3.ph>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Federico Sevilla III <jijo@fs3.ph>
Cc: xfs@oss.sgi.com

On Fri, Apr 11, 2008 at 06:06:37PM +0800, Federico Sevilla III wrote:
> Hi,
> 
> I noticed the below logs in my dmesg. The machine continues to be
> useable, and I'm not aware of which process wasn't able to perform
> correctly. Is this a cause for concern? Hope you can advise.
> 
> Thank you very much.
> 
> xfslogd/1: page allocation failure. order:0, mode:0x0
> Pid: 261, comm: xfslogd/1 Not tainted 2.6.24.2 #1
> 
> Call Trace:
>  [<ffffffff8025a9b2>] __alloc_pages+0x223/0x381
>  [<ffffffff802753be>] __slab_alloc+0x178/0x53b
>  [<ffffffff80321c39>] free_address+0x17/0x66
>  [<ffffffff802759ac>] kmem_cache_alloc+0x76/0x7c
>  [<ffffffff80321c39>] free_address+0x17/0x66
>  [<ffffffff80321d03>] xfs_buf_free+0x7b/0x7d
>  [<ffffffff802eb4fc>] xfs_buf_iodone_callbacks+0x107/0x17b
>  [<ffffffff80322ba0>] xfs_buf_iodone_work+0x0/0x72

There's nothing to worry about from an XFs perspective from this
error message.  XFS handles the memory allocation error here and
does the right thing. The memory allocator is just being noisy.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
