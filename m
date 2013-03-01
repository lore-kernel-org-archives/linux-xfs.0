Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38BDB7FD5
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 16:14:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 283EF8F8040
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 14:14:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uMobwCgf09SoeGqU for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 14:14:24 -0800 (PST)
Message-ID: <5131283F.8030704@sandeen.net>
Date: Fri, 01 Mar 2013 16:14:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
In-Reply-To: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
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
To: Ole Tange <tange@binf.ku.dk>
Cc: xfs@oss.sgi.com

On 2/28/13 9:22 AM, Ole Tange wrote:
> I forced a RAID online. I have done that before and xfs_repair
> normally removes the last hour of data or so, but saves everything
> else.
> 
> Today that did not work:
> 
> /usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> flfirst 232 in agf 91 too large (max = 128)
> Segmentation fault (core dumped)

FWIW, the fs in question seems to need a log replay, so 
xfs_repair -n would find it in a worse state...
I had forgotten that xfs_repair -n won't complain about
a dirty log.  Seems like it should.

But, the log is corrupt enough that it won't replay:

XFS (loop0): Mounting Filesystem
XFS (loop0): Starting recovery (logdev: internal)
ffff88036e7cd800: 58 41 47 46 00 00 00 01 00 00 00 5b 0f ff ff 00  XAGF.......[....
XFS (loop0): Internal error xfs_alloc_read_agf at line 2146 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa033d009

so really this'll require xfs_repair -L

xfs_repair -L doesn't segfault though, FWIW.

I'll try to look into the -n segfault in any case.

-Eric

> Core put in: http://dna.ku.dk/~tange/tmp/xfs_repair.core.bz2
> 
> I tried using the git-version, too, but could not get that to compile.
> 
> # uname -a
> Linux franklin 3.2.0-0.bpo.4-amd64 #1 SMP Debian 3.2.35-2~bpo60+1
> x86_64 GNU/Linux
> 
> # ./xfs_repair -V
> xfs_repair version 3.1.10
> 
> # cat /proc/cpuinfo |grep MH | wc
>      64     256    1280
> 
> # cat /proc/partitions |grep md5
>    9        5 125024550912 md5
>  259        0 107521114112 md5p1
>  259        1 17503434752 md5p2
> 
> # cat /proc/mdstat
> Personalities : [raid0] [raid6] [raid5] [raid4]
> md5 : active raid0 md1[0] md4[3] md3[2] md2[1]
>       125024550912 blocks super 1.2 512k chunks
> 
> md1 : active raid6 sdd[1] sdi[9] sdq[13] sdau[7] sdt[10] sdg[5] sdf[4] sde[2]
>       31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/8] [_UU_UUUUUU]
>       bitmap: 2/2 pages [8KB], 1048576KB chunk
> 
> md4 : active raid6 sdo[13] sdu[9] sdad[8] sdh[7] sdc[6] sds[11]
> sdap[3] sdao[2] sdk[1]
>       31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/8] [_UUUU_UUUU]
>       [>....................]  recovery =  2.1% (84781876/3907017344)
> finish=2196.4min speed=29003K/sec
>       bitmap: 2/2 pages [8KB], 1048576KB chunk
> 
> md2 : active raid6 sdac[0] sdal[9] sdak[8] sdaj[7] sdai[6] sdah[5]
> sdag[4] sdaf[3] sdae[2] sdr[10]
>       31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/10] [UUUUUUUUUU]
>       bitmap: 0/2 pages [0KB], 1048576KB chunk
> 
> md3 : active raid6 sdaq[0] sdab[9] sdaa[8] sdb[7] sdy[6] sdx[5] sdw[4]
> sdv[3] sdz[10] sdj[1]
>       31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [10/10] [UUUUUUUUUU]
>       bitmap: 0/2 pages [0KB], 1048576KB chunk
> 
> unused devices: <none>
> 
> # smartctl -a /dev/sdau|grep Model
> Device Model:     Hitachi HDS724040ALE640
> 
> # hdparm -W /dev/sdau
> /dev/sdau:
>  write-caching =  0 (off)
> 
> # dmesg
> [ 3745.914280] xfs_repair[25300]: segfault at 7f5d9282b000 ip
> 000000000042d068 sp 00007f5da3183dd0 error 4 in
> xfs_repair[400000+7f000]
> 
> 
> /Ole
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
