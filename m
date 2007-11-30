Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Nov 2007 23:33:10 -0800 (PST)
Received: from mars.puhasoft.hu (mars.puhasoft.hu [212.108.197.33])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAU7X3Gj029677
	for <linux-xfs@oss.sgi.com>; Thu, 29 Nov 2007 23:33:06 -0800
Message-ID: <474FB90C.4060905@tsabi.hu>
Date: Fri, 30 Nov 2007 08:17:32 +0100
From: =?UTF-8?B?VMOzdGggQ3NhYmE=?= <tsabi@tsabi.hu>
MIME-Version: 1.0
Subject: Re: XFS performance problems on Linux x86_64
References: <474C8A05.3020604@e-626.net> <20071127220536.GL119954183@sgi.com> <fii8bm$6h5$1@ger.gmane.org> <20071130045808.GK119954183@sgi.com>
In-Reply-To: <20071130045808.GK119954183@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Bernd Schubert <bernd-schubert@gmx.de>, linux-xfs@oss.sgi.com

Hello list,

I tried this parameters, and got this results with bonnie++. As i think
there isnt any speedup with this parameteres, or i am doing something wrong?

tsabi



oldbck ~ # uname -a
Linux oldbck 2.6.23-gentoo-r2-uk-01 #1 SMP Tue Nov 20 03:43:04 CET 2007
x86_64 Intel(R) Xeon(TM) CPU 2.80GHz GenuineIntel GNU/Linux


test 1:

oldbck mnt # mkfs.xfs -i size=512 -f /dev/md5
meta-data=/dev/md5               isize=512    agcount=32, agsize=4513008
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=144416192, imaxpct=25
         =                       sunit=16     swidth=64 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=262144 blocks=0, rtextents=0

oldbck mnt # mount /dev/md5 /mnt/data

oldbck mnt # bonnie++ -u root -d /mnt/data
Version 1.93c       ------Sequential Output------ --Sequential Input-
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
oldbck           4G   522  99 235160  50 86692  17  1040  96 241681  22
457.9   9
Latency             15620us     205ms     119ms     100ms   50727us
79657us
Version 1.93c       ------Sequential Create------ --------Random
Create--------
oldbck              -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16 11000  77 +++++ +++ 13765  82 11977  83 +++++ +++
11049  77
Latency             66657us      49us   76936us   68300us      18us
72243us
1.93c,1.93c,oldbck,1,1196392150,4G,,522,99,235160,50,86692,17,1040,96,241681,22,457.9,9,16,,,,,11000,77,+++++,+++,13765,82,11977,83,+++++,+++,11049,77,15620us,205ms,119ms,100ms,50727us,79657us,66657us,49us,76936us,68300us,18us,72243us



test 2:

oldbck mnt # mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i
attr=2,size=512 -d agcount=4 /dev/md5
meta-data=/dev/md5               isize=512    agcount=4, agsize=36104048
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=144416192, imaxpct=25
         =                       sunit=16     swidth=64 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=262144 blocks=0, rtextents=0

oldbck mnt # mount -o logbsize=256k,nobarrier /dev/md5 /mnt/data

oldbck mnt # bonnie++ -u root -d /mnt/data
Version 1.93c       ------Sequential Output------ --Sequential Input-
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
oldbck           4G   523  99 237016  44 87202  17  1040  96 245389  22
446.5   7
Latency             15531us     184ms     133ms     105ms   11835us
85541us
Version 1.93c       ------Sequential Create------ --------Random
Create--------
oldbck              -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16 12772  77 +++++ +++ 14759  74 13499  81 +++++ +++
11617  70
Latency             86835us      56us   79869us   79967us      24us
95818us
1.93c,1.93c,oldbck,1,1196391889,4G,,523,99,237016,44,87202,17,1040,96,245389,22,446.5,7,16,,,,,12772,77,+++++,+++,14759,74,13499,81,+++++,+++,11617,70,15531us,184ms,133ms,105ms,11835us,85541us,86835us,56us,79869us,79967us,24us,95818us



test 3:

oldbck mnt # mkfs.ext3 /dev/md5
mke2fs 1.40.2 (12-Jul-2007)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
72220672 inodes, 144416192 blocks
7220809 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
4408 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000

Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 32 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
oldbck mnt # mount /dev/md5 /mnt/data
oldbck mnt #

oldbck mnt # bonnie++ -u root -d /mnt/data
Version 1.93c       ------Sequential Output------ --Sequential Input-
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
oldbck           4G   326  99 211619  80 91680  23  1341  96 237493  21
495.5   9
Latency             32953us     220ms    1599ms   62374us   59342us
472ms
Version 1.93c       ------Sequential Create------ --------Random
Create--------
oldbck              -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
+++++ +++
Latency              7677us     165us     252us   17010us      13us
243us
1.93c,1.93c,oldbck,1,1196389368,4G,,326,99,211619,80,91680,23,1341,96,237493,21,495.5,9,16,,,,,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++,32953us,220ms,1599ms,62374us,59342us,472ms,7677us,165us,252us,17010us,13us,243us




David Chinner írta:
> On Wed, Nov 28, 2007 at 12:13:57AM +0100, Bernd Schubert wrote:
>> Hello David,
>>
>> David Chinner wrote:
>>> # mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=4
>>> # <dev> mount -o logbsize=256k <dev> <mtpt>
>> thanks, I was also going to ask which are optimal parameters. Just didn't
>> have the time yet :)
>> Any idea when these options will be default? 
> 
> They should already be the defaults in the current CVS tree. ;)
> 
> Cheers,
> 
> Dave.
