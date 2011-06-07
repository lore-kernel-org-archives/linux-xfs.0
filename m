Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57Gbj0p037071 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 11:37:45 -0500
Received: from pyre.virge.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27EA31E412E6
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 09:37:43 -0700 (PDT)
Received: from pyre.virge.net (24-246-28-70.cable.teksavvy.com [24.246.28.70])
	by cuda.sgi.com with ESMTP id myEIUngmZmRv0Bmy for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2011 09:37:43 -0700 (PDT)
Date: Tue, 7 Jun 2011 12:37:42 -0400
From: Norbert Veber <nveber@pyre.virge.net>
Subject: Small files perform much faster on newly formatted fs?
Message-ID: <20110607163742.GH28625@pyre.virge.net>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi,

I have some xfs filesystems on my computer running linux.  These were
created (formatted) about 2 years ago on debian 5.0 on software raid
5+lvm.  I am getting pretty terible performance with small files, and
decided to try to optimize that a bit with some mount options etc.

I also created a new filesystem to try different mkfs options.  This was
done on the same computer which has since been upgraded to debian 6.0.

I found a very suprising thing.  The new filesystem performed an order
of magnitude faster than the 2 year old filessytem which has made with
an older kernel and older mkfs.xfs (from debian 5.0).

For a simple test I tried to time the untar and rm -rf on the linux
2.6.32 source tree.  Its not very scientific but I get pretty consistent
results.  Old 20gb filessystem:

pyre:/shared# xfs_info /shared
meta-data=/dev/mapper/vg0-shared isize=256    agcount=9, agsize=610304
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=5062656, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

Since sunit and swidth wasnt automatically set by the old debian 5 mkfs
time, I use the mount options isntead:

nveber@pyre[6788:~/files/doc]$ mount | grep shared
/dev/mapper/vg0-newshared on /mnt/tmp type xfs (rw)
/dev/mapper/vg0-shared on /shared type xfs (rw,sunit=128,swidth=256)

Now for the "benchmark":
pyre:/shared# sync;sleep 15s;time ionice -c1 tar -zxf linux-2.6_2.6.32.orig.tar.gz

real	3m6.842s
user	0m3.800s
sys	0m2.692s

New 30gb filesystem:
pyre:/shared# xfs_info /mnt/tmp
meta-data=/dev/mapper/vg0-newshared isize=256    agcount=16,
agsize=491504 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=7864064, imaxpct=25
         =                       sunit=16     swidth=32 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=3840, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

pyre:/mnt/tmp# sync;sleep 15s;time ionice -c1 tar -zxf
linux-2.6_2.6.32.orig.tar.gz

real	0m19.851s
user	0m3.828s
sys	0m2.184s

20 seconds vs 3+ minutes?!  The only difference I can see is
lazy-count=1 and a larger agcount.  Sunit and swidth were also set
automatically by mkfs this time.  I tried the lazy-count option for the
old fs:
pyre:~# umount /shared
pyre:~# xfs_admin -c1 /dev/vg0/shared
Enabling lazy-counters
pyre:~# mount /shared
pyre:/shared# mv linux-2.6-2.6.32/ deleteme
pyre:/shared# sync;sleep 15s;time ionice -c1 tar -zxf linux-2.6_2.6.32.orig.tar.gz

real	2m37.634s
user	0m3.800s
sys	0m2.612s

Its a little faster now, but still way slower than the new fs.  Whats
the difference, and how can I make the old one perform at this level
short of reformatting? :)

Thanks,

Norbert

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
