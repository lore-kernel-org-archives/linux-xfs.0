Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8N7LaQn112615 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 02:21:36 -0500
Received: from phd-imap.ethz.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96DD894B90
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 00:22:30 -0700 (PDT)
Received: from phd-imap.ethz.ch (phd-imap.ethz.ch [129.132.80.51]) by
	cuda.sgi.com with ESMTP id aOx8gmWYrG8lobir for
	<xfs@oss.sgi.com>; Thu, 23 Sep 2010 00:22:30 -0700 (PDT)
Subject: XFS errors on large Infiniband fileserver setup
MIME-Version: 1.0
Date: Thu, 23 Sep 2010 09:22:29 +0200
From: Christian Herzog <horeizo@phys.ethz.ch>
Message-ID: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, isg@phys.ethz.ch


Dear all,

we (Physics Dept. at ETH Zurich) are trying to set up a large file 
server combo (two disk backends connected to a frontend by Infiniband, 
all running Ubuntu 10.04) and keep getting XFS internal error 
xfs_da_do_buf(2) messages when copying large amounts of data, resulting 
in 'structure needs cleaning' warnings. We have tried a lot of 
different kernels, iSCSI implementations, LVM configurations, whatnot, 
but these errors persist. The setup right now looks like this:

2 disk backends, each: Quad-Xeon X5550, 12G of RAM, 28T HW SATA-RAID6 
sliced into 2T chunks by LVM2 and exported via tgt 1.0.0-2, Ubuntu 
10.04 LTS, connected via Mellanox MHRH19B-XTR Infiniband + ISER to

1 frontend Octo-Xeon E5520, 12G of RAM, open-iscsi 2.0.871 initiator, 
Ubuntu 10.04 LTS. LMV2 stitches together the 2T-iSCSI-LUNs and provides 
a 10T test XFS filesystem

right now we're performing stress tests and when copying large amounts 
of data to the XFS filesystem, at some point we get

Filesystem "dm-3": XFS internal error xfs_da_do_buf(2) at line 2113 of 
file /home/kernel-ppa/mainline/build/fs/xfs/xfs_da_btree.c.  Caller 
0xffffffffa0299a1a
This can be provoked by running a 'du' or 'find' while writing the 
data.

on the frontend and XFS reports 'structure needs cleaning'. The 
following modifications have been suggested and we're working on them 
right now:

- try w/o ISER (direct IB over TCP)
- try an XFS filesystem < 2T
- try RHEL or SLES (will take more time)

We already had to change the I/O scheduler from Deadline to CFQ in 
order to get it up and running at all and also tried to change the 
kernel from stock LTS to 2.6.34-020634-generic, but we still get the FS 
errors.


root@phd-san-gw1:~# xfs_info /export/astrodata
meta-data=/dev/mapper/vgastro-lvastro isize=256    agcount=10, 
agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2684354550, 
imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, 
lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


we're slowly but surely running out of ideas here. Needless to say the 
system should have been deployed quite some time ago. Any help would be 
greatly appreciated. We're also happy to provide any further 
information that might be useful.

thanks a lot and kind regards,
-Christian



--
Dr. Christian Herzog <herzog@phys.ethz.ch>  support: +41 44 633 26 68
IT Services Group, HPT D 17                   voice: +41 44 633 39 50
Department of Physics, ETH Zurich
8093 Zurich, Switzerland                     http://nic.phys.ethz.ch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
