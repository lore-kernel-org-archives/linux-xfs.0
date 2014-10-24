Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E68B7F47
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 15:11:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D454304059
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 13:11:24 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id BYIpz4wqSGxDO5DU
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 13:11:24 -0700 (PDT)
Received: from [134.64.128.163] (unknown [192.65.45.20])
	by greer.hardwarefreak.com (Postfix) with ESMTPA id 8920E6C14A
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 15:11:23 -0500 (CDT)
Message-ID: <544AB289.8010005@hardwarefreak.com>
Date: Fri, 24 Oct 2014 15:11:53 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: makefs alignment issue
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Just remade a couple of filesystems and received an alignment msg I
don't recall receiving previously:

# mkfs.xfs -f -d su=64k,sw=12 /dev/s2d_a1l003
mkfs.xfs: Specified data stripe width 1536 is not the same as the volume
stripe width 2048
meta-data=/dev/s2d_a1l003        isize=256    agcount=44,
agsize=268435440 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=11709285376, imaxpct=5
         =                       sunit=16     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


/dev/s2d_a1l003 is an alias to dm-0 which is a dm-multipath device to a
LUN on hardware RAID.  The hardware geometry is 64kx 12, 768k.  AFAIK no
geometry information has been specified for these device mapper devices
(someone else's responsibility).  Though I assume dm geometry data is
the reason for mkfs.xfs throwing this alert.  I don't find anything in
/sys/devices/virtual/block/dm-0/ indicating geometry.

Any ideas how to verify what's going on here and fix it?

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
