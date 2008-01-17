Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 14:44:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0HMiJOS022764
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 14:44:25 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41B88530A41
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 14:44:37 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id KFzvBJk4gLaWQV4K for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 14:44:37 -0800 (PST)
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <478FD48F.1060707@sandeen.net>
References: 
	 <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local>
	 <478FA832.7030200@sandeen.net>
	 <9CE70E6ED2C2F64FB5537A2973FA4F02535954@pvn-3001.purevideo.local>
	 <478FD48F.1060707@sandeen.net>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 09:47:34 +1100
Message-Id: <1200610054.9463.218.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mark Magpayo <mmagpayo@purevideo.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Thu, 2008-01-17 at 16:19 -0600, Eric Sandeen wrote:
> 
> Yep, in 1k units, so:
> 
> 19046932480*1024
> 19504058859520
> 
> and:
> 
> superblock read failed, offset 19504058859520, size 2048, ag 64, rval
> 0
> 
> so it's trying to read a 2k (?) superblock right in the last 1k of the
> device?  Hrm.  (Dave, Barry - isn't that 2048 the sector size, not
> block
> size?)
> 
> Also from your sb 0 printout:
> 
> blocksize = 4096
> dblocks = 11904332800

sectsize = 512
sectlog = 9

So, SB reckons its a regular 512 byte sector size.  Perhaps the device
driver is reporting a 2K sector size from the BLKSSZGET ioctl?  That'd
be wierd, cos mkfs would have issued a warning when creating with 512
byte sectors.  *shrug*.

> is 48760147148800, exactly 2.5x bigger than your device is. Weird.

cheers.

-- 
Nathan
