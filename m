Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86IlCn5098397 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 13:47:12 -0500
Received: from mailhost.ldc.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 420B7198FE9C
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 11:47:10 -0700 (PDT)
Received: from mailhost.ldc.fr (mailhost.ldc.fr [86.65.205.244]) by
	cuda.sgi.com with ESMTP id 49i0hSXqwqtXEeLH for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2011 11:47:10 -0700 (PDT)
In-Reply-To: <OF62081B23.59A4BF92-ONC1257903.003AB613-C1257903.003D9151@LocalDomain>
References: <OF62081B23.59A4BF92-ONC1257903.003AB613-C1257903.003D9151@LocalDomain>
Subject: XFS frozen when moving file from one project quota to another
Message-ID: <OFA406DB9E.729FBB28-ONC1257903.006155C9-C1257903.00672FA2@grpldc.com>
From: Boris.SANEGRE@agis-sa.fr
Date: Tue, 6 Sep 2011 20:47:04 +0200
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, debian-user@lists.debian.org
Cc: debian-user-french@lists.debian.org, Salokine Terata <salokine.terata@free.fr>


Hi,

I'm under Debian/Linux 5.0.8. I'm trying to move a file from one project
quota to another one.
XFS freeze.

I have tested on 2 same servers -> same bug.

Based on my article on http://wiki.debian.org/fr/Quota (in french)


Example:

Creating FS (1):
	dd if=3D/dev/zero of=3D/root/file.xfs bs=3D1M count=3D100
	mkfs.xfs /root/file.xfs
	mkdir /media/mount.xfs
	mount -o loop,prjquota /root/file.xfs /media/mount.xfs

Creating directories:
	mkdir /media/mount.xfs/dirA /media/mount.xfs/dirB

Declaring project:
	echo 1:/media/mount.xfs/dirA >> /etc/projects
	echo 2:/media/mount.xfs/dirB >> /etc/projects
	echo prjDirA:1 >> /etc/projid
	echo prjDirB:2 >> /etc/projid

Setting up project:
	xfs_quota -x -c 'project -s prjDirA' /media/mount.xfs
	xfs_quota -x -c 'project -s prjDirB' /media/mount.xfs

Configuring project:
	xfs_quota -x -c 'limit -p bhard=3D20m prjDirA' /media/mount.xfs
	xfs_quota -x -c 'limit -p bhard=3D20m prjDirB' /media/mount.xfs

Control:
	xfs_quota -x -c report /media/mount.xfs
		Project quota on /media/mount.xfs (/dev/loop0)
		                               Blocks
		Project ID       Used       Soft       Hard    Warn/Grace
		---------- --------------------------------------------------
		prjDirA             0          0      20480     00 [--------]
		prjDirB             0          0      20480     00 [--------]

Create basic file (2)
	dd if=3D/dev/zero of=3D/media/mount.xfs/dirA/5Mo.file bs=3D1M count=3D5

Moving ... bash don't return. i can't break process. XFS crash and need to
restart my serveur via button.
	mv /media/mount.xfs/dirA/5Mo.file /media/mount.xfs/dirB/
	^C^C^C

Some informations:
	ps aux | grep mv
		root      4275  0.0  0.0  13952   784 pts/0    D+   19:32
0:00 mv /media/mount.xfs/dirA/5Mo.file /media/mount.xfs/dirB/

	lsof | grep 4275
		mv        4275     root  cwd       DIR                8,1
4096     229377 /root
		mv        4275     root  rtd       DIR                8,1
4096          2 /
		mv        4275     root  txt       REG                8,1
85320      41031 /bin/mv
		mv        4275     root  mem       REG                8,1
17424      24600 /lib/libattr.so.1.1.0
		mv        4275     root  mem       REG                8,1
14616      25939 /lib/libdl-2.7.so
		mv        4275     root  mem       REG                8,1
1375536      25934 /lib/libc-2.7.so
		mv        4275     root  mem       REG                8,1
29360      25917 /lib/libacl.so.1.1.0
		mv        4275     root  mem       REG                8,1
109464      25893 /lib/libselinux.so.1
		mv        4275     root  mem       REG                8,1
119288      25907 /lib/ld-2.7.so
		mv        4275     root  mem       REG                8,5
1771376     180831 /usr/lib/locale/locale-archive
		mv        4275     root    0u      CHR              136,0
2 /dev/pts/0
		mv        4275     root    1u      CHR              136,0
2 /dev/pts/0
		mv        4275     root    2u      CHR              136,0
2 /dev/pts/0
		mv        4275     root    3r      REG                7,0
5242880        133 /media/mount.xfs/dirA/5Mo.file



Information about my server:
	uname -a: Linux lnx043002 2.6.26-2-amd64 #1 SMP Tue Jan 25 05:59:43
UTC 2011 x86_64 GNU/Linux

	OS: Debian 5.0.8

	dpkg -l | grep samba
		ii  libcrypt-smbhash-perl                0.12-2
generate LM/NT hash of a password for samba
		ii  samba                                2:3.5.6~dfsg-3~bpo50+1
SMB/CIFS file, print, and login server for Unix
		ii  samba-common                         2:3.5.6~dfsg-3~bpo50+1
common files used by both the Samba server and client
		ii  samba-common-bin                     2:3.5.6~dfsg-3~bpo50+1
common files used by both the Samba server and client

	dpkg -l | grep xfs
		ii  x11-xfs-utils                        7.3+1
X font server utilities
		ii  xfsdump                              2.2.48-1
Administrative utilities for the XFS filesystem
		ii  xfsprogs                             2.9.8-1lenny1
Utilities for managing the XFS filesystem


	dpkg -l | grep lvm
		ii  lvm2                                 2.02.39-8
The Linux Logical Volume Manager



(1) Tested also on LVM+DrDB
(2) Tested also with 108GB of user's data

Best regard
Boris San=E8gre.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
