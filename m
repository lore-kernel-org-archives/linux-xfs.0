Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p58IwnvR113363 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 13:58:49 -0500
Received: from pyre.virge.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF14812D5364
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 11:58:46 -0700 (PDT)
Received: from pyre.virge.net (24-246-28-70.cable.teksavvy.com [24.246.28.70])
	by cuda.sgi.com with ESMTP id 0KHFbEnA3dtIlwck for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2011 11:58:46 -0700 (PDT)
Date: Wed, 8 Jun 2011 14:58:44 -0400
From: Norbert Veber <nveber@pyre.virge.net>
Subject: Re: Small files perform much faster on newly formatted fs?
Message-ID: <20110608185844.GB28625@pyre.virge.net>
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
	<20110608122638.GQ28625@pyre.virge.net> <201106081547.38266@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201106081547.38266@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Jun 08, 2011 at 03:47:33PM +0200, Michael Monnerie wrote:
> The difference could be that your filesystem is very much aged, and the 
> free space clustered around to new files get heavily fragmented. Did you 
> run xfs_defrag often? How full is your filesystem?

Doesn't seem to be the case:
pyre:~# xfs_db -c frag -r /dev/vg0/shared 
actual 61132, ideal 60937, fragmentation factor 0.32%
(thats the old/slow filesystem)

I re-created the test filesystem to be the same size (20gb) as the
original, and copied all the same files to it, so both are now 80% full.

pyre:~# lvremove /dev/vg0/newshared
Do you really want to remove active logical volume newshared? [y/n]: y
  Logical volume "newshared" successfully removed
pyre:~# lvcreate -L 20G -n newshared vg0
  Logical volume "newshared" created

I also tried to replicate the same sunit/swidth options, but mkfs.xfs is
too smart for its own good and ignored my settings:

pyre:~# mkfs.xfs -f -d sunit=0,swidth=0 -l sunit=0 /dev/vg0/newshared
meta-data=/dev/vg0/newshared     isize=256    agcount=16, agsize=327664
blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=5242624, imaxpct=25
         =                       sunit=16     swidth=32 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=16 blks,
lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
pyre:~# mount /dev/vg0/newshared /mnt/tmp
pyre:~# cp -a /shared/* /mnt/tmp/
pyre:/# cd /mnt/tmp
pyre:/mnt/tmp# sync;sleep 15s;time ionice -c1 tar -zxf
linux-2.6_2.6.32.orig.tar.gz

real    0m21.248s
user    0m3.772s
sys     0m2.204s


> Also the log has sunit=0 against 16, maybe there's the diff.
> Are you on a newer kernel that supports delaylog? Then try that.

Yes, it could be that the mount options only set sunit/swidth for the
data section and not the journal, so metadata operations are much
slower.  I am not able to test as mkfs.xfs ignores my command line
options and sets the values even if I tell it they should be 0..

Thanks,

Norbert

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
