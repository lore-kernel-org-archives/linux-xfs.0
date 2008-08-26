Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 18:59:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7Q1xhiR012950
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 18:59:47 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 119DF3CD562
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 19:01:06 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id NBTMVWAWeRhna07t for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 19:01:06 -0700 (PDT)
Date: Tue, 26 Aug 2008 12:01:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs fix backport for 2.6.16.y
Message-ID: <20080826020101.GU5706@disturbed>
References: <20080825153931.GD7575@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825153931.GD7575@coraid.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ed Cashin <ecashin@coraid.com>
Cc: xfs@oss.sgi.com, Adrian Bunk <bunk@kernel.org>

On Mon, Aug 25, 2008 at 11:39:31AM -0400, Ed Cashin wrote:
> Dave Chinner, hello.
> 
> Your fix for the counters that had been preventing an XFS from growing
> by more than two terabytes went into 2.6.21, after the introduction of
> the per-cpu in-core superblock counters.  The per-cpu in-core
> superblock counters are not in the latest version of the long-lived
> stable kernel 2.6.16.y, maintained by Adrian Bunk.
> 
> The problem with growing by more than two terabytes appears to be
> there, though.  The 2.6.16.62 kernel will not allow me to grow an XFS
> by, e.g., 10 terabytes, so xfs_growfs does not report any change in
> the data blocks.
> 
> I backported your fix,
> 
>     commit 20f4ebf2bf2f57c1a9abb3655391336cc90314b3
>     Author: David Chinner <dgc@sgi.com>
>     Date:   Sat Feb 10 18:36:10 2007 +1100
>     
>         [XFS] Make growfs work for amounts greater than 2TB
>         
>         The free block modification code has a 32bit interface, limiting the size
>         the filesystem can be grown even on 64 bit machines. On 32 bit machines,
>         there are other 32bit variables in transaction structures and interfaces
>         that need to be expanded to allow this to work.
>         
>         SGI-PV: 959978
>         SGI-Modid: xfs-linux-melb:xfs-kern:27894a
>         
>         Signed-off-by: David Chinner <dgc@sgi.com>
>         Signed-off-by: Christoph Hellwig <hch@infradead.org>
>         Signed-off-by: Tim Shimmin <tes@sgi.com>
> 
> ... to the 2.6.16.y git tree, and the result is included below.  When
> I apply this backported fix to 2.6.16.62, I can grow an online XFS by
> 10 terabytes without any trouble.
> 
> Do you see any problems with this backport?  If not, I will submit it
> for inclusion in the next 2.6.16.y release.

I suggest you make sure it passes test 078 in the xfsqa suite (part
of the xfs-cmds tree) as that tests all the nasty growfs corner
cases. You'll need to test it on 32 bit and 64 bit machines....

If it passes that then I don't see any problems - SGI backported
this for sles10 which is based on 2.6.16 a long time ago.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
