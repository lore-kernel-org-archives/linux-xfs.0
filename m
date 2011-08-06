Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p76AZQJl159135 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 05:35:27 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC35611FCEE4
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 03:36:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GqwiPkbwdCDvKyVe for <xfs@oss.sgi.com>;
	Sat, 06 Aug 2011 03:36:29 -0700 (PDT)
Date: Sat, 6 Aug 2011 20:35:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Errors mounting xfs file system
Message-ID: <20110806103518.GD3162@dastard>
References: <CAPH64aG=uqdcyxaHQq1Phbmn-xs_rPmhJVoerKKSHG+wumGdrg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPH64aG=uqdcyxaHQq1Phbmn-xs_rPmhJVoerKKSHG+wumGdrg@mail.gmail.com>
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
To: Warrick Howieson <whowieson@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Aug 06, 2011 at 08:01:42PM +1000, Warrick Howieson wrote:
> Hi:
> 
> I have a couple of disks out of a NAS unit that I cannot mount.
> 
> They were in a Thecus N2200 NAS
> 
> When I look at the in gParted, they happily show up as xfs disks, but when I
> rty to mount them, Iget a hole bunch of errors.
> 
> Can anyone point me in the right direction on how I can mount these disks to
> get the data off them
> 
> 
> root@sysresccd /mnt % man xfs_repair
> root@sysresccd /mnt % xfs_repair -v /dev/sdb2
> xfs_repair: cannot open /dev/sdb2: Device or resource busy

That usually means the filesystem is mounted. Try unmounting it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
