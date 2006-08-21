Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Aug 2006 23:16:42 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7L6GMDW021190
	for <xfs@oss.sgi.com>; Sun, 20 Aug 2006 23:16:26 -0700
Received: from agami.com ([192.168.168.133])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k7L6FjwI024137
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 20 Aug 2006 23:15:50 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k7L6FeNv021152
	for <xfs@oss.sgi.com>; Sun, 20 Aug 2006 23:15:40 -0700
Message-ID: <44E94F90.1010606@agami.com>
Date: Mon, 21 Aug 2006 11:45:44 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: Differences in su/sw values for hw vs. sw RAID 5?
References: <082120060155.2003.44E912A400010D0F000007D322058864429C07900E0B079D0D@comcast.net>
In-Reply-To: <082120060155.2003.44E912A400010D0F000007D322058864429C07900E0B079D0D@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: bridavis@comcast.net, xfs@oss.sgi.com

For RAID-5 device, for any write, the parity as well has to be 
calculated before writing. In absence of any column of RAID, it is read 
from disk and then re-written. When you choose writes such as all 
columns are already there, parity can be directly calculated and written 
(without incurring any extra read I/O) and that's why, declaring in that 
form is desirable. Someone correct me if I am wrong.

# mdadm --create /dev/md15 --level=5 --raid-devices=3 -c 64 /dev/sd[hvi]1
mdadm: array /dev/md15 started.

When forced choice of sw=1,su=128k
# cat /proc/mdstat | more
...
md15 : active raid5 sdv1[2] sdi1[1] sdh1[0]
       78139904 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
# mkfs.xfs -f -d sw=1,su=128k /dev/md15
mkfs.xfs: Specified data stripe unit 256 is not the same as the volume 
stripe unit 128
meta-data=/dev/md15              isize=256    agcount=16, agsize=1220928 
blks
          =                       sectsz=512
data     =                       bsize=4096   blocks=19534848, imaxpct=25
          =                       sunit=32     swidth=32 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=9568, version=1
          =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=131072 blocks=0, rtextents=0

Though by default, it detects the former one.

# mkfs.xfs -f /dev/md15
meta-data=/dev/md15              isize=256    agcount=16, agsize=1220944 
blks
          =                       sectsz=512
data     =                       bsize=4096   blocks=19534976, imaxpct=25
          =                       sunit=16     swidth=32 blks, unwritten=1
naming   =version 2              bsize=4096

Please note that default created here is: sunit=16, swidth=3
bridavis@comcast.net wrote:
> I getting conflicting reports as to how I should generate my sunit/swidth vaules for hardware RAID 5.
> 
> Setup: hardware RAID 5, 3 disks at 300 GBs each, 64k stripe size.
> 
> Originally, following the man page and the mailing list archives, I came up sw=2,su=64k. 
> 
> However, I read a reply to an earlier question I sent to the list, and it indicated that the hardward RAID should be treated as a single disk, so I came up with sw=1,su=128k.
> 
> Which one is correct for my setup?
> 
> Thanks!
> 
> [[HTML alternate version deleted]]
> 
> 
