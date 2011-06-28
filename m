Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SF34tP232788 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 10:03:04 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0588A1E536D3
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:03:03 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id cSA83FE7ekpyKOkJ
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:03:03 -0700 (PDT)
Received: by wyh22 with SMTP id 22so231820wyh.26
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:03:03 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 28 Jun 2011 11:03:02 -0400
Message-ID: <BANLkTimsEAyCF52hzx0ay4S+6TkscpKXoQ@mail.gmail.com>
Subject: XFS file loss - 2.6.38.5, FC RAID
From: Paul Anderson <pha@umich.edu>
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
To: xfs-oss <xfs@oss.sgi.com>

I'm sending this error report as an informational point - I'm not sure
much can be done about it at the present time.

We had a machine crash Sunday night (June 26) around 8PM - the
hardware failed due to a Sun J4400 chassis fault.  The XFS file loss
noted in this report was not on this chassis.

On power cycle and subsequent reboot, one of our home directory
volumes, a pair of 40TiByte Promise RAID6 fiber channel SAN array
together in a single LVM, lost many files.

File loss is characterized by numerous files now with length of zero.
I lost files that I know were last changed on Friday (June 24), more
than 2 days before the crash.

Kernel is 2.6.38.5, userland is Ubuntu 10.04, server hardware is a 24
core Dell R900 w/128GiBytes RAM, an LSIFC949E fiber channel card, a
bunch of Dell PERC 6 RAID cards, and a lot of direct attach SAS JBOD
cabinets (mostly J4400, but a few Dell MD1000's).  The boot drive is a
pair of matched 1TiByte drives in a HW RAID-1 config.

The Promise RAID6 SAN unit where the files were lost is battery
backed, and reports no errors.  The filesystem showed no signs of
distress prior to this.  The filesystem was less than 4 weeks old.

Here's the fstab mount options:

/dev/wonderlandhomet/homet    /homet    xfs
inode64,logbufs=8,noatime        0       0

xfs_info shows:

root@wonderland:~# xfs_info /homet
meta-data=/dev/mapper/wonderlandhomet-homet isize=256    agcount=81,
agsize=268435328 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=21484355584, imaxpct=1
         =                       sunit=128    swidth=2816 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The dmesg log shows no signs of hardware or kernel software problems
up to the point where the directly attached SAS card reported faults
for the cabinet.

The vm tuning parameters are defaults (yes, I know this is bad):

root@louie:/proc/sys/vm# cat dirty_background_bytes
0
root@louie:/proc/sys/vm# cat dirty_background_ratio
10
root@louie:/proc/sys/vm# cat dirty_bytes
0
root@louie:/proc/sys/vm# cat dirty_expire_centisecs
3000
root@louie:/proc/sys/vm# cat dirty_ratio
40
root@louie:/proc/sys/vm# cat dirty_writeback_centisecs
500

My main question is: what specific action can I take to minimize the
likelihood of this happening again?  As far as I know, the dirty pages
should expire and be flushed to the FC array (2 days?  should be
enough), and the FC array itself is stable.

The machine was moderately busy, but far from overwhelmingly so.

Feedback welcome...

Thanks,

Paul Anderson
Center for Statistical Genetics
University of Michigan, Ann Arbor

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
