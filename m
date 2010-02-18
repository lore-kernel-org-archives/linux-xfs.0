Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1IA5ZYb042238 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 04:05:36 -0600
Received: from srv.cyf-kr.edu.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D02713B6AA0
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 02:06:52 -0800 (PST)
Received: from srv.cyf-kr.edu.pl (srv.cyf-kr.edu.pl [149.156.2.11]) by
	cuda.sgi.com with ESMTP id sXxCkkRavar2uXIl for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2010 02:06:52 -0800 (PST)
Received: from kinga.cyf-kr.edu.pl (kinga.cyf-kr.edu.pl [149.156.2.32])
	by srv.cyf-kr.edu.pl (8.12.11.20060308/8.12.8) with ESMTP id
	o1IA47xl018688 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 11:04:07 +0100
Received: from pl.localnet (pl.cyf-kr.edu.pl [149.156.9.188])
	by kinga.cyf-kr.edu.pl (8.12.11/8.12.11) with ESMTP id o1IA6gLv014747
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 11:06:43 +0100 (MET)
From: Patryk Lason <p.lason@cyfronet.pl>
Subject: XFS + LVM + quota = disk quota exceeded
Date: Thu, 18 Feb 2010 11:06:36 +0100
MIME-Version: 1.0
Message-Id: <201002181106.36672.p.lason@cyfronet.pl>
Reply-To: p.lason@cyfronet.pl
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

Hello,

I'm not able to touch a file on an XFS filesystem with quotas created on an LVM 
volume.
Even if I set limits to 10TB on 2TB device.

OS: CentOS release 5.4 (Final)
Kernel: Linux nfs 2.6.18-164.11.1.el5 #1 SMP Wed Jan 20 07:32:21 EST 2010 
x86_64 x86_64 x86_64 GNU/Linux
Path to xfs: /lib/modules/2.6.18-164.11.1.el5/kernel/fs/xfs/xfs.ko

Device: /dev/mapper/lvm--people-people on /people type xfs 
(rw,noatime,usrquota,grpquota)

  --- Volume group ---
  VG Name               lvm-people
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               2.00 TB
  PE Size               4.00 MB
  Total PE              524031
  Alloc PE / Size       524031 / 2.00 TB
  Free  PE / Size       0 / 0
  VG UUID               XYOrZr-6Pqv-JPKP-cuKU-xcbO-vfet-rbRgkO

  --- Logical volume ---
  LV Name                /dev/lvm-people/people
  VG Name                lvm-people
  LV UUID                X766hc-NkTy-TGFb-3FJE-syOg-uwwk-LrbYyc
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                2.00 TB
  Current LE             524031
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:12

# xfs_info /people/
meta-data=/dev/mapper/lvm--people-people isize=256    agcount=32, 
agsize=16768992 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=536607744, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


>From xfs_quota:
Disk quotas for User xxx (1111)
Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted 
on
/dev/mapper/lvm--people-people
                        742740 10737418240 10737418240   00 [--------] /people


# su - xxx
$ pwd
/people/xxx
$ touch a
touch: cannot touch `a': Disk quota exceeded


What may be wrong and where?

Regards,
Patryk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
