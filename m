Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jul 2008 01:16:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6G8GqLu014550
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 01:16:53 -0700
Received: from rsbne02.RSBNE.LOCAL (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13ED612E59D9
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 01:17:59 -0700 (PDT)
Received: from rsbne02.RSBNE.LOCAL (robert87.lnk.telstra.net [203.45.17.90]) by cuda.sgi.com with ESMTP id dFwQ3o9mJBpHubVp for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 01:17:59 -0700 (PDT)
MIME-Version: 1.0
Subject: RE: Power loss causes bad magic number??
Date: Wed, 16 Jul 2008 18:17:37 +1000
Message-ID: <F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL>
References: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL> <487D5F80.1050909@sandeen.net> <F46A887185FC6044A7FAC577E31118AE021E0623@rsbne01.RSBNE.LOCAL> <20080716073503.GE29319@disturbed>
From: "Stephen Porter" <stephenp@r-s.com.au>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, sandeen@sandeen.net




-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com]

> That looks like a boot loader.

That's what I thought, but again, this isn't a boot volume, could running xfs_repair without the -n have done this?

> And at 0x200 I'd expect to see an AGF header, not zeros. To
> me, that says that either XFS is inside a partition on the drive
> or someone ran a partitioning tool on /dev/sdc and overwrote the
> XFS filesystem headers...

relevant line from /etc/fstab:

/dev/sdc	/home/username/Data	xfs	defaults	0	2

the raid management tool is reporting everythings ok... any idea what could have caused this?  

....

Ok, my apologies, I've just done an ls of /dev/sd* and the devices have been remapped (any idea what would have caused that?), sdc is no longer sdc, it is now sda, the boot devices are now detected as sdb and sdc (2 mirrored physical disks, used to be sda and sdb).  How was the machine able to boot?  I'm more confused than ever now, but the data is all there.

Sorry for wasting everyones time.

Regards,

Stephen.




[[HTML alternate version deleted]]
