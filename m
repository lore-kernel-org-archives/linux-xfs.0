Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 22:11:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9J5BFAB028274
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 22:11:15 -0700
Received: from sorrow.cyrius.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6F33515701
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 22:12:58 -0700 (PDT)
Received: from sorrow.cyrius.com (sorrow.cyrius.com [65.19.161.204]) by cuda.sgi.com with ESMTP id 4J8rvYGzQ45vjoB1 for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 22:12:58 -0700 (PDT)
Date: Sun, 19 Oct 2008 07:12:47 +0200
From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081019051247.GD9598@deprecation.cyrius.com>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net> <20081018085752.GS25834@deprecation.cyrius.com> <20081019014830.GI31761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081019014830.GI31761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

* Dave Chinner <david@fromorbit.com> [2008-10-19 12:48]:
> That's the log replay indicating that there's a bad transaction
> header in the log. Very strange - it shoul dbe a clean log. What
> does xfs_logprint -t /dev/sda5 tell you about the transactions
> in the log?

mdebian:~# mkfs.xfs -f /dev/sda5
meta-data=/dev/sda5              isize=256    agcount=4, agsize=94380
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=377519,
imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks,
lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
debian:~# mount -t xfs /dev/sda5 /mnt
debian:~# cp /usr/bin/* /mnt/
debian:~# umount /mnt
debian:~# mount -t xfs /dev/sda5 /mnt
mount: /dev/sda5: can't read superblock
debian:~# xfs_logprint -t /dev/sda5
xfs_logprint:
    data device: 0x805
    log device: 0x805 daddr: 1510112 length: 20480

XFS: Log inconsistent (didn't find previous header)
XFS: empty log check failed
xfs_logprint: failed to find head and tail, error: 5
debian:~#

-- 
Martin Michlmayr
http://www.cyrius.com/
