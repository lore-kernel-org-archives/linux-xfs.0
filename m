Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0MHlwEc133250 for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 11:47:58 -0600
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 412561C7009F
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 09:48:58 -0800 (PST)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id rXsVq7t3aNrAWPNA for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2010 09:48:58 -0800 (PST)
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id E8B484B025A
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 18:48:52 +0100 (CET)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 0CBB24B0246
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 18:48:49 +0100 (CET)
Date: Fri, 22 Jan 2010 18:54:19 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: nfs performance delta between filesystems
Message-ID: <20100122185419.63ae6430@harpe.intellique.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Here is an interesting mystery to solve : XFS is always much faster
locally than all other FSs, but quite slower through NFS.

I'm benchmarking a RAID-10 setup with various filesystems, ext3, reiser
(3.6), jfs and xfs. I'm strictly and only interested in continuous
sequential write (data recording) through NFS (basic 1G Eth), so I'm
benchmarking with =


dd if=3D/dev/zero of=3D/mnt/whatever/file bs=3D1M

following the throughput with iostat.

Setup : linux 2.6.27.21, software RAID 10 (64K stripe), 1GB RAM, 64
bits kernel, 4 Savvio 500GB disks, Phenom II, Intel Pro1000 network.

All the following tests have been run several times each, to even
results.

Locally, xfs mounted this way =


/dev/md2 on /mnt/raid type xfs (rw,noatime,nobarrier)

is wayyyyy better than all other filesystems :

~# dd if=3D/dev/zero of=3D/mnt/raid/testdd bs=3D1M count=3D4096
4096+0 records in
4096+0 records out
4294967296 bytes (4.3 GB) copied, 23.0655 s, 186 MB/s

ext3, jfs and reiser score the same around 150 MB/s.

I'm exporting the mountpoint through NFS :

/mnt/raid    *(fsid=3D0,rw,async,no_root_squash,no_subtree_check)

And mount with no options (or just "tcp") on the client. Then the
results are quite different. XFS gives a bit less than 90 MB/s (not
bad):

 ~$ sudo dd if=3D/dev/zero of=3D/mnt/temp/testnfsdd1 bs=3D1M count=3D2048
2048+0 enregistrements lus
2048+0 enregistrements =E9crits
2147483648 octets (2,1 GB) copi=E9s, 24,1755 s, 88,8 MB/s

But... reiserfs gives ~ 92 MB/s, and ext3 95 MB/s. Results are
consistently better with both through NFS, while they're constantly
much worse locally... How come???

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
