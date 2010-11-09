Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9C19ib152580 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 06:01:09 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EABB160BFC
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 04:02:36 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id G9OfiPUp9C9qC4BZ
	for <xfs@oss.sgi.com>; Tue, 09 Nov 2010 04:02:36 -0800 (PST)
Received: from cl-840.mbx-01.si.sixxs.net ([2001:15c0:65ff:347::2])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <mw@dermichi.com>) id 1PFmuJ-0000hi-Fs
	for xfs@oss.sgi.com; Tue, 09 Nov 2010 13:02:35 +0100
Message-ID: <4CD9385A.7070201@dermichi.com>
Date: Tue, 09 Nov 2010 13:02:34 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: vmap allocation for size 1048576 failed
References: <4CD924A6.6040200@dermichi.com> <201011091213.52728@zmi.at>
In-Reply-To: <201011091213.52728@zmi.at>
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

> You should describe the loop setup and all devices down to the disk. 
> Might be easier for the devs to help then.

-rw-r--r--   1 root root 2.0G Nov  9 13:01 portage-loopback

/dev/loop0 /mnt/portage xfs rw,noatime,attr2,delaylog,logbsize=256k,noquota
meta-data=/dev/loop0             isize=256    agcount=4, agsize=1048576 blks
         =                       sectsz=512   attr=2
data     =                       bsize=512    blocks=4194304, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=512    blocks=65536, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

/dev/sda3 / xfs
rw,swalloc,attr2,delaylog,logbsize=256k,sunit=128,swidth=384,usrquota,grpquota
meta-data=/dev/sda3              isize=256    agcount=4, agsize=90929920
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=363719632, imaxpct=10
         =                       sunit=16     swidth=48 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

/dev/sda is a 4-disk RAID-5 on a 3ware 8506-4LP Controller.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
