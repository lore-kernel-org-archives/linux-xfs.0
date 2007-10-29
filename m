Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 14:10:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TLAUrr010243
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 14:10:33 -0700
Date: Tue, 30 Oct 2007 08:10:22 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Crash with XFS on top of DRBD (DRBD 8.0.6 svn / Kernel 2.6.22)
Message-ID: <20071029211021.GK995458@sgi.com>
References: <20071029101329.ietaisee@trusted.lncsa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029101329.ietaisee@trusted.lncsa.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Laurent Caron <lcaron@lncsa.fr>
Cc: drbd-user@linbit.com, xfs@oss.sgi.com

On Mon, Oct 29, 2007 at 10:14:19AM +0100, Laurent Caron wrote:
> Hi,
> 
> I'm back with my crash, oomkiller..... problems on my DRBD cluster of 2
> servers.
> 
> I compiled a 2.6.22 kernel with slab/slab debugging turned on.
> 
> Here is the last oom-killer message I got on that server.

You ran out of low memory. Slab didn't use it all, so I'm not
sure what would be using it. You should post OOM invokations
to LKML. Given DRDB is te unusual thing your are using, I'd
be looking there first...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
