Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5ULgTmW260957 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 16:42:29 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AED2A44806
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 14:42:28 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id DZvsbJltIKaaxhPJ for
	<xfs@oss.sgi.com>; Thu, 30 Jun 2011 14:42:28 -0700 (PDT)
Received: from webmail.sonic.net (d.webmail.sonic.net [69.12.208.81])
	by a.mail.sonic.net (8.13.8.Beta0-Sonic/8.13.7) with ESMTP id
	p5ULgRnN000598 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 14:42:27 -0700
MIME-Version: 1.0
Message-ID: <47455.1309470147@sonic.net>
Date: Thu, 30 Jun 2011 14:42:27 -0700
Subject: xfs_growfs doesn't resize
From: kkeller@sonic.net
Reply-To: kkeller@sonic.net
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

Hello kind XFS folks,

I am having a strange issue with xfs_growfs, and before I attempt to do
something potentially unsafe, I thought I would check in with the list
for advice.

Our fileserver had an ~11TB xfs filesystem hosted under linux lvm.  I
recently added more disks to create a new 9TB container, and used the
lvm tools to add the container to the existing volume group.  When I
went to xfs_growfs the filesystem, I had the first issue that this user
had, where the metadata was reported, but there was no message about
the new number of blocks:

http://oss.sgi.com/archives/xfs/2008-01/msg00085.html

Fortunately, I have not yet seen the other symptoms that the OP saw: I
can still read from and write to the original filesystem.  But the
filesystem size hasn't changed, and I'm not experienced enough to
interpret the xfs_info output properly.

I read through that thread (and others), but none seemed specific to my
issue.  Plus, since my filesystem still seems healthy, I'm hoping that
there's a graceful way to resolve the issue and add the new disk space.

Here's some of the information I've seen asked for in the past.  I
apologize for it being fairly long.

/proc/partitions:

major minor  #blocks  name

   8     0  244129792 sda
   8     1     104391 sda1
   8     2    8385930 sda2
   8     3   21205800 sda3
   8     4          1 sda4
   8     5   30876898 sda5
   8     6   51761398 sda6
   8     7   20555136 sda7
   8     8    8233281 sda8
   8     9   20603331 sda9
   8    16 11718684672 sdb
   8    17 11718684638 sdb1
 253     1 21484244992 dm-1
   8    48 9765570560 sdd
   8    49 9765568085 sdd1


sdb1 is the original member of the volume group.  sdd1 is the new PV.  I
believe dm-1 is the LV where the volume group is hosted (and all the LVM
tools report a 20TB logical volume).


# lvdisplay 
  --- Logical volume ---
  LV Name                /dev/saharaVG/saharaLV
  VG Name                saharaVG
  LV UUID                DjacPa-p9mk-mBmv-69c2-dmXF-LfxQ-wsRUOD
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                20.01 TB
  Current LE             5245177
  Segments               2
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:1

# uname -a
Linux sahara.xxx 2.6.18-128.1.6.el5 #1 SMP Wed Apr 1 09:10:25 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux

Yes, it's not a completely current kernel.  This box is running CentOS 5
with some yum updates.

# xfs_growfs -V
xfs_growfs version 2.9.4

This xfs_info is from after the xfs_growfs attempt.  I regret that I don't have one from before; I was actually thinking of it, but the resize went so smoothly on my test machine (and went fine in the past as well on other platforms) that I didn't give it much thought till it was too late.

# xfs_info /export/
meta-data=/dev/mapper/saharaVG-saharaLV isize=256    agcount=32, agsize=91552192 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=2929670144,
imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

I saw requests to run xfs_db, but I don't want to mess up the syntax, even if -r should be safe.

Thanks for any help you can provide!

--keith


-- 
kkeller@sonic.net


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
