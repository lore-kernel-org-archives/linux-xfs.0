Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Sep 2006 16:34:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8PNYZaG017329
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 16:34:36 -0700
Received: from tricca.tcs.tulane.edu (tricca.tcs.tulane.edu [129.81.224.27])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6878045F68E
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 15:12:07 -0700 (PDT)
Message-ID: <45185424.2030707@tulane.edu>
Date: Mon, 25 Sep 2006 17:11:48 -0500
From: Rene Salmon <rsalmon@tulane.edu>
MIME-Version: 1.0
Subject: LVM and XFS cannot set blocksize on block device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Rene Salmon <rsalmon@tulane.edu>

Hi,


I am trying to create an xfs file system on and LVM logical volume.
the actual physical drive has blocks or sectors of 4096.

when I try to make the xfs file system on top of LVM I get this message:

helix-priv:~ # mkfs.xfs -f /dev/vg_u00/lv_u00
mkfs.xfs: warning - cannot set blocksize on block device 
/dev/vg_u00/lv_u00: Invalid argument
Warning: the data subvolume sector size 512 is less than the sector size
reported by the device (4096).
meta-data=/dev/vg_u00/lv_u00     isize=256    agcount=32, 
agsize=11489280 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=367656960, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
          =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
helix-priv:~ #





any ideas?

Thanks
Rene



-- 
-
--
         Rene Salmon
         Tulane University
         Center for Computational Science
         http://www.ccs.tulane.edu
	rsalmon@tulane.edu
         Tel 504-862-8393
	Tel 504-988-8552
         Fax 504-862-8392
