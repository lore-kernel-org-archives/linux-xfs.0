Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0NAMGIs184029 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 04:22:17 -0600
Received: from pastinake.doctronic.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1CFE18559F0
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 02:21:31 -0800 (PST)
Received: from pastinake.doctronic.de (pastinake.doctronic.de [217.6.226.210])
	by cuda.sgi.com with ESMTP id Km1rUIBGAGUABCCu for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2009 02:21:31 -0800 (PST)
Received: from ZWERG.DOCTRONIC.LOCAL (zwerg.doctronic.de [192.168.4.131])
	by pastinake.doctronic.de (8.13.1/8.13.1) with ESMTP id n0NALUU4013696
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 11:21:31 +0100
Received: from co by ZWERG.DOCTRONIC.LOCAL with local (Exim 4.63)
	(envelope-from <oberscheid@doctronic.de>) id 1LQJAI-0002Aa-Sm
	for xfs@oss.sgi.com; Fri, 23 Jan 2009 11:21:30 +0100
Date: Fri, 23 Jan 2009 11:21:30 +0100
From: Carsten Oberscheid <oberscheid@doctronic.de>
Subject: Strange fragmentation in nearly empty filesystem
Message-ID: <20090123102130.GB8012@doctronic.de>
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

Hi there,

I am experiencing my XFS filesystem degrading over time in quite a
strange and annoying way. Googling "XFS fragmenation" tells me either
that this does not happen or to use xfs_fsr, which doesn't really help
me anymore -- see below. I'd appreciate any help on this.

Background: I am using two VMware virtual machines on my Linux
desktop. These virtual machines store images of their main memory in
.vmem files, which are about half a gigabyte in size for each of my
VMs. The .vmem files are created when starting the VM, written when
suspending it and read when resuming. I prefer suspendig and resuming
over shutting down and booting again, so with my VMs these files can
have a lifetime of several weeks.

On Ubuntu's default ext3 filesystem the vmem files showed heavy
fragmentation problems right from the start, so I switched over to
XFS. At first everything seemed fine, but after some time (about two
weeks, in the beginning) it took longer and longer to suspend the VM
in the evening and to resume it in the morning. 'sudo filefrag *'
showed heavy fragmentation (up to 50.000 extents and more) of the
.vmem files. Reading a 512M file thus fragmented takes several
minutes, and writing it takes at least twice as long.

For some time, 'sudo xfs_fsr *.vmem' used to fix this (back down to
one single extent). Replacing the files by a copy of themselves or
rebooting the VM (thus creating new .vmem files) fixed fragmentation
as well.

After some months I observed that the time it took to reach a
perceptible level of fragmentation (slow reading/writing) got shorter
and shorter. Instead of, say, two weeks it now took only a few days to
reach 10.000 extents or more.

Again some months later, xfs_fsr was unable to get the files back to
one single extent, and even new files started with at least a handful
of extents right away.

Today, a formerly new .vmem file is already after the first VM suspend
badly fragmented (about 20.000 extents) and accordingly slow to read
and write. Suspending the VM can take 15 minutes or more.

Some more facts:

 -  The filesystem is nearly empty (8% of about 500GB used, see
    below).

 -  System information, xfs_info output appended below.

 -  Other large files created in this filesystem show fragmentation
    from start as well, but they are not rewritten as often as the
    .vmem files, so they don't deteriorate as much and as quickly. So
    I don't think this to be a VMware specific problem. I think it
    just shows more obviously there.

 -  A few weeks ago, I did a fresh mkfs.xfs on the filesystem and
    restored the contents from a tar backup -- observing the same
    heavy fragmentation as before. Perhaps this did not really
    create a fresh filesystem structure?

What is happening here? I thought fragmentation would become serious
only on nearly full filesystems when there's not enough continuous
free space left. Or can free space also be fragmented over time by
some patterns of usage? Are there any XFS parameters I could try to
make this more robust against fragmentation?

Thanks in advance


Carsten Oberscheid



Running Ubuntu 8.10 with current XFS package (where can I find the XFS
version?)

[co@tangchai]~ uname -a
Linux tangchai 2.6.27-7-generic #1 SMP Tue Nov 4 19:33:06 UTC 2008 x86_64 GNU/Linux

[co@tangchai]~ df
Filesystem           1K-blocks      Used Available Use% Mounted on
...
/dev/sdb5            488252896  40028724 448224172   9% /home

[co@tangchai]~ xfs_info /home
meta-data=/dev/sdb5              isize=256    agcount=4, agsize=30523998 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=122095992, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

[co@tangchai]~ cat /etc/mtab
...
/dev/sdb5 /home xfs rw,inode64 0 0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
