Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08BB87F69
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 17:18:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98B56AC002
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 15:18:52 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sokQFHL3Cmk449VV for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 15:18:50 -0700 (PDT)
Date: Fri, 10 Apr 2015 08:18:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: interesting MD-xfs bug
Message-ID: <20150409221846.GG13731@dastard>
References: <5526E8E9.3030805@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5526E8E9.3030805@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
> If I build an MD raid0 with a non power of 2 chunk size, it appears
> that I can mkfs.xfs a file system, but it doesn't show up in blkid
> and is not mountable.  Yet, using a power of 2 chunk size, this does
> work correctly.   This is kernel 3.18.9.
> 
> 
> For example, non-power of 2 chunk:
> 
> root@unison:~# wipefs -a /dev/sdb
> 4 bytes were erased at offset 0x1000 (linux_raid_member)
> they were: fc 4e 2b a9
> root@unison:~# wipefs -a /dev/sda
> 4 bytes were erased at offset 0x1000 (linux_raid_member)
> they were: fc 4e 2b a9
> root@unison:~# mdadm --create /dev/md20 --level=0 --metadata=1.2
> --chunk=1152 --auto=yes --raid-disks=2 /dev/sd[ab]
> mdadm: array /dev/md20 started.
> 
> root@unison:~# mkfs.xfs /dev/md20
> log stripe unit (1179648 bytes) is too large (maximum is 256KiB)
> log stripe unit adjusted to 32KiB
> meta-data=/dev/md20              isize=256    agcount=50,
> agsize=268435296 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=13164865984, imaxpct=5
>          =                       sunit=288    swidth=576 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> root@unison:~# blkid | grep xfs

That looks more like a blkid or udev problem. try using blkid -p so
that it doesn't look up the cache but directly probes devices for
the signatures. strace might tell you a bit more, too. And if the
filesystem mounts, then it definitely isn't an XFS problem ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
