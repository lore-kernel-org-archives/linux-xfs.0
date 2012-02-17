Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HBpven078323 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 05:51:57 -0600
Received: from extern.innogames.de (extern.innogames.de [80.252.99.240]) by
	cuda.sgi.com with ESMTP id fHHef9XO0ctjwR3n for
	<xfs@oss.sgi.com>; Fri, 17 Feb 2012 03:51:55 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by extern.innogames.de (Postfix) with ESMTP id 275D76040F5
	for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 12:51:55 +0100 (CET)
Received: from extern.innogames.de ([127.0.0.1])
	by localhost (extern.innogames.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zbSPFqESK2jY for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 12:51:55 +0100 (CET)
Received: from [172.16.5.29] (unknown [212.48.107.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by extern.innogames.de (Postfix) with ESMTPSA id 072376040F4
	for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 12:51:55 +0100 (CET)
Message-ID: <4F3E3F5A.9000202@innogames.de>
Date: Fri, 17 Feb 2012 12:51:54 +0100
From: Bernhard Schrader <bernhard.schrader@innogames.de>
MIME-Version: 1.0
Subject: Problems with filesizes on different Kernels
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

we just discovered a problem, which I think is related to XFS. Well, I 
will try to explain.

The environment i am working with are around 300 Postgres databases in 
separated VM's. All are running with XFS. Differences are just in kernel 
versions.
- 2.6.18
- 2.6.39
- 3.1.4

Some days ago i discovered that the file nodes of my postgresql tables 
have strange sizes. They are located in 
/var/lib/postgresql/9.0/main/base/[databaseid]/
If I execute the following commands i get results like this:

Command: du -sh | tr "\n" " "; du --apparent-size -h
Result: 6.6G	. 5.7G	.

Well, as you can see there is something wrong. The files consume more 
Diskspace than they originally would do. This happens only on 2.6.39 and 
3.1.4 servers. the old 2.6.18 has normal behavior and the sizes are the 
same for both commands.

The following was done on a 3.1.4 kernel.
To get some more informations i played a little bit with the xfs tools:

First i choose one file to examine:
##########
/var/lib/postgresql/9.0/main/base/43169# ls -lh 64121
-rw------- 1 postgres postgres 58M 2012-02-16 17:03 64121

/var/lib/postgresql/9.0/main/base/43169# du -sh 64121
89M    64121
##########

So this file "64121" has a difference of 31MB.

##########
/var/lib/postgresql/9.0/main/base/43169# xfs_bmap  64121
64121:
     0: [0..116991]: 17328672..17445663

/var/lib/postgresql/9.0/main/base/43169# xfs_fsr -v 64121
64121
64121 already fully defragmented.

/var/lib/postgresql/9.0/main/base/43169# xfs_info /dev/xvda1
meta-data=/dev/root              isize=256    agcount=4, agsize=959932 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3839727, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=2560, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

/var/lib/postgresql/9.0/main/base/43169# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / xfs rw,noatime,nodiratime,attr2,delaylog,nobarrier,noquota 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=755 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
devpts /dev/pts devpts 
rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
#########

I sent the following also to postgres mailinglist but i think this is 
now useful too.

Strange, or  not? Regarding this informations, the file is contiguous on 
disk and has of course no fragmentation, so why is it showing so much 
diskusage?

The relation this filenode is belonging to, is an index, and regarding 
my last overview it seems that this happens for 95% only to indexes/pkeys.

Well you could think i have some strange config settings, but we 
distribute this config via puppet, and also the servers on old hardware 
have this config. so things like fillfactor couldn't explain this.

We also thought that there could be some filehandles still exist. So we 
decided to reboot. Wow, we thought we got it, the free diskspace 
increased slowly for a while. But then, after 1-2GB captured diskspace 
it went back to normal and the filenodes grew again. This doesn't 
explain it as well. :/

One more thing, a xfs_fsr /dev/xvda1 recaptures also some diskspace, but 
with same effect as a reboot.


Some differences on 2.6.18 are the mount options and the lazy-count:
###########
xfs_info /dev/xvda1
meta-data=/dev/root              isize=256    agcount=4, agsize=959996 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3839983, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=2560, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / xfs rw,noatime,nodiratime 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid 0 0
proc /proc proc rw,nosuid,nodev,noexec 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec 0 0
#############

I don't know what causes this problem, and why we are the only ones who 
discovered this. I don't know if it's really 100% related to xfs but for 
now i don't have other ideas. If you need anymore information I will 
provide.

Thanks in advance
Bernhard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
