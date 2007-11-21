Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 13:31:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lALLV8ZA014131
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 13:31:14 -0800
Date: Thu, 22 Nov 2007 08:31:11 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] bulkstat fixups
Message-ID: <20071121213110.GD114266761@sgi.com>
References: <4733EEF2.9010504@sgi.com> <20071111214759.GS995458@sgi.com> <4737C11D.8030007@sgi.com> <20071112041121.GT66820511@sgi.com> <473D1DE0.1090106@sgi.com> <20071121151747.GC8454@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121151747.GC8454@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 21, 2007 at 03:17:47PM +0000, Christoph Hellwig wrote:
> +#define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
> +
> 
> 	I don't think this macro is really helpful.  An inline would
> 	have been useful if statstruct_size was constant, but this
> 	way it's much better to just write out the comparism the four
> 	times it's used.
> 
> +	if (!ubcountp || *ubcountp <= 0) {
> +		return EINVAL;
> +	}
> 
> 	No need for the braces here.
> 
> 
> I also must say I don't like the cond_resched() calls very much.  They
> look entirely random to me.  We really should only need cond_resched
> when it's absolutely needed, and it deserves a comment why it's needed
> then.

I think I mentioned that we don't need them in the innermost loop.
The reason for adding them is that if the inode clusters are in cache,
bulkstat will not yield the cpu at all and so holds off other
things from operating on that CPU. And when bulkstat has got itself
stuck in a loop, if it's running on the same CPU as I/O completion
events are running on (i.e. disk interrupts delivered to) it basically
hangs the filesystem. If that CPU is taking interrupts for your root
filesystem....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
