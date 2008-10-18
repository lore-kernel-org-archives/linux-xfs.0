Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 01:56:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9I8uWhO022206
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 01:56:33 -0700
Received: from sorrow.cyrius.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E898A511478
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 01:58:15 -0700 (PDT)
Received: from sorrow.cyrius.com (sorrow.cyrius.com [65.19.161.204]) by cuda.sgi.com with ESMTP id EWm381fpNkv1IfLv for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 01:58:15 -0700 (PDT)
Date: Sat, 18 Oct 2008 10:57:56 +0200
From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081018085752.GS25834@deprecation.cyrius.com>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F89E0F.6030307@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

* Eric Sandeen <sandeen@sandeen.net> [2008-10-17 09:15]:
> If you unmount & remount, does the ls work then?

I cannot even mount it:

debian:~# mkfs.xfs -f /dev/sda5
meta-data=/dev/sda5              isize=256    agcount=4, agsize=94380 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=377519, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
debian:~# mount /dev/sda5 /mnt
[42949596.920000] XFS mounting filesystem sda5
debian:~# cp /usr/bin/* /mnt/
debian:~# umount /mnt
debian:~# mount -t xfs /dev/sda5 /mnt
[42949612.290000] XFS mounting filesystem sda5
[42949612.460000] Starting XFS recovery on filesystem: sda5 (logdev: internal)
[42949612.480000] XFS: xlog_recover_process_data: bad flag
[42949612.500000] XFS: log mount/recovery failed: error 5
[42949612.500000] XFS: log mount failed
mount: /dev/sda5: can't read superblock
debian:~#

> Do you know what cachepolicy you're booted with?  If it's writeallocate,
> you might try cachepolicy=writeback, otherwise try cachepolicy=uncached
> (which will be horribly slow) and see if the problem goes away or not;
> it'd be a clue.

I just tried with cachepolicy=writeback and cachepolicy=uncached but I
get the same problem.
-- 
Martin Michlmayr
http://www.cyrius.com/
