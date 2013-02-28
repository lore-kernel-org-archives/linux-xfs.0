Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0BBCE7F7D
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 09:22:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9600FAC002
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 07:22:30 -0800 (PST)
Received: from mail-pb0-f43.google.com (mail-pb0-f43.google.com
	[209.85.160.43]) by cuda.sgi.com with ESMTP id ks99ggTTTlCqknPu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Feb 2013 07:22:28 -0800 (PST)
Received: by mail-pb0-f43.google.com with SMTP id md12so1136590pbc.30
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 07:22:28 -0800 (PST)
MIME-Version: 1.0
From: Ole Tange <tange@binf.ku.dk>
Date: Thu, 28 Feb 2013 16:22:08 +0100
Message-ID: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
Subject: xfs_repair segfaults
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

I forced a RAID online. I have done that before and xfs_repair
normally removes the last hour of data or so, but saves everything
else.

Today that did not work:

/usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
flfirst 232 in agf 91 too large (max = 128)
Segmentation fault (core dumped)

Core put in: http://dna.ku.dk/~tange/tmp/xfs_repair.core.bz2

I tried using the git-version, too, but could not get that to compile.

# uname -a
Linux franklin 3.2.0-0.bpo.4-amd64 #1 SMP Debian 3.2.35-2~bpo60+1
x86_64 GNU/Linux

# ./xfs_repair -V
xfs_repair version 3.1.10

# cat /proc/cpuinfo |grep MH | wc
     64     256    1280

# cat /proc/partitions |grep md5
   9        5 125024550912 md5
 259        0 107521114112 md5p1
 259        1 17503434752 md5p2

# cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md5 : active raid0 md1[0] md4[3] md3[2] md2[1]
      125024550912 blocks super 1.2 512k chunks

md1 : active raid6 sdd[1] sdi[9] sdq[13] sdau[7] sdt[10] sdg[5] sdf[4] sde[2]
      31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/8] [_UU_UUUUUU]
      bitmap: 2/2 pages [8KB], 1048576KB chunk

md4 : active raid6 sdo[13] sdu[9] sdad[8] sdh[7] sdc[6] sds[11]
sdap[3] sdao[2] sdk[1]
      31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/8] [_UUUU_UUUU]
      [>....................]  recovery =  2.1% (84781876/3907017344)
finish=2196.4min speed=29003K/sec
      bitmap: 2/2 pages [8KB], 1048576KB chunk

md2 : active raid6 sdac[0] sdal[9] sdak[8] sdaj[7] sdai[6] sdah[5]
sdag[4] sdaf[3] sdae[2] sdr[10]
      31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/10] [UUUUUUUUUU]
      bitmap: 0/2 pages [0KB], 1048576KB chunk

md3 : active raid6 sdaq[0] sdab[9] sdaa[8] sdb[7] sdy[6] sdx[5] sdw[4]
sdv[3] sdz[10] sdj[1]
      31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/10] [UUUUUUUUUU]
      bitmap: 0/2 pages [0KB], 1048576KB chunk

unused devices: <none>

# smartctl -a /dev/sdau|grep Model
Device Model:     Hitachi HDS724040ALE640

# hdparm -W /dev/sdau
/dev/sdau:
 write-caching =  0 (off)

# dmesg
[ 3745.914280] xfs_repair[25300]: segfault at 7f5d9282b000 ip
000000000042d068 sp 00007f5da3183dd0 error 4 in
xfs_repair[400000+7f000]


/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
