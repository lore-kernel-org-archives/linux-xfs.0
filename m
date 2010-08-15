Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7F0qI3s167569 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 19:52:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 886DE4BD283
	for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 17:52:44 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	DEHqdYdqVPnEQsPF for <xfs@oss.sgi.com>;
	Sat, 14 Aug 2010 17:52:44 -0700 (PDT)
Date: Sun, 15 Aug 2010 10:52:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs.fsck change that is unhelpful
Message-ID: <20100815005240.GH10429@dastard>
References: <4C670101.8050901@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C670101.8050901@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Aug 14, 2010 at 01:48:01PM -0700, Linda A. Walsh wrote:
> 
> Some time ago, when I upgraded a system, I ran into problems when
> it hit a file system that was offline.  It wasn't a critical
> partition, so it normally wouldn't have been an issue, but somewhere
> along the line
> someone mangled fsck.xfs.

fsck.xfs is behaving identically to e2fsck when presented with an
invalid block device - it exits with an error of 8, which is defined
as "operational error" in the e2fsck man page.

> Instead of doing the useful thing with an xfs file system and being a
> link to ->/bin/true, someone thought it would be neat to return failure if
> it couldn't find the file system that it was supposed to check

If the device is not present when the bootup sequence is attempting
to access it, then you've got a configuration error somewhere. It
should return an error.

> (mount-by-name, name not yet present, => system refuse to boot).

That sounds like a problem with the distro init scripts or you've
stuffed up your /etc/fstab config (i.e. fs_passno is wrong). Indeed,
setting fs_passno = 0 will cause the filesysetm fsck to be skipped
completely on boot, regardless of the fs type...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
