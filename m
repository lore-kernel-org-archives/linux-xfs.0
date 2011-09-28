Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S1ARZi076610 for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 20:10:27 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83A931C4BF5A
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 18:10:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zXKexvJUVGarrB7S for <xfs@oss.sgi.com>;
	Tue, 27 Sep 2011 18:10:24 -0700 (PDT)
Date: Wed, 28 Sep 2011 11:10:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 64-bit inodes and back again
Message-ID: <20110928011020.GE3159@dastard>
References: <4E825C25.6050804@cchtml.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E825C25.6050804@cchtml.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Cronenworth <mike@cchtml.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 27, 2011 at 06:28:37PM -0500, Michael Cronenworth wrote:
> Hello,
> 
> I enabled 64-bit inodes on a 2.6.35.14 kernel system. I ran into
> some software that did not handle this well, so I wanted to go back
> to 32-bit inodes. When I booted into the system again, any files
> that were created while in 64-bit inode mode are inaccessable and
> are shown to me like this:
> 
> $ ls -l /var/lib/mock/
> ls: cannot access /var/lib/mock/dist-5E-build-373-1401: Invalid argument
> ??????????? ? ?    ?     ?            ? dist-5E-build-373-1401
> 
> I was led[1] to believe that this would not cause problems, but it has.

I'm pretty sure this was fixed in 2.6.37. There's nothing wrong with
the filesystem, just the kernel code had an arbitrary restriction on
where inodes code be read from in 32-bit inode mode. That was
removed in commit d276734 ("xfs: fix bogus m_maxagi check in
xfs_iget").

> I have run xfs_repair on the file system but the old files still remain.
> 
> Are there any other things I can do to fix this? One thought is to
> remount with 64-bit inodes and erase or copy the offending files,
> but is that my only option?

xfs_reno is a tool designed to move all 64 bit inodes back into the
32 bit inode space again.

http://xfs.org/index.php/Unfinished_work#The_xfs_reno_tool

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
