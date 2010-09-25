Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8P2HamN211034 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 21:17:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 881061BFD8E8
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 19:18:30 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	DrnQ4qjwdUsfreNY for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 19:18:30 -0700 (PDT)
Date: Sat, 25 Sep 2010 12:18:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: No space left on device
Message-ID: <20100925021826.GU2614@dastard>
References: <A7468B16-5A58-4012-B38B-784D89566D86@bayour.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <A7468B16-5A58-4012-B38B-784D89566D86@bayour.com>
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
To: Turbo Fredriksson <turbo@bayour.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 24, 2010 at 04:07:23PM +0200, Turbo Fredriksson wrote:
> I started with a few hundred gig on my FS
> (on top of LVM which in turn is on top a bunch
> of MD devices).
> 
> Slowly increasing the size with pvmove/{vg,lv}extend
> etc. Yesterday, I added more disks yet again and
> now have about 8Tb on one FS... ~1Tb free. But still
> get the 'No space left on device'.
> 
> 
> I've been looking through the 'Net and it
> must be because I'm out of inodes (and that
> the data is on the first 1Tb etc)...
> 
> I'm running on AMD 64bit (native kernel, but
> Debian Lenny 32bit userland - 2.6.2[4-6] kernel).
....
> The worst thing is that every time I grow
> the FS, I have to reboot into a 32bit kernel:
> 
> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument

The compat ioctl handlers for 32bit userspace to 64 bit kernel we
not included until a later kernel. Either upgrade to a 64 bit
userspace or to a much more recent kernel, and the problem will go
away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
