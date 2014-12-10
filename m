Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE68A7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 14:32:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D4A88F8035
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 12:32:36 -0800 (PST)
Received: from mail-qg0-f52.google.com (mail-qg0-f52.google.com
	[209.85.192.52]) by cuda.sgi.com with ESMTP id HCHA255iLKzKnhh6
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Dec 2014 12:32:35 -0800 (PST)
Received: by mail-qg0-f52.google.com with SMTP id a108so2687257qge.39
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 12:32:34 -0800 (PST)
Message-ID: <5488ADDD.404@gmail.com>
Date: Wed, 10 Dec 2014 15:32:29 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_quota off/remove
References: <8688BD11DAC0574AA90295127E9E9F4AC04DD4FF@exchangewes8.wesad.wesleyan.edu>
In-Reply-To: <8688BD11DAC0574AA90295127E9E9F4AC04DD4FF@exchangewes8.wesad.wesleyan.edu>
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
To: "Meij, Henk" <hmeij@wesleyan.edu>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/10/14 13:37, Meij, Henk wrote:
> Is off/remove working for xfs_quota? I seem to not be able to zero
> out the project quota metadata and move the project to another
> partition. I did not remove the entries in the /etc/proj* files.
> 
> 
> 
> -Henk
> 
> 
> 
>  1308  xfs_quota -x -c 'project -s data_1_hmeij'
>  1309  xfs_quota -x -c 'report -h -bi' /data/1
> 
> 
> 
> User quota on /data/1 (/dev/sdb1)
>                         Blocks
> User ID      Used   Soft   Hard Warn/Grace
> ---------- ---------------------------------
> root            0      0      0  00 [------]
> hmeij      854.4M      0      0  00 [------]
> 
> Project quota on /data/1 (/dev/sdb1)
>                         Blocks
> Project ID   Used   Soft   Hard Warn/Grace
> ---------- ---------------------------------
> data_1_hmeij 854.4M      0      0  00 [------]
> 
> 
> 
>  1318  xfs_quota -x -c 'off' -c 'remove' /data/1
> 
>  1331  umount /data/1; mount /data1
> 
> 
> 
>  1333  xfs_quota -x -c 'report -h' /data/1
> 
> 
> 
> same report output, same metadata ...

As an XFS user: Add me in on this thread?

On one hand, the man page for xfs_quota states for "off":  "Permanently
switches quota off for the filesystem identified by the current path.
Quota can only be switched back on subsequently by unmounting and then
mounting again."

It's confusing when permanent is not really permanent.  However,
mounting without quotas leaves the quotas off.  The xfs_quota "state"
command was helpful in showing the actual state of accounting and
enforcement.  Also, to mount without uquota or without pquota still 
disables uquota and pquota independently.

I take it that project quotas have much to do with the attributes set 
on the a projid directory and files created within it.

# Switching to add a secondary issue hit while trying to duplicate 
# your issue...feel free to ask me to get my own thread.  Just wanted 
# to record that here is where I hit an issue.

On the other hand, for me to use the xfs_quota "off -p" command with
even one file with project quota, the v4 filesystem here at work becomes
impossible to unmount.  When only the containing directory for the
project quota has zero files in it, the command works just fine.  CPU 
usage for xfs_quota doesn't go over 2% while it is hanging.

A forced crash (yikes!) yields nothing but input-related stack and the 
KMS console not switching back to VGA.

Quotas haven't been touched on this box in a while, and they were set up
maybe 3-4 years ago.

An upgrade to the newest everything from git did not make things 
better, though I'm keeping it because the previous git version worked 
really well, other than for me wondering about xfs_quota.

I'll try to get more from my testing boxes at home.

Thanks!

Michael

# Backing info:

# scripts/ver_linux from kernel source:

# PC started out running Slackware 14, but it's been upgraded from 
# mostly-official source in a lot of places.

Linux ________ 3.10.62 #1 Sun Dec 7 19:13:27 EST 2014 i686 Intel(R) Pentium(R) 4 CPU 2.80GHz GenuineIntel GNU/Linux
 
Gnu C                  4.8.3
Gnu make               3.82
binutils               2.24.51.0.3.20140127
util-linux             2.21.2
mount                  support
module-init-tools      9
e2fsprogs              1.42.8
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.2.2
pcmciautils            017
quota-tools            3.17.
PPP                    2.4.5
Linux C Library        2.20
Dynamic linker (ldd)   2.20
Linux C++ Library      6.0.19
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.3
oprofile               0.9.7
Sh-utils               8.21

# xfs_info:

meta-data=/dev/sda8              isize=256    agcount=4, agsize=6160384 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=24641536, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=12032, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# info from "mount" for this partition:

/dev/sda8 on /storage type xfs (rw,uquota,pquota)

# /proc/partitions

major minor  #blocks  name

   8        0  156290904 sda
   8        1    4200966 sda1
   8        2          1 sda2
   8        5    1048576 sda5
   8        6   12582912 sda6
   8        7   24600689 sda7
   8        8   98566144 sda8
   8        9   10485760 sda9
   8       10    2097152 sda10
   8       11    1349296 sda11
   8       12    1347936 sda12
   8       16   39062500 sdb
   8       17   10485760 sdb1
   8       18     524288 sdb2
   8       19    1048576 sdb3
   8       20   27002835 sdb4
  11        0    1048575 sr0
  11        1    1048575 sr1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
