Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p12MGYs0071252 for <xfs@oss.sgi.com>; Wed, 2 Feb 2011 16:16:35 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D3DB120DF45
	for <xfs@oss.sgi.com>; Wed,  2 Feb 2011 14:19:00 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PaFBLB6eikY4lMKn for <xfs@oss.sgi.com>;
	Wed, 02 Feb 2011 14:19:00 -0800 (PST)
Date: Thu, 3 Feb 2011 09:18:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS stat/statvfs problems with 2.6.38-rc2-00175-g6fb1b30
Message-ID: <20110202221858.GS11040@dastard>
References: <20110202023644.GA25214@hexapodia.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110202023644.GA25214@hexapodia.org>
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
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 01, 2011 at 06:36:44PM -0800, Andy Isaacson wrote:
> Since updating past 2.6.37, I'm seeing du(1) sometimes report files
> taking up 8GB even though ls(1) reports the correct size (hundreds of
> bytes).  At the same time, df reports that the filesystem is 95% or 100%
> full (although I can still write to the filesystem).  Repeated du calls
> show persistent results (once st_blocks is wrong, it stays wrong).
> Rebooting clears the problem for a few hours, then it seems to come
> back, although the exact files affected seems to change.  xfs_check
> doesn't find any errors, and rebooting into 2.6.37 clears up the problem
> entirely.
> 
> There's nothing in dmesg indicating a problem:
> 
> Jan 27 08:04:37 pyron kernel: [    0.000000] Linux version 2.6.38-rc2-00175-g6fb1b30 (adi@pyron) (gcc version 4.4.5 (Debian 4.4.5-10) ) #75 SMP Thu Jan 27 00:39:11 PST 2011
> Jan 27 08:04:37 pyron kernel: [    8.420170] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> Jan 27 08:04:37 pyron kernel: [    8.434527] XFS mounting filesystem dm-8
> Jan 27 08:04:37 pyron kernel: [    8.676644] Starting XFS recovery on filesystem: dm-8 (logdev: internal)
> Jan 27 08:04:37 pyron kernel: [    8.734279] Ending XFS recovery on filesystem: dm-8 (logdev: internal)
> Jan 27 08:04:37 pyron kernel: [    8.762724] XFS mounting filesystem dm-9
> Jan 27 08:04:37 pyron kernel: [    8.957986] Ending clean XFS mount for filesystem: dm-9
> Jan 27 08:04:37 pyron kernel: [    8.985909] XFS mounting filesystem dm-10
> Jan 27 08:04:37 pyron kernel: [    9.098404] Starting XFS recovery on filesystem: dm-10 (logdev: internal)
> Jan 27 08:04:37 pyron kernel: [    9.205018] Ending XFS recovery on filesystem: dm-10 (logdev: internal)
> 
> 
> /d1 is a 200GB XFS on DM on AHCI SATA on a Core i7 desktop board.
> The erroneous statvfs reports are visible in this munin graph:
> http://web.hexapodia.org/~adi/tmp/20110201-df-pyron.png
> (the filesystem is actually 72% full currently, and should be linearly
> filling as is visible around Jan 26.)

It'll be the excessive specualtive preallocation bug introduced in
.38-rc1  which is fixed in .38-rc3.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
