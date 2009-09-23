Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8NLBMMM035890 for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 16:11:22 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADBF9477B8B
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 14:12:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lzMhLDUP3lxdApAv for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2009 14:12:40 -0700 (PDT)
Message-ID: <4ABA8F45.1060004@sandeen.net>
Date: Wed, 23 Sep 2009 16:12:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: problems with xfs_growfs after lvextend
References: <4ABA8D56.2040101@phy.duke.edu>
In-Reply-To: <4ABA8D56.2040101@phy.duke.edu>
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
To: Jimmy Dorff <jdorff@phy.duke.edu>
Cc: xfs@oss.sgi.com

Jimmy Dorff wrote:
> Hello,
> 
> I'm having a problem with a corrupt xfs filesystem after attempting to 
> grow the filesystem.
> 
> The problem is very similar to this post:
> http://www.redhat.com/archives/linux-lvm/2005-November/msg00026.html
> Except that xfs_repair never finds a secondary superblock.
> 
> Details:
> CentOS Linux,
> kernel 2.6.18-128.1.16.el5.centos.plus x86_64
> lvm2-2.02.40-6.el5
> originally: xfsprogs-2.9.4-1.el5.centos.x86_64

> This sever has been up and running for a few months w/o problems. Today 
> we added some disks to a 3ware controller. The disks were all tested 
> individually before installation.
> 
> Used "tw_cli" to configure a new RAID volume, which appeared in Linux as 
> normal (/dev/sdd).
> 
> # pvcreate /dev/sdd
> # vgextend array_vg /dev/sdd
> # lvextend /dev/array_vg/data --size +12T

that centos kernel had a bug where growing more than 2T (I Think ...) at
a time overflowed.  So for +12T you probably hit it.

That's probably your bug, and cattelan on this list has helped people
recover from it before, I'd suggest not trying to "fix" anything just
yet (don't force repair, etc).

It's fixed in the RHEL5.4 xfs code from RH, FWIW.

-Eric


> 
> This all worked w/o any errors. vgdisplay and lvdisplay all report the 
> correct info and sizes.
> 
> The 6TB xfs filesystem on /dev/array_vg/data was mounted as "/srv/data"
> # xfs_growfs /srv/data
> 
> The size of the filesystem didn't change. I unmounted it and tried 
> again, but no change. However, now I can't mount the filesystem at all.
> 
> xfs_check causes xfs_db to use so much memory as to hang up the system.
> xfs_repair reports:
> Phase 1 - find and verify superblock...
> superblock read failed, offset 19791209299968, size 2048, ag 96, rval 0
> 
> fatal error -- Invalid argument
> 
> Also, I've noticed this in syslog:
> kernel: attempt to access beyond end of device
> kernel: dm-1: rw=0, want=64424509440, limit=38654705664
> kernel: I/O error in filesystem ("dm-1") meta-data dev dm-1 block 
> 0xeffffffff       ("xfs_read_buf") error 5 buf count 512
> kernel: XFS: size check 2 failed
> 
> 
> I've trying using xfs_repair from xfsprogs 3.0.3, but it made no 
> difference.
> 
> Any suggestions ? Any help understanding why this didn't work ?
> 
> 
> Thanks,
> Jimmy Dorff
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
