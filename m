Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Jan 2007 05:56:16 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0ADuAqw002875
	for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 05:56:12 -0800
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1H4duw-0001C7-G7
	for linux-xfs@oss.sgi.com; Wed, 10 Jan 2007 14:55:02 +0100
Received: from p54a57214.dip.t-dialin.net ([84.165.114.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 14:55:02 +0100
Received: from christoph.bier by p54a57214.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 14:55:02 +0100
From: Christoph Bier <christoph.bier@web.de>
Subject: Mounting an external HDD fails each second time after xfs_repair
Date: Wed, 10 Jan 2007 14:35:34 +0100
Message-ID: <eo2q35$h6e$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi all,

I use 14 partitions (one extended partition; partition table see
below) on my new external 400GB HDD that is managed by LVM2 on
Debian Sarge with a vanilla kernel 2.6.19.

The first time I mounted the HDD on my desktop everything worked
fine and I was able to copy 71GB of data. I unmounted and exported
the HDD and imported and mounted it on my laptop (commands see
below) running Ubuntu Edgy. Fine, too, I was able to read the data.
I exported again and imported again on my desktop. But now mounting
fails with

	mount: /dev/mm-extern/audiovideo: can't read superblock

/var/log/syslog prints:
[Output:
http://www.zvisionwelt.de/tmpdownloads/mount-failure-syslog.output]

The funny thing is that I just wanted to have a recent syslog print
to post here and tried again to mount the HDD and now it works!
[/var/log/syslog output:
http://www.zvisionwelt.de/tmpdownloads/mount-success-syslog.output]

I didn't change anything else after the mount failure mentioned
above! BUT: Reading fails while I wanted to have a look at the files
in lost+found.
[/var/log/syslog output:
http://www.zvisionwelt.de/tmpdownloads/read-failure-syslog.output]

Yesterday I used xfs_repair after the mount failure with the result
that two directories were removed:

# xfs_repair /dev/mm-extern/audiovideo
[Output: http://www.zvisionwelt.de/tmpdownloads/xfs_repair.output]

Then mounting worked again. But this morning it failed again as I
wrote above. I could repeat the scenario: xfs_repair -> mounting
works -> unmount -> mounting again fails -> xfs_repair -> mounting
works -> unmount -> mounting again fails -> waiting for about 90
minutes (without xfs_repair) it worked again. Strange ...

Looking for answers I found this message tonight:
<news:20031210174704.20943.qmail@web12304.mail.yahoo.com> Citation
from this message: "After [xfs_repair] the file system is mountable
for one time again."

Any ideas what's going wrong here? I found
<http://oss.sgi.com/projects/xfs/faq.html#dir2>. But this should be
fixed since 2.6.17.7.

Here is some more information:

Partition table:
http://www.zvisionwelt.de/tmpdownloads/partition-table.txt

The HDD has one volume group named "mm-extern". The logical volume
is named "audiovideo".

fstab entry:
/dev/mm-extern/audiovideo /media/samsung xfs defaults,noatime   0
    0

# xfs_info /media/samsung/
meta-data=/media/samsung         isize=256    agcount=16,
agsize=6104384 blks
         =                       sectsz=512
data     =                       bsize=4096   blocks=97670144,
imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

Importing and mounting of the external HDD:
	vgscan
	vgimport mm-extern
	vgchange -a y /dev/mm-extern
	mount /media/samsung

Exporting and unmounting:
	umount /media/samsung
	vgchange -a n /dev/mm-extern
	vgexport mm-extern

# dpkg -l lvm\* | grep ^ii
ii  lvm-common     1.5.17         The Logical Volume Manager for
Linux (common
ii  lvm2           2.01.04-5      The Linux Logical Volume Manager
# dpkg -l xfsprogs | grep ^ii
ii  xfsprogs       2.6.20-1       Utilities for managing the XFS
filesystem

I successfully use xfs with LVM2 on an internal HDD.

Best,
  Christoph
-- 
+++ Typografie-Regeln: http://zvisionwelt.de/downloads.html (1.6)
