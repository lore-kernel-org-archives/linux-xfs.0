Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DEFEA7F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 09:06:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F46CAC00A
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 07:06:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id i7v5GDgXm0wHB55E for <xfs@oss.sgi.com>;
	Wed, 14 May 2014 07:06:17 -0700 (PDT)
Message-ID: <5373785D.6000907@sandeen.net>
Date: Wed, 14 May 2014 09:06:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db dont work on blocksize 4096?
References: <e6b0d925a9409122a92d4e14922a26fd@zbfmail.de>
In-Reply-To: <e6b0d925a9409122a92d4e14922a26fd@zbfmail.de>
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
To: weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

On 5/14/14, 7:47 AM, Marko Weber|8000 wrote:
> 
> hello,
> does xfs_db not work on blocksize 4096 ?
> 
> i get this:
> 
> bunka distfiles # xfs_db -r /dev/sda4
> xfs_db: error - read only 0 of 512 bytes
> cache_node_purge: refcount was 1, not zero (node=0x686530)
> xfs_db: cannot read root inode (117)
> cache_node_purge: refcount was 1, not zero (node=0x688810)
> xfs_db: cannot read realtime bitmap inode (117)
> xfs_db: error - read only 0 of 512 bytes
> xfs_db> quit
> 
> any hints, ideas tipps?
> 
> thank you
> 
> marko
> 

What version of xfsprogs?  Works here:


# insmod drivers/scsi/scsi_debug.ko dev_size_mb=32 sector_size=4096
# blockdev --getpbsz --getss /dev/sdd
4096
4096
# mkfs.xfs /dev/sdd
meta-data=/dev/sdd               isize=256    agcount=2, agsize=4096 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=8192, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=1605, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# xfs_db /dev/sdd
xfs_db> sb 0
xfs_db> p magicnum
magicnum = 0x58465342
xfs_db> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
