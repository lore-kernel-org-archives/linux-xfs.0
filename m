Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92F6E7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 10:34:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5FDE830407E
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 08:34:34 -0700 (PDT)
Received: from orion.efm.de (orion.efm.de [195.190.148.230]) by cuda.sgi.com
	with ESMTP id vkV4NfWXcTtVXOwG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 08:34:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by orion.efm.de (Postfix) with ESMTP id 8B06F1A1003E
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 17:34:30 +0200 (CEST)
Received: from orion.efm.de ([127.0.0.1])
	by localhost (orion.efm.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XmXNUmi9FRtQ for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 17:34:30 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by orion.efm.de (Postfix) with ESMTP id 710111A1003F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 17:34:30 +0200 (CEST)
Received: from orion.efm.de ([127.0.0.1])
	by localhost (orion.efm.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OSSlpC6a1PgD for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 17:34:30 +0200 (CEST)
Received: from orion.efm.de (orion.efm.de [195.190.148.230])
	by orion.efm.de (Postfix) with ESMTP id 4FD951A1003E
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 17:34:30 +0200 (CEST)
Date: Tue, 19 Aug 2014 17:34:30 +0200 (CEST)
From: Thomas Klaube <thomas@klaube.net>
Message-ID: <362338960.3862279.1408462470243.JavaMail.zimbra@klaube.net>
In-Reply-To: <159192779.3859815.1408461799560.JavaMail.zimbra@klaube.net>
Subject: xlog_write: reservation ran out. Need to up reservation
MIME-Version: 1.0
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

Hi all,

I am currently testing/benchmarking xfs on top of a bcache. When I run a heavy
IO workload (fio with 64 threads, read/write) on the device for ~30-45min I get

[ 9092.978268] XFS (bcache1): xlog_write: reservation summary:
[ 9092.978268]   trans type  = (null) (42)
[ 9092.978268]   unit res    = 18730384 bytes
[ 9092.978268]   current res = -1640 bytes
[ 9092.978268]   total reg   = 512 bytes (o/flow = 1163749592 bytes)
[ 9092.978268]   ophdrs      = 655304 (ophdr space = 7863648 bytes)
[ 9092.978268]   ophdr + reg = 1171613752 bytes
[ 9092.978268]   num regions = 2
[ 9092.978268] 
[ 9092.978272] XFS (bcache1): region[0]: LR header - 512 bytes
[ 9092.978273] XFS (bcache1): region[1]: commit - 0 bytes
[ 9092.978274] XFS (bcache1): xlog_write: reservation ran out. Need to up reservation
[ 9092.978303] XFS (bcache1): xfs_do_force_shutdown(0x2) called from line 2036 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa04433c8
[ 9092.979189] XFS (bcache1): Log I/O Error Detected.  Shutting down filesystem
[ 9092.979210] XFS (bcache1): Please umount the filesystem and rectify the problem(s)
[ 9092.979238] XFS (bcache1): xfs_do_force_shutdown(0x2) called from line 1497 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0443b57
[ 9093.183869] XFS (bcache1): xfs_log_force: error 5 returned.
[ 9093.489944] XFS (bcache1): xfs_log_force: error 5 returned.

Kernel is 3.16.1 but this also happens with Ubuntu 3.13.0.34. 
With the bcache the fio puts ~30k IOps on the filesystem. 

xfs_info:
meta-data=/dev/bcache1           isize=256    agcount=8, agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1949957886, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

umount/mount recovers the fs and the fs seems ok.

I can reproduce this behavior. Is there anything I could try to debug
this?

Regards
Thomas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
