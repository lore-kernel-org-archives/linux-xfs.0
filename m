Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4CHR4Cl197909 for <xfs@oss.sgi.com>; Sat, 12 May 2012 12:27:04 -0500
Received: from mail.linuxsystems.it (mail.linuxsystems.it [2.119.245.41]) by
	cuda.sgi.com with ESMTP id 7rxbXxhNPfkNraoo for
	<xfs@oss.sgi.com>; Sat, 12 May 2012 10:27:01 -0700 (PDT)
Received: from [192.168.2.4] (unknown [192.168.2.4])
	by mail.linuxsystems.it (Postfix) with ESMTPSA id 7EA5B3683
	for <xfs@oss.sgi.com>; Sat, 12 May 2012 19:27:00 +0200 (CEST)
Message-ID: <4FAE9DBF.1090505@linuxsystems.it>
Date: Sat, 12 May 2012 19:28:31 +0200
From: =?ISO-8859-15?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
MIME-Version: 1.0
Subject: How to recover data from an xfs partition
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,
I had a (software) problem with my xen server ended ruining my domU =

partitions. I already recovered all my ext4 partitions using fsck.ext4, =

but I can't recover the only xfs partition I have :(

When I try to mount I get:

root@firewall:~# mount -o loop,offset=3D$((97280*1024)) -t xfs =

/srv/xen/webserver.img /mnt
mount: Structure needs cleaning



While when trying to fsck I get:

root@firewall:~# xfs_check /dev/loop51
xfs_check: /dev/loop51 is not a valid XFS filesystem (unexpected SB =

magic number 0xeb639010)
xfs_check: size check failed
xfs_check: WARNING - filesystem uses v1 dirs,limited functionality provided.
cache_node_purge: refcount was 1, not zero (node=3D0x11f0820)
xfs_check: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=3D0x11f0970)
xfs_check: cannot read realtime bitmap inode (22)
xfs_check: size check failed
xfs_check: WARNING - filesystem uses v1 dirs,limited functionality provided.
bad superblock magic number eb639010, giving up



xfs_check:

root@firewall:~# xfs_check /dev/loop51
xfs_check: /dev/loop51 is not a valid XFS filesystem (unexpected SB =

magic number 0xeb639010)
xfs_check: size check failed
xfs_check: WARNING - filesystem uses v1 dirs,limited functionality provided.
cache_node_purge: refcount was 1, not zero (node=3D0x22f1820)
xfs_check: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=3D0x22f1970)
xfs_check: cannot read realtime bitmap inode (22)
xfs_check: size check failed
xfs_check: WARNING - filesystem uses v1 dirs,limited functionality provided.
bad superblock magic number eb639010, giving up




xfs_repair:

root@firewall:~# xfs_repair /dev/loop51
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
...........................................................................=
.....found =

candidate secondary superblock...
unable to verify superblock, continuing...
.............
[...]
....................................Sorry, could not find valid =

secondary superblock
Exiting now.


How can I restore my data? I cannot believe I had no problems restoring =

*15* ext4 partitions while I can't restore the only xfs partition I have :(

Hope you can help,
Niccol=F2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
