Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Nov 2007 13:00:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lADL0LfD008145
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2007 13:00:26 -0800
Date: Wed, 14 Nov 2007 08:00:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: porting xfs_reno to linux
Message-ID: <20071113210018.GX995458@sgi.com>
References: <4739EB0B.6030407@linworks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4739EB0B.6030407@linworks.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <ruben.porras@linworks.de>
Cc: xfs@oss.sgi.com

On Tue, Nov 13, 2007 at 07:20:59PM +0100, Ruben Porras wrote:
> Let's go back to the shrink xfs theme.
> 
> >2. Move inodes out of offline AGs
> >		- On Irix, we have a program called 'xfs_reno' which
> >		  converts 64 bit inode filesystems to 32 bit inode
> >		  filesystems. This needs to be:
> >		  	- released under the GPL (should not be a problem).
> 
> done
> 
> >			- ported to linux
> 
> Do you mean, rewrite the program to work on kernel space,

No.

> or just port it 
> to glibc?

Port to linux. i.e. make it work and remove any tainted code that it
might contain from  Irix so we can open source it.  Barry has
already done this; the patch is here:

http://oss.sgi.com/archives/xfs/2007-10/msg00054.html

All it needs is reviewing and then xfs_reno for linux is done.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
