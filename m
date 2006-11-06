Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Nov 2006 03:33:04 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA6BWwaG027725
	for <xfs@oss.sgi.com>; Mon, 6 Nov 2006 03:32:59 -0800
Received: from server1.spsn.net (server1.spsn.net [195.234.231.102])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0BDD50CAF0
	for <xfs@oss.sgi.com>; Mon,  6 Nov 2006 03:32:10 -0800 (PST)
From: Sascha Nitsch <sgi@linuxhowtos.org>
Subject: Re: Weird performance decrease
Date: Mon, 6 Nov 2006 12:31:26 +0100
References: <200611061028.08963.sgi@linuxhowtos.org> <454F16E4.6050907@rentalia.com>
In-Reply-To: <454F16E4.6050907@rentalia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200611061231.26623.sgi@linuxhowtos.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Rubio <ruben@rentalia.com>
Cc: xfs@oss.sgi.com

On Monday 06 November 2006 12:05, you wrote:
> I have seen that there is performance problems when there is some files
> in a directory and data is being added in the files.
>
> Are the files franmented?
> Go to a directory where the files are listed, and
> xfs_bmap -v * | less
>
> Check out the results.

The files themself are not fragmentented. They only get (re)written at once.
No appends.
But a couple of the directories have extends.
Examples:

0354:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..7]:          8964012..8964019  1 (3091..3098)         8
   1: [8..15]:         9013089..9013096  1 (52168..52175)       8

00f0:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
   0: [0..7]:          80648721..80648728  9 (432..439)           8
   1: [8..15]:         80654561..80654568  9 (6272..6279)         8
   2: [16..23]:        80662073..80662080  9 (13784..13791)       8
   3: [24..31]:        80669473..80669480  9 (21184..21191)       8
   4: [32..39]:        80677185..80677192  9 (28896..28903)       8
   5: [40..47]:        80685105..80685112  9 (36816..36823)       8
   6: [48..55]:        80692545..80692552  9 (44256..44263)       8
   7: [56..63]:        80700001..80700008  9 (51712..51719)       8
   8: [64..71]:        80708272..80708279  9 (59983..59990)       8
   9: [72..79]:        80716819..80716826  9 (68530..68537)       8

some up to 123 (tested via some checks in random picked directories).
Would increasing the directory size help to avoid those extends?
I'm quite new when it comes to internal stuff of xfs, just used it "as is"
and was happy.

Sascha

> Sascha Nitsch escribió:
> > Hi,
> >
> > I'm observing a rather strange behaviour of the filesystem cache
> > algorithm.
> >
> > I have a server running the following app scenario:
> >
> > A filesystem tree with a depth of 7 directories and 4 character directory
> > names.
> > In the deepest directories are files.
> > filesize from 100 bytes to 5kb.
> > Filesystem is XFS.
> >
> > The app creates dirs in the tree and reads/writes files into the deepest
> > dirs in the tree.
> >
> > CPU: Dual Xeon 3.0 Ghz w/HT 512KB cache each, 2GB RAM, SCSI-HDD 15k RPM
> >
> > The first while, all is fine and extremely fast. After a while the buffer
> > size is about 3.5 MB
> > and cache size about 618 MB.
> > Until that moment ~445000 directories and ~106000 files have been created
> >
> > Thats where the weird behaviour starts.
> >
> > The buffer size drops to ~200 kb and cache size starts decreasing fast.
> > This results in a drastic performace drop in my app.
> > (avg. read/write times increase from 0.3ms to 4ms)
> > not a constant increase, a jumping increase. During the next while it
> > constantly gets slower (19ms and more).
> >
> > After running a while (with still reducing cache size) the buffer size
> > stays at
> > ~700kb and cache about 400 MB. Performane is terrible. Way slower than
> > starting up with no cache.
> >
> > restarting the app makes no change, neither remounting the partition.
> >
> > cmd to create the fs:
> > mkfs.xfs -b size=512 -i maxpct=0 -l version=2 -n size=16k /dev/sdc
> > mounting with
> > mount /dev/sdc /data
> >
> > I'm open for suggestion on mkfs calls, mount options and kernel tuning
> > via procfs.
> > I have a testcase to reproduce the problem. It happens after ~45 minutes.
> >
> > xfs_info /data/
> > meta-data=/data                  isize=256    agcount=16, agsize=8960921
> > blks =                       sectsz=512
> > data     =                       bsize=512    blocks=143374736, imaxpct=0
> >          =                       sunit=0      swidth=0 blks, unwritten=1
> > naming   =version 2              bsize=16384
> > log      =internal               bsize=512    blocks=65536, version=2
> >          =                       sectsz=512   sunit=0 blks
> > realtime =none                   extsz=65536  blocks=0, rtextents=0
> >
> > kernel:
> > a 2.6.9-34.0.2.ELsmp #1 SMP Mon Jul 17 21:41:41 CDT 2006 i686 i686 i386
> > GNU/Linux
> >
> > filesystem usage is < 1%
