Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oASMnOwk056236 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:49:24 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5B811C7B8E6
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 14:51:05 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id XmzYdEm3j0db3gsP
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 14:51:05 -0800 (PST)
Received: by qwe5 with SMTP id 5so3339086qwe.26
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 14:51:04 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 28 Nov 2010 22:51:04 +0000
Message-ID: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>
Subject: XFS: performance
From: Yclept Nemo <orbisvicis@gmail.com>
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

After 3-4 years of using one XFS partition for every mount point
(/,/usr,/etc,/home,/tmp...) I started noticing a rapid performance
degradation. Subjectively I now feel my XFS partition is 5-10x slower
... while other partitions (ntfs,ext3) remain the same.
Now I just purchased a new hard-drive and I'm going to be copying all
my original files over onto a *new* XFS partition. When using mkfs.xfs
I'd like to optimize and avoid whatever it was that made my old XFS
partition slower than a snail.

in all cases, bsize=4096

Original hard drive (98GB Seagate, 39.8Gb XFS partition)
# xfs_info /dev/sdb5
meta-data=/dev/sdb5
    isize=256
    agcount=4, agsize=2595896 blks (9.9 GB)
    sectsz=512    attr=2
data=
    bsize=4096
    blocks=10383582, imaxpct=25 (39.6 GB)
    sunit=0    swidth=0 blks
naming=version 2
    bsize=4096   ascii-ci=0
log=internal
    bsize=4096
    blocks=5070, version=2 (19.8 MB)
    sectsz=512
    sunit=0 blks, lazy-count=0
realtime =none
    extsz=4096
    blocks=0, rtextents=0


New hard drive (500GB Samsung MP4, 100GB XFS partition)
# mkfs.xfs /dev/sda5
meta-data=/dev/sda5
    isize=256
    agcount=4, agsize=6553600 blks (25.0 GB)
    sectsz=512    attr=2
data=
    bsize=4096
    blocks=26214400, imaxpct=25 (100.0 GB)
    sunit=0    swidth=0 blks
naming=version 2
    bsize=4096   ascii-ci=0
log=internal
    bsize=4096
    blocks=12800, version=2 (50MB)
    sectsz=512
    sunit=0 blks, lazy-count=1
realtime=none
    extsz=4096
    blocks=0, rtextents=0

I was considering running "mkfs.xfs -d agcount=32 -i attr=2 -l
version=2,lazy-count=1,size=256m /dev/sda5".

Yes, I know that in xfs_progs 3.1.3 "-i attr=2 -l
version=2,lazy-count=1" are already default options. However I think I
should tweak the log size, blocksize, and data allocation group counts
beyond the default values and I'm looking for some recommendations or
input.

I assume mkfs.xfs automatically selects optimal values, but I *have*
space to spare for a larger log section... and perhaps my old XFS
partition became sluggish when the log section had filled up, if this
is even possible.
Similarly a larger agcount should always give better performance,
right? Some resources claim that agcount should never fall below
eight.
I'm also hesitant about reducing the blocksize from a maximum of 4096
bytes, but since XFS manages my entire file-system tree, a blocksize
of 512, 1024,or even 2048 bytes might squeeze out some extra
performance. [I assume] the performance w.r.t. blocksize is:
 . a larger blocksize dramatically increases large file performance,
but also increases space usage when dealing with small files.
. a smaller blocksize dramatically decreases performance for large
files, and somewhat increases performance for small files, while also
slightly increasing space usage with extra inodes(?)

I want to make it clear that I prefer performance over space efficiency.

Many thanks,
orbisvicis

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
