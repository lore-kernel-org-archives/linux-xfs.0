Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 13:13:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0MLCwQq031716
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 13:13:01 -0800
Date: Wed, 23 Jan 2008 08:13:11 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
Message-ID: <20080122211311.GA155259@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local> <20080119004018.GH155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 22, 2008 at 11:40:52AM -0800, Mark Magpayo wrote:
> Any ideas on how long the xfs_repair is supposed to take on 18TB?  I
> started it Friday nite, and it's now Tuesday afternoon.  It's stuck
> here:
> 
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> 
> I figure traversing a filesystem of 18TB takes a while, but does 4 days
> sound right?

Yes, it can if it's swapping like mad because you don't have enough
RAM in the machine. Runtime is also detemrined by how many inodes there
are in the filesystem - do you know how many there are? Also, more
recent xfs_repair versions tend to be faster - what version are you
using again?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
